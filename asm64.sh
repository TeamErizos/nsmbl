#!/bin/bash
# Script_Ligador_Ensamblador

if [ -z $1 ]; then
    echo "Usage ./asm64.sh <asmMainFile> (no extension)"
    exit
fi

# Verificar que no puso el usuario la extemsion
if [ ! -e "$1.asm" ]; then
    echo "Error $1.asm not found"
    echo "Note, do not enter file extentionns."
    exit
fi

# Compilar, ensamblar y ligar
echo "Estamos ensamblando el archivo" $1
 yasm -Worphan-labels -g dwarf2 -f elf64 $1.asm -l $1.lst
 echo "Ligando archivo" $1
 ld -g -o $1 $1.o
 echo "Ya se puede ejecutar"