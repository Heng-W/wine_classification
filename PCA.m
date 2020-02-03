function [DS, com_num, PV, score] = PCA(SA, T, option)
%PCA降维
% Inputs:
%    SA:标准化后的输入矩阵  T:主成分的信息保留率  options:可选
% Outputs:
%    DS:特征值、贡献率、累计贡献率
%    com_num:T对应的主成分数
%    PV:特征向量
%    score:主成分得分

n = size(SA,2);
CM = cov(SA);    %计算协方差矩阵，信息大小用方差来衡量
[V,D] = eig(CM);   %计算CM的特征向量和特征值，排除线性相关性
DS = zeros(n,3);
for i = 1:n
    DS(i,1) = D(n-i+1,n-i+1);       %将特征值按降序排列到DS中
end
%计算方差贡献率，特征值越大相应的贡献率越大
for i = 1:n
    DS(i,2) = DS(i,1) / sum(DS(:,1));           %单个方差贡献率
    DS(i,3) = sum(DS(1:i,1)) / sum(DS(:,1));    %累计方差贡献率
end
for i = 1:n
    if DS(i,3) >= T
        com_num = i;
        break;
    end
end
PV = zeros(n,com_num);
for j = 1:com_num         %提取主成分的特征向量，得到降维后的标准正交基
    PV(:,j) = V(:,n-j+1); %（实对称矩阵不同特征值对应的特征向量正交）
end
score = SA*PV; %用得到的标准正交基实现数据集的投影，计算主成分得分

if nargin > 2
    switch option
        case 'ShowFigure'
            figure;
            hold on;
            xlabel('主成分');
            ylabel('方差贡献率');
            bar(1:n,DS(:,2));
            plot(1:n,DS(:,3),'b-');
            legend({'单个贡献率','累计贡献率'},'Location','NorthWest');
        otherwise
            fprintf('选项不存在');
    end
end

end

