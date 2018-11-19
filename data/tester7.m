clc, clear all

test=[1,1,1,1,1,1,1];

ind={1,3,4,6};

idx=cell2mat(ind)

same=sum(test(idx))

test(idx)=test(idx)/same