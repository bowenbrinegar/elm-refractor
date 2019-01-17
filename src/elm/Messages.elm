module Messages exposing (..)

import Browser exposing (..)
import Browser.Events exposing (..)
import Json.Decode exposing (Decoder)
import Models exposing (..)

type Msg
    = FireTheCannons
    | Randomize
    | RandomW
    | RandomH
    | SetCoords Coords
    | SetX Int
    | SetY Int
    | SetW Int
    | SetH Int
    | CreateLazer 
    | IncrementIndex
    | ClearLazers Coords
    | ClearIndex
