function [Mu, Sigma,YY,rho] = FindP_test(XX,n_tree,M)

%             P=zeros(n_tree,size(Xt,1));
            addpath(genpath(pwd));

            for T=1:n_tree
                X=XX;%X1(M.bootsam(:,T),:);
                %X=X1;
                Y=M.training_response(M.bootsam(:,T),:);
                Tree=M.forest{T};
                Parent=Tree.Parent;
                
                %%%Finding paths
                Paths={};
                for i=1:length(Parent)
                    if Tree.isleaf(i)==1
                        Paths=[Paths;Tree.findpath(1,i)];
                    end
                end
                %%%%%%%%%%%%%%%%
                
                P3=zeros(1,length(Paths));
                PP3=P3;
                if size(Y,2)==1
                    mu=P3;
                    sigma=P3;
                else
                    mu=[P3' P3']';
                    sigma=[P3' P3']';
                end
                
                for k=1:size(X,1)
                    x=X(k,:);
                    for i=1:length(Paths)
                        Path=Paths{i};
                        P2=zeros(1,length(Path));
                        P2(1)=1;

                        for j=1:length(Path)-1
                                N=Path(j);
                                %Index=[Tree.Node{N}{4}{1} Tree.Node{N}{4}{2}];
                                %x=X((Index),:);
                                Eta=zeros(1,size(x,2));
                                Tau=zeros(1,size(x,2));
                                Pick=Tree.Node{N}{1};
                                Threshold=Tree.Node{N}{2};
                                Eta(Pick)=100*Threshold;
                                Tau(Pick)=Threshold;
                                %Tau=repmat(Tau,size(x,1),1);
                                P1=1./(1+exp(Eta*(x'-Tau')));

                                Ch=Tree.getchildren(N);
                                if Ch(1)==Path(j+1)
                                    P2(j+1)=P1;
                                else
                                    P2(j+1)=1-P1;
                                end
                        end
                        
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        y=Tree.Node{Path(j+1)}(:,2:end);
                        mu(:,i)=mean(y)';
                        
                        sigma(:,i)=std(y)';
                        
                        if sum(std(y))<0.00001
                            sigma(:,i)=std(Y)'/5;
                        end
                        
%                         if size(Y,2)==1
%                             pp=normpdf(Y(k,:), mu(:,i), sigma(:,i));
%                         elseif size(Y,2)==2
%                             pp=mvnpdf(Y(k,:), mu(:,i)', sigma(:,i)');
%                         end
                        
%                         P3(i)=pp*prod(P2);
                        PP3(i)=prod(P2);
                        if PP3(i)>0.5
                            YYY=y;
                        end
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %P3(i)=prod(P2);
                        
                        
                    end
                    YY{k,T}=YYY;
                    Mu{k, T}=(mu*PP3')';
                    Sigma{k, T}=sqrt(((sigma.^2)*PP3')');

%                     P(T, k)=sum(P3);
                end
            end
            
            In=nchoosek(1:n_tree,2);
            for k=1:size(X,1)
                for I=1:size(In,1)
                    l1=length(YY{k,In(I,1)});
                    l2=length(YY{k,In(I,2)});
                    combos=[];
                    for i=1:l1
                        for j=1:l2
                            combos = [combos ; [YY{k,In(I,1)}(i) YY{k,In(I,2)}(j)]];
                        end
                    end
                    rho(k,I)=min(min(corrcoef(combos(:,1),combos(:,2))));
                    if(isnan(rho(k,I)))%|| rho(k,:)<0.000001
                        rho(k,I)=0;
                    end
                end
            end
            
           
            for T1=1:n_tree
                for T2=1:n_tree
                     com=[];
                    for k=1:25
                        for j=1:20
                            com=[com ; datasample(YY{k,T1},1) datasample(YY{k,T2},1)];
                        end
                    end
                    rhoo(T1,T2)=min(min(corrcoef(com(:,1),com(:,2))));
                    stdd{T1,T2}(1)=std(com(:,1));
                    stdd{T1,T2}(2)=std(com(:,2));
                    cova(T1,T2)=min(min(corrcoef(com(:,1),com(:,2))))*std(com(:,1))*std(com(:,2));
                end
            end
            