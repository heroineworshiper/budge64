; high res rotation
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


RotTabLo:
    .byte $00, $01, $02, $03, $04, $05, $06, $07
    .byte $08, $09, $0a, $0b, $0c, $0d, $0e, $0f
    .byte $00, $00, $01, $02, $03, $04, $05, $06
    .byte $07, $08, $09, $0a, $0b, $0c, $0d, $0e
    .byte $00, $00, $01, $02, $03, $04, $05, $06
    .byte $07, $08, $09, $0a, $0b, $0c, $0d, $0e
    .byte $00, $00, $01, $02, $03, $04, $05, $06
    .byte $07, $08, $09, $0a, $0b, $0c, $0d, $0e
    .byte $00, $00, $01, $02, $03, $04, $05, $06
    .byte $07, $08, $09, $0a, $0b, $0c, $0d, $0e
    .byte $00, $00, $01, $02, $03, $04, $05, $06
    .byte $07, $08, $09, $0a, $0b, $0c, $0d, $0e
    .byte $00, $00, $01, $02, $03, $04, $05, $06
    .byte $07, $08, $09, $0a, $0b, $0c, $0d, $0e
    .byte $00, $00, $01, $02, $03, $04, $05, $06
    .byte $07, $08, $09, $0a, $0b, $0c, $0d, $0e
    .byte $00, $00, $01, $02, $03, $04, $05, $06
    .byte $07, $08, $09, $0a, $0b, $0c, $0c, $0d
    .byte $00, $00, $01, $02, $03, $04, $05, $06
    .byte $07, $08, $09, $09, $0a, $0b, $0c, $0d
    .byte $00, $00, $01, $02, $03, $04, $05, $06
    .byte $07, $07, $08, $09, $0a, $0b, $0c, $0d
    .byte $00, $00, $01, $02, $03, $04, $05, $06
    .byte $06, $07, $08, $09, $0a, $0b, $0c, $0c
    .byte $00, $00, $01, $02, $03, $04, $04, $05
    .byte $06, $07, $08, $09, $09, $0a, $0b, $0c
    .byte $00, $00, $01, $02, $03, $04, $04, $05
    .byte $06, $07, $08, $08, $09, $0a, $0b, $0c
    .byte $00, $00, $01, $02, $03, $03, $04, $05
    .byte $06, $06, $07, $08, $09, $0a, $0a, $0b
    .byte $00, $00, $01, $02, $02, $03, $04, $05
    .byte $05, $06, $07, $08, $08, $09, $0a, $0b
    .byte $00, $00, $01, $02, $02, $03, $04, $04
    .byte $05, $06, $07, $07, $08, $09, $09, $0a
    .byte $00, $00, $01, $02, $02, $03, $04, $04
    .byte $05, $06, $06, $07, $08, $08, $09, $0a
    .byte $00, $00, $01, $01, $02, $03, $03, $04
    .byte $05, $05, $06, $06, $07, $08, $08, $09
    .byte $00, $00, $01, $01, $02, $02, $03, $04
    .byte $04, $05, $05, $06, $07, $07, $08, $08
    .byte $00, $00, $01, $01, $02, $02, $03, $03
    .byte $04, $05, $05, $06, $06, $07, $07, $08
    .byte $00, $00, $01, $01, $02, $02, $03, $03
    .byte $04, $04, $05, $05, $06, $06, $07, $07
    .byte $00, $00, $00, $01, $01, $02, $02, $03
    .byte $03, $04, $04, $05, $05, $06, $06, $07
    .byte $00, $00, $00, $01, $01, $02, $02, $02
    .byte $03, $03, $04, $04, $05, $05, $05, $06
    .byte $00, $00, $00, $01, $01, $01, $02, $02
    .byte $03, $03, $03, $04, $04, $04, $05, $05
    .byte $00, $00, $00, $01, $01, $01, $02, $02
    .byte $02, $03, $03, $03, $04, $04, $04, $05
    .byte $00, $00, $00, $00, $01, $01, $01, $02
    .byte $02, $02, $02, $03, $03, $03, $04, $04
    .byte $00, $00, $00, $00, $00, $01, $01, $01
    .byte $01, $02, $02, $02, $02, $03, $03, $03
    .byte $00, $00, $00, $00, $00, $00, $01, $01
    .byte $01, $01, $01, $02, $02, $02, $02, $02
    .byte $00, $00, $00, $00, $00, $00, $00, $01
    .byte $01, $01, $01, $01, $01, $01, $02, $02
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $01, $01, $01, $01, $01
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $00, $00, $00, $00, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $fe, $fe
    .byte $00, $00, $00, $00, $00, $00, $ff, $ff
    .byte $ff, $ff, $ff, $fe, $fe, $fe, $fe, $fe
    .byte $00, $00, $00, $00, $00, $ff, $ff, $ff
    .byte $ff, $fe, $fe, $fe, $fe, $fd, $fd, $fd
    .byte $00, $00, $00, $00, $ff, $ff, $ff, $fe
    .byte $fe, $fe, $fe, $fd, $fd, $fd, $fc, $fc
    .byte $00, $00, $00, $ff, $ff, $ff, $fe, $fe
    .byte $fe, $fd, $fd, $fd, $fc, $fc, $fc, $fb
    .byte $00, $00, $00, $ff, $ff, $ff, $fe, $fe
    .byte $fd, $fd, $fd, $fc, $fc, $fc, $fb, $fb
    .byte $00, $00, $00, $ff, $ff, $fe, $fe, $fe
    .byte $fd, $fd, $fc, $fc, $fb, $fb, $fb, $fa
    .byte $00, $00, $00, $ff, $ff, $fe, $fe, $fd
    .byte $fd, $fc, $fc, $fb, $fb, $fa, $fa, $f9
    .byte $00, $00, $ff, $ff, $fe, $fe, $fd, $fd
    .byte $fc, $fc, $fb, $fb, $fa, $fa, $f9, $f9
    .byte $00, $00, $ff, $ff, $fe, $fe, $fd, $fd
    .byte $fc, $fb, $fb, $fa, $fa, $f9, $f9, $f8
    .byte $00, $00, $ff, $ff, $fe, $fe, $fd, $fc
    .byte $fc, $fb, $fb, $fa, $f9, $f9, $f8, $f8
    .byte $00, $00, $ff, $ff, $fe, $fd, $fd, $fc
    .byte $fb, $fb, $fa, $fa, $f9, $f8, $f8, $f7
    .byte $00, $00, $ff, $fe, $fe, $fd, $fc, $fc
    .byte $fb, $fa, $fa, $f9, $f8, $f8, $f7, $f6
    .byte $00, $00, $ff, $fe, $fe, $fd, $fc, $fc
    .byte $fb, $fa, $f9, $f9, $f8, $f7, $f7, $f6
    .byte $00, $00, $ff, $fe, $fe, $fd, $fc, $fb
    .byte $fb, $fa, $f9, $f8, $f8, $f7, $f6, $f5
    .byte $00, $00, $ff, $fe, $fd, $fd, $fc, $fb
    .byte $fa, $fa, $f9, $f8, $f7, $f6, $f6, $f5
    .byte $00, $00, $ff, $fe, $fd, $fc, $fc, $fb
    .byte $fa, $f9, $f8, $f8, $f7, $f6, $f5, $f4
    .byte $00, $00, $ff, $fe, $fd, $fc, $fc, $fb
    .byte $fa, $f9, $f8, $f7, $f7, $f6, $f5, $f4
    .byte $00, $00, $ff, $fe, $fd, $fc, $fb, $fa
    .byte $fa, $f9, $f8, $f7, $f6, $f5, $f4, $f4
    .byte $00, $00, $ff, $fe, $fd, $fc, $fb, $fa
    .byte $f9, $f9, $f8, $f7, $f6, $f5, $f4, $f3
    .byte $00, $00, $ff, $fe, $fd, $fc, $fb, $fa
    .byte $f9, $f8, $f7, $f7, $f6, $f5, $f4, $f3
    .byte $00, $00, $ff, $fe, $fd, $fc, $fb, $fa
    .byte $f9, $f8, $f7, $f6, $f5, $f4, $f4, $f3
    .byte $00, $00, $ff, $fe, $fd, $fc, $fb, $fa
    .byte $f9, $f8, $f7, $f6, $f5, $f4, $f3, $f2
    .byte $00, $00, $ff, $fe, $fd, $fc, $fb, $fa
    .byte $f9, $f8, $f7, $f6, $f5, $f4, $f3, $f2
    .byte $00, $00, $ff, $fe, $fd, $fc, $fb, $fa
    .byte $f9, $f8, $f7, $f6, $f5, $f4, $f3, $f2
    .byte $00, $00, $ff, $fe, $fd, $fc, $fb, $fa
    .byte $f9, $f8, $f7, $f6, $f5, $f4, $f3, $f2
    .byte $00, $00, $ff, $fe, $fd, $fc, $fb, $fa
    .byte $f9, $f8, $f7, $f6, $f5, $f4, $f3, $f2
    .byte $00, $00, $ff, $fe, $fd, $fc, $fb, $fa
    .byte $f9, $f8, $f7, $f6, $f5, $f4, $f3, $f2
    .byte $00, $00, $ff, $fe, $fd, $fc, $fb, $fa
    .byte $f9, $f8, $f7, $f6, $f5, $f4, $f3, $f2
