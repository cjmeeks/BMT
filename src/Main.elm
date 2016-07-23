module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String exposing (..)
import Http as HT exposing (..)
import Date exposing (..)
import Date.Extra.Format as Format exposing(isoFormat)
import Array exposing (..)
import Json.Decode as Decode exposing ((:=), object2, string, int, Decoder)
import Json.Encode as Encode exposing (object, encode, string, Value)
import Task

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Item = String

type alias Model =
    { firmware : String
    , meid : String
    , seqNum : String
    , timeZone : String
    , temp : String
    , weight : String
    , battery : String
    , signal : String
    , messageType : String
    , x : String
    , y : String
    , z : String
    , highT : Bool
    , zeroW : Bool
    , lowB : Bool
    , lowS : Bool
    , year : Maybe String
    , day : Maybe String
    , month : Maybe String
    , theHour : Maybe String
    , theMinute : Maybe String
    , dateString : String
    , getData : String
    , failData : Maybe HT.Error
    }

type JSON object = Object

init : (Model, Cmd Msg)
init =
  (
  { firmware = ""
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
  , day =  Nothing
  , month =  Nothing
  , theHour =  Nothing
  , theMinute = Nothing
  , dateString = ""
  , getData = ""
  , failData = Nothing
  }
  , Cmd.none)

-- UPDATE
type Msg
    = FirmWare String
    | Meid String
    | SeqNum String
    | Date String
    | Time String
    | TimeZone String
    | Temp String
    | Weight String
    | Battery String
    | Signal String
    | Clear
    | LowSig Bool
    | LowBat Bool
    | ZeroWeight Bool
    | HighTemp Bool
    | MessageType String
    | Submit
    | PostSucceed Item
    | PostFail HT.Error
    | PostRequest
    | GetRequest

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        FirmWare firm ->
            ({ model | firmware = firm }, Cmd.none)

        Meid meid ->
            ({ model | meid = meid }, Cmd.none)

        SeqNum num ->
            ({ model | seqNum = num }, Cmd.none)

        Date date ->
            (splitDate date model, Cmd.none)

        Time time ->
            (splitTime time model , Cmd.none)

        TimeZone zone ->
            ({ model | timeZone = zone }, Cmd.none)

        Temp temp ->
            ({ model | temp = temp }, Cmd.none)

        Weight weight ->
            ({ model | weight = weight }, Cmd.none)

        Battery battery ->
           ({ model | battery = battery }, Cmd.none)

        Signal signal ->
            ({ model | signal = signal }, Cmd.none)
        MessageType messType ->
            ({ model | messageType = messType}, Cmd.none)

        Clear ->
            init

        LowSig bool->
            ({ model | lowS = bool }, Cmd.none)

        LowBat bool->
            ({ model | lowB = bool }, Cmd.none)

        ZeroWeight bool->
            ({ model | zeroW = bool }, Cmd.none)

        HighTemp bool->
            ({ model | highT = bool }, Cmd.none)

        Submit ->
          (model , submitData {model | dateString = getDateString model})

        PostSucceed success->
          ({model | getData = success}, Cmd.none)

        PostFail error ->
          (case error of
            Timeout -> {model | z = "Timeout"}
            NetworkError -> {model | z =" NetworkError"}
            UnexpectedPayload payload -> {model | z = payload}
            BadResponse number response -> {model | y =  toString number
                                                  ,  z = response}
          , Cmd.none)

        PostRequest ->
            (model, postRequest "yo" "lo")

        GetRequest ->
            (model, Cmd.none)


-- VIEW


view : Model -> Html Msg
view model =
    let
        firmView =
            div [ class "col-md-3 text-center lead" ] [ text "FirmWare", div [] [input [ onInput FirmWare] [] ] ]
        meidView =
            div [ class "col-md-3 text-center lead" ] [ text "Meid", div [] [input [ onInput Meid ] []] ]
        seqView =
            div [ class "col-md-3 text-center lead" ] [ text "Sequence Number", div [] [input [ onInput SeqNum ] []] ]
        dateView =
            div [ class "col-md-3 text-center lead" ] [ text "Date", div [] [ input [ onInput Date ] [] ] ]
        timeView =
            div [ class "col-md-3 text-center" ] [ text "Time of Day(hh:mm-(24 Hour))", div [] [ input [ onInput Time ] [] ] ]
        zoneView =
            div [ class "col-md-3 text-center lead" ] [ text "TimeZone((+/-)hh:mm)", div [] [input [ onInput TimeZone ][] ] ]
        tempView =
            div [ class "col-md-3 text-center lead" ] [ text "Temp", div [] [input [ onInput Temp ] [] ] ]
        weightView =
            div [ class "col-md-3 text-center lead" ] [ text "Weight", div [] [input [ onInput Weight ] [] ] ]
        batteryView =
            div [ class "col-md-3 text-center lead" ] [ text "Battery", div [] [input [ onInput Battery ][] ]  ]
        signalView =
            div [ class "col-md-3 text-center lead" ] [ text "Signal", div [] [input [ onInput Signal ] [] ] ]
        messTypeView =
            div [ class "col-md-3 text-center lead"]  [ text "Message Type", div [] [input [onInput MessageType ] []] ]
    in
        div [ class "container" ]
            [ div [class "row text-center "] [img [src "img/BMTHeader.png"] []],  div [class "container col-md-12"] [div [ class "row" ] [ firmView, messTypeView ,meidView, seqView ]
            , div [ class "row" ] [  dateView, timeView, zoneView, tempView ]
            , div [class "row " ] [  weightView, batteryView, signalView ]
            , div[class "row col-md-12 text-center lead h1"][text (bottleMessage model)]
            , checksView model
            , div [class "col-md-12 text-center "] [ button [class "btn-lg btn-success active", onClick Submit] [ text "SUBMIT"],button [ class "btn-lg btn-danger active", onClick Clear ] [ text "Clear" ],button [ class "btn-lg btn-default active", onClick PostRequest ] [ text "Post" ], button [ class "btn-lg btn-default active", onClick GetRequest ] [ text "Get" ]]]]


