; ---------------------------------------------------------------------------
; Kid chameleon decompression algorithm

; input:
;       a2 = source address
;       a3 = destination address

; usage:
;       move.l	a2,-(sp)
;	moveq	#0,d1
;	moveq	#0,d2
;	move.w	(a0)+,d0
;	lea	(a0,d0.w),a1
;	lea	(source).l,a2
;	lea	(buffer).w,a3

; See http://www.segaretro.org/Enigma_compression for format description
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

;sub_13684
Decompress_Chunk:
	moveq	#0,d0
	move.w	#$7FF,d4
	moveq	#0,d5
	moveq	#0,d6
	move.w	a3,d7
	subq.w	#1,d2
	beq.w	loc_13A24
	subq.w	#1,d2
	beq.w	loc_139A6
	subq.w	#1,d2
	beq.w	loc_13928
	subq.w	#1,d2
	beq.w	loc_138AA
	subq.w	#1,d2
	beq.w	loc_1382E
	subq.w	#1,d2
	beq.w	loc_137B0
	subq.w	#1,d2
	beq.w	loc_13736

Decompress_BitPos0:
	move.b	(a0)+,d1
	add.b	d1,d1
	bcs.s	Decompress_BP0_DrcCpy
	move.l	a2,a6
	add.b	d1,d1
	bcs.s	Decompress_BP0_LongRef
	move.b	(a1)+,d5
	suba.l	d5,a6
	add.b	d1,d1
	bcc.s	loc_136D0
	move.b	(a6)+,(a2)+

loc_136D0:
	move.b	(a6)+,(a2)+
	move.b	(a6)+,(a2)+
	cmp.w	a2,d7
	bls.s	loc_13724
	bra.w	loc_1382E
; ---------------------------------------------------------------------------

Decompress_BP0_LongRef:
	lsl.w	#3,d1
	move.w	d1,d6
	and.w	d4,d6		; d4 = $7FF
	move.b	(a1)+,d6
	suba.l	d6,a6
	add.b	d1,d1
	bcs.s	Decompress_BP0_LongRef_2or3
	add.b	d1,d1
	bcs.s	loc_13706
	bra.s	loc_13708
; ---------------------------------------------------------------------------

Decompress_BP0_LongRef_2or3:
	add.b	d1,d1
	bcc.s	Decompress_BP0_LongRef_2
	moveq	#0,d0
	move.b	(a1)+,d0	; read amount of bytes
	beq.s	loc_13716
	subq.w	#6,d0
	bmi.s	loc_1371C

loc_136FE:
	move.b	(a6)+,(a2)+
	dbf	d0,loc_136FE

Decompress_BP0_LongRef_2:
	move.b	(a6)+,(a2)+

loc_13706:
	move.b	(a6)+,(a2)+

loc_13708:
	move.b	(a6)+,(a2)+
	move.b	(a6)+,(a2)+
	move.b	(a6)+,(a2)+
	cmp.w	a2,d7
	bls.s	loc_1372C
	bra.w	loc_13A24
; ---------------------------------------------------------------------------

loc_13716:
	moveq	#0,d0 ; changed from move.w to moveq, saves 4 cycles.
	rts
; ---------------------------------------------------------------------------

loc_1371C:
	move.w	#$FFFF,d0
	moveq	#1,d2
	rts
; ---------------------------------------------------------------------------

loc_13724:
	move.w	#1,d0
	moveq	#5,d2
	rts
; ---------------------------------------------------------------------------

loc_1372C:
	moveq	#1,d0 ; changed from move.w to moveq, saves 4 cycles.
	moveq	#1,d2
	rts
; ---------------------------------------------------------------------------

Decompress_BP0_DrcCpy:
	move.b	(a1)+,(a2)+

loc_13736:
	add.b	d1,d1
	bcs.s	loc_137AE	; top bit = 1 --> direct copy
	move.l	a2,a6
	add.b	d1,d1
	bcs.s	loc_13756	; top bits 01 --> long ref
	; top bits 00 --> short ref 00:A
	move.b	(a1)+,d5
	suba.l	d5,a6
	add.b	d1,d1
	bcc.s	loc_1374A	; A = 0 --> copy 2 tiles
	; A = 1 --> copy 3 tiles
	move.b	(a6)+,(a2)+

loc_1374A:
	move.b	(a6)+,(a2)+
	move.b	(a6)+,(a2)+
	cmp.w	a2,d7
	bls.s	loc_1379E
	bra.w	loc_138AA
