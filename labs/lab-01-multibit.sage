from sage.stats.distributions.discrete_gaussian_integer import DiscreteGaussianDistributionIntegerSampler

class pke_multibit():
  def __init__(self, dimension, packing):
    self.n = dimension
    self.k = packing
    self.q = next_prime(self.n^2)
    self.sigma = sqrt(self.n/(2*pi.n()))
    self.D = DiscreteGaussianDistributionIntegerSampler(sigma=self.sigma)
    self.Zq = IntegerModRing(self.q)

  def pp_gen(self):
    self.A = random_matrix(self.Zq, self.n, self.n)

  def keygen(self):
    s = matrix(self.Zq, self.n, self.k, [self.D() for _ in range(self.n*self.k)])
    e = matrix(self.Zq, self.n, self.k, [self.D() for _ in range(self.n*self.k)])
    b = s.transpose() * self.A + e.transpose()
    return s, b

  def encrypt(self, m, pk):
    x = random_matrix(ZZ, self.n, self.k, x=2)
    m = zero_matrix(self.Zq, self.n, self.k).stack(m)
    M = self.A.stack(pk)
    c = (M*x + m * (self.q//2)) % self.q
    return c

  def decrypt(self, c, sk):
    d = -sk.transpose()
    d = d.augment(identity_matrix(self.k))
    m_dec = d * c
    return m_dec.apply_map(lambda x: 1 if self.q//4 < x and x < (3*self.q)//4 else 0)


dimension = 150
packing = 4
message = random_matrix(ZZ, packing, x=2)

scheme = pke_multibit(dimension, packing)
scheme.pp_gen()
sk, pk = scheme.keygen()
c = scheme.encrypt(message, pk)
m_dec = scheme.decrypt(c, sk)

print message
print m_dec
