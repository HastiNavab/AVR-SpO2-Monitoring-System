.INCLUDE "m32def.inc"

.CSEG
.ORG 0x0000
	;IVT
    RJMP start

start:
	; stack init.
	LDI  R16, HIGH(RAMEND)
    OUT  SPH, R16
    LDI  R16, LOW(RAMEND)
    OUT  SPL, R16


	;porta keypad
	LDI  R16, 0xF0
    OUT  DDRA, R16
	LDI  R16, 0xFF
    OUT  PORTA, R16

	;portb az sensor data migire
	LDI  R16, 0x00
    OUT  DDRB, R16
    OUT  PORTB, R16

	; port c, d
    LDI  R16, 0xFF
    OUT  DDRC, R16
    LDI  R16, 0x00
    OUT  PORTC, R16

    LDI  R16, 0xFF
    OUT  DDRD, R16
    LDI  R16, 0x00
    OUT  PORTD, R16

	;flag
    CLT

	; mahal avalie buffer
    LDI  ZH, HIGH(0x0400)
    LDI  ZL, LOW(0x0400)


Main:

    BRTS Ready

    RCALL Keypad
    CPI  R16, 0xFF
    BREQ Main

    ; debounce
    MOV   R20, R16
    RCALL Delay
    RCALL Keypad
    CP    R16, R20
    BRNE  Main
    MOV   R16, R20

	; data kham dar r16 hast
    RCALL E2prom

	; meghdar kilid dar r16 hast

    CPI  R16, 0xFF
    BREQ Wait

    ; akharin kilid f boode ya na?
    CPI  R16, 0x0F
    BREQ KeyF

    ; buffer faghat 2 byte zarfiat darad
    LDI  R17, LOW(0x0402)
    CP   ZL, R17
    LDI  R17, HIGH(0x0402)
    CPC  ZH, R17
    BRSH Wait

    ST   Z+, R16
    RJMP Wait


KeyF:
    SET


; sabr baraye bardashtan dast
Wait:
    RCALL Keypad
    CPI  R16, 0xFF
    BRNE Wait

    RCALL Delay
    RCALL Keypad
    CPI  R16, 0xFF
    BRNE Wait

    RJMP Main


; yani F tashkhis dadim
Ready:

	RCALL Readkey
    MOV   R18, R16

    RCALL Readkey
    MOV   R19, R16

    CLT

    ; reset buffer
    LDI   ZH, HIGH(0x0400)
    LDI   ZL, LOW(0x0400)

    ; shomare khane faghat 0 ta 9
    CPI   R18, 10
    BRSH  Main

    ; A
    CPI   R19, 0x0A
    BREQ  A

    ; B
    CPI   R19, 0x0B
    BREQ  B

	; na A na B
    RJMP  Main


A:
    CBI   PORTC, 7
    SBI   PORTC, 7
    RCALL Delay
    IN    R20, PINB
    CBI   PORTC, 7
    LDI   R17, 0x34
    EOR   R20, R17


    CBI   PORTD, 7
    SBI   PORTD, 7
    RCALL Delay
    IN    R21, PINB
    CBI   PORTD, 7
    EOR   R21, R17

    RCALL SpO2
    RCALL Save

	; spo dar r22
    RCALL Display

    RJMP Main


B:
    RCALL Load

	;spo dar r22
    RCALL Display

    RJMP Main



Keypad:
	;radif 1
    LDI  R16, 0x7F
    OUT  PORTA, R16

    NOP
    NOP

    IN   R16, PINA

    MOV  R17, R16
    ANDI R17, 0x0F
    CPI  R17, 0x0F
    BRNE Find


	;radif 2
    LDI  R16, 0xBF
    OUT  PORTA, R16

    NOP
    NOP

    IN   R16, PINA

    MOV  R17, R16
    ANDI R17, 0x0F
    CPI  R17, 0x0F
    BRNE Find


	; radif 3
    LDI  R16, 0xDF
    OUT  PORTA, R16

    NOP
    NOP

    IN   R16, PINA

    MOV  R17, R16
    ANDI R17, 0x0F
    CPI  R17, 0x0F
    BRNE Find


	;radif 4
    LDI  R16, 0xEF
    OUT  PORTA, R16

    NOP
    NOP

    IN   R16, PINA

    MOV  R17, R16
    ANDI R17, 0x0F
    CPI  R17, 0x0F
    BRNE Find


	;hichi
    LDI  R17, 0xFF
    OUT  PORTA, R17
    LDI  R16, 0xFF
    RET


Find:
    LDI  R17, 0xFF
    OUT  PORTA, R17
    RET


E2prom:
    CPI  R16, 0x77
    BREQ E3

    CPI  R16, 0x7B
    BREQ E2

    CPI  R16, 0x7D
    BREQ E1

    CPI  R16, 0x7E
    BREQ E0


    CPI  R16, 0xB7
    BREQ E7

    CPI  R16, 0xBB
    BREQ E6

    CPI  R16, 0xBD
    BREQ E5

    CPI  R16, 0xBE
    BREQ E4


    CPI  R16, 0xD7
    BREQ EB

    CPI  R16, 0xDB
    BREQ EA

    CPI  R16, 0xDD
    BREQ E9

    CPI  R16, 0xDE
    BREQ E8


    CPI  R16, 0xE7
    BREQ EF

    CPI  R16, 0xEB
    BREQ EE

    CPI  R16, 0xED
    BREQ ED

    CPI  R16, 0xEE
    BREQ EC

    LDI  R16, 0xFF
    RET


