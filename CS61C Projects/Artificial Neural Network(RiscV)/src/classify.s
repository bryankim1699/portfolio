.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # argument error check
    addi t0, x0, 5
    bne a0, t0, incorrect_args_error    

    # PROLOGUE
    addi sp, sp, -52
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw s10, 40(sp)
    sw s11, 44(sp)
    sw ra, 48(sp)


	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load argv into s11
    mv s11, a1

    # Load print_classification
    mv s10, a2

    # Load pretrained m0
    lw a0, 4(s11)
    
    addi sp, sp, -8
    sw a1, 0(sp)
    sw a2, 4(sp)
   	mv a1, sp
    addi t0, sp, 4
    mv a2, t0
    
    jal read_matrix
    
    lw a2, 4(sp)
    lw a1, 0(sp)
    addi sp, sp, 8

    mv s0, a0           # storing the matrix for m0
    mv s1, a1           # storing the rows for m0
    mv s2, a2           # storing the cols for m0

    # Load pretrained m1
    lw a0, 8(s11)
    
    addi sp, sp, -8
    sw a1, 0(sp)
    sw a2, 4(sp)
    mv a1, sp
    addi t0, sp, 4
    mv a2, t0
    
    jal read_matrix
    
    lw a2, 4(sp)
    lw a1, 0(sp)
    addi sp, sp, 8

    mv s3, a0           # storing the matrix for m1
    mv s4, a1           # storing the rows for m1
    mv s5, a2           # storing the cols for m1

    # Load input matrix
	lw a0, 12(s11)
    
	addi sp, sp, -8
    sw a1, 0(sp)
    sw a2, 4(sp)
    mv a1, sp
    addi t0, sp, 4
    mv a2, t0
    
    jal read_matrix
    
    lw a2, 4(sp)
    lw a1, 0(sp)
    addi sp, sp, 8

    mv s6, a0           # storing the matrix for input
    mv s7, a1           # storing the rows for input
    mv s8, a2           # storing the cols for input


    # Load file output path
    lw a0, 16(s11)
    mv s9, a0


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input

    mul a0, s1, s8            # multiplying rows of m0 and cols of input to get number of elements in m0 * input   \ 
    slli a0, a0, 2
    
    jal malloc

    beq a0, x0, malloc_error          #check for malloc error

    add a6, a0, x0                   # allocated space for return argument d

    mv a0, s0                       # setting m0 to first matrix
    mv a1, s1                       # rows of m0
    mv a2, s2                       # cols of m0
    mv a3, s6                       # setting input to second matrix
    mv a4, s7                       # rows of input
    mv a5, s8                       # cols of input
    
    jal matmul
    
    addi sp, sp, -4 
    sw a6, 0(sp)

    mv a0, s0
    jal free                        # free matrix m0 memory

    mv a0, s6
    jal free                        # free matrix input memory

    lw a6, 0(sp)
    addi sp, sp, 4
    
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    
    mul a1, s1, s8                   # multipling rows of m0 and cols of input to get number of elements in m0 * input  
    mv a0, a6 

    jal relu 

    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    mv s0, a0                       # store relu'd product to be free'd
    mv a3, s0                       # setting ReLU(m0 * input) a0 to second matrix

    mul a0, s4, s8                  # multiplying rows of m1 and cols of relu'd product to get number of elements in m1 * ReLU(m0 * input)
    slli a0, a0, 2  

    addi sp, sp, -4 
    sw a3, 0(sp)

    jal malloc   

    lw a3, 0(sp)
    addi sp, sp, 4    

    beq a0 x0 malloc_error          #check for malloc error                   

    add a6, a0, x0                  # allocated space for return argument d

    mv a0, s3                    # setting m1 to first matrix
    mv a1, s4                    # rows of m1
    mv a2, s5                    # cols of m1
    mv a4, s1                    # rows of ReLU(m0 * input)
    mv a5, s8                    # cols of ReLU(m0 * input)

    jal matmul

    addi sp, sp, -4 
    sw a6, 0(sp)

    mv a0, s0
    jal free                       # free matrix ReLU(m0 * input) memory

    mv a0, s3
    jal free                       # free matrix m1

    lw a6, 0(sp)
    addi sp, sp, 4

    mv s0, a6                      # save end matrix m1 * ReLU(m0 * input) to be read
    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

    mv a1, s0                    # saving product of 3. to be written
    mv a0, s9                    # pointer to filename to output to
    mv a2, s4                    # rows of product of 3.
    mv a3, s8                    # cols of product of 3.

    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax

    mv a0, s0
    mul a1, s4, s8

    jal argmax

    mv s3, a0                   # saving classification(a0)

    mv a0, s0
    jal free                    # freeing final matrix m1 * ReLU(m0 * input)

    # Print classification
    
    bne s10 x0 skip_print_move
    mv a1, s3
    jal print_int

    # Print newline afterwards for clarity
    li a1, '\n'
    jal print_char

skip_print_move:
    #Epilogue
    lw ra, 48(sp)
    lw s11, 44(sp)
    lw s10, 40(sp)
    lw s9, 36(sp)
    lw s8, 32(sp)
    lw s7, 28(sp)
    lw s6, 24(sp)
    lw s5, 20(sp)
    lw s4, 16(sp)
    lw s3, 12(sp)
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 52

    ret
    
malloc_error:
    addi a1, x0, 88
    j exit2

incorrect_args_error:
    addi a1, x0, 89
    j exit2

