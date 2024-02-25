package main

import (
	"api/controller"
	"api/db"
	"api/model"
	"api/repo"
	"api/usecase"
	"api/validator"

	validate "github.com/go-playground/validator"
	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"
)

func main() {
	db, err := db.InitDB()
	if err != nil {
		panic(err)
	}

	db.AutoMigrate(&model.Todo{})

	e := echo.New()
	e.Validator = &validator.CustomValidator{Validator: validate.New()}
	e.Use(middleware.Logger())

	tr := repo.NewTodoRepo(db)
	tu := usecase.NewTodoUsecase(tr)
	tc := controller.NewTodoController(tu)

	t := e.Group("/todos")

	t.GET("", tc.GetAllTodo)
	t.GET("/:id", tc.GetTodoById)
	t.POST("", tc.CreateTodo)
	t.PUT("/:id", tc.UpdateTodo)
	t.DELETE("/:id", tc.DeleteTodo)

	e.Logger.Fatal(e.Start(":8080"))
}