E0:
    LDI  R16, 0x00
    RET

E1:
    LDI  R16, 0x01
    RET

E2:
    LDI  R16, 0x02
    RET

E3:
    LDI  R16, 0x03
    RET

E4:
    LDI  R16, 0x04
    RET

E5:
    LDI  R16, 0x05
    RET

E6:
    LDI  R16, 0x06
    RET

E7:
    LDI  R16, 0x07
    RET

E8:
    LDI  R16, 0x08
    RET

E9:
    LDI  R16, 0x09
    RET

EA:
    LDI  R16, 0x0A
    RET

EB:
    LDI  R16, 0x0B
    RET

EC:
    LDI  R16, 0x0C
    RET

ED:
    LDI  R16, 0x0D
    RET

EE:
    LDI  R16, 0x0E
    RET

EF:
    LDI  R16, 0x0F
    RET


Readkey:

    LDI  R17, LOW(0x0400)
    CP   ZL, R17
    LDI  R17, HIGH(0x0400)
    CPC  ZH, R17
	BREQ Empty

    SBIW ZL, 1
    LD   R16, Z
    RET


Empty:

    LDI  R16, 0xFF
    RET


Delay:

    ; taakhir takhribi 10ms baraye clock 1MHz
    LDI   R24, LOW(2500)
    LDI   R25, HIGH(2500)

DelayLoop:

    SBIW  R24, 1
    BRNE  DelayLoop
    RET


SpO2:

    ; makhraj dar R26:R23
    MOV   R23, R20
    CLR   R26
    ADD   R23, R21

    BRCC  MakhrajReady
    INC   R26


MakhrajReady:

    MOV   R16, R23
    OR    R16, R26
    BREQ  Zero

	; soorat dar R1:R0
    LDI   R16, 100
    MUL   R21, R16

    MOV   R24, R0
    MOV   R25, R1
    CLR   R1
    CLR   R22


Tghsim:

	;moghayese soorat makhraj
    CP    R24, R23
    CPC   R25, R26

    ; soorat<makhraj
    BRLO  Done

    ; soorat>makhraj
    SUB   R24, R23
    SBC   R25, R26
    INC   R22
    RJMP  Tghsim


Zero:

    CLR   R22


Done:

    RET


Save:

    MOV   R16, R18
    LDI   R17, 0x0F
    ADD   R16, R17


E2promWrite:

    SBIC  EECR, EEWE
    RJMP  E2promWrite

    OUT   EEARL, R16
    CLR   R17
    OUT   EEARH, R17

    OUT   EEDR, R22

    SBI   EECR, EEMWE
    SBI   EECR, EEWE


E2promWriteWait:

    SBIC  EECR, EEWE
    RJMP  E2promWriteWait

    RET



Load:

    MOV   R16, R18
    LDI   R17, 0x0F
    ADD   R16, R17


eeWait:

    SBIC  EECR, EEWE
    RJMP  eeWait

    OUT   EEARL, R16
    CLR   R17
    OUT   EEARH, R17

    SBI   EECR, EERE

    IN    R22, EEDR
    RET



Display:
    MOV   R24, R22
    CLR   R23


Dahgan:
    CPI   R24, 10
    BRLO  SevenSeg

    SUBI  R24, 10
    INC   R23

    RJMP  Dahgan


SevenSeg:
; r23 dagan r24 yekan
    MOV   R16, R24
    RCALL SegCode
    OUT   PORTC, R17

    MOV   R16, R23
    RCALL SegCode
    OUT   PORTD, R17

    RET



SegCode:

    CPI   R16, 0
    BREQ  Seg0

    CPI   R16, 1
    BREQ  Seg1

    CPI   R16, 2
    BREQ  Seg2

    CPI   R16, 3
    BREQ  Seg3

    CPI   R16, 4
    BREQ  Seg4

    CPI   R16, 5
    BREQ  Seg5

    CPI   R16, 6
    BREQ  Seg6

    CPI   R16, 7
    BREQ  Seg7

    CPI   R16, 8
    BREQ  Seg8

    CPI   R16, 9
    BREQ  Seg9

    CLR   R17
    RET


Seg0:
    LDI   R17, 0x3F
    RET

Seg1:
    LDI   R17, 0x06
    RET

Seg2:
    LDI   R17, 0x5B
    RET

Seg3:
    LDI   R17, 0x4F
    RET

Seg4:
    LDI   R17, 0x66
    RET

Seg5:
    LDI   R17, 0x6D
    RET

Seg6:
    LDI   R17, 0x7D
    RET

Seg7:
    LDI   R17, 0x07
    RET

Seg8:
    LDI   R17, 0x7F
    RET

Seg9:
    LDI   R17, 0x6F
    RET