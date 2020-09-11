# CSE 220 Programming Project #4
# Name: Steven Zeng
# Net ID: stzeng
# SBU ID: 111671704

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################

.text
load_board:
move $s0, $a0 #board
move $s1, $a1 #filename

load_board.start:
#open file
move $a0, $s1
li $a1, 0
li $v0, 13
syscall

#read file
move $s2, $v0 #file descriptor
li $v0, 14 
move $a0, $s2
move $a1, $s0
#move $a1, $0 #loads num_rows
li $a2, 255
syscall

move $s0, $a1

#print file
#li $v0, 4
#move $a0, $a1
#syscall

load_board.fixloop:
lbu $s3, 0($s0) #stores rows
lbu $s4, 1($s0) #stores cols or second digit of row
beq $s4, 10, row1digit
li $t0, 10
addi $s3, $s3, -48
addi $s4, $s4, -48
mul $s3, $s3, $t0
add $s3, $s3, $s4 #compute num_row into s3
j computecol.1

row1digit:
addi $s3, $s3, -48 #compute num_row into s3
j computecol.2

computecol.1:
lbu $s4, 3($s0)
lbu $s5, 4($s0)
beq $s5, 10, col1digit.1
li $t0, 10
addi $s4, $s4, -48
addi $s5, $s5, -48
mul $s4, $s4, $t0
add $s4, $s4, $s5 #compute num_col into s4
addi $s0, $s0, 6
j printxd

computecol.2:
lbu $s4, 2($s0)
lbu $s5, 3($s0)
beq $s5, 10, col1digit.2
li $t0, 10
addi $s4, $s4, -48
addi $s5, $s5, -48
mul $s4, $s4, $t0
add $s4, $s4, $s5 #compute num_col into s4
addi $s0, $s0, 5
j printxd

col1digit.1:
addi $s4, $s4, -48
addi $s0, $s0, 5
j printxd

col1digit.2:
addi $s4, $s4, -48
addi $s0, $s0, 4

printxd:
li $t0, 0 #loop var
li $t1, 0 #count of Xs
li $t2, 0 #count of Os
li $t3, 0 #count of invalid chars

countandfix:
beq $t0, $s3, closefile
countandfix.1:
lbu $s5, 0($s0) #loads char from 2d array 
beq $s5, 10, countandfixreset
beq $s5, 'X', countx
beq $s5, 'O', counto
bne $s5, '.', countinv
addi $s0, $s0, 1
j countandfix.1

countx:
addi $t1, $t1, 1
addi $s0, $s0, 1
j countandfix.1

counto:
addi $t2, $t2, 1
addi $s0, $s0, 1
j countandfix.1

countinv:
addi $t3, $t3, 1
li $t4, '.'
sb $t4, 0($s0)
addi $s0, $s0, 1
j countandfix.1

countandfixreset:
addi $s0, $s0, 1
addi $t0, $t0, 1
j countandfix

#close file
closefile:
#li $v0, 4
#move $a0, $a1
#syscall


#li $v0, 16
#move $a0, $s2
#syscall
li $v0, 0
or $v0, $v0, $t1
sll $v0, $v0, 8
or $v0, $v0, $t2
sll $v0, $v0, 8
or $v0, $v0, $t3
j load_board.end

load_board.nofile:
li $v0, -1
j load_board.end

load_board.end:
    jr $ra
##################################################################################################################################
get_slot:
move $s0, $a0
lbu $s3, 0($s0) #stores rows
lbu $s4, 1($s0) #stores cols or second digit of row
beq $s4, 10, row1digitget
li $t0, 10
addi $s3, $s3, -48
addi $s4, $s4, -48
mul $s3, $s3, $t0
add $s3, $s3, $s4 #compute num_row into s3
j computecol.1get

row1digitget:
addi $s3, $s3, -48 #compute num_row into s3
j computecol.2get

computecol.1get:
lbu $s4, 3($s0)
lbu $s5, 4($s0)
beq $s5, 10, col1digit.1get
li $t0, 10
addi $s4, $s4, -48
addi $s5, $s5, -48
mul $s4, $s4, $t0
add $s4, $s4, $s5 #compute num_col into s4
addi $s0, $s0, 6
j get_slot.start

computecol.2get:
lbu $s4, 2($s0)
lbu $s5, 3($s0)
beq $s5, 10, col1digit.2get
li $t0, 10
addi $s4, $s4, -48
addi $s5, $s5, -48
mul $s4, $s4, $t0
add $s4, $s4, $s5 #compute num_col into s4
addi $s0, $s0, 5
j get_slot.start

col1digit.1get:
addi $s4, $s4, -48
addi $s0, $s0, 5
j get_slot.start

col1digit.2get:
addi $s4, $s4, -48
addi $s0, $s0, 4

get_slot.start:
bltz $a1, get_slot.inv
bltz $a2, get_slot.inv
bgt $a1, $s3, get_slot.inv
bgt $a2, $s4, get_slot.inv
addi $s4, $s4, 1
mul $a1, $a1, $s4
add $a1, $a1, $a2
add $s0, $s0, $a1
lbu $v0, 0($s0)
j get_slot.end

get_slot.inv:
li $v0, -1
j get_slot.end

get_slot.end:
    jr $ra
###################################################################################################################################
set_slot:
move $s0, $a0
lbu $s3, 0($s0) #stores rows
lbu $s4, 1($s0) #stores cols or second digit of row
beq $s4, 10, row1digitset
li $t0, 10
addi $s3, $s3, -48
addi $s4, $s4, -48
mul $s3, $s3, $t0
add $s3, $s3, $s4 #compute num_row into s3
j computecol.1set

