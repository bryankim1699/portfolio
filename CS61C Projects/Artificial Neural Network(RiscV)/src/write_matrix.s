.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -24
    sw s0 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra 20(sp)

    mv s0, a0       # saves address of filename to s0
    mv s1, a1       # saves address of start of the matrix in memory
    mv s2, a2       # saves number of rows in the matrix
    mv s3, a3       # saves number of cols in the matrix

    # opening the file
    mv a1, s0                   # set a1 to be the filename
    addi a2, x0, 1              # set permission for file to write

    jal fopen

    addi t0, x0, -1
    beq t0, a0, fopen_error     #check for fopen error

    mv s4, a0       # saves file descriptor to use and close later

    #fwrite for rows
    mv a1, s4
    add t0, s2, x0
    addi sp, sp, -4
    sw t0 0(sp)
    add a2, sp, x0
    li a3, 1
    li a4, 4
    
    jal fwrite

    lw t0, 0(sp)
    addi sp, sp, 4

    addi t0, x0, 1
    bne a0 t0 fwrite_error   # check for fwrite error for rows

    #fwrite for cols
    mv a1, s4
    add t0, s3, x0
    addi sp, sp, -4
    sw t0 0(sp)
    add a2, sp, x0
    li a3, 1
    li a4, 4
    
    jal fwrite  

    lw t0, 0(sp)
    addi sp, sp, 4

    addi t0, x0, 1
    bne a0 t0 fwrite_error   # check for fwrite error for cols

    #fwrite for matrix
    mv a1, s4
    mv a2, s1
    mul t0, s2, s3
    mv a3, t0
    addi a4, x0, 4

    addi sp, sp, -4             #storing number of total elements
    sw a3, 0(sp)

    jal fwrite

    lw a3, 0(sp)
    addi sp, sp, 4

    bne a0, a3, fwrite_error    # check for fwrite error for the matrix

    #closing the file
    mv a1, s4                   # put file descriptor to be closed in a1

    jal fclose

    bne a0, x0, fclose_error    # check for fclose error


    # Epilogue
    lw ra 20(sp)
    lw s4 16(sp)
    lw s3 12(sp)
    lw s2 8(sp)
    lw s1 4(sp)
    lw s0 0(sp)
    addi sp, sp, 24


    ret

fopen_error:
    addi a1, x0, 93
    j exit2

fwrite_error:
    addi a1, x0, 94
    j exit2

fclose_error:
    addi a1, x0, 95
    j exit2