; ---------------------------------------------------------------------------

loc_13756:	; long ref 01:BBB:AA
	lsl.w	#3,d1	; skip 3 bits, put the into upper byte of word
	move.w	d1,d6
	and.w	d4,d6	; d4 = $7FF? is that always true?
	move.b	(a1)+,d6	; d6 = BBB*256 + BYTE1
	suba.l	d6,a6	; address to copy from
	add.b	d1,d1
	bcs.s	loc_1376A	; first bit of AA is 1
	add.b	d1,d1
	bcs.s	loc_13780	; AA = 01 --> copy 4 tiles
	bra.s	loc_13782	; AA = 00 --> copy 3 tiles
; ---------------------------------------------------------------------------

loc_1376A:
	add.b	d1,d1
	bcc.s	loc_1377E	; AA = 10 --> copy 5 tiles
	; AA = 11 --> copy 6 or more tiles
	moveq	#0,d0
	move.b	(a1)+,d0
	beq.s	loc_13790	; BYTE2 = 0 means: quit decompression
	subq.w	#6,d0
	bmi.s	loc_13796	; 0 < BYTE2 < 6 means: flush buffer

loc_13778:	; copy BYTE2 tiles
	move.b	(a6)+,(a2)+
	dbf	d0,loc_13778

loc_1377E:
	move.b	(a6)+,(a2)+

loc_13780:
	move.b	(a6)+,(a2)+

loc_13782:
	move.b	(a6)+,(a2)+
	move.b	(a6)+,(a2)+
	move.b	(a6)+,(a2)+
	cmp.w	a2,d7
	bls.s	loc_137A6
	bra.w	Decompress_BitPos0
; ---------------------------------------------------------------------------

loc_13790:	; quit decompression
	moveq	#0,d0 ; changed from move.w to moveq, saves 4 cycles.
	rts
; ---------------------------------------------------------------------------

loc_13796:	; flush decompression buffer
	move.w	#$FFFF,d0
	moveq	#0,d2
	rts
; ---------------------------------------------------------------------------

loc_1379E:
	moveq	#1,d0 ; changed from move.w to moveq, saves 4 cycles.
	moveq	#4,d2
	rts
; ---------------------------------------------------------------------------

loc_137A6:
	moveq	#1,d0 ; changed from move.w to moveq, saves 4 cycles.
	moveq	#0,d2
	rts
; ---------------------------------------------------------------------------

loc_137AE:
	move.b	(a1)+,(a2)+

loc_137B0:
	add.b	d1,d1
	bcs.s	loc_1382C
	move.l	a2,a6
	add.b	d1,d1
	bcs.s	loc_137D0
	move.b	(a1)+,d5
	suba.l	d5,a6
	add.b	d1,d1
	bcc.s	loc_137C4
	move.b	(a6)+,(a2)+

loc_137C4:
	move.b	(a6)+,(a2)+
	move.b	(a6)+,(a2)+
	cmp.w	a2,d7
	bls.s	loc_1381C
	bra.w	loc_13928
; ---------------------------------------------------------------------------

loc_137D0:
	lsl.w	#3,d1
	move.w	d1,d6
	and.w	d4,d6
	move.b	(a1)+,d6
	suba.l	d6,a6
	add.b	d1,d1
	bcs.s	loc_137E6
	move.b	(a0)+,d1
	add.b	d1,d1
	bcs.s	loc_137FE
	bra.s	loc_13800
; ---------------------------------------------------------------------------

loc_137E6:
	move.b	(a0)+,d1
	add.b	d1,d1
	bcc.s	loc_137FC
	moveq	#0,d0
	move.b	(a1)+,d0
	beq.s	loc_1380E
	subq.w	#6,d0
	bmi.s	loc_13814

loc_137F6:
	move.b	(a6)+,(a2)+
	dbf	d0,loc_137F6

loc_137FC:
	move.b	(a6)+,(a2)+

loc_137FE:
	move.b	(a6)+,(a2)+

loc_13800:
	move.b	(a6)+,(a2)+
	move.b	(a6)+,(a2)+
	move.b	(a6)+,(a2)+
	cmp.w	a2,d7
	bls.s	loc_13824
	bra.w	loc_13736
; ---------------------------------------------------------------------------

loc_1380E:
	moveq	#0,d0 ; changed from move.w to moveq, saves 4 cycles.
	rts
