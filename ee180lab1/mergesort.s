#==============================================================================
# File:         mergesort.s (PA 1)
#
# Description:  Skeleton for assembly mergesort routine. 
#
#       To complete this assignment, add the following functionality:
#
#       1. Call mergesort. (See mergesort.c)
#          Pass 3 arguments:
#
#          ARG 1: Pointer to the first element of the array
#          (referred to as "nums" in the C code)
#
#          ARG 2: Number of elements in the array
#
#          ARG 3: Temporary array storage
#                 
#          Remember to use the correct CALLING CONVENTIONS !!!
#          Pass all arguments in the conventional way!
#
#       2. Mergesort routine.
#          The routine is recursive by definition, so mergesort MUST 
#          call itself. There are also two helper functions to implement:
#          merge, and arrcpy.
#          Again, make sure that you use the correct calling conventions!
#
#==============================================================================

.data
HOW_MANY:   .asciiz "How many elements to be sorted? "
ENTER_ELEM: .asciiz "Enter next element: "
ANS:        .asciiz "The sorted list is:\n"
SPACE:      .asciiz " "
EOL:        .asciiz "\n"

.text
.globl main

#==========================================================================
main:
#==========================================================================

    #----------------------------------------------------------
    # Register Definitions
    #----------------------------------------------------------
    # $s0 - pointer to the first element of the array
    # $s1 - number of elements in the array
    # $s2 - number of bytes in the array
    #----------------------------------------------------------
    
    #---- Store the old values into stack ---------------------
    addiu   $sp, $sp, -32
    sw      $ra, 28($sp)

    #---- Prompt user for array size --------------------------
    li      $v0, 4              # print_string
    la      $a0, HOW_MANY       # "How many elements to be sorted? "
    syscall         
    li      $v0, 5              # read_int
    syscall 
    move    $s1, $v0            # save number of elements

    #---- Create dynamic array --------------------------------
    li      $v0, 9              # sbrk
    sll     $s2, $s1, 2         # number of bytes needed
    move    $a0, $s2            # set up the argument for sbrk
    syscall
    move    $s0, $v0            # the addr of allocated memory


    #---- Prompt user for array elements ----------------------
    addu    $t1, $s0, $s2       # address of end of the array
    move    $t0, $s0            # address of the current element
    j       read_loop_cond

read_loop:
    li      $v0, 4              # print_string
    la      $a0, ENTER_ELEM     # text to be displayed
    syscall
    li      $v0, 5              # read_int
    syscall
    sw      $v0, 0($t0)     
    addiu   $t0, $t0, 4

read_loop_cond:
    bne     $t0, $t1, read_loop 

    #---- Call Mergesort ---------------------------------------
    # ADD YOUR CODE HERE! 

    #---- Create temp array --------------------------------
    li      $v0, 9              # sbrk
    sll     $s2, $s1, 2         # number of bytes needed
    move    $a1, $s2            # set up the argument for sbrk
    syscall
    move    $s3, $v0            # the addr of allocated memory #$s3 has temp_array allocated mem address
    
    move $a0,$s0		#allocated array address
    move $a1,$s1		#number of elements
    move $a2,$s3		#temp array address

   #push regs
    sw $a0,0($sp)
    sw $a1,4($sp)
    sw $a2,8($sp)

    jal mergesort
    
    lw $a0,0($sp)
    lw $a1,4($sp)
    lw $a2,8($sp)

return:
    # You must use a syscall to allocate
    # temporary storage (temp_array in the C implementation)
    # then pass the three arguments in $a0, $a1, and $a2 before
    # calling mergesort

    #---- Print sorted array -----------------------------------
    li      $v0, 4              # print_string
    la      $a0, ANS            # "The sorted list is:\n"
    syscall

    #---- For loop to print array elements ----------------------
    
    #---- Iniliazing variables ----------------------------------
    move    $t0, $s0            # address of start of the array
    addu    $t1, $s0, $s2       # address of end of the array
    j       print_loop_cond

print_loop:
    li      $v0, 1              # print_integer
    lw      $a0, 0($t0)         # array[i]
    syscall
    li      $v0, 4              # print_string
    la      $a0, SPACE          # print a space
    syscall            
    addiu   $t0, $t0, 4         # increment array pointer

print_loop_cond:
    bne     $t0, $t1, print_loop

    li      $v0, 4              # print_string
    la      $a0, EOL            # "\n"
    syscall          

    #---- Exit -------------------------------------------------
    lw      $ra, 28($sp)
    addiu   $sp, $sp, 32
    jr      $ra


