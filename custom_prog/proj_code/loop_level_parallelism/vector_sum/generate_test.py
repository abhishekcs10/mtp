import random
fp=open('large_test','w')
fp.write('10000000\n')
for i in range(0,10000000):
	fp.write(str(random.randint(0,1000000))+"\n")

fp.close()

