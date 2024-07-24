
func (m *default{{.upperStartCamelObject}}Model) Delete(ctx context.Context, {{.lowerStartCamelPrimaryKey}} ...{{.dataType}}) error {
	{{if .withCache}}data, err:=m.FindOne(ctx, {{.lowerStartCamelPrimaryKey}})
	if err!=nil{
		if err == ErrNotFound {
			return nil
		}
		return err
	}
	 err = m.ExecCtx(ctx, func(conn *gorm.DB) error {
		return conn.Delete(&{{.upperStartCamelObject}}{}, {{.lowerStartCamelPrimaryKey}}).Error
	}, m.getCacheKeys(data)...){{else}} err:= m.conn.WithContext(ctx).Delete(&{{.upperStartCamelObject}}{}, {{.lowerStartCamelPrimaryKey}}).Error
	{{end}}
	return err
}

func (m *default{{.upperStartCamelObject}}Model) Search(ctx context.Context, cond *{{.upperStartCamelObject}}Cond) (ret []*{{.upperStartCamelObject}}, count int64, err error) {
	session := cond.generateCond(m.conn.WithContext(ctx).Model(&{{.upperStartCamelObject}}{}))
	if err = session.Count(&count).Error; err != nil {
		return
	}
	if err = session.Limit(cond.Size).Offset(cond.Page).Find(&ret).Error; err != nil {
		return
	}
	return
}
