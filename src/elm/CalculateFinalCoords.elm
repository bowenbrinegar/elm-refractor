module CalculateFinalCoords exposing (..)

import Models exposing (..)
import LazerCalibration exposing (..)


calculateFinalXY : Model -> Lazer -> Lazer
calculateFinalXY model lazer = 
    let
        x = lazer.x_pos
        y = lazer.y_pos
        rotate = lazer.rotate
        angle = lazer.angle
        run = xCalibration angle rotate
        rise = yCalibration angle rotate
        finalW = toFloat model.div_w
        finalH = toFloat model.div_h
        finalCoords = 
            if rotate <= 90 then
                runRR90 x y rise run 0 finalH lazer
            else if rotate <= 180 then
                runRR180 x y rise run 0 0 lazer
            else if rotate <= 270 then
                runRR270 x y rise run finalW 0 lazer
            else
                runRR360 x y rise run finalW finalH lazer
    in
        Lazer lazer.id lazer.initial_x lazer.initial_y lazer.x_pos lazer.y_pos finalCoords.x finalCoords.y
        lazer.cur_width lazer.width lazer.height lazer.rotate lazer.gradientDirection
        lazer.angle lazer.isRefraction



runRR90 : Float -> Float -> Float -> Float -> Float -> Float -> Lazer -> FinalCoords
runRR90 x y rise run finalW finalH lazer =
    let
        cur_x =
            if x - run > finalW then
                x - run
            else
                x 
        cur_y =
            if y + rise < finalH then
                y + rise
            else
                y
        hit_x = cur_x - run < finalW
        hit_y = cur_y + rise > finalH 
    in
        if (hit_y || hit_x) then    
            FinalCoords cur_x cur_y
        else
            runRR90 cur_x cur_y rise run finalW finalH lazer

runRR180 : Float -> Float -> Float -> Float -> Float -> Float -> Lazer -> FinalCoords
runRR180 x y rise run finalW finalH lazer =
    let
        cur_x =
            if x - run > finalW then
                x - run
            else
                x 
        cur_y =
            if y - rise > finalH then
                y - rise
            else
                y
        hit_x = cur_x - run < finalW
        hit_y = cur_y - rise < finalH 
    in
        if (hit_y || hit_x) then    
            FinalCoords cur_x cur_y
        else
            runRR180 cur_x cur_y rise run finalW finalH lazer
    
runRR270 : Float -> Float -> Float -> Float -> Float -> Float -> Lazer -> FinalCoords
runRR270 x y rise run finalW finalH lazer =
    let
        cur_x =
            if x + run < finalW then
                x + run
            else
                x
        cur_y =
            if y - rise > finalH then
                y - rise
            else
                y
        hit_x = cur_x + run > finalW
        hit_y = cur_y - rise < finalH
    in
        if (hit_y || hit_x) then    
            FinalCoords cur_x cur_y
        else
            runRR270 cur_x cur_y rise run finalW finalH lazer

runRR360 : Float -> Float -> Float -> Float -> Float -> Float -> Lazer -> FinalCoords
runRR360 x y rise run finalW finalH lazer =
    let
        cur_x =
            if x + run < finalW then
                x + run
            else
                x
        cur_y =
            if y + rise < finalH then
                y + rise
            else
                y

        hit_x = cur_x + run > finalW
        hit_y = cur_y + rise > finalH
    in
        if (hit_y || hit_x) then    
            FinalCoords cur_x cur_y
        else
            runRR360 cur_x cur_y rise run finalW finalH lazer
    