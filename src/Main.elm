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
    , x = ""
    , y = ""
    , z = ""
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
    | LowSig
    | LowBat
    | ZeroWeight
    | HighTemp
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

        LowSig ->
            lowSignal model

        LowBat ->
            lowBattery model

        ZeroWeight ->
            zeroWeight model

        HighTemp ->
            highTemp model


highTemp : Model -> Model
highTemp model =
    { firmware = model.firmware
    , meid = model.meid
    , seqNum = model.seqNum
    , date = model.date
    , time = model.time
    , timeZone = model.timeZone
    , temp = "112.3"
    , weight = model.weight
    , battery = model.battery
    , signal = model.signal
    , something = model.something
    , x = model.x
    , y = model.y
    , z = model.z
    }


zeroWeight : Model -> Model
zeroWeight model =
    { firmware = model.firmware
    , meid = model.meid
    , seqNum = model.seqNum
    , date = model.date
    , time = model.time
    , timeZone = model.timeZone
    , temp = model.temp
    , weight = "0"
    , battery = model.battery
    , signal = model.signal
    , something = model.something
    , x = model.x
    , y = model.y
    , z = model.z
    }


lowBattery : Model -> Model
lowBattery model =
    { firmware = model.firmware
    , meid = model.meid
    , seqNum = model.seqNum
    , date = model.date
    , time = model.time
    , timeZone = model.timeZone
    , temp = model.temp
    , weight = model.weight
    , battery = "3.1"
    , signal = model.signal
    , something = model.something
    , x = model.x
    , y = model.y
    , z = model.z
    }


lowSignal : Model -> Model
lowSignal model =
    { firmware = model.firmware
    , meid = model.meid
    , seqNum = model.seqNum
    , date = model.date
    , time = model.time
    , timeZone = model.timeZone
    , temp = model.temp
    , weight = model.weight
    , battery = model.battery
    , something = model.something
    , signal = "2"
    , x = model.x
    , y = model.y
    , z = model.z
    }


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
    , x = ""
    , y = ""
    , z = ""
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
            [ div [class "row h1 text-center"] [text "SMRxT Bottle Message Tool"], div [class "container col-md-9"] [div [ class "row" ] [ firmView, meidView, seqView ]
              , div [ class "row" ] [ dateView, timeView, zoneView ]
            , div [class "row " ] [ tempView, weightView, batteryView ]
            , div [ class "row " ] [ signalView ]
            , bottleMessageView ]
            , buttonsView ]

buttonsView : Html Msg
buttonsView =  div [class "container col-md-3"] [div []
    [ div [class "row"] [button [ class "btn-lg btn-primary btn-block", onClick LowSig ] [ text "Low Signal" ]]
    , div [class "row"] [button [ class "btn-lg btn-primary btn-block", onClick LowBat ] [ text "Low Battery" ]]
    , div [class "row"] [button [ class "btn-lg btn-primary btn-block", onClick ZeroWeight ] [ text "Zero Weight" ]]
    , div [class "row"] [button [ class "btn-lg btn-primary btn-block", onClick HighTemp ] [ text "High Temperature" ]]
    , div [class "row"] [button [ class "btn-lg btn-danger btn-block", onClick Clear ] [ text "Clear" ]]
    ]]

bottleMessageView : Html Msg
bottleMessageView = div [class "h1"] [ text (String.concat [ model.firmware, ",", model.meid, ",", model.seqNum, ";", model.date, "-", model.time, ",", model.timeZone, ",", model.temp, ",", model.weight, ",", model.battery, ",", model.signal, ",", model.x, ",", model.y, ",", model.z ]) ]
