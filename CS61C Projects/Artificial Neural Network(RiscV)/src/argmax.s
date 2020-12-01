.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # check if a1 is 0
    blt x0, a1, continue
    addi a1, a1, 77
    j exit2

continue:
    # Prologue
    addi sp, sp, -12
    sw ra, 0(sp)
    sw s1, 4(sp)
    sw s0, 8(sp)
    
    add s0, a0, x0      # save address of this node in s0
    add s1, a1, x0      # save size of array in s1

    # create counter variable
    add t0, x0, x0

    # keep track of index of biggest so far
    add t2, x0, x0

    # keep track of biggest number 
    add t3, x0, x0

loop_start:
    # check if counter is equal to length
    beq t0, a1, done
    
    lw t1, 0(s0)        # load the value at the adress into a0

    # checking if value at t1 is negative
    bge t3, t1, loop_end        # next iteration of loop


loop_continue:
    #set the new max(t3) to current value(t1)
    add t3, t1, x0

    #save the index of our new max 
    add t2, t0, x0

loop_end:
    addi t0, t0, 1         # increment the count
    addi s0, s0, 4      # offset the array address by 4
    j loop_start # repeat if we haven't reached the array size yet
    
done:
    add a0, t2, x0
    # Epilogue
    lw s0, 8(sp)
    lw s1, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 12


    ret
