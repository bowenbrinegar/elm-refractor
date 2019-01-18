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
                target_x =
                    if num <= 45 then
                        (toFloat (model.y - clientY) * tan (model.pointerAngle - 45))
                    else if num <= 90 then 
                        0.0
                    else if num <= 135 then 
                        0.0
                    else if num <= 180 then 
                        (toFloat model.y) * tan (model.pointerAngle - 180)
                    else if num <= 225 then
                        (toFloat model.y) * tan (model.pointerAngle - 225)
                    else if num <= 270 then
                        toFloat clientX
                    else if num <= 315 then
                        toFloat clientX
                    else    
                        (toFloat model.y) * tan (model.pointerAngle - 360)
                target_y =
                    if num <= 45 then
                        toFloat clientY
                    else if num <= 90 then 
                        toFloat (model.x) * tan (model.pointerAngle - 90)
                    else if num <= 135 then 
                        toFloat (model.x) * tan (model.pointerAngle - 135)
                    else if num <= 180 then 
                        0.0
                    else if num <= 225 then
                        0.0
                    else if num <= 270 then
                        (toFloat (model.x - clientX)) * tan (model.pointerAngle - 270)
                    else if num <= 315 then
                        (toFloat (model.x - clientX)) * tan (model.pointerAngle - 315)
                    else
                        toFloat clientY

                xerpos = Debug.log "x_pos" model.x
                xer = Debug.log "target x" target_x
                yerpos = Debug.log "y_pos" model.y
                yer = Debug.log "target y" target_y
                gradientDirection = 
                    if model.pointerAngle <= 180 then
                        "to left"
                    else
                        "to right"
                newLazer =
                    Lazer model.index model.x model.y target_x target_y 0 (model.w) 
                    (model.h) model.pointerAngle gradientDirection
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
                            model.pointerAngle + (tick)
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
        newX = 
            if lazer.target_x == 0.0 then
                lazer.x_pos - round (toFloat lazer.x_pos * 0.03)                
            else
                lazer.x_pos + round (lazer.target_x * 0.03)
        newY = 
            if lazer.target_y == 0.0 then
                lazer.y_pos - round (toFloat lazer.y_pos * 0.03)                
            else
                lazer.y_pos + round (lazer.target_y * 0.03)
        newLazer = 
            Lazer lazer.id newX newY lazer.target_x lazer.target_y newCurWidth lazer.width 
            lazer.height lazer.rotate lazer.gradientDirection

    in
        newLazer


---- Utilities ----
    
run : Msg -> Cmd Msg
run message = 
    Task.perform (always message) (Task.succeed ())

toString : Int -> String
toString a =    
    String.fromInt(a)



