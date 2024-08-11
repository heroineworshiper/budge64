
; 
; Indexes into the rotation tables.  One entry for each rotation value (0-27). 
; The "low" and "high" tables have the same value at each position, just shifted
; over 4 bits.
; 
; Mathematically, cosine has the same shape as sine, but is shifted by PI/2 (one
; quarter period) ahead of it.  That's why there are two sets of tables, one of
; which is shifted by 7 bytes.
; 
; See the comments above RotTabLo for more details.
; 
RotIndexLo_sin:
    .byte $70, $60, $50, $40, $30, $20, $10, $00
    .byte $10, $20, $30, $40, $50, $60, $70, $80
    .byte $90, $a0, $b0, $c0, $d0, $e0, $d0, $c0
    .byte $b0, $a0, $90, $80

RotIndexHi_sin:
    .byte $07, $06, $05, $04, $03, $02, $01, $00
    .byte $01, $02, $03, $04, $05, $06, $07, $08
    .byte $09, $0a, $0b, $0c, $0d, $0e, $0d, $0c
    .byte $0b, $0a, $09, $08

RotIndexLo_cos:
    .byte $00, $10, $20, $30, $40, $50, $60, $70
    .byte $80, $90, $a0, $b0, $c0, $d0, $e0, $d0
    .byte $c0, $b0, $a0, $90, $80, $70, $60, $50
    .byte $40, $30, $20, $10

RotIndexHi_cos:
    .byte $00, $01, $02, $03, $04, $05, $06, $07
    .byte $08, $09, $0a, $0b, $0c, $0d, $0e, $0d
    .byte $0c, $0b, $0a, $09, $08, $07, $06, $05
    .byte $04, $03, $02, $01


; 
; Indexes into the scale tables.  One entry for each scale value (0-15).  See
; the comments above ScaleTabLo for more details.
; 
ScaleIndexLo: 
    .byte $00, $10, $20, $30, $40, $50, $60, $70
    .byte $80, $90, $a0, $b0, $c0, $d0, $e0, $f0

ScaleIndexHi:
    .byte $00, $01, $02, $03, $04, $05, $06, $07
    .byte $08, $09, $0a, $0b, $0c, $0d, $0e, $0f


; get the next tables to start on a 256 byte boundary
.align 243 

; 
; Math constants for rotation.
; 
; To compute X * cos(theta), start by converting theta (0-27) into a table base
; address (using the 28-byte tables RotIndexLo_cos / RotIndexHi_cos).  Split the
; X coordinate into nibbles, use the low 4 bits to index into the adjusted
; RotTabLo pointer, and the high 4 bits to index into the adjusted RotTabHi
; pointer.  Add the values at those locations together.
; 
; This is similar to the way the scale table works.  See ScaleTableLo, below,
; for a longer explanation of how the nibbles are used.
; 
; As an example, suppose we have a point at (36,56), and we want to rotate it 90
; degrees (rot=7).  We use the RotIndex tables to get the table base addresses:
; sin=$00/$00 ($1200/$1300), cos=$70/$07 ($1270/$1307).  We split the
; coordinates into nibbles without shifting ($24,$38 --> $20 $04, $30 $08), and
; use the nibbles as indexes into the tables:
; 
;  X * cos(theta) = ($1274)+($1327) = $00+$00 = 0
;  Y * sin(theta) = ($1208)+($1330) = $08+$30 = 56
;  X * sin(theta) = ($1204)+($1320) = $04+$20 = 36
;  Y * cos(theta) = ($1278)+($1337) = $00+$00 = 0
; 
;  XC = X*cos(theta) - Y*sin(theta) = -56
;  YC = X*sin(theta) + Y*cos(theta) = 36
; 
; which is exactly what we expected (counter-clockwise).
; 
; The largest value from the index table is $EE, so that last 17 bytes in each
; table are unused.
; 

