module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String
import Date


main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    { firmware : String
    , meid : String
    , seqNum : String
    , date : String
    , time : String
    , timeZone : String
    , temp : String
    , weight : String
    , battery : String
    , signal : String
    , something : String
    , x : String
    , y : String
    , z : String
    , highT : Bool
    , zeroW : Bool
    , lowB : Bool
    , lowS : Bool

    }


model : Model
model =
    { firmware = ""
    , meid = ""
    , seqNum = ""
    , date = ""
    , time = ""
    , timeZone = ""
    , temp = ""
    , weight = ""
    , battery = ""
    , signal = ""
    , something = "BR"
    , x = "0"
    , y = "0"
    , z = "0"
    , highT = False
    , zeroW = False
    , lowB = False
    , lowS = False
    }



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
    | Something String


update : Msg -> Model -> Model
update msg model =
    case msg of
        FirmWare firm ->
            { model | firmware = firm }

        Meid meid ->
            { model | meid = meid }

        SeqNum num ->
            { model | seqNum = num }

        Date date ->
            { model | date = date }

        Time time ->
            { model | time = time }

        TimeZone zone ->
            { model | timeZone = zone }

        Temp temp ->
            { model | temp = temp }

        Weight weight ->
            { model | weight = weight }

        Battery battery ->
            { model | battery = battery }

        Signal signal ->
            { model | signal = signal }
        Something s ->
            { model | something = s}

        Clear ->
            modelClear model

        LowSig bool->
            { model | lowS = bool }

        LowBat bool->
            { model | lowB = bool }

        ZeroWeight bool->
            { model | zeroW = bool }

        HighTemp bool->
            { model | highT = bool }


modelClear : Model -> Model
modelClear _ =
    { firmware = ""
    , meid = ""
    , seqNum = ""
    , date = ""
    , time = ""
    , timeZone = ""
    , temp = ""
    , weight = ""
    , battery = ""
    , signal = ""
    , something = "BR"
    , x = "0"
    , y = "0"
    , z = "0"
    , highT = False
    , zeroW = False
    , lowB = False
    , lowS = False
    }



-- VIEW


view : Model -> Html Msg
view model =
    let
        firmView =
            div [ class "col-md-4 text-center" ] [ text "FirmWare", div [] [input [ onInput FirmWare ] [] ] ]
        meidView =
            div [ class "col-md-4 text-center" ] [ text "Meid", div [] [input [ onInput Meid ] []] ]
        seqView =
            div [ class "col-md-4 text-center" ] [ text "Sequence Number", div [] [input [ onInput SeqNum ] []] ]
        dateView =
            div [ class "col-md-4 text-center" ] [ text "Date", div [] [ input [ onInput Date ] [] ] ]
        timeView =
            div [ class "col-md-4 text-center" ] [ text "Time of Day(hh:mm)", div [] [ input [ onInput Time ] [] ] ]
        zoneView =
            div [ class "col-md-4 text-center" ] [ text "TimeZone", div [] [input [ onInput TimeZone ][] ] ]
        tempView =
            div [ class "col-md-4 text-center" ] [ text "Temp", div [] [input [ onInput Temp ] [] ] ]
        weightView =
            div [ class "col-md-4 text-center" ] [ text "Weight", div [] [input [ onInput Weight ] [] ] ]
        batteryView =
            div [ class "col-md-4 text-center" ] [ text "Battery", div [] [input [ onInput Battery ][] ]  ]
        signalView =
            div [ class "col-md-4 text-center" ] [ text "Signal", div [] [input [ onInput Signal ] [] ] ]
        somethingView =
            div [ class "col-md-4 text-center"]  [ text "BR", div [] [input [onInput Something ] []] ]
    in
        div [ class "container" ]
            [ div [class "row smrxtHeader text-center span-block"] [text "SMRxT Bottle Message Tool"],  div [class "container col-md-9"] [div [ class "row" ] [ firmView, meidView, seqView ]
            , div [ class "row" ] [ dateView, timeView, zoneView ]
            , div [class "row " ] [ tempView, weightView, batteryView ]
            , div [ class "row " ] [ signalView, somethingView ]
            , bottleMessageView model]
            , checksView
            , formView model
            ]

checksView : Html Msg
checksView =  div [class "container col-md-3"] [div []
    [ div [class "row"] [input [ type' "checkbox", checked model.lowS ,onCheck LowSig ] [ ], text "Low Signal" ]
    , div [class "row"] [input [ type' "checkbox", checked model.lowB ,onCheck LowBat ] [ ], text "Low Battery"]
    , div [class "row"] [input [ type' "checkbox", checked model.zeroW ,onCheck ZeroWeight ] [], text "Zero Weight" ]
    , div [class "row"] [input [ type' "checkbox", checked model.highT ,onCheck HighTemp ] [], text "High Temperature"]
    , div [class "row"] [button [ class "btn-lg btn-danger", onClick Clear ] [ text "Clear" ]]
    ]]

bottleMessageView : Model -> Html Msg
bottleMessageView model =
  div [class "h1 col-md-12 text-center"]
  [ text (String.concat
  [ model.firmware, ","
  , model.something, ","
  , model.meid, ","
  , model.seqNum, ";"
  , model.date, "-"
  , model.time, ","
  , model.timeZone, ","
  , if model.highT then "112.0" else model.temp, ","
  , if model.zeroW then "0" else model.weight, ","
  , if model.lowB then "3.1" else model.battery, ","
  , if model.lowS then "2" else model.signal, ","
  , model.x, ","
  , model.y, ","
  , model.z ]) ]

formView : Model -> Html Msg
formView model =
  let
    firmView = div [class "text-center col-md-4"] [label [class "text-center"] [text "FirmWare"], div [] [input [value model.firmware] []]]

    meidView = div [class "text-center col-md-4"] [label [class "text-center"] [text "FirmWare"], div [] [input [value model.meid][]]]

    seqView =div [class "text-center col-md-4"] [label [class "text-center"] [text "Sequence Number"], div [] [input [value model.seqNum][]]]

    dateView = div [class "text-center col-md-4"] [label [class "text-center"] [text "Date (mm/dd/yyyy)"], div [] [input [value model.date][]]]

    timeView = div [class "text-center col-md-4"] [label [class "text-center"] [text "Time Of Date (hh:mm)"], div [] [input [ value model.time][]]]

    zoneView = div [class "text-center col-md-4"] [label [class "text-center"] [text "TimeZone"], div [] [input [ value model.timeZone][]]]

    tempView =div [class "text-center col-md-4"] [label [class "text-center"] [text "Temperature"], div [] [input [ value model.temp][]]]

    weightView = div [class "text-center col-md-4"] [label [class "text-center"] [text "Weight"], div [] [input [ value model.weight][]]]

    batteryView = div [class "text-center col-md-4"] [label [class "text-center"] [text "Battery"], div [] [input [ value model.battery][]]]

    signalView =div [class "text-center col-md-12"] [label [class "text-center"] [text "Signal"], div [] [input [value model.signal][]]]

    somethingView =div [class "text-center col-md-4"] [label [class "text-center"] [text "Something"], div [] [input [placeholder model.something, value model.something][]]]

  in
    div [class "row col-md-12"] [
      Html.form [id "message-form"]
      [ h1 [class "text-center"] [text "Message Form"]
      , div [class "row"] [firmView, somethingView, meidView]
      , div [class "row"] [seqView, dateView, timeView]
      , div [class "row"] [tempView, weightView, batteryView]
      , div [class "row text-center"] [signalView]
      , div [class "row col-md-4 text-center"] [button [ class "btn-success"] [ text "Submit" ]]

      ]
    ]
