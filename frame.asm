model tiny

.code

locals 

org 100h

VIDEO_SEGMENT_ADR       equ 0b800h
FRAME_LENGTH            equ 30
FRAME_WIDTH             equ 8
FRAME_COLOR             equ 52
TEXT_COLOR              equ 11011010b

start:                  push    VIDEO_SEGMENT_ADR
                        pop     es

                        mov     di, (5 * 80 + 10) * WORD

                        mov     si, offset frame_template
                        mov     cx, FRAME_LENGTH

                        call    first_and_last_line

                        add     di, 160 - FRAME_LENGTH * WORD

                        mov     si, offset frame_template
                        mov     cx, FRAME_LENGTH

                        mov     bx, FRAME_WIDTH - 2
                        call    draw_line

                        ;mov     word ptr es:[di], 5221h
                        ;mov     ax, 5221h
                        ;stosw

                        mov     si, offset frame_template
                        mov     cx, FRAME_LENGTH
                        call    first_and_last_line

                        mov     si, offset text

string_lenth:           lodsb
                        cmp     al, 0
                        je      ready_length
                        inc     cx
                        jmp     string_lenth

ready_length:           mov     si, offset text
                        mov     di, FRAME_LENGTH + FRAME_WIDTH * 80 + (5 * 80 + 10) * WORD

                        ;mov     cx, str_length

                        cmp     cx, 1
                        je      @@one_symbol

                        ;sub     di, str_length      ; не делю на 2, тк клеточка - 2 байта
                        
                        mov     bl, cl
                        and     bl, 1       ;оставляем последний бит 
                        
                        and     cl, 0feh
                        ;shr     cl, 1      ;альтернативный способ стереть последний бит
                        ;shl     cl, 1
                        sub     di, cx

                        or      cl, bl
                        mov     ah, TEXT_COLOR

@@one_symbol:
                        call    draw_text

                        mov     ah, 4ch
                        int     21h
;----------------------------------------------
; Input:    di = begining of string
;           cx = strlen
; Destroys: ah, cx, si, di
; Returns:  nothing
;----------------------------------------------
draw_text               proc

                        lodsb
                        stosw

                        loop    draw_text

                        ret
                        endp
;----------------------------------------------
; Input:    di = begining of the frame
;           cx = frame length
;           si = ptr on symbol
; Destroys: ah, cx, si, di
; Returns:  output first and last row of frame
;----------------------------------------------
first_and_last_line     proc

                        mov     ah, FRAME_COLOR
                        lodsb
                        repne   stosw

                        ret
                        endp
;----------------------------------------------
; Input:    di = begining of the frame
;           cx = frame length
;           bx = frame width
; Destroys: ah, cx, si, di, bx
; Returns:  output row of frame
;----------------------------------------------
draw_line               proc

                        mov     ah, FRAME_COLOR
                        lodsb
                        stosw

                        sub     cx, 2
                        mov     ah, 1
                        lodsb
                        repne   stosw

                        mov     ah, FRAME_COLOR
                        lodsb
                        stosw

                        mov     si, offset frame_template
                        mov     cx, FRAME_LENGTH

                        add     di, 160 - FRAME_LENGTH * WORD

                        dec     bx
                        cmp     bx, 0
                        jne     draw_line

                        ret
                        endp
.data
                        
frame_template          db      3,32,3
text                    db      "POLINA SOLNYSHKO!!!", 0
str_length              equ $-text
end start
