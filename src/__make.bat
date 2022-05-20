@echo off

set OUT=mode1

if exist _out\%OUT%.gen del _out\%OUT%.gen

..\bin\axm68k.exe /j .* /j _inc* /k /p /q subcpu\sp.s68k,subcpu\_out\sp.bin,,subcpu\_out\sp.lst > subcpu\_out\sp.txt
type subcpu\_out\sp.txt
..\bin\axm68k.exe /j .* /j _inc* /k /p /q core.m68k,_out\%OUT%.gen,,_out\%OUT%.lst > _out\out.txt
type _out\out.txt

if not exist _out\%OUT%.gen goto Error
..\bin\mdromfix.exe _out\%OUT%.gen > nul

:Error
pause