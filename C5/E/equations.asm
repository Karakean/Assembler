.686
.model flat
public _main
.data
; 2x^2 - x - 15 = 0
fact_a dd +2.0
fact_b dd -1.0
fact_c dd -15.0
two dd 2.0
four dd 4.0
x1 dd ?
x2 dd ?

.code
_main PROC
finit

fld fact_b
fmul fact_b
fld four
fmul fact_a
fmul fact_c
fsubp st(1), st(0)
fsqrt

fld fact_b
fchs
fsub st(0), st(1)
fld fact_a
fmul two
fdivp st(1), st(0)
fstp x1

fld fact_b
fchs
fadd st(0), st(1)
fld fact_a
fmul two
fdivp st(1),st(0)
fstp x2

 _main ENDP
 END