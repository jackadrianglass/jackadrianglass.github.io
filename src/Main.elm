module Main exposing (main)

import Browser
import Browser.Events as Events
import Color as C
import Color.Convert exposing (colorToCssRgb)
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
        , subscriptions =
            \_ ->
                Events.onResize
                    (\width height ->
                        WindowResized
                            { width = toFloat width
                            , height = toFloat height
                            }
                    )
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


linkTreeIcon : Icons.Icon -> String -> Html.Html msg
linkTreeIcon icon url =
    Html.a [ Attr.href url ]
        [ icon
            |> Icons.withSize 2
            |> Icons.withSizeUnit "em"
            |> Icons.toHtml [ Attr.style "color" (colorToCssRgb Theme.theme.rose) ]
        ]


splashScreen : Model -> Html.Html msg
splashScreen model =
    Html.div
        [ Attr.style "min-height" "100vh"
        , Attr.style "min-width" "100vw"
        , Attr.style "display" "flex"
        , Attr.style "justify-content" "center"
        , Attr.style "align-content" "center"
        ]
        [ Html.div
            [ Attr.style "z-index" "-1"
            , Attr.style "position" "absolute"
            , Attr.style "display" "block"
            ]
            [ TiledLines.view model.drawingModel ]
        , Html.div
            [ Attr.style "z-index" "auto"
            , Attr.style "justify-content" "center"
            , Attr.style "align-content" "center"
            ]
            [ Html.div
                [ Attr.style "border" ("solid " ++ colorToCssRgb Theme.theme.highlightHigh)
                , Attr.style "border-radius" "3ch"
                , Attr.style "padding" "2ch"
                , Attr.style "background-color" (colorToCssRgb Theme.theme.base)
                , Attr.style "font-size" "1.5rem"
                ]
                [ Html.h1 [ Attr.style "text-align" "center" ] [ Html.text "Jack Glass" ]
                , Html.div
                    [ Attr.style "display" "flex"
                    , Attr.style "justify-content" "space-around"
                    , Attr.style "width" "100%"
                    ]
                    [ linkTreeIcon Icons.github "https://github.com/jackadrianglass"
                    , linkTreeIcon Icons.linkedin "https://www.linkedin.com/in/jack-glass-561944129/"

                    -- todo: do something different with the email
                    -- maybe have it copy to clipboard?
                    , linkTreeIcon Icons.mail "jackadrianglass@gmail.com"
                    ]
                ]
            ]
        ]


about =
    Html.div [ Attr.class "card" ]
        [ Html.img [ Attr.class "card-img", Attr.src "headshot.jpeg" ] [ Html.text "Jack's Beautiful Face" ]
        , Html.div [ Attr.class "card-content" ]
            [ Html.h1 [] [ Html.text "About" ]
            , Html.p [] [ Html.text Util.fillerParagraph ]
            ]
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
            [ html (splashScreen model)
            , html (Html.hr [] [])
            , html about
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
