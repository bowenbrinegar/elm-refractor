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
        x: String,
        y: String,
        w: Int,
        h: Int
    }


initialModel : Model
initialModel = 
    {
        lazers = [],
        index = 0,
        seed = Random.initialSeed 50,
        x = "0",
        y = "0",
        w = 0,
        h = 0
    }
    
type alias LazerId =
    Int

type alias Lazer = 
    {
        id : LazerId,
        x_pos : String,
        y_pos : String,
        width: String,
        height: String
    }
    
type alias Coords = 
    { 
        x : Int, 
        y : Int 
    }



