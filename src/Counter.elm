module Counter exposing (view)

import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Types exposing (Model, Msg(..))


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div []
            [ text (String.fromInt model.counterValue)
            , button [ onClick Clear ] [ text "Clear" ]
            ]
        , button [ onClick Increment ] [ text "+" ]
        ]
