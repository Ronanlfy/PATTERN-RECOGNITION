% SongClassifier - build, train and evaluate a classifier. It is designed
% for hummed or whistled melodies (can work with both at the same time)
%
% This classifier works using Hidden Markov Models. It builds a HMM for
% each class, and uses it to estimate the log probabilities of the classes
% given new samples. The class with the maximum log probability is selected
% as the sample class.
%
% LIMITATIONS: 
% 1 - If you change your working directory after instantiating, it will
%     no longer work unless the directory name was given as an absolute
%     path.
% 2 - This is designed for WAV files, 22050 Hz sample rate, 16 bits per 
%     sample.
%--------------------------------------------------------------------------
%Code Authors:
%   Alfredo Fanghella
%   Hirahi Galindo
%--------------------------------------------------------------------------
classdef SongClassifier
    
    properties(Access=public)
        DatabaseName='.'; % path to the song database.
        % see the constructor method for info on the database format.
        Hmms=[]; % trained hmms for each class.
        Classes={}; % name of each class
        ClassPaths={}; % path to each class directory in the database.
        Trained=false;
        nStates=0; % number of states for each HMM.
    end
    
    methods(Access=public)
        
        function sc=SongClassifier(dirName, nStates)
            % Class constructor, returns a SongClassifier object.
            % Parameters:
            %   dirName: path to the database. The database is expected
            %            to consist of a root directory, containing
            %            a directory for each class. Each class directory
            %            has to contain an original.wav file with the
            %            original melody, and any amount of samples, with
            %            filenames 1.wav, 2.wav, 3.wav and so.
            %  nStates : number of states for each class HMM. The classes
            %            will be in alphabetical order, taking the 
            %            directory name as the classes name. One state for
            %            each semitone/pause should work.
            sc.DatabaseName = dirName;
            sc.nStates = nStates;
            dirInfo = dir(dirName);
            if size(dirInfo,1) == 0
                error('Could not find database');
                return;
            end
            for i=1:size(dirInfo,1)
                name = dirInfo(i).name;
                if (strcmp('.', name) == false) && (strcmp('..', name) == false)
                    sc.Classes = [sc.Classes {name}];
                    sc.ClassPaths = [sc.ClassPaths {[dirName '/' name]}];
                end
            end
            
            if length(sc.Classes) ~= length(nStates)
                error('Length of input nStates must be the same as the number of classes in the directory.');
            end
        end
        
        function sc=train(sc)
            % Return a new classifier using the complete database.
            distribution = DiscreteD();
            distribution.PseudoCount = 0.5;% smoothing

            for i=1:length(sc.Classes)
                display(sprintf('Training HMM %d.', i))
                [data, len] = loadData(sc.ClassPaths{i}, []);
                sc.Hmms = [sc.Hmms, MakeLeftRightHMM(sc.nStates(i), distribution, data, len)];
            end
            sc.Trained = true;
        end
        
        function lg = logprobs(sc, song, fs)
            % Evaluate de log probabilities for each class given a sample.
            % Parameters:
            %   song: melody to classify, as returned by audioread or the 
            %         record function.
            %   fs: audio data sample rate.
            % Output: array with log probabilities for each class in
            %         alphabetical order (i.e., the order they apper in
            %         sc.Classes.
            feature = features.semitones(features.GetMusicFeatures(song, fs));
            lg = logprob(sc.Hmms, feature);
        end
        
        function [class, lprob] = classify(sc, song, fs)
            % Classify a song
            % Parameters:
            %   song: melody to classify, as returned by audioread or the 
            %         record function.
            %   fs: audio data sample rate.
            % Outputs:
            %   class: predicted class name.
            %   lprob: log probability of the predicted class given the
            %          sample.
            [lprob, i] = max(sc.logprobs(song, fs));
            class = sc.Classes{i};
        end
        
        function [err, classErr, errList] = validate(sc, folds)
            % Calculates the error rate for the classifier using stratified
            % k-fold cross validation, and returns the error rates for each
            % class and a list with the misclassified songs and their
            % predicted class.
            % Input:
            %   folds: number of folds to consider.
            % Output:
            %   err     : average error rate.
            %   classErr: array with error rates for each class, appearing
            %              in the same order as they do in sc.Classes.
            %   errList : cell array where the {1,i} element contains the
            %             path to the ith sample misclassified, and the 
            %             {2,i} element contains its predicted class.
            
            % get the number of samples in each class
            classSize = [];
            for i=1:length(sc.Classes)
                current = length(dir(sc.ClassPaths{i}))-3;
                classSize(i) = current;
                if current < folds
                    error('Not enough samples for the number of folds.');
                end
            end
            
            % get the partitions for each class
            partition = cell(length(sc.Classes), folds, 3);
            fprintf('\nPartitioning data (%d classes):', length(sc.Classes));
            for i=1:length(sc.Classes)
                fprintf(' %d', i);
                samples = randperm(classSize(i)); % permuted song names as numbers
                for j=0:folds-1
                   low = floor(j*classSize(i)/folds)+1;
                   high = floor((j+1)*classSize(i)/folds);
                   songs = samples(low:high); % sub array for the current fold
                   [data, len] = loadData(sc.ClassPaths{i}, songs);
                   partition{i, j+1, 1} = data;
                   partition{i, j+1, 2} = len;
                   partition{i, j+1, 3} = songs;
                end
            end
            fprintf('. Done.\n')
            % Now partition{i,j,:} contains the test sequence, the length
            % of each subsequence and the corresponding song number
            % for class i, fold j.
            
            distribution = DiscreteD(); % for HMM creation
            distribution.PseudoCount = 0.5;
            
            % get error
            err = 0;
            errList = {};
            classErr = zeros(1, length(sc.Classes));
            for i=1:folds
                
                % train each HMM without using fold i
                sc.Hmms = [];
                fprintf('Building classifier %d: ', i);
                for j=1:length(sc.Classes)
                    [data, len] = sc.flattenCells(partition,j,i); % returns the training set
                    sc.Hmms = [sc.Hmms, MakeLeftRightHMM(sc.nStates(j), distribution, data, len)];
                end
                fprintf('Done. Evaluating: ');
                
                
                % evaluate fold i
                misclassified = 0;
                totalSongs = 0;
                for j=1:length(sc.Classes)
                    songs = sc.splitData(partition, j, i); % returns each test sample
                    for k=1:size(songs,2)
                        [~, classIndex] = max(logprob(sc.Hmms, songs{k,1}));
                        if classIndex ~= j
                            misclassified = misclassified + 1;
                            songName = sprintf('%s/%d.wav', sc.ClassPaths{j}, songs{k,2});
                            errList = [errList, {songName; sc.Classes{classIndex}}];
                            classErr(j) = classErr(j) + 1/classSize(j);
                        end
                    end
                    totalSongs = totalSongs + size(songs,1);
                end
                % add error to average
                fprintf('Error rate: %.6f\n', misclassified/totalSongs);
                err = err + misclassified/(totalSongs*folds);
            end
            fprintf('Average error: %.6f\n', err);
        end
        
        function sound(sc, class)
            % play the original audio for the given class.
            for i=1:length(sc.Classes)
                if strcmp(sc.Classes{i}, class)
                    [song, fs] = audioread(fullfile(sc.ClassPaths{i}, 'original.wav'));
                    sound(song, fs);
                    return;
                end
            end
            error('Input must be the name of a class.');
        end
    end
    
    methods(Access=private) % Helper methods.
        
        function [data, len] = flattenCells(sc, partition, class, fold)
            % Concatenates the feature sequences, and their lengths,
            % corresponding to class 'class', except for the one stored
            % for the given fold (which is going to be used as test data).
            data = [];
            len = [];
            for i=1:size(partition,2)
                if i ~= fold
                    data = [data, partition{class, i, 1}];
                    len = [len, partition{class, i, 2}];
                end
            end
        end
        
        function splitted = splitData(sc, partition, class, fold)
            % Splits the data for the given class and fold into songs.
           amount = length(partition{class, fold, 3});
           songs = partition{class, fold, 3};
           data = partition{class, fold, 1};
           len = partition{class, fold, 2};
           splitted = cell(amount, 2);
           low = 0;
           for i=1:amount
               splitted{i,1} = data(low+1:low+len(i));
               splitted{i,2} = songs(i);
               low = low + len(i);
           end
        end
    end
end