module ChatMirror exposing (init, updateChat, view)

import Html exposing (Html, button, div, h1, input, li, text, ul)
import Html.Attributes exposing (placeholder, type_, value)
import Html.Events exposing (on, onClick, onInput)
import Json.Decode as D
import Types exposing (Chat, ChatChange(..), Msg(..), Page(..))


init : Chat
init =
    { username = ""
    , draft = ""
    , messages = []
    }



-- UPDATE


updateChat : ChatChange -> Chat -> Chat
updateChat chatChange chat =
    case chatChange of
        Draft updatedMessage ->
            { chat | draft = updatedMessage }

        User newUser ->
            { chat | username = newUser }

        Receive message ->
            { chat | messages = chat.messages ++ [ message ] }

        Send ->
            { chat | draft = "" }



-- VIEW


view : Chat -> Html Msg
view chat =
    div []
        [ h1 [] [ text "Echo Chat" ]
        , chatMessagesWithUser chat
        , input
            [ type_ "text"
            , placeholder "Draft"
            , onInput (Draft >> UpdateChat)
            , on "keydown" (ifIsEnter (UpdateChat Send))
            , value chat.draft
            ]
            []
        , input
            [ type_ "text"
            , placeholder "Username"
            , onInput (User >> UpdateChat)
            , value chat.username
            ]
            []
        , button [ onClick (UpdateChat Send) ] [ text "Send" ]
        ]


toChatMessage : String -> Html Msg
toChatMessage message =
    li [] [ text message ]


toMessageWithUser : String -> String -> String
toMessageWithUser user =
    \message -> user ++ ": " ++ message


chatMessagesWithUser : Chat -> Html Msg
chatMessagesWithUser chat =
    ul []
        (chat.messages |> List.map (toMessageWithUser chat.username) |> List.map toChatMessage)



-- DETECT ENTER


ifIsEnter : msg -> D.Decoder msg
ifIsEnter msg =
    D.field "key" D.string
        |> D.andThen
            (\key ->
                if key == "Enter" then
                    D.succeed msg

                else
                    D.fail "some other key"
            )
