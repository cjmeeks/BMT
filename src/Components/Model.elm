module Model exposing (..)

import Http as HT exposing (..)


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
    , responseData : String
    , responseNumber : String
    , failData : Maybe HT.Error
    }
