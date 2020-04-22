module Register exposing (init, updateForm, view)

import Html exposing (Html, div, input)
import Html.Attributes exposing (placeholder, type_, value)
import Html.Events exposing (onInput)
import Types exposing (Msg(..), RegistrationForm, RegistrationFormField(..))


init : RegistrationForm
init =
    { username = "", password = "", passwordAgain = "" }


updateForm : RegistrationFormField -> RegistrationForm -> RegistrationForm
updateForm formField form =
    case formField of
        Username value ->
            { form | username = value }

        Password value ->
            { form | password = value }

        PasswordAgain value ->
            { form | passwordAgain = value }


view : RegistrationForm -> Html Msg
view form =
    div []
        [ viewInput "text" "Username" form.username (Username >> RegistrationFormChange)
        , viewInput "password" "Password" form.password (Password >> RegistrationFormChange)
        , viewInput "password" "Confirm Password" form.passwordAgain (PasswordAgain >> RegistrationFormChange)
        ]


viewInput : String -> String -> String -> (String -> Msg) -> Html Msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []
