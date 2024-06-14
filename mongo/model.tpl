package model

import (
    "context"
	"fmt"

    "go.mongodb.org/mongo-driver/bson"
	"github.com/zeromicro/go-zero/core/stores/monc"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo/options"
	"go.mongodb.org/mongo-driver/mongo"
)


{{if .Cache}}var prefix{{.Type}}CacheKey = "cache:{{.Type}}:"{{end}}

func (m *default{{.Type}}Model) key(id string) string {
	return fmt.Sprintf("%s%s", prefix{{.Type}}CacheKey, id)
}

func New{{.Type}}ID() string{
	return primitive.NewObjectID().Hex()
}

type {{.lowerType}}Model interface{
	Insert(ctx context.Context,data *{{.Type}}) error
	FindOne(ctx context.Context,id string) (*{{.Type}}, error)
	Update(ctx context.Context,data *{{.Type}}) error
	Delete(ctx context.Context, id ...string) (int64, error)
	Search(ctx context.Context, cond {{.Type}}Cond) ([]*{{.Type}}, int, error)
}

type default{{.Type}}Model struct {
    {{if .Cache}}*monc.Model{{else}}*mongo.Model{{end}}
}

func newDefault{{.Type}}Model(conn *monc.Model) *default{{.Type}}Model {
	return &default{{.Type}}Model{conn}
}

func (m *default{{.Type}}Model) Insert(ctx context.Context, data *{{.Type}}) error {
    data.ID = New{{.Type}}ID()
	data.Created = Now()
	data.Updated = Now()
	_, err := m.InsertOneNoCache(ctx, data)
	return err
}

func (m *default{{.Type}}Model) FindOne(ctx context.Context, id string) (*{{.Type}}, error) {
    var r {{.Type}}
	filter := bson.M{"_id": id}
	err := m.FindOneNoCache(ctx, &r, filter)
	if err == mongo.ErrNoDocuments {
        return nil, nil
    }
	return &r, err
}

func (m *default{{.Type}}Model) Update(ctx context.Context, data *{{.Type}}) error {
	data.Updated = Now()
	_, err := m.ReplaceOneNoCache(ctx, bson.M{"_id": data.ID}, data)
	return err
}

func (m *default{{.Type}}Model) Delete(ctx context.Context, id ...string) (int64, error) {
	return  m.DeleteMany(ctx, bson.M{"_id": bson.M{"$in": id}})
}

func (m *default{{.Type}}Model) Search(ctx context.Context, cond {{.Type}}Cond) ([]*{{.Type}}, int, error) {
	var r []*{{.Type}}
	filter := cond.generateCond()
	err := m.Aggregate(ctx, &r, mongo.Pipeline{
		{{"{{"}}Key: "$match", Value: filter{{"}}"}},
		{{"{{"}}Key: "$sort", Value: bson.M{"updated": -1}{{"}}"}},
		{{"{{"}}Key: "$skip", Value: (cond.Page - 1) * cond.Size{{"}}"}},
		{{"{{"}}Key: "$limit", Value: cond.Size{{"}}"}},
	})
	if err != nil {
		return nil, 0, err
	}

	countOption := options.CountOptions{}
	count, err := m.CountDocuments(ctx, filter, &countOption)
	if err != nil {
		return nil, 0, err
	}

	return r, int(count), nil
}
