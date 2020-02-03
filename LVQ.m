function [pv,flag] = LVQ(data, label, pv_init, pv_label, lr, iter_cnt, option)
%Learning Vertor Quantization（学习矢量量化），监督型聚类，训练出一组原型向量
% Inputs:
%   data:样本集   label:标签   pv_init:初始化的原型向量(输入为空则随机产生)
%   pv_label:原型向量标签   lr:学习率   iter_cnt:迭代次数
% Outputs:
%   pv:训练得到的原型向量
%   flag:由训练结果得到的样本类别值

[m,n] = size(data);
q = size(pv_label,1);
dist = zeros(1,q);
flag = zeros(m,1);

if isempty(pv_init)
    pv = zeros(q,n);
    for i = 1:q
        while 1
            j = randi(m,1);
            if label(j,1) == pv_label(i,1)
                pv(i,:) = data(j,:);
                break;
            end
        end
    end
else
    pv = pv_init;
end;

for iter = 1:iter_cnt;
    j = randi(m,1);%随机选取样本
    for i = 1:q
        dist(i) = norm(data(j,:) - pv(i,:));%计算到每个原型向量的距离
    end
    [~, idx] = min(dist);%求最小距离
    
    if label(j,1) == pv_label(idx,1)
        new_pv = pv(idx,:) + lr*(data(j,:) - pv(idx,:));
    else
        new_pv = pv(idx,:) - lr*(data(j,:) - pv(idx,:));
    end
    pv(idx,:) = new_pv;
end

for x = 1:m
    for i = 1:q
        dist(i) = norm(data(x,:) - pv(i,:));
    end
    [~, flag(x,1)] = min(dist);
end

if nargin > 6
    switch option
        case 'ShowFigure'
            color_enum = {'r','g','b','c','y','m','k'};
            if q <= size(color_enum,2)
                color = color_enum(:,1:q);
            else
                color = cell(1,q);
                color(:,1:size(color_enum,2)) = color_enum;
                for i = size(color_enum,2)+1:q
                    color{1,i} = rand(1,3);
                end
            end
            figure;
            title('分类结果');
            for i = 1:m
                if n == 2
                    scatter(data(i,1),data(i,2),15,color{flag(i,1)});
                else
                    scatter3(data(i,1),data(i,2),data(i,3),15,color{flag(i,1)});
                end
                hold on;
            end
            grid on;
        otherwise
            fprintf('选项不存在');
    end
end
end
