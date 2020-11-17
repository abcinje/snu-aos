import numpy as np

def pagerank(M, num_iterations: int = 100, d: float = 0.85):
    N = M.shape[1]
    v = np.random.rand(N, 1)
    v = v / np.linalg.norm(v, 1)
    M_hat = (d * M + (1 - d) / N)
    for i in range(num_iterations):
        v = M_hat @ v
    return v

M = np.array([[0, 0, 0, 0, 1],
    [0.5, 0, 0, 0, 0],
    [0.5, 0, 0, 0, 0],
    [0, 1, 0.5, 0, 0],
    [0, 0, 0.5, 1, 0]])

v = pagerank(M, 100, 0.85)
print(v)

