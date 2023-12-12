package main

import (
	"bytes"
	"context"
	"io"
	"log/slog"
)

var _newline = []byte{'\n'}

type logWriter struct {
	log  *slog.Logger
	lvl  slog.Level
	buff bytes.Buffer
}

func newLogWriter(log *slog.Logger, lvl slog.Level) (io.Writer, func()) {
	w := &logWriter{
		log: log,
		lvl: lvl,
	}
	return w, w.flush
}

func (w *logWriter) Write(bs []byte) (int, error) {
	total := len(bs)
	for len(bs) > 0 {
		var (
			line []byte
			ok   bool
		)
		line, bs, ok = bytes.Cut(bs, _newline)
		if !ok {
			// No newline. Buffer for later.
			w.buff.Write(bs)
			break
		}

		if w.buff.Len() == 0 {
			w.log.Log(context.Background(), w.lvl, string(line))
			continue
		}

		// Join with previously buffered partial line.
		w.buff.Write(line)
		w.log.Log(context.Background(), w.lvl, w.buff.String())
		w.buff.Reset()
	}
	return total, nil
}

func (w *logWriter) flush() {
	if w.buff.Len() > 0 {
		w.log.Log(context.Background(), w.lvl, w.buff.String())
	}
}
