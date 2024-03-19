#matadd_3x3.s
.data
    mat1: .word 5, 5, 3, 8, 4, 6, 1, 14, 6
    mat2: .word 10, 10, 6, 18, 13, 6, 10, 12, 13
    mat_expected: .word 15, 15, 9, 26, 17, 12, 11, 26, 19
    mat_result: .word 0, 0, 0, 0, 0, 0, 0, 0, 0
    size: .word 3
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








