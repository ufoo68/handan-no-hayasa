module Main exposing (..)

import Browser
import Html exposing (Html, button, div, h1, img, text)
import Html.Attributes exposing (hidden, style, src)
import Html.Events exposing (onClick)
import Process
import Task exposing (..)



-- MODEL


type alias Model =
    { tenguAnswer : String
    , isTimeout : Bool
    }


longTask : Task Never Judge
longTask =
    Process.sleep 2000
        |> Task.map (always Late)


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "" False
    , Task.perform Decision longTask
    )



-- UPDATE


type Judge
    = Late
    | Fast
    | Bad


type Msg
    = Decision Judge


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Decision judge ->
            case judge of
                Bad ->
                    ( { model
                        | tenguAnswer =
                            if not model.isTimeout then
                                "判断が甘い"

                            else
                                model.tenguAnswer
                        , isTimeout = True
                      }
                    , Cmd.none
                    )

                Fast ->
                    ( { model
                        | tenguAnswer =
                            if not model.isTimeout then
                                "判断が早い"
                            else
                                model.tenguAnswer
                        , isTimeout = True
                      }
                    , Cmd.none
                    )

                Late ->
                    ( { model
                        | tenguAnswer =
                            if not model.isTimeout then
                                "判断が遅い"

                            else
                                model.tenguAnswer
                        , isTimeout = True
                      }
                    , Cmd.none
                    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div
        [style "text-align" "center"]
        [ h1 [] [ text "妹が鬼になってしまった！" ]
        , button [ onClick (Decision Fast), style "font-size" "2em" ] [ text "闘う" ]
        , button [ onClick (Decision Bad), style "font-size" "2em" ] [ text "闘わない" ]
        , h1 [ hidden (not model.isTimeout) ] [ text model.tenguAnswer ]
        , img [ src "./tengu.png", hidden (not model.isTimeout) ] []
        ]


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
