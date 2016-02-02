function [Count1, Count2, Count3, BB,P_val]=Count2(Mu2, Sigma2, AA_PRF,AA_wRF, finalY, F, Confidence,  Yactual)
CI_T=[];
CI_default=[];
CI_W=[];
P_val_T=[];
P_val_default=[];
P_val_W=[];
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
        
        obj=gmdistribution(mu,sigma);
        PDF_default{ii}=pdf(obj,xx);
        CDF_default{ii}=cdf(obj,xx);
        
        obj=gmdistribution(mu,sigma, abs(AA_wRF{FF}));
        PDF_W{ii}=pdf(obj,xx);
        CDF_W{ii}=cdf(obj,xx);
        
        CI_T=[CI_T;FindCI(CDF_T{ii}, xx, Confidence) ];%(ii+(FF-1)*size(Sigma{FF},1),:), Mean_T(ii)]=FindCI(CDF_T{ii}, xx, Confidencek);
        CI_default=[CI_default;FindCI(CDF_default{ii}, xx, Confidence)];%[CI_default(ii+(FF-1)*size(Sigma{FF},1),:), Mean_default(ii)]=...
        CI_W=[CI_W;FindCI(CDF_W{ii}, xx, Confidence)];
        %% P value
        Y_pos=floor(Yactual(ii)*100)+101;
        P_val_T=[P_val_T; 2*min(sum(PDF_T{ii}(1:Y_pos)),sum(PDF_T{ii}(Y_pos+1:end)))];
        P_val_default=[P_val_default; 2*min(sum(PDF_default{ii}(1:Y_pos)),sum(PDF_default{ii}(Y_pos+1:end)))];
        P_val_W=[P_val_W; 2*min(sum(PDF_W{ii}(1:Y_pos)),sum(PDF_W{ii}(Y_pos+1:end)))];
    end
end
P_val=[mean(P_val_T) mean(P_val_default) mean(P_val_W)];

Count1=0;
Count2=0;
Count3=0;
for i=1:length(Yactual)    
    if F>1
        %in=setdiff([1:size(finalY,1)], FoldedIndex{FF});
        YY=Yactual;%(in);
    else
        YY=Yactual;
    end
    
    y=YY(i);
    Count1=Count1 + (CI_T(i,1)<=y & y<=CI_T(i,2));
    Count2=Count2 + (CI_default(i,1)<=y & y<=CI_default(i,2));
    Count3=Count3 + (CI_W(i,1)<=y & y<=CI_W(i,2));
end

BB=[CI_T(:,2)-CI_T(:,1) CI_default(:,2)-CI_default(:,1) CI_W(:,2)-CI_W(:,1)];