RotTabLo:
    .byte $00, $01, $02, $03, $04, $05, $06, $07
    .byte $08, $09, $0a, $0b, $0c, $0d, $0e, $0f
    .byte $00, $01, $02, $03, $04, $05, $06, $07
    .byte $08, $09, $0a, $0b, $0c, $0d, $0e, $0f
    .byte $00, $01, $02, $03, $04, $05, $05, $06
    .byte $07, $08, $09, $0a, $0b, $0c, $0d, $0e
    .byte $00, $01, $02, $02, $03, $04, $05, $05
    .byte $06, $07, $08, $09, $09, $0a, $0b, $0c
    .byte $00, $01, $01, $02, $02, $03, $04, $04
    .byte $05, $06, $06, $07, $07, $08, $09, $09
    .byte $00, $00, $01, $01, $02, $02, $03, $03
    .byte $03, $04, $04, $05, $05, $06, $06, $07
    .byte $00, $00, $00, $01, $01, $01, $01, $02
    .byte $02, $02, $02, $02, $03, $03, $03, $03
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $ff, $ff, $ff, $ff, $fe
    .byte $fe, $fe, $fe, $fe, $fd, $fd, $fd, $fd
    .byte $00, $00, $ff, $ff, $fe, $fe, $fd, $fd
    .byte $fd, $fc, $fc, $fb, $fb, $fa, $fa, $f9
    .byte $00, $ff, $ff, $fe, $fe, $fd, $fc, $fc
    .byte $fb, $fa, $fa, $f9, $f9, $f8, $f7, $f7
    .byte $00, $ff, $fe, $fe, $fd, $fc, $fb, $fb
    .byte $fa, $f9, $f8, $f7, $f7, $f6, $f5, $f4
    .byte $00, $ff, $fe, $fd, $fc, $fb, $fb, $fa
    .byte $f9, $f8, $f7, $f6, $f5, $f4, $f3, $f2
    .byte $00, $ff, $fe, $fd, $fc, $fb, $fb, $fa
    .byte $f8, $f7, $f6, $f5, $f4, $f3, $f2, $f1
    .byte $00, $ff, $fe, $fd, $fc, $fb, $fa, $f9
    .byte $f8, $f7, $f6, $f5, $f4, $f3, $f2, $f1
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00



RotTabHi:
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $10, $10, $0e, $0d, $0a, $07, $04, $00
    .byte $fc, $f9, $f6, $f3, $f2, $f0, $f0, $00
    .byte $20, $1f, $1d, $19, $14, $0e, $07, $00
    .byte $f9, $f2, $ec, $e7, $e3, $e1, $e0, $00
    .byte $30, $2f, $2b, $26, $1e, $15, $0b, $00
    .byte $f5, $eb, $e2, $da, $d5, $d1, $d0, $00
    .byte $40, $3e, $3a, $32, $28, $1c, $0e, $00
    .byte $f2, $e4, $d8, $ce, $c6, $c2, $c0, $00
    .byte $50, $4e, $48, $3f, $32, $23, $12, $00
    .byte $ee, $dd, $ce, $c1, $b8, $b2, $b0, $00
    .byte $60, $5e, $56, $4b, $3c, $2a, $15, $00
    .byte $eb, $d6, $c4, $b5, $aa, $a2, $a0, $00
    .byte $70, $6d, $65, $58, $46, $31, $19, $00
    .byte $e7, $cf, $ba, $a8, $9b, $93, $90, $00
    .byte $80, $83, $8d, $9c, $b0, $c8, $e4, $00
    .byte $1c, $38, $50, $64, $73, $7d, $80, $00
    .byte $90, $93, $9b, $a8, $ba, $cf, $e7, $00
    .byte $19, $31, $46, $58, $65, $6d, $70, $00
    .byte $a0, $a2, $aa, $b5, $c4, $d6, $eb, $00
    .byte $15, $2a, $3c, $4b, $56, $5e, $60, $00
    .byte $b0, $b2, $b8, $c1, $ce, $dd, $ee, $00
    .byte $12, $23, $32, $3f, $48, $4e, $50, $00
    .byte $c0, $c2, $c6, $ce, $d8, $e4, $f2, $00
    .byte $0e, $1c, $28, $32, $3a, $3e, $40, $00
    .byte $d0, $d1, $d5, $da, $e2, $eb, $f5, $00
    .byte $0b, $15, $1e, $26, $2b, $2f, $30, $00
    .byte $e0, $e1, $e3, $e7, $ec, $f2, $f9, $00
    .byte $07, $0e, $14, $19, $1d, $1f, $20, $00
    .byte $f0, $f0, $f2, $f3, $f6, $f9, $fc, $00
    .byte $04, $07, $0a, $0d, $0e, $10, $10, $00

