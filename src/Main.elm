module Main exposing (Model, Msg(..), Plate, Search(..), findPlate, init, main, plateDetail, plateString, platesData, toSearch, update, view)

import Browser
import Html exposing (Html, a, div, form, h1, input, span, text)
import Html.Attributes as A
import Html.Events as E
import Url



---- MODEL ----


type Search
    = Value String
    | Empty


type alias Plate =
    { key : String
    , name : String
    , region : String
    , origin : String
    }


type alias Model =
    { search : Search
    , plates : List Plate
    }


init : ( Model, Cmd Msg )
init =
    ( { search = Empty
      , plates = platesData
      }
    , Cmd.none
    )



---- UPDATE ----


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
        [ div [ A.class "plate-input" ]
            [ div [ A.class "eu-band" ]
                [ div [ A.class "eu-stars" ] (List.map euStar (List.range 0 11))
                , div [ A.class "eu-d" ] [ text "D" ]
                ]
            , input
                [ E.onInput Change, A.maxlength 3, A.autofocus True ]
                []
            ]
        , div []
            [ h1 [] [ text (plateString model) ]
            , div [ A.class "plate-detail" ] [ text (plateDetail model) ]
            , mapsLink model
            ]
        ]


euStar : Int -> Html Msg
euStar i =
    let
        angle =
            (toFloat i * 30 - 90) * pi / 180

        left =
            50 + 38 * cos angle

        top =
            50 + 38 * sin angle
    in
    span
        [ A.class "eu-star"
        , A.style "left" (String.fromFloat left ++ "%")
        , A.style "top" (String.fromFloat top ++ "%")
        ]
        [ text "★" ]


plateString : Model -> String
plateString { plates, search } =
    plates
        |> findPlate search
        |> nameOrNotFound


findPlate : Search -> List Plate -> Maybe Plate
findPlate search plates =
    case search of
        Empty ->
            Nothing

        Value value ->
            plates
                |> List.filter (\{ key, name, region } -> String.toUpper value == key)
                |> List.head


nameOrNotFound : Maybe Plate -> String
nameOrNotFound plate =
    case plate of
        Just { name } ->
            name

        Nothing ->
            ""


plateDetail : Model -> String
plateDetail { plates, search } =
    plates
        |> findPlate search
        |> detailOrEmpty


detailOrEmpty : Maybe Plate -> String
detailOrEmpty plate =
    case plate of
        Just { origin, region } ->
            if String.isEmpty origin then
                region

            else
                origin ++ ", " ++ region

        Nothing ->
            ""


mapsLink : Model -> Html Msg
mapsLink { plates, search } =
    case findPlate search plates of
        Just { name } ->
            a
                [ A.href ("https://www.google.com/maps/search/?api=1&query=" ++ Url.percentEncode name)
                , A.target "_blank"
                , A.rel "noopener"
                , A.class "maps-link"
                ]
                [ text "📍 Show on Google Maps" ]

        Nothing ->
            text ""



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }



---- DATA ----


