module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, div, form, h1, h2, input, text)
import Html.Attributes as A
import Html.Events as E



---- MODEL ----


type Search
    = Value String
    | Empty


type alias Plate =
    { key : String
    , name : String
    , region : String
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
        [ h2 []
            [ text "KFZAPP" ]
        , input
            [ E.onInput Change ]
            []
        , div [] [ h1 [] [ text (plateString model) ] ]
        ]


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
    [ { key = "A", name = "Augsburg", region = "Bay" }
    , { key = "AA", name = "Aalen Ostalbkreis", region = "BaWü" }
    , { key = "AB", name = "Aschaffenburg", region = "Bay" }
    , { key = "ABG", name = "Altenburg", region = "Thür" }
    , { key = "AC", name = "Aachen", region = "NrWe" }
    , { key = "AE", name = "Auerbach", region = "Sachs" }
    , { key = "AIC", name = "Aichach-Friedberg", region = "Bay" }
    , { key = "AK", name = "Altenkirchen/Westerwald", region = "Sachs" }
    , { key = "AM", name = "Amberg", region = "Bay" }
    , { key = "AN", name = "Ansbach", region = "Bay" }
    , { key = "ANA", name = "Annaberg", region = "Sachs" }
    , { key = "ANG", name = "Angermünde", region = "Bran" }
    , { key = "ANK", name = "Anklam", region = "MeVo" }
    , { key = "AOE", name = "Altötting", region = "Bay" }
    , { key = "APD", name = "Apolda", region = "Thür" }
    , { key = "ARN", name = "Arnstadt", region = "Thür" }
    , { key = "ART", name = "Artern", region = "Thür" }
    , { key = "AS", name = "Amberg-Sulzbach", region = "Bay" }
    , { key = "ASL", name = "Aschersleben", region = "SaAn" }
    , { key = "AT", name = "Altentreptow", region = "MeVo" }
    , { key = "AU", name = "Aue", region = "Sachs" }
    , { key = "AUR", name = "Aurich", region = "NiSa" }
    , { key = "AW", name = "Bad Neuenahr-Ahrweiler", region = "Sachs" }
    , { key = "AZ", name = "Alzey-Worms", region = "Sachs" }
    , { key = "B", name = "Berlin", region = "Bln" }
    , { key = "BA", name = "Bamberg", region = "Bay" }
    , { key = "BAD", name = "Baden-Baden", region = "BaWü" }
    , { key = "BAR", name = "Barnim", region = "Bran" }
    , { key = "BB", name = "Böblingen", region = "BaWü" }
    , { key = "BBG", name = "Bernburg", region = "SaAn" }
    , { key = "BC", name = "Biberach/Riss", region = "BaWü" }
    , { key = "BED", name = "Brand-Erbisdorf", region = "Sachs" }
    , { key = "BEL", name = "Belzig", region = "Bran" }
    , { key = "BER", name = "Bernau bei Berlin", region = "Bran" }
    , { key = "BGL", name = "Berchtesgadener Land", region = "Bay" }
    , { key = "BI", name = "Bielefeld", region = "NrWe" }
    , { key = "BIR", name = "Birkenfeld/Nahe und Idar-Oberstein", region = "Sachs" }
    , { key = "BIT", name = "Bitburg-Prüm", region = "Sachs" }
    , { key = "BIW", name = "Bischofswerda", region = "Sachs" }
    , { key = "BL", name = "Zollernalbkreis in Balingen", region = "BaWü" }
    , { key = "BM", name = "Erftkreis in Bergheim", region = "NrWe" }
    , { key = "BN", name = "Bonn", region = "NrWe" }
    , { key = "BNA", name = "Borna", region = "Sachs" }
    , { key = "BO", name = "Bochum", region = "NrWe" }
    , { key = "BOR", name = "Borken in Ahaus", region = "NrWe" }
    , { key = "BOT", name = "Bottrop", region = "NrWe" }
    , { key = "BRA", name = "Wesermarsch in Brake", region = "NiSa" }
    , { key = "BRB", name = "Brandenburg", region = "Bran" }
    , { key = "BRG", name = "Burg", region = "SaAn" }
    , { key = "BS", name = "Braunschweig", region = "NiSa" }
    , { key = "BSK", name = "Beeskow", region = "Bran" }
    , { key = "BT", name = "Bayreuth", region = "Bay" }
    , { key = "BTF", name = "Bitterfeld", region = "SaAn" }
    , { key = "BÜS", name = "Büsingen am Hochrhein", region = "BaWü" }
    , { key = "BÜZ", name = "Bützow", region = "MeVo" }
    , { key = "BW", name = "Bundes-Wasser und Schiffahrtsverwaltung", region = "Bund" }
    , { key = "BWL", name = "Baden-Württemberg Landesregierung und Landtag", region = "BaWü" }
    , { key = "BYL", name = "Bayern Landesregierung und Landtag", region = "Bay" }
    , { key = "BZ", name = "Bautzen", region = "Sachs" }
    , { key = "C", name = "Chemnitz", region = "Sachs" }
    , { key = "CA", name = "Calau", region = "Bran" }
    , { key = "CB", name = "Cottbus", region = "Bran" }
    , { key = "CE", name = "Celle", region = "NiSa" }
    , { key = "CHA", name = "Cham/Oberpfalz", region = "Bay" }
    , { key = "CLP", name = "Cloppenburg", region = "NiSa" }
    , { key = "CO", name = "Coburg", region = "Bay" }
    , { key = "COC", name = "Cochem-Zell/Mosel", region = "Sachs" }
    , { key = "COE", name = "Cösfeld/Westfalen", region = "NrWe" }
    , { key = "CUX", name = "Cuxhaven", region = "NiSa" }
    , { key = "CW", name = "Calw", region = "BaWü" }
    , { key = "D", name = "Düsseldorf", region = "NrWe" }
    , { key = "DA", name = "Darmstadt", region = "Hess" }
    , { key = "DAH", name = "Dachau", region = "Bay" }
    , { key = "DAN", name = "Lüchow-Dannenberg", region = "NiSa" }
    , { key = "DAU", name = "Daun (Eifel)", region = "Sachs" }
    , { key = "DB", name = "Deutsche Bundesbahn", region = "Bund" }
    , { key = "DBR", name = "Bad Doberan", region = "MeVo" }
    , { key = "DD", name = "Dresden", region = "Sachs" }
    , { key = "DE", name = "Dessau", region = "SaAn" }
    , { key = "DEG", name = "Deggendorf", region = "Bay" }
    , { key = "DEL", name = "Delmenhorst", region = "NiSa" }
    , { key = "DGF", name = "Dingolfing-Landau", region = "Bay" }
    , { key = "DH", name = "Diepholz", region = "NiSa" }
    , { key = "DL", name = "Döbeln", region = "Sachs" }
    , { key = "DLG", name = "Dillingen/Donau", region = "Bay" }
    , { key = "DM", name = "Demmin", region = "MeVo" }
    , { key = "DN", name = "Düren", region = "NrWe" }
    , { key = "DO", name = "Dortmund", region = "NrWe" }
    , { key = "DON", name = "Donau-Ries in Donauwörth", region = "Bay" }
    , { key = "DS", name = "Dahme-Spreewald", region = "Bran" }
    , { key = "DU", name = "Duisburg", region = "NrWe" }
    , { key = "DÜW", name = "Bad Dürkheim in Neustadt/Weinstrasse", region = "Sachs" }
    , { key = "DW", name = "Dippoldiswalde", region = "Sachs" }
    , { key = "DZ", name = "Delitzsch", region = "Sachs" }
    , { key = "E", name = "Essen", region = "NrWe" }
    , { key = "EB", name = "Eilenburg", region = "Sachs" }
    , { key = "EBE", name = "Ebersberg", region = "Sachs" }
    , { key = "ED", name = "Erding", region = "Bay" }
    , { key = "EE", name = "Elbe-Elster", region = "Bran" }
    , { key = "EF", name = "Erfurt", region = "Thür" }
    , { key = "EH", name = "Eisenhüttenstadt", region = "Bran" }
    , { key = "EI", name = "Eichstätt", region = "Bay" }
    , { key = "EIL", name = "Eisleben", region = "SaAn" }
    , { key = "EIS", name = "Eisenberg", region = "Thür" }
    , { key = "EL", name = "Emsland in Meppen", region = "NiSa" }
    , { key = "EM", name = "Emmendingen", region = "BaWü" }
    , { key = "EMD", name = "Emden", region = "NiSa" }
    , { key = "EMS", name = "Rhein-Lahn-Kreis in Bad Ems", region = "Sachs" }
    , { key = "EN", name = "Ennepe-Ruhr-Kreis in Schwelm", region = "NrWe" }
    , { key = "ER", name = "Erlangen/Stadt", region = "Bay" }
    , { key = "ERB", name = "Odenwaldkreis in Erbach", region = "Hess" }
    , { key = "ERH", name = "Erlangen-Höchstadt", region = "Bay" }
    , { key = "ES", name = "Esslingen/Neckar", region = "BaWü" }
    , { key = "ESA", name = "Eisenach", region = "Thür" }
    , { key = "ESW", name = "Werra-Meissner-Kreis in Eschwege", region = "Hess" }
    , { key = "EU", name = "Euskirchen", region = "NrWe" }
    , { key = "EW", name = "Eberswalde", region = "Bran" }
    , { key = "F", name = "Frankfurt/Main", region = "Hess" }
    , { key = "FB", name = "Wetteraukreis in Friedberg", region = "Hess" }
    , { key = "FD", name = "Fulda", region = "Hess" }
    , { key = "FDS", name = "Freudenstadt", region = "BaWü" }
    , { key = "FF", name = "Frankfurt/Oder", region = "Bran" }
    , { key = "FFB", name = "Fürstenfeldbruck", region = "Bay" }
    , { key = "FG", name = "Freiberg/Sachsen", region = "Sachs" }
    , { key = "FI", name = "Finsterwalde", region = "Bran" }
    , { key = "FL", name = "Flensburg", region = "SlHo" }
    , { key = "FLÖ", name = "Flöha", region = "Sachs" }
    , { key = "FN", name = "Bodenseekreis in Friedrichshafen", region = "BaWü" }
    , { key = "FO", name = "Forchheim", region = "Bay" }
    , { key = "FOR", name = "Forst", region = "Bran" }
    , { key = "FR", name = "Freiburg/Breisgau", region = "BaWü" }
    , { key = "FRG", name = "Freyung-Grafenau", region = "Bay" }
    , { key = "FRI", name = "Friesland in Jever", region = "NiSa" }
    , { key = "FRW", name = "Bad Freienwalde", region = "Bran" }
    , { key = "FS", name = "Freising", region = "Bay" }
    , { key = "FT", name = "Frankenthal/Pfalz", region = "Sachs" }
    , { key = "FTL", name = "Freital", region = "Sachs" }
    , { key = "FÜ", name = "Fürth", region = "Bay" }
    , { key = "FW", name = "Fürstenwalde", region = "Bran" }
    , { key = "G", name = "Gera", region = "Thür" }
    , { key = "GA", name = "Gardelegen", region = "SaAn" }
    , { key = "GAP", name = "Garmisch-Partenkirchen", region = "Bay" }
    , { key = "GC", name = "Glauchau", region = "Sachs" }
    , { key = "GDB", name = "Gadebusch", region = "MeVo" }
    , { key = "GE", name = "Gelsenkirchen", region = "NrWe" }
    , { key = "GER", name = "Germersheim", region = "Sachs" }
    , { key = "GF", name = "Gifhorn", region = "NiSa" }
    , { key = "GG", name = "Gross-Gerau", region = "Hess" }
    , { key = "GHA", name = "Geithain", region = "Sachs" }
    , { key = "GHC", name = "Gräfenhainichen", region = "SaAn" }
    , { key = "GI", name = "Giessen", region = "Hess" }
    , { key = "GL", name = "Rheinisch-Bergischer Kreis in Bergisch Gladbach", region = "NrWe" }
    , { key = "GM", name = "Oberbergischer Kreis in Gummersbach", region = "NrWe" }
    , { key = "GMN", name = "Grimmen", region = "MeVo" }
    , { key = "GNT", name = "Genthin", region = "SaAn" }
    , { key = "GÖ", name = "Göttingen", region = "NiSa" }
    , { key = "GP", name = "Göppingen", region = "BaWü" }
    , { key = "GR", name = "Görlitz", region = "Sachs" }
    , { key = "GRH", name = "Grossenhain", region = "Sachs" }
    , { key = "GRM", name = "Grimma", region = "Sachs" }
    , { key = "GRS", name = "Gransee", region = "Bran" }
    , { key = "GRZ", name = "Greiz", region = "Thür" }
    , { key = "GS", name = "Goslar", region = "NiSa" }
    , { key = "GT", name = "Gütersloh in Rheda-Wiedenbrück", region = "NrWe" }
    , { key = "GTH", name = "Gotha", region = "Thür" }
    , { key = "GÜ", name = "Güstrow", region = "MeVo" }
    , { key = "GUB", name = "Guben", region = "Bran" }
    , { key = "GVM", name = "Grevesmühlen", region = "MeVo" }
    , { key = "GW", name = "Greifswald/Landkreis", region = "MeVo" }
    , { key = "GZ", name = "Günzburg", region = "Bay" }
    , { key = "H", name = "Hannover", region = "NiSa" }
    , { key = "HA", name = "Hagen/Westfalen", region = "NrWe" }
    , { key = "HAL", name = "Halle/Saale", region = "SaAn" }
    , { key = "HAM", name = "Hamm/Westfalen", region = "NrWe" }
    , { key = "HAS", name = "Hassberge in Hassfurt", region = "Bay" }
    , { key = "HB", name = "Hansestadt Bremen und Bremerhaven", region = "Bre" }
    , { key = "HBN", name = "Hildburghausen", region = "Thür" }
    , { key = "HBS", name = "Halberstadt", region = "SaAn" }
    , { key = "HC", name = "Hainichen", region = "Sachs" }
    , { key = "HD", name = "Rhein-Neckar-Kreis und Heidelberg", region = "BaWü" }
    , { key = "HDH", name = "Heidenheim/Brenz", region = "BaWü" }
    , { key = "HDL", name = "Haldensleben", region = "SaAn" }
    , { key = "HE", name = "Helmstedt", region = "NiSa" }
    , { key = "HEF", name = "Bad Hersfeld-Rotenburg", region = "Hess" }
    , { key = "HEI", name = "Dithmarschen in Heide/Holstein", region = "SlHo" }
    , { key = "HER", name = "Herne", region = "NrWe" }
    , { key = "HET", name = "Hettstedt", region = "SaAn" }
    , { key = "HF", name = "Herford in Kirchlengern", region = "NrWe" }
    , { key = "HG", name = "Hochtaunuskreis in Bad Homburg v.d.H.", region = "Hess" }
    , { key = "HGN", name = "Hagenow", region = "MeVo" }
    , { key = "HGW", name = "Hansestadt Greifswald", region = "MeVo" }
    , { key = "HH", name = "Hansestadt Hamburg", region = "Hbg" }
    , { key = "HHM", name = "Hohenmölsen", region = "SaAn" }
    , { key = "HI", name = "Hildesheim", region = "NiSa" }
    , { key = "HIG", name = "Heiligenstadt", region = "Thür" }
    , { key = "HL", name = "Hansestadt Lübeck", region = "SlHo" }
    , { key = "HM", name = "Hameln-Pyrmont", region = "NiSa" }
    , { key = "HN", name = "Heilbronn/Neckar", region = "BaWü" }
    , { key = "HO", name = "Hof", region = "Bay" }
    , { key = "HOL", name = "Holzminden", region = "NiSa" }
    , { key = "HOM", name = "Saar-Pfalz-Kreis in Homburg/Saar", region = "Saar" }
    , { key = "HOT", name = "Hohenstein-Ernstthal", region = "Sachs" }
    , { key = "HP", name = "Bergstrasse in Heppenheim", region = "Hess" }
    , { key = "HR", name = "Schwalm-Eder-Kreis in Homberg", region = "Hess" }
    , { key = "HRO", name = "Hansestadt Rostock", region = "MeVo" }
    , { key = "HS", name = "Heinsberg", region = "NrWe" }
    , { key = "HSK", name = "Hochsauerlandkreis in Meschede", region = "NrWe" }
    , { key = "HST", name = "Hansestadt Stralsund", region = "MeVo" }
    , { key = "HU", name = "Hanau", region = "Hess" }
    , { key = "HV", name = "Havelberg", region = "SaAn" }
    , { key = "HVL", name = "Havelland", region = "Bran" }
    , { key = "HWI", name = "Hansestadt Wismar", region = "MeVo" }
    , { key = "HX", name = "Höxter", region = "NrWe" }
    , { key = "HY", name = "Hoyerswerda", region = "Sachs" }
    , { key = "HZ", name = "Herzberg", region = "Bran" }
    , { key = "IGB", name = "St. Ingbert", region = "Saar" }
    , { key = "IL", name = "Ilmenau", region = "Thür" }
    , { key = "IN", name = "Ingolstadt/Donau", region = "Bay" }
    , { key = "IZ", name = "Itzehoe", region = "SlHo" }
    , { key = "J", name = "Jena", region = "Thür" }
    , { key = "JB", name = "Joeterbog", region = "Bran" }
    , { key = "JE", name = "Jessen", region = "SaAn" }
    , { key = "K", name = "Köln", region = "NrWe" }
    , { key = "KA", name = "Karlsruhe", region = "BaWü" }
    , { key = "KB", name = "Waldeck-Frankenberg in Korbach", region = "Hess" }
    , { key = "KC", name = "Kronach", region = "Bay" }
    , { key = "KE", name = "Kempten/Allgäu", region = "Bay" }
    , { key = "KEH", name = "Kelheim", region = "Bay" }
    , { key = "KF", name = "Kaufbeuren", region = "Bay" }
    , { key = "KG", name = "Bad Kissingen", region = "Bay" }
    , { key = "KH", name = "Bad Kreuznach", region = "Sachs" }
    , { key = "KI", name = "Kiel", region = "SlHo" }
    , { key = "KIB", name = "Donnersberg-Kreis in Kirchheimbolanden", region = "Sachs" }
    , { key = "KL", name = "Kaiserslautern", region = "Sachs" }
    , { key = "KLE", name = "Kleve", region = "NrWe" }
    , { key = "KLZ", name = "Klötze", region = "SaAn" }
    , { key = "KM", name = "Kamenz", region = "Sachs" }
    , { key = "KN", name = "Konstanz", region = "BaWü" }
    , { key = "KO", name = "Koblenz", region = "Sachs" }
    , { key = "KÖT", name = "Köthen", region = "SaAn" }
    , { key = "KR", name = "Krefeld", region = "NrWe" }
    , { key = "KS", name = "Kassel", region = "Hess" }
    , { key = "KT", name = "Kitzingen", region = "Bay" }
    , { key = "KU", name = "Kulmbach", region = "Bay" }
    , { key = "KÜN", name = "Hohenlohe-Kreis in Künzelsau", region = "BaWü" }
    , { key = "KUS", name = "Kusel", region = "Sachs" }
    , { key = "KW", name = "Königs-Wusterhausen", region = "Bran" }
    , { key = "KY", name = "Kyritz", region = "Bran" }
    , { key = "L", name = "Leipzig", region = "Sachs" }
    , { key = "LA", name = "Landshut", region = "Bay" }
    , { key = "LAU", name = "Nürnberger Land in Lauf/Pegnitz", region = "Bay" }
    , { key = "LB", name = "Ludwigsburg", region = "BaWü" }
    , { key = "LBS", name = "Lobenstein", region = "Thür" }
    , { key = "LBZ", name = "Lübz", region = "MeVo" }
    , { key = "LC", name = "Luckau", region = "Sachs" }
    , { key = "LD", name = "Landau/Pfalz", region = "Sachs" }
    , { key = "LDK", name = "Lahn-Dill-Kreis in Wetzlar", region = "Hess" }
    , { key = "LER", name = "Leer/Ostfriesland", region = "NiSa" }
    , { key = "LEV", name = "Leverkusen", region = "NrWe" }
    , { key = "LG", name = "Lüneburg", region = "NiSa" }
    , { key = "LI", name = "Lindau/Bodensee", region = "Bay" }
    , { key = "LIB", name = "Bad Liebenwerda", region = "Bran" }
    , { key = "LIF", name = "Lichtenfels", region = "Bay" }
    , { key = "LIP", name = "Lippe in Detmold", region = "NrWe" }
    , { key = "LL", name = "Landsberg/Lech", region = "Bay" }
    , { key = "LM", name = "Limburg-Weilburg/Lahn", region = "Hess" }
    , { key = "LN", name = "Lübben", region = "Bran" }
    , { key = "LÖ", name = "Lörrach", region = "BaWü" }
    , { key = "LÖB", name = "Löbau", region = "Sachs" }
    , { key = "LOS", name = "Oder-Spree", region = "Bran" }
    , { key = "LSA", name = "Sachsen-Anhalt Landesregierung und Landtag", region = "SaAn" }
    , { key = "LSN", name = "Sachsen Landesregierung und Landtag", region = "Sachs" }
    , { key = "LSZ", name = "Bad Langensalza", region = "Thür" }
    , { key = "LU", name = "Ludwigshafen/Rhein", region = "Sachs" }
    , { key = "LUK", name = "Luckenwalde", region = "Bran" }
    , { key = "LWL", name = "Ludwigslust", region = "MeVo" }
    , { key = "M", name = "München", region = "Bay" }
    , { key = "MA", name = "Mannheim", region = "BaWü" }
    , { key = "MAB", name = "Marienberg", region = "Sachs" }
    , { key = "MB", name = "Miesbach", region = "Bay" }
    , { key = "MC", name = "Malchin", region = "MeVo" }
    , { key = "MD", name = "Magdeburg", region = "SaAn" }
    , { key = "ME", name = "Mettmann", region = "NrWe" }
    , { key = "MEI", name = "Meissen", region = "Sachs" }
    , { key = "MER", name = "Merseburg", region = "SaAn" }
    , { key = "MG", name = "Mönchengladbach", region = "NrWe" }
    , { key = "MGN", name = "Meiningen", region = "Thür" }
    , { key = "MH", name = "Mülheim/Ruhr", region = "NrWe" }
    , { key = "MHL", name = "Mühlhausen", region = "Thür" }
    , { key = "MI", name = "Minden-Lübbecke/Westfalen", region = "NrWe" }
    , { key = "MIL", name = "Miltenberg", region = "Bay" }
    , { key = "MK", name = "Märkischer Kreis in Lüdenscheid", region = "NrWe" }
    , { key = "MM", name = "Memmingen", region = "Bay" }
    , { key = "MN", name = "Unterallgäu in Mindelheim", region = "Bay" }
    , { key = "MOL", name = "Märkisch-Oderland", region = "Bran" }
    , { key = "MOS", name = "Neckar-Odenwald-Kreis in Mosbach", region = "BaWü" }
    , { key = "MR", name = "Marburg-Biedenkopf/Lahn", region = "Hess" }
    , { key = "MS", name = "Münster/Westfalen", region = "NrWe" }
    , { key = "MSP", name = "Main-Spessart-Kreis in Karlstadt", region = "Bay" }
    , { key = "MTK", name = "Main-Taunus-Kreis in Hofheim", region = "Hess" }
    , { key = "MÜ", name = "Mühldorf am Inn", region = "Bay" }
    , { key = "MVL", name = "Mecklenburg-Vorpommern Landesregierung und Landtag", region = "MeVo" }
    , { key = "MYK", name = "Mayen-Koblenz", region = "Sachs" }
    , { key = "MZ", name = "Mainz-Bingen und Mainz", region = "Sachs" }
    , { key = "MZG", name = "Merzig-Wadern", region = "Saar" }
    , { key = "N", name = "Nürnberg", region = "Bay" }
    , { key = "NAU", name = "Nauen", region = "Bran" }
    , { key = "NB", name = "Neubrandenburg", region = "MeVo" }
    , { key = "ND", name = "Neuburg-Schrobenhausen/Donau", region = "Bay" }
    , { key = "NDH", name = "Nordhausen", region = "Thür" }
    , { key = "NE", name = "Neuss", region = "NrWe" }
    , { key = "NEA", name = "Neustadt-Bad Windsheim/Aisch", region = "Bay" }
    , { key = "NEB", name = "Nebra/Unstrut", region = "SaAn" }
    , { key = "NES", name = "Rhön-Grabfeld in Bad Neustadt/Saale", region = "Bay" }
    , { key = "NEW", name = "Neustadt/Waldnaab", region = "Bay" }
    , { key = "NF", name = "Nordfriesland in Husum", region = "SlHo" }
    , { key = "NH", name = "Neuhaus/Rennsteig", region = "Thür" }
    , { key = "NI", name = "Nienburg/Weser", region = "NiSa" }
    , { key = "NK", name = "Neunkirchen/Saar", region = "Saar" }
    , { key = "NL", name = "Niedersachsen Landesregierung und Landtag", region = "NiSa" }
    , { key = "NM", name = "Neumarkt/Oberpfalz", region = "Bay" }
    , { key = "NMB", name = "Naumburg/Saale", region = "SaAn" }
    , { key = "NMS", name = "Neumünster", region = "SlHo" }
    , { key = "NOH", name = "Grafschaft Bentheim in Nordhorn", region = "NiSa" }
    , { key = "NOM", name = "Northeim", region = "NiSa" }
    , { key = "NP", name = "Neuruppin", region = "Bran" }
    , { key = "NR", name = "Neuwied/Rhein", region = "Sachs" }
    , { key = "NRW", name = "Nordrhein-Westfalen Landesregierung und Landtag", region = "NrWe" }
    , { key = "NU", name = "Neu-Ulm", region = "Bay" }
    , { key = "NW", name = "Neustadt/Weinstrasse", region = "Sachs" }
    , { key = "NY", name = "Niesky", region = "Sachs" }
    , { key = "NZ", name = "Neustrelitz", region = "MeVo" }
    , { key = "OA", name = "Oberallgäu in Sonthofen", region = "Bay" }
    , { key = "OAL", name = "Ostallgäu in Marktoberdorf", region = "Bay" }
    , { key = "OB", name = "Oberhausen/Rheinland", region = "NrWe" }
    , { key = "OBG", name = "Osterburg", region = "SaAn" }
    , { key = "OC", name = "Oschersleben", region = "SaAn" }
    , { key = "OD", name = "Stormarn in Bad Oldesloe", region = "SlHo" }
    , { key = "OE", name = "Olpe", region = "NrWe" }
    , { key = "OF", name = "Offenbach/Main", region = "Hess" }
    , { key = "OG", name = "Ortenaukreis in Offenburg", region = "BaWü" }
    , { key = "OH", name = "Ostholstein in Eutin", region = "SlHo" }
    , { key = "OHA", name = "Osterode/Harz", region = "NiSa" }
    , { key = "OHV", name = "Oberhavel", region = "Bran" }
    , { key = "OHZ", name = "Osterholz-Scharmbeck", region = "NiSa" }
    , { key = "OL", name = "Oldenburg", region = "NiSa" }
    , { key = "OPR", name = "Ostprignitz-Ruppin", region = "Bran" }
    , { key = "OR", name = "Oranienburg", region = "Bran" }
    , { key = "OS", name = "Osnabrück", region = "NiSa" }
    , { key = "OSL", name = "Oberspreewald-Lausitz", region = "Bran" }
    , { key = "OVL", name = "Obervogtland in Klingenthal und Ölsnitz", region = "Sachs" }
    , { key = "OZ", name = "Oschatz", region = "Sachs" }
    , { key = "P", name = "Potsdam", region = "Bran" }
    , { key = "PA", name = "Passau", region = "Bay" }
    , { key = "PAF", name = "Pfaffenhofen/Ilm", region = "Bay" }
    , { key = "PAN", name = "Rottal-Inn in Pfarrkirchen", region = "Bay" }
    , { key = "PB", name = "Paderborn", region = "NiSa" }
    , { key = "PCH", name = "Parchim", region = "MeVo" }
    , { key = "PE", name = "Peine", region = "NiSa" }
    , { key = "PER", name = "Perleberg", region = "Bran" }
    , { key = "PF", name = "Enzkreis und Pforzheim", region = "BaWü" }
    , { key = "PI", name = "Pinneberg", region = "SlHo" }
    , { key = "PIR", name = "Pirna", region = "Sachs" }
    , { key = "PK", name = "Pritzwalk", region = "Bran" }
    , { key = "PL", name = "Plauen", region = "Sachs" }
    , { key = "PLÖ", name = "Plön/Holstein", region = "SlHo" }
    , { key = "PM", name = "Potsdam-Mittelmark", region = "Bran" }
    , { key = "PN", name = "Pössneck", region = "Thür" }
    , { key = "PR", name = "Prignitz", region = "Bran" }
    , { key = "PS", name = "Pirmasens", region = "Sachs" }
    , { key = "PW", name = "Pasewalk", region = "MeVo" }
    , { key = "PZ", name = "Prenzlau", region = "Bran" }
    , { key = "QFT", name = "Querfurt", region = "SaAn" }
    , { key = "QLB", name = "Quedlinburg", region = "SaAn" }
    , { key = "R", name = "Regensburg", region = "Bay" }
    , { key = "RA", name = "Rastatt", region = "BaWü" }
    , { key = "RC", name = "Reichenbach/Vogtland", region = "Sachs" }
    , { key = "RD", name = "Rendsburg-Eckernfoerde", region = "SlHo" }
    , { key = "RDG", name = "Ribnitz-Damgarten", region = "MeVo" }
    , { key = "RE", name = "Recklinghausen in Marl", region = "NrWe" }
    , { key = "REG", name = "Regen (Bayr. Wald)", region = "Bay" }
    , { key = "RH", name = "Roth/Rednitz", region = "Bay" }
    , { key = "RIE", name = "Riesa", region = "Sachs" }
    , { key = "RL", name = "Rochlitz", region = "Sachs" }
    , { key = "RM", name = "Röbel/Müritz", region = "MeVo" }
    , { key = "RN", name = "Rathenow", region = "Bran" }
    , { key = "RO", name = "Rosenheim", region = "Bay" }
    , { key = "ROS", name = "Rostock/Landkreis", region = "MeVo" }
    , { key = "ROW", name = "Rotenburg/Wümme", region = "NiSa" }
    , { key = "RPL", name = "Rheinland-Pfalz Landesregierung und Landtag", region = "Sachs" }
    , { key = "RS", name = "Remscheid", region = "NrWe" }
    , { key = "RSL", name = "Rosslau/Elbe", region = "SaAn" }
    , { key = "RT", name = "Reutlingen", region = "BaWü" }
    , { key = "RU", name = "Rudolstadt", region = "Thür" }
    , { key = "RÜD", name = "Rheingau-Taunus-Kreis in Rüdesheim", region = "Hess" }
    , { key = "RÜG", name = "Rügen in Bergen", region = "MeVo" }
    , { key = "RV", name = "Ravensburg", region = "BaWü" }
    , { key = "RW", name = "Rottweil", region = "BaWü" }
    , { key = "RZ", name = "Herzogtum Lauenburg in Ratzeburg", region = "SlHo" }
    , { key = "S", name = "Stuttgart", region = "BaWü" }
    , { key = "SAD", name = "Schwandorf", region = "Bay" }
    , { key = "SAL", name = "Saarland Landesregierung und Landtag", region = "Saar" }
    , { key = "SAW", name = "Salzwedel", region = "SaAn" }
    , { key = "SB", name = "Saarbrücken", region = "Saar" }
    , { key = "SBG", name = "Strasburg", region = "MeVo" }
    , { key = "SBK", name = "Schönebeck/Elbe", region = "SaAn" }
    , { key = "SC", name = "Schwabach", region = "Bay" }
    , { key = "SCZ", name = "Schleiz", region = "Thür" }
    , { key = "SDH", name = "Sondershausen", region = "Thür" }
    , { key = "SDL", name = "Stendal", region = "SaAn" }
    , { key = "SDT", name = "Schwedt/Oder", region = "Bran" }
    , { key = "SE", name = "Bad Segeberg", region = "SlHo" }
    , { key = "SEB", name = "Sebnitz", region = "Sachs" }
    , { key = "SEE", name = "Seelow", region = "Bran" }
    , { key = "SFA", name = "Soltau-Fallingbostel", region = "NiSa" }
    , { key = "SFB", name = "Senftenberg", region = "Bran" }
    , { key = "SFT", name = "Stassfurt", region = "SaAn" }
    , { key = "SG", name = "Solingen", region = "NrWe" }
    , { key = "SGH", name = "Sangerhausen", region = "SaAn" }
    , { key = "SH", name = "Schleswig-Holstein Landesregierung und Landtag", region = "SlHo" }
    , { key = "SHA", name = "Schwäbisch Hall", region = "BaWü" }
    , { key = "SHG", name = "Schaumburg in Stadthagen", region = "NiSa" }
    , { key = "SHL", name = "Suhl", region = "Thür" }
    , { key = "SI", name = "Siegen", region = "NrWe" }
    , { key = "SIG", name = "Sigmaringen", region = "BaWü" }
    , { key = "SIM", name = "Rhein-Hunsrück-Kreis in Simmern", region = "Sachs" }
    , { key = "SK", name = "Saalkreis in Halle", region = "SaAn" }
    , { key = "SL", name = "Schleswig-Flensburg", region = "SlHo" }
    , { key = "SLF", name = "Saalfeld", region = "Thür" }
    , { key = "SLN", name = "Schmölln", region = "Thür" }
    , { key = "SLS", name = "Saarlouis", region = "Saar" }
    , { key = "SLZ", name = "Bad Salzungen", region = "Thür" }
    , { key = "SM", name = "Schmalkalden", region = "Thür" }
    , { key = "SN", name = "Schwerin", region = "MeVo" }
    , { key = "SO", name = "Söst", region = "NrWe" }
    , { key = "SÖM", name = "Sömmerda", region = "Thür" }
    , { key = "SON", name = "Sonneberg", region = "Thür" }
    , { key = "SP", name = "Speyer", region = "Sachs" }
    , { key = "SPB", name = "Spremberg", region = "Bran" }
    , { key = "SPN", name = "Spree-Neisse", region = "Bran" }
    , { key = "SR", name = "Straubing-Bogen", region = "Bay" }
    , { key = "SRB", name = "Strausberg", region = "Bran" }
    , { key = "SRO", name = "Stadtroda", region = "Thür" }
    , { key = "ST", name = "Steinfurt", region = "NrWe" }
    , { key = "STA", name = "Starnberg", region = "Bay" }
    , { key = "STB", name = "Sternberg", region = "MeVo" }
    , { key = "STD", name = "Stade", region = "NiSa" }
    , { key = "STL", name = "Stollberg", region = "Sachs" }
    , { key = "SU", name = "Rhein-Sieg-Kreis in Siegburg", region = "NrWe" }
    , { key = "SÜW", name = "Südl. Weinstrasse in Landau", region = "Sachs" }
    , { key = "SW", name = "Schweinfurt", region = "Bay" }
    , { key = "SZ", name = "Salzgitter", region = "NiSa" }
    , { key = "SZB", name = "Schwarzenberg", region = "Sachs" }
    , { key = "TBB", name = "Main-Tauber-Kreis in Tauberbischofsheim", region = "BaWü" }
    , { key = "TET", name = "Teterow", region = "MeVo" }
    , { key = "TF", name = "Teltow-Fläming", region = "Bran" }
    , { key = "TG", name = "Torgau", region = "Sachs" }
    , { key = "THL", name = "Thüringen Landesregierung und Landtag", region = "Thür" }
    , { key = "TIR", name = "Tirschenreuth", region = "Bay" }
    , { key = "TÖL", name = "Bad Tölz-Wolfratshausen", region = "Bay" }
    , { key = "TP", name = "Templin/Uckermark", region = "Bran" }
    , { key = "TR", name = "Trier-Saarburg", region = "Sachs" }
    , { key = "TS", name = "Traunstein", region = "Bay" }
    , { key = "TÜ", name = "Tübingen", region = "BaWü" }
    , { key = "TUT", name = "Tuttlingen", region = "BaWü" }
    , { key = "UE", name = "Ülzen", region = "NiSa" }
    , { key = "UEM", name = "Ückermünde", region = "MeVo" }
    , { key = "UL", name = "Alb-Donau-Kreis und Ulm", region = "BaWü" }
    , { key = "UM", name = "Uckermark", region = "Bran" }
    , { key = "UN", name = "Unna/Westfalen", region = "NrWe" }
    , { key = "VB", name = "Vogelsbergkreis in Lauterbach", region = "Hess" }
    , { key = "VEC", name = "Vechta", region = "NiSa" }
    , { key = "VER", name = "Verden/Aller", region = "NiSa" }
    , { key = "VIE", name = "Viersen", region = "NrWe" }
    , { key = "VK", name = "Völklingen", region = "Saar" }
    , { key = "VS", name = "Schwarzwald-Baar-Kreis in Villingen-Schwenningen", region = "BaWü" }
    , { key = "W", name = "Wuppertal", region = "NrWe" }
    , { key = "WAF", name = "Warendorf", region = "NrWe" }
    , { key = "WB", name = "Wittenberg", region = "SaAn" }
    , { key = "WBS", name = "Worbis", region = "Thür" }
    , { key = "WDA", name = "Werdau", region = "Sachs" }
    , { key = "WE", name = "Weimar", region = "Thür" }
    , { key = "WEN", name = "Weiden/Oberpfalz", region = "Bay" }
    , { key = "WES", name = "Wesel in Mörs", region = "NrWe" }
    , { key = "WF", name = "Wolfenbüttel", region = "NiSa" }
    , { key = "WHV", name = "Wilhelmshaven", region = "NiSa" }
    , { key = "WI", name = "Wiesbaden", region = "Hess" }
    , { key = "WIL", name = "Bernkastel-Wittlich/Mosel", region = "Sachs" }
    , { key = "WIS", name = "Wismar/Landkreis", region = "MeVo" }
    , { key = "WK", name = "Wittstock", region = "Bran" }
    , { key = "WL", name = "Harburg in Winsen/Luhe", region = "NiSa" }
    , { key = "WLG", name = "Wolgast/Usedom", region = "MeVo" }
    , { key = "WM", name = "Weilheim-Schongau/Oberbayern", region = "Bay" }
    , { key = "WMS", name = "Wolmirstedt", region = "Sachs" }
    , { key = "WN", name = "Rems-Murr-Kreis in Waiblingen", region = "BaWü" }
    , { key = "WND", name = "St. Wendel", region = "Saar" }
    , { key = "WO", name = "Worms", region = "Sachs" }
    , { key = "WOB", name = "Wolfsburg", region = "NiSa" }
    , { key = "WR", name = "Wernigerode", region = "SaAn" }
    , { key = "WRN", name = "Waren/Müritz", region = "MeVo" }
    , { key = "WSF", name = "Weissenfels", region = "SaAn" }
    , { key = "WST", name = "Ammerland in Westerstede", region = "NiSa" }
    , { key = "WSW", name = "Weisswasser", region = "Sachs" }
    , { key = "WT", name = "Waldshut-Tiengen", region = "BaWü" }
    , { key = "WTM", name = "Wittmund", region = "NiSa" }
    , { key = "WÜ", name = "Würzburg", region = "Bay" }
    , { key = "WUG", name = "Weissenburg-Gunzenhausen", region = "Bay" }
    , { key = "WUN", name = "Wunsiedel", region = "Bay" }
    , { key = "WUR", name = "Wurzen", region = "Sachs" }
    , { key = "WW", name = "Westerwald in Montabaur", region = "Sachs" }
    , { key = "WZL", name = "Wanzleben", region = "SaAn" }
    , { key = "X", name = "Bundeswehr für NATO-Hauptquartiere", region = "Bund" }
    , { key = "Y", name = "Bundeswehr", region = "Bund" }
    , { key = "Z", name = "Zwickau", region = "Sachs" }
    , { key = "ZE", name = "Zerbst", region = "SaAn" }
    , { key = "ZI", name = "Zittau", region = "Sachs" }
    , { key = "ZP", name = "Zschopau", region = "Sachs" }
    , { key = "ZR", name = "Zeulenroda", region = "Thür" }
    , { key = "ZS", name = "Zossen", region = "Bran" }
    , { key = "ZW", name = "Zweibrücken", region = "Sachs" }
    , { key = "ZZ", name = "Zeitz", region = "SaAn" }
    ]
