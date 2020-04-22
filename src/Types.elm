module Types exposing
    ( Model
    , Msg(..)
    , Page(..)
    , RegistrationForm
    , RegistrationFormField(..)
    )


type Page
    = Home
    | ChatMirror
    | Counter
    | Register


type RegistrationFormField
    = Username String
    | Password String
    | PasswordAgain String


type alias RegistrationForm =
    { username : String
    , password : String
    , passwordAgain : String
    }


type alias Model =
    { currentPage : Page
    , username : String
    , draft : String
    , messages : List String
    , counterValue : Int
    , registrationForm : RegistrationForm
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
    | RegistrationFormChange RegistrationFormField
