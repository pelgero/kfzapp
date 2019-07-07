module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, div, form, h1, input, text)
import Html.Attributes as A
import Html.Events as E



---- MODEL ----


type alias Model =
    { search : Search
    , plates : List ( String, String )
    }


init : ( Model, Cmd Msg )
init =
    ( { search = Empty
      , plates =
            [ ( "B"
              , "Berlin"
              )
            , ( "M"
              , "München"
              )
            , ( "K"
              , "Köln"
              )
            , ( "BN"
              , "Bonn"
              )
            ]
      }
    , Cmd.none
    )



---- UPDATE ----


type Search
    = Value String
    | Empty


type Msg
    = Change String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change value ->
            ( { model | search = toSearch value }, Cmd.none )


toSearch : String -> Search
toSearch value =
    if String.isEmpty value then
        Empty

    else
        Value value



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "KFZApp" ]
        , form []
            [ input [ E.onInput Change ] []
            ]
        , div [] [ text (firstFound model.plates model.search) ]
        ]


firstFound : List ( String, String ) -> Search -> String
firstFound plates search =
    case search of
        Empty ->
            ""

        Value value ->
            plates
                |> List.filter (\( nr, name ) -> String.startsWith (String.toUpper value) nr)
                |> List.head
                |> Maybe.withDefault ( "", "Not Found" )
                |> Tuple.second



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
