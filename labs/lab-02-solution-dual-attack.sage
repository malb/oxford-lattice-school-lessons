def block_sizef(delta_0):
    """
    Blocksize for a given delta_0
    :param delta_0: root-hermite factor

    """
    k = ZZ(40)
    RR = delta_0.parent()
    pi_r = RR(pi)
    e_r = RR(e)

    f = lambda k: (k/(2*pi_r*e_r) * (pi_r*k)**(1/k))**(1/(2*(k-1)))

    while f(2*k) > delta_0:
        k *= 2
    while f(k+10) > delta_0:
        k += 10
    while True:
        if f(k) < delta_0:
            break
        k += 1

    return k

def balanced_lift(e):
    q = parent(e).order()
    e = ZZ(e)
    return e - q if e > q//2 else e

from sage.crypto.lwe import LindnerPeikert
adv, n = 0.6, 50

sage.all.set_random_seed(1337) # make it reproducible

lwe = LindnerPeikert(n)
q = lwe.K.order()
alpha = RR(sqrt(2*pi)*lwe.D.sigma/q)

log_delta_0 = log(RR(sqrt(log(1/adv)/pi))/alpha, 2)**2 / (4*n*log(q, 2))
delta_0 = RR(2**log_delta_0)

beta = block_sizef(delta_0)
m = ZZ(round(sqrt(n*log(q, 2)/log(delta_0, 2))))
beta, m

samples = [lwe() for _ in range(m)]

A = matrix([a for a,c in samples])
c = vector([c for a,c in samples])

B = A.left_kernel().matrix()
N = B.change_ring(ZZ)
S = matrix(ZZ, n, m-n).augment(q*identity_matrix(n))
B = N.stack(S)

R = B.BKZ(block_size=beta, proof=False)

v = R[0]
balanced_lift(v*c)

l = []
for r in R.rows():
    l.append(balanced_lift(r*c))

histogram(l, color="#5DA5DA", edgecolor="#5DA5DA", bins=20)
