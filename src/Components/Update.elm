module Update exposing (..)

import Model exposing (Model, Item, Msg)
import Util exposing (splitTime, splitDate, submitData, getDateString, postRequest, init, convertToUnixTime)
import ISO8601 as Date exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Model.FirmWare firm ->
            { model | firmware = firm } ! []

        Model.Meid meid ->
            { model | meid = meid } ! []

        Model.SeqNum num ->
            { model | seqNum = num } ! []

        Model.Date date ->
            splitDate date model ! []

        Model.Time time ->
            splitTime time model ! []

        Model.TimeZone zone ->
            { model | timeZone = zone } ! []

        Model.Temp temp ->
            { model | temp = temp } ! []

        Model.Weight weight ->
            { model | weight = weight } ! []

        Model.Battery battery ->
            { model | battery = battery } ! []

        Model.Signal signal ->
            { model | signal = signal } ! []

        Model.MessageType messType ->
            { model | messageType = messType } ! []

        Model.Clear ->
            init

        Model.LowSig bool ->
            { model | lowS = bool } ! []

        Model.LowBat bool ->
            { model | lowB = bool } ! []

        Model.ZeroWeight bool ->
             { model | zeroW = bool } ! []

        Model.HighTemp bool ->
             { model | highT = bool } ! []

        Model.Submit ->
            ( model, submitData { model | unixTime = convertToUnixTime (Date.fromString (getDateString model)) } )

        Model.POST (Result.Ok valueStr) ->
          model ! []

        Model.POST (Result.Err err) ->
          {model | responseData = (Basics.toString err)} ! []


        Model.Dropdown ->
            model ! []
