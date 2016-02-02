function [D c] = Multi_D_mod(YY,Y, y, V_inv,N,copula,Command)


            NN=size(y,1);
            ybar1 = sum(y,1)/size(y,1);
            ybar2 = sum(y,1)/size(y,1);

    
       if Command==1 %%Which means using CMRF        
            M(:,1)=ksdensity(y(:,1),y(:,1),'function', 'cdf')';
            M(:,2)=ksdensity(y(:,2),y(:,2),'function', 'cdf')';
            y1=linspace(1/N,1,N);
            yy = [y1' y1'];
            m=size(yy,1);
            N1=size(M,1);
            Mat1=M(:,1)*ones(1,m);
            Mat2=M(:,2)*ones(1,m);
            C=ones(N1,1)*y1;

            MM1=Mat1<=C;
            MM2=Mat2<=C;
            [A B]=meshgrid([1:m]);
            A=A(:)';
            B=B(:)';

            MM=MM1(:,A).*MM2(:,B);
            c=sum(MM,1)/N1;
            c=reshape(c,m,m)';
            IntDiff=(sum(sum(abs(copula-c))))/N^2;
            D1=6*size(Y,1)*IntDiff;
            sigma1=std(Y(:,1));
            sigma2=std(Y(:,2));
            D2=sum((y(:,1)-ybar1(1)).^2)/(sigma1^2) + sum((y(:,2)-ybar1(2)).^2)/(sigma2^2);
            D=[D1 D2];
            
        elseif Command==2 %%Using VMRF
                    
            yhat = y - ybar2(ones(size(y,1), 1), :); % yhat = y - repmat(ybar,size(y,1),1);
            
            c=[];
            D = sum(diag((yhat*V_inv*yhat')));
            
       elseif Command==3  %%Using Regular RF
           ybar = sum(y)/size(y,1);
           D = sum((y - ybar).^2);
           c=[];
       end
    


