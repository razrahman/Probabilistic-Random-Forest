function [CI,mu]=FindCI(cdf, X, Confidence)

A1=(1-Confidence)/2;
A2=1-A1;

i1=find(cdf>=A1 & cdf<=A2);
CI=[X(i1(1)) X(i1(end))];

i2=find(cdf>=0.5);
mu=X(i2(1));