row1digitset:
addi $s3, $s3, -48 #compute num_row into s3
j computecol.2set

computecol.1set:
lbu $s4, 3($s0)
lbu $s5, 4($s0)
beq $s5, 10, col1digit.1set
li $t0, 10
addi $s4, $s4, -48
addi $s5, $s5, -48
mul $s4, $s4, $t0
add $s4, $s4, $s5 #compute num_col into s4
addi $s0, $s0, 6
j set_slot.start

computecol.2set:
lbu $s4, 2($s0)
lbu $s5, 3($s0)
beq $s5, 10, col1digit.2set
li $t0, 10
addi $s4, $s4, -48
addi $s5, $s5, -48
mul $s4, $s4, $t0
add $s4, $s4, $s5 #compute num_col into s4
addi $s0, $s0, 5
j set_slot.start

col1digit.1set:
addi $s4, $s4, -48
addi $s0, $s0, 5
j set_slot.start

col1digit.2set:
addi $s4, $s4, -48
addi $s0, $s0, 4

set_slot.start:
bltz $a1, set_slot.inv
bltz $a2, set_slot.inv
bgt $a1, $s3, set_slot.inv
bgt $a2, $s4, set_slot.inv
addi $s4, $s4, 1
mul $a1, $a1, $s4
add $a1, $a1, $a2
add $s0, $s0, $a1
sb $a3, 0($s0)
move $v0, $a3
j set_slot.end

set_slot.inv:
li $v0, -1

set_slot.end:
    jr $ra
##################################################################################################################################
place_piece:
bne $a3, 'X', checkifO 
j checkforspace
checkifO:
bne $a3, 'O', cantplace

checkforspace:
move $s0, $a0
move $s1, $a1
move $s2, $a2
move $s5, $a3
addi $sp, $sp, -20
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s5, 12($sp)
sw $ra, 16($sp)
jal get_slot
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s5, 12($sp)
lw $ra, 16($sp)
addi $sp, $sp, 20
bne $v0, '.', cantplace
move $a1, $s1
move $a2, $s2
move $a3, $s5
addi $sp, $sp, -20
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s5, 12($sp)
sw $ra, 16($sp)
jal set_slot
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s5, 12($sp)
lw $ra, 16($sp)
addi $sp, $sp, 20
j place_piece.end

cantplace:
li $v0, -1
j place_piece.end

place_piece.end:
    jr $ra
###################################################################################################################################
game_status:
move $s0, $a0
lbu $s3, 0($s0) #stores rows
lbu $s4, 1($s0) #stores cols or second digit of row
beq $s4, 10, row1digitgame
li $t0, 10
addi $s3, $s3, -48
addi $s4, $s4, -48
mul $s3, $s3, $t0
add $s3, $s3, $s4 #compute num_row into s3
j computecol.1game

row1digitgame:
addi $s3, $s3, -48 #compute num_row into s3
j computecol.2game

computecol.1game:
lbu $s4, 3($s0)
lbu $s5, 4($s0)
beq $s5, 10, col1digit.1game
li $t0, 10
addi $s4, $s4, -48
addi $s5, $s5, -48
mul $s4, $s4, $t0
add $s4, $s4, $s5 #compute num_col into s4
addi $s0, $s0, 6
j game_status.start

computecol.2game:
lbu $s4, 2($s0)
lbu $s5, 3($s0)
beq $s5, 10, col1digit.2game
li $t0, 10
addi $s4, $s4, -48
addi $s5, $s5, -48
mul $s4, $s4, $t0
add $s4, $s4, $s5 #compute num_col into s4
addi $s0, $s0, 5
j game_status.start

col1digit.1game:
addi $s4, $s4, -48
addi $s0, $s0, 5
j game_status.start

col1digit.2game:
addi $s4, $s4, -48
addi $s0, $s0, 4

game_status.start:
li $v0, 0 #count of X's
li $v1, 0 #count of O's
li $s1, 0 #array accessor(row)
li $s2, 0 #array accessor(col)
addi $s4, $s4, 1
mul $s4, $s4, $s3

game_status.loop2: 
beq $s1, $s4, game_status.end
lbu $s5, 0($s0)
beq $s5, 'X', incx
beq $s5, 'O', inco
addi $s1, $s1, 1
addi $s0, $s0, 1
j game_status.loop2

incx:
addi $v0, $v0, 1
addi $s1, $s1, 1
addi $s0, $s0, 1
j game_status.loop2

inco:
addi $v1, $v1, 1
addi $s1, $s1, 1
addi $s0, $s0, 1
j game_status.loop2

game_status.end:
    jr $ra
###################################################################################################################################
check_horizontal_capture:
move $s0, $a0
lbu $s3, 0($s0) #stores rows
lbu $s4, 1($s0) #stores cols or second digit of row
beq $s4, 10, row1digithor
li $t0, 10
addi $s3, $s3, -48
addi $s4, $s4, -48
mul $s3, $s3, $t0
add $s3, $s3, $s4 #compute num_row into s3
j computecol.1hor

row1digithor:
addi $s3, $s3, -48 #compute num_row into s3
j computecol.2hor

computecol.1hor:
lbu $s4, 3($s0)
lbu $s5, 4($s0)
beq $s5, 10, col1digit.1hor
li $t0, 10
addi $s4, $s4, -48
addi $s5, $s5, -48
mul $s4, $s4, $t0
add $s4, $s4, $s5 #compute num_col into s4
addi $s0, $s0, 6
j hor.start

