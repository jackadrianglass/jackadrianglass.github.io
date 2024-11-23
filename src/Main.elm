module Main exposing (main)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import FeatherIcons as Icons
import Html exposing (Html)
import Html.Attributes exposing (style)
import Theme
import Util



-- Main --


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- Init --


type alias Model =
    {}


init : () -> ( Model, Cmd Msg )
init _ =
    ( {}, Cmd.none )



-- View --


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


view _ =
    layout
        -- todo: This is where you put your style options
        -- see what else you can do with this
        -- todo: Add a switch from light mode to dark mode
        [ Font.color Theme.theme.text
        , Font.size 18
        , Font.family
            [ Font.typeface "Open Sans"
            , Font.sansSerif
            ]
        , Background.color Theme.theme.base
        ]
    <|
        column [ width fill, spacing 30 ]
            [ el [ width fill, htmlAttribute <| style "min-height" "100vh", splashScreen ] <|
                column [ centerX, centerY, padding 5, spacing 5 ]
                    [ h1 [ centerX, Font.color Theme.theme.pine ] "Banana"
                    , h1 [ centerX, Font.color Theme.theme.pine ] "Split"
                    , row [ centerX ]
                        [ linkTreeIcon Icons.github "https://github.com/jackadrianglass"
                        , linkTreeIcon Icons.linkedin "https://www.linkedin.com/in/jack-glass-561944129/"

                        -- todo: do something different with the email
                        , linkTreeIcon Icons.mail "jackadrianglass@gmail.com"
                        ]
                    ]
            , h1 [ centerX, Font.center ] "more icecream please!"
            , textColumn [ centerX ] <| List.repeat 10 (paragraph [] [ text Util.fillerParagraph ])
            ]



-- Update --


type Msg
    = Loading


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )
