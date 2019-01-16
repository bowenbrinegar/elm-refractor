module View exposing (..)

import Html exposing (Html, text, div, h1, img, button, Attribute)
import Html.Attributes exposing (src, class, style)
import Html.Events exposing (..)
import Models exposing (..)
import Messages exposing (..)

view : Model -> Html Msg
view model =
    div []
        [   div [class "header-container"] [
                header,
                renderIndex model.index
            ],
            div [class "lazer-container"] (model.lazers |> List.map renderLazer)
        ]

renderIndex : Int -> Html h1
renderIndex a =
    let
        num =  String.fromInt(a)
    in
        h1 [] [ text num ]

header : Html Msg
header = 
    div []
        [
            img [ src "/logo.svg" ] [],
            h1 [] [ text "Space Lazers!"],
            buttonGroup
        ]
  

buttonGroup : Html Msg
buttonGroup = 
    div []
        [
            button [ onClick FireTheCannons ] [text "+"],
            button [ onClick ClearLazers ] [text "-"]
        ]


renderLazer : Lazer -> Html msg
renderLazer lazer =
    div [
        class "space-lazer", 
        style  "width" (lazer.width ++ "px"),
        style "height" (lazer.height ++ "px"),
        style "left" (lazer.x_pos ++ "%"),
        style "top" (lazer.y_pos ++ "%")
    ] []
    