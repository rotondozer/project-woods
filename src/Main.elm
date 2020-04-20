port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as D



-- MAIN


main : Program () Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }




-- PORTS


port sendMessage : String -> Cmd msg
port messageReceiver : (String -> msg) -> Sub msg



-- MODEL


type alias Model =
  { username : String
  , draft : String
  , messages : List String
  }


init : () -> ( Model, Cmd Msg )
init flags =
  ( { username = "User" 
    ,  draft = ""
    , messages = [] 
    }
  , Cmd.none)



-- UPDATE


type Msg
  = DraftChanged String
  | Send
  | Recv String
  | UserChanged String


-- Use the `sendMessage` port when someone presses ENTER or clicks
-- the "Send" button. Check out index.html to see the corresponding
-- JS where this is piped into a WebSocket.
--
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    DraftChanged draft ->
      ( { model | draft = draft }
      , Cmd.none
      )

    Send ->
      ( { model | draft = "" }
      , sendMessage model.draft
      )

    Recv message ->
      ( { model | messages = model.messages ++ [message] }
      , Cmd.none
      )

    UserChanged username ->
      ( { model | username = username }
      , Cmd.none
      )



-- SUBSCRIPTIONS


-- Subscribe to the `messageReceiver` port to hear about messages coming in
-- from JS. Check out the index.html file to see how this is hooked up to a
-- WebSocket.
--
subscriptions : Model -> Sub Msg
subscriptions _ =
  messageReceiver Recv



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text "Echo Chat" ]
    , chatMessagesWithUser model
    , input
        [ type_ "text"
        , placeholder "Draft"
        , onInput DraftChanged
        , on "keydown" (ifIsEnter Send)
        , value model.draft
        ]
        []
    , input
        [ type_ "text"
        , placeholder "Username"
        , onInput UserChanged
        , value model.username
        ]
        []
    , button [ onClick Send ] [ text "Send" ]
    ]

toChatMessage : String -> Html Msg
toChatMessage message = li [] [ text message ]

toMessageWithUser : String -> String -> String
toMessageWithUser user = \message -> user ++ ": " ++ message

chatMessagesWithUser : Model -> Html Msg
chatMessagesWithUser model = 
  ul []
    (model.messages |> List.map (toMessageWithUser model.username) |> List.map toChatMessage)

-- DETECT ENTER


ifIsEnter : msg -> D.Decoder msg
ifIsEnter msg =
  D.field "key" D.string
    |> D.andThen (\key -> if key == "Enter" then D.succeed msg else D.fail "some other key")