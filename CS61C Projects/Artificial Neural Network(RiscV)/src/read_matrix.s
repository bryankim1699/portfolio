.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)


    mv s0, a0       # save address of filename to s0
    mv s1, a1       # save number of rows s1
    mv s2, a2       # save number of cols s2
    li s4, 4        # save number of bytes to be read from file for rows/cols

    # opening the file
    mv a1, s0       # set a1 to be the filename
    mv a2, x0       # set permission for file to read
    
    jal fopen  

    addi t0, x0, -1
    beq t0 a0 fopen_error   # check for fopen error

    mv s3, a0         # save file descriptor to use and close later

    #fread on rows
    mv a1, s3
    mv a2, s1
    add a3, s4, x0

    jal fread
    
    bne a0 s4 fread_error   # check for fread error for rows

    #fread on cols
    mv a1, s3
    mv a2, s2 
    add a3, s4, x0
    
    jal fread
    
    bne a0 s4 fread_error   #check for fread error for cols

    #allocating memory for the matrix
    lw t3, 0(s1)
    lw t4, 0(s2)
    mul t1, t3, t4      # number of elements to be read
    slli a3, t1, 2      # number of bytes to be read

    mv a0, a3           # allocating memory

    addi sp, sp, -4
    sw a3, 0(sp)

    jal ra malloc

    lw a3, 0(sp)
    addi sp, sp, 4

    beq a0 x0 malloc_error   #check for malloc error

    mv a2, a0          # allocated space for the matrix in array
    mv a1, s3
    
    addi sp, sp, -8
    sw a3, 0(sp)
    sw a2, 4(sp)

    jal fread

    lw a2, 4(sp)
    lw a3, 0(sp)
    addi sp, sp, 8

    bne a0 a3 fread_error   # check for fread error for matrix

    mv a1, s3      # file descriptor returned by fopen to be closed
    
    addi sp, sp, -4
    sw a2, 0(sp)

    jal fclose

    lw a2, 0(sp) 
    addi sp, sp, 4
    
    bne a0 x0 fclose_error      #check for fclose error
    
    mv a0, a2      # return pointer to the matrix in array

    # Epilogue
    lw ra 20(sp)
    lw s4 16(sp)
    lw s3 12(sp)
    lw s2 8(sp)
    lw s1 4(sp)
    lw s0 0(sp)
    addi sp, sp, 24


    ret

malloc_error:
    addi a1, x0, 88
    j exit2

fopen_error:
    addi a1, x0, 90
    j exit2

fread_error:
    addi a1, x0, 91
    j exit2

fclose_error:
    addi a1, x0, 92
    j exit2
