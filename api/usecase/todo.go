package usecase

import (
	"api/model"
	"api/repo"
)

type ITodoUsecase interface {
	GetAll() ([]*model.Todo, error)
	GetByID(id int) (*model.Todo, error)
	Create(tr model.Todo) error
	Update(id int, tr *model.Todo) error
	Delete(id int) error
}

type todoUsecase struct {
	tr repo.ITodoRepo
}

func NewTodoUsecase(tr repo.ITodoRepo) ITodoUsecase {
	return &todoUsecase{tr: tr}
}

func (tu *todoUsecase) GetAll() ([]*model.Todo, error) {
	return tu.tr.GetAll()
}

func (tu *todoUsecase) GetByID(id int) (*model.Todo, error) {
	return tu.tr.GetByID(id)
}

func (tu *todoUsecase) Create(t model.Todo) error {
	return tu.tr.Create(t)
}

func (tu *todoUsecase) Update(id int, t *model.Todo) error {
	return tu.tr.Update(id, t)
}

func (tu *todoUsecase) Delete(id int) error {
	return tu.tr.Delete(id)
}
