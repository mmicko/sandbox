ifeq ($(OS),Windows_NT)
SILENT_OUT := >nul
EXE	:= .exe
else
SILENT_OUT := >/dev/null
EXE	:=
endif

.PHONY: all tb clean lint roms

all: roms tb

build:
	@mkdir build

build/roms:
ifeq ($(OS),Windows_NT)
	@mkdir build\roms
else
	@mkdir build/roms
endif

tb: build build/intellec4.out build/mcs4eval.out build/ttl.out
	@vvp build/ttl.out

build/ttl.out: build tb/ttl_tb.v rtl/ttl_7400.v rtl/ttl_7402.v rtl/ttl_7404.v rtl/ttl_74244.v rtl/ttl_74138.v rtl/ttl_74155.v
	@iverilog -o build/ttl.out -s ttl_tb tb/ttl_tb.v rtl/ttl_7400.v rtl/ttl_7402.v rtl/ttl_7404.v rtl/ttl_74244.v rtl/ttl_74138.v rtl/ttl_74155.v

build/mcs4eval.out: build rtl/i4001.v rtl/i4002.v rtl/i4004.v rtl/mcs4_clk_gen.v tb/mcs4eval_tb.v 
	@iverilog -o build/mcs4eval.out -s mcs4eval_tb rtl/i4001.v rtl/i4002.v rtl/i4004.v rtl/mcs4_clk_gen.v tb/mcs4eval_tb.v

build/intellec4.out: build rtl/i4001.v rtl/i4002.v rtl/i4003.v rtl/i4004.v rtl/mcs4_clk_gen.v tb/intellec4_tb.v
	@iverilog -o build/intellec4.out -s intellec4_tb rtl/i4001.v rtl/i4002.v rtl/i4003.v rtl/i4004.v rtl/mcs4_clk_gen.v tb/intellec4_tb.v

roms: build build/roms
	@python scripts/genroms.py roms/mcs4eval/mcs4eval.bin build/roms/mcs4eval.mem	

lint: rtl/i4001.v rtl/i4002.v rtl/i4003.v rtl/i4004.v rtl/mcs4_clk_gen.v rtl/ttl_7400.v rtl/ttl_7402.v rtl/ttl_7404.v rtl/ttl_74244.v
	@verilator --lint-only -Wall --top-module mcs4_clk_gen rtl/i4001.v rtl/i4002.v rtl/i4003.v rtl/i4004.v rtl/mcs4_clk_gen.v rtl/ttl_7400.v rtl/ttl_7402.v rtl/ttl_7404.v rtl/ttl_74244.v

clean:
	$(RM) -f -r build
	$(RM) -f -r *.vcd

