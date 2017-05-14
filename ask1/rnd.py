#!/usr/bin/env python

import sys
import random

ln=len(sys.argv)
filename="input.txt"

if ln==1:
  N=random.randint(2,200)

elif ln==2:
  N=int(sys.argv[1])

elif ln==3:
  N=sys.argv[1]
  filename=argv[2]

else:
  print "Usage: python "+argv[0]+" [N] [filename]"
  exit(1)

fp=open(filename,'w')
fp.write (str(N))
fp.write ("\n")

for i in range(N):
  k=random.randint(1,1000000000)
  fp.write (str(k))
  if i<N-1:
    fp.write(" ")


fp.write("\n")
fp.close()


