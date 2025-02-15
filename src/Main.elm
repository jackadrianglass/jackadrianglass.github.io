module Main exposing (main)

import Browser
import Browser.Events as Events
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
            |> Icons.withSize 1.5
            |> Icons.withSizeUnit "em"
            |> Icons.withClass "link-tree-icon"
            |> Icons.toHtml []
        ]


splashScreen : Model -> Html.Html msg
splashScreen model =
    Html.div
        [ Attr.class "splash-screen" ]
        [ Html.div [ Attr.class "splash-screen-background" ] [ TiledLines.view model.drawingModel ]
        , Html.div [ Attr.class "splash-screen-foreground" ]
            [ Html.div [ Attr.class "splash-screen-box" ]
                [ Html.h1 [] [ Html.text "Jack Glass" ]
                , Html.div [ Attr.class "splash-screen-linktree" ]
                    [ linkTreeIcon Icons.github "https://github.com/jackadrianglass"
                    , linkTreeIcon Icons.linkedin "https://www.linkedin.com/in/jack-glass-561944129/"

                    -- todo: do something different with the email
                    -- maybe have it copy to clipboard?
                    , linkTreeIcon Icons.mail "jackadrianglass@gmail.com"
                    ]
                ]
            ]
        ]


about : Html msg
about =
    Html.div [ Attr.class "card" ]
        [ Html.div [ Attr.class "card-content" ]
            [ Html.h1 [] [ Html.text "About" ]
            , Html.p []
                [ Html.text
                    """
I’m a Calgary-based software engineer with 6+ years of development experience
building applications ranging from embedded systems programming on a cycling dynamics
pedal, to distributed backend development for high performance geospatial computation.
My work has involved many languages and libraries including
"""
                ]
            , Html.br [] []
            , Html.ul []
                -- todo: Ideally I'd like some iconography for the technologies that I've used but this is good enough for now
                [ Html.li [] [ Html.text "Rust, Axum, and protobuf for backend web development" ]
                , Html.li [] [ Html.text "C++ and Qt for gui application development" ]
                , Html.li [] [ Html.text "Python and FastApi for distributed computation" ]
                , Html.li [] [ Html.text "Devops tooling including Bazel, Waf, Python, Bash, Powershell, Docker, Jenkins, etc." ]
                , Html.li [] [ Html.text "C, ANT and BLE for low resource embedded systems" ]
                ]
            , Html.br [] []
            , Html.p [] [ Html.text """
I'm also actively involved in the Calgary software community. I host a weekly coworking
session as a recurring space for folks to work on their side projects. I'm also involved
with the Software Developers of Calgary group helping host a monthly meetup to help working
developers hone their craft.
            """ ]
            ]
        , Html.img
            [ Attr.class "card-img"
            , Attr.src "headshot.png"
            ]
            [ Html.text "Jack's Beautiful Face" ]
        ]


view : Model -> Html msg
view model =
    Html.div []
        [ splashScreen model
        , Html.br [] []
        , Html.br [] []
        , about
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
