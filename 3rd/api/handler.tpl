package {{.PkgName}}

import (
	"net/http"

	"gitlab.qiniu.io/qbox/eden/cmd/sinai/3rd/outside/logic/third"
	"gitlab.qiniu.io/qbox/eden/cmd/sinai/3rd/outside/types"
	"gitlab.qiniu.io/qbox/eden/cmd/sinai/internal/svc"
	"gitlab.qiniu.io/qbox/eden/common/errorx"
	"gitlab.qiniu.io/qbox/eden/common/httpresp"

	"github.com/zeromicro/go-zero/rest/httpx"
)

func {{.HandlerName}}(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		{{if .HasRequest}}var req types.{{.RequestType}}
		if err := httpx.Parse(r, &req); err != nil {
			httpresp.HttpErr(w, r, errorx.NewStatCodeError(http.StatusBadRequest, 2, err.Error()))
			return
		}

		{{end}}l := {{.LogicName}}.New{{.LogicType}}(r.Context(), svcCtx)
		{{if .HasResp}}resp, {{end}}err := l.{{.Call}}({{if .HasRequest}}&req{{end}})
		{{if .HasResp}}
		httpresp.Http(w, r, resp, err)
		{{else}}
		httpresp.Http(w, r, nil, err)
		{{end}}
	}
}
