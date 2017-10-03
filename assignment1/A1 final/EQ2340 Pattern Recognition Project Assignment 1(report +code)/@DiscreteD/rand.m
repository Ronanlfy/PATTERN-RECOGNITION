function R=rand(pD,nData)
%R=rand(pD,nData) returns random scalars drawn from given Discrete Distribution.
%
%Input:
%pD=    DiscreteD object
%nData= scalar defining number of wanted random data elements
%
%Result:
%R= row vector with integer random data drawn from the DiscreteD object pD
%   (size(R)= [1, nData]
%
%----------------------------------------------------
%Code Authors:Feiyang Liu
%             Baoqing she
%----------------------------------------------------

if numel(pD)>1
    error('Method works only for a single DiscreteD object');
end;

%*** Insert your own code here and remove the following error message 

%normalize the probability
pD.ProbMass = pD.ProbMass./repmat(sum(pD.ProbMass),size(pD.ProbMass,1),1);
prob_sum= cumsum(pD.ProbMass);
%build r
R = zeros(1,nData);
random = rand(1,nData);
for i = 1:nData
    %find the index of random integer
    R(i) = find(random(i) < prob_sum, 1);
end
%error('Not yet implemented');
