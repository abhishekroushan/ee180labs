###############################################################################
# File         : lb.S
# Project      : EE180 Lab 2: MIPS
#
# Standards/Formatting:
#   MIPS gas, soft tab, 80 column
#
# Description:
#   Test the functionality of the 'lb' instruction.
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
#    nop #added
#    nop #added
    ori     $t0, $t0, 0x3210
    lui     $t1, 0xde0f
#    nop #added
#    nop #added
    ori     $t1, $t1, 0xbeef
#    nop #added
#    nop #added
    sw      $t1, 0($t0)
#    nop #added
#    nop #added
    lb      $s2, 0($t0)         # 0xffffffde
    lb      $s3, 1($t0)         # 0x0000000f
    lb      $s4, 2($t0)         # 0xffffffbe
    lb      $s5, 3($t0)         # 0xffffffef
    lui     $t2, 0xffff
#    nop #added
#    nop #added
    ori     $t2, $t2, 0xffde
    ori     $t3, $0, 0x0f
    lui     $t4, 0xffff
#    nop #added
#    nop #added
    ori     $t4, $t4, 0xffbe
    lui     $t5, 0xffff
#    nop #added
#    nop #added
    ori     $t5, $t5, 0xffef
    subu    $v1, $t2, $s2
#    nop #added
#    nop #added
    sltiu   $v0, $v1, 1
#    nop #added
    subu    $v1, $t3, $s3
#    nop #added
#    nop #added
    sltiu   $v1, $v1, 1
#    nop #added
#    nop #added
    and     $v0, $v0, $v1
    subu    $v1, $t4, $s4
#    nop #added
#    nop #added
    sltiu   $v1, $v1, 1
#    nop #added
#    nop #added
    and     $v0, $v0, $v1
    subu    $v1, $t5, $s5
#    nop #added
#    nop #added
    sltiu   $v1, $v1, 1
#    nop #added
#    nop #added
    and     $v0, $v0, $v1
#    nop #added
#    nop #added
    sw      $v0, 4($s0)         # Set the test result
    sw      $s1, 0($s0)         # Set 'done'

$done:
    j       $done
    nop

    .end boot
