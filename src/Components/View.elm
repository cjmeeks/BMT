module View exposing (..)

import Model exposing (Model, Item, Msg)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String exposing (..)
import ISO8601 as Date exposing (..)


view : Model -> Html Msg
view model =
    let
        firmView =
            div [ class "col-md-3 text-center lead" ] [ text "FirmWare", div [] [ input [ onInput Model.FirmWare ] [] ] ]

        meidView =
            div [ class "col-md-3 text-center lead" ] [ text "Meid", div [] [ selectMenu ] ]

        {- div [ class "col-md-3 text-center lead" ] [ div [ class "dropdown lead" ]
           [ button [ attribute "aria-expanded" "true", attribute "aria-haspopup" "true", class "btn btn-default dropdown-toggle", attribute "data-toggle" "true", id "dropdownMenu1", type' "button", onClick Model.Dropdown ]
               [ text "Dropdown"
               , span [ class "caret" ]
                   []
               ]
           , ul [ attribute "aria-labelledby" "dropdownMenu1", class "dropdown-menu" ]
               [ li []
                   [ text model.meid ]
               , li []
                   [ text model.meid ]
               , li []
                   [  text model.meid ]
               , li [ class "divider", attribute "role" "separator" ]
                   []
               ]
           ] ]
        -}
        seqView =
            div [ class "col-md-3 text-center lead" ] [ text "Sequence Number", div [] [ input [ onInput Model.SeqNum ] [] ] ]

        dateView =
            div [ class "col-md-3 text-center lead" ] [ text "Date", div [] [ input [ onInput Model.Date ] [] ] ]

        timeView =
            div [ class "col-md-3 text-center lead" ] [ text "Time(hh:mm(24 Hour))", div [] [ input [ onInput Model.Time ] [] ] ]

        zoneView =
            div [ class "col-md-3 text-center lead" ] [ text "TimeZone((+/-)hh:mm)", div [] [ input [ onInput Model.TimeZone ] [] ] ]

        tempView =
            div [ class "col-md-3 text-center lead" ] [ text "Temp", div [] [ input [ onInput Model.Temp ] [] ] ]

        weightView =
            div [ class "col-md-3 text-center lead" ] [ text "Weight", div [] [ input [ onInput Model.Weight ] [] ] ]

        batteryView =
            div [ class "col-md-3 text-center lead" ] [ text "Battery", div [] [ input [ onInput Model.Battery ] [] ] ]

        signalView =
            div [ class "col-md-3 text-center lead" ] [ text "Signal", div [] [ input [ onInput Model.Signal ] [] ] ]

        messTypeView =
            div [ class "col-md-3 text-center lead" ] [ text "Message Type", div [] [ input [ onInput Model.MessageType ] [] ] ]
    in
        div [ class "container" ]
            [ div [ class "row text-center " ] [ img [ src "img/BMTHeader.png" ] [] ]
            , div [ class "container col-md-12" ]
                [ div [ class "row" ] [ firmView, messTypeView, meidView, seqView ]
                , div [ class "row" ] [ dateView, timeView, zoneView, tempView ]
                , div [ class "row " ] [ weightView, batteryView, signalView ]
                , div [ class "row col-md-12 text-center lead " ] [ text (bottleMessage model) ]
                , checksView model
                , div [ class "col-md-12 text-center " ] [ button [ class "btn-lg btn-success active", onClick Model.Submit ] [ text "SUBMIT" ], button [ class "btn-lg btn-danger active", onClick Model.Clear ] [ text "Clear" ] ]
                , div [ class "col-md-12 text-center" ] [ text (responseView model) ]
                , div [ class "row" ]
                    [ div [ class "col-md-12 text-center" ]
                        [ text
                            (case model.dateString of
                                Ok value ->
                                    Date.toString value

                                Err error ->
                                    error
                            )
                        ]
                    ]
                ]
            ]


checksView : Model -> Html Msg
checksView model =
    div [ class "col-md-12 text-center" ]
        [ div []
            [ ul [ class "list-inline" ]
                [ li [ class "list-inline-item" ] [ div [] [ label [ class "btn btn-primary active" ] [ input [ type_ "checkbox", checked model.lowS, onCheck Model.LowSig ] [], text "Low Signal" ] ] ]
                , li [ class "list-inline-item" ] [ div [] [ label [ class "btn btn-primary active" ] [ input [ type_ "checkbox", checked model.lowB, onCheck Model.LowBat ] [], text "Low Battery" ] ] ]
                , li [ class "list-inline-item" ] [ div [] [ label [ class "btn btn-primary active" ] [ input [ type_ "checkbox", checked model.zeroW, onCheck Model.ZeroWeight ] [], text "Zero Weight" ] ] ]
                , li [ class "list-inline-item" ] [ div [] [ label [ class "btn btn-primary active" ] [ input [ type_ "checkbox", checked model.highT, onCheck Model.HighTemp ] [], text "High Temperature" ] ] ]
                ]
            ]
        ]


bottleMessage : Model -> String
bottleMessage model =
    String.concat
        [ model.firmware
        , ","
        , model.messageType
        , ","
        , model.meid
        , ","
        , model.seqNum
        , ";"
        , case model.year of
            Just year ->
                year

            Nothing ->
                ""
        , "-"
        , case model.month of
            Just month ->
                month

            Nothing ->
                ""
        , "-"
        , case model.day of
            Just day ->
                day

            Nothing ->
                ""
        , "T"
        , case model.theHour of
            Just theHour ->
                theHour

            Nothing ->
                ""
        , ":"
        , case model.theMinute of
            Just theMinute ->
                theMinute

            Nothing ->
                ""
        , ":00"
        , model.timeZone
        , ","
        , if model.highT then
            "112.0"
          else
            model.temp
        , ","
        , if model.zeroW then
            "0"
          else
            model.weight
        , ","
        , if model.lowB then
            "3.1"
          else
            model.battery
        , ","
        , if model.lowS then
            "2"
          else
            model.signal
        , ","
        , model.x
        , ","
        , model.y
        , ","
        , model.z
        , Basics.toString model.unixTime
        ]



{- meidDrop: Model -> Html Msg
   meidDrop model =
-}


responseView : Model -> String
responseView model =
    String.concat [ model.responseNumber, " :: ", model.responseData ]


selectMenu : Html Msg
selectMenu =
    Html.node "div"
        [ attribute "style" "position:relative;width:200px;height:25px;border:0;padding:0;margin:0;" ]
        [ Html.text "\x0D\n"
        , Html.node "select"
            [ attribute "style" "position:absolute;top:0px;left:0px;width:200px; height:25px;line-height:20px;margin:0;padding:0;"
            ]
            [ Html.text "\x0D\n   "
            , Html.node "option" [] []
            , Html.text "\x0D\n   "
            , Html.node "option" [ attribute "value" "one" ] [ Html.text "one" ]
            , Html.text "\x0D\n   "
            , Html.node "option" [ attribute "value" "two" ] [ Html.text "two" ]
            , Html.text "\x0D\n   "
            , Html.node "option" [ attribute "value" "three" ] [ Html.text "three" ]
            , Html.text "\x0D\n"
            ]
        , Html.text "\x0D\n"
        , Html.node "input"
            [ attribute "name" "displayValue"
            , attribute "placeholder" "add/select a value"
            , attribute "id" "displayValue"
            , attribute "style" "position:absolute;top:0px;left:0px;width:183px;width:180px\t;#width:180px;height:23px; height:21px\t;#height:18px;border:1px solid #556;"
            , attribute "onfocus" "this.select()"
            , attribute "type" "text"
            ]
            [ input [ onInput Model.Meid ] [] ]
        , Html.text "\x0D\n"
        ]
