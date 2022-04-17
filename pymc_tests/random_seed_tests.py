
import scipy.stats as stats
import pymc3 as pm
import scipy

print(f"pymc version: {pm.__version__}")
print(f"scipy version:{scipy.__version__}")
print("----- STATS.NORM.RVS only -----", end='\n')

for i in range(5):
    print(f" --- loop {i} --- ", end='\n')
    test_vals = stats.norm.rvs(loc=1, scale=1, size=5)
    print(test_vals, end='\n\n')


print("----- STATS.NORM.RVS with PYMC, no random seed -----", end='\n')

for i in range(5):
    print(f" --- loop{i} --- ", end='\n')
    test_vals = stats.norm.rvs(loc=2, scale=1, size=5)
    print(test_vals, end='\n')

    with pm.Model() as m:
        dummy = pm.Normal("dummy", 0, 0.5)
        trace_test = pm.sample(
            draws=100, random_seed=None, return_inferencedata=False, progressbar=False
        )


print("----- STATS.NORM.RVS with PYMC, with random seed -----", end='\n')

for i in range(5):
    print(f" --- loop{i} --- ", end='\n')
    test_vals = stats.norm.rvs(loc=1, scale=1, size=5)
    print(test_vals, end='\n\n')

    with pm.Model() as m:
        dummy = pm.Normal("dummy", 0, 0.5)
        trace_test = pm.sample(
            draws=100, random_seed=0, return_inferencedata=False, progressbar=False
        )

