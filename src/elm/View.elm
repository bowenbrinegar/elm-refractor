module View exposing (..)

import Html exposing (Html, text, div, h1, img, button, Attribute)
import Html.Attributes exposing (src, class, style)
import Html.Events exposing (..)
import Models exposing (..)
import Messages exposing (..)
import Json.Decode as Json exposing (Decoder)
import Json.Decode.Pipeline as Pipe exposing (..)
import Browser.Events exposing (onClick, onAnimationFrame)

view : Model -> Html Msg
view model =
    div []
        [   div [class "header-container"] [
                header,
                h1 [] [text (String.fromInt (round model.pointerAngle))]
            ],
            cannonPointer model,
            div [
                class "lazer-container",
                on "mousedown" (Json.map MouseDown eventDecoder),
                on "mouseup" (Json.map MouseUp eventDecoder)

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

cannonPointer : Model -> Html Msg
cannonPointer model = 
    if model.isMouseDown then
        div [
            class "cannon",
            style "left" (String.fromInt model.x ++ "px"),
            style "top" (String.fromInt model.y ++ "px"),
            style "transform" ("rotate(" ++ String.fromFloat (model.pointerAngle + 90) ++ "deg" ),
            on "mouseup" (Json.map MouseUp eventDecoder)
        ] []
    else
        div [] []

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
        style "width" (String.fromInt lazer.cur_width ++ "px"),
        style "height" (String.fromInt lazer.height ++ "px"),
        style "left" (String.fromInt lazer.x_pos ++ "px"),
        style "top" (String.fromInt lazer.y_pos ++ "px"),
        style "transform" ("rotate(" ++ String.fromFloat lazer.rotate ++ "deg" ),
        style "background" ("linear-gradient(" ++ lazer.gradientDirection ++ ", rgba(48,202,244,1) 0%,rgba(48,202,244,0.99) 1%,rgba(125,185,232,0.02) 97%,rgba(125,185,232,0) 99%);")
    ] [
        h1 [] [text (String.fromInt (round(lazer.y_ratio / lazer.x_ratio)))]
    ]
    