checksView : Model -> Html Msg
checksView model =  div [class "col-md-12 text-center"] [div []
    [ ul [class "list-inline"]
    [  li [class "list-inline-item"] [div [] [label [class "btn btn-primary active"] [input [ type' "checkbox", checked model.lowS ,onCheck LowSig ] [ ], text "Low Signal" ]]]
    , li [class "list-inline-item"] [div [] [label [class "btn btn-primary active"] [input [ type' "checkbox", checked model.lowB ,onCheck LowBat ] [ ], text "Low Battery"]]]
    , li [class "list-inline-item"] [div [] [label [class "btn btn-primary active"] [input [ type' "checkbox", checked model.zeroW ,onCheck ZeroWeight ] [], text "Zero Weight" ]]]
    , li [class "list-inline-item"] [div [] [label [class "btn btn-primary active"] [input [ type' "checkbox", checked model.highT ,onCheck HighTemp ] [], text "High Temperature"]]]]]]

bottleMessage : Model -> String
bottleMessage model =
   String.concat[model.firmware, ",", model.messageType, ",", model.meid, ",", model.seqNum, ";"
    , case model.year of
        Just year -> year
        Nothing -> ""
      , "-"
    , case model.month of
        Just month -> month
        Nothing -> ""
    , "-"
    ,case model.day of
        Just day -> day
        Nothing -> ""
    , "T"
    , case model.theHour of
        Just theHour -> theHour
        Nothing -> ""
    , ":"
    , case model.theMinute of
        Just theMinute -> theMinute
        Nothing -> ""
    , model.timeZone, ","
    , if model.highT then "112.0" else model.temp, ","
    , if model.zeroW then "0" else model.weight, ","
    , if model.lowB then "3.1" else model.battery, ","
    , if model.lowS then "2" else model.signal, ","
    , model.x, ","
    , model.y, ","
    , model.z
    ,model.getData]

--subscriptions
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

--helper functions
splitTime : String -> Model -> Model
splitTime time model =
  let
    listTime = Array.fromList (split ":" time)
  in
     { model
         | theHour = Array.get 0 listTime
         , theMinute = Array.get 1 listTime
     }


splitDate : String -> Model -> Model
splitDate date model =
    let
      listDate = Array.fromList (split "/" date)
    in
    { model
        | year = Array.get 2 listDate
        , day = Array.get 1 listDate
        , month = Array.get 0 listDate
    }

getDateString : Model -> String
getDateString model =
  String.concat
  [
    case model.year of
        Just year -> year
        Nothing -> "Year"
      , "-"
    , case model.month of
        Just month -> month
        Nothing -> "Month"
    , "-"
    ,case model.day of
        Just day -> day
        Nothing -> "Day"
    , "T"
    , case model.theHour of
        Just theHour -> theHour
        Nothing -> "Hour"
    , ":"
    , case model.theMinute of
        Just theMinute -> theMinute
        Nothing -> "Minute"
    , ","
    , model.timeZone
  ]

getjsonMessage : Model -> Encode.Value
getjsonMessage model =
  Encode.object
    [ ("message" , Encode.string (bottleMessage model))
    ]
--requests
postRequest : String -> String -> Cmd Msg
postRequest username password =
  let
    url = "http://localhost:8081"
    body =
      HT.multipart
        [ HT.stringData "user" username
        , HT.stringData "password" password
        ]
  in
    Task.perform PostFail PostSucceed (HT.post postDecoder url body)


submitData : Model -> Cmd Msg
submitData model =
  let
    url = "http://localhost:8081"
    message = (Encode.encode 0 (getjsonMessage model))
    body = HT.string message

  in
    Task.perform PostFail PostSucceed (HT.post postDecoder url body)

postDecoder : Decoder String
postDecoder = Decode.string

submitMessage : Model -> Cmd Msg
submitMessage model =
  let
    url = "http://localhost:8081"
    message = message = (Encode.encode 0 (getjsonMessage model))
    body = HT.string message
  in
    Task.perform PostFail PostSucceed (HT.send Ht.defaultSettings )

{-getDecoder : Decoder Item2
getDecoder =
    Json.object2 Item Item
    ("name" := Json.string,
      "job" := Json.string)-}
