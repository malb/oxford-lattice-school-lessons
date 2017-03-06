from sage.stats.distributions.discrete_gaussian_integer import DiscreteGaussianDistributionIntegerSampler

# Init, set dimension
n = 16
k = 2  # number of bits
q = next_prime(n^2)
sigma = sqrt(n/(2*pi.n()))
D = DiscreteGaussianDistributionIntegerSampler(sigma=sigma)
ZZq = ZZ.quotient(q*ZZ)

# ppGen
A = random_matrix(ZZq, n)

# KeyGen
s = matrix(ZZq, n, k, [D() for _ in range(n*k)])
e = matrix(ZZq, n, k, [D() for _ in range(n*k)])
b = s.transpose() * A + e.transpose()

# Encrypt k bits m
m = random_matrix(ZZ, k, x=2)
print m

x = random_matrix(ZZ, n, k, x=2)
m = zero_matrix(ZZq, n, k).stack(m)
M = A.stack(b)
c = (M*x + m * round(q/2)) % q

# Decrypt
d = -s.transpose()
d = d.augment(identity_matrix(k))
m_dec = d * c

f = lambda x: 1 if round(q/4) < x and x < round(3*q/4) else 0
print m_dec.apply_map(f)
