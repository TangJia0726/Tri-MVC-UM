function [ X,y,v,n,d] = loadData( p )
%LOADDATA �������� ·��  
%   p ���ݵ�·���������ж��
%   X ����
%   y ��ǩ
%   n ���ݵĸ���
%   d ���ݵ�ά��
%   v ��ͼ����
v = size(p,2); %���㵽�׼��ص���ͼ���ݻ��Ƕ���ͼ����
for a = 1:v
    rX = load(p{v}); %һ����˵����N x D  ���Ϊ N x D
    [n{a},d{a}] = size(rX);
    y{a} = rX(:,end);
    X{a} = rX(:,1:end-1);
end;
end