computecol.2hor:
lbu $s4, 2($s0)
lbu $s5, 3($s0)
beq $s5, 10, col1digit.2hor
li $t0, 10
addi $s4, $s4, -48
addi $s5, $s5, -48
mul $s4, $s4, $t0
add $s4, $s4, $s5 #compute num_col into s4
addi $s0, $s0, 5
j hor.start

col1digit.1hor:
addi $s4, $s4, -48
addi $s0, $s0, 5
j hor.start

col1digit.2hor:
addi $s4, $s4, -48
addi $s0, $s0, 4

hor.start:
move $s1, $a3 #player char
li $s2, 0
addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36
bne $a3, $v0, hor.inv

#check left 1 spot 
addi $a2, $a2, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36


beq $a3, 'X', checkforx
beq $a3, 'O', checkforo
j hor.inv

checkforx:
bne $v0, 'O', checkrightx.1
addi $a2, $a2, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'O', checkrightx.2
addi $a2, $a2, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'X', checkrightx.3

addi $a2, $a2, 1
li $a3, '.'

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

addi $a2, $a2, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

li $a3, 'X'
li $s2, 2
addi $a2, $a2, 1
j checkrightx


checkforo:
bne $v0, 'X', checkrighto.1
addi $a2, $a2, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'X', checkrighto.2
addi $a2, $a2, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'O', checkrighto.3

addi $a2, $a2, 1
li $a3, '.'

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

addi $a2, $a2, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

li $a3, 'O'
li $s2, 2
addi $a2, $a2, 1
j checkrighto


checkrightx.1:
addi $a2, $a2, 1
j checkrightx

checkrightx.2:
addi $a2, $a2, 2
j checkrightx

checkrightx.3:
addi $a2, $a2, 3
j checkrightx

checkrightx:
addi $a2, $a2, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'O', hor.finish
addi $a2, $a2, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'O', hor.finish
addi $a2, $a2, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'X', hor.finish

addi $a2, $a2, -1
li $a3, '.'

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

addi $a2, $a2, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

li $a3, 'X'
addi $s2, $s2, 2
j hor.finish

checkrighto.1:
addi $a2, $a2, 1
j checkrighto

checkrighto.2:
addi $a2, $a2, 2
j checkrighto

checkrighto.3:
addi $a2, $a2, 3 
j checkrighto

checkrighto:
addi $a2, $a2, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'X', hor.finish
addi $a2, $a2, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'X', hor.finish
addi $a2, $a2, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'O', hor.finish

addi $a2, $a2, -1
li $a3, '.'

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

addi $a2, $a2, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

li $a3, 'O'
addi $s2, $s2, 2
j hor.finish


hor.inv:
li $v0, -1
j hor.end

hor.finish:
move $v0, $s2
j hor.end

hor.end:
    jr $ra
####################################################################################################################################
check_vertical_capture:
move $s0, $a0
lbu $s3, 0($s0) #stores rows
lbu $s4, 1($s0) #stores cols or second digit of row
beq $s4, 10, row1digitver
li $t0, 10
addi $s3, $s3, -48
addi $s4, $s4, -48
mul $s3, $s3, $t0
add $s3, $s3, $s4 #compute num_row into s3
j computecol.1ver

row1digitver:
addi $s3, $s3, -48 #compute num_row into s3
j computecol.2ver

computecol.1ver:
lbu $s4, 3($s0)
lbu $s5, 4($s0)
beq $s5, 10, col1digit.1ver
li $t0, 10
addi $s4, $s4, -48
addi $s5, $s5, -48
mul $s4, $s4, $t0
add $s4, $s4, $s5 #compute num_col into s4
addi $s0, $s0, 6
j ver.start

computecol.2ver:
lbu $s4, 2($s0)
lbu $s5, 3($s0)
beq $s5, 10, col1digit.2ver
li $t0, 10
addi $s4, $s4, -48
addi $s5, $s5, -48
mul $s4, $s4, $t0
add $s4, $s4, $s5 #compute num_col into s4
addi $s0, $s0, 5
j ver.start

col1digit.1ver:
addi $s4, $s4, -48
addi $s0, $s0, 5
j ver.start

col1digit.2ver:
addi $s4, $s4, -48
addi $s0, $s0, 4

ver.start:
move $s1, $a3 #player char
li $s2, 0
addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36
bne $a3, $v0, ver.inv

#check left 1 spot 
addi $a1, $a1, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36


beq $a3, 'X', checkforxver
beq $a3, 'O', checkforover
j ver.inv

checkforxver:
bne $v0, 'O', checkrightx.1ver
addi $a1, $a1, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'O', checkrightx.2ver
addi $a1, $a1, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'X', checkrightx.3ver

addi $a1, $a1, 1
li $a3, '.'

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

addi $a1, $a1, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

li $a3, 'X'
li $s2, 2
addi $a1, $a1, 1
j checkrightxver


checkforover:
bne $v0, 'X', checkrighto.1ver
addi $a1, $a1, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'X', checkrighto.2ver
addi $a1, $a1, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'O', checkrighto.3ver

addi $a1, $a1, 1
li $a3, '.'

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

addi $a1, $a1, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

li $a3, 'O'
li $s2, 2
addi $a1, $a1, 1
j checkrightover


checkrightx.1ver:
addi $a1, $a1, 1
j checkrightxver

checkrightx.2ver:
addi $a1, $a1, 2
j checkrightxver

checkrightx.3ver:
addi $a1, $a1, 3
j checkrightxver

