module Messages exposing (..)

type Msg
    = FireTheCannons
    | Randomize
    | RandomX
    | RandomY
    | RandomW
    | RandomH
    | SetX Int
    | SetY Int
    | SetW Int
    | SetH Int
    | CreateLazer
    | IncrementIndex
    | ClearLazers
    | ClearIndex