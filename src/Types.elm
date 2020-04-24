module Types exposing
    ( Chat
    , ChatMsg(..)
    , CounterMsg(..)
    , Model
    , Msg(..)
    , Page(..)
    , RegistrationForm
    , RegistrationMsg(..)
    )


type Page
    = Home
    | ChatMirror
    | Counter
    | Register


type alias RegistrationForm =
    { username : String
    , password : String
    , passwordAgain : String
    }


type RegistrationMsg
    = Username String
    | Password String
    | PasswordAgain String


type alias Chat =
    { username : String
    , draft : String
    , messages : List String
    }


type ChatMsg
    = Draft String
    | User String
    | Send
    | Receive String


type CounterMsg
    = Increment
    | Decrement
    | Clear


type alias Model =
    { currentPage : Page
    , chat : Chat
    , counterValue : Int
    , registrationForm : RegistrationForm
    }


type Msg
    = ChangeView Page
    | UpdateChat ChatMsg
    | UpdateCounter CounterMsg
    | UpdateRegistrationForm RegistrationMsg
