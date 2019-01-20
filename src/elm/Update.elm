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
        MouseDown pos ->
            ({ model | x = pos.x, y = pos.y, div_w = pos.w, div_h = pos.h, isMouseDown = True}, Cmd.none )
        MouseUp pos -> 
            ({ model | isMouseDown = False }, run FireTheCannons)
        SetW a ->
            ({ model | w = a }, Cmd.none)
        SetH a ->
            ({ model | h = a }, Cmd.none)
        CreateLazer -> 
            let
                clientX = model.div_w
                clientY = model.div_h
                num = round model.pointerAngle
                gradientDirection = 
                    if model.pointerAngle <= 180 then
                        "to left"
                    else
                        "to right"
                newLazer =
                    if model.pointerAngle == 0 then
                        model.lazers
                    else if model.pointerAngle == 90 then
                        model.lazers
                    else if model.pointerAngle == 270 then
                        model.lazers
                    else if model.pointerAngle == 360 then
                        model.lazers
                    else
                        Lazer model.index model.x model.y (toFloat model.x) (toFloat model.y) 0 0 0 (model.w) 
                        (model.h) model.pointerAngle gradientDirection :: model.lazers
            in
                ({ model | lazers = newLazer }, run IncrementIndex)
        ClearLazers pos ->
            ({ model | lazers = []}, run ClearIndex)
        IncrementIndex ->
            ({ model | index = model.index + 1 }, Cmd.none)
        ClearIndex ->
            ({ model | index = 0}, Cmd.none)
        FrameEvent tick ->
            let 
                newAngle = 
                    if model.isMouseDown then
                        if model.pointerAngle > 350 then
                            0
                        else
                            model.pointerAngle + 5
                    else
                        model.pointerAngle
            in
                ({ model | pointerAngle = newAngle }, run MassAnimationUpdate)
        MassAnimationUpdate ->
            let 
                newList = List.map (runUpdateOnLazer model) model.lazers
            in
                ({ model | lazers = newList }, Cmd.none)


---- Lazer Update ----


runUpdateOnLazer : Model -> Lazer -> Lazer
runUpdateOnLazer model lazer = 
    let 
        newCurWidth =
            if lazer.cur_width < lazer.width then
                lazer.cur_width + 50
            else
                lazer.width
        currRotate =
            if lazer.rotate <= 90 then
                lazer.rotate
            else if lazer.rotate <= 180 then
                lazer.rotate - 90
            else if lazer.rotate <= 270 then
                lazer.rotate - 180
            else
                lazer.rotate - 270
        newX =
            if lazer.rotate <= 90 then
                lazer.x_pos - (currRotate / ((90 - currRotate) / 3.6))
            else if lazer.rotate <= 180 then
                lazer.x_pos - (currRotate / ((currRotate) / 3.6))
            else if lazer.rotate <= 270 then
                lazer.x_pos + (currRotate / ((90 - currRotate) / 3.6))
            else
                lazer.x_pos + (currRotate / ((currRotate) / 3.6))
        newY = 
            if lazer.rotate <= 90 then
                lazer.y_pos + (currRotate / ((currRotate) / 3.6))
            else if lazer.rotate <= 180 then
                lazer.y_pos - (currRotate / ((90 - currRotate) / 3.6))
            else if lazer.rotate <= 270 then
                lazer.y_pos - (currRotate / ((currRotate) / 3.6))
            else
                lazer.y_pos + (currRotate / ((90 - currRotate) / 3.6))
    in
        Lazer lazer.id lazer.initial_x lazer.initial_y newX newY lazer.target_x lazer.target_y lazer.width lazer.width 
        lazer.height lazer.rotate lazer.gradientDirection


---- Utilities ----
    
run : Msg -> Cmd Msg
run message = 
    Task.perform (always message) (Task.succeed ())

toString : Int -> String
toString a =    
    String.fromInt(a)



