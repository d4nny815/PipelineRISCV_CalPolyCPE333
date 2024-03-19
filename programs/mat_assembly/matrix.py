from random import randint
import sys

# ! Change this to change the range of the values generated
RANGE_MIN = 1
RANGE_MAX = 20


def main():
    global SIZE 
    SIZE, add_mul = parse_args()
    setup_riscv(SIZE, add_mul)
    return 0


def parse_args():
    (size, add_mul) = (0, 0)
    error_string_1 = "Usage: python3 matrix.py [size] [add_mul(0/1)]"
    if len(sys.argv) != 3:
        sys.exit(error_string_1)
    try:
        size = int(sys.argv[1])
    except ValueError:
        sys.exit(error_string_1)
    try:
        add_mul = int(sys.argv[2])
        if add_mul != 0 and add_mul != 1:
            sys.exit(error_string_1)
    except ValueError:
        sys.exit(error_string_1)
    return (size, add_mul)


# prints the matrices to be able to copy into RARS
def setup_riscv(size, add_mul):
    matA = generate_matrix(size)
    matB = generate_matrix(size)
    mat_result = [0 for i in range(size * size)]
    mat_0 = [0 for i in range(size * size)]
    if add_mul == 1:
        print(f"data set for matrix addition")
        mat_add(matA, matB, mat_result)
    else:
        print(f"data set for matrix multiplication")
        mat_mul(matA, matB, mat_result)
    print_mat_riscv(matA, size, "mat1")
    print_mat_riscv(matB, size, "mat2")
    print_mat_riscv(mat_result, size, "mat_expected")
    print_mat_riscv(mat_0, size, "mat_result")
    print(f"size: .word {size}")
    return 0


def generate_matrix(size):
    matrix = []
    for i in range(size * size):
        matrix.append(randint(RANGE_MIN, RANGE_MAX))
    # print(len(matrix))
    return matrix


def print_mat_riscv(matrix, size, name):
    matrix_string = ""
    data = f"{name}: .word "
    for i in range(size * size):
        matrix_string += str(matrix[i]) + ", "
    data += matrix_string[:-2]
    print(data)
    return 0


def mat_mul(mat_a, mat_b, mat_result):
    for i in range(SIZE):
        for j in range(SIZE):
            index = i * SIZE + j
            for k in range(SIZE):
                index1 = i * SIZE + k
                index2 = k * SIZE + j
                mat_result[index] = mat_result[index] + mat_a[index1] * mat_b[index2]
    return 0


def mat_add(mat_a, mat_b, mat_result):
    for i in range(SIZE):
        for j in range(SIZE):
            index = i * SIZE + j
            mat_result[index] = mat_a[index] + mat_b[index]
    return 0


def test_matrix(mat_result, mat_expected):
    for i in range(SIZE):
        for j in range(SIZE):
            index = i * SIZE + j
            # my_str = f"index: {index}, result: {mat_result[index]}, expected: {mat_expected[index]}, hex {hex(mat_result[index])}"
            # print(my_str)
            if mat_result[index] != mat_expected[index]:
                raise IndexError("Matrices not equal")
    return 0


if __name__ == "__main__":
    main()