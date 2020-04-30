port module Main exposing (init, main, view)

import Browser
import Browser.Navigation as Navigation
import ChatMirror
import Counter
import Html exposing (Html, a, button, div, h1, li, text, ul)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Register
import Types exposing (ChatMsg(..), Model, Msg(..), RegistrationMsg(..), Route(..))
import Url
import Url.Parser as Parser



-- PORTS


port sendMessage : String -> Cmd msg


port messageReceiver : (String -> msg) -> Sub msg



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


init : () -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
    ( { url = url
      , key = key
      , chat = ChatMirror.init
      , counterValue = 0
      , registrationForm = Register.init
      }
    , Cmd.none
    )



-- UPDATE
-- Use the `sendMessage` port when someone presses ENTER or clicks
-- the "Send" button. Check out index.Browser.Document to see the corresponding
-- JS where this is piped into a WebSocket.
--


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Navigation.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Navigation.load href )

        UrlChanged url ->
            ( { model | url = url }, Cmd.none )

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

        GetStuff ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS
-- Subscribe to the `messageReceiver` port to hear about messages coming in
-- from JS. Check out the index.html file to see how this is hooked up to a
-- WebSocket.
--


subscriptions : Model -> Sub Msg
subscriptions _ =
    messageReceiver (Receive >> UpdateChat)



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Elm Playground"
    , body =
        [ div [ class "container" ]
            [ ul [ class "nav navbar-nav" ]
                [ viewLink "chat-mirror"
                , viewLink "counter"
                , viewLink "register"
                , viewLink "public-APIs"
                ]
            , viewCurrentPage model
            ]
        ]
    }


viewCurrentPage : Model -> Html Msg
viewCurrentPage model =
    case toRoute model.url of
        Home ->
            h1 [] [ text "Elm Guide Projects Home" ]

        ChatMirror ->
            ChatMirror.view model.chat

        Counter ->
            Counter.view model.counterValue

        Register ->
            Register.view model.registrationForm

        PublicAPIs ->
            div [ class "container" ]
                [ text "Push this button to do a thing "
                , button [ class "btn btn-large btn-primary", onClick GetStuff ] [ text "Get Stuff" ]
                ]


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href ("/" ++ path) ] [ text path ] ]


routeParser : Parser.Parser (Route -> a) a
routeParser =
    Parser.oneOf
        [ Parser.map Home Parser.top
        , Parser.map ChatMirror (Parser.s "chat-mirror")
        , Parser.map Counter (Parser.s "counter")
        , Parser.map Register (Parser.s "register")
        , Parser.map PublicAPIs (Parser.s "public-APIs")
        ]


toRoute : Url.Url -> Route
toRoute url =
    Maybe.withDefault Home (Parser.parse routeParser url)
