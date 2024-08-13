; budge 3-D Graphics System using 128 step rotation

.include "cbm_kernal.inc"
.include "common.inc"


BMP0 = $6000
BMP0_SCREEN = $5c00
BMP1 = $a000
BMP1_SCREEN = $8000

; select a demo
;CUBE_DEMO := 1
SHUTTLE1 := 1
;SHUTTLE2 := 1

; uncomment to use XOR to clear
;USE_XOR := 1
; uncomment to double the object size
.ifndef CUBE_DEMO
DOUBLE_SIZE := 1
.endif
  
; self modifying code
OpDEY := $88 ;DEY opcode
OpINY := $c8 ;INY opcode
OpDEX := $ca ;DEX opcode
OpINX := $e8 ;INX opcode
OpNOP := $ea ;NOP opcode

; globals
current_page := $05 ; Current hi-res page id.
temp1 := $fb
temp2 := $fc
temp3 := $fd
temp4 := $fe

.segment "DATA"


.segment	"START"

    .byte $01, $08, $0b, $08, $13, $02, $9e, $32, $30, $36, $31, $00, $00, $00

.segment	"CODE"

jmp mane

.include "tables2.s"



mane:
    INIT_DEBUG
; switch out BASIC ROM
    lda #KERNAL_IN
    sta PORT_REG

; bitmap mode https://sta.c64.org/cbm64mem.html
    lda	#$bb
	sta	$d011		

; border color
	lda	#$0e
	sta	$d020
	sta	$d021

    lda #0
    sta current_page
; set up the bitmap
    jsr flip_page
    jsr clear
    jsr flip_page
    jsr clear

	lda	$d018       ; set bitmap memory relative to VIC bank
	and	#%11110000
	ora	#%00001000  ; vic bank + $2000
	sta	$d018	

; set color memory to white pen on dark blue paper (also clears sprite pointers) on screen 2
	ldx	#$00
	lda	#$e6
loopcol:
	sta	BMP0_SCREEN,x	
	sta	BMP0_SCREEN+$100,x
	sta	BMP0_SCREEN+$200,x
	sta	BMP0_SCREEN+$300,x
    sta	BMP1_SCREEN,x	
	sta	BMP1_SCREEN+$100,x
	sta	BMP1_SCREEN+$200,x
	sta	BMP1_SCREEN+$300,x
	inx
	bne	loopcol

; clear entire bitmap
        jsr clear_BMP0_full
        jsr clear_BMP1_full


        SELECT_PRINTER
        PRINT_TEXT welcome

;        SET_LITERAL16 temp1, RotTabLo
;        PRINT_HEX16 temp1
;        SET_LITERAL16 temp1, RotTabHi
;        PRINT_HEX16 temp1
;        SET_LITERAL16 temp1, ScaleTabLo
;        PRINT_HEX16 temp1
;        SET_LITERAL16 temp1, ScaleTabHi
;        PRINT_HEX16 temp1
;        SET_LITERAL16 temp1, XCoord0_BMP0
;        PRINT_HEX16 temp1
;        SET_LITERAL16 temp1, Div7Tab
;        PRINT_HEX16 temp1
;        SET_LITERAL16 temp1, YTableHi_BMP0
;        PRINT_HEX16 temp1
;        SET_LITERAL16 temp1, YTableHi_BMP1
;        PRINT_HEX16 temp1

; draw it
loop:
.ifndef USE_XOR
        jsr clear
.endif

        jsr CRUNCH
.ifdef SHUTTLE1
; shuttle animation 1
        ldx #0
        jsr inc_zrot
.endif
.ifdef SHUTTLE2
; shuttle animation 2
        ldx #0
        jsr inc_zrot
.endif
.ifdef CUBE_DEMO
; animate a cube
        ldx #1
        jsr inc_zrot
.endif


; promote from draw to erase if using XOR
.ifdef USE_XOR
        lda CODE_arr
        cmp #1
        bne promote1
            inc CODE_arr
