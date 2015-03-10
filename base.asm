section .data
digits: db  "0123456789",10
nl: db 0xA
n: dq 420

section .text
    global _start
_start:
        call main
;; exit
        mov     rdi,rax
        mov     rax,60
        syscall

equal:
        mov rax,[rsp+8*1]
        cmp rax,[rsp+8*2]
        setz al
        movzx eax, al
        ret

less_than:
        mov rax,[rsp+8*2]
        cmp rax,[rsp+8*1]
        setb al
        movzx eax, al
        ret
        
greater_than:
        mov rax,[rsp+8*2]
        cmp rax,[rsp+8*1]
        seta al
        movzx eax, al
        ret
        
less_than_equal:
        mov rax,[rsp+8*2]
        cmp rax,[rsp+8*1]
        setbe al
        movzx eax, al
        ret
        
greater_than_equal:
        mov rax,[rsp+8*2]
        cmp rax,[rsp+8*1]
        setae al
        movzx eax, al
        ret
        
plus:
        mov rax,[rsp+8*2]
        add rax,[rsp+8*1]
        ret

minus:
        mov rax,[rsp+8*2]
        sub rax,[rsp+8*1]
        ret
        
newline:
        mov rsi, nl             ; load char ptr
        mov rax, 1              ; write
        syscall
        ret
        
display:
        push 0
.decomp_loop:                    ; decompose number onto digits on stack
        test rax,rax
        jz .do_print             ; if 0; done, print out number

        mov rdx, 0
        mov rbx, 10
        div rbx                 ; rax / rbx; remainder in rdx
        
        add rdx, digits         ; calculate offset from 'digits'
        push rdx                ; push ptr of digit char
        jmp .decomp_loop
.do_print:
        ;; set up write args
        mov rdx, 1              ; length
        mov rdi, 1              ; fd
.print_loop:
        pop rax                 ; load char ptr from stack
        test rax,rax
        jz .print_end            ; go to end if end of string
        
        mov rsi, rax            ; load char ptr
        mov rax, 1              ; write
        syscall
       
        jmp .print_loop
.print_end:
        ret
