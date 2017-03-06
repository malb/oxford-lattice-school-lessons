from sage.stats.distributions.discrete_gaussian_integer import DiscreteGaussianDistributionIntegerSampler

# Init, set dimension
n = 500
q = next_prime(n^2)
sigma = sqrt(n/(2*pi.n()))
D = DiscreteGaussianDistributionIntegerSampler(sigma=sigma)
ZZq = ZZ.quotient(q*ZZ)

# ppGen
A = random_matrix(ZZq, n)

# KeyGen
s = vector(ZZq, [D() for _ in range(n)])
e = vector(ZZq, [D() for _ in range(n)])
b = s * A + e

# Encrypt bit m
m = 1  # or 0
M = A.stack(b)
x = random_vector(n, 0, 2)
c = M*x 
c[n] = (c[n] + m*round(q/2)) % q

# Decrypt
d = list(-s)
d.append(1)
m_dec = vector(d) * c
if round(q/4) < m_dec and m_dec < round(3*q/4):
    print 1
else:
    print 0

