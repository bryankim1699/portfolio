.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    #checks for errors
    addi t5, x0, 1
    blt a2, t5, errorlength     # check if length of vectors is less than 1
    blt a3, t5, errorstride     # check if stride of v0 is less than 1
    blt a4, t5, errorstride     # check if stride of v1 is less than 1

    # Prologue
    addi sp, sp, -24
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    
    add s0, a0, x0      # save address start to v0
    add s1, a1, x0      # save address start to v1
    add s2, a2, x0      # save length of vectors
    add s3, a3, x0      # save stride of v0
    add s4, a4, x0      # save stride of v1

    # create counter variable
    add t0, x0, x0

    # keep track sum so far
    add t3, x0, x0

    # keep track multiplication @ ith level  
    add t4, x0, x0

loop_start:
    # check if counter is equal to length
    beq t0, a2, done
    
    lw t1, 0(s0)        # load the value at the adress into t1
    lw t2, 0(s1)        # load the value at the adress into t2
    
    mul t4, t1, t2      # multipying at ith level
    add t3, t3, t4      # sum so far at ith level

loop_end:
    addi t0, t0, 1         # increment the count

    slli t6, s3, 2
    add s0, s0, t6         # offset the array(v0) address by stride
    slli t6, s4, 2
    add s1, s1, t6         # offset the array(v1) address by stride

    j loop_start           # repeat if we haven't reached the array size yet

done:
    add a0, t3, x0
    # Epilogue
    lw s4, 20(sp)
    lw s3, 16(sp)
    lw s2, 12(sp)
    lw s1, 8(sp)
    lw s0, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 24
    
    ret

errorlength:
    addi a1, x0, 75
    j exit2

errorstride:
    addi a1, x0, 76
    j exit2

    
