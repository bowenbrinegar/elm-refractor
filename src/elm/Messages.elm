module Messages exposing (..)

import Browser exposing (..)
import Browser.Events exposing (..)
import Json.Decode exposing (Decoder)
import Models exposing (..)

type Msg
    = FireTheCannons
    | Randomize
    | MouseDown Coords
    | MouseUp Coords
    | SetW Int
    | SetH Int
    | CreateLazer
    | IncrementIndex
    | ClearLazers Coords
    | ClearIndex
    | FrameEvent Float
    | MassAnimation
    | CheckRefraction
    | CalculatedFinalXY