promote1:
        lda CODE_arr + 1
        cmp #1
        bne promote2
            inc CODE_arr + 1
promote2:
.endif

        jmp loop

hang:
    jmp hang
    rts

inc_yrot:
    inc YROT_arr,x
    lda YROT_arr,x
    cmp #127
    bcc inc_yrot2 ; yrot < 127
        lda #0
        sta YROT_arr,x
inc_yrot2:
        rts

inc_xrot:
    inc XROT_arr,x
    lda XROT_arr,x
    cmp #127
    bcc inc_xrot2 ; xrot < 127
        lda #0
        sta XROT_arr,x
inc_xrot2:
        rts

inc_zrot:
    inc ZROT_arr,x
    lda ZROT_arr,x
    cmp #127
    bcc inc_zrot2 ; zrot < 127
        lda #0
        sta ZROT_arr,x
inc_zrot2:
        rts






flip_page:
; wait for raster line >= 256
    lda $d011
    bpl flip_page

    lda #1
    eor current_page
    sta current_page
    cmp #0
    bne flip_page2 ; current_page == 1

; display BMP0, draw BMP1
; https://sta.c64.org/cbm64mem.html
	    lda $d018
	    and	#%00001111  ; set color memory relative to VIC bank
	    ora	#%01110000  ; vic bank + $1c00
	    sta	$d018

        lda	$dd00		; set the VIC bank
	    and	#%11111100
	    ora	#%00000010  ; $4000
	    sta	$dd00

        ldx #>XCoord1_BMP1
        ldy #>YCoord1_BMP1
        lda #<YTableHi_BMP1
        sta ytablemod1 + 1
        sta ytablemod2 + 1
        sta ytablemod3 + 1
        lda #>YTableHi_BMP1
        jmp flip_page3

flip_page2:
; display BMP1, draw BMP0
	lda $d018           ; set color memory relative to VIC bank
	and	#%00001111
	ora	#%00000000      ; VIC II only sees character ROM at $9000
	sta	$d018

	lda	$dd00		    ; set the VIC bank
	and	#%11111100
	ora	#%00000001      ; $8000
	sta	$dd00

    ldx #>XCoord0_BMP0
    ldy #>YCoord0_BMP0
    lda #<YTableHi_BMP0
    sta ytablemod1 + 1
    sta ytablemod2 + 1
    sta ytablemod3 + 1
    lda #>YTableHi_BMP0
flip_page3:
; set high bytes of transformed coord arrays
    stx _0E_or_10_1+2
    stx _0E_or_10_2+2
    stx _0E_or_10_3+2
    sty _0F_or_11_1+2
    sty _0F_or_11_2+2
    sty _0F_or_11_3+2
    sta ytablemod1 + 2
    sta ytablemod2 + 2
    sta ytablemod3 + 2
    rts


; clear entire screen
clear_BMP1_full:
	ldy	#32
    lda	#<BMP1	; set starting address
	sta	modfull1 + 1
	lda	#>BMP1
	sta	modfull1 + 2	
    jmp loop_clear_full

clear_BMP0_full:
	ldy	#32
    lda	#<BMP0	; set starting address
	sta	modfull1 + 1
	lda	#>BMP0
	sta	modfull1 + 2	

loop_clear_full:
	ldx	#250
	lda	#$00            ;filling value 
loop_clear_full2:
	dex
modfull1:
    sta	BMP0,x
    bne	loop_clear_full2
	    clc
	    lda	modfull1+1
	    adc	#250
	    sta	modfull1+1
	    lda	modfull1+2
	    adc	#00
	    sta	modfull1+2
	    dey
	    bne	loop_clear_full
	        rts

; clear the current drawing area
clear:
    lda current_page 
    beq clear_BMP1 ; current_page == 0

clear_BMP0:
; clear cols 0 - 255
    lda #$00
    ldx #0
