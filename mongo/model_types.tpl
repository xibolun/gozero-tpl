package model

import (
    "time"

	"github.com/globalsign/mgo/bson"
)

type {{.Type}} struct{
	ID            string      `bson:"_id" json:"id"`
	Created time.Time `bson:"created,omitempty" json:"created,omitempty"`
	Updated time.Time `bson:"updated,omitempty" json:"updated,omitempty"`
	Creator string `bson:"creator,omitempty" json:"creator,omitempty"`
	// todo: complete your model properties at below

}

type {{.Type}}Cond struct{
	// todo: complete your model query cond properties at below
	Key  string `bson:"key"`
	Size int64
	Page int64
}

func (c *{{.Type}}Cond) generateCond() bson.M {
	m := bson.M{}
	// todo: write your query cond at below
	if c.Page < 1 {
		c.Page = 1
	}
	if c.Size > 1000 {
		c.Size = 1000
	}
	return m
}