; ---------------------------------------------------------------------------

loc_13814:
	move.w	#$FFFF,d0
	moveq	#7,d2
	rts
; ---------------------------------------------------------------------------

loc_1381C:
	moveq	#1,d0 ; changed from move.w to moveq, saves 4 cycles.
	moveq	#3,d2
	rts
; ---------------------------------------------------------------------------

loc_13824:
	moveq	#1,d0 ; changed from move.w to moveq, saves 4 cycles.
	moveq	#7,d2
	rts
; ---------------------------------------------------------------------------

loc_1382C:
	move.b	(a1)+,(a2)+

loc_1382E:
	add.b	d1,d1
	bcs.s	loc_138A8
	move.l	a2,a6
	add.b	d1,d1
	bcs.s	loc_1384E
	move.b	(a1)+,d5
	suba.l	d5,a6
	add.b	d1,d1
	bcc.s	loc_13842
	move.b	(a6)+,(a2)+

loc_13842:
	move.b	(a6)+,(a2)+
	move.b	(a6)+,(a2)+
	cmp.w	a2,d7
	bls.s	loc_13898
	bra.w	loc_139A6
; ---------------------------------------------------------------------------

loc_1384E:
	lsl.w	#3,d1
	move.b	(a0)+,d1
	move.w	d1,d6
	and.w	d4,d6
	move.b	(a1)+,d6
	suba.l	d6,a6
	add.b	d1,d1
	bcs.s	loc_13864
	add.b	d1,d1
	bcs.s	loc_1387A
	bra.s	loc_1387C
; ---------------------------------------------------------------------------

loc_13864:
	add.b	d1,d1
	bcc.s	loc_13878
	moveq	#0,d0
	move.b	(a1)+,d0
	beq.s	loc_1388A
	subq.w	#6,d0
	bmi.s	loc_13890

loc_13872:
	move.b	(a6)+,(a2)+
	dbf	d0,loc_13872

loc_13878:
	move.b	(a6)+,(a2)+

loc_1387A:
	move.b	(a6)+,(a2)+

loc_1387C:
	move.b	(a6)+,(a2)+
	move.b	(a6)+,(a2)+
	move.b	(a6)+,(a2)+
	cmp.w	a2,d7
	bls.s	loc_138A0
	bra.w	loc_137B0
; ---------------------------------------------------------------------------

loc_1388A:
	moveq	#0,d0 ; changed from move.w to moveq, saves 4 cycles.
	rts
; ---------------------------------------------------------------------------

loc_13890:
	move.w	#$FFFF,d0
	moveq	#6,d2
	rts
; ---------------------------------------------------------------------------

loc_13898:
	moveq	#1,d0 ; changed from move.w to moveq, saves 4 cycles.
	moveq	#2,d2
	rts
; ---------------------------------------------------------------------------

loc_138A0:
	moveq	#1,d0 ; changed from move.w to moveq, saves 4 cycles.
	moveq	#6,d2
	rts
; ---------------------------------------------------------------------------

loc_138A8:
	move.b	(a1)+,(a2)+

loc_138AA:
	add.b	d1,d1
	bcs.s	loc_13926
	move.l	a2,a6
	add.b	d1,d1
	bcs.s	loc_138CA
	move.b	(a1)+,d5
	suba.l	d5,a6
	add.b	d1,d1
	bcc.s	loc_138BE
	move.b	(a6)+,(a2)+

loc_138BE:
	move.b	(a6)+,(a2)+
	move.b	(a6)+,(a2)+
	cmp.w	a2,d7
	bls.s	loc_13916
	bra.w	loc_13A24
; ---------------------------------------------------------------------------

loc_138CA:
	lsl.w	#2,d1
	move.b	(a0)+,d1
	add.w	d1,d1
	move.w	d1,d6
	and.w	d4,d6
	move.b	(a1)+,d6
	suba.l	d6,a6
	add.b	d1,d1
	bcs.s	loc_138E2
	add.b	d1,d1
	bcs.s	loc_138F8
	bra.s	loc_138FA
; ---------------------------------------------------------------------------

loc_138E2:
	add.b	d1,d1
	bcc.s	loc_138F6
	moveq	#0,d0
	move.b	(a1)+,d0
	beq.s	loc_13908
	subq.w	#6,d0
	bmi.s	loc_1390E

