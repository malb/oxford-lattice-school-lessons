from sage.stats.distributions.discrete_gaussian_polynomial import DiscreteGaussianDistributionPolynomialSampler

# Init, set dimension
n = 16
q = next_prime(n^2)
sigma = sqrt(n/(2*pi.n()))

ZZq = ZZ.quotient(q*ZZ)
Rq.<x> = ZZq['x'].quotient_ring(x^n+1)
P = DiscreteGaussianDistributionPolynomialSampler(Rq, n, sigma)

# ppGen
a = Rq.random_element()

# KeyGen
s = P()
e = P()
b = s * a + e

# Encrypt bit m
m = Rq([randint(0, 1) for _ in range(n)])
print m

r = P()
c = (a*r + P(), b*r + P() + Rq(m) * round(q/2))

# Decrypt
m_dec = c[1] - s * c[0]
f = lambda x: 1 if round(q/4) < x and x < round(3*q/4) else 0
print Rq(map(f, m_dec.list()))

