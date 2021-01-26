.data 
DISPLAY:
    .space 16384
END_OF_DISPLAY:
.text

main: 
la $t9, DISPLAY
addi $t0, $zero, 0x079b39
addi $t1, $zero, 0x5789e8
add $t2, $zero, 0xfffff0
jal paintWhite
jal cover
la $t9, DISPLAY
addi $t9, $t9, 528
nameLoop:
   addi $t1, $zero, 0xf5a41e
   jal checkName
   j nameLoop
returnStopName:
mLoop:
addi $k0, $k0, 0
jal checkInput
j mLoop


run:
la $t9, DISPLAY
la $s1, ($t9)
addi $k0, $k0, 0
   
   jal paintWhite
   jal platform
   
   addi $t3, $zero, 15  
    add $t4, $zero, $zero
 mainLoop: 
    jal drawPlatform  
    
  Loop1:
    beq $t4, $t3, LoopDone1
    add $s7, $zero, $t9 
    addi $t9, $t9, -128
    jal checkInput
    jal eraseDoodler
    jal drawDoodler
    jal drawPlatform
    
    addi $v0, $zero, 32
    addi $a0, $zero, 75
    syscall
    addi $t4, $t4, 1
    
j Loop1
LoopDone1:
    add $t4, $zero, $zero
    
    
  Loop2:  
    blt $s1, $t9, mainLoopDone 
    lw $t5, 4296($t9)
    beq $t5, $t0, LoopDone2
    lw $t5, 4300($t9)
    beq $t5, $t0, LoopDone2
    lw $t5, 4308($t9)
    beq $t5, $t0, LoopDone2
    
    add $s7, $zero, $t9
    
    jal checkInput
    jal eraseDoodler	
    addi $t9, $t9, 128

    jal drawDoodler
    
    
    addi $t4, $t4, 1
    
    jal drawPlatform
    addi $v0, $zero, 32
    addi $a0, $zero, 75
    syscall
    j Loop2
LoopDone2:
    addi $t3, $zero, 15  
    add $t4, $zero, $zero
    addi $t9, $t9, 1000
    bge $s1, $t9, moveDown
    returnMoveDown:
    addi $t9, $t9, -1000
    
    j mainLoop
    mainLoopDone:
    jal paintWhite
    addi $v0, $zero, 32
    addi $a0, $zero, 75
    syscall
    jal showScore

    
moveDown:
    add $s3, $zero, $t9
    la $t9, DISPLAY
    addi $t9, $t9, -776
    addi $t4, $t4, 3
    div $k0, $t4
    mfhi $t3
    beq $t3, 0, notifications
    returnNotifications:
    add $t9, $zero, $s3
    
    addi $k0, $k0, 1
    addi $t3, $zero, 11 
    add $t4, $zero, $zero
    downLoop: 
    beq $t4, $t3, downDone
    addi $v0, $zero, 32
    addi $a0, $zero, 75
    syscall 
    ble $t4, 10, moveDisplay
    returnMoveDisplay:
    beq $t4, 8, newPlatform
    returnNewPlatform:
    addi $t4, $t4, 1
    
    j downLoop
    downDone:
    jal eraseNotifications
    addi $t3, $zero, 3
    add $t4, $zero, $zero
    j returnMoveDown


moveDisplay:
    jal erasePlatform
    addi $s1, $s1, 128
    jal drawPlatform
    addi $t9, $t9, -1000
    la $s7, ($t9)
    jal eraseDoodler
    jal checkInput
    jal drawDoodler
    addi $t9, $t9, 1000
    j returnMoveDisplay
  
newPlatform:
    jal erasePlatform
   
    addi $v0, $zero, 42
    addi $a1, $zero, 24
    syscall
    mul $a0, $a0, 4
    
    add $s6, $zero, $s5 
    add $s5, $zero, $s4
    add $s4, $zero, $a0
    
    addi $s1, $s1, -1408
    
    jal drawPlatform
    
    j returnNewPlatform
       


.globl paintWhite    
paintWhite:
   la $s1, 0($t9)
   add $t7, $zero, $zero
   addi $t6, $zero, 1024
   
   paintLoop:
   beq $t7, $t6, paintLoopDone
   sw $t2, 0($t9)
   addi $t9, $t9, 4
   addi $t7, $t7, 1
   j paintLoop
   paintLoopDone:
   addi $t9, $t9, -4096
   jr $ra

                
