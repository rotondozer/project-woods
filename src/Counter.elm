module Counter exposing (update, view)

import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Types exposing (CounterMsg(..), Msg(..))



-- UPDATE


update : CounterMsg -> Int -> Int
update counterMsg counterValue =
    case counterMsg of
        Increment ->
            counterValue + 1

        Decrement ->
            if counterValue == 0 then
                counterValue

            else
                counterValue - 1

        Clear ->
            0



-- VIEW


view : Int -> Html Msg
view counterValue =
    div []
        [ button [ onClick (UpdateCounter Increment) ] [ text "-" ]
        , div []
            [ text (String.fromInt counterValue)
            , button [ onClick (UpdateCounter Clear) ] [ text "Clear" ]
            ]
        , button [ onClick (UpdateCounter Increment) ] [ text "+" ]
        ]
