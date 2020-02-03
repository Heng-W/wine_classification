function [center, flag, Cu, cnt] = Kmeans(data, N, center_init, option)
%K-means聚类
% Inputs:
%    data:样本集   N:聚类数目   center_init:初始化的均值向量(输入为空则随机产生)
% Outputs:
%    center:更新得到的均值向量  flag:样本类别值
%    Cu:分类得到的簇  cnt:更新次数

[m, n] = size(data);
flag = zeros(m, 1);
Cu = cell(1, N);
cnt = 0;

if isempty(center_init)
    center = zeros(N, n);
    %随机产生聚类中心
    for i = 1:N
        center(i, :) = data(randi(m, 1), :);
    end
else
    center = center_init;
end
dist = zeros(1, N);
new_center = zeros(N, n);
while 1
    for i = 1:N
        Cu{i} = [];
    end
    for x = 1:m
        for y = 1:N
            dist(y) = norm(data(x, :) - center(y, :));%计算到每个聚类中心的距离
        end
        [~, temp] = min(dist);%求最小的距离
        flag(x, 1) = temp;
        if isempty(Cu{temp})
            Cu{temp} = data(x,:);
        else
            Cu{temp} = union(Cu{temp}, data(x, :), 'rows');
        end
    end
    k = 0;
    for i = 1:N
        m1 = size(Cu{i}, 1);
        if m1 ~= 0
            new_center(i, :) = sum(Cu{i}(:, 1:n)) / m1;
        end
        if norm(new_center(i, :) - center(i, :)) < 0.001
            k = k + 1;
        end
    end
    if k == N
        break;
    else
        center = new_center;
        cnt = cnt + 1;
    end
end

if nargin > 3
    switch option
        case 'ShowFigure'
            color = {'r','g','b','c','y','m','k'};
            figure;
            title('分类结果');
            for i = 1:N
                if i <= size(color, 2)
                    paint_color = color{i};
                else
                    paint_color = rand(1, 3);
                end
                if n == 2
                    scatter(Cu{i}(:, 1), Cu{i}(:, 2), 15, paint_color);
                else
                    scatter3(Cu{i}(:, 1), Cu{i}(:, 2), Cu{i}(:, 3), 15, paint_color);
                end
                hold on;
            end
            grid on;
        otherwise
            fprintf('选项不存在');
    end
end

end