RotTabHi:
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $10, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    .byte $0e, $0e, $0e, $0d, $0d, $0c, $0c, $0b
    .byte $20, $1f, $1f, $1f, $1f, $1f, $1e, $1e
    .byte $1d, $1c, $1c, $1b, $1a, $19, $18, $17
    .byte $30, $2f, $2f, $2f, $2f, $2e, $2d, $2d
    .byte $2c, $2b, $2a, $29, $27, $26, $25, $23
    .byte $40, $3f, $3f, $3f, $3e, $3e, $3d, $3c
    .byte $3b, $39, $38, $36, $35, $33, $31, $2f
    .byte $50, $4f, $4f, $4f, $4e, $4d, $4c, $4b
    .byte $49, $48, $46, $44, $42, $40, $3d, $3b
    .byte $60, $5f, $5f, $5e, $5e, $5d, $5b, $5a
    .byte $58, $56, $54, $52, $4f, $4d, $4a, $47
    .byte $70, $6f, $6f, $6e, $6d, $6c, $6b, $69
    .byte $67, $65, $62, $60, $5d, $59, $56, $52
    .byte $80, $81, $81, $82, $83, $84, $86, $88
    .byte $8a, $8d, $90, $93, $96, $9a, $9e, $a2
    .byte $90, $91, $91, $92, $93, $94, $95, $97
    .byte $99, $9b, $9e, $a0, $a3, $a7, $aa, $ae
    .byte $a0, $a1, $a1, $a2, $a2, $a3, $a5, $a6
    .byte $a8, $aa, $ac, $ae, $b1, $b3, $b6, $b9
    .byte $b0, $b1, $b1, $b1, $b2, $b3, $b4, $b5
    .byte $b7, $b8, $ba, $bc, $be, $c0, $c3, $c5
    .byte $c0, $c1, $c1, $c1, $c2, $c2, $c3, $c4
    .byte $c5, $c7, $c8, $ca, $cb, $cd, $cf, $d1
    .byte $d0, $d1, $d1, $d1, $d1, $d2, $d3, $d3
    .byte $d4, $d5, $d6, $d7, $d9, $da, $db, $dd
    .byte $e0, $e1, $e1, $e1, $e1, $e1, $e2, $e2
    .byte $e3, $e4, $e4, $e5, $e6, $e7, $e8, $e9
    .byte $f0, $f1, $f1, $f1, $f1, $f1, $f1, $f1
    .byte $f2, $f2, $f2, $f3, $f3, $f4, $f4, $f5
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $0b, $0a, $0a, $09, $08, $08, $07, $06
    .byte $06, $05, $04, $03, $03, $02, $01, $00
    .byte $16, $15, $14, $13, $11, $10, $0f, $0d
    .byte $0c, $0a, $09, $07, $06, $04, $03, $01
    .byte $21, $20, $1e, $1c, $1a, $18, $16, $14
    .byte $12, $10, $0d, $0b, $09, $07, $04, $02
    .byte $2d, $2a, $28, $26, $23, $20, $1e, $1b
    .byte $18, $15, $12, $0f, $0c, $09, $06, $03
    .byte $38, $35, $32, $2f, $2c, $29, $25, $22
    .byte $1e, $1a, $17, $13, $0f, $0b, $07, $03
    .byte $43, $40, $3c, $39, $35, $31, $2d, $29
    .byte $24, $20, $1b, $17, $12, $0e, $09, $04
    .byte $4f, $4b, $47, $42, $3e, $39, $34, $2f
    .byte $2a, $25, $20, $1b, $15, $10, $0a, $05
    .byte $a6, $ab, $af, $b4, $b9, $bf, $c4, $ca
    .byte $d0, $d5, $db, $e1, $e8, $ee, $f4, $fa
    .byte $b1, $b5, $b9, $be, $c2, $c7, $cc, $d1
    .byte $d6, $db, $e0, $e5, $eb, $f0, $f6, $fb
    .byte $bd, $c0, $c4, $c7, $cb, $cf, $d3, $d7
    .byte $dc, $e0, $e5, $e9, $ee, $f2, $f7, $fc
    .byte $c8, $cb, $ce, $d1, $d4, $d7, $db, $de
    .byte $e2, $e6, $e9, $ed, $f1, $f5, $f9, $fd
    .byte $d3, $d6, $d8, $da, $dd, $e0, $e2, $e5
    .byte $e8, $eb, $ee, $f1, $f4, $f7, $fa, $fd
    .byte $df, $e0, $e2, $e4, $e6, $e8, $ea, $ec
    .byte $ee, $f0, $f3, $f5, $f7, $f9, $fc, $fe
    .byte $ea, $eb, $ec, $ed, $ef, $f0, $f1, $f3
    .byte $f4, $f6, $f7, $f9, $fa, $fc, $fd, $ff
    .byte $f5, $f6, $f6, $f7, $f8, $f8, $f9, $fa
    .byte $fa, $fb, $fc, $fd, $fd, $fe, $ff, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $ff, $fe, $fd, $fd, $fc, $fb
    .byte $fa, $fa, $f9, $f8, $f8, $f7, $f6, $f6
    .byte $00, $ff, $fd, $fc, $fa, $f9, $f7, $f6
    .byte $f4, $f3, $f1, $f0, $ef, $ed, $ec, $eb
    .byte $00, $fe, $fc, $f9, $f7, $f5, $f3, $f0
    .byte $ee, $ec, $ea, $e8, $e6, $e4, $e2, $e0
    .byte $00, $fd, $fa, $f7, $f4, $f1, $ee, $eb
    .byte $e8, $e5, $e2, $e0, $dd, $da, $d8, $d6
    .byte $00, $fd, $f9, $f5, $f1, $ed, $e9, $e6
    .byte $e2, $de, $db, $d7, $d4, $d1, $ce, $cb
    .byte $00, $fc, $f7, $f2, $ee, $e9, $e5, $e0
    .byte $dc, $d7, $d3, $cf, $cb, $c7, $c4, $c0
    .byte $00, $fb, $f6, $f0, $eb, $e5, $e0, $db
    .byte $d6, $d1, $cc, $c7, $c2, $be, $b9, $b5
    .byte $00, $06, $0c, $12, $18, $1f, $25, $2b
    .byte $30, $36, $3c, $41, $47, $4c, $51, $55
    .byte $00, $05, $0a, $10, $15, $1b, $20, $25
    .byte $2a, $2f, $34, $39, $3e, $42, $47, $4b
    .byte $00, $04, $09, $0e, $12, $17, $1b, $20
    .byte $24, $29, $2d, $31, $35, $39, $3c, $40
    .byte $00, $03, $07, $0b, $0f, $13, $17, $1a
    .byte $1e, $22, $25, $29, $2c, $2f, $32, $35
    .byte $00, $03, $06, $09, $0c, $0f, $12, $15
    .byte $18, $1b, $1e, $20, $23, $26, $28, $2a
    .byte $00, $02, $04, $07, $09, $0b, $0d, $10
    .byte $12, $14, $16, $18, $1a, $1c, $1e, $20
    .byte $00, $01, $03, $04, $06, $07, $09, $0a
    .byte $0c, $0d, $0f, $10, $11, $13, $14, $15
    .byte $00, $00, $01, $02, $03, $03, $04, $05
    .byte $06, $06, $07, $08, $08, $09, $0a, $0a
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $f5, $f5, $f4, $f4, $f3, $f3, $f2, $f2
    .byte $f2, $f1, $f1, $f1, $f1, $f1, $f1, $f1
    .byte $ea, $e9, $e8, $e7, $e6, $e5, $e4, $e4
    .byte $e3, $e2, $e2, $e1, $e1, $e1, $e1, $e1
    .byte $df, $dd, $db, $da, $d9, $d7, $d6, $d5
    .byte $d4, $d3, $d3, $d2, $d1, $d1, $d1, $d1
    .byte $d3, $d1, $cf, $cd, $cb, $ca, $c8, $c7
    .byte $c5, $c4, $c3, $c2, $c2, $c1, $c1, $c1
    .byte $c8, $c5, $c3, $c0, $be, $bc, $ba, $b8
    .byte $b7, $b5, $b4, $b3, $b2, $b1, $b1, $b1
    .byte $bd, $b9, $b6, $b3, $b1, $ae, $ac, $aa
    .byte $a8, $a6, $a5, $a3, $a2, $a2, $a1, $a1
    .byte $b1, $ae, $aa, $a7, $a3, $a0, $9e, $9b
    .byte $99, $97, $95, $94, $93, $92, $91, $91
    .byte $5a, $5e, $62, $66, $6a, $6d, $70, $73
    .byte $76, $78, $7a, $7c, $7d, $7e, $7f, $7f
    .byte $4f, $52, $56, $59, $5d, $60, $62, $65
    .byte $67, $69, $6b, $6c, $6d, $6e, $6f, $6f
    .byte $43, $47, $4a, $4d, $4f, $52, $54, $56
    .byte $58, $5a, $5b, $5d, $5e, $5e, $5f, $5f
    .byte $38, $3b, $3d, $40, $42, $44, $46, $48
    .byte $49, $4b, $4c, $4d, $4e, $4f, $4f, $4f
    .byte $2d, $2f, $31, $33, $35, $36, $38, $39
    .byte $3b, $3c, $3d, $3e, $3e, $3f, $3f, $3f
    .byte $21, $23, $25, $26, $27, $29, $2a, $2b
    .byte $2c, $2d, $2d, $2e, $2f, $2f, $2f, $2f
    .byte $16, $17, $18, $19, $1a, $1b, $1c, $1c
    .byte $1d, $1e, $1e, $1f, $1f, $1f, $1f, $1f
    .byte $0b, $0b, $0c, $0c, $0d, $0d, $0e, $0e
    .byte $0e, $0f, $0f, $0f, $0f, $0f, $0f, $0f