; 
; Math constants for scaling.
; 
; Each table has 16 sets of 16 entries, with one set for each of the 16 possible
; scale values.  The values within a set determine how one 4-bit nibble of the
; coordinate is scaled.
; 
; Suppose you want to scale the value 100 ($64) by scale factor 8 (a bit over
; half size).  We begin by using self-modifying code to select the table
; subsets.  This is done in a clever way to avoid shifting.  The instructions
; that load from ScaleTabLo are modified to reference $1800, $1810, $1820, and
; so on.  The instructions that load from ScaleTabHi reference $1900, $1901,
; $1902, etc.  The offset comes from the two 16-byte ScaleIndex tables.  For a
; scale factor of 8, we'll be using $1880 and $1908 as the base addresses.
; 
; To do the actual scaling, we mask to get the low part of the value ($04) and
; index into ScaleTabLo, at address $1884.  We mask the high part of the value
; ($60) and index into ScaleTabHi, at $1968.  We add the values there ($02, $36)
; to get $38 = 56, which is just over half size as expected.
; 
; This is an approximation, but so is any integer division, and it's done in
; 512+32=544 bytes instead of the 16*256=4096 bytes that you'd need for a fully-
; formed scale.  For hi-res graphics it's certainly good enough.
; 
;   32 = $20 = ($1880)+($1928) = 18 (.563)
;   40 = $28 = ($1888)+($1928) = 22 (.55)
;   47 = $2F = ($188F)+($1928) = 26 (.553)
;   48 = $30 = ($1880)+($1938) = 27 (.563)
;  100 = $64 = ($1884)+($1968) = 56 (.56)
; 
ScaleTabLo:
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $01, $01, $01, $01, $01, $01, $01, $01
    .byte $00, $00, $00, $00, $00, $00, $01, $01
    .byte $01, $01, $01, $02, $02, $02, $02, $02
    .byte $00, $00, $00, $00, $01, $01, $01, $01
    .byte $02, $02, $02, $02, $03, $03, $03, $03
    .byte $00, $00, $00, $00, $01, $01, $01, $02
    .byte $02, $02, $03, $03, $03, $04, $04, $04
    .byte $00, $00, $00, $01, $01, $01, $02, $02
    .byte $03, $03, $03, $04, $04, $04, $05, $05
    .byte $00, $00, $00, $01, $01, $02, $02, $03
    .byte $03, $03, $04, $04, $05, $05, $06, $06
    .byte $00, $00, $01, $01, $02, $02, $03, $03
    .byte $04, $04, $05, $05, $06, $06, $07, $07
    .byte $00, $00, $01, $01, $02, $02, $03, $03
    .byte $04, $05, $05, $06, $06, $07, $07, $08
    .byte $00, $00, $01, $01, $02, $03, $03, $04
    .byte $05, $05, $06, $06, $07, $08, $08, $09
    .byte $00, $00, $01, $02, $02, $03, $04, $04
    .byte $05, $06, $06, $07, $08, $08, $09, $0a
    .byte $00, $00, $01, $02, $03, $03, $04, $05
    .byte $06, $06, $07, $08, $09, $09, $0a, $0b
    .byte $00, $00, $01, $02, $03, $04, $04, $05
    .byte $06, $07, $08, $08, $09, $0a, $0b, $0c
    .byte $00, $00, $01, $02, $03, $04, $05, $06
    .byte $07, $07, $08, $09, $0a, $0b, $0c, $0d
    .byte $00, $00, $01, $02, $03, $04, $05, $06
    .byte $07, $08, $09, $0a, $0b, $0c, $0d, $0e
    .byte $00, $01, $02, $03, $04, $05, $06, $07
    .byte $08, $09, $0a, $0b, $0c, $0d, $0e, $0f


