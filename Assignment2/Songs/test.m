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


%three pitches after y-axis log
figure(1)

subplot(3,1,1)
plot(T1,seq1(1,:));
ylim([100, 300]);
set(gca,'YScale','log')
title('pitch frequency of melody1')
xlabel('timeT/s');
ylabel('log(frequency)/Hz');

subplot(3,1,2)
plot(T2,seq2(1,:));
ylim([100, 300]);
set(gca,'YScale','log')
title('pitch frequency of melody2')
xlabel('timeT/s');
ylabel('log(frequency)/Hz');

subplot(3,1,3)
plot(T3,seq3(1,:));
ylim([100, 300]);
set(gca,'YScale','log')
title('pitch frequency of melody3')
xlabel('timeT/s');
ylabel('log(frequency)/Hz');


%three correlation series
figure(2)

subplot(3,1,1)
plot(T1,seq1(2,:));
title('correlation of melody1')
xlabel('timeT/s');
ylabel('correlation');

subplot(3,1,2)
plot(T2,seq2(2,:));
title('correlation of melody2')
xlabel('timeT/s');
ylabel('correlation');

subplot(3,1,3)

plot(T3,seq3(2,:));
title('correlation of melody3')
xlabel('timeT/s');
ylabel('correlation');


%three intensity series
figure(3)

subplot(3,1,1)
plot(T1,seq1(3,:));
set(gca,'YScale','log')
title('intensity of melody1')
xlabel('timeT/s');
ylabel('power');

subplot(3,1,2)
plot(T2,seq2(3,:));
set(gca,'YScale','log')
title('intensity of melody2')
xlabel('timeT/s');
ylabel('power');

subplot(3,1,3)

plot(T3,seq3(3,:));
title('intensity of melody3')
set(gca,'YScale','log')
xlabel('timeT/s');
ylabel('power');

%three transformed intensity series
figure(4)

subplot(3,1,1)
a1 = max(seq1(3,:));
b1 = min(seq1(3,:));
newint1 = seq1(3,:) / (a1 - b1);
plot(T1,newint1);
title('transformed intensity of melody1')
xlabel('timeT/s');
ylabel('power');

subplot(3,1,2)
a2 = max(seq2(3,:));
b2 = min(seq2(3,:));
newint2 = seq2(3,:) / (a2 - b2);
plot(T2,newint2);
title('transformed intensity of melody2')
xlabel('timeT/s');
ylabel('power');

subplot(3,1,3)
a3 = max(seq3(3,:));
b3 = min(seq3(3,:));
newint3 = seq3(3,:) / (a3 - b3);
plot(T3,newint3);
title('transformed intensity of melody3')
xlabel('timeT/s');
ylabel('power');







