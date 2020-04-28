module Types exposing
    ( Chat
    , ChatMsg(..)
    , CounterMsg(..)
    , Model
    , Msg(..)
    , RegistrationForm
    , RegistrationMsg(..)
    , Route(..)
    )

import Browser
import Browser.Navigation as Navigation
import Url


type Route
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
    { url : Url.Url
    , key : Navigation.Key
    , chat : Chat
    , counterValue : Int
    , registrationForm : RegistrationForm
    }


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | UpdateChat ChatMsg
    | UpdateCounter CounterMsg
    | UpdateRegistrationForm RegistrationMsg