ScaleTabHi:
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $01, $02, $03, $04, $05, $06, $07, $08
    .byte $09, $0a, $0b, $0c, $0d, $0e, $0f, $10
    .byte $02, $04, $06, $08, $0a, $0c, $0e, $10
    .byte $12, $14, $16, $18, $1a, $1c, $1e, $20
    .byte $03, $06, $09, $0c, $0f, $12, $15, $18
    .byte $1b, $1e, $21, $24, $27, $2a, $2d, $30
    .byte $04, $08, $0c, $10, $14, $18, $1c, $20
    .byte $24, $28, $2c, $30, $34, $38, $3c, $40
    .byte $05, $0a, $0f, $14, $19, $1e, $23, $28
    .byte $2d, $32, $37, $3c, $41, $46, $4b, $50
    .byte $06, $0c, $12, $18, $1e, $24, $2a, $30
    .byte $36, $3c, $42, $48, $4e, $54, $5a, $60
    .byte $07, $0e, $15, $1c, $23, $2a, $31, $38
    .byte $3f, $46, $4d, $54, $5b, $62, $69, $70
    .byte $f8, $f0, $e8, $e0, $d8, $d0, $c8, $c0
    .byte $b8, $b0, $a8, $a0, $98, $90, $88, $80
    .byte $f9, $f2, $eb, $e4, $dd, $d6, $cf, $c8
    .byte $c1, $ba, $b3, $ac, $a5, $9e, $97, $90
    .byte $fa, $f4, $ee, $e8, $e2, $dc, $d6, $d0
    .byte $ca, $c4, $be, $b8, $b2, $ac, $a6, $a0
    .byte $fb, $f6, $f1, $ec, $e7, $e2, $dd, $d8
    .byte $d3, $ce, $c9, $c4, $bf, $ba, $b5, $b0
    .byte $fc, $f8, $f4, $f0, $ec, $e8, $e4, $e0
    .byte $dc, $d8, $d4, $d0, $cc, $c8, $c4, $c0
    .byte $fd, $fa, $f7, $f4, $f1, $ee, $eb, $e8
    .byte $e5, $e2, $df, $dc, $d9, $d6, $d3, $d0
    .byte $fe, $fc, $fa, $f8, $f6, $f4, $f2, $f0
    .byte $ee, $ec, $ea, $e8, $e6, $e4, $e2, $e0
    .byte $ff, $fe, $fd, $fc, $fb, $fa, $f9, $f8
    .byte $f7, $f6, $f5, $f4, $f3, $f2, $f1, $f0

; 
; These four buffers hold transformed points in screen coordinates.  The points
; are in the same order as they are in the mesh definition.
; 
; One pair of tables holds the X/Y screen coordinates from the previous frame,
; the other pair of tables holds the coordinates being transformed for the
; current frame.  We need two sets because we're display set 0 while generating
; set 1, and after we flip we need to use set 0 again to erase the display.
; 
; Computed X coordinate, set 0.
XCoord0_BMP0:      .res   256
; Computed Y coordinate, set 0.
YCoord0_BMP0:      .res   256
; Computed X coordinate, set 1.
XCoord1_BMP1:      .res   256
; Computed Y coordinate, set 1.
YCoord1_BMP1:      .res   256




; 
; Divide-by-7 table.  Used to divide the X coordinate (0-255) by 7, yielding a
; byte offset for the hi-res screen column.  
; On the C64, it skips 8 bytes every 8 columns.
; 
Div7Tab:
    .byte 0,0,0,0,0,0,0,0
    .byte 8,8,8,8,8,8,8,8
    .byte 16,16,16,16,16,16,16,16
    .byte 24,24,24,24,24,24,24,24
    .byte 32,32,32,32,32,32,32,32
    .byte 40,40,40,40,40,40,40,40
    .byte 48,48,48,48,48,48,48,48
    .byte 56,56,56,56,56,56,56,56
    .byte 64,64,64,64,64,64,64,64
    .byte 72,72,72,72,72,72,72,72
    .byte 80,80,80,80,80,80,80,80
    .byte 88,88,88,88,88,88,88,88
    .byte 96,96,96,96,96,96,96,96
    .byte 104,104,104,104,104,104,104,104
    .byte 112,112,112,112,112,112,112,112
    .byte 120,120,120,120,120,120,120,120
    .byte 128,128,128,128,128,128,128,128
    .byte 136,136,136,136,136,136,136,136
    .byte 144,144,144,144,144,144,144,144
    .byte 152,152,152,152,152,152,152,152
    .byte 160,160,160,160,160,160,160,160
    .byte 168,168,168,168,168,168,168,168
    .byte 176,176,176,176,176,176,176,176
    .byte 184,184,184,184,184,184,184,184
    .byte 192,192,192,192,192,192,192,192
    .byte 200,200,200,200,200,200,200,200
    .byte 208,208,208,208,208,208,208,208
    .byte 216,216,216,216,216,216,216,216
    .byte 224,224,224,224,224,224,224,224
    .byte 232,232,232,232,232,232,232,232
    .byte 240,240,240,240,240,240,240,240
    .byte 248,248,248,248,248,248,248,248


