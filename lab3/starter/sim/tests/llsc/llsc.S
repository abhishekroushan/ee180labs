###############################################################################
# File         : lw.S
# Project      : EE180 Lab 2: MIPS
#
# Standards/Formatting:
#   MIPS gas, soft tab, 80 column
#
# Description:
#   Test the functionality of the 'lw' instruction.
#
###############################################################################


    .section .boot, "x"
    .balign 4
    .set    noreorder
    .global boot
    .ent    boot
boot:
    lui     $s0, 0x8002         # Load the base address of the status/test registers
    ori     $s1, $0, 1          # Prepare the 'done' status
    lui     $t0, 0              # Load some valid address 0x00003210 to register $t0
    ori     $t0, $t0, 0x3210
    sw      $0, 0($t0)
    ori     $t1, $0, 2
    sw      $t1, 0($t0)
    ll      $t2, 0($t0)
    #comment the below line for ll followed by sc test
    addi    $t2,$t2,1
    sc      $t2, 8($s0)
    nop #added
    nop #added       
    #comment the below line for ll followed by sc test
    addi     $t2,$t2,1  
    sw      $t2, 4($s0)         # Set the test result
    sw 	    $s1, 0($s0)         # Set 'done'

$done:
    j       $done
    nop

    .end boot
