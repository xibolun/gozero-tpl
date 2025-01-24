package {{.pkgName}}

import (
	"context"

	"gitlab.qiniu.io/qbox/eden/cmd/demo/3rd/outside/types"
	"gitlab.qiniu.io/qbox/eden/cmd/demo/internal/svc"

	"github.com/zeromicro/go-zero/core/logx"
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
	// todo: add your logic here and delete this line

	{{.returnString}}
}
