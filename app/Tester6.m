clc,clear all

[grammar] = loadGrammar('TEST_Grammar2Min.txt');

n=5;

[population] = initPopulation (grammar, n)