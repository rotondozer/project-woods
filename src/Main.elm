port module Main exposing (init, main, view)

import Browser exposing (element)
import ChatMirror
import Counter
import Html exposing (Html, button, div, h1, text)
import Html.Events exposing (onClick)
import Register
import Types exposing (ChatMsg(..), Model, Msg(..), Page(..), RegistrationMsg(..))



-- PORTS


port sendMessage : String -> Cmd msg


port messageReceiver : (String -> msg) -> Sub msg



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , subscriptions = subscriptions
        , view = view
        , update = update
        }



-- MODEL


init : () -> ( Model, Cmd Msg )
init _ =
    ( { currentPage = Home
      , chat = ChatMirror.init
      , counterValue = 0
      , registrationForm = Register.init
      }
    , Cmd.none
    )



-- UPDATE
-- Use the `sendMessage` port when someone presses ENTER or clicks
-- the "Send" button. Check out index.html to see the corresponding
-- JS where this is piped into a WebSocket.
--


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeView newView ->
            ( { model | currentPage = newView }
            , Cmd.none
            )

        UpdateChat chatChange ->
            ( { model | chat = ChatMirror.update chatChange model.chat }
            , ChatMirror.updateCmd sendMessage chatChange model.chat
            )

        UpdateCounter counterMsg ->
            ( { model | counterValue = Counter.update counterMsg model.counterValue }
            , Cmd.none
            )

        UpdateRegistrationForm formFieldChange ->
            ( { model | registrationForm = Register.update formFieldChange model.registrationForm }
            , Cmd.none
            )



-- SUBSCRIPTIONS
-- Subscribe to the `messageReceiver` port to hear about messages coming in
-- from JS. Check out the index.html file to see how this is hooked up to a
-- WebSocket.
--


subscriptions : Model -> Sub Msg
subscriptions _ =
    messageReceiver (Receive >> UpdateChat)



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick (ChangeView Home) ] [ text "Home" ]
        , button [ onClick (ChangeView ChatMirror) ] [ text "Chat Mirror" ]
        , button [ onClick (ChangeView Counter) ] [ text "Counter" ]
        , button [ onClick (ChangeView Register) ] [ text "Register" ]
        , viewCurrentPage model
        ]


viewCurrentPage : Model -> Html Msg
viewCurrentPage model =
    case model.currentPage of
        Home ->
            h1 [] [ text "Elm Guide Projects Home" ]

        ChatMirror ->
            ChatMirror.view model.chat

        Counter ->
            Counter.view model.counterValue

        Register ->
            Register.view model.registrationForm
