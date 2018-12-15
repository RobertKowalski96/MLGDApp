clc; clear all, close all;

%parameters:
hyperparameters.n=40; %osobniki
hyperparameters.tk=200; %end cycle number
hyperparameters.mutationProb=0.001;
hyperparameters.mutationScale=0.4;
hyperparameters.CrossingOverProb=0.4;

teachingSentencesFile = 'minimumTeachingSampleGrammar1.txt';
grammarFile = 'testGrammar1Min.txt';
positiveTestFile = 'positiveTestGrammar1.txt';
negativeTestFile = 'negativeTestGrammar1.txt';


[grammar, distanceParam, yParam, hyperparameters, populationHistory, lethalMutations, time, bestSolutionHistory] = SGA (hyperparameters, teachingSentencesFile, grammarFile, positiveTestFile, negativeTestFile);