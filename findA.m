function [AA, fval, fval_default] = findA(P, n_tree, Eta)
    
    addpath(genpath(pwd))
    Alpha0=ones(n_tree,1);
    Alpha0=Alpha0/sum(Alpha0);
    f=@(x)MinFunc(x,P);
    A=[-eye(n_tree);eye(n_tree)];
    b=[-(1/(Eta*n_tree))*ones(n_tree,1); ones(n_tree,1)];%Eta*n_tree
    %b=[zeros(n_tree,1); ones(n_tree,1)];
    Aeq=ones(1,n_tree);
    beq=ones(1,1);
    %options = optimset('Algorithm','interior-point');
    options = optimset('Algorithm','interior-point', 'MaxFunEvals',100000, 'MaxIter', 1000, 'TolCon', 1e-10);
    [AA]=fmincon(f,Alpha0,A,b,Aeq,beq,[],[],[], options);
    
    
    A0=ones(n_tree,1);
    A0=A0/sum(A0);
    fval_default=sum(log(P*A0));
    fval=sum(log(P*AA));