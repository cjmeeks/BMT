module Util exposing (..)

import Model exposing (Model, Item, Msg)
import Array exposing (..)
import Json.Decode as Decode exposing (string, int, Decoder)
import Json.Encode as Encode exposing (object, encode, string, Value)
import String exposing (..)
import Http as HT
import ISO8601 as Date exposing (..)


init : ( Model, Cmd Msg )
init =
    ( { firmware = ""
      , meid = ""
      , seqNum = ""
      , timeZone = ""
      , temp = ""
      , weight = ""
      , battery = ""
      , signal = ""
      , messageType = ""
      , x = "0"
      , y = "0"
      , z = "0"
      , highT = False
      , zeroW = False
      , lowB = False
      , lowS = False
      , year = Nothing
      , day = Nothing
      , month = Nothing
      , theHour = Nothing
      , theMinute = Nothing
      , dateString = Err "error"
      , unixTime = 0
      , responseData = ""
      , responseNumber = ""
      , failData = Nothing
      }
    , Cmd.none
    )


splitTime : String -> Model -> Model
splitTime time model =
    let
        listTime =
            Array.fromList (split ":" time)
    in
        { model
            | theHour = Array.get 0 listTime
            , theMinute = Array.get 1 listTime
        }


splitDate : String -> Model -> Model
splitDate date model =
    let
        listDate =
            Array.fromList (split "/" date)
    in
        { model
            | year = Array.get 2 listDate
            , day = Array.get 1 listDate
            , month = Array.get 0 listDate
        }


getDateString : Model -> String
getDateString model =
    String.concat
        [ case model.year of
            Just year ->
                year

            Nothing ->
                "Year"
        , "-"
        , case model.month of
            Just month ->
                month

            Nothing ->
                "Month"
        , "-"
        , case model.day of
            Just day ->
                day

            Nothing ->
                "Day"
        , "T"
        , case model.theHour of
            Just theHour ->
                theHour

            Nothing ->
                "Hour"
        , ":"
        , case model.theMinute of
            Just theMinute ->
                theMinute

            Nothing ->
                "Minute"
        , ":"
        , "00.00"
        , model.timeZone
        ]


getjsonMessage : Model -> Encode.Value
getjsonMessage model =
    Encode.object
        [ ( "message", Encode.string (sendString model) )
        ]



--requests


sendString : Model -> String
sendString model =
    String.concat
        [ model.firmware
        , ","
        , model.messageType
        , ","
        , model.meid
        , ","
        , model.seqNum
        , ";"
        , Basics.toString model.unixTime
        , ","
        , model.timeZone
        , ","
        , model.temp
        , ","
        , model.weight
        , ","
        , model.battery
        , ","
        , model.signal
        , ","
        , ","
        , model.x
        , ","
        , model.y
        , ","
        , model.z
        ]



--a test post request


postRequest : String -> String -> Cmd Msg
postRequest username password =
    let
        url =
            "http://localhost:8081"

        body =
            HT.multipartBody
                [ HT.stringPart "user" username
                , HT.stringPart "password" password
                ]
        request =
            HT.post url body postDecoder
    in
      HT.send Model.POST request



--submits the message in proper format to the server


submitData : Model -> Cmd Msg
submitData model =
    let
        url =
            "http://localhost:8081"

        message =
            (Encode.encode 0 (getjsonMessage model))

        body =
            HT.jsonBody (Encode.string (sendString model))

        request =
          HT.post url body postDecoder

    in
        HT.send Model.POST request



--decodes the response expects nothing back right now


postDecoder : Decoder String
postDecoder =
    Decode.string



--converts the time inputed to unix time


convertToUnixTime : Result String Date.Time -> Int
convertToUnixTime time =
    case time of
        Ok value ->
            Date.toTime value

        Err error ->
            -1



{- submit using still figuring out
   submitMessage : Model -> Cmd Msg
   submitMessage model =
     let
       url = "http://localhost:8081"
       message = (Encode.encode 0 (getjsonMessage model))
       body = HT.string message
     in
       Task.perform PostFail PostSucceed (HT.send HT.defaultSettings )

-}
