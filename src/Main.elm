module Main exposing (main)

import Html exposing (Html, text, div, button, input, ul, li)
import Html.Attributes exposing (value, placeholder, type_)
import Html.Events exposing (onClick, onInput)
import Browser

-- TYPES
type alias Model = 
  { 
    score : Int,
    name: String,
    todoList: List String,
    newTodoItem: String
  }
type Msg
  = Increment | AddItem String | UpdateNewTodo String

-- FUNCTIONS
increment : Int -> Int
increment value =
  value + 1

incrementModel: Model -> Model
incrementModel model =
  {model | score = increment model.score}

addItem: String -> Model -> List String
addItem newItem model =
  newItem :: model.todoList

-- HTML FUNCTIONS
todoItemView : String -> Html Msg
todoItemView item =
  li [] [ text item ]
-- STATE

init : Model
init =
  {
    score = 0,
    name = "John Doe",
    todoList = [],
    newTodoItem = ""
  }

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment -> model 
      |> incrementModel
      |> Debug.log "Updated model"

    AddItem newItem -> 
      if String.isEmpty newItem then
        model
      else
        {model | todoList = addItem newItem model, newTodoItem = ""}
      
    UpdateNewTodo newInput ->
      { model | newTodoItem = newInput }

view : Model -> Html Msg
view model =
  div []
    [
      input [placeholder "Specify new todo item", type_ "text", onInput UpdateNewTodo, value model.newTodoItem] [],
      div [] [
        text "The current value is: ", text (String.fromInt model.score)
      ],
      button [ onClick Increment ] [ text "Increase score" ],
      button [ onClick (AddItem model.newTodoItem) ] [ text "Add Item" ],
      div [] [
        text "LIST OF TODO ITEMS: ",
        ul [] (List.map todoItemView model.todoList)
      ]
    ]

main : Program () Model Msg
main = 
  Browser.sandbox
    {
      init = init, view = view, update = update
    }