module Tests exposing (..)

import Expect
import Main exposing (..)
import Test exposing (..)


all : Test
all =
    describe "KFZAPP search"
        [ describe "toSearch"
            [ test "empty input gives Empty" <|
                \_ ->
                    Expect.equal Empty (toSearch "")
            , test "non-empty input gives Value" <|
                \_ ->
                    Expect.equal (Value "BNA") (toSearch "BNA")
            ]
        , describe "findPlate"
            [ test "Empty finds nothing" <|
                \_ ->
                    Expect.equal Nothing (findPlate Empty platesData)
            , test "exact code finds the district" <|
                \_ ->
                    findPlate (Value "B") platesData
                        |> Maybe.map .name
                        |> Expect.equal (Just "Berlin")
            , test "lookup is case-insensitive" <|
                \_ ->
                    findPlate (Value "bna") platesData
                        |> Maybe.map .name
                        |> Expect.equal (Just "Leipzig")
            , test "unknown code finds nothing" <|
                \_ ->
                    Expect.equal Nothing (findPlate (Value "ZZZ") platesData)
            ]
        , describe "display strings (README example: BNA)"
            [ test "plateString shows the district name" <|
                \_ ->
                    Expect.equal "Leipzig"
                        (plateString { search = Value "BNA", plates = platesData })
            , test "plateDetail shows origin and Bundesland" <|
                \_ ->
                    Expect.equal "Borna, Sachsen"
                        (plateDetail { search = Value "BNA", plates = platesData })
            , test "plateDetail without origin shows only the Bundesland" <|
                \_ ->
                    Expect.equal "Berlin"
                        (plateDetail { search = Value "B", plates = platesData })
            , test "empty search shows nothing" <|
                \_ ->
                    Expect.all
                        [ \model -> Expect.equal "" (plateString model)
                        , \model -> Expect.equal "" (plateDetail model)
                        ]
                        { search = Empty, plates = platesData }
            ]
        , describe "update"
            [ test "Change stores the typed value" <|
                \_ ->
                    update (Change "bn") (Tuple.first init)
                        |> Tuple.first
                        |> .search
                        |> Expect.equal (Value "bn")
            , test "clearing the input empties the search" <|
                \_ ->
                    update (Change "") (Tuple.first init)
                        |> Tuple.first
                        |> .search
                        |> Expect.equal Empty
            ]
        , describe "platesData"
            [ test "contains the Bundeswehr codes X and Y" <|
                \_ ->
                    Expect.all
                        [ \plates ->
                            findPlate (Value "X") plates
                                |> Maybe.map .name
                                |> Expect.equal (Just "Bundeswehr für NATO-Hauptquartiere")
                        , \plates ->
                            findPlate (Value "Y") plates
                                |> Maybe.map .name
                                |> Expect.equal (Just "Bundeswehr")
                        ]
                        platesData
            ]
        ]
