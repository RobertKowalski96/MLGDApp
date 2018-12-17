clc; clear all, close all;

%parameters:
hyperparameters.n=40; %osobniki
hyperparameters.tk=3000; %end cycle number
hyperparameters.mutationProb=0.001;
hyperparameters.mutationScale=0.5;
hyperparameters.CrossingOverProb=0.5;

teachingSentencesFile = 'minimumTeachingSampleGrammar1.txt';
grammarFile = 'testGrammar1Covering.txt';
positiveTestFile = 'positiveTestGrammar1.txt';
negativeTestFile = 'negativeTestGrammar1.txt';


[grammar, distanceParam, yParam, hyperparameters, populationHistory, lethalMutations, time, bestSolutionHistory] = SGA (hyperparameters, teachingSentencesFile, grammarFile, positiveTestFile, negativeTestFile);