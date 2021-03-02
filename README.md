# Legend of [Luser](https://en.wikipedia.org/wiki/Luser)

This is a game made in godot. It's an action adventure game, sort of like Zelda, but with a hacker theme.

> Internet slang prior to the popularization of the Internet in the late 1990s, defined a luser (sometimes expanded to local user; also luzer or luzzer) as a painfully annoying, stupid, or irritating computer user. The word is a blend of "loser" and "user". Among hackers, the word luser takes on a broad meaning, referring to any normal user (in other words, not a "guru"), with the implication the person is also a loser. The term is partially interchangeable with the hacker term lamer.

You can see the current-published version [here](https://luser.surge.sh).


## code language

The language in the computer is a simple assembly, that uses only ops and numbers.

### jump to line

```asm
JMP 0 0 <LINE>
```

### set a register

```asm
SET 0 <REGISTER> <VALUE>
```

### move a value from 1 register to another

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

### compare, and branch

```asm
CMP 0 <REGISTER> <REGISTER>
JMP 0 0 0A ; jump to 0A on success
; other stuff on fail
```

## example

```asm
00 SET 00 01 00  ; set register 0 to 1
01 MOV 00 00 01  ; copy register 0 into 1
02 CMP 00 00 01  ; do register 0 & 1 match?
03 JMP 00 00 0A  ; jump to 0A on success
04 JMP 00 00 00  ; jump to 0 on fail
```


