function [ V,P,iter ] = One_ThreeMVCUM( datas, dim, alpha, beta, MAX_ITER, map,cls_num ,y)

cnt_views = size(datas,2);
thrsh = 1e-10;
X = {}; 
n_views = {};
d_views = {};
H = {};
P = {};

for a = 1 : cnt_views
    X{a} = datas{a};% N x d
    n_views{a} = size(X{a},1);
    d_views{a} = size(X{a},2);
    X{a} = X{a}';% d x N  
    
    T = sort(X{a},2,'descend');
    mmax = repmat(T(:,1),1,n_views{a});
    minx =repmat( T(:,end),1,n_views{a} );
    X{a} = (X{a} - minx)./(mmax-minx);
    X{a}(find(isnan(X{a}))) = 0;
    
    temp_X = repmat(sqrt(sum(X{a}.^2,2)),1,size(X{a},2));
    X{a} = X{a}./temp_X; 
    X{a}(find(isnan(X{a}))) = 0;
    
    %X{a} = X{a}'; %N x d 
end


for a = 1: cnt_views
    options = [];
    options.NeighborMode = 'KNN';
    options.k = 25;
    options.WeightMode = 'HeatKernel'; %
    options.t = 0.2; %
  
    T_W= constructW(X{a}',options); %Rows of vectors of data points. Each row is x_i
    W = zeros(n_views{a});
    for i = 1:n_views{a}
        ind = find(T_W(:,i)~=0);
        W(ind,i) = T_W(ind,i);  
    end
    W=(W+W')/2;
    S{a} = W;
    if dim <=0
       dim = min(d_views{a},n_views{a}); 
    end
    U{a} = rand(d_views{a},dim); % 
    H{a} = rand(dim,dim); % 
    V{a} = ones(n_views{a},dim); % 
    
    for b = a :cnt_views
        P{a,b} = ones(n_views{a},n_views{b});% na x nb
        P{b,a} = P{a,b}';
    end
end



goal =calcGoals( X,S,U,H,V,P,alpha,beta );
iter = 1;
while(iter<= MAX_ITER)
    
    %update U H V - for each view
    for a = 1 :cnt_views
        % update U-------------------------
        F_U = U{a}'*X{a}*V{a}*H{a}' - H{a}*V{a}'*V{a}*H{a}';
        F_U_t = (abs(F_U) + F_U)/2;
        F_U_f = (abs(F_U) - F_U)/2;
        DOWN = U{a}*H{a}*V{a}'*V{a}*H{a}'+U{a}*F_U_t;
        UP = X{a}*V{a}*H{a}'+U{a}*F_U_f;
        UP(find(UP<=0)) = 0;
        DOWN(find(DOWN<=0)) = 0;
        U{a} = U{a}.* ((UP)./( DOWN ));
        U{a}(find(isnan(U{a}))) = 0;
        
        % update H-------------------------
        DOWN = U{a}'*U{a}*H{a}*V{a}'*V{a};
        UP = U{a}'*X{a}*V{a};
        UP(find(UP<=0)) = 0;
        DOWN(find(DOWN<=0)) = 0;
        H{a} = H{a}.* ( ( UP )./( DOWN ) );
        H{a}(find(isnan(H{a}))) = 0;
        % update V-------------------------
        UP = {};
        DOWN = {};
        F_V = V{a}'*X{a}'*U{a}*H{a} - H{a}'*U{a}'*U{a}*H{a};
        UP_ALL = X{a}'*U{a}*H{a} ;
        DOWN_ALL = V{a}*H{a}'*U{a}'*U{a}*H{a} ;
        
        for b = 1: cnt_views
            if a ~= b
                UP{b} = P{a,b}'*V{b}*V{b}'*P{a,b}*V{a};
                DOWN{b} = P{a,b}'*P{a,b}*P{a,b}'*P{a,b}*V{a};
                F_V = F_V + 2*beta*( V{a}'*UP{b} - V{a}'*DOWN{b});
                UP_ALL = UP_ALL + 2*beta*UP{b};
                DOWN_ALL = DOWN_ALL + 2*beta*DOWN{b};
            end
        end
        F_V_t = (abs(F_V) + F_V)/2;
        F_V_f = (abs(F_V) - F_V)/2;
        UP_ALL = UP_ALL + V{a}*F_V_f;
        DOWN_ALL = DOWN_ALL + V{a}*F_V_t;
        UP_ALL(find(UP_ALL<=0)) = 0;
        DOWN_ALL(find(DOWN_ALL<=0)) = 0;
        V{a} = V{a}.*  ( (UP_ALL)./(DOWN_ALL) );
        V{a}(find(isnan(V{a}))) = 0;
    end
    
    %update P{a,b}
    for a = 1 :cnt_views
         for b = a + 1: cnt_views
            if a ~= b
                UP = 1*(alpha* S{a}'*P{a,b}*S{b} + alpha*S{a}*P{a,b}*S{b}') + beta*V{b}*V{b}'*P{a,b}*V{a}*V{a}';
                DOWN =( alpha* S{a}'*P{a,b}*P{a,b}'*S{a}*P{a,b} + alpha*S{a}*P{a,b}*P{a,b}'*S{a}'*P{a,b}) + beta*P{a,b}*V{a}*V{a}'*P{a,b}'*P{a,b}*V{a}*V{a}';
                UP(find(UP<=0)) = 0;
                DOWN(find(DOWN<=0)) = 0;
                P{a,b} = P{a,b}.*((UP./DOWN));
                P{a,b}(find(isnan(P{a,b}))) = 0;
                P{b ,a}= P{a,b}';
            end
         end
    end
    one_res = zeros(1, 10);
    goal = calcGoals( X,S,U,H,V,P,alpha,beta );
    one_res(1:10) = goal;
    a1 = mappingsACC(P{1,2},map{1,2},1);
    a2 = mappingsACC(P{1,2},map{1,2},3);
    a3 = mappingsACC(P{1,2},map{1,2},10);
    one_res(1,1:3) = [a1,a2,a3];
    for a = 1:cnt_views
         try
             C = kmeans(V{a},cls_num);
             [A nmi avgent] = compute_nmi(y{a},C);
             acc = Accuracy(C,double(y{a}));
             [f,p,r] = compute_f(y{a},C);
             [AR,RI,MI,HI]=RandIndex(y{a},C);
             one_res(1,1+3 * a :1+3 * a + 2) = [nmi,acc,f];
             
         end
    end
    if(isnan(goal))
        break;
    end
    iter = iter+1
end


end
function [ retval ] = calcGoals( X,S,U,H,V,P,alpha,beta )
retval = 0;
cnt_views = size(S,2);
for a = 1 :cnt_views
    retval = retval + norm(X{a} - U{a}*H{a}*V{a}', 'fro');
    for b = 1 :cnt_views
        if a ~= b
           retval = retval + alpha * norm( P{a,b}'*S{a}*P{a,b}- S{b},'fro') + beta * norm( P{a,b}*V{a}*V{a}'*P{a,b}'- V{b}*V{b}','fro');
        end
    end
end

end