; loop 256 times
clear_BMP0_loop:
    sta BMP0+0*320,x
    sta BMP0+1*320,x
    sta BMP0+2*320,x
    sta BMP0+3*320,x
    sta BMP0+4*320,x
    sta BMP0+5*320,x
    sta BMP0+6*320,x
    sta BMP0+7*320,x
    sta BMP0+8*320,x
    sta BMP0+9*320,x
    sta BMP0+10*320,x
    sta BMP0+11*320,x
    sta BMP0+12*320,x
    sta BMP0+13*320,x
    sta BMP0+14*320,x
    sta BMP0+15*320,x
    sta BMP0+16*320,x
    sta BMP0+17*320,x
    sta BMP0+18*320,x
    sta BMP0+19*320,x
    sta BMP0+20*320,x
    sta BMP0+21*320,x
    sta BMP0+22*320,x
    sta BMP0+23*320,x
    sta BMP0+24*320,x
    inx
    bne	clear_BMP0_loop
        rts




clear_BMP1:
; clear cols 0 - 255
    lda #$00
    ldx #0
; loop 256 times
clear_BMP1_loop:
    sta BMP1+0*320,x
    sta BMP1+1*320,x
    sta BMP1+2*320,x
    sta BMP1+3*320,x
    sta BMP1+4*320,x
    sta BMP1+5*320,x
    sta BMP1+6*320,x
    sta BMP1+7*320,x
    sta BMP1+8*320,x
    sta BMP1+9*320,x
    sta BMP1+10*320,x
    sta BMP1+11*320,x
    sta BMP1+12*320,x
    sta BMP1+13*320,x
    sta BMP1+14*320,x
    sta BMP1+15*320,x
    sta BMP1+16*320,x
    sta BMP1+17*320,x
    sta BMP1+18*320,x
    sta BMP1+19*320,x
    sta BMP1+20*320,x
    sta BMP1+21*320,x
    sta BMP1+22*320,x
    sta BMP1+23*320,x
    sta BMP1+24*320,x
    inx
    bne	clear_BMP1_loop
        rts


; 
; Draw a list of lines using exclusive-or, which inverts the pixels.  Drawing
; the same thing twice erases it.
; 
; On entry:
;  $45 - index of first line
;  $46 - index of last line
;  XCoord_0E/YCoord_0F or XCoord_10/YCoord_11 have transformed points in screen
; coordinates
; 
; When the module is configured for OR-mode drawing, this code is replaced with
; a dedicated erase function.  The erase code is nearly identical to the draw
; code, but saves a little time by simply zeroing out whole bytes instead of
; doing a read-modify-write.

hptr       := $06 ; 2 bytes
xstart     := $1c 
ystart     := $1d 
xend       := $1e 
yend       := $1f 
delta_x    := $3c 
delta_y    := $3d 
line_adj   := $3e 
line_index := $43 
ysave      := $44 

DrawLineList:    ldx     first_line       ; start with the first line in this object
DrawLoop:        lda     LineStartPoint,x ; get X0,Y0
                 tay                       
_0E_or_10_1:     lda     XCoord0_BMP0,y   ; the instructions here are modified to load from
                 sta     xstart           ; the appropriate set of X/Y coordinate tables
_0F_or_11_1:     lda     YCoord0_BMP0,y
                 sta     ystart
                 lda     LineEndPoint,x   ; get X1,Y1
                 tay
_0E_or_10_2:     lda     XCoord0_BMP0,y 
                 sta     xend
_0F_or_11_2:     lda     YCoord0_BMP0,y
                 sta     yend
                 stx     line_index       ; save this off
; Prep the line draw code.  We need to compute deltaX/deltaY, and set a register
; increment / decrement / no-op instruction depending on which way the line is
; going.
                lda     xstart            ; compute delta X
                sec
                sbc     xend
                bcs     L1A2F             ; left to right
                eor     #$ff              ; right to left; invert value
                adc     #$01     
                ldy     #OpINX   
                bne     GotDeltaX

