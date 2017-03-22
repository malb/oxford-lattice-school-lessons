from sage.stats.distributions.discrete_gaussian_polynomial import DiscreteGaussianDistributionPolynomialSampler
def balance(e, q=None):
  try:
    p = parent(e).change_ring(ZZ)
    return p([balance(e_) for e_ in e])
  except (TypeError, AttributeError):
    if q is None:
      try:
        q = parent(e).order()
      except AttributeError:
        q = parent(e).base_ring().order()
    return ZZ(e)-q if ZZ(e)>q/2 else ZZ(e)


class pke_ring():
  def __init__(self, dimension):
    self.n = dimension
    self.q = next_prime(self.n^2)
    self.sigma = sqrt(self.n/(2*pi.n()))
    Zq = IntegerModRing(self.q)
    Pq.<y> = Zq['y']
    self.Rq = Pq.quotient_ring(y^dimension+1)
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
    m_dec = (c[1] - sk * c[0]).list()
    return map(lambda x: round(2/self.q * balance(x, self.q)) % 2, m_dec)

dimension = 16
message = [randint(0, 1) for _ in range(dimension)]

scheme = pke_ring(dimension)
scheme.pp_gen()
sk, pk = scheme.keygen()
c = scheme.encrypt(message, pk)
m_dec = scheme.decrypt(c, sk)

print message
print m_dec