# ADD YOUR CODE HERE! 

mergesort:
   #stack pointer operations left
   #push pop for registers contents left

   #mergesort args stack store
    addi $sp,$sp,-16
    sw $ra,0($sp)
    sw $s0,4($sp)
    sw $s1,8($sp)
    sw $s2,12($sp)

   # move $t3,$a0
   # move $t4,$a1
   #check if n<2
    addi $t6,$zero,2
    slt $t7,$a1,$t6
    bne $t7,$zero,exit_merge

    addi $s0,$a0,0
    addi $s1,$a1,0
    addi $s2,$a2,0
    
    srl $t0,$s1,1 #mid=n/2
    addi $a1,$t0,0
    jal mergesort
    
   
    add $a0,$s0,$t0 #array+mid
    sub $a1,$s1,$t0 #n-mid
    addi $a2,$s2,0
    jal mergesort
   
    addi $a0,$s0,0
    addi $a1,$s1,0
    addi $a2,$s2,0
    move $a3,$t0
    jal merge 

exit_merge: 
    lw $ra,0($sp)
    lw $s0,4($sp)
    lw $s1,8($sp)
    lw $s2,12($sp)
    addi $sp,$sp,16
    #$v0 has the result to pass as return value

    jr      $ra

merge:
    addi $sp,$sp,-20
   
    sw $ra,0($sp)
    sw $s0,4($sp)
    sw $s1,8($sp)
    sw $s2,12($sp)
    sw $s3,16($sp)

    addi $s0,$a0,0  
    addi $s1,$a1,0  
    addi $s2,$a2,0  
    addi $s3,$a3,0  
 
    addi $t0,$t0,0 #tpos   
    addi $t1,$t1,0 #lpos
    addi $t2,$t2,0 #rpos

    sub $t3,$s1,$s3 #rn
    add $t4,$s0,$s3 #rarr 

while:
 
    #if else
    add $t5,$s0,$t1#array[lpos]
    add $t6,$t4,$t2#raar[rpos]
    slt $t7,$t5,$t6#if comparision
    beq $t7,$zero,if_st

if_st:
    addi $t5,$t1,1 #lpos++
    add $t5,$t5,$s0
    addi $t6,$t0,1#tpos++
    add $t6,$t6,$s2
    lw $t7,0($t5)
    sw $t7,0($t6)
    j end_ifelse
else_st:
    addi $t5,$t2,1
    add $t5,$t5,$t4
    addi $t6,$t0,1
    add $t6,$t6,$s0
    lw $t7,0($t5)
    sw $t7,0($t6)

end_ifelse:

    slt $t5,$t1,$s3 #lpos<mid
    slt $t6,$t2,$t3 #rpos<rn
    and $t7,$t5,$t6 #logical and
    bne $t7,$zero,while
    

    slt $t5,$t1,$s3
    bne $t5,$zero,lpos_cond
    j lpos_exit
lpos_cond:
    
    add $a0,$s2,$t0 #tmp_array+tpos
    add $a1,$s0,$t1 #array+lpos
    sub $a2,$s3,$t1 #mid-lpos
    jal arrcpy

lpos_exit:

    slt $t6,$t2,$t3
    bne $t6,$zero, rpos_cond
    j rpos_exit
rpos_cond:
    
    add $a0,$s2,$t0 #tmp_array+tpos
    add $a1,$t4,$t2 
    sub $a2,$t3,$t2
    jal arrcpy
rpos_exit:
 
    addi $a0,$s0,0
    addi $a1,$s2,0
    addi $a2,$s1,0


    lw $ra,0($sp)
    lw $s0,4($sp)
    lw $s1,8($sp)
    lw $s2,12($sp)
    lw $s3,16($sp)
    addi $sp,$sp,20
    jr      $ra               

arrcpy:

    addi $sp,$sp,-12
    sw $ra,0($sp) 
    
    addi $t0,$t0,0	#i=0
jump:
    add $t2,$a1,$t0
    lw $t3,0($t2)
    add $t2,$a0,$t0
    sw $t3,0($t2)    

    addi $t0,$t0,1
    slt $t1,$t0,$a2
    bne $t1,$zero,jump
    
    lw $ra,0($sp) 
    addi $sp,$sp,12 
   
    jr      $ra