; 
; Hi-res bit table.  Converts the X coordinate (0-255) into a bit position
; within a byte.
; 
HiResBitTab:
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1
    .byte 128,64,32,16,8,4,2,1


; 
; Hi-res Y-coordinate lookup table, high byte.
; 
YTableHi_BMP0:
    .byte >BMP0 + 0, >BMP0 + 0, >BMP0 + 0, >BMP0 + 0, >BMP0 + 0, >BMP0 + 0, >BMP0 + 0, >BMP0 + 0
    .byte >BMP0 + 1, >BMP0 + 1, >BMP0 + 1, >BMP0 + 1, >BMP0 + 1, >BMP0 + 1, >BMP0 + 1, >BMP0 + 1
    .byte >BMP0 + 2, >BMP0 + 2, >BMP0 + 2, >BMP0 + 2, >BMP0 + 2, >BMP0 + 2, >BMP0 + 2, >BMP0 + 2
    .byte >BMP0 + 3, >BMP0 + 3, >BMP0 + 3, >BMP0 + 3, >BMP0 + 3, >BMP0 + 3, >BMP0 + 3, >BMP0 + 3
    .byte >BMP0 + 5, >BMP0 + 5, >BMP0 + 5, >BMP0 + 5, >BMP0 + 5, >BMP0 + 5, >BMP0 + 5, >BMP0 + 5
    .byte >BMP0 + 6, >BMP0 + 6, >BMP0 + 6, >BMP0 + 6, >BMP0 + 6, >BMP0 + 6, >BMP0 + 6, >BMP0 + 6
    .byte >BMP0 + 7, >BMP0 + 7, >BMP0 + 7, >BMP0 + 7, >BMP0 + 7, >BMP0 + 7, >BMP0 + 7, >BMP0 + 7
    .byte >BMP0 + 8, >BMP0 + 8, >BMP0 + 8, >BMP0 + 8, >BMP0 + 8, >BMP0 + 8, >BMP0 + 8, >BMP0 + 8
    .byte >BMP0 + 10, >BMP0 + 10, >BMP0 + 10, >BMP0 + 10, >BMP0 + 10, >BMP0 + 10, >BMP0 + 10, >BMP0 + 10
    .byte >BMP0 + 11, >BMP0 + 11, >BMP0 + 11, >BMP0 + 11, >BMP0 + 11, >BMP0 + 11, >BMP0 + 11, >BMP0 + 11
    .byte >BMP0 + 12, >BMP0 + 12, >BMP0 + 12, >BMP0 + 12, >BMP0 + 12, >BMP0 + 12, >BMP0 + 12, >BMP0 + 12
    .byte >BMP0 + 13, >BMP0 + 13, >BMP0 + 13, >BMP0 + 13, >BMP0 + 13, >BMP0 + 13, >BMP0 + 13, >BMP0 + 13
    .byte >BMP0 + 15, >BMP0 + 15, >BMP0 + 15, >BMP0 + 15, >BMP0 + 15, >BMP0 + 15, >BMP0 + 15, >BMP0 + 15
    .byte >BMP0 + 16, >BMP0 + 16, >BMP0 + 16, >BMP0 + 16, >BMP0 + 16, >BMP0 + 16, >BMP0 + 16, >BMP0 + 16
    .byte >BMP0 + 17, >BMP0 + 17, >BMP0 + 17, >BMP0 + 17, >BMP0 + 17, >BMP0 + 17, >BMP0 + 17, >BMP0 + 17
    .byte >BMP0 + 18, >BMP0 + 18, >BMP0 + 18, >BMP0 + 18, >BMP0 + 18, >BMP0 + 18, >BMP0 + 18, >BMP0 + 18
    .byte >BMP0 + 20, >BMP0 + 20, >BMP0 + 20, >BMP0 + 20, >BMP0 + 20, >BMP0 + 20, >BMP0 + 20, >BMP0 + 20
    .byte >BMP0 + 21, >BMP0 + 21, >BMP0 + 21, >BMP0 + 21, >BMP0 + 21, >BMP0 + 21, >BMP0 + 21, >BMP0 + 21
    .byte >BMP0 + 22, >BMP0 + 22, >BMP0 + 22, >BMP0 + 22, >BMP0 + 22, >BMP0 + 22, >BMP0 + 22, >BMP0 + 22
    .byte >BMP0 + 23, >BMP0 + 23, >BMP0 + 23, >BMP0 + 23, >BMP0 + 23, >BMP0 + 23, >BMP0 + 23, >BMP0 + 23
    .byte >BMP0 + 25, >BMP0 + 25, >BMP0 + 25, >BMP0 + 25, >BMP0 + 25, >BMP0 + 25, >BMP0 + 25, >BMP0 + 25
    .byte >BMP0 + 26, >BMP0 + 26, >BMP0 + 26, >BMP0 + 26, >BMP0 + 26, >BMP0 + 26, >BMP0 + 26, >BMP0 + 26
    .byte >BMP0 + 27, >BMP0 + 27, >BMP0 + 27, >BMP0 + 27, >BMP0 + 27, >BMP0 + 27, >BMP0 + 27, >BMP0 + 27
    .byte >BMP0 + 28, >BMP0 + 28, >BMP0 + 28, >BMP0 + 28, >BMP0 + 28, >BMP0 + 28, >BMP0 + 28, >BMP0 + 28
    .byte >BMP0 + 30, >BMP0 + 30, >BMP0 + 30, >BMP0 + 30, >BMP0 + 30, >BMP0 + 30, >BMP0 + 30, >BMP0 + 30

