#vpath %.dll .

NIMFLAGS = -d=release -d=mingw -d=strip --opt=size --mm=orc --threads=on
#NIMFLAGS = -d=debug -d=mingw --embedsrc=on --hints=on

DLLS = $(notdir $(wildcard build/*.dll))
RANDOM = $(shell python -c 'import string,random; print("".join(random.choice(string.ascii_letters) for i in range(8)))' )
export RANDOM

.PHONY: clean
.PHONY: build

default: build

clean:
	rm -f out/*.dll
	rm -rf build/*.def

build: $(DLLS)

rebuild: clean build

%.dll: dllproxy.nim
	cp build/$*.dll out/$$RANDOM.dll
	python gen_def.py out/$$RANDOM.dll > build/$*.def
	nim c $(NIMFLAGS) --app=lib --nomain --cpu=amd64 --passl:build/$*.def --out=out/$*.dll dllproxy.nim