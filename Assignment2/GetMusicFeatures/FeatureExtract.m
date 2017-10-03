function feature = FeatureExtract(frIsequence,sigma,theta)
%feature = pausefind(frIsequence,sigma,theta) used for find the
%feature given the pitch, correlation and intensity.
%
%Input:
%frIsequence:output from FeatureExtract
%sigma: threshold for correlation
%theta: threshold for normalized intensity
%
%Result:
%feature: feature based on the logatirhm of the pitch track

%----------------------------------------------------
%Code Authors:FEIYANG LIU

length = size(frIsequence,2);


freq = pausefind(frIsequence,sigma,theta);

upperbound = max(freq);
lowbound = min(freq);
peak = 500;

%if maxpoint is smaller than upperbound, indicates the noise/silent has
%been repalced;else use the lowbound to replace the peak point.
if  upperbound < peak
    freq = freq;
else
    highfreq = find(freq == upperbound);
    freq(highfreq) = lowbound;
end

maxpoint = max(freq);
%minpoint = min(freq);
%find minmum point except for the lowbound, since the lowbound is the noise
% or silent, not the wanted minmum of melody pitch, so find the second 
%minmum, the extract it in order to be robust to transposition
series = freq;
min_series = min(series);
minfind = (series == min_series);
series(minfind) = nan;
minpoint = min(series);

%normalize it into interval [0,1];and transform into interval 
%[lowbound,upperbound], then robust to transposition

%feature = (freq - minpoint) / (maxpoint - minpoint);
feature = log(freq) - log(minpoint);
feature(find(feature < 0)) = 0;
%find the mean and variance of the melody, add noises to vacant region

meanvalue = mean(feature);
stdvalue = std(feature(find(feature ~= 0)));
len = size(find(feature == 0),2);
feature(find(feature == 0)) = meanvalue + stdvalue * ...
  (2 * rand(1,len) - 1);

%transform the output relative frequency into semitones, the length of one
%semitone is log(40/20)/12 = log(2)/12;
feature = feature * 12 / log(2);

%feature(find(feature < 0)) = rand(1,size(find(feature < 0),2)); 
%feature = feature * (upperbound - lowbound) + lowbound;

%set final outputs into integer
%feature = round(feature);
end





