module Update exposing (..)

import Messages exposing (..)
import Models exposing (..)
import Random exposing (..)
import Task exposing (..)
import Debug exposing (log)
import Json.Decode as Json exposing (Decoder)
import Json.Decode.Pipeline as PL exposing (..)
import LazerCommands exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FrameEvent tick ->
            let 
                newAngle = cannonAngle model
            in
                ({ model | pointerAngle = newAngle }, run MassAnimation)
        MassAnimation ->
            let 
                runUpdateOnLazer lazer =
                    let
                        newWidth = calculateWidth lazer.cur_width lazer.width
                        targetX = xCalibration lazer.x_pos lazer.angle lazer.rotate
                        targetY = yCalibration lazer.y_pos lazer.angle lazer.rotate
                    in
                        { lazer | x_pos = targetX, y_pos = targetY, cur_width = newWidth } 
                mappedLazers = List.map runUpdateOnLazer model.lazers
            in
                ({ model | lazers = mappedLazers}, Cmd.none)
        MouseDown pos ->
            ({ model | x = pos.x, y = pos.y, div_w = pos.w, div_h = pos.h, isMouseDown = True}, Cmd.none )
        MouseUp pos -> 
            ({ model | isMouseDown = False }, run FireTheCannons)
        FireTheCannons -> 
            (model, Cmd.batch[run CreateLazer, run IncrementIndex, run Randomize])
        CreateLazer -> 
            let
                gradientDirection = generateGradient model.pointerAngle
                angle = angleCalibration model.pointerAngle
                newLazer = createLazer model gradientDirection angle
            in
                ({ model | lazers = newLazer }, run IncrementIndex)
        ClearLazers pos ->
            ({ model | lazers = []}, run ClearIndex)
        IncrementIndex ->
            ({ model | index = model.index + 1 }, Cmd.none)
        ClearIndex ->
            ({ model | index = 0}, Cmd.none)
        Randomize -> 
            (model, Cmd.batch[generate SetW (int 50 500), generate SetH (int 1 5)])
        SetW a ->
            ({ model | w = a }, Cmd.none)
        SetH a ->
            ({ model | h = a }, Cmd.none)

---- Utilities ----
    
run : Msg -> Cmd Msg
run message = 
    Task.perform (always message) (Task.succeed ())

toString : Int -> String
toString a =    
    String.fromInt(a)



