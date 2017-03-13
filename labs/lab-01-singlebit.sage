from sage.stats.distributions.discrete_gaussian_integer import DiscreteGaussianDistributionIntegerSampler

class pke_singlebit():
  def __init__(self, dimension):
    self.n = dimension
    self.q = next_prime(self.n^2)
    self.sigma = sqrt(self.n/(2*pi.n()))
    self.D = DiscreteGaussianDistributionIntegerSampler(sigma=self.sigma)
    self.Zq = IntegerModRing(self.q)

  def pp_gen(self):
    self.A = random_matrix(self.Zq, self.n, self.n)

  def keygen(self):
    s = vector(self.Zq, [self.D() for _ in range(self.n)])
    e = vector(self.Zq, [self.D() for _ in range(self.n)])
    b = s * self.A + e
    return s, b

  def encrypt(self, m, pk):
    M = self.A.stack(pk)
    x = random_vector(self.n, 0, 2)
    c = M*x 
    c[self.n] = (c[self.n] + m*self.q//2) % self.q
    return c

  def decrypt(self, c, sk):
    d = list(-sk)
    d.append(1)
    m_dec = vector(d) * c
    return 1 if self.q//4 < m_dec and m_dec < (3*self.q)//4 else 0


dimension = 150
message = randint(0, 1)
scheme = pke_singlebit(dimension)
scheme.pp_gen()
sk, pk = scheme.keygen()
c = scheme.encrypt(message, pk)
m_dec = scheme.decrypt(c, sk)

print message
print m_dec
