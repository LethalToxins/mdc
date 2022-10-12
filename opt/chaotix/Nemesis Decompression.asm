; =============== S U B R O U T I N E =======================================


NemDec:                                 ; CODE XREF: sub_74CBA+1E↓p
                lea     sub_749B8(pc),a3
                lea     ($C00000).l,a4
                bra.s   loc_7493A
; ---------------------------------------------------------------------------
                lea     sub_749CE(pc),a3

loc_7493A:                              ; CODE XREF: NemDec+A↑j
                lea     ($FFDD56).w,a1
                move.w  (a0)+,d2
                bpl.s   loc_74946
                adda.w  #$A,a3

loc_74946:                              ; CODE XREF: NemDec+16↑j
                lsl.w   #3,d2
                movea.w d2,a5
                moveq   #8,d3
                moveq   #0,d2
                bsr.w   sub_749E4
                move.b  (a0)+,d5
                asl.w   #8,d5
                move.b  (a0)+,d5
                moveq   #$10,d6

loc_7495A:                              ; CODE XREF: NemDec+72↓j
                move.b  d6,d7
                subq.b  #8,d7
                move.w  d5,d1
                lsr.w   d7,d1
                cmpi.b  #$FC,d1
                bcc.s   loc_7499E
                andi.w  #$FF,d1
                add.w   d1,d1
                sub.b   (a1,d1.w),d6
                moveq   #0,d0
                move.b  1(a1,d1.w),d0

loc_74978:                              ; CODE XREF: NemDec+8C↓j
                cmpi.b  #9,d6
                bcc.s   loc_74984
                addq.b  #8,d6
                asl.w   #8,d5
                move.b  (a0)+,d5

loc_74984:                              ; CODE XREF: NemDec+52↑j
                moveq   #$F,d1
                and.w   d0,d1
                lsr.w   #4,d0

loc_7498A:                              ; CODE XREF: NemDec:loc_74998↓j
                lsl.l   #4,d4
                or.b    d1,d4
                subq.w  #1,d3
                bne.s   loc_74998
                jmp     (a3)
; ---------------------------------------------------------------------------

loc_74994:                              ; CODE XREF: sub_749B8+6↓j
                                        ; sub_749C2+8↓j ...
                moveq   #0,d4
                moveq   #8,d3

loc_74998:                              ; CODE XREF: NemDec+66↑j
                dbf     d0,loc_7498A
                bra.s   loc_7495A
; ---------------------------------------------------------------------------

loc_7499E:                              ; CODE XREF: NemDec+3C↑j
                cmpi.b  #$F,d6
                bcc.s   loc_749AA
                addq.b  #8,d6
                asl.w   #8,d5
                move.b  (a0)+,d5

loc_749AA:                              ; CODE XREF: NemDec+78↑j
                subi.b  #$D,d6
                move.w  d5,d1
                lsr.w   d6,d1
                moveq   #$7F,d0
                and.w   d1,d0
                bra.s   loc_74978
; End of function NemDec


; =============== S U B R O U T I N E =======================================


sub_749B8:
                move.l  d4,(a4)
                subq.w  #1,a5
                move.w  a5,d4
                bne.s   loc_74994
                rts
; End of function sub_749B8


; =============== S U B R O U T I N E =======================================


sub_749C2:
                eor.l   d4,d2
                move.l  d2,(a4)
                subq.w  #1,a5
                move.w  a5,d4
                bne.s   loc_74994
                rts
; End of function sub_749C2


; =============== S U B R O U T I N E =======================================


sub_749CE:
                move.l  d4,(a4)+
                subq.w  #1,a5
                move.w  a5,d4
                bne.s   loc_74994
                rts
; End of function sub_749CE


; =============== S U B R O U T I N E =======================================


sub_749D8:
                eor.l   d4,d2
                move.l  d2,(a4)+
                subq.w  #1,a5
                move.w  a5,d4
                bne.s   loc_74994
                rts
; End of function sub_749D8


; =============== S U B R O U T I N E =======================================


sub_749E4:                              ; CODE XREF: NemDec+24↑p
                                        ; sub_74B5C+28↓p ...
                move.b  (a0)+,d0

loc_749E6:                              ; CODE XREF: sub_749E4+E↓j
                cmpi.b  #$FF,d0
                bne.s   loc_749EE
                rts
; ---------------------------------------------------------------------------

loc_749EE:                              ; CODE XREF: sub_749E4+6↑j
                move.b  d0,d7

loc_749F0:                              ; CODE XREF: sub_749E4+38↓j
                move.b  (a0)+,d0
                bmi.s   loc_749E6
                moveq   #$F,d1
                and.w   d1,d7
                and.w   d0,d1
                ext.w   d0
                add.w   d0,d0
                or.w    byte_74A1E(pc,d0.w),d7
                subq.w  #8,d1
                neg.w   d1
                move.b  (a0)+,d0
                lsl.w   d1,d0
                add.w   d0,d0
                moveq   #1,d5
                lsl.w   d1,d5
                subq.w  #1,d5

loc_74A12:                              ; CODE XREF: sub_749E4+34↓j
                move.w  d7,(a1,d0.w)
                addq.w  #2,d0
                dbf     d5,loc_74A12
                bra.s   loc_749F0
; End of function sub_749E4

; ---------------------------------------------------------------------------
byte_74A1E:     dc.b   0,  0,  1,  0,  2,  0,  3,  0,  4,  0,  5,  0,  6,  0,  7,  0
                                        ; DATA XREF: sub_749E4+1A↑r
                dc.b   8,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
                dc.b   0,$10,  1,$10,  2,$10,  3,$10,  4,$10,  5,$10,  6,$10,  7,$10
                dc.b   8,$10,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
                dc.b   0,$20,  1,$20,  2,$20,  3,$20,  4,$20,  5,$20,  6,$20,  7,$20
                dc.b   8,$20,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
                dc.b   0,$30,  1,$30,  2,$30,  3,$30,  4,$30,  5,$30,  6,$30,  7,$30
                dc.b   8,$30,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
                dc.b   0,$40,  1,$40,  2,$40,  3,$40,  4,$40,  5,$40,  6,$40,  7,$40
                dc.b   8,$40,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
                dc.b   0,$50,  1,$50,  2,$50,  3,$50,  4,$50,  5,$50,  6,$50,  7,$50
                dc.b   8,$50,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
                dc.b   0,$60,  1,$60,  2,$60,  3,$60,  4,$60,  5,$60,  6,$60,  7,$60
                dc.b   8,$60,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
                dc.b   0,$70,  1,$70,  2,$70,  3,$70,  4,$70,  5,$70,  6,$70,  7,$70
                dc.b   8,$70,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0