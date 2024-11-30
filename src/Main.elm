module Main exposing (main)

import Browser
import Browser.Events as Events
import Color as C
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import FeatherIcons as Icons
import Html exposing (Html)
import Html.Attributes as Attr
import Random
import Theme
import TiledLines
import Util



-- Main --


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Events.onResize (\width height -> WindowResized { width = toFloat width, height = toFloat height })
        }



-- Init --


type alias Model =
    { drawingModel : TiledLines.Model, scrollBarWidth : Float }


type alias Flags =
    { windowWidth : Float, windowHeight : Float, scrollBarWidth : Float }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        drawingSettings : TiledLines.Settings
        drawingSettings =
            { width = flags.windowWidth - flags.scrollBarWidth
            , height = flags.windowHeight
            , stepSize = 20
            , strokeColor = Theme.theme.highlightHigh
            , backgroundColor = Theme.theme.base
            }

        model : Model
        model =
            { drawingModel = { settings = drawingSettings, drawingDirections = Nothing }
            , scrollBarWidth = flags.scrollBarWidth
            }
    in
    ( model, Random.generate Ready <| TiledLines.generateDirections drawingSettings )



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


-- todo: Honestly, I'm tinkering enough with things that require CSS that I should just actually go learn CSS
h1 : List (Attr () msg) -> String -> Element msg
h1 attributes content =
    el (attributes ++ [ Font.size 60, Font.heavy ]) (text content)


h2 : List (Attr () msg) -> String -> Element msg
h2 attributes content =
    el (attributes ++ [ Font.size 40, Font.heavy ]) (text content)


splashScreen : Model -> Element msg
splashScreen model =
    el
        [ width fill
        , htmlAttribute <| Attr.style "min-height" "100vh"
        , behindContent <| el [ height fill, width fill ] <| Element.html <| TiledLines.view model.drawingModel
        ]
    <|
        column [ centerX, centerY, padding 5, spacing 5 ]
            [ h1 [ centerX ] "Jack Glass"
            , h2 [ centerX, Font.color <| fromRgb <| C.toRgba Theme.theme.pine ] "A Curious Software Engineer"
            , row [ centerX ]
                [ linkTreeIcon Icons.github "https://github.com/jackadrianglass"
                , linkTreeIcon Icons.linkedin "https://www.linkedin.com/in/jack-glass-561944129/"

                -- todo: do something different with the email
                -- maybe have it copy to clipboard?
                , linkTreeIcon Icons.mail "jackadrianglass@gmail.com"
                ]
            ]


about =
    column [ width fill, centerX ]
        [ h1 [ centerX, Font.center ] "About"
        , image [width <| px 150] { src = "ferris.svg", description = "placeholder for an actual thing" }
        ]


view : Model -> Html msg
view model =
    layout
        -- todo: Add a switch from light mode to dark mode
        [ Font.color <| fromRgb <| C.toRgba Theme.theme.text
        , Font.size 18

        -- todo: Tinker with the font
        , Font.family
            [ Font.typeface "Open Sans"
            , Font.sansSerif
            ]
        , Background.color <| fromRgb <| C.toRgba Theme.theme.base
        ]
    <|
        column [ width fill, spacing 30 ]
            [ splashScreen model
            , about
            , h1 [ centerX, Font.center ] "more icecream please!"
            , textColumn [ centerX ] <| List.repeat 10 (paragraph [] [ text Util.fillerParagraph ])
            ]



-- Update --


type Msg
    = Ready (List Int)
    | WindowResized { width : Float, height : Float }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Ready directions ->
            let
                old =
                    model.drawingModel

                newDrawing =
                    { old | drawingDirections = Just directions }
            in
            ( { model | drawingModel = newDrawing }, Cmd.none )

        WindowResized dimensions ->
            let
                oldSettings =
                    model.drawingModel.settings

                newSettings =
                    { oldSettings | width = dimensions.width - model.scrollBarWidth, height = dimensions.height }

                oldDrawingModel =
                    model.drawingModel

                newDrawingModel =
                    { oldDrawingModel | settings = newSettings, drawingDirections = Nothing }

                newModel =
                    { model | drawingModel = newDrawingModel }
            in
            ( newModel, Random.generate Ready <| TiledLines.generateDirections newSettings )
