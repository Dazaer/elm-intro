module Main exposing (main)

import Html exposing (Html, text, div, button, input)
import Html.Attributes exposing (value, placeholder)
import Html.Events exposing (onClick)
import Browser

-- TYPES
type alias Model = 
  { value : Int }
type Msg
  = Increment

-- FUNCTIONS
increment : Int -> Int
increment value =
  value + 1

incrementModel: Model -> Model
incrementModel model =
  {model | value = increment model.value}

-- STATE

init : Model
init =
  {
    value = 0
  }

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment -> model 
      |> incrementModel
      |> Debug.log "Updated model"

view : Model -> Html Msg
view model =
  div []
    [
      input [placeholder "Insert text"] [],
      div [] [
        text "The current value is: ", text (String.fromInt model.value)
      ],
      button [ onClick Increment ] [ text "Increment" ]
    ]

main : Program () Model Msg
main = 
  Browser.sandbox
    {
      init = init, view = view, update = update
    }