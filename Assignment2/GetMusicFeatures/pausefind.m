 
function output = pausefind(frIsequence,sigma,theta)
%output = pausefind(frIsequence,sigma,theta) used for find the
%pause/silent region from the original melody input. 
%
%Input:
%sigma: threshold for correlation
%theta: threshold for normalized intensity
%
%Result:
%output: keeps the original pitch for harmonic region, set the non-harmonic
%region as lowbound

%----------------------------------------------------
%Code Authors:FEIYANG LIU
%----------------------------------------------------

length = size(frIsequence,2);

freq = frIsequence(1,:);
corr = frIsequence(2,:);
int = frIsequence(3,:);

lowbound = min(freq) / 2;

a = max(int);
b = min(int);
newint = (int - b) / (a - b);

%find the low intensity area
pause = find(newint < theta);
freq(pause) = lowbound;
%freq(pause) = lowbound + (upperbound - lowbound) * rand(1,size(pause,2));

%find the low correlation area
pausefind = find(corr < sigma);
freq(pause) = lowbound;
%freq(pause) = lowbound + (upperbound - lowbound) * rand(1,size(pause,2));

output = freq;
end


