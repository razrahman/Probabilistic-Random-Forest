function [Count1, Count2, BB]=Count(Mu, Sigma, AA, finalY, FF,F, Confidence, FoldedIndex, YpredP)


if size(finalY,2)==1 || size(finalY,2)==2
        for ii=1:size(Sigma{FF},1);
            mu=cell2mat(Mu{FF}(ii,:)');
            sigma=[];
            for jj=1:length(Sigma{FF}(ii,:))
                sigma(1,1,jj)=cell2mat(Sigma{FF}(ii,jj)');
            end
            obj=gmdistribution(mu,sigma, abs(AA{FF}));
            xx=[min(min(finalY))-1:0.01:max(max(finalY))+1]';
            PDF_T{ii}=pdf(obj,xx);
            CDF_T{ii}=cdf(obj,xx);
            obj=gmdistribution(mu,sigma);
            PDF_default{ii}=pdf(obj,xx);
            CDF_default{ii}=cdf(obj,xx);

            [CI_T(ii,:), Mean_T(ii)]=FindCI(CDF_T{ii}, xx, Confidence);
            [CI_default(ii,:), Mean_default(ii)]=FindCI(CDF_default{ii}, xx, Confidence);

        end

        Count1=0;
        Count2=0;

         for i=1:size(Sigma{FF},1)

             if F>1
                in=setdiff([1:size(finalY,1)], FoldedIndex{FF});
                YY=YpredP(in);
             else
                YY=YpredP;
             end

             y=YY(i);
             Count1=Count1 + (CI_T(i,1)<=y & y<=CI_T(i,2));
             Count2=Count2 + (CI_default(i,1)<=y & y<=CI_default(i,2));
         end
         
         BB=[CI_T(:,2)-CI_T(:,1) CI_default(:,2)-CI_default(:,1)];

else

        for ii=1:size(Sigma{FF},1);
            mu=cell2mat(Mu{FF}(ii,:)');
            sigma=[];
            for jj=1:length(Sigma{FF}(ii,:))
                sigma(1,1:size(finalY,2),jj)=cell2mat(Sigma{FF}(ii,jj)');
            end
            obj=gmdistribution(mu,sigma, abs(AA{FF}));
            xx=[min(min(finalY))-1:0.01:max(max(finalY))+1]';
            [xx1, xx2]=meshgrid(xx,xx);
            PDF_T{ii}=reshape(pdf(obj,[xx1(:) xx2(:)]), length(xx(:)), length(xx(:)));
            CDF_T{ii}=reshape(cdf(obj,[xx1(:) xx2(:)]), length(xx(:)), length(xx(:)));
            obj=gmdistribution(mu,sigma);
            PDF_default{ii}=reshape(pdf(obj,[xx1(:) xx2(:)]), length(xx(:)), length(xx(:)));
            CDF_default{ii}=reshape(cdf(obj,[xx1(:) xx2(:)]), length(xx(:)), length(xx(:)));

            [CI_T(ii,:), Mean1_T(ii)]=FindCI(CDF_T{ii}, xx, Confidence);
            [CI_default(ii,:), Mean1_default(ii)]=FindCI(CDF_default{ii}, xx, Confidence);

        end

        Count1=0;
        Count2=0;

         for i=1:size(Sigma{FF},1)

             if F>1
                in=setdiff([1:size(finalY,1)], FoldedIndex{FF});
                YY=YpredP1(in);
             else
                YY=YpredP1;
             end

             y=YY(i);
             Count1=Count1 + (CI_T(i,1)<=y & y<=CI_T(i,2));
             Count2=Count2 + (CI_default(i,1)<=y & y<=CI_default(i,2));
         end
end