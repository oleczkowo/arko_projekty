EXEFILE = draw_line
OBJECTS = draw_line.o line.o
CCFMT = -m32
NASMFMT = -f elf32
CCOPT =
NASMOPT = -w+all

.c.o:
	cc $(CCFMT) $(CCOPT) -c -no-pie $<

.s.o:
	nasm $(NASMFMT) $(NASMOPT) -l $*.lst $<

$(EXEFILE): $(OBJECTS)
	cc $(CCFMT) -o $@ -no-pie $^

clean:
	rm *.o *.lst $(EXEFILE)
