#!/usr/bin/env python
import glob

scores = [[], [], [], [], [], [], [], [], []]
for filename in glob.glob("0.out"):
    with open(filename) as f:
        for line in f:
            if "Crypto" in line:
                scores[0].append(int(line.split()[1]))
            elif "DeltaBlue" in line:
                scores[1].append(int(line.split()[1]))
            elif "EarleyBoyer" in line:
                scores[2].append(int(line.split()[1]))
            elif "NavierStokes" in line:
                scores[3].append(int(line.split()[1]))
            elif "RayTrace" in line:
                scores[4].append(int(line.split()[1]))
            elif "RegExp" in line:
                scores[5].append(int(line.split()[1]))
            elif "Richards" in line:
                scores[6].append(int(line.split()[1]))
            elif "Splay" in line:
                scores[7].append(int(line.split()[1]))
            elif "Score" in line:
                scores[8].append(int(line.split()[3]))

for score in scores:
    print(sum(score) / float(len(score)))
