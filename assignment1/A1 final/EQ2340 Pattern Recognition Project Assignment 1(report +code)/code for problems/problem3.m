%problem 3
clear all

mc = MarkovChain([0.75;0.25], [0.99 0.01;0.03 0.97]);
g1 = GaussD('Mean',0,'StDev',1); %Distribution for state=1
g2 = GaussD('Mean',3,'StDev',2); %Distribution for state=2
h = HMM(mc, [g1; g2]); %The HMM

nSamples = 10000;
[X, ~] = rand(h, nSamples);


mean = mean(X)
variance = var(X)