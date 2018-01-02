ifeq ($(OS),Windows_NT)
SILENT_OUT := >nul
EXE	:= .exe
else
SILENT_OUT := >/dev/null
EXE	:=
endif

.PHONY: all tb clean lint

all: tb

build:
	@mkdir build

tb: build build/intellec4.out build/mcs4eval.out
	@vvp build/intellec4.out
	@vvp build/mcs4eval.out

build/mcs4eval.out: build rtl/i4001.v rtl/i4002.v rtl/i4004.v rtl/mcs4_clk_gen.v tb/mcs4eval_tb.v
	@iverilog -o build/mcs4eval.out -s mcs4eval_tb rtl/i4001.v rtl/i4002.v rtl/i4004.v rtl/mcs4_clk_gen.v tb/mcs4eval_tb.v

build/intellec4.out: build rtl/i4001.v rtl/i4002.v rtl/i4003.v rtl/i4004.v rtl/mcs4_clk_gen.v tb/intellec4_tb.v
	@iverilog -o build/intellec4.out -s intellec4_tb rtl/i4001.v rtl/i4002.v rtl/i4003.v rtl/i4004.v rtl/mcs4_clk_gen.v tb/intellec4_tb.v

lint: rtl/i4001.v rtl/i4002.v rtl/i4003.v rtl/i4004.v rtl/mcs4_clk_gen.v
	@verilator --lint-only -Wall --top-module mcs4_clk_gen rtl/i4001.v rtl/i4002.v rtl/i4003.v rtl/i4004.v rtl/mcs4_clk_gen.v

clean:
	$(RM) -f -r build

