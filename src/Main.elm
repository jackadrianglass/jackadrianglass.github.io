module Main exposing (main)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import FeatherIcons as Icons
import Html exposing (Html)
import Html.Attributes exposing (style)


fillerParagraph : String
fillerParagraph =
    "Lorem ipsum odor amet, consectetuer adipiscing elit. Augue quam cubilia class varius morbi luctus faucibus. Pharetra nisi phasellus duis maximus ex vel sed quis aptent. Sagittis elementum gravida libero aptent dui consequat efficitur per imperdiet. Pharetra auctor mus suspendisse turpis, sem ad ad. Fusce iaculis placerat libero risus ac class potenti integer. Turpis dignissim purus efficitur habitant ad quam placerat. Nascetur nec cubilia hac himenaeos curabitur mi. Bibendum rutrum blandit neque ligula primis dictum dignissim pellentesque!"



-- todo: Get the light version as well https://rosepinetheme.com/palette/ingredients/


theme =
    -- todo: How do I get fonts to be scaled appropriately for headings and content
    { base = rgb255 25 23 36
    , surface = rgb255 31 29 46
    , overlay = rgb255 38 35 58
    , muted = rgb255 110 106 134
    , subtle = rgb255 144 140 170
    , text = rgb255 224 222 244
    , love = rgb255 235 111 146
    , gold = rgb255 246 193 119
    , rose = rgb255 235 188 186
    , pine = rgb255 49 116 143
    , foam = rgb255 156 207 216
    , iris = rgb255 196 167 231
    , highlightLow = rgb255 33 32 46
    , highlightMed = rgb255 64 61 82
    , highlightHigh = rgb255 82 79 103
    }


linkTreeIcon : Icons.Icon -> String -> Element msg
linkTreeIcon icon url =
    link []
        { url = url
        , label =
            icon
                |> Icons.withSize 30
                |> Icons.toHtml []
                |> html
        }


h1 : List (Attr () msg) -> String -> Element msg
h1 attributes content =
    el (attributes ++ [ Font.size 60, Font.heavy ]) (text content)


splashScreen : Attribute msg
splashScreen =
    -- todo: Make this the animation rather than an image
    -- some ideas could be any of the simple canvas examples from the coding train. Could have it cycle on a timer or on page load
    behindContent <| el [ height fill, width fill ] <| image [ height fill, centerX ] { src = "https://cdn-icons-png.flaticon.com/512/6482/6482627.png", description = "" }


main : Html msg
main =
    layout
        -- todo: This is where you put your style options
        -- see what else you can do with this
        -- todo: Add a switch from light mode to dark mode
        [ Font.color theme.text
        , Font.size 18
        , Font.family
            [ Font.typeface "Open Sans"
            , Font.sansSerif
            ]
        , Background.color theme.base
        ]
    <|
        column [ width fill, spacing 30 ]
            [ el [ width fill, htmlAttribute <| style "min-height" "100vh", splashScreen ] <|
                column [ centerX, centerY, padding 5, spacing 5 ]
                    [ h1 [ centerX, Font.color theme.pine ] "Banana"
                    , h1 [ centerX, Font.color theme.pine ] "Split"
                    , row [ centerX ]
                        [ linkTreeIcon Icons.github "https://github.com/jackadrianglass"
                        , linkTreeIcon Icons.linkedin "https://www.linkedin.com/in/jack-glass-561944129/"
                        -- todo: do something different with the email
                        , linkTreeIcon Icons.mail "jackadrianglass@gmail.com"
                        ]
                    ]
            , h1 [ centerX, Font.center ] "more icecream please!"
            , textColumn [ centerX ] <| List.repeat 10 (paragraph [] [ text fillerParagraph ])
            ]
