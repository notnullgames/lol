## code language

The language in the computer is a very simple assembly, that uses only ops and numbers. All ops are meant to fit on a single line (so no seperate `CMP` and conditional-jumps, like in TASM.)

Things are in reverse-order (LSB first) so for example `jump to line 0x00 if register 0x01 > register 0x02` would be `JGT 00 02 01`.

### set a register

```asm
SET 0 <REGISTER> <VALUE>
```

### copy a value from 1 register to another

```asm
MOV 0 <REGISTER_TO> <REGISTER_FROM>
```

### add a number to a register

```asm
ADD 0 <REGISTER> <VALUE>
```

### subtract a number from a register

```asm
SUB 0 <REGISTER> <VALUE>
```

### multiply a number with a register

```asm
MUL 0 <REGISTER> <VALUE>
```

### divide a number from a register

```asm
DIV 0 <REGISTER> <VALUE>
```

### jump to line

```asm
JMP 0 0 <LINE>
```

### jump if equal

`REGISTERA == REGISTERB`

```asm
JEQ <LINE> <REGISTERB> <REGISTERA>
; other stuff on fail
```

### jump if not-equal

`REGISTERA != REGISTERB`

```asm
JNE <LINE> <REGISTERB> <REGISTERA>
; other stuff on fail
```

### jump if greater-than

`REGISTERA > REGISTERB`

```asm
JGT <LINE> <REGISTERB> <REGISTERA>
; other stuff on fail
```

### jump if less-than

`REGISTERA < REGISTERB`

```asm
JLT <LINE> <REGISTERB> <REGISTERA>
; other stuff on fail
```

## example

we have a computer that has these memory-mapped registers:

```
0A - pin digit 1
0B - pin digit 2
0C - pin digit 3
0D - pin digit 4
0E - alarm
0F - flashing red light
10 - door-lock mechanism
11 - wait (in seconds)
```

Here is it's code:

```asm
; this sets up the comparison, so pin should be 1,2,3,4
00 SET 00 00 01 ; set register 0 to 1
01 SET 00 01 02 ; set register 1 to 2
02 SET 00 02 03 ; set register 2 to 3
03 SET 00 03 04 ; set register 3 to 4

04 SET 00 06 01 ; "truth" for comparison, in 06 register

; check pin
05 JNE 0D 0A 00 ; jump to 0D if pin1 (0A register) is not equal to register 00 (1)
06 JNE 0D 0B 01 ; jump to 0D if pin2 (0B register) is not equal to register 01 (2)
07 JNE 0D 0C 02 ; jump to 0D if pin3 (0C register) is not equal to register 02 (3)
08 JNE 0D 0D 03 ; jump to 0D if pin4 (0D register) is not equal to register 03 (4)

; this allows the security gaurd to enter correct pin to disable alarm
09 JEQ 10 0E 06 ; compare 0E & 06 registers, if equal (alarm is on) go turn it off by jumping to 10

0A SET 00 10 00 ; unlock the door
0B SET 00 11 14 ; wait for 20 seconds (0x14)
0C SET 00 10 01 ; lock the door

; error routine: other things jump here
0D SET 00 0E 01 ; sound alarm
0E SET 00 0F 01 ; flashing red light on
0F JMP 00 00 05 ; loop back to beginning so security-guard can enter correct code to disable alarm

; routine to allow security gaurd to turn off alarm & lock door
10 SET 00 0E 00 ; alarm off
11 SET 00 0F 00 ; flashing red light off
12 JMP 00 00 05 ; jump back to pin-routine
```

If you were hacking this, a solution might be to modify the "error" routine:

```asm
0D SET 00 0E 00 ; don't sound alarm
0E SET 00 0F 00 ; no flashing red light
0F JMP 00 00 0A ; loop back to unlock routine
```

This would allow you to enter any pin.

Another solution might be to look at the registers on the bottom of the screen:

```
01 02 03 04 00 01
```

That is the pin (which is also just in in the code, at the top, so you don't even need ot run this.)


## new ideas

Same thing could be done wiht less characters.

ops:

```
S - SET - set a register to a value
M - MOV - copy value in 1 register to another
+ - ADD - add 2 registers
- - SUB - subtract 1 register from another register
* - MUL - multiply 1 register with another register
/ - DIV - multiply 1 register with another register
J - JMP - jump to a line
= - JEQ - jump if 1 register equals another register
! - JNE - jump if 1 register does not equal another register
> - JGT - jump if 1 register is greater than another register
< - JLT - jump if 1 register is less than another register
```

Peripheral registers:

```
G - pin digit 1
H - pin digit 2
I - pin digit 3
J - pin digit 4
K - alarm
L - flashing red light
M - door-lock mechanism
N - wait (in seconds)
```

same code above would look like this:

```
S  O 01   
S  P 02   
S  Q 03   
S  R 04   
S  T 01   
! 0D  O  G
! 0D  P  H
! 0D  Q  I
! 0D  R  J
= 10  K  T
S  M 00   
S  N 14   
S  M 01   
S  K 01   
S  L 01   
J  05     
S  K 00   
S  L 00   
J  05     
```

showing this help on each line:

```
SET O to 0x01
SET P to 0x02
SET Q to 0x03
SET R to 0x04
SET T to 0x01
if G != O JUMP to line 0x0D
if H != P JUMP to line 0x0D
if I != Q JUMP to line 0x0D
if J != R JUMP to line 0x0D
if T == K JUMP to line 0x10
SET M to 0x00
SET N to 0x14
SET M to 0x01
SET K to 0x01
SET L to 0x01
JUMP to line 0x05
SET K to 0x00
SET L to 0x00
JUMP to line 0x05
```

with registers/help, like this, at bottom:

```
SET O to 0x01

G:00 K:00 O:00 S:00 W:00
H:00 L:00 P:00 T:00 X:00
I:00 M:00 Q:00 U:00 Y:00
J:00 N:00 R:00 V:00 Z:00       0F (current line)
```