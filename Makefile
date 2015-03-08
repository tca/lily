SOURCES=other-tests/t1.scm other-tests/t2.scm other-tests/t3.scm other-tests/t4.scm other-tests/t5.scm other-tests/t6.scm
ASSEMBLES=$(SOURCES:.scm=.asm)
OBJECTS=$(ASSEMBLES:.asm=.o)
BINARIES=$(OBJECTS:.o=.exe)

all: $(ASSEMBLES) $(BINARIES)

%.asm: %.scm
	sagittarius -c -Lmatch-sagittarius -L. -S.sld -d lily.scm $< > $@

%.o: %.asm base.asm
	nasm -felf64 $< -o $@

%.exe: %.o
	ld $< -o $@

clean:
	rm -f $(OBJECTS)
	rm -f $(ASSEMBLES)
	rm -f $(BINARIES)

