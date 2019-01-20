module LazerCommands exposing (..)

import Task exposing (..)
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

createLazer : Model -> String -> Float -> List Lazer
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
        Lazer model.index (toFloat model.x) (toFloat model.y) 0 (model.w) 
        (model.h) model.pointerAngle gradientDir angle :: model.lazers

generateGradient : Float -> String
generateGradient angle = 
    if angle <= 180 then
        "to top"
    else
        "to bottom"

angleCalibration : Float -> Float
angleCalibration angle =
    if angle <= 90 then
        angle
    else if angle <= 180 then
        angle - 90
    else if angle <= 270 then
        angle - 180
    else
        angle - 270

calculateWidth : Int -> Int -> Int
calculateWidth curWidth maxWidth = 
    if (curWidth + 50) < maxWidth then
        curWidth + 50
    else
        maxWidth

xCalibration : Float -> Float -> Float -> Float
xCalibration xPos angle rotate = 
    if rotate <= 90 then
        xPos - ( angle / ((90 -  angle ) / 3.6))
    else if rotate <= 180 then
        xPos - ( angle / (( angle ) / 3.6))
    else if rotate <= 270 then
        xPos + ( angle / ((90 -  angle ) / 3.6))
    else
        xPos + ( angle / (( angle ) / 3.6))

yCalibration : Float -> Float -> Float -> Float
yCalibration yPos angle rotate = 
    if rotate <= 90 then
        yPos + (angle / ((angle) / 3.6))
    else if rotate <= 180 then
        yPos - (angle / ((90 - angle) / 3.6))
    else if rotate <= 270 then
        yPos - (angle / ((angle) / 3.6))
    else
        yPos + (angle / ((90 - angle) / 3.6))