.globl checkInput
checkInput:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    lw $t8, 0xffff0000
    beq $t8, 1, key_press
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    


key_press:
    lw $t5, 0xffff0004
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    beq $t5, 0x6a, respond_to_j
    beq $t5, 0x6b, respond_to_k
    beq $t5, 0x73, run
    beq $t5, 0x20, exit
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
exit:  
    la $t9, DISPLAY
    jal paintWhite
    la $t1, 0x07851c
    addi $t9, $t9, 800
    jal drawB
    addi $t9, $t9, 16
    jal drawY
    addi $t9, $t9, 16
    jal drawE
    li $v0, 10
    addi $t9, $t9, -1500
    la $t1, 0xfc51ef
    jal drawStar
    addi $t9, $t9, 20
    la $t1, 0x82f7ed
    jal drawStar
    addi $t9, $t9, 332
    la $t1, 0xd6b2f7
    jal drawStar
    addi $t9, $t9, 80
    la $t1, 0xfc51ef
    jal drawStar
    addi $t9, $t9, 272
    la $t1, 0x82f7ed
    jal drawStar
    addi $t9, $t9, 1468
    la $t1, 0xfc51ef
    jal drawStar
    addi $t9, $t9, 152
    la $t1, 0xfaea2c
    jal drawStar
    addi $t9, $t9, 404
    la $t1, 0xd6b2f7
    jal drawStar
    addi $t9, $t9, 80
    la $t1, 0xfaea2c
    jal drawStar
    addi $t9, $t9, 204
    la $t1, 0xfc51ef
    jal drawStar
    addi $t9, $t9, 140
    la $t1, 0xfaea2c
    jal drawStar
    addi $t9, $t9, 160
    la $t1, 0x82f7ed
    jal drawStar
    
    syscall

respond_to_j:
    add $t9, $t9, -4
    jr $ra


respond_to_k:
    add $t9, $t9, 4
    jr $ra
    
 
 platform:
    addi $v0, $zero, 42
    addi $a1, $zero, 24
    syscall
    mul $a0, $a0, 4
    add $s4, $zero, $a0
    
    addi $v0, $zero, 42
    addi $a1, $zero, 24
    syscall
    mul $a0, $a0, 4
    add $s5, $zero, $a0
    
    addi $v0, $zero, 42
    addi $a1, $zero, 24
    syscall
    mul $a0, $a0, 4
    add $s6, $zero, $a0
    jr $ra
  
 onePlatform:
    la $t0, 0x76e85a
    sw $t0, 0($s1)
    sw $t0, 4($s1)
    sw $t0, 8($s1)
    sw $t0, 12($s1)
    sw $t0, 16($s1)
    sw $t0, 20($s1) 
    sw $t0, 24($s1)
    sw $t0, 28($s1)
    sw $t0, 32($s1)
    la $t0, 0x844928
    sw $t0, 136($s1)
    sw $t0, 140($s1)
    sw $t0, 144($s1)
    sw $t0, 148($s1) 
    sw $t0, 152($s1)
    la $t0, 0x76e85a
    jr $ra
    
 eraseOnePlatform:
    sw $t2, 0($s1)
    sw $t2, 4($s1)
    sw $t2, 8($s1)
    sw $t2, 12($s1)
    sw $t2, 16($s1)
    sw $t2, 20($s1) 
    sw $t2, 24($s1)
    sw $t2, 28($s1)
    sw $t2, 32($s1)
    sw $t2, 136($s1)
    sw $t2, 140($s1)
    sw $t2, 144($s1)
    sw $t2, 148($s1) 
    sw $t2, 152($s1)
    jr $ra
 
 drawPlatform:  
 addi $sp, $sp, -4
sw $ra, 0($sp)
    addi $s1, $s1, 896
    add $s1, $s1, $s4
    jal onePlatform
    sub $s1, $s1, $s4
 
    addi $s1, $s1, 1408
    add $s1, $s1, $s5
    jal onePlatform
    sub $s1, $s1, $s5
    
    addi $s1, $s1, 1408
    add $s1, $s1, $s6
    jal onePlatform
    sub $s1, $s1, $s6
    
    addi $s1, $s1, -3712
    lw $ra, 0($sp)