L1A2F:          beq     IsVertical        ; branch if deltaX=0
                ldy     #OpDEX   
                bne     GotDeltaX

IsVertical:     ldy     #OpNOP            ; fully vertical, use no-op
GotDeltaX:      sta     delta_x    
                sty     _InxDexNop1
                sty     _InxDexNop2
                lda     ystart            ; compute delta Y
                sec         
                sbc     yend
                bcs     L1A4E             ; end < start, we're good
                eor     #$ff              ; invert value
                adc     #$01     
                ldy     #OpINY   
                bne     GotDeltaY

L1A4E:          beq     IsHorizontal      ; branch if deltaY=0
                ldy     #OpDEY   
                bne     GotDeltaY

IsHorizontal:   ldy     #OpNOP            ; fully horizontal, use no-op
GotDeltaY:      sta     delta_y     
                sty     _InyDeyNop1 
                sty     _InyDeyNop2 
                ldx     xstart      
                ldy     ystart      
                lda     #$00        
                sta     line_adj    
                lda     delta_x     
                cmp     delta_y     
                bcs     HorizDomLine
; Line draw: vertically dominant (move vertically every step)
; 
; On entry: X=xpos, Y=ypos
VertDomLine:    cpy     yend              ;
                beq     LineDone          ;
_InyDeyNop1:    nop                       ; self-mod INY/DEY/NOP
                lda     YTableLo,y        ; new line, update Y position
                sta     hptr              ;
ytablemod1:     lda     YTableHi_BMP0,y   ;
                sta     hptr+1            ;
                lda     line_adj          ; Bresenham update
                clc                
                adc     delta_x    
                cmp     delta_y    
                bcs     NewColumn  
                sta     line_adj   
                bcc     SameColumn 

NewColumn:      sbc     delta_y    
                sta     line_adj   
_InxDexNop1:    nop                       ; self-mod INX/DEX/NOP
SameColumn:     sty     ysave             ;
                ldy     Div7Tab,x         ; XOR-draw the point
                lda     (hptr),y      
.ifdef USE_XOR
                eor     HiResBitTab,x
.else
                ora     HiResBitTab,x 
.endif
                sta     (hptr),y      
                ldy     ysave         
                jmp     VertDomLine   

LineDone:       ldx     line_index    
                inx                   
                cpx     last_line         ; reached end?
                beq     DrawDone
                jmp     DrawLoop

DrawDone:       rts             

; Line draw: horizontally dominant (move horizontally every step)
; 
; On entry: X=xpos, Y=ypos
HorizDomLine:   lda     YTableLo,y        ; set up hi-res pointer
                sta     hptr              ;
ytablemod2:     lda     YTableHi_BMP0,y   ;
                sta     hptr+1            ;
HorzLoop:       cpx     xend              ; X at end?
                beq     LineDone          ; yes, finish
_InxDexNop2:    nop                       ;
                lda     line_adj          ; Bresenham update
                clc                       ;
                adc     delta_y           ;
                cmp     delta_x           ;
                bcs     NewRow            ;
                sta     line_adj          ;
                bcc     SameRow           ;

NewRow:         sbc     delta_x           ;
                sta     line_adj          ;
_InyDeyNop2:    nop                       ;
                lda     YTableLo,y        ; update Y position
                sta     hptr              ;
ytablemod3:     lda     YTableHi_BMP0,y   ;
                sta     hptr+1            ;
SameRow:        sty     ysave             ;
                ldy     Div7Tab,x         ; XOR-draw the point
                lda     (hptr),y       
.ifdef USE_XOR
                eor     HiResBitTab,x 
.else
                ora     HiResBitTab,x  
.endif
                sta     (hptr),y       
                ldy     ysave          
                jmp     HorzLoop       





