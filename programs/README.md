# Programs to Test CPE 333 Pipeline Otter
## How to use

### `matrix.py`
Python script for generating dataset of MxM matrix for matrix arthimetic
use "python3 matrix.py **size** **matadd**"
- size - size of the square matrix
- matadd - 0 dataset for matmul, 1 dataset for matadd

Prints the 2 matrices being added, the correct result, space for a result to overwrite and the size 

### `matmul/`
Contains RISCV assembly with some preloaded dataset that performs the matrix multiplication

### `matadd/`
Contains RISCV assembly with some preloaded dataset that performs the matrix addition