addi $sp, $sp, 4
    
    jr $ra
    

 erasePlatform: 
 addi $sp, $sp, -4
sw $ra, 0($sp)
    add $s1, $s1, 896
    add $s1, $s1, $s4
    jal eraseOnePlatform
    sub $s1, $s1, $s4
    
    add $s1, $s1, 1408
    add $s1, $s1, $s5
    jal eraseOnePlatform
    sub $s1, $s1, $s5
    
    add $s1, $s1, 1408
    add $s1, $s1, $s6
    jal eraseOnePlatform
    sub $s1, $s1, $s6
    
    add $s1, $s1, -3712
    lw $ra, 0($sp)
addi $sp, $sp, 4
    jr $ra
    
    

showScore:
la $t9, DISPLAY
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $t9, $t9, 512
jal drawScore
addi $t9, $t9, 896
addi $t4, $zero, 10
addi $t1, $zero, 0xf5a41e
loop:
div $k0, $t4
mfhi $t6
jal drawNumber
addi $t9, $t9, -16
sub $k0, $k0, $t6
beq $k0, $zero, loopEnd
div $k0, $k0, 10
j loop
loopEnd:
addi $t9, $t9, -2100
la $t1, 0xf43ef9
jal drawStar
addi $t9, $t9, 152
la $t1, 0xab51fc
jal drawStar
addi $t9, $t9, 184
la $t1, 0xa7fc51
jal drawStar
addi $t9, $t9, 2500
la $t1, 0xfa1710
jal drawStar
addi $t9, $t9, 200
la $t1, 0xab51fc
jal drawStar
addi $t9, $t9, 180
la $t1, 0xa7fc51
jal drawStar
addi $t9, $t9, 320
la $t1, 0x51f9fc
jal drawStar
lw $ra, 0($sp)
addi $sp, $sp, 4
j mLoop


drawStar:
    sw $t1, 784($t9)
    sw $t1, 912($t9)
    sw $t1, 1040($t9)
    sw $t1, 908($t9)
    sw $t1, 916($t9)
    jr $ra 




drawNumber:
beq $t6, 0, draw0
beq $t6, 1, draw1
beq $t6, 2, draw2
beq $t6, 3, draw3
beq $t6, 4, draw4
beq $t6, 5, draw5
beq $t6, 6, draw6
beq $t6, 7, draw7
beq $t6, 8, draw8
beq $t6, 9, draw9
returnDN:
jr $ra


