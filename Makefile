SOURCES=other-tests/t1.scm other-tests/t2.scm other-tests/t3.scm other-tests/t4.scm other-tests/t5.scm other-tests/t6.scm\
        other-tests/t7.scm other-tests/t8.scm other-tests/t9.scm\
        other-tests/t10.scm other-tests/t11.scm other-tests/t12.scm\
        other-tests/t13.scm other-tests/t14.scm  \
        other-tests/t-gcd.scm #other-tests/t-fact.scm
ASSEMBLES=$(SOURCES:.scm=.asm)
OBJECTS=$(ASSEMBLES:.asm=.o)
BINARIES=$(OBJECTS:.o=.exe)

TESTS=$(BINARIES:.exe=.test)

all: $(ASSEMBLES) $(BINARIES)

test: $(TESTS)

%.asm: %.scm
	sagittarius -c -Lmatch-sagittarius -L. -S.sld -d lily.scm $< > $@

%.o: %.asm base.asm
	nasm -felf64 $< -o $@

%.exe: %.o
	ld $< -o $@

%.test: %.exe
	./$< ; echo

clean:
	rm -f $(OBJECTS)
	rm -f $(ASSEMBLES)
	rm -f $(BINARIES)

