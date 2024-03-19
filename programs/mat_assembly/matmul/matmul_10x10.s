#matmul
.data
    mat1: .word 16, 19, 17, 16, 11, 6, 2, 20, 16, 17, 5, 15, 12, 15, 2, 2, 14, 1, 5, 20, 2, 16, 8, 5, 1, 16, 19, 10, 10, 7, 7, 10, 11, 8, 3, 2, 6, 15, 15, 6, 18, 4, 15, 8, 19, 8, 5, 16, 20, 2, 5, 9, 7, 2, 12, 13, 18, 10, 1, 11, 20, 12, 14, 20, 5, 9, 16, 7, 5, 14, 5, 18, 11, 4, 11, 6, 9, 16, 13, 16, 4, 7, 9, 3, 17, 11, 19, 8, 8, 3, 13, 15, 11, 13, 18, 18, 17, 11, 9, 5
    mat2: .word 1, 10, 12, 6, 11, 10, 8, 8, 15, 20, 3, 2, 19, 13, 6, 8, 4, 10, 4, 9, 3, 2, 5, 17, 3, 7, 3, 3, 4, 19, 9, 18, 13, 13, 19, 3, 10, 1, 8, 11, 5, 19, 7, 6, 6, 4, 15, 13, 3, 19, 16, 18, 5, 10, 8, 20, 10, 8, 9, 2, 17, 5, 15, 12, 18, 15, 19, 18, 13, 10, 1, 15, 20, 17, 9, 5, 9, 10, 15, 17, 13, 5, 6, 11, 18, 12, 18, 17, 13, 1, 6, 14, 8, 3, 4, 8, 3, 16, 8, 8
    mat_expected: .word 783, 1465, 1615, 1557, 1331, 1101, 1197, 1356, 1269, 1723, 687, 838, 1044, 956, 925, 782, 761, 950, 749, 992, 885, 858, 1121, 1116, 1011, 1054, 981, 1070, 896, 868, 537, 763, 992, 1011, 893, 696, 811, 861, 826, 966, 743, 1260, 1175, 1271, 1199, 988, 1255, 1170, 1120, 1504, 734, 979, 1005, 924, 820, 905, 910, 1030, 793, 1029, 875, 1275, 1400, 1302, 1313, 1101, 1114, 1146, 1150, 1503, 713, 1071, 1277, 1200, 990, 946, 1007, 1247, 964, 1239, 793, 944, 956, 980, 930, 901, 1068, 1047, 793, 1050, 1033, 1447, 1450, 1422, 1352, 1256, 1376, 1327, 1162, 1531
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
    mul a0, a1, a2                  # mult(i, size)
    mv s4, a0                       # s4 = i * size
    add s5, s4, t5                  # s5 = i * size + j
    slli s5, s5, 2                  # s5 = (i * size + j) * 4 (index)
k_loop:
    bge t4, s3, j_loop_admin        # if k >= size, j_loop_end
    add s6, s4, t4                  # a0 = i * size + k
    slli s6, s6, 2                  # a0 = (i * size + k) * 4 (index1)
    mv a1, t4                       # a1 = k
    mv a2, s3                       # a2 = size
    mul a0, a1, a2                  # mult(k, size)
    add s7, a0, t5                  # a0 = k * size + j
    slli s7, s7, 2                  # a0 = (k * size + j) * 4 (index2)

    add t0, s1, s6                  # addr of matrix 1[i][k]
    lw a1, 0(t0)                    # a1 = matrix 1[i][k]
    add t1, s2, s7                  # addr of matrix 2[k][j]
    lw a2, 0(t1)                    # a2 = matrix 2[k][j]
    mul a0, a1, a2                  # mult(matrix 1[i][k], matrix 2[k][j])
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
    mul a0, a1, a2                  # mult(i, size)
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