drawScore:
la $t1, 0x07851c
addi $sp, $sp, -4
sw $ra, 0($sp)
    jal drawS
    addi $t9, $t9, 16

    jal drawC
    addi $t9, $t9, 16

    jal drawO
    addi $t9, $t9, 16

    jal drawR
    addi $t9, $t9, 16
    
    jal drawE
    
    addi $t9, $t9, 16
    sw $t1, 1036($t9)
    sw $t1, 1292($t9)
    
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra
    
 
drawA:
    sw $t1, 788($t9)
    sw $t1, 784($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 1036($t9)
    sw $t1, 1164($t9)
    sw $t1, 1292($t9)
    sw $t1, 1300($t9)
    sw $t1, 1172($t9)
    sw $t1, 1044($t9)
    sw $t1, 916($t9)
    sw $t1, 1040($t9)
    jr $ra 

drawB:
    sw $t1, 788($t9)
    sw $t1, 784($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 1036($t9)
    sw $t1, 1164($t9)
    sw $t1, 1292($t9)
    sw $t1, 1296($t9)
    sw $t1, 1300($t9)
    sw $t1, 1172($t9)
    sw $t1, 1044($t9)
    sw $t1, 916($t9)
    sw $t1, 1040($t9)
    jr $ra
 
drawC:
    sw $t1, 788($t9)
    sw $t1, 784($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 1036($t9)
    sw $t1, 1164($t9)
    sw $t1, 1292($t9)
    sw $t1, 1296($t9)
    sw $t1, 1300($t9)
    jr $ra
    
drawD:
    sw $t1, 788($t9)
    sw $t1, 784($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 1036($t9)
    sw $t1, 1164($t9)
    sw $t1, 1292($t9)
    sw $t1, 1296($t9)
    sw $t1, 1300($t9)
    sw $t1, 1172($t9)
    sw $t1, 1044($t9)
    sw $t1, 916($t9)
    jr $ra
 
drawE:
    sw $t1, 788($t9)
    sw $t1, 784($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 1036($t9)
    sw $t1, 1164($t9)
    sw $t1, 1292($t9)
    sw $t1, 1296($t9)
    sw $t1, 1300($t9)
    sw $t1, 1044($t9)
    sw $t1, 1040($t9)
    jr $ra
    
 drawF:
    sw $t1, 788($t9)
    sw $t1, 784($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 1036($t9)
    sw $t1, 1164($t9)
    sw $t1, 1292($t9)
    sw $t1, 1044($t9)
    sw $t1, 1040($t9)
    jr $ra
    
 drawG:
    sw $t1, 788($t9)
    sw $t1, 784($t9)
    sw $t1, 908($t9)
    sw $t1, 1036($t9)
    sw $t1, 1164($t9)
    sw $t1, 1296($t9)
    sw $t1, 1300($t9)
    sw $t1, 1172($t9)
    sw $t1, 1044($t9)
    sw $t1, 1040($t9)
    jr $ra
  
  drawH:
    sw $t1, 788($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 1036($t9)
    sw $t1, 1164($t9)
    sw $t1, 1292($t9)
    sw $t1, 1300($t9)
    sw $t1, 1172($t9)
    sw $t1, 1044($t9)
    sw $t1, 916($t9)
    sw $t1, 1040($t9)
    jr $ra
    
  drawI:
    sw $t1, 788($t9)
    sw $t1, 784($t9)
    sw $t1, 780($t9)
    sw $t1, 912($t9)
    sw $t1, 1040($t9)
    sw $t1, 1168($t9)
    sw $t1, 1292($t9)
    sw $t1, 1296($t9)
    sw $t1, 1300($t9)
    jr $ra
  
  drawJ:
    sw $t1, 788($t9)
    sw $t1, 784($t9)
    sw $t1, 780($t9)
    sw $t1, 912($t9)
    sw $t1, 1040($t9)
    sw $t1, 1168($t9)
    sw $t1, 1292($t9)
    sw $t1, 1296($t9)
    jr $ra
    
  drawK:
    sw $t1, 788($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 1036($t9)
    sw $t1, 1164($t9)
    sw $t1, 1292($t9)
    sw $t1, 1300($t9)
    sw $t1, 1168($t9)
    sw $t1, 912($t9)
    jr $ra
    
  drawL:
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 1036($t9)
    sw $t1, 1164($t9)
    sw $t1, 1292($t9)
    sw $t1, 1296($t9)
    sw $t1, 1300($t9)
    jr $ra 
    
  drawM:
    sw $t1, 788($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 912($t9)
    sw $t1, 1036($t9)
    sw $t1, 1164($t9)
    sw $t1, 1292($t9)
    sw $t1, 1300($t9)
    sw $t1, 1172($t9)
    sw $t1, 1044($t9)
    sw $t1, 916($t9)
    sw $t1, 1040($t9)
    
    jr $ra
    
  drawN:
    sw $t1, 788($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 912($t9)
    sw $t1, 1036($t9)
    sw $t1, 1164($t9)
    sw $t1, 1168($t9)
    sw $t1, 1292($t9)
    sw $t1, 1300($t9)
    sw $t1, 1172($t9)
    sw $t1, 1044($t9)
    sw $t1, 916($t9)
    sw $t1, 1040($t9)
    
    jr $ra
    
  drawO:
    sw $t1, 788($t9)
    sw $t1, 784($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 1036($t9)
    sw $t1, 1164($t9)
    sw $t1, 1292($t9)
    sw $t1, 1296($t9)
    sw $t1, 1300($t9)
    sw $t1, 1172($t9)
    sw $t1, 1044($t9)
    sw $t1, 916($t9)
    jr $ra
    
  drawP:
    sw $t1, 788($t9)
    sw $t1, 784($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 1036($t9)
    sw $t1, 1164($t9)
    sw $t1, 1292($t9)
    sw $t1, 1044($t9)
    sw $t1, 916($t9)
    sw $t1, 1040($t9)
    jr $ra
    
  drawQ:
    sw $t1, 788($t9)
    sw $t1, 784($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 1036($t9)
    sw $t1, 1164($t9)
    sw $t1, 1300($t9)
    sw $t1, 1172($t9)
    sw $t1, 1044($t9)
    sw $t1, 916($t9)
    sw $t1, 1168($t9)
    jr $ra
    
  drawR:
    sw $t1, 788($t9)
    sw $t1, 784($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 1036($t9)
    sw $t1, 1164($t9)
    sw $t1, 1292($t9)
    sw $t1, 1300($t9)
    sw $t1, 1044($t9)
    sw $t1, 916($t9)
    sw $t1, 1168($t9)
    jr $ra
  
    
drawS:
    sw $t1, 788($t9)
    sw $t1, 784($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 1036($t9)
    sw $t1, 1292($t9)
    sw $t1, 1296($t9)
    sw $t1, 1300($t9)
    sw $t1, 1172($t9)
    sw $t1, 1044($t9)
    sw $t1, 1040($t9)
    jr $ra
    
 drawT:
    sw $t1, 788($t9)
    sw $t1, 784($t9)
    sw $t1, 780($t9)
    sw $t1, 912($t9)
    sw $t1, 1040($t9)
    sw $t1, 1168($t9)
    sw $t1, 1296($t9)
    jr $ra
    
 drawU:
    sw $t1, 788($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 1036($t9)
    sw $t1, 1164($t9)
    sw $t1, 1292($t9)
    sw $t1, 1296($t9)
    sw $t1, 1300($t9)
    sw $t1, 1172($t9)
    sw $t1, 1044($t9)
    sw $t1, 916($t9)
    jr $ra
    
 drawV:
    sw $t1, 788($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 1036($t9)
    sw $t1, 1164($t9)
    sw $t1, 1296($t9)
    sw $t1, 1172($t9)
    sw $t1, 1044($t9)
    sw $t1, 916($t9)
    jr $ra
    
    
  drawW:
    sw $t1, 788($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 1036($t9)
    sw $t1, 1164($t9)
    sw $t1, 1168($t9)
    sw $t1, 1292($t9)
    sw $t1, 1300($t9)
    sw $t1, 1172($t9)
    sw $t1, 1044($t9)
    sw $t1, 916($t9)
    sw $t1, 1040($t9)
    
    jr $ra
    
  drawX:
    sw $t1, 788($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 916($t9)
    sw $t1, 1040($t9)
    sw $t1, 1164($t9)
    sw $t1, 1172($t9)
    sw $t1, 1292($t9)
    sw $t1, 1300($t9)
    jr $ra
    
  drawY:
    sw $t1, 788($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 916($t9)
    sw $t1, 1040($t9)
    sw $t1, 1168($t9)
    sw $t1, 1296($t9)
    jr $ra
    
  drawZ:
    sw $t1, 788($t9)
    sw $t1, 784($t9)
    sw $t1, 780($t9)
    sw $t1, 1164($t9)
    sw $t1, 1292($t9)
    sw $t1, 1296($t9)
    sw $t1, 1300($t9)
    sw $t1, 916($t9)
    sw $t1, 1040($t9)
    jr $ra
 
 draw1:
    sw $t1, 784($t9)
    sw $t1, 912($t9)
    sw $t1, 1040($t9)
    sw $t1, 1168($t9)
    sw $t1, 1296($t9)
    j returnDN
  
    
    
 draw2:
    sw $t1, 788($t9)
    sw $t1, 784($t9)
    sw $t1, 780($t9)
    sw $t1, 1036($t9)
    sw $t1, 1164($t9)
    sw $t1, 1292($t9)
    sw $t1, 1296($t9)
    sw $t1, 1300($t9)
    sw $t1, 1044($t9)
    sw $t1, 916($t9)
    sw $t1, 1040($t9)
    j returnDN
    
    
 draw3:
    sw $t1, 788($t9)
    sw $t1, 784($t9)
    sw $t1, 780($t9)
    sw $t1, 1036($t9)
    sw $t1, 1292($t9)
    sw $t1, 1296($t9)
    sw $t1, 1300($t9)
    sw $t1, 1172($t9)
    sw $t1, 1044($t9)
    sw $t1, 916($t9)
    sw $t1, 1040($t9)
    j returnDN
    
    
 draw4:
    sw $t1, 788($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 1036($t9)
    sw $t1, 1300($t9)
    sw $t1, 1172($t9)
    sw $t1, 1044($t9)
    sw $t1, 916($t9)
    sw $t1, 1040($t9)
    j returnDN
   
    
 draw5:
    sw $t1, 788($t9)
    sw $t1, 784($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 1036($t9)
    sw $t1, 1292($t9)
    sw $t1, 1296($t9)
    sw $t1, 1300($t9)
    sw $t1, 1172($t9)
    sw $t1, 1044($t9)
    sw $t1, 1040($t9)
    j returnDN
    
    
    
  draw6:
    sw $t1, 788($t9)
    sw $t1, 784($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 1036($t9)
    sw $t1, 1292($t9)
    sw $t1, 1296($t9)
    sw $t1, 1300($t9)
    sw $t1, 1164($t9)
    sw $t1, 1172($t9)
    sw $t1, 1044($t9)
    sw $t1, 1040($t9)
    j returnDN
    
    
  draw7:
    sw $t1, 788($t9)
    sw $t1, 784($t9)
    sw $t1, 780($t9)
    sw $t1, 1300($t9)
    sw $t1, 1172($t9)
    sw $t1, 1044($t9)
    sw $t1, 916($t9)
    j returnDN
    
   
  draw8:
    sw $t1, 788($t9)
    sw $t1, 784($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 1036($t9)
    sw $t1, 1164($t9)
    sw $t1, 1292($t9)
    sw $t1, 1296($t9)
    sw $t1, 1300($t9)
    sw $t1, 1172($t9)
    sw $t1, 1044($t9)
    sw $t1, 916($t9)
    sw $t1, 1040($t9)
    j returnDN
 
  
  draw9:
    sw $t1, 788($t9)
    sw $t1, 784($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 1036($t9)
    sw $t1, 1292($t9)
    sw $t1, 1296($t9)
    sw $t1, 1300($t9)
    sw $t1, 1172($t9)
    sw $t1, 1044($t9)
    sw $t1, 916($t9)
    sw $t1, 1040($t9)
    j returnDN
  
  draw0:
    sw $t1, 788($t9)
    sw $t1, 784($t9)
    sw $t1, 780($t9)
    sw $t1, 908($t9)
    sw $t1, 1036($t9)
    sw $t1, 1164($t9)
    sw $t1, 1292($t9)
    sw $t1, 1296($t9)
    sw $t1, 1300($t9)
    sw $t1, 1172($t9)
    sw $t1, 1044($t9)
    sw $t1, 916($t9)
    j returnDN
    
checkName:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    lw $t8, 0xffff0000
    beq $t8, 1, name_press
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    

name_press:
    lw $t5, 0xffff0004
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    beq $t5, 0x61, respond_to_a
    beq $t5, 0x62, respond_to_b
    beq $t5, 0x63, respond_to_c
    beq $t5, 0x64, respond_to_d
    beq $t5, 0x65, respond_to_e
    beq $t5, 0x66, respond_to_f
    beq $t5, 0x67, respond_to_g
    beq $t5, 0x68, respond_to_h
    beq $t5, 0x69, respond_to_i
    beq $t5, 0x6a, respond_to_j2
    beq $t5, 0x6b, respond_to_k2
    beq $t5, 0x6c, respond_to_l
    beq $t5, 0x6d, respond_to_m
    beq $t5, 0x6e, respond_to_n
    beq $t5, 0x6f, respond_to_o
    beq $t5, 0x70, respond_to_p
    beq $t5, 0x71, respond_to_q
    beq $t5, 0x72, respond_to_r
    beq $t5, 0x73, respond_to_s
    beq $t5, 0x74, respond_to_t
    beq $t5, 0x75, respond_to_u
    beq $t5, 0x76, respond_to_v
    beq $t5, 0x77, respond_to_w
    beq $t5, 0x78, respond_to_x
    beq $t5, 0x79, respond_to_y
    beq $t5, 0x7a, respond_to_z
    beq $t5, 0x20, stopName
    returnNameInput:
    addi $t9, $t9, 16
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

stopName:
    j returnStopName
respond_to_a:
jal drawA
j returnNameInput

respond_to_b:
jal drawB
j returnNameInput

respond_to_c:
jal drawC
j returnNameInput

respond_to_d:
jal drawD
j returnNameInput

respond_to_e:
jal drawE
j returnNameInput

respond_to_f:
jal drawF
j returnNameInput

respond_to_g:
jal drawG
j returnNameInput

respond_to_h:
jal drawH
j returnNameInput

respond_to_i:
jal drawI
j returnNameInput

respond_to_j2:
jal drawJ
j returnNameInput

respond_to_k2:
jal drawK
j returnNameInput

respond_to_l:
jal drawL
j returnNameInput

respond_to_m:
jal drawM
j returnNameInput

respond_to_n:
jal drawN
j returnNameInput

respond_to_o:
jal drawO
j returnNameInput

respond_to_p:
jal drawP
j returnNameInput

respond_to_q:
jal drawQ
j returnNameInput

respond_to_r:
jal drawR
j returnNameInput

respond_to_s:
jal drawS
j returnNameInput

respond_to_t:
jal drawT
j returnNameInput

respond_to_u:
jal drawU
j returnNameInput

respond_to_v:
jal drawV
j returnNameInput

respond_to_w:
jal drawW
j returnNameInput

respond_to_x:
jal drawX
j returnNameInput

respond_to_y:
jal drawY
j returnNameInput

respond_to_z:
jal drawZ
j returnNameInput

cover:
addi $sp, $sp, -4
sw $ra, 0($sp)
la $t1, 0x07851c
addi $t9, $t9, -256
jal drawN
addi $t9, $t9, 16
jal drawA
addi $t9, $t9, 16
jal drawM
addi $t9, $t9, 16
jal drawE
addi $t9, $t9, 16
sw $t1, 1036($t9)
sw $t1, 1292($t9)
la $t1, 0xfe020d
addi $t9, $t9, 16
jal drawHeart
la $t1, 0x07851c
addi $t9, $t9, 1840
jal drawP
addi $t9, $t9, 16
jal drawR
addi $t9, $t9, 16
jal drawE
addi $t9, $t9, 16
jal drawS
addi $t9, $t9, 16
jal drawS

addi $t9, $t9, 28
jal drawS
addi $t9, $t9, 668
jal drawT
addi $t9, $t9, 16
jal drawO
addi $t9, $t9, 28
la $t1, 0xf5a41e
jal drawS
addi $t9, $t9, 16
jal drawT
addi $t9, $t9, 16
jal drawA
addi $t9, $t9, 16
jal drawR
addi $t9, $t9, 16
jal drawT



lw $ra, 0($sp)
 addi $sp, $sp, 4
 jr $ra

eraseNotifications:
add $t3, $zero, $zero
addi $t4, $zero, 224
la $s3, DISPLAY
eraseN:
    beq $t3, $t4, eraseEnd
    sw $t2, 0($s3)
    addi $s3, $s3, 4
    addi $t3, $t3, 1
    j eraseN
    eraseEnd:
    addi $s3, $s3, -896
    jr $ra
    
         
notifications:
    addi $t1, $zero, 0x800080
    
    addi $v0, $zero, 42
    addi $a1, $zero, 6
    syscall
    beq $a0, 0, drawPerfect
    beq $a0, 1, drawAwesome
    beq $a0, 2, drawPoggers
    beq $a0, 3, drawWow
    beq $a0, 4, drawCool
    beq $a0, 5, drawNice
    beq $a0, 6, drawGood
    returnN:   
    addi $t1, $zero, 0x5789e8
    j returnNotifications 

drawCool:
    jal drawC
    addi $t9, $t9, 16
    jal drawO
    addi $t9, $t9, 16
    jal drawO
    addi $t9, $t9, 16
    jal drawL
    addi $t9, $t9, 16
    jal drawPun
    addi $t9, $t9, -64
    j returnN
    
 drawNice:
    jal drawN
    addi $t9, $t9, 16
    jal drawI
    addi $t9, $t9, 16
    jal drawC
    addi $t9, $t9, 16
    jal drawE
    addi $t9, $t9, 16
    jal drawPun
    addi $t9, $t9, -64
    j returnN
    
  drawGood:
    jal drawG
    addi $t9, $t9, 16
    jal drawO
    addi $t9, $t9, 16
    jal drawO
    addi $t9, $t9, 16
    jal drawD
    addi $t9, $t9, 16
    jal drawPun
    addi $t9, $t9, -64
    j returnN
    
drawPerfect:
    jal drawP
    addi $t9, $t9, 16
    jal drawE
    addi $t9, $t9, 16
    jal drawR
    addi $t9, $t9, 16
    jal drawF
    addi $t9, $t9, 16
    jal drawE
    addi $t9, $t9, 16
    jal drawC
    addi $t9, $t9, 16
    jal drawT
    addi $t9, $t9, 16
    jal drawPun
    addi $t9, $t9, -112
    j returnN


drawAwesome:
    jal drawA
    addi $t9, $t9, 16
    jal drawW
    addi $t9, $t9, 16
    jal drawE
    addi $t9, $t9, 16
    jal drawS
    addi $t9, $t9, 16
    jal drawO
    addi $t9, $t9, 16
    jal drawM
    addi $t9, $t9, 16
    jal drawE
    addi $t9, $t9, 16
    jal drawPun
    addi $t9, $t9, -112
    j returnN
 
 drawPoggers:
    jal drawP
    addi $t9, $t9, 16
    jal drawO
    addi $t9, $t9, 16
    jal drawG
    addi $t9, $t9, 16
    jal drawG
    addi $t9, $t9, 16
    jal drawE
    addi $t9, $t9, 16
    jal drawR
    addi $t9, $t9, 16
    jal drawS
    addi $t9, $t9, 16
    jal drawPun
    addi $t9, $t9, -112
    j returnN
    
  drawWow:
    jal drawW
    addi $t9, $t9, 16
    jal drawO
    addi $t9, $t9, 16
    jal drawW
    addi $t9, $t9, 16
    jal drawPun
    addi $t9, $t9, -48
    j returnN
   
   drawPun:
    sw $t1, 784($t9)
    sw $t1, 912($t9)
    sw $t1, 1040($t9)
    sw $t1, 1296($t9)
    jr $ra
    
    
   drawDoodler:
    la $t1, 0xd4f84d
    sw $t1, 3788($t9)
    sw $t1, 3792($t9)
    sw $t1, 3796($t9)
    sw $t1, 3916($t9)
    sw $t1, 3920($t9)
    sw $t1, 3928($t9)
    la $t1, 0x374017
    sw $t1, 4172($t9)
    sw $t1, 4180($t9)
    la $t1, 0x07851c
    sw $t1, 4044($t9)
    sw $t1, 4048($t9)
    sw $t1, 4052($t9)
    la $t1, 0x000000
    sw $t1, 3924($t9)
    la $t1, 0xb6bfbd
    sw $t1, 3912($t9)
    sw $t1, 4040($t9)
    la $t1, 0xfd1d12
    sw $t1, 4168($t9)
    jr $ra
    
    eraseDoodler:
    sw $t2, 3788($s7)
    sw $t2, 3792($s7)
    sw $t2, 3796($s7)
    sw $t2, 3916($s7)
    sw $t2, 3920($s7)
    sw $t2, 3928($s7)
    sw $t2, 4172($s7)
    sw $t2, 4180($s7)
    sw $t2, 4044($s7)
    sw $t2, 4048($s7)
    sw $t2, 4052($s7)
    sw $t2, 3924($s7)
    sw $t2, 3912($s7)
    sw $t2, 4040($s7)
    sw $t2, 4168($s7)
    jr $ra
    
    drawHeart:
   
    sw $t1, 784($t9)
    sw $t1, 792($t9)
    sw $t1, 908($t9)
    sw $t1, 912($t9)
    sw $t1, 916($t9)
    sw $t1, 920($t9)
    sw $t1, 924($t9)
    sw $t1, 1036($t9)
    sw $t1, 1040($t9)
    sw $t1, 1044($t9)
    sw $t1, 1048($t9)
    sw $t1, 1052($t9)
    
    sw $t1, 1168($t9)
    sw $t1, 1172($t9)
    sw $t1, 1176($t9)
    sw $t1, 1300($t9)
    jr $ra
    

    
    
    