; Coordinate transformation function.  Transforms all points in a single object.
; 
; On entry:
;  scale 0-15
;  xc 0-255
;  yc 0-200
;  zrot 00-27
;  yrot 00-27
;  xrot 00-27
;  first_point: index of first point to transform
;  last_point: index of last point to transform
; 
; Rotation values greater than $1B, and scale factors greater than $0F, disable
; the calculation.  This has the same effect as a rotation value of 0 or a scale
; of 15, but is more efficient, because this uses self-modifying code to skip
; the computation entirely.
; 
xc          := $19 ; transformed X coordinate
yc          := $1a ; transformed Y coordinate
zc          := $1b ; transformed Z coordinate
scale       := $1c ; $00-0F, where $0F is full size
xposn       := $1d ; X coordinate (0-255)
yposn       := $1e ; Y coordinate (0-191)
zrot        := $1f ; Z rotation ($00-1B)
yrot        := $3c ; Y rotation ($00-1B)
xrot        := $3d ; X rotation ($00-1B)
rot_tmp     := $3f ; 4 bytes
out_index   := $43 
first_point := $45 
last_point  := $46 


CompTransform:

; angle is in Y
.macro COMPUTE_LO index_table, dst, dst2
; compute the magnitude 0 offset
    lda #0
    sta temp1
    lda index_table,y
    asl A                    ; left shift 4 bits
    rol temp1
    asl A
    rol temp1
    asl A
    rol temp1
    asl A
    rol temp1
    clc                      ; add temp1, A to table start
    adc #<RotTabLo
    sta dst + 1
    sta dst2 + 1
    lda temp1
    adc #>RotTabLo
    sta dst + 2
    sta dst2 + 2
.endmacro

; angle is in Y
.macro COMPUTE_HI index_table, dst, dst2
; compute the magnitude 0 offset
    lda index_table,y
    sta temp1 ; bits 4:5 into temp1
    lsr temp1
    lsr temp1
    lsr temp1
    lsr temp1
    and #$f   ; bits 0:3 into A
    clc 
    adc #<RotTabHi          ; add temp1, A to table start
    sta dst + 1
    sta dst2 + 1
    lda temp1
    adc #>RotTabHi
    sta dst + 2
    sta dst2 + 2
.endmacro

; Configure Z rotation.
                ldy     zrot
                COMPUTE_LO RotIndex_sin, _zrotLS1, _zrotLS2
                COMPUTE_LO RotIndex_cos, _zrotLC1, _zrotLC2
                COMPUTE_HI RotIndex_sin, _zrotHS1, _zrotHS2
                COMPUTE_HI RotIndex_cos, _zrotHC1, _zrotHC2
; Configure Y rotation.
                ldy     yrot
                COMPUTE_LO RotIndex_sin, _yrotLS1, _yrotLS2
                COMPUTE_LO RotIndex_cos, _yrotLC1, _yrotLC2
                COMPUTE_HI RotIndex_sin, _yrotHS1, _yrotHS2
                COMPUTE_HI RotIndex_cos, _yrotHC1, _yrotHC2
; Configure X rotation.
                ldy     xrot
                COMPUTE_LO RotIndex_sin, _xrotLS1, _xrotLS2
                COMPUTE_LO RotIndex_cos, _xrotLC1, _xrotLC2
                COMPUTE_HI RotIndex_sin, _xrotHS1, _xrotHS2
                COMPUTE_HI RotIndex_cos, _xrotHC1, _xrotHC2


