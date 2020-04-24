module Types exposing
    ( Chat
    , ChatChange(..)
    , Model
    , Msg(..)
    , Page(..)
    , RegistrationForm
    , RegistrationFormFieldChange(..)
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


type RegistrationFormFieldChange
    = Username String
    | Password String
    | PasswordAgain String


type alias Chat =
    { username : String
    , draft : String
    , messages : List String
    }


type ChatChange
    = Draft String
    | User String
    | Send
    | Receive String


type alias Model =
    { currentPage : Page
    , chat : Chat
    , counterValue : Int
    , registrationForm : RegistrationForm
    }


type Msg
    = ChangeView Page
    | UpdateChat ChatChange
    | Decrement
    | Increment
    | Clear
    | UpdateRegistrationForm RegistrationFormFieldChange
