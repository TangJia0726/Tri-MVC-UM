function [ acc ] = mappingsACC(P,map,k)
%������ȷ�� ������ͼӳ����ȷ�� ����  ǰk����Χ�ڵ�ӳ����ȷ�� pΪ1->2
%ÿһ�е���С sort(x,2) Ӧ��ȡ��ǰ�漸�� sort(x,2,'descend')
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

