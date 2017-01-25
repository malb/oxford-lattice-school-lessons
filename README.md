# Lessons for Oxford Spring School on Lattice-based Cryptography

## Outline ##

(Outline seemed outdated...)

## Lectures & Labs ##

### Lecture 1 (Léo, 60 minutes, Mon 11:30-12:30)

Signatures from lattices
- The Hash-then-Sign approach
- Gaussian Sampling: why (Nguyen-Regev attack) and how
- The Fiat-Shamir approach

### Lecture 2 (Martin, 60 minutes, Mon 13:30-13:30)

- [overview/reminder] Finkle-Pohst Enumeration (no pruning …)
- [overview/reminder] short: BKZ, and quality prediction (root Hermite factor, GSA, …)
- Mounting simple attacks on SIS (approx-SVP) and LWE (uSVP) 
- Finding $m$ is an exercise
- Need to check with *Phong* what he’ll cover

### Homework 1 (Tuesday ?)

1. Given LWE/SIS parameters and a simple cost model for BKZ, predict security level asymptotics
2. [signatures]

Prerequisite: LWE, and LWE-based encryption

### Lecture 3 (Martin & Léo, 60 minutes, ???)

Overstreched NTRU
- Martin: Lattice-subfield attack
- Léo: Kirchner-Fouque generalization [KF16]

### Lecture 4 (Léo, 60 minutes, Tue 11:30-12:30)

- Stickelberger Class relation and application to Ideal-SVP

prerequisite : CGS-BS-CDPR attack (Need to check with *Dan*).

### Lab 1: Constructions (Martin+Léo, 120 minutes, Wed 15:00-17:00)

- Sage lecture (introduction.org)

1. Design and Implementation of LWE Encryption
  a. Make a script that compute the security level in practice
  b. Optimize in practice the parameter for the scheme designe in HW 1
  c. Implement the full scheme: KeyGen, Enc, Dec

2. (opt) Gaussian Sampling
  a. Implement the Klein / GPV Gaussian Sampling algorithm  
  b. Implement a full signature scheme, using NTRU-type lattice
  c. Implement FFT GPV Gaussian Sampling algorithm

### Homework (Wednesday)

Prepare for lab 2.

### Lab 2: Attacks (Martin+Leo, 90 minutes, Wed 15:00-16:30)

- Fpylll lecture

1. Experimenting with LLL / BKZ:
Measure Root-Hermite factors, plot GS norms, check GSA's validity, measure cost
Do it for both BKZ and BKZ2. Compare statistics

2. 
  a. Given a SIS instance, mount the best attack according to the model
  b. (opt) Improve it using cleverer strategies (e.g. autotuned progressive strategy)

3. Given an LWE instance, mount the best attack according to the model
4. (opt) Improve the previous by introducing a pruned enumeration on the whole lattice after BKZ reduction
5. (opt) Improve the following using more clever strategies
6. (opt) Get your name up there [https://www.latticechallenge.org/lwe_challenge/challenge.php]

## Other ##

Ali:  
> Martin, you can assume that people know Python or some other programming languages. If you have a handout with the main Sage commands that you will use, we can distribute it to the students at the beginning of the school so that they can practice them before your session. 
>  
> You have two sessions so I would suggest the following;
>  
> First session; intro to (Lattice-related) Sage, then implementation of one (or more) lattice-based constructions. Additionally, you can give them a homework for the next day, say you ask them to try to implement an attack that has been explained by Léo.
>  
> Second session; more on Sage if needed, and solve the homework.
