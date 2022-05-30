function [ datas, labels, mappings] = processData( raw_data,y,levels )
% process_data ����ͬ��ͼ�������������,���������ɾ��
% ���룺
%   raw_data��ԭʼ���� Nxd ���һ��Ϊ��ʵ��ǩ
% �����
%   datas������ ������� ÿ����ͼ�����ݲ�һ��
%   labels:�𿪵�ÿ����ͼ��Ӧ����ʵ�ı�ǩ
%   mappings��ԭʼ�������������֮���ӳ���ϵ ����������֤

n_views = size(raw_data,2); %������ͼ���ܸ���
for a = 1 : n_views 
   raw_data{a} = [ raw_data{a},y{a}]; 
end
mappings ={};
labels = {};
datas = {};
for a = 1 : n_views 
    %��ȡ��ǰ��ͼ����������
    n_view_a = size(raw_data{a}, 1);
    d_view_a = size(raw_data{a}, 2);
    mapping = randperm(n_view_a); %�������λ��
    %��������
    datas{a} = zeros(size(raw_data{a}));
    for i = 1:n_view_a
       %�����û�
       datas{a}(i,:) = raw_data{a}(mapping(i),:);
    end
    n_view_a = ceil(n_view_a - n_view_a * levels(a));
    datas{a} = datas{a}(1:n_view_a,:);
    labels{a} = datas{a}(:,end);
    datas{a} = datas{a}(1:n_view_a,1:end-1);
    mappings{a} = mapping(1:n_view_a);%���ܴ��ڲ�ͬ�ĸ��� ��˲���ֱ���þ���
end
end