checkrightxver:
addi $a1, $a1, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'O', ver.finish
addi $a1, $a1, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'O', ver.finish
addi $a1, $a1, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'X', ver.finish

addi $a1, $a1, -1
li $a3, '.'

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

addi $a1, $a1, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

li $a3, 'X'
addi $s2, $s2, 2
j ver.finish

checkrighto.1ver:
addi $a1, $a1, 1
j checkrightover

checkrighto.2ver:
addi $a1, $a1, 2
j checkrightover

checkrighto.3ver:
addi $a1, $a1, 3 
j checkrightover

checkrightover:
addi $a1, $a1, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'X', ver.finish
addi $a1, $a1, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'X', ver.finish
addi $a1, $a1, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'O', ver.finish

addi $a1, $a1, -1
li $a3, '.'

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

addi $a1, $a1, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

li $a3, 'O'
addi $s2, $s2, 2
j ver.finish

ver.inv:
li $v0, -1
j ver.end

ver.finish:
move $v0, $s2
j ver.end

ver.end:
    jr $ra
####################################################################################################################################
check_diagonal_capture:
move $s0, $a0
lbu $s3, 0($s0) #stores rows
lbu $s4, 1($s0) #stores cols or second digit of row
beq $s4, 10, row1digitdiag
li $t0, 10
addi $s3, $s3, -48
addi $s4, $s4, -48
mul $s3, $s3, $t0
add $s3, $s3, $s4 #compute num_row into s3
j computecol.1diag

row1digitdiag:
addi $s3, $s3, -48 #compute num_row into s3
j computecol.2diag

computecol.1diag:
lbu $s4, 3($s0)
lbu $s5, 4($s0)
beq $s5, 10, col1digit.1diag
li $t0, 10
addi $s4, $s4, -48
addi $s5, $s5, -48
mul $s4, $s4, $t0
add $s4, $s4, $s5 #compute num_col into s4
addi $s0, $s0, 6
j diag.start

computecol.2diag:
lbu $s4, 2($s0)
lbu $s5, 3($s0)
beq $s5, 10, col1digit.2diag
li $t0, 10
addi $s4, $s4, -48
addi $s5, $s5, -48
mul $s4, $s4, $t0
add $s4, $s4, $s5 #compute num_col into s4
addi $s0, $s0, 5
j diag.start

col1digit.1diag:
addi $s4, $s4, -48
addi $s0, $s0, 5
j diag.start

col1digit.2diag:
addi $s4, $s4, -48
addi $s0, $s0, 4

diag.start:

move $s1, $a3 #player char
li $s2, 0
addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36
bne $a3, $v0, diag.inv

#check left 1 spot 
addi $a1, $a1, -1
addi $a2, $a2, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36


beq $a3, 'X', checkforxdiag
beq $a3, 'O', checkforodiag
j ver.inv

checkforxdiag:

bne $v0, 'O', checkrightx.1diag
addi $a1, $a1, -1
addi $a2, $a2, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'O', checkrightx.2diag
addi $a1, $a1, -1
addi $a2, $a2, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'X', checkrightx.3diag

addi $a1, $a1, 1
addi $a2, $a2, 1
li $a3, '.'

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

addi $a1, $a1, 1
addi $a2, $a2, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

li $a3, 'X'
addi $s2, $s2, 2
addi $a1, $a1, 1
addi $a2, $a2, 1
j checkrightxdiag


checkforodiag:
bne $v0, 'X', checkrighto.1diag
addi $a1, $a1, -1
addi $a2, $a2, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'X', checkrighto.2diag
addi $a1, $a1, -1
addi $a2, $a2, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'O', checkrighto.3diag

addi $a1, $a1, 1
addi $a2, $a2, 1
li $a3, '.'

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

addi $a1, $a1, 1
addi $a2, $a2, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

li $a3, 'O'
addi $s2, $s2, 2
addi $a1, $a1, 1
addi $a2, $a2, 1
j checkrightodiag


checkrightx.1diag:
addi $a1, $a1, 1
addi $a2, $a2, 1
j checkrightxdiag

checkrightx.2diag:
addi $a1, $a1, 2
addi $a2, $a2, 2
j checkrightxdiag

checkrightx.3diag:
addi $a2, $a2, 3
addi $a1, $a1, 3
j checkrightxdiag

checkrightxdiag:
addi $a2, $a2, 1
addi $a1, $a1, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'O', resetx.1
addi $a1, $a1, 1
addi $a2, $a2, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'O', resetx.2
addi $a1, $a1, 1
addi $a2, $a2, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'X', resetx.3

addi $a1, $a1, -1
addi $a2, $a2, -1
li $a3, '.'

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

addi $a1, $a1, -1
addi $a2, $a2, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

addi $a1, $a1, -1
addi $a2, $a2, -1

li $a3, 'X'
addi $s2, $s2, 2
j diag.start1

resetx.1:
addi $a1, $a1, -1
addi $a2, $a2, -1
j diag.start1

resetx.2:
addi $a1, $a1, -2
addi $a2, $a2, -2
j diag.start1

resetx.3:
addi $a1, $a1, -3
addi $a2, $a3, -3
j diag.start1


checkrighto.1diag:
addi $a1, $a1, 1
addi $a2, $a2, 1
j checkrightodiag

checkrighto.2diag:
addi $a1, $a1, 2
addi $a2, $a2, 2
j checkrightodiag

checkrighto.3diag:
addi $a1, $a1, 3 
addi $a2, $a2, 3
j checkrightodiag

