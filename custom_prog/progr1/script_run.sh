#!/bin/bash
for i in {1..1024}
do
	printf "*****************************\n#Cores=$i\n***************************\n\n" >> sniper.out
	`run-sniper -n 3 ./out.prog1 < test >> sniper.out`

done
