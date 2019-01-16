module RandomGenerators exposing (..)

import Random exposing (..)
import Messages exposing (..)
import Task exposing (..)

---- RANDOM COMMANDS ----

seed : Random.Seed 
seed = 
    Random.initialSeed 1

betweenXBounds : Generator Int
betweenXBounds = int 1 100

betweenYBounds : Generator Int
betweenYBounds = int 1 100

betweenWidthBounds : Generator Int
betweenWidthBounds = int 50 500

betweenHeightBounds : Generator Int
betweenHeightBounds = int 1 5
