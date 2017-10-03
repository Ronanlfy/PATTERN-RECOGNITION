%code for problem 2
mc=MarkovChain([0.75;0.25], [0.99 0.01;0.03 0.97]);
seq = rand(mc,10000);

a = find(seq==1);
b = find(seq==2);
%calculate the relative frequency of occurrences
freq_1 = length(a) / (length(a) + length(b));
freq_2 = length(b) / (length(a) + length(b));
disp('the relative frequency of occurrences of St = 1:');
disp(freq_1);
disp('the relative frequency of occurrences of St = 2:');
disp(freq_2);