; DEBUG
;                ldy zrot
;                COMPUTE_LO RotIndex_sin, test_sin_lo, test_sin_lo
;                COMPUTE_LO RotIndex_cos, test_cos_lo, test_cos_lo
;                COMPUTE_HI RotIndex_sin, test_sin_hi, test_sin_hi
;                COMPUTE_HI RotIndex_cos, test_cos_hi, test_cos_hi
;
;TEST_MAG_LO := $00 ; low nibble
;TEST_MAG_HI := $80 ; high nibble
;                ldy #TEST_MAG_LO
;test_sin_lo:    lda RotTabLo,y
;                sta temp1
;                ldy #TEST_MAG_HI
;test_sin_hi:    lda RotTabHi,y
;                clc
;                adc temp1
;                sta temp1
;
;                ldy #TEST_MAG_LO
;test_cos_lo:    lda RotTabLo,y
;                sta temp2
;                ldy #TEST_MAG_HI
;test_cos_hi:    lda RotTabHi,y
;                clc
;                adc temp2
;                sta temp2
;
;                PRINT_HEX8 zrot
;                PRINT_HEX8 temp1
;                PRINT_HEX8 temp2
;                lda #$0a
;                jsr CIOUT
                
                ldx     first_point   ; get first point index; this stays in X for a while

; Configure scaling.
ConfigScale:    ldy     scale     
                cpy     #$10           ; valid scale value?
                bcc     SetScale       ; yes, configure it
                lda     #<DoTranslate  ; no, skip it
                sta     _BeforeScale+1 
                lda     #>DoTranslate  
                sta     _BeforeScale+2 
                bne     TransformLoop  

SetScale:       lda     #<DoScale      
                sta     _BeforeScale+1 
                lda     #>DoScale      
                sta     _BeforeScale+2 
                lda     ScaleIndexLo,y ; $00, $10, $20, ... $F0
                sta     _scaleLX+1     
                sta     _scaleLY+1     
                lda     ScaleIndexHi,y ; $00, $01, $02, ... $0F
                sta     _scaleHX+1     
                sta     _scaleHY+1     
; 
; Now that we've got the code modified, perform the computation for all points
; in the object.
; 
TransformLoop:  lda     ShapeXCoords,x
                sta     xc            
                lda     ShapeYCoords,x
                sta     yc            
                lda     ShapeZCoords,x
                sta     zc            
.ifdef DOUBLE_SIZE
                asl xc ; HACK double the size
                asl yc ; HACK double the size
                asl zc ; HACK double the size
.endif

                stx     out_index        ; save for later

;                PRINT_TEXT transformloop1
;                PRINT_HEX8 xc
;                PRINT_HEX8 yc
;                PRINT_HEX8 zc
;                lda #$0a
;                jsr CIOUT


DoZrot:         lda     xc               ;  rotating about Z, so we need to update X/Y coords
                and     #$0f             ;  split X/Y into nibbles
                sta     rot_tmp   
                lda     xc        
                and     #$f0      
                sta     rot_tmp+1 
                lda     yc        
                and     #$0f      
                sta     rot_tmp+2 
                lda     yc        
                and     #$f0      
                sta     rot_tmp+3 
                ldy     rot_tmp          ;  transform X coord
                ldx     rot_tmp+1        ;  XC = X * cos(theta) - Y * sin(theta)
_zrotLC1:       lda     RotTabLo,y
                clc               
_zrotHC1:       adc     RotTabHi,x
                ldy     rot_tmp+2 
                ldx     rot_tmp+3 
                sec               
_zrotLS1:       sbc     RotTabLo,y
                sec               
_zrotHS1:       sbc     RotTabHi,x
                sta     xc                ;  save updated coord
_zrotLC2:       lda     RotTabLo,y        ; transform Y coord
                clc                       ;  YC = Y * cos(theta) + X * sin(theta)
_zrotHC2:       adc     RotTabHi,x  
                ldy     rot_tmp     
                ldx     rot_tmp+1   
                clc                 
_zrotLS2:       adc     RotTabLo,y  
                clc                 
_zrotHS2:       adc     RotTabHi,x  
                sta     yc               ;  save updated coord

; DEBUG
;                jmp skip_rot

