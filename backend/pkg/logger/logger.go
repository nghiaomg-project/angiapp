package logger

import (
	"log"
	"os"
)

type Logger interface {
	Info(v ...interface{})
	Error(v ...interface{})
}

type SimpleLogger struct {
	infoLogger  *log.Logger
	errorLogger *log.Logger
}

func New() *SimpleLogger {
	return &SimpleLogger{
		infoLogger:  log.New(os.Stdout, "INFO: ", log.Ldate|log.Ltime|log.Lshortfile),
		errorLogger: log.New(os.Stderr, "ERROR: ", log.Ldate|log.Ltime|log.Lshortfile),
	}
}

func (l *SimpleLogger) Info(v ...interface{}) {
	l.infoLogger.Println(v...)
}

func (l *SimpleLogger) Error(v ...interface{}) {
	l.errorLogger.Println(v...)
}
