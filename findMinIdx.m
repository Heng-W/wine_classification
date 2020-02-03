function  flag = findMinIdx(data, vects)
%找到最小距离的行向量索引值
% Inputs:
%    data:样本集  vects:向量组
% Output:
%    flag:索引值矩阵（列向量）

m = size(data, 1);
N = size(vects, 1);
flag = zeros(m, 1);
dist = zeros(1, N);

for i = 1:m
    for k = 1:N
        dist(k) = norm(data(i, :) - vects(k, :));%计算到每个聚类中心的距离
    end
    [~, flag(i, 1)] = min(dist);      %求最小的距离
end

end

