function [Count1, Count2, BB]=Count_QRF(Mu2, Sigma2, AA_PRF,Y_testing, finalY, F, Confidence,  Yactual)
CI_T=[];
CI_W=[];
for FF=1:F
    for ii=1:size(Sigma2{FF},1)
        mu=cell2mat(Mu2{FF}(ii,:)');
        sigma=[];
        for jj=1:length(Sigma2{FF}(ii,:))
            sigma(1,1,jj)=cell2mat(Sigma2{FF}(ii,jj)');
        end
        obj=gmdistribution(mu,sigma, abs(AA_PRF{FF}));
        xx=[min(min(finalY))-1:0.01:max(max(finalY))+1]';
        PDF_T{ii}=pdf(obj,xx);
        CDF_T{ii}=cdf(obj,xx);
        
        xx2=[min(min(finalY)):0.01:max(max(finalY))]';
        X1=[];
        for jj=1:length(Sigma2{FF}(ii,:))
            X1=[X1 Y_testing{FF}{ii,jj}'];
        end
%         X1=sort(X1);
%         xx2=[min(min(finalY)):(max(max(finalY))-min(min(finalY)))/length(X1):max(max(finalY))]';
%         X_ax=unique(X1);
%         L=length(unique(X1));
%         for i=1:L
%             Y_ax(i)=length(find(X_ax(i)==X1));
%         end
        for j=1:length(xx2)
            CDF_W{ii}(j)=length(find(X1<=xx2(j)))/length(X1);
        end
%         PDF_W{ii}=X1/sum(X1); % pdf
%         CDF_W{ii}=cumsum(PDF_W{ii});
                
        CI_T=[CI_T;FindCI(CDF_T{ii}, xx, Confidence) ];%(ii+(FF-1)*size(Sigma{FF},1),:), Mean_T(ii)]=FindCI(CDF_T{ii}, xx, Confidencek);
        CI_W=[CI_W;FindCI(CDF_W{ii}, xx2, Confidence)];%[CI_default(ii+(FF-1)*size(Sigma{FF},1),:), Mean_default(ii)]=...
    end
end

Count1=0;
Count2=0;
for i=1:length(Yactual)    
    if F>1
        %in=setdiff([1:size(finalY,1)], FoldedIndex{FF});
        YY=Yactual;%(in);
    else
        YY=Yactual;
    end
    
    y=YY(i);
    Count1=Count1 + (CI_T(i,1)<=y & y<=CI_T(i,2));
    Count2=Count2 + (CI_W(i,1)<=y & y<=CI_W(i,2));
end

BB=[CI_T(:,2)-CI_T(:,1) CI_W(:,2)-CI_W(:,1)];