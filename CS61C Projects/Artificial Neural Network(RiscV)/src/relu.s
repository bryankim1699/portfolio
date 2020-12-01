.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:

    # check if a1 is 0
    blt x0, a1, continue
    addi a1, a1, 78
    j exit2

continue:
    # Prologue
    addi sp, sp, -12
    sw ra, 0(sp)
    sw s1, 4(sp)
    sw s0, 8(sp)

    add s0, a0, x0      # save address of this node in s0
    add s1, a1, x0      # save size of array in s1

    #create counter variable
    add t0, x0, x0

loop_start:
    # check if counter is equal to length
    beq t0, a1, done
    
    lw t1, 0(s0)        # load the value at the adress into a0

    # checking if value at t1 is negative
    bge t1, x0, loop_end        # next iteration of loop

loop_continue:
    mul t1, t1, x0

loop_end:
    sw t1, 0(s0)
    addi t0, t0, 1         # increment the count
    addi s0, s0, 4      # offset the array address by 4
    j loop_start # repeat if we haven't reached the array size yet

done:
    # Epilogue
    lw s0, 8(sp)
    lw s1, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 12

	ret
