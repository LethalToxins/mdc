; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR j_LoadGameModeData

DecompressToRAM_Special:
	lea	Palette_Permutation_unknown(pc),a3
; END OF FUNCTION CHUNK	FOR j_LoadGameModeData

; =============== S U B	R O U T	I N E =======================================


DecompressToRAM:
	bsr.w	sub_142CC
	lea	($FFFF0280).l,a4
	moveq	#0,d3

loc_143CC:
	moveq	#0,d4

loc_143CE:
	move.b	(a3,d3.w),d5
	lsl.b	#4,d5
	or.b	(a3,d4.w),d5
	move.b	d5,(a4)+
	addq.w	#1,d4
	cmpi.w	#$10,d4
	bne.s	loc_143CE
	addq.w	#1,d3
	cmpi.w	#$10,d3
	bne.s	loc_143CC

loc_143EA:
	moveq	#-1,d0
	move.l	d0,a3
	move.l	a2,a4
	bsr.w	Decompress_Chunk
	lea	($C00000).l,a6
	move.l	a2,d3
	sub.l	a4,d3
	lsr.w	#1,d3
	subq.w	#1,d3
	lea	($FFFF0280).l,a3
	moveq	#0,d5

loc_1440A:
	move.b	(a4)+,d5
	move.b	(a3,d5.w),d6
	lsl.w	#8,d6
	move.b	(a4)+,d5
	move.b	(a3,d5.w),d6
	move.w	d6,(a6)
	dbf	d3,loc_1440A
	tst.w	d0
	beq.s	return_14438
	lea	(Decompression_Buffer).l,a2
	lea	$800(a2),a4
	move.w	#$1FF,d3

loc_14430:
	move.l	(a4)+,(a2)+
	dbf	d3,loc_14430
	bra.s	loc_143EA
; ---------------------------------------------------------------------------

return_14438:
	rts
; End of function DecompressToRAM