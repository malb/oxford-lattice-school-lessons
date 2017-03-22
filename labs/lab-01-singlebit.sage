from sage.stats.distributions.discrete_gaussian_integer import DiscreteGaussianDistributionIntegerSampler

def balance(e, q=None):
  try:
    p = parent(e).change_ring(ZZ)
    return p([balance(e_, q=q) for e_ in e])
  except (TypeError, AttributeError):
    if q is None:
      try:
        q = parent(e).order()
      except AttributeError:
        q = parent(e).base_ring().order()
    return ZZ(e)-q if ZZ(e)>q/2 else ZZ(e)


class pke_singlebit():
  def __init__(self, dimension):
    self.n = dimension
    self.q = next_prime(self.n^2)
    self.m = 2*self.n*ceil(log(self.q, 2))
    self.sigma = sqrt(self.n/(2*pi.n()))
    self.D = DiscreteGaussianDistributionIntegerSampler(sigma=self.sigma)
    self.Zq = IntegerModRing(self.q)

  def pp_gen(self):
    self.A = random_matrix(self.Zq, self.n, self.m)

  def keygen(self):
    s = vector(self.Zq, [self.D() for _ in range(self.n)])
    e = vector(self.Zq, [self.D() for _ in range(self.m)])
    b = s * self.A + e
    return s, b

  def encrypt(self, m, pk):
    M = self.A.stack(pk)
    x = random_vector(self.m, 0, 2)
    c = M*x 
    c[self.n] = (c[self.n] + m*self.q//2) % self.q
    return c

  def decrypt(self, c, sk):
    d = list(-sk)
    d.append(1)
    m_dec = balance(vector(d) * c, self.q)
    return round(m_dec * 2/self.q) % 2


dimension = 150
message = randint(0, 1)
scheme = pke_singlebit(dimension)
scheme.pp_gen()
sk, pk = scheme.keygen()
c = scheme.encrypt(message, pk)
m_dec = scheme.decrypt(c, sk)

print message
print m_dec
