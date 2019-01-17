module Update exposing (..)

import Messages exposing (..)
import Models exposing (..)
import Random exposing (..)
import Task exposing (..)
import RandomGenerators exposing (..)
import Debug exposing (log)
import Json.Decode as Json exposing (Decoder)
import Json.Decode.Pipeline as PL exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FireTheCannons -> 
            (model, Cmd.batch
                [
                    run CreateLazer,
                    run Randomize
                ]
            )
        Randomize -> 
            (model, Cmd.batch
                [
                    run RandomW,
                    run RandomH
                ]
            )
        RandomW ->
            (model, generate SetW betweenWidthBounds)
        RandomH -> 
            (model, generate SetH betweenHeightBounds)
        SetCoords pos ->
            ( { model | x = String.fromInt(pos.x), y = String.fromInt(pos.y)}, run FireTheCannons )
        SetW a ->
            ({ model | w = a }, Cmd.none)
        SetH a ->
            ({ model | h = a }, Cmd.none)
        CreateLazer -> 
            ({ model | lazers = Lazer model.index (model.x) (model.y) (toString model.w) (toString model.h) :: model.lazers}, run IncrementIndex)
        ClearLazers pos ->
            ({ model | lazers = []}, run ClearIndex)
        IncrementIndex ->
            ({ model | index = model.index + 1 }, Cmd.none)
        ClearIndex ->
            ({ model | index = 0}, Cmd.none)



---- Utilities ----
    
run : Msg -> Cmd Msg
run message = 
    Task.perform (always message) (Task.succeed ())


toString : Int -> String
toString a =    
    String.fromInt(a)