YTableHi_BMP1:
    .byte >BMP1 + 0, >BMP1 + 0, >BMP1 + 0, >BMP1 + 0, >BMP1 + 0, >BMP1 + 0, >BMP1 + 0, >BMP1 + 0
    .byte >BMP1 + 1, >BMP1 + 1, >BMP1 + 1, >BMP1 + 1, >BMP1 + 1, >BMP1 + 1, >BMP1 + 1, >BMP1 + 1
    .byte >BMP1 + 2, >BMP1 + 2, >BMP1 + 2, >BMP1 + 2, >BMP1 + 2, >BMP1 + 2, >BMP1 + 2, >BMP1 + 2
    .byte >BMP1 + 3, >BMP1 + 3, >BMP1 + 3, >BMP1 + 3, >BMP1 + 3, >BMP1 + 3, >BMP1 + 3, >BMP1 + 3
    .byte >BMP1 + 5, >BMP1 + 5, >BMP1 + 5, >BMP1 + 5, >BMP1 + 5, >BMP1 + 5, >BMP1 + 5, >BMP1 + 5
    .byte >BMP1 + 6, >BMP1 + 6, >BMP1 + 6, >BMP1 + 6, >BMP1 + 6, >BMP1 + 6, >BMP1 + 6, >BMP1 + 6
    .byte >BMP1 + 7, >BMP1 + 7, >BMP1 + 7, >BMP1 + 7, >BMP1 + 7, >BMP1 + 7, >BMP1 + 7, >BMP1 + 7
    .byte >BMP1 + 8, >BMP1 + 8, >BMP1 + 8, >BMP1 + 8, >BMP1 + 8, >BMP1 + 8, >BMP1 + 8, >BMP1 + 8
    .byte >BMP1 + 10, >BMP1 + 10, >BMP1 + 10, >BMP1 + 10, >BMP1 + 10, >BMP1 + 10, >BMP1 + 10, >BMP1 + 10
    .byte >BMP1 + 11, >BMP1 + 11, >BMP1 + 11, >BMP1 + 11, >BMP1 + 11, >BMP1 + 11, >BMP1 + 11, >BMP1 + 11
    .byte >BMP1 + 12, >BMP1 + 12, >BMP1 + 12, >BMP1 + 12, >BMP1 + 12, >BMP1 + 12, >BMP1 + 12, >BMP1 + 12
    .byte >BMP1 + 13, >BMP1 + 13, >BMP1 + 13, >BMP1 + 13, >BMP1 + 13, >BMP1 + 13, >BMP1 + 13, >BMP1 + 13
    .byte >BMP1 + 15, >BMP1 + 15, >BMP1 + 15, >BMP1 + 15, >BMP1 + 15, >BMP1 + 15, >BMP1 + 15, >BMP1 + 15
    .byte >BMP1 + 16, >BMP1 + 16, >BMP1 + 16, >BMP1 + 16, >BMP1 + 16, >BMP1 + 16, >BMP1 + 16, >BMP1 + 16
    .byte >BMP1 + 17, >BMP1 + 17, >BMP1 + 17, >BMP1 + 17, >BMP1 + 17, >BMP1 + 17, >BMP1 + 17, >BMP1 + 17
    .byte >BMP1 + 18, >BMP1 + 18, >BMP1 + 18, >BMP1 + 18, >BMP1 + 18, >BMP1 + 18, >BMP1 + 18, >BMP1 + 18
    .byte >BMP1 + 20, >BMP1 + 20, >BMP1 + 20, >BMP1 + 20, >BMP1 + 20, >BMP1 + 20, >BMP1 + 20, >BMP1 + 20
    .byte >BMP1 + 21, >BMP1 + 21, >BMP1 + 21, >BMP1 + 21, >BMP1 + 21, >BMP1 + 21, >BMP1 + 21, >BMP1 + 21
    .byte >BMP1 + 22, >BMP1 + 22, >BMP1 + 22, >BMP1 + 22, >BMP1 + 22, >BMP1 + 22, >BMP1 + 22, >BMP1 + 22
    .byte >BMP1 + 23, >BMP1 + 23, >BMP1 + 23, >BMP1 + 23, >BMP1 + 23, >BMP1 + 23, >BMP1 + 23, >BMP1 + 23
    .byte >BMP1 + 25, >BMP1 + 25, >BMP1 + 25, >BMP1 + 25, >BMP1 + 25, >BMP1 + 25, >BMP1 + 25, >BMP1 + 25
    .byte >BMP1 + 26, >BMP1 + 26, >BMP1 + 26, >BMP1 + 26, >BMP1 + 26, >BMP1 + 26, >BMP1 + 26, >BMP1 + 26
    .byte >BMP1 + 27, >BMP1 + 27, >BMP1 + 27, >BMP1 + 27, >BMP1 + 27, >BMP1 + 27, >BMP1 + 27, >BMP1 + 27
    .byte >BMP1 + 28, >BMP1 + 28, >BMP1 + 28, >BMP1 + 28, >BMP1 + 28, >BMP1 + 28, >BMP1 + 28, >BMP1 + 28
    .byte >BMP1 + 30, >BMP1 + 30, >BMP1 + 30, >BMP1 + 30, >BMP1 + 30, >BMP1 + 30, >BMP1 + 30, >BMP1 + 30

