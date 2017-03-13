from sage.stats.distributions.discrete_gaussian_polynomial import DiscreteGaussianDistributionPolynomialSampler
N = 8
q = 50
sigma = 1.17*sqrt(q/(2*N))
R.<x> = ZZ['x']
phi = x^N+1
D = DiscreteGaussianDistributionPolynomialSampler(R, N, sigma)

def circ(p):
  l = p.list()
  A = matrix(QQ, N, N)
  for i in range(N):
    for j in range(i):
      A[i, j] = -l[j-i]
    for j in range(i, N):
      A[i, j] = l[j-i]
  return A


def gen_basis(sk):
  Af = circ(sk[0])
  Ag = circ(sk[1])
  AF = circ(sk[2])
  AG = circ(sk[3])
  return block_matrix([[Ag,-Af],[AG,-AF]])

def bar(p):
  l = p.list()
  p_bar = l[0]
  for i in range(1, N):
    p_bar = p_bar + l[N-i] * x^i
  return p_bar

def keygen():
  ok = False
  while not ok :
    f = D()
    g = D()
    R_f, rho_f, _ = xgcd(f, phi)
    R_g, rho_g, _ = xgcd(g, phi)
    rho_f = rho_f % phi
    rho_g = rho_g % phi
    ok = (gcd(R_f, q) == 1) and (gcd(R_f, R_g) == 1)
  
  _, u, v = xgcd(R_f, R_g)
  
  F = -q * v * rho_g
  G =  q * u * rho_f

  #fbar = bar(f)
  #gbar = bar(g)
  #num = F*fbar%phi + G*gbar%phi
  #den = f*fbar%phi + g*gbar%phi
  #R_den, rho_den, _ = xgcd(den, phi)
  #R_den1 = ZZ(R_den%q).inverse_mod(q)
  #den_1 = R_den1 * rho_den
  #k = num*den_1 %phi
  #print "k"
  #print k
  #print F
  #print G
  #F = F - k*f%phi
  #G = G - k*g%phi
  #print F
  #print G
  #print "=="

  assert f * G % phi - g * F % phi == q
  
  R_f1 = ZZ(R_f%q).inverse_mod(q)
  f1 = R_f1 * rho_f
  
  h = ((g * f1) % phi) % q

  pk = h
  sk = (f, g, F, G)
  return sk, pk

def sign(tag, sk):
  B = gen_basis(sk)
  _ , M = B.gram_schmidt()
  #print M
  tag = vector(tag.list())
  #print "B"
  #print B
  #print "tag"
  #print tag
  #print "tag Zn"
  #print tag * B^-1
  #print "tag Zn rounded"
  #print (tag * B^-1).apply_map(round) * B
  return (tag * M^-1).apply_map(round) * M

def verify(tag, s, pk):
  return (tag - (s[0] + pk*s[1] % phi)).norm(2)

tag = R.random_element(2*N-1, x=-q//2, y=q//2)
sk, pk = keygen()
s = sign(tag, sk)
print verify(tag, s, pk)
