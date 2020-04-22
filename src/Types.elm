module Types exposing (Model, Msg(..), Page(..))


type Page
    = Home
    | ChatMirror
    | Counter


type alias Model =
    { currentPage : Page
    , username : String
    , draft : String
    , messages : List String
    , counterValue : Int
    }


type Msg
    = ChangeView Page
    | DraftChanged String
    | Send
    | Recv String
    | UserChanged String
    | Decrement
    | Increment
    | Clear
