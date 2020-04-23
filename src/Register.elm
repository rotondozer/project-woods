module Register exposing (init, updateForm, view)

import Html exposing (Html, div, input)
import Html.Attributes exposing (placeholder, type_, value)
import Html.Events exposing (onInput)
import Types exposing (Msg(..), RegistrationForm, RegistrationFormFieldChange(..))


init : RegistrationForm
init =
    { username = "", password = "", passwordAgain = "" }


updateForm : RegistrationFormFieldChange -> RegistrationForm -> RegistrationForm
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
        [ viewInput "text" "Username" form.username Username
        , viewInput "password" "Password" form.password Password
        , viewInput "password" "Confirm Password" form.passwordAgain PasswordAgain
        ]


viewInput : String -> String -> String -> (String -> RegistrationFormFieldChange) -> Html Msg
viewInput t p v fieldChange =
    input [ type_ t, placeholder p, value v, onInput (fieldChange >> RegistrationFormChange) ] []