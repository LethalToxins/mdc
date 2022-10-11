; =============== S U B	R O U T	I N E =======================================

; a0 - source address
; d0 - offset in VRAM (destination)

DecompressToVRAM:
				; Load_InGame+504p ...
	bsr.s	sub_142CC
	moveq	#-1,d0
	move.l	d0,a3	; end address beyond which to flush buffer

loc_14300:
	move.l	a2,a4		; a0 command array
				; a1 input array
				; a2 temp buffer
				; d2 bitpos (1 is lowest bit/last, 7 second highest, 0 highest)
	bsr.w	Decompress_Chunk
	lea	($C00000).l,a6
	move.l	a2,d3
	sub.l	a4,d3
	lsr.w	#1,d3
	subq.w	#1,d3

loc_14314:
	move.w	(a4)+,(a6)	; transfer data from buffer to VRAM
	dbf	d3,loc_14314
	tst.w	d0	; finished decompression?
	beq.s	return_14334
	; have to continue decompression but buffer is full
	lea	(Decompression_Buffer).l,a2
	lea	$800(a2),a4
	move.w	#$1FF,d3

loc_1432C:	; move second $800 bytes from buffer to first $800 bytes of buffer
	move.l	(a4)+,(a2)+
	dbf	d3,loc_1432C
	bra.s	loc_14300	; a0 command array
				; a1 input array
				; a2 temp buffer
				; d2 bitpos (1 is lowest bit/last, 7 second highest, 0 highest)
; ---------------------------------------------------------------------------

return_14334:
	rts
; End of function DecompressToVRAM

; =============== S U B	R O U T	I N E =======================================


DecompressToVRAM_Special:
	move.l	a1,-(sp)
	bsr.s	sub_142CC
	lea	($FFFF0280).l,a4
	moveq	#0,d3

loc_14348:
	moveq	#0,d4

loc_1434A:
	move.b	(a3,d3.w),d5
	lsl.b	#4,d5
	or.b	(a3,d4.w),d5
	move.b	d5,(a4)+
	addq.w	#1,d4
	cmpi.w	#$10,d4
	bne.s	loc_1434A
	addq.w	#1,d3
	cmpi.w	#$10,d3
	bne.s	loc_14348

loc_14366:
	moveq	#-1,d0
	move.l	d0,a3
	move.l	a2,a4
	bsr.w	Decompress_Chunk
	move.l	a2,d3
	sub.l	a4,d3
	lsr.w	#1,d3
	subq.w	#1,d3
	lea	($FFFF0280).l,a3
	moveq	#0,d5
	move.l	(sp)+,a6

loc_14382:
	move.b	(a4)+,d5
	move.b	(a3,d5.w),d6
	lsl.w	#8,d6
	move.b	(a4)+,d5
	move.b	(a3,d5.w),d6
	move.w	d6,(a6)+
	dbf	d3,loc_14382
	move.l	a6,-(sp)
	tst.w	d0
	beq.s	loc_143B2
	lea	(Decompression_Buffer).l,a2
	lea	$800(a2),a4
	move.w	#$1FF,d3

loc_143AA:
	move.l	(a4)+,(a2)+
	dbf	d3,loc_143AA
	bra.s	loc_14366
; ---------------------------------------------------------------------------

loc_143B2:
	move.l	(sp)+,a1
	lea	($C00000).l,a6
	rts
; End of function DecompressToVRAM_Special