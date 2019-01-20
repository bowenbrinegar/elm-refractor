module Models exposing (..)

import Random exposing (..)
import Json.Decode as Json exposing (Decoder)
import Json.Encode as Encode
import Json.Decode.Pipeline as Pipe

type alias Model = 
    {
        lazers: List Lazer,
        index: Int,
        seed: Seed,
        x: Int,
        y: Int,
        w: Int,
        h: Int,
        div_w : Int,
        div_h : Int,
        pointerAngle: Float,
        isMouseDown: Bool
    }

initialModel : Model
initialModel = 
    {
        lazers = [],
        index = 0,
        seed = Random.initialSeed 50,
        x = 0,
        y = 0,
        w = 0,
        h = 0,
        div_w = 0,
        div_h = 0,
        pointerAngle = 225.0,
        isMouseDown = False
    }
    
type alias LazerId =
    Int

type alias Lazer = 
    {
        id : LazerId,
        initial_x : Int,
        initial_y : Int,
        x_pos : Float,
        y_pos : Float,
        target_x : Float,
        target_y : Float,
        cur_width: Int,
        width : Int,
        height : Int,
        rotate : Float,
        gradientDirection : String
    }
    
type alias Coords = 
    { 
        x : Int, 
        y : Int,
        w : Int,
        h : Int
    }