checkrightodiag:
addi $a1, $a1, 1
addi $a2, $a2, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'X', resety.1
addi $a1, $a1, 1
addi $a2, $a2, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'X', resety.2
addi $a1, $a1, 1
addi $a2, $a2, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'O', resety.3

addi $a1, $a1, -1
addi $a2, $a2, -1
li $a3, '.'

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

addi $a1, $a1, -1
addi $a2, $a2, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

addi $a1, $a1, -1
addi $a2, $a2, -1

li $a3, 'O'
addi $s2, $s2, 2
j diag.start1


resety.1:
addi $a1, $a1, -1
addi $a2, $a2, -1
j diag.start1

resety.2:
addi $a1, $a1, -2
addi $a2, $a2, -2
j diag.start1

resety.3:
addi $a1, $a1, -3
addi $a2, $a2, -3
j diag.start1


diag.start1:


addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36
bne $a3, $v0, diag.inv

#check left 1 spot 
addi $a1, $a1, -1
addi $a2, $a2, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36


beq $a3, 'X', checkforxdiag1
beq $a3, 'O', checkforodiag1
j ver.inv

checkforxdiag1:
bne $v0, 'O', checkrightx.1diag1
addi $a1, $a1, -1
addi $a2, $a2, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'O', checkrightx.2diag1
addi $a1, $a1, -1
addi $a2, $a2, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'X', checkrightx.3diag1

addi $a1, $a1, 1
addi $a2, $a2, -1
li $a3, '.'

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

addi $a1, $a1, 1
addi $a2, $a2, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

li $a3, 'X'
addi $s2, $s2, 2
addi $a1, $a1, 1
addi $a2, $a2, -1

j checkrightxdiag1


checkforodiag1:
bne $v0, 'X', checkrighto.1diag1
addi $a1, $a1, -1
addi $a2, $a2, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'X', checkrighto.2diag1
addi $a1, $a1, -1
addi $a2, $a2, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'O', checkrighto.3diag1

addi $a1, $a1, -1
addi $a2, $a2, 1
li $a3, '.'

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

addi $a1, $a1, -1
addi $a2, $a2, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

li $a3, 'O'
addi $s2, $s2, 2
addi $a1, $a1, -1
addi $a2, $a2, 1
j checkrightodiag1


checkrightx.1diag1:
addi $a1, $a1, 1
addi $a2, $a2, -1
j checkrightxdiag1

checkrightx.2diag1:
addi $a1, $a1, 2
addi $a2, $a2, -2
j checkrightxdiag1

checkrightx.3diag1:
addi $a2, $a2, 3
addi $a1, $a1, -3
j checkrightxdiag1

checkrightxdiag1:

addi $a1, $a1, 1
addi $a2, $a2, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'O', diag.finish
addi $a1, $a1, 1
addi $a2, $a2, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'O', diag.finish
addi $a1, $a1, 1
addi $a2, $a2, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'X', diag.finish

addi $a1, $a1, -1
addi $a2, $a2, 1
li $a3, '.'

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

addi $a1, $a1, -1
addi $a2, $a2, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

li $a3, 'X'
addi $s2, $s2, 2
j diag.finish

checkrighto.1diag1:
addi $a1, $a1, 1
addi $a2, $a2, -1
j checkrightodiag1

checkrighto.2diag1:
addi $a1, $a1, 2
addi $a2, $a2, -2
j checkrightodiag1

checkrighto.3diag1:
addi $a1, $a1, 3 
addi $a2, $a2, -3
j checkrightodiag1

checkrightodiag1:
addi $a1, $a1, 1
addi $a2, $a2, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'X', diag.finish
addi $a1, $a1, 1
addi $a2, $a2, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'X', diag.finish
addi $a1, $a1, 1
addi $a2, $a2, -1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal get_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

bne $v0, 'O', diag.finish

addi $a1, $a1, -1
addi $a2, $a2, 1
li $a3, '.'

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

addi $a1, $a1, -1
addi $a2, $a2, 1

addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s3, 4($sp)
sw $s4, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $a0, 20($sp)
sw $a1, 24($sp)
sw $a2, 28($sp)
sw $a3, 32($sp)
jal set_slot
lw $ra, 0($sp)
lw $s3, 4($sp)
lw $s4, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 32($sp)
addi $sp, $sp, 36

li $a3, 'O'
addi $s2, $s2, 2
j diag.finish



diag.inv:
li $v0, -1
j diag.end

diag.finish:
li $v0, 4
syscall
move $v0, $s2
j diag.end

diag.end:
    jr $ra
####################################################################################################################################
check_horizontal_winner:
move $s0, $a0
lbu $s3, 0($s0) #stores rows
lbu $s4, 1($s0) #stores cols or second digit of row
beq $s4, 10, row1digithwin
li $t0, 10
addi $s3, $s3, -48
addi $s4, $s4, -48
mul $s3, $s3, $t0
add $s3, $s3, $s4 #compute num_row into s3
j computecol.1hwin

row1digithwin:
addi $s3, $s3, -48 #compute num_row into s3
j computecol.2hwin

computecol.1hwin:
lbu $s4, 3($s0)
lbu $s5, 4($s0)
beq $s5, 10, col1digit.1hwin
li $t0, 10
addi $s4, $s4, -48
addi $s5, $s5, -48
mul $s4, $s4, $t0
add $s4, $s4, $s5 #compute num_col into s4
addi $s0, $s0, 6
j hwin.start

computecol.2hwin:
lbu $s4, 2($s0)
lbu $s5, 3($s0)
beq $s5, 10, col1digit.2hwin
li $t0, 10
addi $s4, $s4, -48
addi $s5, $s5, -48
mul $s4, $s4, $t0
add $s4, $s4, $s5 #compute num_col into s4
addi $s0, $s0, 5
j hwin.start

