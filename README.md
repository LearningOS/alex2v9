# convert Alex-Machine ELF file to v9 executable and debug info

- alex2v9
    - usage: ./alex2v9 infile outfile
    - convert elf to v9 executable
    
- dwarf2v9
    - usage: ./dwarf2v9 infile outfile
    - or ./dwarf2v9 infile - # print result to stdout
    - generate v9 debug info from elf file

- requirements
    - ruby > 1.9, objdump, readelf, llvm-objdump
   