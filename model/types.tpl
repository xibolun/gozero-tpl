
type (
	{{.lowerStartCamelObject}}Model interface{
		{{.method}}
		Search(ctx context.Context, cond *{{.upperStartCamelObject}}Cond) (ret []*{{.upperStartCamelObject}}, count int64, err error)
	}

	default{{.upperStartCamelObject}}Model struct {
		{{if .withCache}}gormc.CachedConn{{else}}conn *gorm.DB{{end}}
		table string
	}

	{{.upperStartCamelObject}} struct {
		{{.fields}}
	}
)
