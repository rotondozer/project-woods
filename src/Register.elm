module Register exposing (init, update, view)

import Html exposing (Html, div, input)
import Html.Attributes exposing (placeholder, type_, value)
import Html.Events exposing (onInput)
import Types exposing (Msg(..), RegistrationForm, RegistrationMsg(..))


init : RegistrationForm
init =
    { username = "", password = "", passwordAgain = "" }



-- UPDATE


update : RegistrationMsg -> RegistrationForm -> RegistrationForm
update registrationMsg form =
    case registrationMsg of
        Username value ->
            { form | username = value }

        Password value ->
            { form | password = value }

        PasswordAgain value ->
            { form | passwordAgain = value }



-- VIEW


view : RegistrationForm -> Html Msg
view form =
    div []
        [ viewInput "text" "Username" form.username Username
        , viewInput "password" "Password" form.password Password
        , viewInput "password" "Confirm Password" form.passwordAgain PasswordAgain
        ]


viewInput : String -> String -> String -> (String -> RegistrationMsg) -> Html Msg
viewInput t p v fieldChange =
    input [ type_ t, placeholder p, value v, onInput (fieldChange >> UpdateRegistrationForm) ] []