; 
; Hi-res Y-coordinate lookup table, low byte.
; 
YTableLo:
    .byte 0,1,2,3,4,5,6,7
    .byte 64,65,66,67,68,69,70,71
    .byte 128,129,130,131,132,133,134,135
    .byte 192,193,194,195,196,197,198,199
    .byte 0,1,2,3,4,5,6,7
    .byte 64,65,66,67,68,69,70,71
    .byte 128,129,130,131,132,133,134,135
    .byte 192,193,194,195,196,197,198,199
    .byte 0,1,2,3,4,5,6,7
    .byte 64,65,66,67,68,69,70,71
    .byte 128,129,130,131,132,133,134,135
    .byte 192,193,194,195,196,197,198,199
    .byte 0,1,2,3,4,5,6,7
    .byte 64,65,66,67,68,69,70,71
    .byte 128,129,130,131,132,133,134,135
    .byte 192,193,194,195,196,197,198,199
    .byte 0,1,2,3,4,5,6,7
    .byte 64,65,66,67,68,69,70,71
    .byte 128,129,130,131,132,133,134,135
    .byte 192,193,194,195,196,197,198,199
    .byte 0,1,2,3,4,5,6,7
    .byte 64,65,66,67,68,69,70,71
    .byte 128,129,130,131,132,133,134,135
    .byte 192,193,194,195,196,197,198,199
    .byte 0,1,2,3,4,5,6,7




