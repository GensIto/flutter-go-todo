package model

type Todo struct {
	ID          int    `json:"id" gorm:"primaryKey autoIncrement:true"`
	Title       string `json:"title" validate:"required"`
	Description string `json:"description" validate:"required"`
	Status      bool   `json:"status" gorm:"default:false"`
}
