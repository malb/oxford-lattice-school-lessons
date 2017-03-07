from sage.stats.distributions.discrete_gaussian_polynomial import DiscreteGaussianDistributionPolynomialSampler

class pke_ring():
  def __init__(self, dimension):
    self.n = dimension
    self.q = next_prime(self.n^2)
    self.sigma = sqrt(self.n/(2*pi.n()))
    Zq = IntegerModRing(self.q)
    self.Rq = PolynomialRing(Zq, 'x').quotient_ring(x^dimension+1)
    self.P = DiscreteGaussianDistributionPolynomialSampler(self.Rq, self.n, self.sigma)

  def pp_gen(self):
    self.a = self.Rq.random_element()

  def keygen(self):
    s = self.P()
    e = self.P()
    b = s * self.a + e
    return s, b

  def encrypt(self, m, pk):
    r = self.P()
    c = (self.a*r + self.P(), pk*r + self.P() + self.Rq(m) * (self.q//2))
    return c

  def decrypt(self, c, sk):
    m_dec = c[1] - sk * c[0]
    return map(lambda x: 1 if self.q//4 < x and x < (3*self.q)//4 else 0, m_dec.list())

dimension = 16
message = [randint(0, 1) for _ in range(dimension)]

scheme = pke_ring(dimension)
scheme.pp_gen()
sk, pk = scheme.keygen()
c = scheme.encrypt(message, pk)
m_dec = scheme.decrypt(c, sk)

print message
print m_dec


