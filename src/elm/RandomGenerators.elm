module RandomGenerators exposing (..)

import Random exposing (..)
import Messages exposing (..)
import Task exposing (..)

---- RANDOM COMMANDS ----

betweenWidthBounds : Generator Int
betweenWidthBounds = int 50 500

betweenHeightBounds : Generator Int
betweenHeightBounds = int 1 5
