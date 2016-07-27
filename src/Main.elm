module Main exposing (..)

import View as V exposing (view)
import Update as U exposing (update)
import Util exposing (..)
import Model as Types

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String exposing (..)
import Http as HT exposing (..)
import Array exposing (..)
import Json.Decode as Decode exposing ((:=), object1, string, int, Decoder)
import Json.Encode as Encode exposing (object, encode, string, Value)
import Task

main =
  Html.program
    { init = Util.init
    , view = V.view
    , update = U.update
    , subscriptions = subscriptions
    }
{-type alias Item =
 {message : String}
 -}

--subscriptions
subscriptions : Types.Model -> Sub Types.Msg
subscriptions model =
  Sub.none
