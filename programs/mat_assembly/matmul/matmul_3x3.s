#matmul.s
.data
    mat1: .word 20, 5, 4, 10, 9, 15, 14, 16, 14
    mat2: .word 17, 10, 12, 12, 20, 14, 7, 20, 19
    mat_expected: .word 428, 380, 386, 383, 580, 531, 528, 740, 658
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
    call matmul         # matmul(matResult, mat1, mat2, size)
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
#  matmul
#  description: multiplies two matrices and stores the result in a third matrix
#    a0 = addr of result matrix
#    a1 = addr of matrix 1
#    a2 = addr of matrix 2
#    a3 = size of matrices
# register usage: s0, s1, s2, s3, s4, s5, s6, s7, t0, t1, t2, t3, t4, t5, t6, a0, a1, a2
##################################################################
matmul:
    # save context
    addi sp, sp, -72                # decrement stack pointer
    sw ra, 0(sp)                    # save return address
    sw s0, 4(sp)                    # save s0
    sw s1, 8(sp)                    # save s1
    sw s2, 12(sp)                   # save s2
    sw s3, 16(sp)                   # save s3
    sw s4, 20(sp)                   # save s4
    sw s5, 24(sp)                   # save s5
    sw s6, 28(sp)                   # save s6
    sw s7, 32(sp)                   # save s7
    sw t0, 36(sp)                   # save t0
    sw t1, 40(sp)                   # save t1
    sw t2, 44(sp)                   # save t2
    sw t3, 48(sp)                   # save t3
    sw t4, 52(sp)                   # save t4
    sw t5, 56(sp)                   # save t5
    sw t6, 60(sp)                   # save t6
    sw a0, 64(sp)                   # save a0
    sw a1, 68(sp)                   # save a1
    sw a2, 72(sp)                   # save a2
    
    mv s0, a0                       # s0 = addr of result matrix
    mv s1, a1                       # s1 = addr of matrix 1
    mv s2, a2                       # s2 = addr of matrix 2
    mv s3, a3                       # s3 = size of matrices

    li t6, 0                        # i = 0
    li t5, 0                        # j = 0
    li t4, 0                        # k = 0

# iterate over rows of matrix 1
i_loop:
    bge t6, s3, matmul_end          # if i >= size, matmul_end
    li t5, 0                        # j = 0
# iterate over columns of matrix 2
j_loop:
    bge t5, s3, i_loop_admin        # if j >= size, i_loop_end
    li t4, 0                        # k = 0

    mv a1, t6                       # a1 = i
    mv a2, s3                       # a2 = size
    call mult                       # mult(i, size)
    mv s4, a0                       # s4 = i * size
    add s5, s4, t5                  # s5 = i * size + j
    slli s5, s5, 2                  # s5 = (i * size + j) * 4 (index)
k_loop:
    bge t4, s3, j_loop_admin        # if k >= size, j_loop_end
    add s6, s4, t4                  # a0 = i * size + k
    slli s6, s6, 2                  # a0 = (i * size + k) * 4 (index1)
    mv a1, t4                       # a1 = k
    mv a2, s3                       # a2 = size
    call mult                       # mult(k, size)
    add s7, a0, t5                  # a0 = k * size + j
    slli s7, s7, 2                  # a0 = (k * size + j) * 4 (index2)

    add t0, s1, s6                  # addr of matrix 1[i][k]
    lw a1, 0(t0)                    # a1 = matrix 1[i][k]
    add t1, s2, s7                  # addr of matrix 2[k][j]
    lw a2, 0(t1)                    # a2 = matrix 2[k][j]
    call mult                       # mult(matrix 1[i][k], matrix 2[k][j])
    add t2, s0, s5                  # addr of result matrix[i][j]
    lw t3, 0(t2)                    # t3 = result matrix[i][j]
    add t3, t3, a0                  # t3 = result matrix[i][j] + matrix 1[i][k] * matrix 2[k][j]
    sw t3, 0(t2)                    # result matrix[i][j] = result matrix[i][j] + matrix 1[i][k] * matrix 2[k][j]

    addi t4, t4, 1                  # increment k
    j k_loop
j_loop_admin:
    addi t5, t5, 1                  # increment j
    j j_loop 
i_loop_admin:
    addi t6, t6, 1                  # increment i
    j i_loop

matmul_end:
    # restore context
    lw ra, 0(sp)                    # restore return address
    lw s0, 4(sp)                    # restore s0
    lw s1, 8(sp)                    # restore s1
    lw s2, 12(sp)                   # restore s2
    lw s3, 16(sp)                   # restore s3
    lw s4, 20(sp)                   # restore s4
    lw s5, 24(sp)                   # restore s5
    lw s6, 28(sp)                   # restore s6
    lw s7, 32(sp)                   # restore s7
    lw t0, 36(sp)                   # restore t0
    lw t1, 40(sp)                   # restore t1
    lw t2, 44(sp)                   # restore t2
    lw t3, 48(sp)                   # restore t3
    lw t4, 52(sp)                   # restore t4
    lw t5, 56(sp)                   # restore t5
    lw t6, 60(sp)                   # restore t6
    lw a0, 64(sp)                   # restore a0
    lw a1, 68(sp)                   # restore a1
    lw a2, 72(sp)                   # restore a2
    addi sp, sp, 72                 # increment stack pointer
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
    mul a0, a1, a2                  # mult(i, size)
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