col1digit.1hwin:
addi $s4, $s4, -48
addi $s0, $s0, 5
j hwin.start

col1digit.2hwin:
addi $s4, $s4, -48
addi $s0, $s0, 4

hwin.start:
li $s5, 0 #col loop var
li $s1, 0 #row loop var
li $s2, 0 #count of chars in each row
addi $s4, $s4, 1
move $s6, $a1
beq $a1, 'X', hwin.row.loop
beq $a1, 'O', hwin.row.loop
j hwin.inv

hwin.row.loop:
beq $s1, $s3, hwin.inv
hwin.col.loop:
beq $s2, 5, hwin.finish
beq $s5, $s4, hwin.col.reset
move $a1, $s1
move $a2, $s5
addi $sp, $sp, -32
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 20($sp)
sw $s6, 24($sp)
sw $ra, 28($sp)
jal get_slot
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $s6, 24($sp)
lw $ra, 28($sp)
addi $sp, $sp, 32
bne $v0, $s6, hwin.add
addi $s2, $s2, 1
addi $s5, $s5, 1
j hwin.row.loop

hwin.add:
addi $s5, $s5, 1
li $s2, 0
j hwin.row.loop


hwin.col.reset:
li $s5, 0
li $s2, 0
addi $s1, $s1, 1
j hwin.row.loop

hwin.finish:
addi $s5, $s5, -5
move $v0, $s1
move $v1, $s5
j hwin.end

hwin.inv:
li $v0, -1
li $v1, -1
j hwin.end

hwin.end:
    jr $ra
####################################################################################################################################
check_vertical_winner:
move $s0, $a0
lbu $s3, 0($s0) #stores rows
lbu $s4, 1($s0) #stores cols or second digit of row
beq $s4, 10, row1digitvwin
li $t0, 10
addi $s3, $s3, -48
addi $s4, $s4, -48
mul $s3, $s3, $t0
add $s3, $s3, $s4 #compute num_row into s3
j computecol.1vwin

row1digitvwin:
addi $s3, $s3, -48 #compute num_row into s3
j computecol.2vwin

computecol.1vwin:
lbu $s4, 3($s0)
lbu $s5, 4($s0)
beq $s5, 10, col1digit.1vwin
li $t0, 10
addi $s4, $s4, -48
addi $s5, $s5, -48
mul $s4, $s4, $t0
add $s4, $s4, $s5 #compute num_col into s4
addi $s0, $s0, 6
j vwin.start

computecol.2vwin:
lbu $s4, 2($s0)
lbu $s5, 3($s0)
beq $s5, 10, col1digit.2vwin
li $t0, 10
addi $s4, $s4, -48
addi $s5, $s5, -48
mul $s4, $s4, $t0
add $s4, $s4, $s5 #compute num_col into s4
addi $s0, $s0, 5
j vwin.start

col1digit.1vwin:
addi $s4, $s4, -48
addi $s0, $s0, 5
j vwin.start

col1digit.2vwin:
addi $s4, $s4, -48
addi $s0, $s0, 4

vwin.start:
li $s5, 0 #col loop var
li $s1, 0 #row loop var
li $s2, 0 #count of chars in each row
move $s6, $a1
beq $a1, 'X', vwin.row.loop
beq $a1, 'O', vwin.row.loop
j vwin.inv

vwin.row.loop:
beq $s1, $s4, vwin.inv
vwin.col.loop:
beq $s2, 5, vwin.finish
beq $s5, $s3, vwin.col.reset
move $a1, $s5
move $a2, $s1
addi $sp, $sp, -32
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 20($sp)
sw $s6, 24($sp)
sw $ra, 28($sp)
jal get_slot
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $s6, 24($sp)
lw $ra, 28($sp)
addi $sp, $sp, 32
bne $v0, $s6, vwin.add
addi $s2, $s2, 1
addi $s5, $s5, 1
j vwin.row.loop

vwin.add:
addi $s5, $s5, 1
li $s2, 0
j vwin.row.loop


vwin.col.reset:
li $s5, 0
li $s2, 0
addi $s1, $s1, 1
j vwin.row.loop

vwin.finish:
addi $s5, $s5, -5
move $v0, $s5
move $v1, $s1
j vwin.end

vwin.inv:
li $v0, -1
li $v1, -1
j vwin.end

vwin.end:
    jr $ra
####################################################################################################################################
check_sw_ne_diagonal_winner:
move $s0, $a0
lbu $s3, 0($s0) #stores rows
lbu $s4, 1($s0) #stores cols or second digit of row
beq $s4, 10, row1digitsw
li $t0, 10
addi $s3, $s3, -48
addi $s4, $s4, -48
mul $s3, $s3, $t0
add $s3, $s3, $s4 #compute num_row into s3
j computecol.1sw

row1digitsw:
addi $s3, $s3, -48 #compute num_row into s3
j computecol.2sw

computecol.1sw:
lbu $s4, 3($s0)
lbu $s5, 4($s0)
beq $s5, 10, col1digit.1sw
li $t0, 10
addi $s4, $s4, -48
addi $s5, $s5, -48
mul $s4, $s4, $t0
add $s4, $s4, $s5 #compute num_col into s4
addi $s0, $s0, 6
j sw.start

