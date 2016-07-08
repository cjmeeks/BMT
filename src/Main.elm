module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String exposing (..)
import Date exposing (..)
import Date.Extra.Format as Format exposing(isoFormat)
import Array exposing (..)

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL


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
    }


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
  , year =Just ""
  , day = Just ""
  , month = Just ""
  , theHour = Just ""
  , theMinute = Just ""
  , dateString = ""
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
            (modelClear model, Cmd.none)

        LowSig bool->
            ({ model | lowS = bool }, Cmd.none)

        LowBat bool->
            ({ model | lowB = bool }, Cmd.none)

        ZeroWeight bool->
            ({ model | zeroW = bool }, Cmd.none)

        HighTemp bool->
            ({ model | highT = bool }, Cmd.none)

        Submit ->
          ({model | dateString = getDateString model}, Cmd.none)

-- VIEW


view : Model -> Html Msg
view model =
    let
        firmView =
            div [ class "col-md-3 text-center" ] [ text "FirmWare", div [] [input [ onInput FirmWare] [] ] ]
        meidView =
            div [ class "col-md-3 text-center" ] [ text "Meid", div [] [input [ onInput Meid ] []] ]
        seqView =
            div [ class "col-md-3 text-center" ] [ text "Sequence Number", div [] [input [ onInput SeqNum ] []] ]
        dateView =
            div [ class "col-md-3 text-center" ] [ text "Date", div [] [ input [ onInput Date ] [] ] ]
        timeView =
            div [ class "col-md-3 text-center" ] [ text "Time of Day(hh:mm)", div [] [ input [ onInput Time ] [] ] ]
        zoneView =
            div [ class "col-md-3 text-center" ] [ text "TimeZone((+/-)hh:mm)", div [] [input [ onInput TimeZone ][] ] ]
        tempView =
            div [ class "col-md-3 text-center" ] [ text "Temp", div [] [input [ onInput Temp, value model.temp ] [] ] ]
        weightView =
            div [ class "col-md-3 text-center" ] [ text "Weight", div [] [input [ onInput Weight,value model.weight ] [] ] ]
        batteryView =
            div [ class "col-md-3 text-center" ] [ text "Battery", div [] [input [ onInput Battery, value model.battery ][] ]  ]
        signalView =
            div [ class "col-md-3 text-center" ] [ text "Signal", div [] [input [ onInput Signal ,value model.signal ] [] ] ]
        messTypeView =
            div [ class "col-md-3 text-center"]  [ text "Message Type", div [] [input [onInput MessageType ] []] ]
    in
        div [ class "container" ]
            [ div [class "row smrxtHeader text-center span-block"] [text "SMRxT Bottle Message Tool"],  div [class "container col-md-12"] [div [ class "row" ] [ firmView, messTypeView ,meidView, seqView ]
            , div [ class "row" ] [  dateView, timeView, zoneView, tempView ]
            , div [class "row " ] [  weightView, batteryView, signalView ]
            , bottleMessageView model]
            , checksView model
            , div [class "col-md-9"] [ button [class "btn-lg btn-success", onClick Submit] [ text "SUBMIT"],button [ class "btn-lg btn-danger", onClick Clear ] [ text "Clear" ]]
            ]

checksView : Model -> Html Msg
checksView model =  div [class "col-md-3"] [div []
    [ div [class "row"] [input [ type' "checkbox", checked model.lowS ,onCheck LowSig ] [ ], text "Low Signal" ]
    , div [class "row"] [input [ type' "checkbox", checked model.lowB ,onCheck LowBat ] [ ], text "Low Battery"]
    , div [class "row"] [input [ type' "checkbox", checked model.zeroW ,onCheck ZeroWeight ] [], text "Zero Weight" ]
    , div [class "row"] [input [ type' "checkbox", checked model.highT ,onCheck HighTemp ] [], text "High Temperature"]
    ]]

bottleMessageView : Model -> Html Msg
bottleMessageView model =
  div [class "h1 col-md-12 text-center"]
    [ text (String.concat
    [ model.firmware, ","
    , model.messageType, ","
    , model.meid, ","
    , model.seqNum, ";"
    , case model.year of
        Just year -> year
        Nothing -> "there is nothing"
      , "-"
    , case model.month of
        Just month -> month
        Nothing -> "nothing son"
    , "-"
    ,case model.day of
        Just day -> day
        Nothing -> "nothing suhsonboi"
    , "T"
    , case model.theHour of
        Just theHour -> theHour
        Nothing -> "nothing sonholo"
    , ":"
    , case model.theMinute of
        Just theMinute -> theMinute
        Nothing -> "nothing sonmin"
    , ","
    , model.timeZone, ","
    , if model.highT then "112.0" else model.temp, ","
    , if model.zeroW then "0" else model.weight, ","
    , if model.lowB then "3.1" else model.battery, ","
    , if model.lowS then "2" else model.signal, ","
    , model.x, ","
    , model.y, ","
    , model.z ]) ]

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

modelClear : Model -> Model
modelClear _ =
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
    , year = Just ""
    , day = Just ""
    , month =Just  ""
    , theHour = Just ""
    , theMinute = Just ""
    , dateString = ""
    }

getDateString : Model -> String
getDateString model =
  String.concat
  [
    case model.year of
        Just year -> year
        Nothing -> "there is nothing"
      , "-"
    , case model.month of
        Just month -> month
        Nothing -> "nothing son"
    , "-"
    ,case model.day of
        Just day -> day
        Nothing -> "nothing suhsonboi"
    , "T"
    , case model.theHour of
        Just theHour -> theHour
        Nothing -> "nothing sonholo"
    , ":"
    , case model.theMinute of
        Just theMinute -> theMinute
        Nothing -> "nothing sonmin"
    , ","
    , model.timeZone
  ]
