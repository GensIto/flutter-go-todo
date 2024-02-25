package repo

import (
	"api/model"

	"gorm.io/gorm"
)

type ITodoRepo interface {
	GetAll() ([]*model.Todo, error)
	GetByID(id int) (*model.Todo, error)
	Create(t model.Todo) error
	Update(id int, t *model.Todo) error
	Delete(id int) error
}

type todoRepo struct {
	db *gorm.DB
}

func NewTodoRepo(db *gorm.DB) *todoRepo {
	return &todoRepo{db: db}
}

func (tr *todoRepo) GetAll() ([]*model.Todo, error) {
	var tasks []*model.Todo
	err := tr.db.Find(&tasks).Error
	return tasks, err
}

func (tr *todoRepo) GetByID(id int) (*model.Todo, error) {
	var task model.Todo
	err := tr.db.First(&task, id).Error
	return &task, err
}

func (tr *todoRepo) Create(t model.Todo) error {
	return tr.db.Create(&t).Error
}

func (tr *todoRepo) Update(id int, t *model.Todo) error {
	var task model.Todo
	err := tr.db.First(&task, id).Error
	if err != nil {
		return err
	}
	task.Title = t.Title
	task.Description = t.Description
	task.Status = t.Status

	return tr.db.Save(task).Error
}

func (tr *todoRepo) Delete(id int) error {
	return tr.db.Delete(&model.Todo{}, id).Error
}
