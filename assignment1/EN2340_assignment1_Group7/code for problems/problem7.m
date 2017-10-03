%problem 7
clear all 

mc = MarkovChain([0.75;0.25], [0.8 0.2; 0.3 0.7]);
%define mean and covariance of the two-dimensional guassian distribution
u1 = [0;0];
cov1 = [2 1;1 4];
u2 = [0;0];
cov2 = [2 0;0 4];
u3 = [7;7];
cov3 = [2 1;1 4];

g1 = GaussD('Mean',u1,'Covariance',cov1); 
g2 = GaussD('Mean',u2,'Covariance',cov2); 
g3 = GaussD('Mean',u3,'Covariance',cov3); 


h1 = HMM(mc, [g1; g2]);
h2 = HMM(mc, [g1; g3]);

nSamples = 500;
[X1, ~] = rand(h1, nSamples);

[X2, ~] = rand(h2, nSamples);

%PLOT, directly see the all output locations, which cluster every point
%belongs to
figure(1)
plot(X1(1,:),X1(2,:),'.');
grid on 
title('random output vector from 2 guassian distribution with same mean');
xlabel('value in the first row of output vector');
ylabel('value in the second row of output vector');
hold on 
plot(0,0,'.');

figure(2)
plot(X2(1,:),X2(2,:),'.');
grid on 
title('random output vector from 2 guassian distribution with different mean');
xlabel('value in the first row of output vector');
ylabel('value in the second row of output vector');
hold on 
plot(0,0,'.');
plot(7,7,'.');