computecol.2sw:
lbu $s4, 2($s0)
lbu $s5, 3($s0)
beq $s5, 10, col1digit.2sw
li $t0, 10
addi $s4, $s4, -48
addi $s5, $s5, -48
mul $s4, $s4, $t0
add $s4, $s4, $s5 #compute num_col into s4
addi $s0, $s0, 5
j sw.start

col1digit.1sw:
addi $s4, $s4, -48
addi $s0, $s0, 5
j sw.start

col1digit.2sw:
addi $s4, $s4, -48
addi $s0, $s0, 4

sw.start:
li $s1, 0 #row loop var
li $s5, 0 #col loop var
li $s2, 0 #count of chars in each row
move $s6, $a1
addi $s3, $s3, 1
beq $s6, 'X', sw.firloop
beq $s6, 'O', sw.firloop
j sw.inv

sw.firloop:
beq $s1, $s4, sw.inv
sw.secloop:
beq $s5, $s3, sw.nextrow
move $a1, $s5
move $a2, $s1


addi $sp, $sp, -44
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 20($sp)
sw $s6, 24($sp)
sw $ra, 28($sp)
sw $a1, 32($sp)
sw $a2, 36($sp)
sw $a0, 40($sp)
jal get_slot
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $s6, 24($sp)
lw $ra, 28($sp)
lw $a1, 32($sp)
lw $a2, 36($sp)
lw $a0, 40($sp)
addi $sp, $sp, 44



bne $v0, $s6, sw.nextcol


sw.thirdloop:


beq $s2, 4, sw.finish
addi $a1, $a1, -1
addi $a2, $a2, 1

addi $sp, $sp, -40
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 20($sp)
sw $s6, 24($sp)
sw $ra, 28($sp)
sw $a1, 32($sp)
sw $a2, 36($sp)
sw $a0, 40($sp)
jal get_slot
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $s6, 24($sp)
lw $ra, 28($sp)
lw $a1, 32($sp)
lw $a2, 36($sp)
addi $sp, $sp, 40

beq $v0, -1, sw.nextcol
bne $v0, $s6, sw.nextcol
addi $s2, $s2, 1
j sw.thirdloop


sw.nextcol:
li $s2, 0
addi $s5, $s5, 1
j sw.firloop

sw.nextrow:
li $s5, 0
li $s2, 0
addi $s1, $s1, 1
j sw.firloop

sw.finish:
move $v0, $s5
move $v1, $s1
j sw.end

sw.inv1:
li $v0, 99
li $v1, 99
j sw.end

sw.inv:
li $v0, -1
li $v1, -1
j sw.end

sw.end:
    jr $ra
####################################################################################################################################
check_nw_se_diagonal_winner:
move $s0, $a0
lbu $s3, 0($s0) #stores rows
lbu $s4, 1($s0) #stores cols or second digit of row
beq $s4, 10, row1digitnw
li $t0, 10
addi $s3, $s3, -48
addi $s4, $s4, -48
mul $s3, $s3, $t0
add $s3, $s3, $s4 #compute num_row into s3
j computecol.1nw

row1digitnw:
addi $s3, $s3, -48 #compute num_row into s3
j computecol.2nw

computecol.1nw:
lbu $s4, 3($s0)
lbu $s5, 4($s0)
beq $s5, 10, col1digit.1nw
li $t0, 10
addi $s4, $s4, -48
addi $s5, $s5, -48
mul $s4, $s4, $t0
add $s4, $s4, $s5 #compute num_col into s4
addi $s0, $s0, 6
j nw.start

computecol.2nw:
lbu $s4, 2($s0)
lbu $s5, 3($s0)
beq $s5, 10, col1digit.2nw
li $t0, 10
addi $s4, $s4, -48
addi $s5, $s5, -48
mul $s4, $s4, $t0
add $s4, $s4, $s5 #compute num_col into s4
addi $s0, $s0, 5
j nw.start

col1digit.1nw:
addi $s4, $s4, -48
addi $s0, $s0, 5
j sw.start

col1digit.2nw:
addi $s4, $s4, -48
addi $s0, $s0, 4

nw.start:
li $s1, 0 #row loop var
li $s5, 0 #col loop var
li $s2, 0 #count of chars in each row
move $s6, $a1
addi $s3, $s3, 1
beq $s6, 'X', nw.firloop
beq $s6, 'O', nw.firloop
j nw.inv

nw.firloop:
beq $s1, $s4, nw.inv
nw.secloop:
beq $s5, $s3, nw.nextrow
move $a1, $s5
move $a2, $s1


addi $sp, $sp, -44
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 20($sp)
sw $s6, 24($sp)
sw $ra, 28($sp)
sw $a1, 32($sp)
sw $a2, 36($sp)
sw $a0, 40($sp)
jal get_slot
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $s6, 24($sp)
lw $ra, 28($sp)
lw $a1, 32($sp)
lw $a2, 36($sp)
lw $a0, 40($sp)
addi $sp, $sp, 44



bne $v0, $s6, nw.nextcol


nw.thirdloop:


beq $s2, 4, nw.finish
addi $a1, $a1, 1
addi $a2, $a2, 1

addi $sp, $sp, -40
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 20($sp)
sw $s6, 24($sp)
sw $ra, 28($sp)
sw $a1, 32($sp)
sw $a2, 36($sp)
sw $a0, 40($sp)
jal get_slot
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $s6, 24($sp)
lw $ra, 28($sp)
lw $a1, 32($sp)
lw $a2, 36($sp)
addi $sp, $sp, 40

beq $v0, -1, nw.nextcol
bne $v0, $s6, nw.nextcol
addi $s2, $s2, 1
j nw.thirdloop