loc_138F0:
	move.b	(a6)+,(a2)+
	dbf	d0,loc_138F0

loc_138F6:
	move.b	(a6)+,(a2)+

loc_138F8:
	move.b	(a6)+,(a2)+

loc_138FA:
	move.b	(a6)+,(a2)+
	move.b	(a6)+,(a2)+
	move.b	(a6)+,(a2)+
	cmp.w	a2,d7
	bls.s	loc_1391E
	bra.w	loc_1382E
; ---------------------------------------------------------------------------

loc_13908:
	moveq	#0,d0 ; changed from move.w to moveq, saves 4 cycles.
	rts
; ---------------------------------------------------------------------------

loc_1390E:
	move.w	#$FFFF,d0
	moveq	#5,d2
	rts
; ---------------------------------------------------------------------------

loc_13916:
	moveq	#1,d0 ; changed from move.w to moveq, saves 4 cycles.
	moveq	#1,d2
	rts
; ---------------------------------------------------------------------------

loc_1391E:
	moveq	#1,d0 ; changed from move.w to moveq, saves 4 cycles.
	moveq	#5,d2
	rts
; ---------------------------------------------------------------------------

loc_13926:
	move.b	(a1)+,(a2)+

loc_13928:
	add.b	d1,d1
	bcs.s	loc_139A4
	move.l	a2,a6
	add.b	d1,d1
	bcs.s	loc_13948
	move.b	(a1)+,d5
	suba.l	d5,a6
	add.b	d1,d1
	bcc.s	loc_1393C
	move.b	(a6)+,(a2)+

loc_1393C:
	move.b	(a6)+,(a2)+
	move.b	(a6)+,(a2)+
	cmp.w	a2,d7
	bls.s	loc_13994
	bra.w	Decompress_BitPos0
; ---------------------------------------------------------------------------

loc_13948:
	add.w	d1,d1
	move.b	(a0)+,d1
	lsl.w	#2,d1
	move.w	d1,d6
	and.w	d4,d6
	move.b	(a1)+,d6
	suba.l	d6,a6
	add.b	d1,d1
	bcs.s	loc_13960
	add.b	d1,d1
	bcs.s	loc_13976
	bra.s	loc_13978
; ---------------------------------------------------------------------------

loc_13960:
	add.b	d1,d1
	bcc.s	loc_13974
	moveq	#0,d0
	move.b	(a1)+,d0
	beq.s	loc_13986
	subq.w	#6,d0
	bmi.s	loc_1398C

loc_1396E:
	move.b	(a6)+,(a2)+
	dbf	d0,loc_1396E

loc_13974:
	move.b	(a6)+,(a2)+

loc_13976:
	move.b	(a6)+,(a2)+

loc_13978:
	move.b	(a6)+,(a2)+
	move.b	(a6)+,(a2)+
	move.b	(a6)+,(a2)+
	cmp.w	a2,d7
	bls.s	loc_1399C
	bra.w	loc_138AA
; ---------------------------------------------------------------------------

loc_13986:
	moveq	#0,d0 ; changed from move.w to moveq, saves 4 cycles.
	rts
; ---------------------------------------------------------------------------

loc_1398C:
	move.w	#$FFFF,d0
	moveq	#4,d2
	rts
; ---------------------------------------------------------------------------

loc_13994:
	moveq	#1,d0 ; changed from move.w to moveq, saves 4 cycles.
	moveq	#8,d2
	rts
; ---------------------------------------------------------------------------

loc_1399C:
	moveq	#1,d0 ; changed from move.w to moveq, saves 4 cycles.
	moveq	#4,d2
	rts
; ---------------------------------------------------------------------------

loc_139A4:
	move.b	(a1)+,(a2)+

loc_139A6:
	add.b	d1,d1
	bcs.s	loc_13A22
	move.l	a2,a6
	add.b	d1,d1
	bcs.s	loc_139C8
	move.b	(a0)+,d1
	move.b	(a1)+,d5
	suba.l	d5,a6
	add.b	d1,d1
	bcc.s	loc_139BC
	move.b	(a6)+,(a2)+

loc_139BC:
	move.b	(a6)+,(a2)+
	move.b	(a6)+,(a2)+
	cmp.w	a2,d7
	bls.s	loc_13A12
	bra.w	loc_13736
; ---------------------------------------------------------------------------

