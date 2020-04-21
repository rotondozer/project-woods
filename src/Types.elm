module Types exposing (..)


type Page
    = Home
    | ChatMirror


type alias Model =
    { currentPage : Page
    , username : String
    , draft : String
    , messages : List String
    }


type Msg
    = ChangeView Page
    | DraftChanged String
    | Send
    | Recv String
    | UserChanged String
