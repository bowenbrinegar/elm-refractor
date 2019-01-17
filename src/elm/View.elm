module View exposing (..)

import Html exposing (Html, text, div, h1, img, button, Attribute)
import Html.Attributes exposing (src, class, style)
import Html.Events exposing (..)
import Models exposing (..)
import Messages exposing (..)
import Json.Decode as Json exposing (Decoder)
import Json.Decode.Pipeline as Pipe exposing (..)
import Browser.Events exposing (onClick)

view : Model -> Html Msg
view model =
    div []
        [   div [class "header-container"] [
                header
            ],
            div [
                    class "lazer-container",
                    on "mousedown" (Json.map SetCoords eventDecoder)
                ]
                (model.lazers |> List.map renderLazer)           
        ]

eventDecoder : Decoder Coords
eventDecoder =
    Json.map2 Coords
        (Json.at ["clientX"] Json.int)
        (Json.at ["clientY"] Json.int)     

renderIndex : String -> Html h1
renderIndex a =
    let
        num = a
    in
        h1 [] [ text num ]

header : Html Msg
header = 
    div []
        [
            img [ src "/logo.svg", on "click" (Json.map ClearLazers eventDecoder)] [],
            h1 [] [ text "Space Lazers!"]
        ]

renderLazer : Lazer -> Html msg
renderLazer lazer =
    div [
        class "space-lazer", 
        style "width" (lazer.width ++ "px"),
        style "height" (lazer.height ++ "px"),
        style "left" (lazer.x_pos ++ "px"),
        style "top" (lazer.y_pos ++ "px")
    ] []
    