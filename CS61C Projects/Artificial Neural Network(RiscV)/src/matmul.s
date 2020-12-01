.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    addi t5, x0, 1
    blt a1, t5, errorm0     # check if # of m0 rows is less than 1
    blt a2, t5, errorm0     # check if # of m0 cols is less than 1
    blt a4, t5, errorm1     # check if # of m1 rows is less than 1
    blt a5, t5, errorm1     # check if # of m1 cols is less than 1
    bne a2, a4, errormatch  # check if m0 cols and m1 rows match

    # Prologue
    addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)

    add s0, a0, x0      # save address start to m0
    add s1, a1, x0      # save # of rows of m0
    add s2, a2, x0      # save # of cols of m0
    add s3, a3, x0      # save address start of m1
    add s4, a4, x0      # save # of rows of m1
    add s5, a5, x0      # save # of cols of m1
    add s6, a6, x0      # save address start of d


    # create counter variable for row of m0
    add t0, x0, x0

outer_loop_start:
    # check if counter is equal to length
    beq t0, s1, done
    # create counter variable for col of m1
    add t1, x0, x0
    # temporary variable for cols
    add t3, s3, x0

inner_loop_start:

    # check if counter is equal to length
    beq t1, s5, outer_loop_end

    # a0 to be taken would be array of m0
    add a0, s0, x0

    # a1 to be taken would be array of m1
    add a1, t3, x0

    # a2 cols of m0/rows of m1, which are equal
    add a2, s2, x0

    # a3 stride for m0 would be 1 because it is already row major order
    add a3, t5, x0

    # a4 stride for m1 would be cols of m1
    add a4, x0, s5

    addi sp, sp, -16
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t5, 8(sp)
    sw t3, 12(sp)

    jal ra dot

    lw t3, 12(sp)
    lw t5, 8(sp)
    lw t1, 4(sp)
    lw t0, 0(sp)
    addi sp, sp, 16

    sw a0, 0(s6)     #storing returned value in D matrix array

inner_loop_end:
    addi t1, t1, 1      # incrementing counter by 1
    addi t3, t3, 4      # incrementing element to be traversed from in m1(col by col)
    addi s6, s6, 4      # incrementing element to be put in for D, new matrix, by 1

    j inner_loop_start

outer_loop_end:
    addi t0, t0, 1      # incrementing counter by 1
    slli t2, s2, 2      # creating a counter to increment m0 by number of cols in m0
    add s0, s0, t2      # going through m0 one row at a time

    j outer_loop_start

done:
    # Epilogue
    lw s6, 28(sp)
    lw s5, 24(sp)
    lw s4, 20(sp)
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 32
       
    ret

errorm0:
    addi a1, x0, 72
    j exit2

errorm1:
    addi a1, x0, 73
    j exit2

errormatch:
    addi a1, x0, 74
    j exit2