platesData =
    [ { key = "A", name = "Augsburg", region = "Bayern", origin = "" }
    , { key = "AA", name = "Ostalbkreis", region = "Baden-Württemberg", origin = "Aalen" }
    , { key = "AB", name = "Aschaffenburg", region = "Bayern", origin = "" }
    , { key = "ABG", name = "Altenburger Land", region = "Thüringen", origin = "Altenburg" }
    , { key = "ABI", name = "Anhalt-Bitterfeld", region = "Sachsen-Anhalt", origin = "" }
    , { key = "AC", name = "Aachen", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "AE", name = "Vogtlandkreis", region = "Sachsen", origin = "Auerbach" }
    , { key = "AH", name = "Borken", region = "Nordrhein-Westfalen", origin = "Ahaus" }
    , { key = "AIB", name = "München, Rosenheim", region = "Bayern", origin = "Aibling" }
    , { key = "AIC", name = "Aichach-Friedberg", region = "Bayern", origin = "Aichach" }
    , { key = "AK", name = "Altenkirchen (Westerwald)", region = "Rheinland-Pfalz", origin = "Altenkirchen" }
    , { key = "ALF", name = "Hildesheim", region = "Niedersachsen", origin = "Alfeld" }
    , { key = "ALZ", name = "Aschaffenburg", region = "Bayern", origin = "Alzenau" }
    , { key = "AM", name = "Amberg, Stadt", region = "Bayern", origin = "" }
    , { key = "AN", name = "Ansbach", region = "Bayern", origin = "" }
    , { key = "ANA", name = "Erzgebirgskreis", region = "Sachsen", origin = "Annaberg" }
    , { key = "ANG", name = "Uckermark", region = "Brandenburg", origin = "Angermünde" }
    , { key = "ANK", name = "Vorpommern-Greifswald", region = "Mecklenburg-Vorpommern", origin = "Anklam" }
    , { key = "AP", name = "Weimarer Land", region = "Thüringen", origin = "Apolda" }
    , { key = "APD", name = "Weimarer Land", region = "Thüringen", origin = "Apolda" }
    , { key = "ARN", name = "Ilm-Kreis", region = "Thüringen", origin = "Arnstadt" }
    , { key = "ART", name = "Kyffhäuserkreis", region = "Thüringen", origin = "Artern" }
    , { key = "AS", name = "Amberg-Sulzbach", region = "Bayern", origin = "Amberg, Sulzbach" }
    , { key = "ASL", name = "Salzlandkreis", region = "Sachsen-Anhalt", origin = "Aschersleben" }
    , { key = "ASZ", name = "Erzgebirgskreis", region = "Sachsen", origin = "Aue, Schwarzenberg" }
    , { key = "AT", name = "Mecklenburgische Seenplatte", region = "Mecklenburg-Vorpommern", origin = "Altentreptow" }
    , { key = "AU", name = "Erzgebirgskreis", region = "Sachsen", origin = "Aue" }
    , { key = "AUR", name = "Aurich", region = "Niedersachsen", origin = "" }
    , { key = "AW", name = "Ahrweiler", region = "Rheinland-Pfalz", origin = "" }
    , { key = "AZ", name = "Alzey-Worms", region = "Rheinland-Pfalz", origin = "Alzey" }
    , { key = "AZE", name = "Anhalt-Bitterfeld", region = "Sachsen-Anhalt", origin = "Landkreis Anhalt-Zerbst (bis 2007)" }
    , { key = "AÖ", name = "Altötting", region = "Bayern", origin = "" }
    , { key = "B", name = "Berlin", region = "Berlin", origin = "" }
    , { key = "BA", name = "Bamberg", region = "Bayern", origin = "" }
    , { key = "BAD", name = "Baden-Baden, Stadt", region = "Baden-Württemberg", origin = "" }
    , { key = "BAR", name = "Barnim", region = "Brandenburg", origin = "" }
    , { key = "BB", name = "Böblingen", region = "Baden-Württemberg", origin = "" }
    , { key = "BBG", name = "Salzlandkreis", region = "Sachsen-Anhalt", origin = "Bernburg" }
    , { key = "BC", name = "Biberach", region = "Baden-Württemberg", origin = "" }
    , { key = "BCH", name = "Neckar-Odenwald-Kreis", region = "Baden-Württemberg", origin = "Buchen" }
    , { key = "BE", name = "Warendorf", region = "Nordrhein-Westfalen", origin = "Beckum" }
    , { key = "BED", name = "Mittelsachsen", region = "Sachsen", origin = "Brand-Erbisdorf" }
    , { key = "BEL", name = "Potsdam-Mittelmark", region = "Brandenburg", origin = "Belzig" }
    , { key = "BER", name = "Barnim", region = "Brandenburg", origin = "Bernau" }
    , { key = "BF", name = "Steinfurt", region = "Nordrhein-Westfalen", origin = "Burgsteinfurt" }
    , { key = "BGD", name = "Berchtesgadener Land", region = "Bayern", origin = "Berchtesgaden" }
    , { key = "BGL", name = "Berchtesgadener Land", region = "Bayern", origin = "" }
    , { key = "BH", name = "Ortenaukreis, Raststatt", region = "Baden-Württemberg", origin = "Bühl" }
    , { key = "BI", name = "Bielefeld, Stadt", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "BID", name = "Marburg-Biedenkopf", region = "Hessen", origin = "Biedenkopf" }
    , { key = "BIN", name = "Mainz-Bingen", region = "Rheinland-Pfalz", origin = "Bingen" }
    , { key = "BIR", name = "Birkenfeld", region = "Rheinland-Pfalz", origin = "" }
    , { key = "BIT", name = "Eifelkreis Bitburg-Prüm", region = "Rheinland-Pfalz", origin = "Bitburg" }
    , { key = "BIW", name = "Bautzen", region = "Sachsen", origin = "Bischofswerda" }
    , { key = "BK", name = "Börde, Rems-Murr-Kreis, Schwäbisch Hall", region = "Baden-Württemberg", origin = "Backnang" }
    , { key = "BKS", name = "Bernkastel-Wittlich", region = "Rheinland-Pfalz", origin = "Bernkastel" }
    , { key = "BL", name = "Zollernalbkreis", region = "Baden-Württemberg", origin = "Balingen" }
    , { key = "BLB", name = "Siegen-Wittgenstein", region = "Nordrhein-Westfalen", origin = "Berleburg" }
    , { key = "BLK", name = "Burgenlandkreis", region = "Sachsen-Anhalt", origin = "" }
    , { key = "BM", name = "Rhein-Erft-Kreis", region = "Nordrhein-Westfalen", origin = "Bergheim" }
    , { key = "BN", name = "Bonn, Stadt", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "BNA", name = "Leipzig", region = "Sachsen", origin = "Borna" }
    , { key = "BO", name = "Bochum, Stadt", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "BOG", name = "Straubing-Bogen", region = "Bayern", origin = "Bogen" }
    , { key = "BOH", name = "Borken", region = "Nordrhein-Westfalen", origin = "Bocholt" }
    , { key = "BOR", name = "Borken", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "BOT", name = "Bottrop, Stadt", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "BR", name = "Landkreis Karlsruhe", region = "Baden-Württemberg", origin = "Bruchsal" }
    , { key = "BRA", name = "Wesermarsch", region = "Niedersachsen", origin = "Brake" }
    , { key = "BRB", name = "Brandenburg, Stadt", region = "Brandenburg", origin = "" }
    , { key = "BRG", name = "Jerichower Land", region = "Sachsen-Anhalt", origin = "Burg" }
    , { key = "BRK", name = "Bad Kissingen", region = "Bayern", origin = "Brückenau" }
    , { key = "BRL", name = "Goslar", region = "Niedersachsen", origin = "Braunlage" }
    , { key = "BRV", name = "Rotenburg (Wümme)", region = "Niedersachsen", origin = "Bremervörde" }
    , { key = "BS", name = "Braunschweig, Stadt", region = "Niedersachsen", origin = "" }
    , { key = "BSB", name = "Osnabrück", region = "Niedersachsen", origin = "Bersenbrück" }
    , { key = "BSK", name = "Oder-Spree", region = "Brandenburg", origin = "Beeskow" }
    , { key = "BT", name = "Bayreuth", region = "Bayern", origin = "" }
    , { key = "BTF", name = "Anhalt-Bitterfeld", region = "Sachsen-Anhalt", origin = "Bitterfeld" }
    , { key = "BUL", name = "Amberg-Sulzbach, Schwandorf", region = "Bayern", origin = "Burglengenfeld" }
    , { key = "BZ", name = "Bautzen", region = "Sachsen", origin = "" }
    , { key = "BÖ", name = "Börde", region = "Sachsen-Anhalt", origin = "" }
    , { key = "BÜD", name = "Wetteraukreis", region = "Hessen", origin = "Büdingen" }
    , { key = "BÜR", name = "Paderborn", region = "Nordrhein-Westfalen", origin = "Büren" }
    , { key = "BÜS", name = "Konstanz, Gemeinde Büsingen am Hochrhein", region = "Baden-Württemberg", origin = "Büsingen" }
    , { key = "BÜZ", name = "Rostock, Landkreis", region = "Mecklenburg-Vorpommern", origin = "Bützow" }
    , { key = "C", name = "Chemnitz, Stadt", region = "Sachsen", origin = "" }
    , { key = "CA", name = "Oberspreewald-Lausitz", region = "Brandenburg", origin = "Calau" }
    , { key = "CAS", name = "Recklinghausen", region = "Nordrhein-Westfalen", origin = "Castrop" }
    , { key = "CB", name = "Cottbus, Stadt", region = "Brandenburg", origin = "" }
    , { key = "CE", name = "Celle", region = "Niedersachsen", origin = "" }
    , { key = "CHA", name = "Cham", region = "Bayern", origin = "" }
    , { key = "CLP", name = "Cloppenburg", region = "Niedersachsen", origin = "" }
    , { key = "CLZ", name = "Goslar", region = "Niedersachsen", origin = "Clausthal-Zellerfeld" }
    , { key = "CO", name = "Zulassungsstelle Coburg, Zweckverband", region = "Bayern", origin = "Coburg" }
    , { key = "COC", name = "Cochem-Zell", region = "Rheinland-Pfalz", origin = "Cochem" }
    , { key = "COE", name = "Coesfeld", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "CR", name = "Schwäbisch Hall", region = "Baden-Württemberg", origin = "Crailsheim" }
    , { key = "CUX", name = "Cuxhaven", region = "Niedersachsen", origin = "" }
    , { key = "CW", name = "Calw", region = "Baden-Württemberg", origin = "" }
    , { key = "D", name = "Düsseldorf, Stadt", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "DA", name = "Darmstadt", region = "Hessen", origin = "" }
    , { key = "DAH", name = "Dachau", region = "Bayern", origin = "" }
    , { key = "DAN", name = "Lüchow-Dannenberg", region = "Niedersachsen", origin = "Dannenberg" }
    , { key = "DAU", name = "Vulkaneifel", region = "Rheinland-Pfalz", origin = "Daun" }
    , { key = "DBR", name = "Rostock, Landkreis", region = "Mecklenburg-Vorpommern", origin = "Doberan" }
    , { key = "DD", name = "Dresden, Stadt", region = "Sachsen", origin = "" }
    , { key = "DE", name = "Dessau-Roßlau, Stadt", region = "Sachsen-Anhalt", origin = "Dessau" }
    , { key = "DEG", name = "Deggendorf", region = "Bayern", origin = "" }
    , { key = "DEL", name = "Delmenhorst, Stadt", region = "Niedersachsen", origin = "" }
    , { key = "DGF", name = "Dingolfing-Landau", region = "Bayern", origin = "Dingolfing" }
    , { key = "DH", name = "Diepholz", region = "Niedersachsen", origin = "" }
    , { key = "DI", name = "Darmstadt-Dieburg", region = "Hessen", origin = "Dieburg" }
    , { key = "DIL", name = "Lahn-Dill-Kreis", region = "Hessen", origin = "Dillenburg" }
    , { key = "DIN", name = "Wesel", region = "Nordrhein-Westfalen", origin = "Dinslaken" }
    , { key = "DIZ", name = "Rhein-Lahn-Kreis", region = "Rheinland-Pfalz", origin = "Diez" }
    , { key = "DKB", name = "Ansbach", region = "Bayern", origin = "Dinkelsbühl" }
    , { key = "DL", name = "Mittelsachsen", region = "Sachsen", origin = "Döbeln" }
    , { key = "DLG", name = "Dillingen an der Donau", region = "Bayern", origin = "Dillingen" }
    , { key = "DM", name = "Mecklenburgische Seenplatte", region = "Mecklenburg-Vorpommern", origin = "Demmin" }
    , { key = "DN", name = "Düren", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "DO", name = "Dortmund, Stadt", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "DON", name = "Donau-Ries in Donauwörth", region = "Bayern", origin = "Donauwörth" }
    , { key = "DS", name = "Schwarzwald-Baar-Kreis", region = "Baden-Württemberg", origin = "Donaueschingen" }
    , { key = "DU", name = "Duisburg, Stadt", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "DUD", name = "Göttingen", region = "Niedersachsen", origin = "Duderstadt" }
    , { key = "DW", name = "Sächsische Schweiz-Osterzgebirge", region = "Sachsen", origin = "Dippoldiswalde" }
    , { key = "DZ", name = "Nordsachsen", region = "Sachsen", origin = "Delitzsch" }
    , { key = "DÜW", name = "Bad Dürkheim", region = "Rheinland-Pfalz", origin = "Dürkheim an der Weinstraße" }
    , { key = "E", name = "Essen, Stadt", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "EA", name = "Wartburgkreis", region = "Thüringen", origin = "Eisenach" }
    , { key = "EB", name = "Nordsachsen", region = "Sachsen", origin = "Eilenburg" }
    , { key = "EBE", name = "Ebersberg", region = "Bayern", origin = "" }
    , { key = "EBN", name = "Haßberge", region = "Bayern", origin = "Ebern" }
    , { key = "EBS", name = "Bayreuth, Forchheim, Kulmbach", region = "Bayern", origin = "Ebermannstadt" }
    , { key = "ECK", name = "Rendsburg-Eckernförde", region = "Schleswig-Holstein", origin = "Eckernförde" }
    , { key = "ED", name = "Erding", region = "Bayern", origin = "" }
    , { key = "EE", name = "Elbe-Elster", region = "Brandenburg", origin = "Elbe, Elster" }
    , { key = "EF", name = "Erfurt, Stadt", region = "Thüringen", origin = "" }
    , { key = "EG", name = "Rottal-Inn", region = "Bayern", origin = "Eggenfelden" }
    , { key = "EH", name = "Oder-Spree", region = "Brandenburg", origin = "Eisenhüttenstadt" }
    , { key = "EI", name = "Eichstätt", region = "Bayern", origin = "" }
    , { key = "EIC", name = "Eichsfeld", region = "Thüringen", origin = "" }
    , { key = "EIL", name = "Mansfeld-Südharz", region = "Sachsen-Anhalt", origin = "Eisleben" }
    , { key = "EIN", name = "Northeim", region = "Niedersachsen", origin = "Einbeck" }
    , { key = "EIS", name = "Saale-Holzland-Kreis", region = "Thüringen", origin = "Eisenberg" }
    , { key = "EL", name = "Emsland", region = "Niedersachsen", origin = "" }
    , { key = "EM", name = "Emmendingen", region = "Baden-Württemberg", origin = "" }
    , { key = "EMD", name = "Emden, Stadt", region = "Niedersachsen", origin = "" }
    , { key = "EMS", name = "Rhein-Lahn-Kreis", region = "Rheinland-Pfalz", origin = "Ems" }
    , { key = "EN", name = "Ennepe-Ruhr-Kreis", region = "Nordrhein-Westfalen", origin = "Ennepe" }
    , { key = "ER", name = "Erlangen, Stadt", region = "Bayern", origin = "" }
    , { key = "ERB", name = "Odenwaldkreis", region = "Hessen", origin = "Erbach" }
    , { key = "ERH", name = "Erlangen-Höchstadt", region = "Bayern", origin = "Erlangen, Höchstadt" }
    , { key = "ERK", name = "Heinsberg", region = "Nordrhein-Westfalen", origin = "Erkelenz" }
    , { key = "ERZ", name = "Erzgebirgskreis", region = "Sachsen", origin = "Erzgebirge" }
    , { key = "ES", name = "Esslingen", region = "Baden-Württemberg", origin = "" }
    , { key = "ESB", name = "Amberg-Sulzbach, Bayreuth, Neustadt a. d. Waldnaab, Nürnberger Land", region = "Bayern", origin = "Eschenbach" }
    , { key = "ESW", name = "Werra-Meißner-Kreis", region = "Hessen", origin = "Eschwege" }
    , { key = "EU", name = "Euskirchen", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "EW", name = "Barnim", region = "Brandenburg", origin = "Eberswalde" }
    , { key = "F", name = "Frankfurt/Main, Stadt", region = "Hessen", origin = "Frankfurt" }
    , { key = "FB", name = "Wetteraukreis in Friedberg Hessen", region = "Hessen", origin = "Friedberg" }
    , { key = "FD", name = "Fulda", region = "Hessen", origin = "" }
    , { key = "FDB", name = "Aichach-Friedberg", region = "Bayern", origin = "Friedberg" }
    , { key = "FDS", name = "Freudenstadt", region = "Baden-Württemberg", origin = "" }
    , { key = "FEU", name = "Ansbach", region = "Bayern", origin = "Feuchtwangen" }
    , { key = "FF", name = "Frankfurt (Oder), Stadt", region = "Brandenburg", origin = "Frankfurt" }
    , { key = "FFB", name = "Fürstenfeldbruck", region = "Bayern", origin = "" }
    , { key = "FG", name = "Mittelsachsen", region = "Sachsen", origin = "Freiberg" }
    , { key = "FI", name = "Elbe-Elster", region = "Brandenburg", origin = "Finsterwalde" }
    , { key = "FKB", name = "Waldeck-Frankenberg", region = "Hessen", origin = "Frankenberg" }
    , { key = "FL", name = "Flensburg", region = "Schleswig-Holstein", origin = "" }
    , { key = "FLÖ", name = "Mittelsachsen", region = "Sachsen", origin = "Flöha" }
    , { key = "FN", name = "Bodenseekreis", region = "Baden-Württemberg", origin = "Friedrichshafen" }
    , { key = "FO", name = "Forchheim", region = "Bayern", origin = "" }
    , { key = "FOR", name = "Spree-Neiße", region = "Brandenburg", origin = "Forst" }
    , { key = "FR", name = "Freiburg im Breisgau, Stadt, Breisgau-Hochschwarzwald", region = "Baden-Württemberg", origin = "Freiburg" }
    , { key = "FRG", name = "Freyung-Grafenau", region = "Bayern", origin = "Freyung, Grafenau" }
    , { key = "FRI", name = "Friesland", region = "Niedersachsen", origin = "" }
    , { key = "FRW", name = "Märkisch-Oderland", region = "Brandenburg", origin = "Freienwalde" }
    , { key = "FS", name = "Freising, Moosburg", region = "Bayern", origin = "Freising" }
    , { key = "FT", name = "Frankenthal (Pfalz), Stadt", region = "Rheinland-Pfalz", origin = "Frankenthal" }
    , { key = "FTL", name = "Sächsische Schweiz-Osterzgebirge", region = "Sachsen", origin = "Freital" }
    , { key = "FW", name = "Oder-Spree", region = "Brandenburg", origin = "Fürstenwalde" }
    , { key = "FZ", name = "Schwalm-Eder-Kreis", region = "Hessen", origin = "Fritzlar" }
    , { key = "FÜ", name = "Fürth", region = "Bayern", origin = "" }
    , { key = "FÜS", name = "Ostallgäu", region = "Bayern", origin = "Füssen" }
    , { key = "G", name = "Gera, Stadt", region = "Thüringen", origin = "" }
    , { key = "GA", name = "Altmarkkreis Salzwedel", region = "Sachsen-Anhalt", origin = "Gardelegen" }
    , { key = "GAN", name = "Northeim", region = "Niedersachsen", origin = "Gandersheim" }
    , { key = "GAP", name = "Garmisch-Partenkirchen", region = "Bayern", origin = "" }
    , { key = "GC", name = "Zwickau", region = "Sachsen", origin = "Glauchau" }
    , { key = "GD", name = "Ostalbkreis", region = "Baden-Württemberg", origin = "Gmünd" }
    , { key = "GDB", name = "Nordwestmecklenburg", region = "Mecklenburg-Vorpommern", origin = "Gadebusch" }
    , { key = "GE", name = "Gelsenkirchen, Stadt", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "GEL", name = "Kleve", region = "Nordrhein-Westfalen", origin = "Geldern" }
    , { key = "GEO", name = "Haßberge, Schweinfurt", region = "Bayern", origin = "Gerolzhofen" }
    , { key = "GER", name = "Germersheim", region = "Rheinland-Pfalz", origin = "" }
    , { key = "GF", name = "Gifhorn", region = "Niedersachsen", origin = "" }
    , { key = "GG", name = "Groß-Gerau", region = "Hessen", origin = "" }
    , { key = "GHA", name = "Leipzig", region = "Sachsen", origin = "Geithain" }
    , { key = "GHC", name = "Wittenberg", region = "Sachsen-Anhalt", origin = "Gräfenhainichen" }
    , { key = "GI", name = "Gießen", region = "Hessen", origin = "" }
    , { key = "GK", name = "Heinsberg", region = "Nordrhein-Westfalen", origin = "Geilenkirchen" }
    , { key = "GL", name = "Rheinisch-Bergischer Kreis", region = "Nordrhein-Westfalen", origin = "Gladbach" }
    , { key = "GLA", name = "Recklinghausen", region = "Nordrhein-Westfalen", origin = "Gladbeck" }
    , { key = "GM", name = "Oberbergischer Kreis", region = "Nordrhein-Westfalen", origin = "Gummersbach" }
    , { key = "GMN", name = "Vorpommern-Rügen", region = "Mecklenburg-Vorpommern", origin = "Grimmen" }
    , { key = "GN", name = "Main-Kinzig-Kreis", region = "Hessen", origin = "Gelnhausen" }
    , { key = "GNT", name = "Jerichower Land", region = "Sachsen-Anhalt", origin = "Genthin" }
    , { key = "GOA", name = "Rhein-Hunsrück-Kreis", region = "Rheinland-Pfalz", origin = "Sankt Goar" }
    , { key = "GOH", name = "Rhein-Lahn-Kreis", region = "Rheinland-Pfalz", origin = "Sankt Goarshausen" }
    , { key = "GP", name = "Göppingen", region = "Baden-Württemberg", origin = "" }
    , { key = "GR", name = "Görlitz", region = "Sachsen", origin = "" }
    , { key = "GRA", name = "Freyung-Grafenau", region = "Bayern", origin = "Grafenau" }
    , { key = "GRH", name = "Meißen", region = "Sachsen", origin = "Großenhain" }
    , { key = "GRI", name = "Rottal-Inn", region = "Bayern", origin = "Griesbach" }
    , { key = "GRM", name = "Leipzig", region = "Sachsen", origin = "Grimma" }
    , { key = "GRZ", name = "Greiz", region = "Thüringen", origin = "" }
    , { key = "GS", name = "Goslar", region = "Niedersachsen", origin = "" }
    , { key = "GT", name = "Gütersloh", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "GTH", name = "Gotha", region = "Thüringen", origin = "" }
    , { key = "GUB", name = "Spree-Neiße", region = "Brandenburg", origin = "Guben" }
    , { key = "GUN", name = "Weißenburg-Gunzenhausen", region = "Bayern", origin = "Gunzenhausen" }
    , { key = "GV", name = "Rhein-Kreis Neuss", region = "Nordrhein-Westfalen", origin = "Grevenbroich" }
    , { key = "GVM", name = "Nordwestmecklenburg", region = "Mecklenburg-Vorpommern", origin = "Grevesmühlen" }
    , { key = "GW", name = "Vorpommern-Greifswald", region = "Mecklenburg-Vorpommern", origin = "Greifswald" }
    , { key = "GZ", name = "Günzburg", region = "Bayern", origin = "" }
    , { key = "GÖ", name = "Göttingen", region = "Niedersachsen", origin = "" }
    , { key = "GÜ", name = "Landkreis Rostock", region = "Mecklenburg-Vorpommern", origin = "Güstrow" }
    , { key = "H", name = "Hannover", region = "Niedersachsen", origin = "" }
    , { key = "HA", name = "Hagen, Stadt", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "HAB", name = "Bad Kissingen", region = "Bayern", origin = "Hammelburg" }
    , { key = "HAL", name = "Halle, Stadt", region = "Sachsen-Anhalt", origin = "" }
    , { key = "HAM", name = "Hamm, Stadt", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "HAS", name = "Haßberge", region = "Bayern", origin = "Hassfurt" }
    , { key = "HB", name = "Freie Hansestadt Bremen", region = "Bremen", origin = "Hansestadt Bremen" }
    , { key = "HBN", name = "Hildburghausen", region = "Thüringen", origin = "" }
    , { key = "HBS", name = "Harz", region = "Sachsen-Anhalt", origin = "Halberstadt" }
    , { key = "HC", name = "Mittelsachsen", region = "Sachsen", origin = "Hainichen" }
    , { key = "HCH", name = "Freudenstadt, Zollernalbkreis", region = "Baden-Württemberg", origin = "Hechingen" }
    , { key = "HD", name = "Heidelberg, Stadt, Rhein-Neckar-Kreis", region = "Baden-Württemberg", origin = "Heidelberg" }
    , { key = "HDH", name = "Heidenheim", region = "Baden-Württemberg", origin = "" }
    , { key = "HDL", name = "Börde", region = "Sachsen-Anhalt", origin = "Haldensleben" }
    , { key = "HE", name = "Helmstedt", region = "Niedersachsen", origin = "" }
    , { key = "HEB", name = "Nürnberger Land", region = "Bayern", origin = "Hersbruck" }
    , { key = "HEF", name = "Hersfeld-Rotenburg", region = "Hessen", origin = "Hersfeld" }
    , { key = "HEI", name = "Dithmarschen", region = "Schleswig-Holstein", origin = "Heide" }
    , { key = "HER", name = "Herne, Stadt", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "HET", name = "Mansfeld-Südharz", region = "Sachsen-Anhalt", origin = "Hettstedt" }
    , { key = "HF", name = "Herford", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "HG", name = "Hochtaunuskreis", region = "Hessen", origin = "Homburg" }
    , { key = "HGN", name = "Ludwigslust-Parchim", region = "Mecklenburg-Vorpommern", origin = "Hagenow" }
    , { key = "HGW", name = "Hansestadt Greifswald", region = "Mecklenburg-Vorpommern", origin = "" }
    , { key = "HH", name = "Freie und Hansestadt Hamburg", region = "Hamburg", origin = "Hansestadt Hamburg" }
    , { key = "HHM", name = "Burgenlandkreis", region = "Sachsen-Anhalt", origin = "Hohenmölsen" }
    , { key = "HI", name = "Hildesheim", region = "Niedersachsen", origin = "" }
    , { key = "HIG", name = "Eichsfeld", region = "Thüringen", origin = "Heiligenstadt" }
    , { key = "HIP", name = "Roth", region = "Bayern", origin = "Hilpoltstein" }
    , { key = "HK", name = "Heidekreis", region = "Niedersachsen", origin = "" }
    , { key = "HL", name = "Hansestadt Lübeck", region = "Schleswig-Holstein", origin = "" }
    , { key = "HM", name = "Hameln-Pyrmont", region = "Niedersachsen", origin = "Hameln" }
    , { key = "HMÜ", name = "Göttingen", region = "Niedersachsen", origin = "Hann. Münden" }
    , { key = "HN", name = "Heilbronn", region = "Baden-Württemberg", origin = "" }
    , { key = "HO", name = "Hof", region = "Bayern", origin = "" }
    , { key = "HOG", name = "Kassel", region = "Hessen", origin = "Hofgeismar" }
    , { key = "HOH", name = "Haßberge", region = "Bayern", origin = "Hofheim" }
    , { key = "HOL", name = "Holzminden", region = "Niedersachsen", origin = "" }
    , { key = "HOM", name = "Saarpfalz-Kreis außer Stadt St. Ingbert (IGB)", region = "Saarland", origin = "Homburg" }
    , { key = "HOR", name = "Freudenstadt", region = "Baden-Württemberg", origin = "Horb" }
    , { key = "HOT", name = "Zwickau", region = "Sachsen", origin = "Hohenstein" }
    , { key = "HP", name = "Bergstraße", region = "Hessen", origin = "Heppenheim" }
    , { key = "HR", name = "Schwalm-Eder-Kreis", region = "Hessen", origin = "Homberg" }
    , { key = "HRO", name = "Hansestadt Rostock", region = "Mecklenburg-Vorpommern", origin = "" }
    , { key = "HS", name = "Heinsberg", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "HSK", name = "Hochsauerlandkreis", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "HST", name = "Hansestadt Stralsund, Stadt", region = "Mecklenburg-Vorpommern", origin = "" }
    , { key = "HU", name = "Hanau, Main-Kinzig-Kreis", region = "Hessen", origin = "Hanau" }
    , { key = "HV", name = "Stendal", region = "Sachsen-Anhalt", origin = "Havelberg" }
    , { key = "HVL", name = "Havelland", region = "Brandenburg", origin = "" }
    , { key = "HWI", name = "Hansestadt Wismar", region = "Mecklenburg-Vorpommern", origin = "" }
    , { key = "HX", name = "Höxter", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "HY", name = "Bautzen", region = "Sachsen", origin = "Hoyerswerda" }
    , { key = "HZ", name = "Harz", region = "Sachsen-Anhalt", origin = "" }
    , { key = "HÖS", name = "Erlangen-Höchstadt", region = "Bayern", origin = "Höchstadt" }
    , { key = "IGB", name = "St. Ingbert, Stadt", region = "Saarland", origin = "Ingbert" }
    , { key = "IK", name = "Ilm-Kreis", region = "Thüringen", origin = "" }
    , { key = "IL", name = "Ilm-Kreis", region = "Thüringen", origin = "Ilmenau" }
    , { key = "ILL", name = "Neu-Ulm", region = "Bayern", origin = "Illertissen" }
    , { key = "IN", name = "Ingolstadt, Stadt", region = "Bayern", origin = "" }
    , { key = "IZ", name = "Steinburg", region = "Schleswig-Holstein", origin = "Itzehoe" }
    , { key = "J", name = "Jena, Stadt", region = "Thüringen", origin = "" }
    , { key = "JB", name = "Teltow-Fläming", region = "Brandenburg", origin = "Jüterbog" }
    , { key = "JE", name = "Wittenberg", region = "Sachsen-Anhalt", origin = "Jessen" }
    , { key = "JL", name = "Jerichower Land", region = "Sachsen-Anhalt", origin = "" }
    , { key = "JÜL", name = "Düren", region = "Nordrhein-Westfalen", origin = "Jülich" }
    , { key = "K", name = "Köln, Stadt", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "KA", name = "Karlsruhe", region = "Baden-Württemberg", origin = "" }
    , { key = "KB", name = "Waldeck-Frankenberg", region = "Hessen", origin = "Korbach" }
    , { key = "KC", name = "Kronach", region = "Bayern", origin = "" }
    , { key = "KE", name = "Kempten (Allgäu), Stadt", region = "Bayern", origin = "Kempten" }
    , { key = "KEH", name = "Kelheim", region = "Bayern", origin = "" }
    , { key = "KEL", name = "Ortenaukreis", region = "Baden-Württemberg", origin = "Kehl" }
    , { key = "KEM", name = "Bayreuth, Tirschenreuth", region = "Bayern", origin = "Kemnath" }
    , { key = "KF", name = "Kaufbeuren, Stadt", region = "Bayern", origin = "" }
    , { key = "KG", name = "Bad Kissingen", region = "Bayern", origin = "Kissingen" }
    , { key = "KH", name = "Bad Kreuznach", region = "Rheinland-Pfalz", origin = "Kreuznach" }
    , { key = "KI", name = "Kiel", region = "Schleswig-Holstein", origin = "" }
    , { key = "KIB", name = "Donnersbergkreis", region = "Rheinland-Pfalz", origin = "Kirchheimbolanden" }
    , { key = "KK", name = "Viersen", region = "Nordrhein-Westfalen", origin = "Kempen, Krefeld" }
    , { key = "KL", name = "Kaiserslautern", region = "Rheinland-Pfalz", origin = "" }
    , { key = "KLE", name = "Kleve", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "KLZ", name = "Altmarkkreis Salzwedel", region = "Sachsen-Anhalt", origin = "Klötze" }
    , { key = "KM", name = "Bautzen", region = "Sachsen", origin = "Kamenz" }
    , { key = "KN", name = "Konstanz", region = "Baden-Württemberg", origin = "" }
    , { key = "KO", name = "Koblenz, Stadt", region = "Rheinland-Pfalz", origin = "" }
    , { key = "KR", name = "Krefeld, Stadt", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "KRU", name = "Günzburg", region = "Bayern", origin = "Krumbach" }
    , { key = "KS", name = "Kassel", region = "Hessen", origin = "" }
    , { key = "KT", name = "Kitzingen", region = "Bayern", origin = "" }
    , { key = "KU", name = "Kulmbach", region = "Bayern", origin = "" }
    , { key = "KUS", name = "Kusel", region = "Rheinland-Pfalz", origin = "" }
    , { key = "KW", name = "Dahme-Spreewald", region = "Brandenburg", origin = "Königs Wusterhausen" }
    , { key = "KY", name = "Ostprignitz-Ruppin", region = "Brandenburg", origin = "Kyritz" }
    , { key = "KYF", name = "Kyffhäuserkreis", region = "Thüringen", origin = "Kyffhäuser" }
    , { key = "KÖN", name = "Rhön-Grabfeld", region = "Bayern", origin = "Königshofen" }
    , { key = "KÖT", name = "Anhalt-Bitterfeld", region = "Sachsen-Anhalt", origin = "Köthen" }
    , { key = "KÖZ", name = "Cham", region = "Bayern", origin = "Kötzting" }
    , { key = "KÜN", name = "Hohenlohekreis", region = "Baden-Württemberg", origin = "Künzelsau" }
    , { key = "L", name = "Leipzig", region = "Sachsen", origin = "" }
    , { key = "LA", name = "Landshut", region = "Bayern", origin = "" }
    , { key = "LAN", name = "Dingolfing-Landau", region = "Bayern", origin = "Landau" }
    , { key = "LAU", name = "Nürnberger Land", region = "Bayern", origin = "Lauf" }
    , { key = "LB", name = "Ludwigsburg", region = "Baden-Württemberg", origin = "" }
    , { key = "LBS", name = "Saale-Orla-Kreis", region = "Thüringen", origin = "Lobenstein" }
    , { key = "LBZ", name = "Ludwigslust-Parchim", region = "Mecklenburg-Vorpommern", origin = "Lübz" }
    , { key = "LC", name = "Dahme-Spreewald", region = "Brandenburg", origin = "Luckau" }
    , { key = "LD", name = "Landau in der Pfalz, Stadt", region = "Rheinland-Pfalz", origin = "Landau" }
    , { key = "LDK", name = "Lahn-Dill-Kreis in Wetzlar, Kreis", region = "Hessen", origin = "Lahn-Dill-Kreis" }
    , { key = "LDS", name = "Dahme-Spreewald", region = "Brandenburg", origin = "Landkreis Dahme-Spreewald" }
    , { key = "LEO", name = "Böblingen", region = "Baden-Württemberg", origin = "Leonberg" }
    , { key = "LER", name = "Leer", region = "Niedersachsen", origin = "" }
    , { key = "LEV", name = "Leverkusen, Stadt", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "LF", name = "Altötting, Berchtesgadener Land, Traunstein", region = "Bayern", origin = "Laufen" }
    , { key = "LG", name = "Lüneburg", region = "Niedersachsen", origin = "" }
    , { key = "LH", name = "Coesfeld, Unna", region = "Nordrhein-Westfalen", origin = "Lüdinghausen" }
    , { key = "LI", name = "Lindau (Bodensee)", region = "Bayern", origin = "Lindau" }
    , { key = "LIB", name = "Elbe-Elster", region = "Brandenburg", origin = "Liebenwerda" }
    , { key = "LIF", name = "Lichtenfels", region = "Bayern", origin = "" }
    , { key = "LIP", name = "Lippe", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "LK", name = "Minden-Lübbecke", region = "Nordrhein-Westfalen", origin = "Lübcke" }
    , { key = "LL", name = "Landsberg am Lech", region = "Bayern", origin = "" }
    , { key = "LM", name = "Limburg-Weilburg", region = "Hessen", origin = "Limburg" }
    , { key = "LN", name = "Dahme-Spreewald", region = "Brandenburg", origin = "Lübben" }
    , { key = "LOS", name = "Oder-Spree", region = "Brandenburg", origin = "Landkreis Oder-Spree" }
    , { key = "LP", name = "Soest", region = "Nordrhein-Westfalen", origin = "Lippstadt" }
    , { key = "LR", name = "Ortenaukreis", region = "Baden-Württemberg", origin = "Lahr" }
    , { key = "LRO", name = "Rostock, Landkreis", region = "Mecklenburg-Vorpommern", origin = "Landkreis Rostock" }
    , { key = "LSZ", name = "Unstrut-Hainich-Kreis", region = "Thüringen", origin = "Langensalza" }
    , { key = "LU", name = "Ludwigshafen am Rhein", region = "Rheinland-Pfalz", origin = "Ludwigshafen" }
    , { key = "LUK", name = "Teltow-Fläming", region = "Brandenburg", origin = "Luckenwalde" }
    , { key = "LUP", name = "Ludwigslust-Parchim", region = "Mecklenburg-Vorpommern", origin = "Ludwigslust, Parchim" }
    , { key = "LWL", name = "Ludwigslust-Parchim", region = "Mecklenburg-Vorpommern", origin = "Ludwigslust" }
    , { key = "LÖ", name = "Lörrach", region = "Baden-Württemberg", origin = "" }
    , { key = "LÖB", name = "Görlitz", region = "Sachsen", origin = "Löbau" }
    , { key = "LÜN", name = "Unna", region = "Nordrhein-Westfalen", origin = "Lünen" }
    , { key = "M", name = "München", region = "Bayern", origin = "" }
    , { key = "MA", name = "Mannheim, Stadt", region = "Baden-Württemberg", origin = "" }
    , { key = "MAB", name = "Erzgebirgskreis", region = "Sachsen", origin = "Marienberg" }
    , { key = "MAI", name = "Kelheim, Landshut", region = "Bayern", origin = "Mainburg" }
    , { key = "MAK", name = "Wunsiedel i. Fichtelgebirge", region = "Bayern", origin = "Marktredwitz" }
    , { key = "MAL", name = "Landshut Straubing-Bogen", region = "Bayern", origin = "Mallersdorf" }
    , { key = "MB", name = "Miesbach", region = "Bayern", origin = "" }
    , { key = "MC", name = "Mecklenburgische Seenplatte", region = "Mecklenburg-Vorpommern", origin = "Malchin" }
    , { key = "MD", name = "Magdeburg, Stadt", region = "Sachsen-Anhalt", origin = "" }
    , { key = "ME", name = "Mettmann", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "MED", name = "Dithmarschen", region = "Schleswig-Holstein", origin = "Meldorf" }
    , { key = "MEG", name = "Schwalm-Eder-Kreis", region = "Hessen", origin = "Melsungen" }
    , { key = "MEI", name = "Meißen", region = "Sachsen", origin = "" }
    , { key = "MEK", name = "Erzgebirgskreis", region = "Sachsen", origin = "Mittlerer Erzgebirgskreis" }
    , { key = "MEL", name = "Osnabrück", region = "Niedersachsen", origin = "Melle" }
    , { key = "MER", name = "Saalekreis", region = "Sachsen-Anhalt", origin = "Merseburg" }
    , { key = "MET", name = "Rhön-Grabfeld", region = "Bayern", origin = "Mellrichstadt" }
    , { key = "MG", name = "Mönchengladbach, Stadt", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "MGH", name = "Main-Tauber-Kreis", region = "Baden-Württemberg", origin = "Mergentheim" }
    , { key = "MGN", name = "Schmalkalden-Meiningen", region = "Thüringen", origin = "Meiningen" }
    , { key = "MH", name = "Mülheim an der Ruhr, Stadt", region = "Nordrhein-Westfalen", origin = "Mülheim" }
    , { key = "MHL", name = "Unstrut-Hainich-Kreis", region = "Thüringen", origin = "Mühlhausen" }
    , { key = "MI", name = "Minden-Lübbecke", region = "Nordrhein-Westfalen", origin = "Minden" }
    , { key = "MIL", name = "Miltenberg", region = "Bayern", origin = "" }
    , { key = "MK", name = "Märkischer Kreis", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "MKK", name = "Main-Kinzig-Kreis", region = "Hessen", origin = "" }
    , { key = "ML", name = "Mansfeld-Südharz", region = "Sachsen-Anhalt", origin = "Mansfelder Land" }
    , { key = "MM", name = "Memmingen, Stadt", region = "Bayern", origin = "" }
    , { key = "MN", name = "Unterallgäu", region = "Bayern", origin = "Mindelheim" }
    , { key = "MO", name = "Wesel", region = "Nordrhein-Westfalen", origin = "Moers" }
    , { key = "MOD", name = "Ostallgäu", region = "Bayern", origin = "Marktoberdorf" }
    , { key = "MOL", name = "Märkisch-Oderland", region = "Brandenburg", origin = "" }
    , { key = "MON", name = "Aachen, Düren", region = "Nordrhein-Westfalen", origin = "Monschau" }
    , { key = "MOS", name = "Neckar-Odenwald-Kreis", region = "Baden-Württemberg", origin = "Mosbach" }
    , { key = "MQ", name = "Saalekreis", region = "Sachsen-Anhalt", origin = "Merseburg, Querfurt" }
    , { key = "MR", name = "Marburg-Biedenkopf", region = "Hessen", origin = "Marburg" }
    , { key = "MS", name = "Münster, Stadt", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "MSE", name = "Mecklenburgische Seenplatte", region = "Mecklenburg-Vorpommern", origin = "" }
    , { key = "MSH", name = "Mansfeld-Südharz", region = "Sachsen-Anhalt", origin = "Mansfeld, Südharz" }
    , { key = "MSP", name = "Main-Spessart", region = "Bayern", origin = "Main, Spessart" }
    , { key = "MST", name = "Mecklenburgische Seenplatte", region = "Mecklenburg-Vorpommern", origin = "Mecklenburg-Strelitz" }
    , { key = "MTK", name = "Main-Taunus-Kreis", region = "Hessen", origin = "" }
    , { key = "MTL", name = "Leipzig", region = "Sachsen", origin = "Muldental" }
    , { key = "MU", name = "Landkreis München", region = "Bayern", origin = "Müncher Umland" }
    , { key = "MUC", name = "München, Stadt", region = "Bayern", origin = "Muenchen" }
    , { key = "MW", name = "Mittelsachsen", region = "Sachsen", origin = "Mittweida" }
    , { key = "MY", name = "Mayen-Koblenz", region = "Rheinland-Pfalz", origin = "Mayen" }
    , { key = "MYK", name = "Mayen-Koblenz", region = "Rheinland-Pfalz", origin = "Mayen, Koblenz" }
    , { key = "MZ", name = "Mainz", region = "Rheinland-Pfalz", origin = "" }
    , { key = "MZG", name = "Merzig-Wadern", region = "Saarland", origin = "Merzig" }
    , { key = "MÜ", name = "Mühldorf am Inn", region = "Bayern", origin = "Mühldorf" }
    , { key = "MÜB", name = "Bayreuth, Hof", region = "Bayern", origin = "Münchberg" }
    , { key = "MÜL", name = "Breisgau-Hochschwarzwald", region = "Baden-Württemberg", origin = "Müllheim" }
    , { key = "MÜR", name = "Mecklenburgische Seenplatte", region = "Mecklenburg-Vorpommern", origin = "Müritz" }
    , { key = "N", name = "Nürnberg Stadt, Nürnberger Land", region = "Bayern", origin = "Nürnberg" }
    , { key = "NAB", name = "Amberg-Sulzbach, Schwandorf", region = "Bayern", origin = "Nabburg" }
    , { key = "NAI", name = "Hof", region = "Bayern", origin = "Naila" }
    , { key = "NAU", name = "Havelland", region = "Brandenburg", origin = "Nauen" }
    , { key = "NB", name = "Neubrandenburg, Stadt", region = "Mecklenburg-Vorpommern", origin = "" }
    , { key = "ND", name = "Neuburg-Schrobenhausen", region = "Bayern", origin = "Neuburg an der Donau" }
    , { key = "NDH", name = "Nordhausen", region = "Thüringen", origin = "" }
    , { key = "NE", name = "Rhein-Kreis Neuss", region = "Nordrhein-Westfalen", origin = "Neuss" }
    , { key = "NEA", name = "Neustadt an der Aisch-Bad Winsheim", region = "Bayern", origin = "Neustadt an der Aisch" }
    , { key = "NEB", name = "Burgenlandkreis", region = "Sachsen-Anhalt", origin = "Nebra" }
    , { key = "NEC", name = "Zulassungsstelle Coburg, Zweckverband", region = "Bayern", origin = "Neustadt bei Coburg" }
    , { key = "NEN", name = "Schwandorf", region = "Bayern", origin = "Neunburg" }
    , { key = "NES", name = "Rhön-Grabfeld", region = "Bayern", origin = "Neustadt an der Saale" }
    , { key = "NEU", name = "Breisgau-Hochschwarzwald", region = "Baden-Württemberg", origin = "Neustadt" }
    , { key = "NEW", name = "Neustadt an der Waldnaab", region = "Bayern", origin = "" }
    , { key = "NF", name = "Nordfriesland", region = "Schleswig-Holstein", origin = "" }
    , { key = "NH", name = "Sonneberg", region = "Thüringen", origin = "Neuhaus" }
    , { key = "NI", name = "Nienburg (Weser)", region = "Niedersachsen", origin = "Nienburg" }
    , { key = "NK", name = "Neunkirchen Saar", region = "Saarland", origin = "Neunkirchen" }
    , { key = "NM", name = "Neumarkt in der Oberpfalz", region = "Bayern", origin = "Neumarkt" }
    , { key = "NMB", name = "Burgenlandkreis", region = "Sachsen-Anhalt", origin = "Naumburg" }
    , { key = "NMS", name = "Neumünster", region = "Schleswig-Holstein", origin = "" }
    , { key = "NOH", name = "Grafschaft Bentheim", region = "Niedersachsen", origin = "Nordhorn" }
    , { key = "NOL", name = "Görlitz", region = "Sachsen", origin = "Niederschlesische Oberlausitz" }
    , { key = "NOM", name = "Northeim", region = "Niedersachsen", origin = "" }
    , { key = "NOR", name = "Aurich", region = "Niedersachsen", origin = "Norden" }
    , { key = "NP", name = "Ostprignitz-Ruppin", region = "Brandenburg", origin = "Neuruppin" }
    , { key = "NR", name = "Neuwied", region = "Rheinland-Pfalz", origin = "Neuwied am Rhein" }
    , { key = "NT", name = "Esslingen", region = "Baden-Württemberg", origin = "Nürtingen" }
    , { key = "NU", name = "Neu-Ulm", region = "Bayern", origin = "" }
    , { key = "NVP", name = "Vorpommern-Rügen", region = "Mecklenburg-Vorpommern", origin = "Nordvorpommern" }
    , { key = "NW", name = "Neustadt an der Weinstraße", region = "Rheinland-Pfalz", origin = "" }
    , { key = "NWM", name = "Nordwestmecklenburg", region = "Mecklenburg-Vorpommern", origin = "" }
    , { key = "NY", name = "Görlitz", region = "Sachsen", origin = "Niesky" }
    , { key = "NZ", name = "Mecklenburgische Seenplatte", region = "Mecklenburg-Vorpommern", origin = "Neustrelitz" }
    , { key = "NÖ", name = "Donau-Ries", region = "Bayern", origin = "Nördlingen" }
    , { key = "OA", name = "Oberallgäu", region = "Bayern", origin = "" }
    , { key = "OAL", name = "Ostallgäu", region = "Bayern", origin = "" }
    , { key = "OB", name = "Oberhausen, Stadt", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "OBB", name = "Miltenberg", region = "Bayern", origin = "Obernburg" }
    , { key = "OBG", name = "Stendal", region = "Sachsen-Anhalt", origin = "Osterburg" }
    , { key = "OC", name = "Börde", region = "Sachsen-Anhalt", origin = "Oschersleben" }
    , { key = "OCH", name = "Würzburg", region = "Bayern", origin = "Ochsenfurt" }
    , { key = "OD", name = "Stormarn", region = "Schleswig-Holstein", origin = "Oldesloe" }
    , { key = "OE", name = "Olpe", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "OF", name = "Offenbach am Main", region = "Hessen", origin = "Offenbach" }
    , { key = "OG", name = "Ortenaukreis", region = "Baden-Württemberg", origin = "Offenburg" }
    , { key = "OH", name = "Ostholstein", region = "Schleswig-Holstein", origin = "" }
    , { key = "OHA", name = "Göttingen", region = "Niedersachsen", origin = "Osterode am Harz" }
    , { key = "OHV", name = "Oberhavel", region = "Brandenburg", origin = "" }
    , { key = "OHZ", name = "Osterholz", region = "Niedersachsen", origin = "" }
    , { key = "OK", name = "Börde", region = "Sachsen-Anhalt", origin = "Ohrekreis" }
    , { key = "OL", name = "Oldenburg (Oldenburg)", region = "Niedersachsen", origin = "Oldenburg" }
    , { key = "OP", name = "Leverkusen, Stadt", region = "Nordrhein-Westfalen", origin = "Opladen" }
    , { key = "OPR", name = "Ostprignitz-Ruppin", region = "Brandenburg", origin = "Ostprignitz, Ruppin" }
    , { key = "OS", name = "Osnabrück", region = "Niedersachsen", origin = "" }
    , { key = "OSL", name = "Oberspreewald-Lausitz", region = "Brandenburg", origin = "Oberspreewald, Lausitz" }
    , { key = "OTW", name = "Neunkirchen", region = "Saarland", origin = "Ottweiler" }
    , { key = "OVI", name = "Schwandorf", region = "Bayern", origin = "Oberviechtach" }
    , { key = "OVL", name = "Vogtlandkreis", region = "Sachsen", origin = "Obervogtland" }
    , { key = "OVP", name = "Vorpommern-Greifswald", region = "Mecklenburg-Vorpommern", origin = "Ostvorpommern" }
    , { key = "OZ", name = "Nordsachsen", region = "Sachsen", origin = "Oschatz" }
    , { key = "P", name = "Potsdam, Stadt", region = "Brandenburg", origin = "" }
    , { key = "PA", name = "Passau", region = "Bayern", origin = "" }
    , { key = "PAF", name = "Pfaffenhofen a. d. Ilm", region = "Bayern", origin = "Pfaffenhofen" }
    , { key = "PAN", name = "Rottal-Inn", region = "Bayern", origin = "Pfarrkirchen" }
    , { key = "PAR", name = "Kehlheim, Neumarkt i. d. Opf.", region = "Bayern", origin = "Parsberg" }
    , { key = "PB", name = "Paderborn", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "PCH", name = "Ludwigslust-Parchim", region = "Mecklenburg-Vorpommern", origin = "Parchim" }
    , { key = "PE", name = "Peine", region = "Niedersachsen", origin = "" }
    , { key = "PEG", name = "Bayreuth, Forchheim, Nürnberger Land", region = "Bayern", origin = "Pegnitz" }
    , { key = "PF", name = "Pforzheim, Stadt, Enzkreis", region = "Baden-Württemberg", origin = "Pforzheim" }
    , { key = "PI", name = "Pinneberg", region = "Schleswig-Holstein", origin = "" }
    , { key = "PIR", name = "Sächsische Schweiz-Osterzgebirge", region = "Sachsen", origin = "Pirna" }
    , { key = "PL", name = "Vogtlandkreis", region = "Sachsen", origin = "Plauen" }
    , { key = "PLÖ", name = "Plön", region = "Schleswig-Holstein", origin = "" }
    , { key = "PM", name = "Potsdam-Mittelmark", region = "Brandenburg", origin = "Potsdam, Mittelmark" }
    , { key = "PN", name = "Saale-Orla-Kreis", region = "Thüringen", origin = "Pößneck" }
    , { key = "PR", name = "Prignitz", region = "Brandenburg", origin = "" }
    , { key = "PRÜ", name = "Eifelkreis Bitburg-Prüm", region = "Rheinland-Pfalz", origin = "Prüm" }
    , { key = "PS", name = "Pirmasens, Stadt, Südwestpfalz", region = "Rheinland-Pfalz", origin = "Pirmasens" }
    , { key = "PW", name = "Vorpommern-Greifswald", region = "Mecklenburg-Vorpommern", origin = "Pasewalk" }
    , { key = "PZ", name = "Uckermark", region = "Brandenburg", origin = "Prenzlau" }
    , { key = "QFT", name = "Saalekreis", region = "Sachsen-Anhalt", origin = "Querfurt" }
    , { key = "QLB", name = "Harz", region = "Sachsen-Anhalt", origin = "Quedlinburg" }
    , { key = "R", name = "Regensburg", region = "Bayern", origin = "" }
    , { key = "RA", name = "Rastatt", region = "Baden-Württemberg", origin = "" }
    , { key = "RC", name = "Vogtlandkreis", region = "Sachsen", origin = "Reichenbach" }
    , { key = "RD", name = "Rendsburg-Eckernförde", region = "Schleswig-Holstein", origin = "Rendsburg" }
    , { key = "RDG", name = "Vorpommern-Rügen", region = "Mecklenburg-Vorpommern", origin = "Ribnitz-Damgarten" }
    , { key = "RE", name = "Recklinghausen", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "REG", name = "Regen", region = "Bayern", origin = "" }
    , { key = "REH", name = "Hof, Wunsiedel im Fichtelgebirge", region = "Bayern", origin = "Rehau" }
    , { key = "REI", name = "Berchtesgadener Land", region = "Bayern", origin = "Reichenhall" }
    , { key = "RG", name = "Meißen", region = "Sachsen", origin = "Riesa, Großenhain" }
    , { key = "RH", name = "Roth", region = "Bayern", origin = "" }
    , { key = "RI", name = "Schaumburg", region = "Niedersachsen", origin = "Rinteln" }
    , { key = "RID", name = "Kelheim", region = "Bayern", origin = "Riedenburg" }
    , { key = "RIE", name = "Meißen", region = "Sachsen", origin = "Riesa" }
    , { key = "RL", name = "Mittelsachsen", region = "Sachsen", origin = "Rochlitz" }
    , { key = "RM", name = "Mecklenburgische Seenplatte", region = "Mecklenburg-Vorpommern", origin = "Röbel/müritz" }
    , { key = "RN", name = "Havelland", region = "Brandenburg", origin = "Rathenow" }
    , { key = "RO", name = "Rosenheim", region = "Bayern", origin = "" }
    , { key = "ROD", name = "Cham, Schwandorf", region = "Bayern", origin = "Roding" }
    , { key = "ROF", name = "Hersfeld-Rotenburg", region = "Hessen", origin = "Rotenburg an der Fulda" }
    , { key = "ROK", name = "Donnersbergkreis", region = "Rheinland-Pfalz", origin = "Rockenhausen" }
    , { key = "ROL", name = "Kelheim, Landshut", region = "Bayern", origin = "Rottenburg an der Laaber" }
    , { key = "ROS", name = "Rostock, Landkreis", region = "Mecklenburg-Vorpommern", origin = "Rostock" }
    , { key = "ROT", name = "Ansbach", region = "Bayern", origin = "Rothenburg ob der Tauber" }
    , { key = "ROW", name = "Rotenburg (Wümme)", region = "Niedersachsen", origin = "" }
    , { key = "RP", name = "Rhein-Pfalz-Kreis", region = "Rheinland-Pfalz", origin = "Rhein-Pfalz" }
    , { key = "RS", name = "Remscheid, Stadt", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "RSL", name = "Dessau-Roßlau, Stadt", region = "Sachsen-Anhalt", origin = "Rosslau" }
    , { key = "RT", name = "Reutlingen", region = "Baden-Württemberg", origin = "" }
    , { key = "RU", name = "Saalfeld-Rudolstadt", region = "Thüringen", origin = "Rudolstadt" }
    , { key = "RV", name = "Ravensburg", region = "Baden-Württemberg", origin = "" }
    , { key = "RW", name = "Rottweil", region = "Baden-Württemberg", origin = "" }
    , { key = "RZ", name = "Herzogtum Lauenburg", region = "Schleswig-Holstein", origin = "Ratzeburg" }
    , { key = "RÜD", name = "Rheingau-Taunus Kreis", region = "Hessen", origin = "Rüdesheim" }
    , { key = "RÜG", name = "Vorpommern-Rügen", region = "Mecklenburg-Vorpommern", origin = "Rügen" }
    , { key = "S", name = "Stuttgart, Stadt", region = "Baden-Württemberg", origin = "" }
    , { key = "SAB", name = "Trier-Saarburg", region = "Rheinland-Pfalz", origin = "Saarburg" }
    , { key = "SAD", name = "Schwandorf", region = "Bayern", origin = "" }
    , { key = "SAN", name = "Hof, Kronach, Kulmbach", region = "Bayern", origin = "Stadtsteinach" }
    , { key = "SAW", name = "Altmarkkreis Salzwedel", region = "Sachsen-Anhalt", origin = "Salzwedel" }
    , { key = "SB", name = "Saarbrücken, Stadt und Stadtverband außer Völklingen, Stadt (VK)", region = "Saarland", origin = "Saarbrücken" }
    , { key = "SBG", name = "Vorpommern-Greifswald", region = "Mecklenburg-Vorpommern", origin = "Strasburg" }
    , { key = "SBK", name = "Salzlandkreis", region = "Sachsen-Anhalt", origin = "Schönebeck" }
    , { key = "SC", name = "Schwabach, Stadt", region = "Bayern", origin = "" }
    , { key = "SCZ", name = "Saale-Orla-Kreis", region = "Thüringen", origin = "Schleiz" }
    , { key = "SDH", name = "Kyffhäuserkreis", region = "Thüringen", origin = "Sondershausen" }
    , { key = "SDL", name = "Stendal", region = "Sachsen-Anhalt", origin = "" }
    , { key = "SDT", name = "Uckermark", region = "Brandenburg", origin = "Schwedt" }
    , { key = "SE", name = "Segeberg", region = "Schleswig-Holstein", origin = "" }
    , { key = "SEB", name = "Sächsische Schweiz-Osterzgebirge", region = "Sachsen", origin = "Sebnitz" }
    , { key = "SEE", name = "Märkisch-Oderland", region = "Brandenburg", origin = "Seelow" }
    , { key = "SEF", name = "Neustadt a. d. Aisch-Bad Windsheim", region = "Bayern", origin = "Scheinfeld" }
    , { key = "SEL", name = "Wunsiedel i. Fichtelgebirge", region = "Bayern", origin = "Selb" }
    , { key = "SFB", name = "Oberspreewald-Lausitz", region = "Brandenburg", origin = "Senftenberg" }
    , { key = "SFT", name = "Salzlandkreis", region = "Sachsen-Anhalt", origin = "Staßfurt" }
    , { key = "SG", name = "Solingen, Stadt", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "SGH", name = "Mansfeld-Südharz", region = "Sachsen-Anhalt", origin = "Sangerhausen" }
    , { key = "SHA", name = "Schwäbisch Hall", region = "Baden-Württemberg", origin = "" }
    , { key = "SHG", name = "Schaumburg", region = "Niedersachsen", origin = "Stadthagen" }
    , { key = "SHK", name = "Saale-Holzland-Kreis", region = "Thüringen", origin = "" }
    , { key = "SHL", name = "Suhl, Stadt", region = "Thüringen", origin = "" }
    , { key = "SI", name = "Siegen-Wittgenstein", region = "Nordrhein-Westfalen", origin = "Siegen" }
    , { key = "SIG", name = "Sigmaringen", region = "Baden-Württemberg", origin = "" }
    , { key = "SIM", name = "Rhein-Hunsrück-Kreis", region = "Rheinland-Pfalz", origin = "Simmern" }
    , { key = "SK", name = "Saalekreis", region = "Sachsen-Anhalt", origin = "" }
    , { key = "SL", name = "Schleswig-Flensburg", region = "Schleswig-Holstein", origin = "Schleswig" }
    , { key = "SLE", name = "Düren, Euskirchen", region = "Nordrhein-Westfalen", origin = "Schleiden" }
    , { key = "SLF", name = "Saalfeld-Rudolstadt", region = "Thüringen", origin = "Saalfeld" }
    , { key = "SLG", name = "Ravensburg, Sigmaringen", region = "Baden-Württemberg", origin = "Saulgau" }
    , { key = "SLK", name = "Salzlandkreis", region = "Sachsen-Anhalt", origin = "" }
    , { key = "SLN", name = "Altenburger Land", region = "Thüringen", origin = "Schmölln" }
    , { key = "SLS", name = "Saarlouis", region = "Saarland", origin = "" }
    , { key = "SLZ", name = "Wartburgkreis", region = "Thüringen", origin = "Salzungen" }
    , { key = "SLÜ", name = "Main-Kinzig-Kreis", region = "Hessen", origin = "Schlüchtern" }
    , { key = "SM", name = "Schmalkalden-Meiningen", region = "Thüringen", origin = "Schmalkalden" }
    , { key = "SMÜ", name = "Augsburg", region = "Bayern", origin = "Schwabmünchen" }
    , { key = "SN", name = "Schwerin, Stadt", region = "Mecklenburg-Vorpommern", origin = "" }
    , { key = "SO", name = "Soest", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "SOB", name = "Neuburg-Schrobenhausen", region = "Bayern", origin = "Schrobenhausen" }
    , { key = "SOG", name = "Weilheim-Schongau", region = "Bayern", origin = "Schongau" }
    , { key = "SOK", name = "Saale-Orla-Kreis", region = "Thüringen", origin = "" }
    , { key = "SON", name = "Sonneberg", region = "Thüringen", origin = "" }
    , { key = "SP", name = "Speyer, Stadt", region = "Rheinland-Pfalz", origin = "" }
    , { key = "SPB", name = "Spree-Neiße", region = "Brandenburg", origin = "Spremberg" }
    , { key = "SPN", name = "Spree-Neiße", region = "Brandenburg", origin = "Spree, Neiße" }
    , { key = "SR", name = "Straubing, Straubing-Bogen", region = "Bayern", origin = "Straubing" }
    , { key = "SRB", name = "Märkisch-Oderland", region = "Brandenburg", origin = "Strausberg" }
    , { key = "SRO", name = "Saale-Holzland-Kreis", region = "Thüringen", origin = "Stadtroda" }
    , { key = "ST", name = "Steinfurt", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "STA", name = "Starnberg", region = "Bayern", origin = "" }
    , { key = "STB", name = "Ludwigslust-Parchim", region = "Mecklenburg-Vorpommern", origin = "Sternberg" }
    , { key = "STD", name = "Stade", region = "Niedersachsen", origin = "" }
    , { key = "STE", name = "Lichtenfels", region = "Bayern", origin = "Staffelstein" }
    , { key = "STL", name = "Erzgebirgskreis", region = "Sachsen", origin = "Stollberg" }
    , { key = "STO", name = "Konstanz, Sigmaringen", region = "Baden-Württemberg", origin = "Stockach" }
    , { key = "SU", name = "Rhein-Sieg-Kreis", region = "Nordrhein-Westfalen", origin = "Siegburg" }
    , { key = "SUL", name = "Amberg-Sulzbach", region = "Bayern", origin = "Sulzbach-Rosenberg" }
    , { key = "SW", name = "Schweinfurt", region = "Bayern", origin = "" }
    , { key = "SWA", name = "Rheingau-Taunus-Kreis", region = "Hessen", origin = "Schwalbach" }
    , { key = "SY", name = "Diepholz", region = "Niedersachsen", origin = "Syke" }
    , { key = "SZ", name = "Salzgitter, Stadt", region = "Niedersachsen", origin = "" }
    , { key = "SZB", name = "Erzgebirgskreis", region = "Sachsen", origin = "Schwarzenberg" }
    , { key = "SÄK", name = "Waldshut", region = "Baden-Württemberg", origin = "Säckingen" }
    , { key = "SÖM", name = "Sömmerda", region = "Thüringen", origin = "" }
    , { key = "SÜW", name = "Südliche Weinstraße", region = "Rheinland-Pfalz", origin = "" }
    , { key = "TBB", name = "Main-Tauber-Kreis", region = "Baden-Württemberg", origin = "Tauberbischofsheim" }
    , { key = "TDO", name = "Nordsachsen", region = "Sachsen", origin = "Torgau, Delitzsch, Oschatz" }
    , { key = "TE", name = "Steinfurt", region = "Nordrhein-Westfalen", origin = "Tecklenburg" }
    , { key = "TET", name = "Rostock, Landkreis", region = "Mecklenburg-Vorpommern", origin = "Teterow" }
    , { key = "TF", name = "Teltow-Fläming", region = "Brandenburg", origin = "Teltow, Fläming" }
    , { key = "TG", name = "Nordsachsen", region = "Sachsen", origin = "Torgau" }
    , { key = "TIR", name = "Tirschenreuth", region = "Bayern", origin = "" }
    , { key = "TO", name = "Nordsachsen", region = "Sachsen", origin = "Torgau, Oschatz" }
    , { key = "TP", name = "Uckermark", region = "Brandenburg", origin = "Templin" }
    , { key = "TR", name = "Trier, Stadt und Trier-Saarburg", region = "Rheinland-Pfalz", origin = "Trier" }
    , { key = "TS", name = "Traunstein", region = "Bayern", origin = "" }
    , { key = "TT", name = "Bodenseekreis", region = "Baden-Württemberg", origin = "Tettnang" }
    , { key = "TUT", name = "Tuttlingen", region = "Baden-Württemberg", origin = "" }
    , { key = "TÖL", name = "Bad Tölz-Wolfratshausen", region = "Bayern", origin = "Tölz" }
    , { key = "TÜ", name = "Tübingen", region = "Baden-Württemberg", origin = "" }
    , { key = "UE", name = "Uelzen", region = "Niedersachsen", origin = "" }
    , { key = "UEM", name = "Vorpommern-Greifswald", region = "Mecklenburg-Vorpommern", origin = "Ueckermünde" }
    , { key = "UER", name = "Vorpommern-Greifswald", region = "Mecklenburg-Vorpommern", origin = "Uecker-Randow" }
    , { key = "UFF", name = "Neustadt a. d. Aisch-Bad Windsheim", region = "Bayern", origin = "Uffenheim" }
    , { key = "UH", name = "Unstrut-Hainich-Kreis", region = "Thüringen", origin = "Unstrut, Hainich" }
    , { key = "UL", name = "Ulm, Stadt, Alb-Donaukreis", region = "Baden-Württemberg", origin = "Ulm" }
    , { key = "UM", name = "Uckermark", region = "Brandenburg", origin = "" }
    , { key = "UN", name = "Unna", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "USI", name = "Hochtaunuskreis", region = "Hessen", origin = "Usingen" }
    , { key = "V", name = "Vogtlandkreis", region = "Sachsen", origin = "Vogtland" }
    , { key = "VAI", name = "Ludwigsburg", region = "Baden-Württemberg", origin = "Vaihingen" }
    , { key = "VB", name = "Vogelsbergkreis", region = "Hessen", origin = "Vogelsberg" }
    , { key = "VEC", name = "Vechta", region = "Niedersachsen", origin = "" }
    , { key = "VER", name = "Verden", region = "Niedersachsen", origin = "" }
    , { key = "VG", name = "Vorpommern-Greifswald", region = "Mecklenburg-Vorpommern", origin = "Vorpommern, Greifswald" }
    , { key = "VIB", name = "Landshut, Rottal-Inn", region = "Bayern", origin = "Vilsbiburg" }
    , { key = "VIE", name = "Viersen", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "VIT", name = "Regen", region = "Bayern", origin = "Viechtach" }
    , { key = "VK", name = "Völklingen, Stadt", region = "Saarland", origin = "" }
    , { key = "VOH", name = "Neustadt a. d. Waldnaab", region = "Bayern", origin = "Vohenstrauß" }
    , { key = "VR", name = "Vorpommern-Rügen", region = "Mecklenburg-Vorpommern", origin = "Vorpommern, Rügen" }
    , { key = "VS", name = "Schwarzwald-Baar-Kreis", region = "Baden-Württemberg", origin = "Villingen-Schwenningen" }
    , { key = "W", name = "Wuppertal, Stadt", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "WA", name = "Waldeck-Frankenberg", region = "Hessen", origin = "Waldeck" }
    , { key = "WAF", name = "Warendorf", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "WAK", name = "Wartburgkreis", region = "Thüringen", origin = "" }
    , { key = "WAN", name = "Herne, Stadt", region = "Nordrhein-Westfalen", origin = "Wanne" }
    , { key = "WAR", name = "Höxter", region = "Nordrhein-Westfalen", origin = "Warburg" }
    , { key = "WAT", name = "Bochum, Stadt", region = "Nordrhein-Westfalen", origin = "Wattenscheid" }
    , { key = "WB", name = "Wittenberg", region = "Sachsen-Anhalt", origin = "" }
    , { key = "WBG", name = "Wolfsburg, Stadt", region = "Niedersachsen", origin = "Worbis" }
    , { key = "WBS", name = "Eichsfeld", region = "Thüringen", origin = "Werdau" }
    , { key = "WDA", name = "Zwickau", region = "Sachsen", origin = "Weimar" }
    , { key = "WE", name = "Weimar, Stadt", region = "Thüringen", origin = "Weilburg" }
    , { key = "WEL", name = "Limburg-Weilburg", region = "Hessen", origin = "Weiden" }
    , { key = "WEN", name = "Weiden in der Oberpfalz, Stadt", region = "Bayern", origin = "Wertingen" }
    , { key = "WER", name = "Augsburg, Dillingen a. d. Donau", region = "Bayern", origin = "Wertingen" }
    , { key = "WES", name = "Wesel", region = "Nordrhein-Westfalen", origin = "" }
    , { key = "WF", name = "Wolfenbüttel", region = "Niedersachsen", origin = "" }
    , { key = "WG", name = "Ravensburg", region = "Baden-Württemberg", origin = "Wangen" }
    , { key = "WHV", name = "Wilhelmshaven, Stadt", region = "Niedersachsen", origin = "" }
    , { key = "WI", name = "Wiesbaden, Stadt", region = "Hessen", origin = "" }
    , { key = "WIL", name = "Bernkastel-Wittlich", region = "Rheinland-Pfalz", origin = "Wittlich" }
    , { key = "WIS", name = "Nordwestmecklenburg", region = "Mecklenburg-Vorpommern", origin = "Wismar" }
    , { key = "WIT", name = "Ennepe-Ruhr-Kreis", region = "Nordrhein-Westfalen", origin = "Witten" }
    , { key = "WIZ", name = "Werra-Meißner-Kreis", region = "Hessen", origin = "Witzenhausen" }
    , { key = "WK", name = "Ostprignitz-Ruppin", region = "Brandenburg", origin = "Wittstock" }
    , { key = "WL", name = "Harburg", region = "Niedersachsen", origin = "Winsen (luhe)" }
    , { key = "WLG", name = "Vorpommern-Greifswald", region = "Mecklenburg-Vorpommern", origin = "Wolgast" }
    , { key = "WM", name = "Weilheim-Schongau", region = "Bayern", origin = "Weilheim" }
    , { key = "WMS", name = "Börde", region = "Sachsen-Anhalt", origin = "Wolmirstedt" }
    , { key = "WN", name = "Rems-Murr-Kreis", region = "Baden-Württemberg", origin = "Waiblingen" }
    , { key = "WND", name = "St. Wendel", region = "Saarland", origin = "Wendel" }
    , { key = "WO", name = "Worms, Stadt", region = "Rheinland-Pfalz", origin = "" }
    , { key = "WOB", name = "Wolfsburg, Stadt", region = "Niedersachsen", origin = "" }
    , { key = "WOH", name = "Kassel", region = "Hessen", origin = "Wolfhagen" }
    , { key = "WOL", name = "Freudenstadt, Ortenaukreis", region = "Baden-Württemberg", origin = "Wolfach" }
    , { key = "WOR", name = "Bad Tölz-Wolfratshausen, München, Starnberg", region = "Bayern", origin = "Wolfratshausen" }
    , { key = "WOS", name = "Freyung-Grafenau", region = "Bayern", origin = "Wolfstein" }
    , { key = "WR", name = "Harz", region = "Sachsen-Anhalt", origin = "Wernigerode" }
    , { key = "WRN", name = "Mecklenburgische Seenplatte", region = "Mecklenburg-Vorpommern", origin = "Waren" }
    , { key = "WS", name = "Mühldorf am Inn, Rosenheim", region = "Bayern", origin = "Wasserburg" }
    , { key = "WSF", name = "Burgenlandkreis", region = "Sachsen-Anhalt", origin = "Weissenfels" }
    , { key = "WST", name = "Ammerland", region = "Niedersachsen", origin = "Westerstede" }
    , { key = "WSW", name = "Görlitz", region = "Sachsen", origin = "Weisswasser" }
    , { key = "WT", name = "Waldshut", region = "Baden-Württemberg", origin = "" }
    , { key = "WTL", name = "Osnabrück", region = "Niedersachsen", origin = "Wittlage" }
    , { key = "WTM", name = "Wittmund", region = "Niedersachsen", origin = "" }
    , { key = "WUG", name = "Weißenburg-Gunzenhausen", region = "Bayern", origin = "Weißenburg" }
    , { key = "WUN", name = "Wunsiedel im Fichtelgebirge", region = "Bayern", origin = "Wunsiedel" }
    , { key = "WUR", name = "Leipzig", region = "Sachsen", origin = "Wurzen" }
    , { key = "WW", name = "Westerwald", region = "Rheinland-Pfalz", origin = "" }
    , { key = "WZ", name = "Lahn-Dill-Kreis", region = "Hessen", origin = "Wetzlar" }
    , { key = "WZL", name = "Börde", region = "Sachsen-Anhalt", origin = "Wanzleben" }
    , { key = "WÜ", name = "Würzburg", region = "Bayern", origin = "" }
    , { key = "WÜM", name = "Cham", region = "Bayern", origin = "Waldmünchen (mit Einem Buchstabendreher)" }
    , { key = "X", name = "Bundeswehr für NATO-Hauptquartiere", region = "Bund", origin = "" }
    , { key = "Y", name = "Bundeswehr", region = "Bund", origin = "" }
    , { key = "Z", name = "Zwickau", region = "Sachsen", origin = "" }
    , { key = "ZE", name = "Anhalt-Bitterfeld", region = "Sachsen-Anhalt", origin = "Zerbst" }
    , { key = "ZEL", name = "Cochem-Zell", region = "Rheinland-Pfalz", origin = "Zell" }
    , { key = "ZI", name = "Görlitz", region = "Sachsen", origin = "Zittau" }
    , { key = "ZIG", name = "Schwalm-Eder-Kreis", region = "Hessen", origin = "Ziegenhain" }
    , { key = "ZP", name = "Erzgebirgskreis", region = "Sachsen", origin = "Zschopau" }
    , { key = "ZR", name = "Greiz", region = "Thüringen", origin = "Zeulenroda" }
    , { key = "ZS", name = "Teltow-Fläming", region = "Brandenburg", origin = "Zossen" }
    , { key = "ZW", name = "Südwestpfalz, Zweibrücken, Stadt", region = "Rheinland-Pfalz", origin = "Zweibrücken" }
    , { key = "ZZ", name = "Burgenlandkreis", region = "Sachsen-Anhalt", origin = "Zeitz" }
    , { key = "ÖHR", name = "Hohenlohekreis", region = "Baden-Württemberg", origin = "Öhringen" }
    , { key = "ÜB", name = "Ravensburg, Bodenseekreis, Sigmaringen", region = "Baden-Württemberg", origin = "Überlingen" }
    ]
