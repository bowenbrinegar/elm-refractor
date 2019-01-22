module Utils exposing (..)

import Messages exposing (..)
import Task exposing (..)

run : Msg -> Cmd Msg
run message = 
    Task.perform (always message) (Task.succeed ())

toString : Int -> String
toString a =    
    String.fromInt(a)