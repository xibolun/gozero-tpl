func (m *default{{.upperStartCamelObject}}Model) Find(ctx context.Context, cond *{{.upperStartCamelObject}}Cond) ([]*{{.upperStartCamelObject}}, error) {
	{{if .withCache}}{{.cacheKey}}
	var resp []*{{.upperStartCamelObject}}
	err := m.QueryCtx(ctx, &resp, {{.cacheKeyVariable}}, func(conn *gorm.DB, v interface{}) error {
    		return conn.Model(&{{.upperStartCamelObject}}{}).Where(cond).Task(&resp).Error
    	})
	switch err {
	case nil:
		return resp, nil
	case ErrNotFound:
		return nil, ErrNotFound
	default:
		return nil, err
	}{{else}}var resp []*{{.upperStartCamelObject}}
	err := m.conn.WithContext(ctx).Model(&{{.upperStartCamelObject}}{}).Where(cond).Take(&resp).Error
	switch err {
	case nil:
		return resp, nil
	case ErrNotFound:
		return nil, ErrNotFound
	default:
		return nil, err
	}{{end}}
}
