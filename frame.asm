model tiny

.code

org 100h

VIDEO_SEGMENT_ADR       equ 0b800h
FRAME_LENGTH            equ 30
FRAME_WIDTH             equ 8 

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

                        ;--------------text-----------------------

;                        add     di, (5 * 80 + 10) * WORD
;                        mov     bl, 2
;                        mov     ax, di
;                        div     bl
;                        
;
;
;                        
;                        
;                        xor     ax, ax
;                        xor     cx, cx
;                        
;                        mov     si, offset text
;                        jmp     string_lenth
;
;ready_length:
;                        mov     al, cl
;                        mov     dl, 2
;                        div     dl
;                        sub     di, ax
;                        
;                        xor     ax, ax
;                    
;                        mov     ah, 52
;                        mov     si, offset text
;                        
;                        add     di, (5 * 80 + 10) * WORD
;
;                        call    draw_text
;
;                        ;--------------text-----------------------

                        mov     si, offset text
                        
string_lenth:           lodsb
                        cmp     al, 0
                        je      ready_length
                        inc     cl
                        jmp     string_lenth

ready_length:           mov     di, FRAME_LENGTH + FRAME_WIDTH * 80 + (5 * 80 + 10) * WORD
                        sub     di, cx                        

                        mov     si, offset text

                        call    draw_text

                        mov     ah, 4ch
                        int     21h


;----------------------------------------------
; Input:    di = begining of string
;           cx = strlen 
; Destroys: ah, cx, si, di 
; Returns:  cpy str 
;----------------------------------------------
draw_text               proc

                        lodsb
                        stosw
                        
                        loop    draw_text   
                        
                        ret
                        endp

first_and_last_line     proc
                        
                        mov     ah, 52
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
text                    db      "edik pidr"

end start