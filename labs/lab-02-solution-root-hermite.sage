# -*- coding: utf-8 -*-
from fpylll import *

deltaf = lambda beta: (beta/(2*pi*e) * (pi*beta)^(1/beta))^(1/(2*beta-1))
fmt = u"n: %3d, bits: %2d, β: %2d, δ_0: %.4f, pred: 2^%5.2f, real: 2^%5.2f"

ntrials = 20
for n in (50, 70, 90, 110, 130):
    for bits in (20, 40):
        for beta in (2, 20, 50, 60):
            if beta > n:
                continue
            beta = ZZ(beta)
            if beta == 2:
                delta_0 = 1.0219
            else:
                delta_0 = deltaf(beta)
            n_pred = float(delta_0^n * 2^(bits/2))
            n_real = []
            for i in range(ntrials):
                A = IntegerMatrix.random(n, "qary", k=n/2, bits=bits)
                if beta == 2:
                    LLL.reduction(A)
                else:
                    par = BKZ.Param(block_size=beta,
                                    strategies=BKZ.DEFAULT_STRATEGY,
                                    max_loops=4,
                                    flags=BKZ.MAX_LOOPS|BKZ.GH_BND)
                    BKZ.reduction(A, par)
                n_real.append(A[0].norm())
            n_real = sum(n_real)/ntrials
            print(fmt%(n, bits, beta, delta_0, log(n_pred,2), log(n_real,2)))
    print