; left shift the value 4 bits to get the RotIndexLo offset for magnitude 0
; left shift bits 4:5 4 bits to get the RotIndexHi offset for magnitude 0
RotIndex_sin:
    .byte $20, $1f, $1e, $1d, $1c, $1b, $1a, $19
    .byte $18, $17, $16, $15, $14, $13, $12, $11
    .byte $10, $0f, $0e, $0d, $0c, $0b, $0a, $09
    .byte $08, $07, $06, $05, $04, $03, $02, $01
    .byte $00, $01, $02, $03, $04, $05, $06, $07
    .byte $08, $09, $0a, $0b, $0c, $0d, $0e, $0f
    .byte $10, $11, $12, $13, $14, $15, $16, $17
    .byte $18, $19, $1a, $1b, $1c, $1d, $1e, $1f
    .byte $20, $21, $22, $23, $24, $25, $26, $27
    .byte $28, $29, $2a, $2b, $2c, $2d, $2e, $2f
    .byte $30, $31, $32, $33, $34, $35, $36, $37
    .byte $38, $39, $3a, $3b, $3c, $3d, $3e, $3f
    .byte $3f, $3e, $3d, $3c, $3b, $3a, $39, $38
    .byte $37, $36, $35, $34, $33, $32, $31, $30
    .byte $2f, $2e, $2d, $2c, $2b, $2a, $29, $28
    .byte $27, $26, $25, $24, $23, $22, $21, $20