loc_139C8:
	move.b	(a0)+,d1
	lsl.w	#3,d1
	move.w	d1,d6
	and.w	d4,d6
	move.b	(a1)+,d6
	suba.l	d6,a6
	add.b	d1,d1
	bcs.s	loc_139DE
	add.b	d1,d1
	bcs.s	loc_139F4
	bra.s	loc_139F6
; ---------------------------------------------------------------------------

loc_139DE:
	add.b	d1,d1
	bcc.s	loc_139F2
	moveq	#0,d0
	move.b	(a1)+,d0
	beq.s	loc_13A04
	subq.w	#6,d0
	bmi.s	loc_13A0A

loc_139EC:
	move.b	(a6)+,(a2)+
	dbf	d0,loc_139EC

loc_139F2:
	move.b	(a6)+,(a2)+

loc_139F4:
	move.b	(a6)+,(a2)+

loc_139F6:
	move.b	(a6)+,(a2)+
	move.b	(a6)+,(a2)+
	move.b	(a6)+,(a2)+
	cmp.w	a2,d7
	bls.s	loc_13A1A
	bra.w	loc_13928
; ---------------------------------------------------------------------------

loc_13A04:
	moveq	#0,d0 ; changed from move.w to moveq, saves 4 cycles.
	rts
; ---------------------------------------------------------------------------

loc_13A0A:
	move.w	#$FFFF,d0
	moveq	#3,d2
	rts
; ---------------------------------------------------------------------------

loc_13A12:
	moveq	#1,d0 ; changed from move.w to moveq, saves 4 cycles.
	moveq	#7,d2
	rts
; ---------------------------------------------------------------------------

loc_13A1A:
	moveq	#1,d0 ; changed from move.w to moveq, saves 4 cycles.
	moveq	#3,d2
	rts
; ---------------------------------------------------------------------------

loc_13A22:
	move.b	(a1)+,(a2)+

loc_13A24:
	add.b	d1,d1
	bcs.s	loc_13A9E
	move.b	(a0)+,d1
	move.l	a2,a6
	add.b	d1,d1
	bcs.s	loc_13A46
	move.b	(a1)+,d5
	suba.l	d5,a6
	add.b	d1,d1
	bcc.s	loc_13A3A
	move.b	(a6)+,(a2)+

loc_13A3A:
	move.b	(a6)+,(a2)+
	move.b	(a6)+,(a2)+
	cmp.w	a2,d7
	bls.s	loc_13A8E
	bra.w	loc_137B0
; ---------------------------------------------------------------------------

loc_13A46:
	lsl.w	#3,d1
	move.w	d1,d6
	and.w	d4,d6
	move.b	(a1)+,d6
	suba.l	d6,a6
	add.b	d1,d1
	bcs.s	loc_13A5A
	add.b	d1,d1
	bcs.s	loc_13A70
	bra.s	loc_13A72
; ---------------------------------------------------------------------------

loc_13A5A:
	add.b	d1,d1
	bcc.s	loc_13A6E
	moveq	#0,d0
	move.b	(a1)+,d0
	beq.s	loc_13A80
	subq.w	#6,d0
	bmi.s	loc_13A86

loc_13A68:
	move.b	(a6)+,(a2)+
	dbf	d0,loc_13A68

loc_13A6E:
	move.b	(a6)+,(a2)+

loc_13A70:
	move.b	(a6)+,(a2)+

loc_13A72:
	move.b	(a6)+,(a2)+
	move.b	(a6)+,(a2)+
	move.b	(a6)+,(a2)+
	cmp.w	a2,d7
	bls.s	loc_13A96
	bra.w	loc_139A6
; ---------------------------------------------------------------------------

loc_13A80:
	moveq	#0,d0 ; changed from move.w to moveq, saves 4 cycles.
	rts
; ---------------------------------------------------------------------------

loc_13A86:
	move.w	#$FFFF,d0
	moveq	#2,d2
	rts
; ---------------------------------------------------------------------------

loc_13A8E:
	moveq	#1,d0 ; changed from move.w to moveq, saves 4 cycles.
	moveq	#6,d2
	rts
; ---------------------------------------------------------------------------

loc_13A96:
	moveq	#1,d0 ; changed from move.w to moveq, saves 4 cycles.
	moveq	#2,d2
	rts
; ---------------------------------------------------------------------------

loc_13A9E:
	move.b	(a1)+,(a2)+
	bra.w	Decompress_BitPos0
; End of function Decompress_Chunk