clear all;
clc;

clear all;
clc;

addpath(genpath(pwd))

%finalX=rand(50,10);
% Y1=2*finalX(:,1)+4*finalX(:,2)-1.5*finalX(:,3)+1*finalX(:,4);
% Y2=0.5*(Y1)+2;
% Y3=(Y1-mean(Y1)).^2;
% finalY1=[Y1 Y2];
% finalY2=[Y1 Y3];

load('Result_GDSC_6_method1_Final.mat')
[Xtrain,Xtest,Ytrain,Ytest]=CreateFoldedDataRF(finalX,finalY2,F,FoldedIndex);

NumVariable=size(finalX,2);

matlabpool open
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%matlabpool open 4       
%[AAD_OOB11 NumRepeatation11]=findVIM_OOB(M11,NumVariable,n_tree,Xtrain, Ytrain,1);
[AAD_OOB12 NumRepeatation12]=findVIM_OOB(M12,NumVariable,n_tree,Xtrain, Ytrain,1);
%[AAD_OOB21 NumRepeatation21]=findVIM_OOB(M21,NumVariable,n_tree,Xtrain, Ytrain,2);
[AAD_OOB22 NumRepeatation22]=findVIM_OOB(M22,NumVariable,n_tree,Xtrain, Ytrain,2);
%matlabpool close

matlabpool close

VIM_V=sum(NumRepeatation22)./(sum(sum(NumRepeatation22)));
VIM_C=sum(NumRepeatation12)./(sum(sum(NumRepeatation12)));

% VIM_V=(1-sum(AAD_OOB22))*NumRepeatation22;
% VIM_C=(1-sum(AAD_OOB12))*NumRepeatation12;

[VIM_V VIM_V_ind]=sort(VIM_V,'descend');
[VIM_C VIM_C_ind]=sort(VIM_C,'descend');

Out=[C1MRF22(1,2) C1MRF12(1,2);C2MRF22(1,2) C2MRF12(1,2)]
VIM_V=VIM_V/sum(VIM_V)
VIM_C=VIM_C/sum(VIM_C)
VIM_V_ind
VIM_C_ind

% error12=Ypred12-Yactual12;
% e12=mean(abs(error12));
% Y12=Ypred12+e(ones(1,size(error12,1)),:);

% [NumRepeatation1, AAD11, AAD12]=findVIM_Perm(M1,NumVariable,n_tree,Xtrain);
% [NumRepeatation2, AAD21, AAD22]=findVIM_Perm(M2,NumVariable,n_tree,Xtrain);
% 
% 
% 
% 
% VIM11=(AAD11-AAD12)/sum(AAD11-AAD12);
% VIM12=(AAD21-AAD22)/sum(AAD21-AAD22);
% 
% 
% VIM21=findVIM(M1,NumVariable,n_tree);
% VIM22=findVIM(M2,NumVariable,n_tree);
% 
% VIM1=(VIM11+VIM21)/2;
% VIM2=(VIM21+VIM22)/2;
% 
% % VIM1=VIM11
% % VIM2=VIM12
% 
% [SortedVIM1 In1]=sort(VIM1,'descend');
% [SortedVIM2 In2]=sort(VIM2,'descend');
% 
%  A1=[In1;SortedVIM1;In2;SortedVIM2]
% 
% VIM1=VIM11;
% VIM2=VIM12;
% [SortedVIM1 In1]=sort(VIM1,'descend');
% [SortedVIM2 In2]=sort(VIM2,'descend');
% 
%  A2=[In1;SortedVIM1;In2;SortedVIM2]
%  
% VIM1=VIM21;
% VIM2=VIM22;
% [SortedVIM1 In1]=sort(VIM1,'descend');
% [SortedVIM2 In2]=sort(VIM2,'descend');
% 
%  A3=[In1;SortedVIM1;In2;SortedVIM2]
%  