nw.nextcol:
li $s2, 0
addi $s5, $s5, 1
j nw.firloop

nw.nextrow:
li $s5, 0
li $s2, 0
addi $s1, $s1, 1
j nw.firloop

nw.finish:
move $v0, $s5
move $v1, $s1
j nw.end

nw.inv1:
li $v0, 99
li $v1, 99
j nw.end

nw.inv:
li $v0, -1
li $v1, -1
j nw.end

nw.end:
    jr $ra
####################################################################################################################################
simulate_game:
li $s7, 0 #game_over
addi $sp, $sp, -20
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
sw $a3, 12($sp)
sw $s7, 16($sp)
jal load_board
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
lw $a3, 12($sp)
lw $s7, 16($sp)
addi $sp, $sp, 20

beq $v0, -1, sim.noboard
move $s0, $a0 #board
move $s1, $a2 #turns
move $s2, $a3 #num of turns 
li $s3, 0 #num of turns so far

strlen:
li $s4, 0 #counter for string length

loop.string.length:
lbu $t0, 0($a2) #loads first char 
beqz $t0, strlen.end #if end of string go to end
addi $s4, $s4, 1 #increment string length
addi $a2, $a2, 1 #increment string pointer
j loop.string.length

strlen.end:
li $t1, 5
div $s4, $t1
mflo $s4 #turns_length
li $s5, 0 #turn_number

sim.loop:
beq $s7, 1, sim.finish
beq $s3, $s2, sim.finish
beq $s5, $s4, sim.finish
lbu $t0, 0($s1) #character
lbu $t1, 1($s1) #row
bne $t1, '0', twodigitrow
lbu $t1, 2($s1)
addi $t1, $t1, -48
gotrow:
lbu $t2, 3($s1) #col
bne $t2, '0', twodigitcol
lbu $t2, 4($s1)
addi $t2, $t2, -48
gotcol:
move $a3, $t0
move $a2, $t2
move $a1, $t1

addi $sp, $sp, -44
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 20($sp)
sw $s7, 24($sp)
sw $a0, 28($sp)
sw $a1, 32($sp)
sw $a2, 36($sp)
sw $a3, 40($sp)
jal place_piece
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $s7, 24($sp)
lw $a0, 28($sp)
lw $a1, 32($sp)
lw $a2, 36($sp)
lw $a3, 40($sp)
addi $sp, $sp, 44

beq $v0, -1, skipturn

addi $sp, $sp, -44
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 20($sp)
sw $s7, 24($sp)
sw $a0, 28($sp)
sw $a1, 32($sp)
sw $a2, 36($sp)
sw $a3, 40($sp)
jal check_horizontal_capture
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $s7, 24($sp)
lw $a0, 28($sp)
lw $a1, 32($sp)
lw $a2, 36($sp)
lw $a3, 40($sp)
addi $sp, $sp, 44

bne $v0, -1, winner

addi $sp, $sp, -44
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 20($sp)
sw $s7, 24($sp)
sw $a0, 28($sp)
sw $a1, 32($sp)
sw $a2, 36($sp)
sw $a3, 40($sp)
jal check_vertical_capture
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $s7, 24($sp)
lw $a0, 28($sp)
lw $a1, 32($sp)
lw $a2, 36($sp)
lw $a3, 40($sp)
addi $sp, $sp, 44

bne $v0, -1, winner

addi $sp, $sp, -44
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 20($sp)
sw $s7, 24($sp)
sw $a0, 28($sp)
sw $a1, 32($sp)
sw $a2, 36($sp)
sw $a3, 40($sp)
jal check_sw_ne_diagonal_winner
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $s7, 24($sp)
lw $a0, 28($sp)
lw $a1, 32($sp)
lw $a2, 36($sp)
lw $a3, 40($sp)
addi $sp, $sp, 44

bne $v0, -1, winner

addi $sp, $sp, -44
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 20($sp)
sw $s7, 24($sp)
sw $a0, 28($sp)
sw $a1, 32($sp)
sw $a2, 36($sp)
sw $a3, 40($sp)
jal check_nw_se_diagonal_winner
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $s7, 24($sp)
lw $a0, 28($sp)
lw $a1, 32($sp)
lw $a2, 36($sp)
lw $a3, 40($sp)
addi $sp, $sp, 44

bne $v0, -1, winner

addi $sp, $sp, -44
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 20($sp)
sw $s7, 24($sp)
sw $a0, 28($sp)
sw $a1, 32($sp)
sw $a2, 36($sp)
sw $a3, 40($sp)
jal game_status
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $s7, 24($sp)
lw $a0, 28($sp)
lw $a1, 32($sp)
lw $a2, 36($sp)
lw $a3, 40($sp)
addi $sp, $sp, 44

addi $s1, $s1, 5
addi $s3, $s3, 1
j sim.loop


winner:
move $v1, $a3
move $v0, $s3
li $s7, 1
j sim.end

skipturn:
addi $s1, $s1, 5
addi $s5, $s5, 1
j sim.loop


twodigitcol:
addi $t2, $t2, -48
li $t9, 10
mul $t2, $t2, $t9
lbu $t3, 4($s1)
add $t2, $t2, $t3
j gotcol

twodigitrow:
addi $t1, $t1, -48
li $t9, 10
mul $t1, $t1, $t9
lbu $t2, 2($s1)
addi $t2, $t2, -48
add $t1, $t1, $t2
j gotrow

sim.finish:
li $v1, -1
move $v0, $s3
j sim.end


sim.noboard:
li $v0, 0
li $v1, -1
j sim.end

sim.end:
    jr $ra
