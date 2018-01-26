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
.globl mergesort
.globl merge
.globl arrcpy
.globl program
.globl check
.globl lpos_exit
.globl rpos_exit
.globl lpos_cond
.globl while
.globl exit_mergesort
.globl temp_bp
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
    move    $a0, $s2            # set up the argument for sbrk
    syscall
    move    $s3, $v0            # the addr of allocated memory #$s3 has temp_array allocated mem address

check:    
    move $a0,$s0		#allocated array address
    move $a1,$s1		#number of elements
    move $a2,$s3		#temp array address

   #push regs
    sw $s0,0($sp)
    sw $s1,4($sp)
    sw $s2,8($sp)
    sw $s3,12($sp)

    jal mergesort

temp_bp: 
    lw $s0,0($sp)
    lw $s1,4($sp)
    lw $s2,8($sp)
    lw $s3,12($sp)

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
    addi $sp,$sp,-32
    sw $ra,0($sp)
    sw $s0,4($sp)
    sw $s1,8($sp)
    sw $s2,12($sp)

   #check if n<2
    addi $t6,$zero,2#$t6=2
    slt $t7,$a1,$t6
    bne $t7,$zero,exit_mergesort

    addi $s0,$a0,0
    addi $s1,$a1,0
    addi $s2,$a2,0
    
    srl $t0,$s1,1 #$t0=mid=n/2
    #addi $a1,$t0,0
    move $a0,$s0
    move $a1,$t0
    move $a2,$s2
    jal mergesort
    
  
    sll $t0,$t0,2   #4*$t0 
    add $a0,$s0,$t0 #array+mid
    srl $t0,$t0,2   #restore mul
    sub $a1,$s1,$t0 #n-mid
    addi $a2,$s2,0
    jal mergesort
   
    addi $a0,$s0,0
    addi $a1,$s1,0
    addi $a2,$s2,0
    move $a3,$t0
program:
    jal merge 

exit_mergesort: 
    lw $ra,0($sp)
    lw $s0,4($sp)
    lw $s1,8($sp)
    lw $s2,12($sp)
    addi $sp,$sp,32
    #$v0 has the result to pass as return value

    jr      $ra

merge:
    addi $sp,$sp,-32
   
    sw $ra,0($sp)
    sw $s0,4($sp)
    sw $s1,8($sp)
    sw $s2,12($sp)
    sw $s3,16($sp)

    #storing args
    addi $s0,$a0,0  
    addi $s1,$a1,0  
    addi $s2,$a2,0  
    addi $s3,$a3,0  

    #temp args 
    addi $t0,$zero,0 #$t0=tpos   
    addi $t1,$zero,0 #$t1=lpos
    addi $t2,$zero,0 #$t2=rpos

    sub $t3,$s1,$s3 #$t3=rn
    sll $s3,$s3,2
    add $t4,$s0,$s3 #$t4=rarr 
    srl $s3,$s3,2

    slt $t5,$t1,$s3 #lpos<mid
    slt $t6,$t2,$t3 #rpos<rn
    and $t7,$t5,$t6 # and
    beq $t7,$zero,endwhile
while:
 
    #if else
    sll $t1,$t1,2 #for addr mult by 4
    sll $t2,$t2,2
    add $t5,$s0,$t1#*array[lpos]
    add $t6,$t4,$t2#*raar[rpos]
    srl $t1,$t1,2 #restore mult by 4
    srl $t2,$t2,2
    lw $s5,0($t5)
    lw $s6,0($t6)
    slt $t7,$s5,$s6#if comparision
    beq $t7,$zero,else_st

if_st:
    sll $t1,$t1,2 #for addr mult by 4
    add $t5,$t1,$s0
    srl $t1,$t1,2 #restore mult by 4
    sll $t0,$t0,2	#for addr mul by 4
    add $t6,$t0,$s2
    srl $t0,$t0,2 #restore mul by 4
    lw $t7,0($t5)
    sw $t7,0($t6)
    addi $t1,$t1,1 #lpos++
    addi $t0,$t0,1#tpos++
    j end_ifelse
else_st:
    sll $t2,$t2,2	#for addr mul by 4
    add $t5,$t2,$t4
    srl $t2,$t2,2	#restore mul by 4
    sll $t0,$t0,2	#for addr mul by 4
    add $t6,$t0,$s2
    srl $t0,$t0,2	#restore mul by 4
    lw $t7,0($t5)
    sw $t7,0($t6)
    addi $t0,$t0,1
    addi $t2,$t2,1

end_ifelse:

    slt $t5,$t1,$s3 #lpos<mid
    slt $t6,$t2,$t3 #rpos<rn
    and $t7,$t5,$t6 # and
    bne $t7,$zero,while
    
endwhile:

    slt $t5,$t1,$s3
    bne $t5,$zero,lpos_cond
    j lpos_exit
lpos_cond:
   
    sll $t0,$t0,2 
    add $a0,$s2,$t0 #*tmp_array+tpos
    srl $t0,$t0,2 
    sll $t1,$t1,2 
    add $a1,$s0,$t1 #*array+lpos
    srl $t1,$t1,2 
    sub $a2,$s3,$t1 #mid-lpos
    jal arrcpy

lpos_exit:

    slt $t6,$t2,$t3
    bne $t6,$zero, rpos_cond
    j rpos_exit
rpos_cond:
   
    sll $t0,$t0,2 
    add $a0,$s2,$t0 #tmp_array+tpos
    srl $t0,$t0,2
    sll $t2,$t2,2 
    add $a1,$t4,$t2 
    srl $t2,$t2,2 
    sub $a2,$t3,$t2
    jal arrcpy
rpos_exit:
 
    addi $a0,$s0,0
    addi $a1,$s2,0
    addi $a2,$s1,0
    jal arrcpy


    lw $ra,0($sp)
    lw $s0,4($sp)
    lw $s1,8($sp)
    lw $s2,12($sp)
    lw $s3,16($sp)
    addi $sp,$sp,32
    jr      $ra               

arrcpy:

    addi $sp,$sp,-32
    sw $ra,0($sp) 
    sw $s0,4($sp)
    sw $s1,8($sp)
    sw $s2,12($sp)
    sw $s3,16($sp)
   
    addi $s0,$a0,0   
    addi $s1,$a1,0   
    addi $s2,$a2,0   
 
    addi $s3,$zero,0	#i=0
    slt $t5,$s3,$s2
    beq $t5,$zero,end_jump
jump:
    sll $s3,$s3,2 	#for addr mul by 4
    add $t6,$s1,$s3
    lw $t7,0($t6)
    add $t6,$s0,$s3
    srl $s3,$s3,2	#restore mul by 4
    sw $t7,0($t6)    

    addi $s3,$s3,1
    slt $t5,$s3,$s2
    bne $t5,$zero,jump
    
end_jump:
    lw $ra,0($sp) 
    lw $s0,4($sp)
    lw $s1,8($sp)
    lw $s2,12($sp)
    lw $s3,16($sp)
    addi $sp,$sp,32 
   
    jr      $ra
