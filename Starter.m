clc; clear all, close all;

%parameters:
hyperparameters.n=40; %osobniki
hyperparameters.tk=100; %end cycle number
hyperparameters.mutationProb=0.001;
hyperparameters.mutationScale=0.4;
hyperparameters.CrossingOverProb=0.4;

sentencesFile = 'sentences.txt';
grammarFile = 'TEST_Grammar2Min.txt';


[grammar, distanceParam, yParam, hyperparameters, populationHistory, lethalMutations, time] = SGA (hyperparameters, sentencesFile, grammarFile);