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

tb: build build/mcs40.out
	@vvp build/mcs40.out

build/mcs40.out: build rtl/i4001.v rtl/i4002.v rtl/i4003.v rtl/i4004.v rtl/mcs40_clk_gen.v tb/mcs40_clk_gen_tb.v
	@iverilog -o build/mcs40.out -s mcs40_clk_gen_tb rtl/i4001.v rtl/i4002.v rtl/i4003.v rtl/i4004.v rtl/mcs40_clk_gen.v tb/mcs40_clk_gen_tb.v

lint: rtl/i4001.v rtl/i4002.v rtl/i4003.v rtl/i4004.v rtl/mcs40_clk_gen.v
	@verilator --lint-only -Wall --top-module mcs40_clk_gen rtl/i4001.v rtl/i4002.v rtl/i4003.v rtl/i4004.v rtl/mcs40_clk_gen.v

clean:
	$(RM) -f -r build

