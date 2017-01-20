# Lessons for Oxford Spring School on Lattice-based Cryptography

## Outline ##

1. Intro to Sage
2. Constructing (Ring-)LWE instance (matrices, polynomials, cyclotomic rings, conversions)
3. SIS attack (simple)
4. BDD attack including pruned enumeration

## Lectures & Labs ##

### Lecture 1 (Léo, 60 minutes, Mon 11:30-12:30)

Lattice-based Crypto basics:
- Signatures from lattices
- Gaussian Sampling: why and how.
- Check with *Nigel* what he wants to cover

### Lecture 2 (Martin, 60 minutes, Mon 13:30-13:30)

- [overview/reminder] Finkle-Pohst Enumeration (no pruning …)
- [overview/reminder] short: BKZ, and quality prediction (root Hermite factor, GSA, …)
- Mounting simple attacks on SIS (approx-SVP) and LWE (uSVP) 
- Need to check with *Phong* what he’ll cover

### Homework 1 (Monday)

1. Given LWE/SIS parameters and a simple cost model for BKZ, predict security level asymptotics
2. Optimise parameter simple 1-bit enc scheme based on LWE (uniform error, perfect correctness)

Prerequisite: LWE, and LWE-based encryption

### Lecture 3 (Martin & Léo, 60 minutes, Overstreched NTRU)

- Martin: Lattice-subfield attack
- Léo: Kirchner-Fouque generalization [KF16]

### Lecture 4 (Léo, 60 minutes, Tue 11:30-12:30)

- Stickelberger Class relation and application to Ideal-SVP

prerequisite : 
CGS-BS-CDPR attack (Need to check with *Dan*).

### Homework (Tuesday)

Prepare for Lab 1.

### Lab 1 (Martin+Leo, 120 minutes, Wed 15:00-17:00)

Implem of HW 1:

1. Make a script that compute the security level in practice

2. 
  - Re-optimize the parameters using a script
  - Implement the scheme

### Homework (Wednesday)

Prepare for lab 2.

### Lab 2 (Martin+Leo, 90 minutes, Wed 15:00-16:30)

1. Experimenting with LLL / BKZ:
Measure Root-Hermite factors, plot GS norms, check GSA's validity, measure cost
Do it for both BKZ and BKZ2. Compare statitistics

2. 
  a. Given a SIS instance, mount the best attack according to the model
  b. (opt) Improve it using cleverer strategies (e.g. autotuned progressive strategy)

3. Given an LWE instance, mount the best attack according to the model

4. (opt) Improve the previous by introducing a pruned enumeration on the whole lattice after BKZ reduction

5. (opt) Improve the following using more clever stategies


## Other ##

Ali:  
> Martin, you can assume that people know Python or some other programming languages. If you have a handout with the main Sage commands that you will use, we can distribute it to the students at the beginning of the school so that they can practice them before your session. 
>  
> You have two sessions so I would suggest the following;
>  
> First session; intro to (Lattice-related) Sage, then implementation of one (or more) lattice-based constructions. Additionally, you can give them a homework for the next day, say you ask them to try to implement an attack that has been explained by Léo.
>  
> Second session; more on Sage if needed, and solve the homework.
