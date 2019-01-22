module LazerCreation exposing (..)

import Models exposing (..)

cannonAngle : Model -> Float
cannonAngle model =
    if model.isMouseDown then
        if model.pointerAngle > 355 then
            0
        else
            model.pointerAngle + 5
    else
        model.pointerAngle

createLazer : Model -> String -> Float ->  List Lazer
createLazer model gradientDir angle =
    if model.pointerAngle == 0 then
        model.lazers
    else if model.pointerAngle == 90 then
        model.lazers
    else if model.pointerAngle == 270 then
        model.lazers
    else if model.pointerAngle == 360 then
        model.lazers
    else
        Lazer model.index (toFloat model.x) (toFloat model.y) (toFloat model.x) (toFloat model.y) 0 0 0 (model.w) 
        (model.h) model.pointerAngle gradientDir angle False :: model.lazers

generateGradient : Float -> String
generateGradient angle = 
    if angle <= 180 then
        "to top"
    else
        "to bottom"


