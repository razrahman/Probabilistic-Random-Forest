clear; close all; clc;

n_tree=50;
mtree=10;
F=5;
min_leaf=5;
Eta=4;
load('finalX_all15')
load('finalY_all15')%8,9 has high values

for j=1:size(finalY,2)
    FA{j}=find(finalY(:,j)>0.1);
    finalX1{j}=finalX(FA{j},:);
    finalY1{j}=finalY(FA{j},j);
    
    if F>1
        [Xtrain{j},Xtest,Ytrain{j},Ytest,FoldedIndex]=CreateFoldedDataMRF(finalX1{j},finalY1{j},F);
    else
        [Xtrain{j},Xtest,Ytrain{j},Ytest,FoldedIndex]=CreateFoldedDataResub(finalX1{j},finalY1{j},F);
    end
    
%     FoldedIndex=[];
%     Yact=YactualV{j};
%     DrugNumber=length(Yact);
%     for i=1:F-1
%         for jj=1:floor(DrugNumber/F)
%             [A,FoldedIndex{i}(jj),ib]=intersect(finalY1{j},Yact(jj+(i-1)*floor(DrugNumber/F),:));
%         end
%         %Yact=setdiff(Yact,Yact(ib,:));
%         if i==F-1
%             for jj=1:DrugNumber-length(Yact(1:i*floor(DrugNumber/F),:))
%                 [A,FoldedIndex{i+1}(jj),ib]=intersect(finalY1{j},Yact(jj+(F-1)*floor(DrugNumber/F),:));
%             end
%         end
%     end
    Command=3;
    Column=1;
    tic
    [YactualP{j},YpredP{j},YpredPB{j}, P{j}, AA{j}, Mu1{j},Mu2{j}, Sigma1{j},Sigma2{j},...
        LH_T{j}, LH_default{j},ModelPRF{j}]...
        = Main_PRF_New(finalX1{j},finalY1{j},F,n_tree,mtree,Column,Command, min_leaf, Eta, FoldedIndex);
    Time_PRF(i)=toc;
    tic
    [YactualV{j},YpredV{j},YpredVB{j},ModelRF{j},AA_deafault{j}]...
        =Main_VRF_New(finalX1{j},finalY1{j},F,n_tree,mtree,Column,Command, min_leaf, FoldedIndex);
    Time_RF(i)=toc;
    tic
    [YactualW{j},YpredW{j},WRF_A{j}]=Main_wRF_New(finalX1{j},finalY1{j},F,n_tree,mtree,Column,Command, min_leaf, FoldedIndex);
    Time_wRF(i)=toc;
    ll=length(YactualP{j});
    NRMSEV(j,:)=sqrt(((YactualV{j}-YpredV{j})'*(YactualV{j}-YpredV{j}))...
        /((YactualV{j}-(ones(1,ll)*YpredV{j}/ll)*ones(ll,1))'*(YactualV{j}-(ones(1,ll)*YpredV{j}/ll)*ones(ll,1))));
    NRMSEP(j,:)=sqrt(((YactualP{j}-YpredP{j})'*(YactualP{j}-YpredP{j}))...
        /((YactualP{j}-(ones(1,ll)*YpredP{j}/ll)*ones(ll,1))'*(YactualP{j}-(ones(1,ll)*YpredP{j}/ll)*ones(ll,1))));
    NRMSEW(j,:)=sqrt(((YactualW{j}-YpredW{j})'*(YactualW{j}-YpredW{j}))...
        /((YactualW{j}-(ones(1,ll)*YpredW{j}/ll)*ones(ll,1))'*(YactualW{j}-(ones(1,ll)*YpredW{j}/ll)*ones(ll,1))));
    MSE1V(j,:)=mean((YactualV{j}-YpredV{j}).^2);
    MSE1P(j,:)=mean((YactualP{j}-YpredP{j}).^2);
    MSE1W(j,:)=mean((YactualW{j}-YpredW{j}).^2);
    
    MAEV(j,:)=mean(abs(YactualV{j}-YpredV{j}));
    MAEP(j,:)=mean(abs(YactualP{j}-YpredP{j}));
    MAEW(j,:)=mean(abs(YactualW{j}-YpredW{j}));
    
    CRF1V(j,:)=corr(YactualV{j}, YpredV{j});
    CRF1P(j,:)=corr(YactualP{j}, YpredP{j});
    CRF1W(j,:)=corr(YactualW{j}, YpredW{j});
    
    
    BiasVV(j,:) =mean(YpredV{j})-mean(YactualV{j});
    BiasPP(j,:) =mean(YpredP{j})-mean(YactualP{j});
    BiasWW(j,:) =mean(YpredW{j})-mean(YactualW{j});
    %
    VarV(j,:)  = var(YpredV{j}  -YactualV{j});
    VarP(j,:)  = var(YpredP{j}  -YactualP{j});
    VarW(j,:)  = var(YpredW{j}  -YactualW{j});
end
for j=1:size(finalY,2)
    
    %     FF=5;
    Confidence=[0.50 0.70 0.80 0.95 0.99];
    for k=1:length(Confidence)
        [Count11(j,k), Count12(j,k), Count13(j,k),BB{j}, P_val(j,:)]...
            =Count2(Mu2{j}, Sigma2{j}, AA{j},WRF_A{j}, finalY1{j}, F,Confidence(k),  YactualP{j});
        
        NN(j,k)=length(BB{j}(:,1));
        NNN(j,k)=sum((BB{j}(:,1)-BB{j}(:,2))<0);
        mBB{k}(j,1)=mean(BB{j}(:,1));
        mBB{k}(j,2)=mean(BB{j}(:,2));
        mBB{k}(j,3)=(mBB{k}(j,2)-mBB{k}(j,1))/mBB{k}(j,1)*100;
        
        NNN2(j,k)=sum((BB{j}(:,1)-BB{j}(:,3))<0);
        mBB2{k}(j,1)=mean(BB{j}(:,1));
        mBB2{k}(j,2)=mean(BB{j}(:,3));
        mBB2{k}(j,3)=(mBB2{k}(j,2)-mBB2{k}(j,1))/mBB2{k}(j,1)*100;
    end
end
MBBB=cell2mat(mBB);
MBBB2=cell2mat(mBB2);
% [MAEV MAEP MAEW]
% [MSE1V MSE1P MSE1W]
% [NRMSEV NRMSEP NRMSEW]
% [CRF1V CRF1P CRF1W]
% [MBBB(:,3) MBBB(:,6) MBBB(:,9) MBBB(:,12) MBBB(:,15)]
% [MBBB2(:,3) MBBB2(:,6) MBBB2(:,9) MBBB2(:,12) MBBB2(:,15)]
% P_val

% save('PRF_CCLE_modified3_all_drugs_15_tree40_4T_relieff_revised1.mat')
%modified2 for picking high values of finalY, modified for cross validation within cross validation