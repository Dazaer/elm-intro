module Main exposing (..)

import Html exposing (Html, text, div, span, button, input, ul, li)
import Html.Attributes exposing (value, placeholder, type_, class)
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
  = Increment | UpdateNewTodo String | AddItem String | CompleteItem String

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

completeItem: String -> Model -> List String
completeItem completedItem model =
    let
      updatedTodoList = List.filter (\item -> item /= completedItem) model.todoList
    in
      updatedTodoList

-- HTML FUNCTIONS
todoItemView : String -> Html Msg
todoItemView item =
  li [class "todo-item"]
    [ span [class "todo-text"] [ text item ]
    , button [class "button", onClick (CompleteItem item) ] [ text "X" ]
    ]
-- STATE

init : () -> (Model, Cmd Msg)
init _ =
  ({
    score = 0,
    name = "John Doe",
    todoList = [],
    newTodoItem = ""
  },
  Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Increment -> ( model 
      |> incrementModel
      |> Debug.log "Updated model"
      , Cmd.none)

    UpdateNewTodo newInput ->
      ({ model | newTodoItem = newInput }, Cmd.none)

    AddItem newItem -> 
      if String.isEmpty newItem then
        (model, Cmd.none)
      else
        ({model | todoList = addItem newItem model, newTodoItem = ""}, Cmd.none)

    CompleteItem completedItem ->
      ({model | todoList = completeItem completedItem model }, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

view : Model -> Html Msg
view model =
  div []
    [
      input [class "input-field", placeholder "Specify new todo item", type_ "text", onInput UpdateNewTodo, value model.newTodoItem] [],
      div [] [
        text "The current value is: ", text (String.fromInt model.score)
      ],
      button [class "button", onClick Increment ] [ text "Increase score" ],
      button [class "button", onClick (AddItem model.newTodoItem) ] [ text "Add Item" ],
      div [] [
        text "LIST OF TODO ITEMS: ",
        ul [class "todo-list"] (List.map todoItemView model.todoList)
      ]
    ]

main : Program() Model Msg
main = 
  Browser.element
    {
      init = init, view = view, update = update, subscriptions = subscriptions
    }