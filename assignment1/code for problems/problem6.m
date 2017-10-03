%problem 6

mc = MarkovChain([0.75;0.25], [0.97 0.02 0.01;0.03 0.95 0.02]);
g1 = GaussD('Mean',0,'StDev',1); %Distribution for state=1
g2 = GaussD('Mean',0,'StDev',2); %Distribution for state=2
h = HMM(mc, [g1; g2]);

nSamples = 500;
[X, ~] = rand(h, nSamples);

T = length(X);
if T < nSamples
    disp(['the HMM is finite, the length of output sequences is ',num2str(T)]);
    
end


