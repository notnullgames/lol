# Legend of [Luser](https://en.wikipedia.org/wiki/Luser)

This is a game made in godot. It's an action-adventure game, sort of like Zelda, but with a hacker theme.

> Internet slang prior to the popularization of the Internet in the late 1990s, defined a luser (sometimes expanded to local user; also luzer or luzzer) as a painfully annoying, stupid, or irritating computer user. The word is a blend of "loser" and "user". Among hackers, the word luser takes on a broad meaning, referring to any normal user (in other words, not a "guru"), with the implication the person is also a loser. The term is partially interchangeable with the hacker term lamer.

You can see the current-published version [here](https://luser.surge.sh).

The fonts are a bit glitchy on the web, but look good on local build, so it's just a sort of idea of how it's progressing.


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