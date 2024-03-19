#matadd_10x10.s
.data
    mat1: .word 7, 18, 17, 7, 15, 12, 3, 17, 4, 12, 15, 3, 9, 2, 16, 6, 9, 2, 2, 18, 17, 17, 3, 20, 7, 13, 12, 12, 17, 19, 11, 3, 12, 11, 20, 5, 8, 20, 9, 7, 13, 5, 13, 6, 1, 12, 17, 6, 5, 18, 17, 3, 13, 15, 10, 12, 19, 13, 16, 12, 7, 17, 17, 2, 12, 10, 16, 16, 6, 19, 18, 6, 8, 9, 5, 10, 8, 14, 13, 3, 1, 18, 13, 16, 11, 20, 4, 13, 11, 1, 16, 7, 3, 5, 1, 9, 13, 2, 19, 2
    mat2: .word 11, 12, 5, 15, 20, 5, 16, 4, 8, 7, 14, 15, 14, 6, 2, 15, 2, 14, 7, 1, 19, 1, 3, 20, 13, 11, 9, 12, 12, 19, 12, 4, 3, 2, 7, 13, 10, 12, 9, 6, 18, 5, 14, 20, 14, 2, 15, 8, 9, 19, 20, 19, 6, 2, 4, 13, 1, 10, 19, 15, 20, 9, 7, 12, 15, 11, 14, 9, 11, 12, 17, 20, 17, 15, 16, 1, 3, 14, 8, 11, 3, 9, 10, 12, 13, 15, 6, 10, 8, 13, 5, 13, 13, 17, 4, 6, 10, 15, 18, 11
    mat_expected: .word 18, 30, 22, 22, 35, 17, 19, 21, 12, 19, 29, 18, 23, 8, 18, 21, 11, 16, 9, 19, 36, 18, 6, 40, 20, 24, 21, 24, 29, 38, 23, 7, 15, 13, 27, 18, 18, 32, 18, 13, 31, 10, 27, 26, 15, 14, 32, 14, 14, 37, 37, 22, 19, 17, 14, 25, 20, 23, 35, 27, 27, 26, 24, 14, 27, 21, 30, 25, 17, 31, 35, 26, 25, 24, 21, 11, 11, 28, 21, 14, 4, 27, 23, 28, 24, 35, 10, 23, 19, 14, 21, 20, 16, 22, 5, 15, 23, 17, 37, 13
    mat_result: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    size: .word 10
.text
init:
    li sp, 0xfffc       # set stack pointer
    la a0, mat_result   # a0 = addr of result matrix
    la a1, mat1         # a1 = addr of matrix 1
    la a2, mat2         # a2 = addr of matrix 2
    la a3, size         # a3 = size of matrices
    lw a3, 0(a3)        # a3 = size
    call matadd         # matadd(matResult, mat1, mat2, size)
    la a0, mat_result   # a0 = addr of result matrix
    la a1, mat_expected # a1 = addr of matrix 3
    la a2, size         # a2 = size of matrices
    lw a2, 0(a2)        # a2 = size
    call testMats       # testMats(matResult, mat3, size)


pass:
    j pass

fail:
    j fail

##################################################################
#  matadd
#  description: adds two matrices and stores the result in a third matrix
#    a0 = addr of result matrix
#    a1 = addr of matrix 1
#    a2 = addr of matrix 2
#    a3 = size of matrices
# register usage: s0, s1, s2, s3, t0, t1, t2, t3, t5, t6, a0, a1, a2
##################################################################
matadd:
    # save context
    addi sp, sp, -52                # decrement stack pointer
    sw ra, 0(sp)                    # save return address
    sw s0, 4(sp)                    # save s0
    sw s1, 8(sp)                    # save s1
    sw s2, 12(sp)                   # save s2
    sw s3, 16(sp)                   # save s3
    sw t0, 20(sp)                   # save t0
    sw t1, 24(sp)                   # save t1
    sw t2, 28(sp)                   # save t2
    sw t3, 32(sp)                   # save t3
    sw t5, 36(sp)                   # save t5
    sw t6, 40(sp)                   # save t6
    sw a0, 44(sp)                   # save a0
    sw a1, 48(sp)                   # save a1
    sw a2, 52(sp)                   # save a2

    mv s0, a0                       # s0 = addr of result matrix
    mv s1, a1                       # s1 = addr of matrix 1
    mv s2, a2                       # s2 = addr of matrix 2
    mv s3, a3                       # s3 = size of matrices

    li t6, 0                        # i = 0
    li t5, 0                        # j = 0

# iterate over rows of matrix 1
ma_i_loop:
    bge t6, s3, matadd_end          # if i >= size, matadd_end
    li t5, 0                        # j = 0
# iterate over columns of matrix 2
ma_j_loop:
    bge t5, s3, ma_i_loop_admin     # if j >= size, ma_i_loop_end
    mv a1, t6                       # a1 = i
    mv a2, s3                       # a2 = size
    call mult                       # mult(i, size)
    add a0, a0, t5                  # a0 = i * size + j
    slli a0, a0, 2                  # a0 = (i * size + j) * 4
    add t0, s1, a0                  # addr of matrix 1[i][j]
    lw t0, 0(t0)                    # t0 = matrix 1[i][k]
    add t1, s2, a0                  # addr of matrix 2[i][j]
    lw t1, 0(t1)                    # t1 = matrix 2[k][j]
    add t2, t0, t1                  # t2 = matrix 1[i][k] + matrix 2[k][j]
    add t3, s0, a0                  # addr of result matrix[i][j]
    sw t2, 0(t3)                    # result matrix[i][j] = matrix 1[i][k] + matrix 2[k][j]

