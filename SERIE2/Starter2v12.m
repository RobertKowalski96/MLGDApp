clc; clear all, close all;

%parameters:
hyperparameters.n=160; %osobniki
hyperparameters.tk=3000; %end cycle number
hyperparameters.mutationProb=0.01;
hyperparameters.mutationScale=0.5;
hyperparameters.CrossingOverProb=0.5;
modelZero.terminals = ['a', 'b', 'c'];
modelZero.terminalsFreq = [1, 1, 1];

teachingSentencesFile = 'minimumTeachingSampleGrammar1.txt';
grammarFile = 'testGrammar1Covering3.txt';
positiveTestFile = 'positiveTestGrammar1.txt';
negativeTestFile = 'negativeTestGrammar1.txt';


[grammar, distanceParam, yParam, hyperparameters, populationHistory, lethalMutations, time, bestSolutionHistory, modelZero] = SGA (hyperparameters, teachingSentencesFile, grammarFile, positiveTestFile, negativeTestFile, modelZero);