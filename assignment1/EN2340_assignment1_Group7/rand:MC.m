function S=rand(mc,T)
%S=rand(mc,T) returns a random state sequence from given MarkovChain object.
%
%Input:
%mc=    a single MarkovChain object
%T= scalar defining maximum length of desired state sequence.
%   An infinite-duration MarkovChain always generates sequence of length=T
%   A finite-duration MarkovChain may return shorter sequence,
%   if END state was reached before T samples.
%
%Result:
%S= integer row vector with random state sequence,
%   NOT INCLUDING the END state,
%   even if encountered within T samples
%If mc has INFINITE duration,
%   length(S) == T
%If mc has FINITE duration,
%   length(S) <= T
%
%---------------------------------------------
%Code Authors:FEIYANG LIU, BAOQING SHE
%---------------------------------------------

S=zeros(1,T);%space for resulting row vector
nS=mc.nStates;
%error('Method not yet implemented');
for t = 1:T
    if t == 1
       prob = DiscreteD(mc.InitialProb);
    else
       prob = DiscreteD(mc.TransitionProb(S(t-1),:));
    end
  %find the next state  
    index = rand(prob,1);
  %decide infinity or finity  
    if index == nS + 1
        disp(['reach the exit state at time ', num2str(t)])
        break
    end
    
    S(t) = index;
end
%for finity case, delete 0 elements
    quit_time = find(S == 0, 1);
    if quit_time
        S = S(:, 1:(quit_time-1));
    end
end



    
    


    



