package response

import "backend/pkg/common"

type Response struct {
	Status  bool        `json:"status"`
	Message string      `json:"message"`
	Data    interface{} `json:"data"`
}

type PaginatedResponse struct {
	Data       interface{}        `json:"data"`
	Pagination *common.Pagination `json:"pagination"`
}

func Success(data interface{}) *Response {
	return &Response{
		Status:  true,
		Message: "Success",
		Data:    data,
	}
}

func Error(message string) *Response {
	return &Response{
		Status:  false,
		Message: message,
		// Message: "Có lỗi xảy ra!",
		Data: nil,
	}
}

func (r *Response) Send() (int, interface{}) {
	if r.Status {
		return 200, r
	}
	return 400, r
}

func (r *Response) SendWithStatus(successCode, errorCode int) (int, interface{}) {
	if r.Status {
		return successCode, r
	}
	return errorCode, r
}

func SuccessWithPagination(data interface{}, pagination *common.Pagination) *Response {
	return &Response{
		Status: true,
		Data: PaginatedResponse{
			Data:       data,
			Pagination: pagination,
		},
		Message: "success",
	}
}
