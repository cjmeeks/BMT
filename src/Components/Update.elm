module Update exposing (..)

import Model exposing (Model, Item, Msg)
import Util exposing (splitTime, splitDate, submitData, getDateString, postRequest, init, convertToUnixTime)
import ISO8601 as Date exposing(..)

import Http exposing (..)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Model.FirmWare firm ->
            ({ model | firmware = firm }, Cmd.none)

        Model.Meid meid ->
            ({ model | meid = meid }, Cmd.none)

        Model.SeqNum num ->
            ({ model | seqNum = num }, Cmd.none)

        Model.Date date ->
            (splitDate date model, Cmd.none)

        Model.Time time ->
            (splitTime time model , Cmd.none)

        Model.TimeZone zone ->
            ({ model | timeZone = zone }, Cmd.none)

        Model.Temp temp ->
            ({ model | temp = temp }, Cmd.none)

        Model.Weight weight ->
            ({ model | weight = weight }, Cmd.none)

        Model.Battery battery ->
           ({ model | battery = battery }, Cmd.none)

        Model.Signal signal ->
            ({ model | signal = signal }, Cmd.none)
        Model.MessageType messType ->
            ({ model | messageType = messType}, Cmd.none)

        Model.Clear ->
            init

        Model.LowSig bool->
            ({ model | lowS = bool }, Cmd.none)

        Model.LowBat bool->
            ({ model | lowB = bool }, Cmd.none)

        Model.ZeroWeight bool->
            ({ model | zeroW = bool }, Cmd.none)

        Model.HighTemp bool->
            ({ model | highT = bool }, Cmd.none)

        Model.Submit ->
          (model, submitData {model | unixTime = convertToUnixTime (Date.fromString (getDateString model))})
          --submitData {model | unixTime = convertToUnixTime (Date.fromString (getDateString model))}
          --{model | dateString = Date.fromString (getDateString model) },
        Model.PostSucceed success->
          (model, Cmd.none)

        Model.PostFail error ->
          (case error of
            Timeout -> {model | z = "Timeout"}
            NetworkError -> {model | z =" NetworkError"}
            UnexpectedPayload payload -> {model | responseData = "Post delivered"}
            BadResponse number response -> {model |  responseNumber =  Basics.toString number
                                                  ,  responseData = response}
          , Cmd.none)

        Model.Dropdown ->
          (model, Cmd.none)
