from sage.crypto.lwe import LWE
from sage.stats.distributions.discrete_gaussian_integer import DiscreteGaussianDistributionIntegerSampler
from sage.all import next_prime, RR, matrix, vector, identity_matrix, ZZ, sqrt, pi, log, prod, ceil


def experiment(n=65, q=next_prime(ceil(2**9)), sigma=8, m=178, block_size=56, tours=6):
    alpha = sigma/q
    L, e = gen_instance(n, alpha, q, m)
    R, norms = run_instance(L, block_size, tours, sigma/sqrt(2*pi))
    return L, R, e, norms


def gen_instance(n, alpha, q, m, t=1):
    D = DiscreteGaussianDistributionIntegerSampler(alpha*q/sqrt(2*pi))
    lwe = LWE(n, q, D)
    Ac = [lwe() for _ in range(m)]
    A = matrix([a_ for a_, c_ in Ac])
    c = vector(ZZ, [c_ for a_, c_ in Ac])
    B = A.T.echelon_form()
    e = (c - A*lwe._LWE__s).change_ring(ZZ)

    def bm(x):
        return ZZ(x) if ZZ(x)<q//2 else ZZ(x)-q

    e = vector(map(bm, e))

    N = B.change_ring(ZZ)
    S = matrix(ZZ, m-n, n).augment(q*identity_matrix(ZZ, m-n))
    L = (N.stack(S)).augment(matrix(ZZ, m, 1))
    L = L.stack(matrix(c).augment(matrix(ZZ, 1, 1, [t])))
    return L, e


def run_instance(L, block_size, tours, stddev):
    from fpylll import BKZ, LLL, GSO, IntegerMatrix
    from fpylll.algorithms.bkz2 import BKZReduction as BKZ2
    from sage.all import e

    A = IntegerMatrix.from_matrix(L)

    block_size = ZZ(block_size)
    par = BKZ.Param(block_size=block_size,
                    strategies=BKZ.DEFAULT_STRATEGY,
                    flags=BKZ.VERBOSE)

    block_size = ZZ(block_size)
    delta_0 = (block_size/(2*pi*e) * (pi*block_size)**(1/block_size))**(1/(2*block_size-1))
    n = ZZ(L.nrows())
    alpha = delta_0**(-2*n/(n-1))

    LLL.reduction(A)
    M = GSO.Mat(A)
    M.update_gso()

    vol = sqrt(prod([RR(M.get_r(i, i)) for i in range(n)]))

    norms  = [map(lambda x: RR(log(x,2)),
                  [(alpha**i * delta_0**n * vol**(1/n))**2 for i in range(n)])]

    norms += [map(lambda x: RR(log(x,2)),
                  [(stddev*sqrt(n-i))**2 for i in range(n)])]

    norms += [[log(RR(M.get_r(i, i)), 2) for i in range(n)]]

    bkz = BKZ2(M)

    for i in range(tours):
        bkz.tour(par)
        norms += [[log(M.get_r(i, i), 2) for i in range(n)]]

    return A.to_matrix(matrix(ZZ, n, n)), norms


def plot_norms(norms, block_size, bound):
    from sage.all import line, Graphics
    from itertools import cycle

    n = len(norms[0])

    colours = cycle(["#4D4D4D", "#5DA5DA", "#FAA43A", "#60BD68",
                     "#F17CB0", "#B2912F", "#B276B2", "#DECF3F", "#F15854"])

    base = colours.next()
    g = line(zip(range(n), norms[0]), legend_label="GSA", color=base,
             frame=True, axes=False, transparent=True, axes_labels=["$i$", "$2\\,\\log_2 \\|\mathbf{b}^*_i\\|$"])
    g += line([(n-block_size, 0), (n-block_size, 0.99*norms[0][n-block_size-1])], color=base, linestyle='--')
    g += line(zip(range(n), norms[1]), legend_label="$\\|\\mathbf{e}^*_{i}\\|$", color=colours.next())
    g += line(zip(range(n), norms[2]), legend_label="LLL", color=colours.next())

    for i, _norms in enumerate(norms[3:]):
        if _norms[0] <= bound:
            thickness = 1.5
        else:
            thickness = 1
        g += line(zip(range(n), _norms),
                  legend_label="tour %d"%i, color=colours.next(), thickness=thickness)
        if _norms[0] <= bound:
            break

    return g
