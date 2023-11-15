package {{.PkgName}}

import (
    "net/http"

    "gitlab.qiniu.io/qbox/suez/common/httpresp"
    "gitlab.qiniu.io/qbox/suez/common/errorx"

    "github.com/gin-gonic/gin"
    {{.ImportPackages}}
    {{if .HasRequest}}"github.com/zeromicro/go-zero/rest/httpx"{{end}}
)

func {{.HandlerName}}(svcCtx *svc.ServiceContext) gin.HandlerFunc {
	return func(ctx *gin.Context) {
		r := ctx.Request
    	w := ctx.Writer
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
