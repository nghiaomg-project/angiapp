package common

type Pagination struct {
	Page       int64 `json:"page"`
	Limit      int64 `json:"limit"`
	TotalRows  int64 `json:"total_rows"`
	TotalPages int64 `json:"total_pages"`
}
