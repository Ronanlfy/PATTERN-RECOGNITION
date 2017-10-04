%main 

clear all

filename1 = 'melody_1.wav';
[y1,fs1] = audioread(filename1);
seq1 = GetMusicFeatures(y1,fs1);

T1 = [1 : size(seq1,2)] / size(seq1,2) * (length(y1) / fs1);


filename2 = 'melody_2.wav';
[y2,fs2] = audioread(filename2);
seq2 = GetMusicFeatures(y2,fs2);
T2 = [1 : size(seq2,2)] / size(seq2,2) * (length(y2) / fs2);


filename3 = 'melody_3.wav';
[y3,fs3] = audioread(filename3);
seq3 = GetMusicFeatures(y3,fs3);
T3 = [1 : size(seq3,2)] / size(seq3,2) * (length(y3) / fs3);


[feature1,sigma1,theta1] = FeatureExtract(seq1);
[feature2,sigma2,theta2] = FeatureExtract(seq2);
[feature3,sigma3,theta3] = FeatureExtract(seq3);


%three pitches after y-axis log
figure(1)

subplot(3,1,1)
plot(T1,seq1(1,:),'b');
ylim([100, 300]);
set(gca,'YScale','log')
title('pitch frequency of melody1')
xlabel('timeT/s');
ylabel('frequency/Hz');

subplot(3,1,2)
plot(T2,seq2(1,:),'b');
ylim([100, 300]);
set(gca,'YScale','log')
title('pitch frequency of melody2')
xlabel('timeT/s');
ylabel('frequency/Hz');

subplot(3,1,3)
plot(T3,seq3(1,:),'b');
ylim([100, 300]);
set(gca,'YScale','log')
title('pitch frequency of melody3')
xlabel('timeT/s');
ylabel('frequency/Hz');


%three correlation series
figure(2)

subplot(3,1,1)
plot(T1,seq1(2,:),'b');
hold on 
plot(T1,repmat(sigma1,1,size(seq1(2,:),2)),'--r');
grid on 
title('correlation of melody1');
legend('correlation','threshold sigma')
xlabel('timeT/s');
ylabel('correlation');

subplot(3,1,2)
plot(T2,seq2(2,:),'b');
hold on 
plot(T2,repmat(sigma2,1,size(seq2(2,:),2)),'--r');
grid on 
title('correlation of melody2')
xlabel('timeT/s');
ylabel('correlation');

subplot(3,1,3)
plot(T3,seq3(2,:),'b');
hold on 
plot(T3,repmat(sigma3,1,size(seq3(2,:),2)),'--r');
grid on 
title('correlation of melody3')
xlabel('timeT/s');
ylabel('correlation');


%three intensity series
figure(3)

subplot(3,1,1)
plot(T1,seq1(3,:),'b');
set(gca,'YScale','log')
title('intensity of melody1')
xlabel('timeT/s');
ylabel('intensity');

subplot(3,1,2)
plot(T2,seq2(3,:),'b');
set(gca,'YScale','log')
title('intensity of melody2')
xlabel('timeT/s');
ylabel('intensity');

subplot(3,1,3)
plot(T3,seq3(3,:),'b');
title('intensity of melody3')
set(gca,'YScale','log')
xlabel('timeT/s');
ylabel('intensity');

%three transformed intensity series
figure(4)

subplot(3,1,1)
a1 = max(seq1(3,:));
b1 = min(seq1(3,:));
newint1 = (seq1(3,:) - b1) / (a1 - b1);
plot(T1,newint1,'b');
hold on 
plot(T1,repmat(theta1,1,size(seq1(2,:),2)),'--r');
grid on 
title('normalized intensity of melody1');
legend('normalized intensity','threshold theta')
xlabel('timeT/s');
ylabel('intensity');

subplot(3,1,2)
a2 = max(seq2(3,:));
b2 = min(seq2(3,:));
newint2 = (seq2(3,:) - b2) / (a2 - b2);
plot(T2,newint2,'b');
hold on 
plot(T2,repmat(theta2,1,size(seq2(2,:),2)),'--r');
grid on 
title('normalized intensity of melody2');
xlabel('timeT/s');
ylabel('intensity');

subplot(3,1,3)
a3 = max(seq3(3,:));
b3 = min(seq3(3,:));
newint3 = (seq3(3,:) - b3) / (a3 - b3);
plot(T3,newint3,'b');
hold on 
plot(T3,repmat(theta3,1,size(seq3(2,:),2)),'--r');
grid on 
title('normalized intensity of melody3');
xlabel('timeT/s');
ylabel('intensity');

max1 = max(feature1);
min1 = min(feature1);
max2 = max(feature2);
min2 = min(feature2);
max3 = max(feature3);
min3 = min(feature3);

figure(5)

subplot(3,1,1)
plot(T1,feature1,'b');
%set(gca,'YScale','log')
%ylim([0, 1]);
hold on 
plot(T1,repmat(max1,1,size(seq1(2,:),2)),'--r');
hold on 
plot(T1,repmat(min1,1,size(seq1(2,:),2)),'--r');
title('feature semitones of melody1')
xlabel('timeT/s');
ylabel('feature based on pitch');

subplot(3,1,2)
plot(T2,feature2,'b');
%set(gca,'YScale','log')
%ylim([0, 1]);
hold on 
plot(T2,repmat(max2,1,size(seq2(2,:),2)),'--r');
hold on 
plot(T2,repmat(min2,1,size(seq2(2,:),2)),'--r');
title('feature semitones of melody2')
xlabel('timeT/s');
ylabel('feature based on pitch');

subplot(3,1,3)
plot(T3,feature3,'b');
%set(gca,'YScale','log')
%ylim([0, 1]);
hold on 
plot(T3,repmat(max3,1,size(seq3(2,:),2)),'--r');
hold on 
plot(T3,repmat(min3,1,size(seq3(2,:),2)),'--r');
title('feature semitones of melody3')
xlabel('timeT/s');
ylabel('feature based on pitch');

%test it is roboustnesss to transposition
transSeq = seq1;
transSeq(1,:) = seq1(1,:) * 1.5;
[trans_feature,] = FeatureExtract(transSeq);

figure(6)

subplot(2,1,1)
plot(T1,feature1,'b');
%set(gca,'YScale','log')
%ylim([0, 1]);
hold on 
plot(T1,repmat(max1,1,size(seq1(2,:),2)),'--r');
hold on 
plot(T1,repmat(min1,1,size(seq1(2,:),2)),'--r');
title('feature semitones of melody1')
xlabel('timeT/s');
ylabel('feature based on pitch');

subplot(2,1,2)
plot(T1,trans_feature,'b');
%set(gca,'YScale','log')
%ylim([0, 1]);
hold on 
plot(T1,repmat(max1,1,size(seq1(2,:),2)),'--r');
hold on 
plot(T1,repmat(min1,1,size(seq1(2,:),2)),'--r');
title('feature semitones of melody1 after transposition')
xlabel('timeT/s');
ylabel('feature based on pitch');

%compare similarity