RotIndex_cos:
    .byte $00, $01, $02, $03, $04, $05, $06, $07
    .byte $08, $09, $0a, $0b, $0c, $0d, $0e, $0f
    .byte $10, $11, $12, $13, $14, $15, $16, $17
    .byte $18, $19, $1a, $1b, $1c, $1d, $1e, $1f
    .byte $20, $21, $22, $23, $24, $25, $26, $27
    .byte $28, $29, $2a, $2b, $2c, $2d, $2e, $2f
    .byte $30, $31, $32, $33, $34, $35, $36, $37
    .byte $38, $39, $3a, $3b, $3c, $3d, $3e, $3f
    .byte $3f, $3e, $3d, $3c, $3b, $3a, $39, $38
    .byte $37, $36, $35, $34, $33, $32, $31, $30
    .byte $2f, $2e, $2d, $2c, $2b, $2a, $29, $28
    .byte $27, $26, $25, $24, $23, $22, $21, $20
    .byte $1f, $1e, $1d, $1c, $1b, $1a, $19, $18
    .byte $17, $16, $15, $14, $13, $12, $11, $10
    .byte $0f, $0e, $0d, $0c, $0b, $0a, $09, $08
    .byte $07, $06, $05, $04, $03, $02, $01, $00

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
; enable 1 to draw a shuttle or cube
.ifdef CUBE_DEMO
CODE_arr:    .byte 0,   1
SCALE_arr:   .byte 15,  15
XROT_arr:    .byte 0,   0
YROT_arr:    .byte 0,   24
ZROT_arr:    .byte 0,   0
.else
CODE_arr:    .byte 1,   0
.endif


.ifdef SHUTTLE1
; shuttle animation 1
SCALE_arr:   .byte 15,  15
XROT_arr:    .byte 24,  0
YROT_arr:    .byte 0,   24
ZROT_arr:    .byte 0,   0
.endif

.ifdef SHUTTLE2 
; shuttle animation 2
SCALE_arr:   .byte 12,  15
XROT_arr:    .byte 0,  0
YROT_arr:    .byte 0,   24
ZROT_arr:    .byte 0,   0
.endif

X_arr:       .byte 127, 127
Y_arr:       .byte 100, 100
; set by CRUNCH
SX_arr:      .byte 0,   0
SY_arr:      .byte 0,   0

NumObjects := 2  ; number of objects
