function [ datas, labels, mappings] = processData( raw_data,y,levels )
% process_data 将不同视图的数据随机打乱,并进行随机删减
% 输入：
%   raw_data：原始数据 Nxd 最后一列为真实标签
% 输出：
%   datas：数据 用来求解 每个视图中数据不一样
%   labels:拆开的每个视图对应的真实的标签
%   mappings：原始数据与打乱数据之间的映射关系 用于最后的验证

n_views = size(raw_data,2); %捕获视图的总个数
for a = 1 : n_views 
   raw_data{a} = [ raw_data{a},y{a}]; 
end
mappings ={};
labels = {};
datas = {};
for a = 1 : n_views 
    %获取当前视图的数据总数
    n_view_a = size(raw_data{a}, 1);
    d_view_a = size(raw_data{a}, 2);
    mapping = randperm(n_view_a); %产生随机位置
    %交换数据
    datas{a} = zeros(size(raw_data{a}));
    for i = 1:n_view_a
       %进行置换
       datas{a}(i,:) = raw_data{a}(mapping(i),:);
    end
    n_view_a = ceil(n_view_a - n_view_a * levels(a));
    datas{a} = datas{a}(1:n_view_a,:);
    labels{a} = datas{a}(:,end);
    datas{a} = datas{a}(1:n_view_a,1:end-1);
    mappings{a} = mapping(1:n_view_a);%可能存在不同的个数 因此不能直接用矩阵
end
end

