

name = ['nn_wine.txt'];
%%wine�Ѿ��Ǵ��ҵ����ݼ���
load('X_WINE.mat');
load('M_WINE.mat');
load('Y_WINE.mat');
v = size(X,2);
n = size(X{v},1);
d = size(X{v},2);


%% ��ȡ��ʵ�ı�ǩ+1  �Լ��ܵ���Ҫ�ľ������ 
for a = 1 :v
    y{a} = y{a}+1;
end
cls_num = max(y{1}); %��ȡ�ܹ���ظ��� ʹ�þ��������ΪK

%% ����������ʵ��ӳ���ϵ  ��λ
map = {};
map{1,2} = located(mappings,1,2); %ֻ��һ�� ��һ�� ֱ���ҵ� ��Ӧ2��ͼ����ʵ�Ķ�λ
map{2,1} = located(mappings,2,1); 




%% Ѱ��ÿһ����ͼ���Ų��� - ���� ( datas, dim, alpha, beta, MAX_ITER )
num_para = 9; %������ͼ���Ϊ9
results = zeros(1100, num_para + 2);
one_res = zeros(1, num_para);


alphas = [0.1];
betas=  [0.00001];

MAX_ITER = 500;
row = 1;
for alpha = alphas
    for beta = betas
        iter = 1;
        [V,P,iter] = One_ThreeMVCUM(X, cls_num , alpha,beta,MAX_ITER,map,cls_num,y);
        % �õ����н�� ���д��� ��nanֵ����infֵ �˴ν������¼
        flag = 0;
        if iter ~=501 
            flag = 1;
        else 
            for a = 1:v
                if sum(sum(isnan(V{a})))~=0 || sum(sum(isnan(V{a})))~=0
                    flag = 1;
                end
            end
        end
        
        if flag == 1
            one_res = [-1,-1,-1,-1,-1,-1,-1,-1,-1];
            results(row,1:num_para) = one_res;
            results(row,num_para+1) = alpha;
            results(row,num_para+2) = beta;

            dlmwrite(name,results , 'precision', '%5f', 'delimiter', '\t');
            row = row +1;
            continue; %������һ�� 
        end
        
        %% ���μ�¼��Ч
        a1 = mappingsACC(P{1,2},map{1,2},1);
        a2 = mappingsACC(P{1,2},map{1,2},3);
        a3 = mappingsACC(P{1,2},map{1,2},10);
        one_res(1,1:3) = [a1,a2,a3];
        for a = 1:v
             V{a}(V{a}==0) = 1e-8;
             C = kmeans(V{a},cls_num);
             [A nmi avgent] = compute_nmi(y{a},C);
             acc = Accuracy(C,double(y{a}));
             [f,p,r] = compute_f(y{a},C);
             [AR,RI,MI,HI]=RandIndex(y{a},C);
             %��¼���е� nmi acc f
             one_res(1,1+3 * a :1+3 * a + 2) = [nmi,acc,f];
        end
        results(row,1:num_para) = one_res;
        results(row,num_para+1) = alpha;
        results(row,num_para+2) = beta;
        dlmwrite(name,results , 'precision', '%5f', 'delimiter', '\t');
        row = row +1;

    end
end



%% �ҵ����Ų��� ���м���ÿһ�ε��������



