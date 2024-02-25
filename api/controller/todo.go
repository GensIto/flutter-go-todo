package controller

import (
	"api/model"
	"api/usecase"
	"strconv"

	"github.com/labstack/echo"
)

type ITodoController interface {
	GetAllTodo(c echo.Context) error
	GetTodoById(c echo.Context) error
	CreateTodo(c echo.Context) error
	UpdateTodo(c echo.Context) error
	DeleteTodo(c echo.Context) error
}

type todoController struct {
	tu usecase.ITodoUsecase
}

func NewTodoController(tu usecase.ITodoUsecase) ITodoController {
	return &todoController{tu: tu}
}

func (tc *todoController) GetAllTodo(c echo.Context) error {
	todos, err := tc.tu.GetAll()
	if err != nil {
		return c.JSON(500, err)
	}
	return c.JSON(200, todos)
}

func (tc *todoController) GetTodoById(c echo.Context) error {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		return c.JSON(400, err)
	}

	todo, err := tc.tu.GetByID(id)
	if err != nil {
		return c.JSON(500, err)
	}
	return c.JSON(200, todo)
}

func (tc *todoController) CreateTodo(c echo.Context) error {
	todo := model.Todo{}
	if err := c.Bind(&todo); err != nil {
		return c.JSON(400, err)
	}
	if err := c.Validate(&todo); err != nil {
		return c.JSON(400, err)
	}

	if err := tc.tu.Create(todo); err != nil {
		return c.JSON(500, err)
	}

	return c.JSON(201, "Created")
}

func (tc *todoController) UpdateTodo(c echo.Context) error {
	todo := model.Todo{}

	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		return c.JSON(411, err)
	}

	if err := c.Bind(&todo); err != nil {
		return c.JSON(400, err)
	}
	if err := c.Validate(&todo); err != nil {
		return c.JSON(400, err)
	}

	if err := tc.tu.Update(id, &todo); err != nil {
		return c.JSON(500, err)
	}

	return c.JSON(200, "Updated")
}

func (tc *todoController) DeleteTodo(c echo.Context) error {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		return c.JSON(400, err)
	}

	if err := tc.tu.Delete(id); err != nil {
		return c.JSON(500, err)
	}

	return c.JSON(200, "Deleted")
}
