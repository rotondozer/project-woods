module ChatMirror exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as D
import Types exposing (Model, Msg(..), Page(..))



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
toChatMessage message =
    li [] [ text message ]


toMessageWithUser : String -> String -> String
toMessageWithUser user =
    \message -> user ++ ": " ++ message


chatMessagesWithUser : Model -> Html Msg
chatMessagesWithUser model =
    ul []
        (model.messages |> List.map (toMessageWithUser model.username) |> List.map toChatMessage)



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
