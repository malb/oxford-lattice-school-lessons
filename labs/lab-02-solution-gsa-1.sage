# -*- coding: utf-8 -*-
from fpylll import *

set_random_seed(1)
n, bits = 120, 40
A = IntegerMatrix.random(n, "qary", k=n/2, bits=bits)
beta = 60
tours = 2

fn = "/tmp/logs.txt"
par = BKZ.Param(block_size=beta,
                strategies=BKZ.DEFAULT_STRATEGY,
                dump_gso_filename=fn,
                max_loops=tours) 
par.flags & BKZ.MAX_LOOPS # max_loops sets flag for you

delta_0 = (beta/(2*pi*e) * (pi*beta)^(1/ZZ(beta)))^(1/(2*beta-1))
alpha = delta_0^(-2*n/(n-1))

norms = [map(log, [(alpha^i * delta_0^n * 2^(bits/2))^2 for i in range(n)])]

BKZ.reduction(A, par)

for i, l in enumerate(open(fn).readlines()):
    if i > tours:
        break
    _norms =  l.split(":")[1] # stop off other information
    _norms = _norms.strip().split(" ") # split string
    _norms = map(float, _norms) # map to floats
    norms.append(_norms)
        
colours = ["#4D4D4D", "#5DA5DA", "#FAA43A", "#60BD68", 
           "#F17CB0", "#B2912F", "#B276B2", "#DECF3F", "#F15854"]

g  = line(zip(range(n), norms[0]), legend_label="GSA", color=colours[0])
g += line(zip(range(n), norms[1]), legend_label="lll", color=colours[1])

for i,_norms in enumerate(norms[2:]):
    g += line(zip(range(n), _norms), 
              legend_label="tour %d"%i, color=colours[i+2])
g
