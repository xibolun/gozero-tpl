
type (
	{{.lowerStartCamelObject}}Model interface{
		{{.method}}
		Find(ctx context.Context, cond *{{.upperStartCamelObject}}Cond) (ret []*{{.upperStartCamelObject}}, err error)
	}

	default{{.upperStartCamelObject}}Model struct {
		{{if .withCache}}gormc.CachedConn{{else}}conn *gorm.DB{{end}}
		table string
	}

	{{.upperStartCamelObject}} struct {
		{{.fields}}
	}

	{{.upperStartCamelObject}}Cond struct {
		 Keyword string
         Page int
         PageSize int
	}
)
