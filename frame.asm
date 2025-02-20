model tiny

.code

org 100h

VIDEO_SEGMENT_ADR       equ 0b800h
FRAME_LENGTH            equ 8
FRAME_WIDTH             equ 4 

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
                        
                        mov     di, (5 * 80 + 10) * WORD + 80 * FRAME_WIDTH * WORD
                        mov     ah, 09h
                        mov     dx, offset text
                        int     21h

                        mov     ah, 4ch
                        int     21h

first_and_last_line     proc
                        
                        mov     ah, 52
                        lodsb 
                        repne   stosw

                        ret
                        endp

draw_line               proc

                        mov     ah, 52                
                        lodsb
                        stosw

                        sub     cx, 2
                        mov     ah, 1
                        lodsb
                        repne   stosw

                        mov     ah, 52                
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
text                    db      "edik pidr$"

end start