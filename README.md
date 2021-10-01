The purpose of this repo is to store notebooks and code for the assignments related to Statistical Rethinking (SR). The data files, which are not a part of this repo, are in a separate directory within the overall project directory. More explanations on the organization of this directory can be found in `repo_setup.md`.

I've aimed to do at least one problem from each chapter, with most of the beginning chapters having multiple problems. My code is often extensive and laborious unfortunately, but it illustrates some of my bottlenecks and how I worked through them.

Lessons throughout SR illustrates a "unit testing of an analysis", which is described briefly by Dr. McElreath [here in this video](https://youtu.be/zwRdO9_GGhY?t=2922). This workflow includes:

1. Expressing theory as a probablilistic program. ("Any generative causal model can be written as a probabilitisic program.")
2. Proving planned analysis could work (conditionally). (For example, use of Pearl's algorithms.)
3. Testing pipeline on synthetic data.
4. Running pipeline on empirical data.

What is interesting about the workflow is how much of the work can (and should) be done *without* data. This can help show whether an analysis can be proven to function as the way we'd expect.

A similar workflow is described more extensively in the article ["Bayesian statistics and modelling" by van de Schoot and colleagues](https://www.nature.com/articles/s43586-020-00001-2). This is from the article's Box 5: The ten checklist points of WAMBS-v2 (an updated version of the WAMBS (when to Worry and how to Avoid the Misuse of Bayesian Statistics).

- Ensure the prior distributions and the model or likelihood are well understood and described in detail in the text. Prior-predictive checking can help identify any prior–data conflict.

- Assess each parameter for convergence, using multiple convergence diagnostics if possible. This may involve examining trace plots or ensuring diagnostics ( 𝑅̂   statistic or effective sample size) are being met for each parameter.

- Sometimes convergence diagnostics such as the  𝑅̂   statistic can fail at detecting non-stationarity within a chain. Use a subsequent measure, such as the split- 𝑅̂  , to detect trends that are missed if parts of a chain are non-stationary but, on average, appear to have reached diagnostic thresholds.

- Ensure that there were sufficient chain iterations to construct a meaningful posterior distribution. The posterior distribution should consist of enough samples to visually examine the shape, scale and central tendency of the distribution.

- Examine the effective sample size for all parameters, checking for strong degrees of autocorrelation, which may be a sign of model or prior mis-specification.

- Visually examine the marginal posterior distribution for each model parameter to ensure that they do not have irregularities that could have resulted from misfit or non-convergence. Posterior predictive distributions can be used to aid in examining the posteriors.

- Fully examine multivariate priors through a sensitivity analysis. These priors can be particularly influential on the posterior, even with slight modifications to the hyperparameters.

- To fully understand the impact of subjective priors, compare the posterior results with an analysis using diffuse priors. This comparison can facilitate a deeper understanding of the impact the subjective priors have on findings. Next, conduct a full sensitivity analysis of all priors to gain a clearer understanding of the robustness of the results to different prior settings.

- Given the subjectivity of the model, it is also important to conduct a sensitivity analysis of the model (or likelihood) to help uncover how robust results are to deviations in the model.

- Report findings, including Bayesian interpretations. Take advantage of explaining and capturing the entire posterior rather than simply a point estimate. It may be helpful to examine the density at different quantiles to fully capture and understand the posterior distribution.

