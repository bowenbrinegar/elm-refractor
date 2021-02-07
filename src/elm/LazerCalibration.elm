module LazerCalibration exposing (..)

import Models exposing (..)

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

xCalibration : Float -> Float -> Float
xCalibration angle rotate = 
    if rotate <= 90 then
        ( angle / ((90 -  angle ) / 3.6))
    else if rotate <= 180 then
        ( angle / (( angle ) / 3.6))
    else if rotate <= 270 then
        ( angle / ((90 -  angle ) / 3.6))
    else
        ( angle / (( angle ) / 3.6))

yCalibration : Float -> Float -> Float
yCalibration angle rotate = 
    if rotate <= 90 then
        (angle / ((angle) / 3.6))
    else if rotate <= 180 then
        (angle / ((90 - angle) / 3.6))
    else if rotate <= 270 then
        (angle / ((angle) / 3.6))
    else
        (angle / ((90 - angle) / 3.6))

assessX : Float -> Float -> Float -> Float
assessX rotate xCalib xPos =
    if rotate <= 90 then
        xPos - xCalib
    else if rotate <= 180 then
        xPos - xCalib
    else if rotate <= 270 then
        xPos + xCalib
    else
        xPos + xCalib

assessY : Float -> Float -> Float -> Float
assessY rotate yCalib yPos =
    if rotate <= 90 then
        yPos + yCalib
    else if rotate <= 180 then
        yPos - yCalib
    else if rotate <= 270 then
        yPos - yCalib
    else
        yPos + yCalib