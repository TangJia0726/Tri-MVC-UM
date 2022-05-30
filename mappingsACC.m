function [ acc ] = mappingsACC(P,map,k)
%计算正确率 单个视图映射正确率 函数  前k个范围内的映射正确性 p为1->2
%每一行的最小 sort(x,2) 应该取最前面几个 sort(x,2,'descend')
[A,C] = sort(P,2,'descend');
[tops] = C(:,1:k);
cnt = 0;
for i = 1:size(P,1)   
    for j = 1:k
       if(map(1,i) == tops(i,j))
          cnt = cnt+1; 
       end
    end
end
acc = cnt/size(P,1);
end

