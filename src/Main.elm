module Main exposing (..)

import View as V exposing (view)
import Update as U exposing (update)
import Util exposing (..)
import Model as Types

import Html exposing (..)
import Html.App as Html


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
