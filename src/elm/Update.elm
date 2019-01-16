module Update exposing (..)

import Messages exposing (..)
import Models exposing (..)
import Random exposing (..)
import Task exposing (..)
import RandomGenerators exposing (..)

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
                    run RandomX,
                    run RandomY,
                    run RandomW,
                    run RandomH
                ]
            )
        RandomX -> 
                (model, generate SetX betweenXBounds)
        RandomY ->
                (model, generate SetY betweenYBounds)
        RandomW ->
                (model, generate SetW betweenWidthBounds)
        RandomH -> 
                (model, generate SetH betweenHeightBounds)
        SetX a ->
            ({model | x = a}, Cmd.none)
        SetY a ->
            ({model | y = a}, Cmd.none)
        SetW a ->
            ({model | w = a}, Cmd.none)
        SetH a ->
            ({model | h = a}, Cmd.none)
        CreateLazer -> 
            ({ model | lazers = Lazer model.index (toString model.x) (toString model.y) (toString model.w) (toString model.h) :: model.lazers}, run IncrementIndex)
        ClearLazers ->
            ({ model | lazers = []}, run ClearIndex)
        IncrementIndex ->
            ({ model | index = model.index + 1 }, Cmd.none)
        ClearIndex ->
            ({ model | index = 0}, Cmd.none)


---- Utilities ----

run : Msg -> Cmd Msg
run message = 
    Task.perform (always message) (Task.succeed ())

---- Utilities ----

toString : Int -> String
toString a =    
    String.fromInt(a)