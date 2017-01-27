from fpylll import *
from fpylll.algorithms.bkz2 import BKZReduction as BKZ2
from fpylll.algorithms.bkz_stats import BKZStats
import time

class MyBKZ(BKZ2):
    def __call__(self, params, norms, min_row=0, max_row=-1):
        """Run the BKZ with `param`  and dump norms to ``norms``

        :param params: BKZ parameters
        :param norms: a list to append vectors of norms to
        :param min_row: start processing in this row
        :param max_row: stop processing in this row (exclusive)

        """
        # this changed in the development version of fpyll
        stats = BKZStats(self, verbose=params.flags & BKZ.VERBOSE)

        if params.flags & BKZ.AUTO_ABORT:
            auto_abort = BKZ.AutoAbort(self.M, self.A.nrows)

        cputime_start = time.clock()

        self.M.discover_all_rows()
        norms.append([self.M.get_r(j, j) for j in range(n)])

        i = 0
        while True:
            with stats.context("tour"):
                clean = self.tour(params, min_row, max_row, stats)
            norms.append([self.M.get_r(j, j) for j in range(n)])
            i += 1
            if clean or params.block_size >= self.A.nrows:
                break
            if (params.flags & BKZ.AUTO_ABORT) and auto_abort.test_abort():
                break
            if (params.flags & BKZ.MAX_LOOPS) and i >= params.max_loops:
                break
            if (params.flags & BKZ.MAX_TIME) \
               and time.clock() - cputime_start >= params.max_time:
                break
            
        stats.finalize()
        self.stats = stats
        return clean

set_random_seed(1)

n, bits = 120, 40
A = IntegerMatrix.random(n, "qary", k=n/2, bits=bits)
beta = 60
tours = 2
par = BKZ.Param(block_size=beta,
                strategies=BKZ.DEFAULT_STRATEGY,
                max_loops=tours) 

delta_0 = (beta/(2*pi*e) * (pi*beta)^(1/ZZ(beta)))^(1/(2*beta-1))
alpha = delta_0^(-2*n/(n-1))

LLL.reduction(A)

norms  = [[(alpha^i * delta_0^n * 2^(bits/2))^2 for i in range(n)]]
bkz = MyBKZ(A)

bkz(par, norms)
        
colours = ["#4D4D4D", "#5DA5DA", "#FAA43A", "#60BD68", "#F17CB0",
           "#B2912F", "#B276B2", "#DECF3F", "#F15854"]

g  = line(zip(range(n), map(log, norms[0])),
          legend_label="GSA", color=colours[0])
g += line(zip(range(n), map(log, norms[1])),
          legend_label="lll", color=colours[1])

for i,_norms in enumerate(norms[2:]):
    g += line(zip(range(n), map(log, _norms)),
              legend_label="tour %d"%i, color=colours[i+2])
g
