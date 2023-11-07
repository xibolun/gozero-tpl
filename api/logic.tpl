package {{.pkgName}}

import (
	{{.imports}}
)

type {{.logic}} struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func New{{.logic}}(ctx context.Context, svcCtx *svc.ServiceContext) *{{.logic}} {
	return &{{.logic}}{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *{{.logic}}) {{.function}}({{.request}}) {{.responseType}} {
    {{if eq "delete" .method}}count, err := l.svcCtx.{{.model}}.Delete(l.ctx, req.IDs...)
    if err != nil {
        err = errorx.ErrorDB(err)
        return
    }
    resp = &types.CommonAffectedResp{Affected: count}

    return
    {{else if eq "put" .method}}data, err := l.svcCtx.{{.model}}.FindOne(l.ctx, req.ID)
    if err != nil {
        err = errorx.ErrorDB(err)
        return
    }
    _ = copier.Copy(data, req)

    if err = l.svcCtx.{{.model}}.Update(l.ctx, data); err != nil {
        err = errorx.ErrorDB(err)
        return
    }
    return
    {{else if  eq "post" .method}}data := &model.{{.model}}{}
    _ = copier.Copy(data, req)

    if err = l.svcCtx.{{.model}}.Insert(l.ctx, data); err != nil {
        err = errorx.ErrorDB(err)
        return
    }
    return
    {{else if  eq "get" .method}}
        {{ if .findByPage }}
    cond := model.{{.model}}Cond{}
    copier.Copy(&cond, req)

    mData, count, err := l.svcCtx.{{.model}}.Search(l.ctx, cond)
    if err!=nil{
        err = errorx.ErrorDB(err)
        return
    }

    resp = &types.{{.model}}Resp{
        Items: make([]*types.{{.model}}, 0),
        Count: int64(count),
    }

    for _, data := range mData {
        item := &types.{{.model}}{}
        _ = copier.Copy(item, data)
        resp.Items = append(resp.Items, item)
    }
    return
        {{else if .findById }}
    data, err := l.svcCtx.{{.model}}.FindOne(l.ctx, req.Id)
	if err != nil {
		err = errorx.ErrorDB(err)
		return
	}

	resp = &types.{{.model}}{}
	_ = copier.Copy(resp, data)

	return
	{{end}}
    {{else}}
    {{.returnString}}
    {{end}}

}
