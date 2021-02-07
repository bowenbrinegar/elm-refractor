module LazerRefraction exposing (..)

import LazerCreation exposing (..)
import LazerCalibration exposing (..)
import Models exposing (..)
import Messages exposing (..)
import Task exposing (..)
import Utils exposing (..)
import List.Extra exposing (filterNot, unique)

isInbounds : Model -> Lazer -> Bool
isInbounds model lazer =
    let
        halfW = toFloat model.div_w / 2
        halfH = toFloat model.div_h / 2
    in
        if (lazer.final_x > halfW) && (lazer.x_pos > toFloat model.div_w) then
            False
        else if (lazer.final_x < halfW) && (lazer.x_pos < 5) then
            False
        else if (lazer.final_y > halfH) && (lazer.y_pos > toFloat model.div_h) then
            False
        else if (lazer.final_y < halfH) && (lazer.y_pos < 5) then
            False
        else
            True

needsRefraction : Model -> Lazer -> Bool
needsRefraction model lazer =
    let
        halfW = toFloat model.div_w / 2
        halfH = toFloat model.div_h / 2
        xPositive = lazer.x_pos + toFloat lazer.width
        xNegative = lazer.x_pos - toFloat lazer.width
        yPositive = lazer.y_pos + toFloat lazer.width
        yNegative = lazer.y_pos - toFloat lazer.width
    in
        if (lazer.final_x > halfW) && (xPositive > toFloat model.div_w) then
            True
        else if (lazer.final_x < halfW) && (xNegative < 5) then
            True
        else if (lazer.final_y > halfH) && (yPositive > toFloat model.div_h) then
            True
        else if (lazer.final_y < halfH) && (yNegative < 5) then
            True
        else
            False
        

isRefraction : Model -> Lazer -> Lazer
isRefraction model lazer =
    let
        hasRefractedId incoming = lazer.id == incoming.id && incoming.isRefraction 
        checkForRefractedCopy = List.filter hasRefractedId model.lazers
        rotate = lazer.rotate
        finalW = toFloat model.div_w
        finalH = toFloat model.div_h
        width = toFloat lazer.width
        edgeBool = needsRefraction model lazer
    in
        if edgeBool then
            createRefraction model lazer
        else
            lazer

createRefraction : Model -> Lazer -> Lazer
createRefraction model lazer =
    let
        finalX = lazer.final_x
        finalY = lazer.final_y
        rotate = lazer.rotate
        angle = lazer.angle
        xPos = lazer.x_pos
        yPos = lazer.y_pos
        edge = whichWallIsTalking model lazer

        newRotate =
            case edge of
                "left-top" -> 
                    if lazer.initial_y < lazer.final_y then
                        if angle <= 45 then
                            360 - (90 - angle)
                        else
                            360 - angle
                    else
                        if angle <= 45 then
                            rotate + ((90 - angle) * 2.0)
                        else
                            rotate + ((90 - angle) * 2.0)
                "left-bottom" ->  
                    if lazer.initial_y < lazer.final_y then
                        if angle <= 45 then
                            360 - (90 - angle)
                        else
                            rotate + 180 + ((90.0 - angle) * 2.0)
                    else
                        if angle <= 45 then
                            rotate + ((90 - angle) * 2.0)
                        else
                            rotate + ((90 - angle) * 2.0)
                "right-top" -> 
                    if lazer.initial_y < lazer.final_y then
                        if angle <= 45 then
                            rotate - 180 - (angle * 2.0)
                        else    
                            rotate - 180 - (angle * 2.0)
                    else
                        if angle <= 45 then
                            rotate - ((90 - angle) * 2.0)
                        else
                            rotate - (angle * 2.0)
                "right-bottom" ->
                    if lazer.initial_y < lazer.final_y then
                        if angle <= 45 then
                            rotate - 180 - (angle * 2.0)
                        else
                            rotate - 180 - (angle * 2.0)
                    else
                        if angle <= 45 then
                            rotate - (angle * 2.0)
                        else
                            rotate - (angle * 2.0)
                "bottom-right" -> 
                    if lazer.initial_x < lazer.final_x then
                        if angle <= 45 then
                            rotate - (angle * 2.0)
                        else
                            rotate - (angle * 2.0)
                    else
                        if angle <= 45 then
                            rotate + ((90.0 - angle) * 2.0)
                        else
                            rotate + ((90.0 - angle) * 2.0)
                "bottom-left" -> 
                    if lazer.initial_x < lazer.final_x then
                        if angle <= 45 then
                            rotate - ((90.0 - angle) * 2.0)
                        else
                            rotate - (angle * 2.0)
                    else
                        if angle <= 45 then
                            rotate + (angle * 2.0)
                        else
                            rotate + (angle * 2.0)
                "top-right" -> 
                    if lazer.initial_x < lazer.final_x then
                        if angle <= 45 then
                            rotate + ((90 - angle) * 2.0)
                        else
                            rotate + ((90 - angle) * 2.0)
                    else
                        if angle <= 45 then
                            rotate - ((90 - angle) * 2.0)
                        else
                            rotate - (angle * 2.0)
                "top-left" ->
                    if lazer.initial_x < lazer.final_x then
                        if angle <= 45 then 
                            rotate - (angle * 2.0)
                        else
                            rotate + ((90.0 - angle) * 2.0)
                    else
                        if angle <= 45 then
                            rotate - (angle * 2.0)
                        else
                            rotate - (angle * 2.0)
                _ -> 0
                  
        finalNewRotate = 
            if newRotate > 360 then
                newRotate - 360
            else
                newRotate
    
        gradientDirection = generateGradient finalNewRotate
        newAngle = angleCalibration finalNewRotate
    in
        Lazer lazer.id finalX finalY finalX finalY 0 0 0 lazer.width lazer.height finalNewRotate
        gradientDirection newAngle True

whichWallIsTalking : Model -> Lazer -> String
whichWallIsTalking model lazer =
    let 
        deltaX = lazer.final_x
        deltaY = lazer.final_y
        finalW = toFloat model.div_w
        finalH = toFloat model.div_h
        halfW = finalW / 2
        halfH = finalH / 2
    in
        if (deltaX < 15) && (deltaY < halfH) then
            "left-top"
        else if (deltaX < 15) && (deltaY > halfH) then
            "left-bottom"
        else if (deltaX + 15 > finalW) && (deltaY < halfH) then
            "right-top"
        else if (deltaX + 15 > finalW) && (deltaY > halfH) then
            "right-bottom"
        else if (deltaY + 15 > finalH) && (deltaX > halfW) then
            "bottom-right"
        else if (deltaY + 15 > finalH) && (deltaX < halfW) then
            "bottom-left"
        else if (deltaY < 15) && (deltaX > halfW) then
            "top-right"
        else 
            "top-left"