module Main exposing (..)

import Browser
import Messages exposing (..)
import Models exposing (..)
import View exposing (..)
import Update exposing (..)
import Subs exposing (..)

---- MODEL ----

init : (Model, Cmd msg)
init = 
    (initialModel, Cmd.none)

---- PROGRAM ----

main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = Subs.subscriptions
        }
