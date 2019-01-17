module Subs exposing (..)

import Browser.Events exposing (onAnimationFrameDelta)
import Html.Events exposing (..)
import Messages exposing (..)
import Models exposing (..)
import Html exposing (..)
import String
import Json.Decode as Json


---- SUBSCRIPTIONS ----

subscriptions : Model -> Sub Msg
subscriptions model =
    onAnimationFrameDelta FrameEvent



    