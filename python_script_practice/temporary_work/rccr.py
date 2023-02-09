#!/usr/bin/env python3

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

mu = 2e-9
gen = 3
dir_ = "D:/test"
msmc_out=pd.read_csv("{}/HDvsTZ.combined.msmc2.final.txt".format(dir_), sep='\t', header=0)
t_years=gen * ((msmc_out.left_time_boundary + msmc_out.right_time_boundary)/2) / mu

plt.figure(figsize=(8, 10))
plt.subplot(211)
plt.semilogx(t_years, (1/msmc_out.lambda_00)/(2*mu), drawstyle='steps',color='red', label='HD')
plt.semilogx(t_years, (1/msmc_out.lambda_11)/(2*mu), drawstyle='steps',color='blue', label='TZ')
plt.xlabel("years ago")
plt.ylabel("population Sizes")
plt.legend()
plt.subplot(212)
relativeCCR=2.0 * msmc_out.lambda_01 / (msmc_out.lambda_00 + msmc_out.lambda_11)
plt.semilogx(t_years,relativeCCR, drawstyle='steps')
plt.xlabel("years ago")
plt.ylabel("Relative CCR")
plt.savefig("MSMC_plot.pdf")


def getCCRintersect(df, val):
    xVec = gen * ((df.left_time_boundary + df.right_time_boundary)/2) / mu
    yVec = 2.0 * df.lambda_01 / (df.lambda_00 + df.lambda_11)
    i = 0
    while yVec[i] < val:
        i += 1
    assert i > 0 and i <= len(yVec), "CCR intersection index out of bounds: {}".format(i)
    assert yVec[i - 1] < val and yVec[i] >= val, "this should never happen"
    intersectDistance = (val - yVec[i - 1]) / (yVec[i] - yVec[i - 1])
    return xVec[i - 1] + intersectDistance * (xVec[i] - xVec[i - 1])

print(getCCRintersect(msmc_out, 0.5)) #Print out the time when relativeCCR=0.5