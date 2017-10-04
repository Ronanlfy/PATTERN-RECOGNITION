 
function [freq,sigma,theta] = pausefind(frIsequence)
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

freq = frIsequence(1,:);
corr = frIsequence(2,:);
int = frIsequence(3,:);

lowbound = min(freq) / 2;

%normalize the intensity into interval[0,1]
a = max(int);
b = min(int);
newint = (int - b) / (a - b);

%these two bounds mean that when value is larger than that, we 100% believe
%it is melody instead of noises
bound_int = 0.8;
bound_corr = 0.95;

%find the low intensity area, and also the threshold for its intensity.
%here we delete all the area where we believe they are melody, and get the
%mean of left regions as the threshold.
unuse_newint = find(newint < bound_int);
theta = mean(newint(unuse_newint));
pause = find(newint < theta);
freq(pause) = lowbound;

%find the low correlation area
unuse_corr = find(corr < bound_corr);
sigma = mean(corr(unuse_corr));
pausefind = find(corr < sigma);
freq(pausefind) = lowbound;


end


