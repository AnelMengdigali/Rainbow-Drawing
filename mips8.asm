.data

DISPLAY: .space 16384 # 64*64*4
DISPLAYWIDTH: .word 64
DISPLAYHEIGHT: .word 64

ArrColors: .word 0x00FF0000 0x00FFFFFF 0x000000FF 0x0000FF00 0x00FFFF00 0x0000FFFF 0x00FF00FF 0x00008080 0x00000080 0x00800000

.text

main:	

	la $s0, ArrColors
		
	li $a2, 16 #r
	li $a0, 0 #x
	li $a1, 0 #y
	
	li $s5, 6 #limit
		
	Loop1: 
		move $t6, $a2
		lw $t2, 0($s0)
		move $a3, $t2 
		addi $t6, $t6, -1
		move $a2, $t6
		beq $a2, $s5, Exit1
		jal circleRainbow
			
		add $s0, $s0, 4
		j Loop1
		
		Exit1:
			li $v0, 10
			syscall
	
	circleRainbow:
	
		li $a0, 0
		li $a1, 0
		move $t5, $a2
		addi $t7, $t5, 1
		move $s3, $a1
		move $t4, $a0	
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		
		Loop2:
	
			mul $s1, $t5, $t5 #r^2
			mul $s2, $t4, $t4 #x^2
			sub $s1, $s1, $s2 #r^2-x^2 
			
			mtc1 $s1, $f1
			cvt.s.w $f1, $f1 
			sqrt.s $f0, $f1
			cvt.w.s $f0, $f0
			mfc1 $s1, $f0
			
			sub $s4, $s3, $s1
				
			add $a0, $t4, 32
			add $a1, $s1, 32
			jal set_pixel_color
			
			mul $t4, $t4, -1
			add $a0, $t4, 32
			jal set_pixel_color
				
			mul $t4, $t4, -1
			add $a0, $t4, 32
			add $a1, $s4, 32
			jal set_pixel_color
			
			mul $t4, $t4, -1
			add $a0, $t4, 32
			jal set_pixel_color
		
			mul $t4, $t4, -1
			addi $t4, $t4, 1
			
			beq $t4, $t7, Exit2
			j Loop2
					
			Exit2:
				lw $ra, 0($sp)
				addi $sp, $sp, 4
				jr $ra
				
		
	set_pixel_color:
	
		lw $t0, DISPLAYWIDTH
		mul $t0, $t0, $a1 
		add $t0, $t0, $a0 
		sll $t0, $t0, 2 
		la $t1, DISPLAY 
		add $t1, $t1, $t0 
		sw $a3, 0($t1) 
		jr $ra
	
	