ma_j_loop_admin:
    addi t5, t5, 1                  # increment j
    j ma_j_loop 
ma_i_loop_admin:
    addi t6, t6, 1                  # increment i
    j ma_i_loop

matadd_end:
    # restore context
    lw ra, 0(sp)                    # restore return address
    lw s0, 4(sp)                    # restore s0
    lw s1, 8(sp)                    # restore s1
    lw s2, 12(sp)                   # restore s2
    lw s3, 16(sp)                   # restore s3
    lw t0, 20(sp)                   # restore t0
    lw t1, 24(sp)                   # restore t1
    lw t2, 28(sp)                   # restore t2
    lw t3, 32(sp)                   # restore t3
    lw t5, 36(sp)                   # restore t5
    lw t6, 40(sp)                   # restore t6
    lw a0, 44(sp)                   # restore a0
    lw a1, 48(sp)                   # restore a1
    lw a2, 52(sp)                   # restore a2
    addi sp, sp, 52                 # increment stack pointer
    ret


##################################################################
#  testMatrices
#  description: tests two matrices for equality
#    a0 = addr of matrix 1
#    a1 = addr of matrix 2
#    a2 = size of matrices
# register usage: s0, s1, s2, t5, t6, a0, a1, a2
##################################################################
testMats:
    # save context
    addi sp, sp, -32                # decrement stack pointer
    sw ra, 0(sp)                    # save return address
    sw s0, 4(sp)                    # save s0
    sw s1, 8(sp)                    # save s1
    sw s2, 12(sp)                   # save s2
    sw t5, 16(sp)                   # save t5
    sw t6, 20(sp)                   # save t6
    sw a0, 24(sp)                   # save a0
    sw a1, 28(sp)                   # save a1
    sw a2, 32(sp)                   # save a2

    mv s0, a0                       # s0 = addr of matrix 1
    mv s1, a1                       # s1 = addr of matrix 2
    mv s2, a2                       # s2 = size of matrices

    li t6, 0                        # i = 0
    li t5, 0                        # j = 0    

tm_i_loop:
    bge t6, s2, testMats_end        # if i >= size, testMats_end
    li t5, 0                        # j = 0
tm_j_loop:
    bge t5, s2, tm_i_loop_admin     # if j >= size, tm_i_loop_end
    mv a1, t6                       # a1 = i
    mv a2, s2                       # a2 = size
    call mult                       # mult(i, size)
    add a0, a0, t5                  # a0 = i * size + j
    slli a0, a0, 2                  # a0 = (i * size + j) * 4
    add t0, s0, a0                  # addr of matrix 1[i][j]
    lw t0, 0(t0)                    # t0 = matrix 1[i][k]
    add t1, s1, a0                  # addr of matrix 2[i][j]
    lw t1, 0(t1)                    # t1 = matrix 2[k][j]
    bne t0, t1, testMats_fail       # if matrix 1[i][j] != matrix 2[i][j], testMats_fail
tm_j_loop_admin:
    addi t5, t5, 1                  # increment j
    j tm_j_loop
tm_i_loop_admin:
    addi t6, t6, 1                  # increment i
    j tm_i_loop

testMats_end:
    # restore context
    lw ra, 0(sp)                    # restore return address
    lw s0, 4(sp)                    # restore s0
    lw s1, 8(sp)                    # restore s1
    lw s2, 12(sp)                   # restore s2
    lw t5, 16(sp)                   # restore t5
    lw t6, 20(sp)                   # restore t6
    lw a0, 24(sp)                   # restore a0
    lw a1, 28(sp)                   # restore a1
    lw a2, 32(sp)                   # restore a2
    addi sp, sp, 32                 # increment stack pointer
    ret

testMats_fail:
    j fail

##################################################################
#  multiplication
#  description: multiples a1 and a2 and stores the result in a0
#    a0 = result 
#    a1 = mulitplicand 
#    a2 = mulitplier
##################################################################
mult:
    addi sp, sp, -16    # decrement stack pointer
    sw ra, 0(sp)        # save return address
    sw a1, 4(sp)        # save multiplicand
    sw a2, 8(sp)        # save multiplier
    sw t0, 12(sp)       # save temp register

    li a0, 0            # product = 0

    bge a2, a1, mult_loop   # a2 >= a1, mult_loop
    mv t0, a1           # t0 = a1
    mv a1, a2           # a1 = a2
    mv a2, t0           # a2 = t0
mult_loop:
    beqz a1, mult_end   # if multiplicand == 0, mult_end
    add a0, a0, a2      # product += multiplier    
    addi a1, a1, -1     # decrement multiplicand
    j mult_loop         # mult_loop
mult_end:
    lw ra, 0(sp)        # restore return address
    lw a1, 4(sp)        # restore multiplicand
    lw a2, 8(sp)        # restore multiplier
    lw t0, 12(sp)       # restore temp register
    addi sp, sp, 16     # increment stack pointer
    jr ra               # return