DoYrot:         lda     xc               ;  rotating about Y, so update X/Z
                and     #$0f        
                sta     rot_tmp     
                lda     xc          
                and     #$f0        
                sta     rot_tmp+1   
                lda     zc          
                and     #$0f        
                sta     rot_tmp+2   
                lda     zc          
                and     #$f0        
                sta     rot_tmp+3   
                ldy     rot_tmp     
                ldx     rot_tmp+1   
_yrotLC1:       lda     RotTabLo,y  
                clc                 
_yrotHC1:       adc     RotTabHi,x  
                ldy     rot_tmp+2   
                ldx     rot_tmp+3   
                sec                 
_yrotLS1:       sbc     RotTabLo,y  
                sec                 
_yrotHS1:       sbc     RotTabHi,x  
                sta     xc          
_yrotLC2:       lda     RotTabLo,y  
                clc                 
_yrotHC2:       adc     RotTabHi,x  
                ldy     rot_tmp     
                ldx     rot_tmp+1   
                clc                 
_yrotLS2:       adc     RotTabLo,y  
                clc                 
_yrotHS2:       adc     RotTabHi,x  
                sta     zc          

DoXrot:         lda     zc           ; rotating about X, so update Z/Y
                and     #$0f      
                sta     rot_tmp   
                lda     zc        
                and     #$f0      
                sta     rot_tmp+1 
                lda     yc        
                and     #$0f      
                sta     rot_tmp+2 
                lda     yc        
                and     #$f0      
                sta     rot_tmp+3 
                ldy     rot_tmp   
                ldx     rot_tmp+1 
_xrotLC1:       lda     RotTabLo,y
                clc               
_xrotHC1:       adc     RotTabHi,x
                ldy     rot_tmp+2 
                ldx     rot_tmp+3 
                sec               
_xrotLS1:       sbc     RotTabLo,y
                sec               
_xrotHS1:       sbc     RotTabHi,x
                sta     zc        
_xrotLC2:       lda     RotTabLo,y
                clc               
_xrotHC2:       adc     RotTabHi,x
                ldy     rot_tmp   
                ldx     rot_tmp+1 
                clc               
_xrotLS2:       adc     RotTabLo,y
                clc               
_xrotHS2:       adc     RotTabHi,x
                sta     yc        



;                PRINT_TEXT transform_loop2
;                PRINT_HEX8 xc
;                PRINT_HEX8 yc
;                PRINT_HEX8 zc
;                lda #$0a
;                jsr CIOUT

_BeforeScale:   jmp     DoScale   

; DEBUG
;skip_rot:

; Apply scaling.  Traditionally this is applied before rotation.
DoScale:        lda     xc           ; scale the X coordinate
                and     #$f0         
                tax                  
                lda     xc           
                and     #$0f         
                tay                  
_scaleLX:       lda     ScaleTabLo,y 
                clc                  
_scaleHX:       adc     ScaleTabHi,x 
                sta     xc           
                lda     yc           ; scale the Y coordinate
                and     #$f0         
                tax                  
                lda     yc           
                and     #$0f         
                tay                  
_scaleLY:       lda     ScaleTabLo,y 
                clc                  
_scaleHY:       adc     ScaleTabHi,x 
                sta     yc           
; 
; Apply translation.
; 
; This is the final step, so the result is written to the transformed-point
; arrays.
; 
DoTranslate:    ldx     out_index        
                lda     xc               
                clc
                adc     xposn            ; object center in screen coordinates
_0E_or_10_3:    sta     XCoord0_BMP0,x    
                lda     yposn           
                sec
                sbc     yc              
_0F_or_11_3:    sta     YCoord0_BMP0,x    
                inx
                cpx     last_point       ; done?
                beq     TransformDone    ; yes, bail
                jmp     TransformLoop    

TransformDone:  rts                      






