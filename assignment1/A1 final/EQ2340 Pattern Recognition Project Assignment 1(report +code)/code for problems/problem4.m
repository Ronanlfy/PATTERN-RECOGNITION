%problem 4
mc = MarkovChain([0.75;0.25], [0.99 0.01;0.03 0.97]);
g1 = GaussD('Mean',0,'StDev',1) %Distribution for state=1
g2 = GaussD('Mean',3,'StDev',2) %Distribution for state=2
h = HMM(mc, [g1; g2]);

nSamples = 500;
[X, ~] = rand(h, nSamples);

T = length(X);
%PLOT
figure(1)
plot(1:T,X);
grid on 
title('problem 4, contiguous samples Xt from the HMM');
xlabel('time T');
ylabel('output random samples X');



