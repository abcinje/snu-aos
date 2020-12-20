import numpy as np
import random
import os
import re

# This 5000 x 5000 matrix occupies 334MB of memory
matrix = np.random.randn(5000, 5000)
summation = 0

for i in range(100):
    x = random.randint(0, 4999)
    y = random.randint(0, 4999)
    summation += matrix[x][y]
