clc; clear all, close all;

%parameters:
hyperparameters.n=40; %osobniki
hyperparameters.tk=300; %end cycle number
hyperparameters.mutationProb=0.001;
hyperparameters.mutationScale=0.4;
hyperparameters.CrossingOverProb=0.4;
modelZero.terminals = ['a', 'b', 'c'];
modelZero.terminalsFreq = [1, 1, 1];

teachingSentencesFile = 'minimumTeachingSampleGrammar1.txt';
grammarFile = 'testGrammar1Covering.txt';
positiveTestFile = 'positiveTestGrammar1.txt';
negativeTestFile = 'negativeTestGrammar1.txt';


[grammar, distanceParam, yParam, hyperparameters, populationHistory, lethalMutations, time, bestSolutionHistory, modelZero] = SGA (hyperparameters, teachingSentencesFile, grammarFile, positiveTestFile, negativeTestFile, modelZero);