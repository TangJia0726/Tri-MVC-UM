function [ X,y,v,n,d] = loadData( p )
%LOADDATA 加载数据 路径  
%   p 数据的路径，可能有多个
%   X 数据
%   y 标签
%   n 数据的个数
%   d 数据的维度
%   v 视图个数
v = size(p,2); %计算到底加载单视图数据还是多视图数据
for a = 1:v
    rX = load(p{v}); %一般来说都是N x D  输出为 N x D
    [n{a},d{a}] = size(rX);
    y{a} = rX(:,end);
    X{a} = rX(:,1:end-1);
end;
end

