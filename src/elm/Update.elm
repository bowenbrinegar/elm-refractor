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
            ({ model | x = pos.x, y = pos.y + 45, isMouseDown = True}, Cmd.none )
        MouseUp pos -> 
            ({ model | isMouseDown = False }, run FireTheCannons)
        SetW a ->
            ({ model | w = a }, Cmd.none)
        SetH a ->
            ({ model | h = a }, Cmd.none)
        CreateLazer -> 
            let 
                x_ratio = cos model.pointerAngle
                y_ratio = sin model.pointerAngle
                gradientDirection = 
                    if model.pointerAngle <= 180 then
                        "to bottom"
                    else
                        "to top"
                newLazer =
                    Lazer model.index (model.x) (model.y) 0 (model.w) 
                    (model.h) model.pointerAngle x_ratio y_ratio gradientDirection
            in
                ({ model | lazers = newLazer :: model.lazers}, run IncrementIndex)
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
                        if model.pointerAngle > 360 then
                            0
                        else
                            model.pointerAngle + (tick * 0.2)
                    else
                        model.pointerAngle
            in
                ({ model | pointerAngle = newAngle }, run MassAnimationUpdate)
        MassAnimationUpdate ->
            let 
                newList = List.map runUpdateOnLazer model.lazers
            in
                ({ model | lazers = newList }, Cmd.none)


---- Lazer Update ----


runUpdateOnLazer : Lazer -> Lazer
runUpdateOnLazer lazer = 
    let 
        newCurWidth = 
            if lazer.cur_width < lazer.width then
                lazer.cur_width + 50
            else
                lazer.width
    
        newX = lazer.x_pos + round (lazer.x_ratio * 10)
            -- if lazer.rotate <= 90 then
            --     lazer.x_pos + round (7 * x_ratio)
            -- else if lazer.rotate <= 180 then
            --     lazer.x_pos + round (7 * x_ratio)
            -- else if lazer.rotate <= 270 then
            --     lazer.x_pos + round (-7 * x_ratio)
            -- else
            --     lazer.x_pos + round (-7 * x_ratio)
        
        newY = lazer.y_pos + round (lazer.y_ratio * 10)
            -- if lazer.rotate <= 90 then
            --     lazer.y_pos + round (7 * y_ratio)
            -- else if lazer.rotate <= 180 then
            --     lazer.y_pos + round (-7 * y_ratio)
            -- else if lazer.rotate <= 270 then
            --     lazer.y_pos + round (-7 * y_ratio)
            -- else
            --     lazer.y_pos + round (7 * y_ratio)
            
        newLazer = 
            Lazer lazer.id newX newY lazer.width lazer.width 
            lazer.height lazer.rotate lazer.x_ratio lazer.y_ratio lazer.gradientDirection
    in
        newLazer


---- Utilities ----
    
run : Msg -> Cmd Msg
run message = 
    Task.perform (always message) (Task.succeed ())

toString : Int -> String
toString a =    
    String.fromInt(a)