;********************************************************************************
;* CRUNCH/CRNCH% entry point                                                    *
;*                                                                              *
;* For each object, do what CODE%(n) tells us to:                               *
;*                                                                              *
;*  0 - do nothing                                                              *
;*  1 - transform and draw                                                      *
;*  2 - erase, transform, draw                                                  *
;*  3 - erase                                                                   *
;********************************************************************************

first_line := $45
last_line  := $46
SavedShapeIndex := $47

CRUNCH:
; 
; First pass: erase old shapes
                ldx     #NumObjects       ; number of defined objects
ShapeLoop:      dex 
                bmi     Transform         ; done
_codeAR1:       lda     CODE_arr,x
                cmp     #$02              ; 2 or 3?
                bcc     ShapeLoop         ; no, move on
                stx     SavedShapeIndex  
                lda     FirstLineIndex,x 
                sta     first_line       
                lda     LastLineIndex,x  
                sta     last_line        
                cmp     first_line        ; is number of lines <= 0?
                bcc     NoLines1          ;
                beq     NoLines1          ; yes, skip draw
                jsr     DrawLineList      ; erase with EOR version, regardless of config
NoLines1:       ldx     SavedShapeIndex   ;
                bpl     ShapeLoop         ; ...always

; 
; Second pass: transform shapes
; 
Transform:      ldx     #NumObjects  
TransLoop:      dex                  
                bmi     DrawNew      
_codeAR2:       lda     CODE_arr,x   
                beq     TransLoop         ; is it zero or three?
                cmp     #$03  
                beq     TransLoop         ; yes, we only draw on 1 or 2
; Extract the scale, X/Y, and rotation values out of the arrays and copy them to
; zero-page locations.
_scaleAR:       lda     SCALE_arr,x      
                sta     scale            
_xAR:           lda     X_arr,x          
                sta     xposn            
_yAR:           lda     Y_arr,x          
                sta     yposn            
_zrotAR:        lda     ZROT_arr,x       
                sta     zrot             
_yrotAR:        lda     YROT_arr,x       
                sta     yrot             
_xrotAR:        lda     XROT_arr,x       
                sta     xrot             
                stx     SavedShapeIndex   ; save this off
                lda     FirstPointIndex,x 
                sta     first_line        ; (actually first_point)
                lda     LastPointIndex,x 
                sta     last_line        
                cmp     first_line        ; is number of points <= 0?
                bcc     NoPoints     
                beq     NoPoints          ; yes, skip transform
                jsr     CompTransform     ; transform all points
NoPoints:       ldx     SavedShapeIndex
                lda     xc             
                clc                    
                adc     xposn          
_sxAR:          sta     SX_arr,x       
                lda     yposn          
                sec                    
                sbc     yc             
_syAR:          sta     SY_arr,x       
                jmp     TransLoop      

; 
; Third pass: draw shapes
; 
DrawNew:        ldx     #NumObjects
L1ECE:          dex
                bmi     L1EF9      
_codeAR3:       lda     CODE_arr,x        ; is it 0 or 3?
                beq     L1ECE
                cmp     #$03 
                beq     L1ECE             ; yup, no draw
                stx     SavedShapeIndex   ; save index
                lda     FirstLineIndex,x  ; draw all the lines in the shape
                sta     first_line      
                lda     LastLineIndex,x 
                sta     last_line       
                cmp     first_line        ; is number of lines <= 0?
                bcc     NoLines2          ;
                beq     NoLines2          ; yes, skip draw
                jsr     DrawLineList      ; draw all lines
NoLines2:       ldx     SavedShapeIndex   ;
                bpl     L1ECE             ; ...always

L1EF9:          jmp     flip_page
                rts











welcome:
    .byte "welcome to budge64 high rotation"
    .byte $0a, $0a, $00    ; null terminator for the message
transformloop1:
    .byte "transformloop1 "
    .byte $00    ; null terminator for the message
transformloop2:
    .byte "transformloop2 "
    .byte $00    ; null terminator for the message


.include "common.s"






