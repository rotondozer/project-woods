module Register exposing (init, update, view)

import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (placeholder, style, type_, value)
import Html.Events exposing (onClick, onInput)
import Types exposing (Msg(..), Page(..), RegistrationForm, RegistrationMsg(..))


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
        , viewValidation form
        , button [ onClick (ChangeView Home) ] [ text "Create Account" ]
        ]


viewInput : String -> String -> String -> (String -> RegistrationMsg) -> Html Msg
viewInput t p v fieldChange =
    input [ type_ t, placeholder p, value v, onInput (fieldChange >> UpdateRegistrationForm) ] []


viewValidation : RegistrationForm -> Html Msg
viewValidation form =
    if form.password == form.passwordAgain then
        if form.password == "" then
            div [] []

        else
            div [ style "color" "green" ] [ text "OK" ]

    else
        div [ style "color" "red" ] [ text "Passwords do not match!" ]