; The next five tables represent the data as it was entered into the shape
; editor.  There are two shapes.  The first (space shuttle) starts at offset 0,
; has 27 points, and 29 lines.  The second (cube) starts immediately after the
; first, has 8 points, and 12 lines.
; 
; 3D mesh X coordinates (-60, -57, ...)
CUBE_SIZE := $30
CUBE_SIZE2 := $d0
ShapeXCoords:
; shuttle
    .byte $c4, $c7, $c7, $c7, $c7, $d6, $d6, $d6
    .byte $d6, $f1, $f1, $00, $00, $15, $15, $1e
    .byte $1e, $1e, $1e, $24, $24, $24, $24, $09
    .byte $1b, $15, $1e
;  cube
    .byte CUBE_SIZE2, CUBE_SIZE, CUBE_SIZE, CUBE_SIZE2, CUBE_SIZE2, CUBE_SIZE, CUBE_SIZE, CUBE_SIZE2

; 3D mesh Y coordinates (0, 3, ...)
ShapeYCoords:
; shuttle
    .byte $00, $03, $03, $fd, $fd, $06, $09, $fa
    .byte $f7, $09, $f7, $0f, $f1, $24, $dc, $24
    .byte $dc, $09, $f7, $09, $f7, $06, $fa, $00
    .byte $00, $00, $00
;  cube
    .byte CUBE_SIZE2, CUBE_SIZE2, CUBE_SIZE, CUBE_SIZE, CUBE_SIZE2, CUBE_SIZE2, CUBE_SIZE, CUBE_SIZE

; 3D mesh Z coordinates (0, 3, ...)
ShapeZCoords:
; shuttle
    .byte $00, $03, $fd, $03, $fd, $09, $fa, $09
    .byte $fa, $fa, $fa, $fa, $fa, $fa, $fa, $fa
    .byte $fa, $fa, $fa, $fa, $fa, $09, $09, $09
    .byte $09, $1b, $1b
; cube
    .byte CUBE_SIZE2, CUBE_SIZE2, CUBE_SIZE2, CUBE_SIZE2, CUBE_SIZE, CUBE_SIZE, CUBE_SIZE, CUBE_SIZE

; 3D mesh line definition: start points (0, 0, 0, ...)
LineStartPoint:
; shuttle
    .byte $00, $00, $00, $00, $01, $02, $03, $04
    .byte $06, $08, $09, $0a, $0b, $0c, $0d, $0e
    .byte $0f, $10, $11, $12, $13, $05, $07, $13
    .byte $14, $15, $17, $19, $1a
; cube
    .byte $1b, $1c, $1d, $1e, $1f, $20, $21, $22
    .byte $1b, $1c, $1d, $1e

; 3D mesh line definition: end points (1, 2, 3, ...)
LineEndPoint:
; shuttle
    .byte $01, $02, $03, $04, $05, $06, $07, $08
    .byte $09, $0a, $0b, $0c, $0d, $0e, $0f, $10
    .byte $11, $12, $13, $14, $14, $15, $16, $15
    .byte $16, $16, $19, $1a, $18
; cube
    .byte $1c, $1d, $1e, $1b, $20, $21, $22, $1f
    .byte $1f, $20, $21, $22

; 
; For shape N, the index of the first point.  For transforming, we use the
; point indexes.
; 
; Shape #0 uses points $00-1A, shape #1 uses points $1B-22.
FirstPointIndex:
    .byte $00, $1b

; For shape N, the index of the last point + 1.
LastPointIndex:
    .byte $1b, $1b + 8

; 
; For shape N, the index of the first line.  For drawing, we use the 
; line indexes.
; 
; Shape #0 uses lines $00-1C, shape #1 uses lines $1D-28
FirstLineIndex:
    .byte $00, $1d

; For shape N, the index of the last line + 1.
LastLineIndex:
    .byte $1d, $1d + 12



; drawing commands are encoded in the following tables
; 1 byte in each table per object
CODE_arr:    .byte 2,   0
SCALE_arr:   .byte 15,  15
X_arr:       .byte 127, 127
Y_arr:       .byte 100, 100
XROT_arr:    .byte 6,   0
YROT_arr:    .byte 0,   6
ZROT_arr:    .byte 1,   0
SX_arr:      .byte 0,   0 ; set by CRUNCH
SY_arr:      .byte 0,   0 ; set by CRUNCH

NumObjects := 2  ; number of objects

