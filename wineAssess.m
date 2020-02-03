clear all;
wine_data = xlsread('wine.xlsx');

method = 'BP';%PK:PCA & Kmeans  PL:PCA & LVQ  BP:BP Neural Network'
rate = 0.7;%训练集70%，测试集30%
N = 3;

total_cnt = size(wine_data,1);
train_cnt = round(total_cnt*rate);
test_cnt = total_cnt - train_cnt;

rand_idx = randperm(total_cnt);
train_idx = rand_idx(1:train_cnt);
test_idx = rand_idx(train_cnt+1:total_cnt);

train_data = wine_data(train_idx,2:size(wine_data,2));
train_class = wine_data(train_idx,1);
test_data = wine_data(test_idx,2:size(wine_data,2));
test_class = wine_data(test_idx,1);
dim = size(wine_data,2)-1;

%矩阵z-score标准化
train_SM = zeros(train_cnt,dim);
data_mean = mean(train_data);
data_std = std(train_data);
test_SM = zeros(test_cnt,dim);
for j = 1:dim
    train_SM(:,j) = (train_data(:,j) - data_mean(j)) / data_std(j);
    test_SM(:,j) = (test_data(:,j) - data_mean(j)) / data_std(j);
end


%三种方法
switch method
    case 'PK'
        [DS, com_num, PV, score] = PCA(train_SM, 0.66,'ShowFigure');
        %初始化聚类中心
        center_init = zeros(3,com_num);
        for i = 1:N
            center_init(i,:) = mean(score(train_class==i,:));
        end
        [center, train_flag, ~, ~] = Kmeans(score, N,center_init,'ShowFigure');%k-means聚类
        test_score = test_SM * PV;     %测试集的评分
        test_flag = findMinIdx(test_score, center);
        
    case 'PL'
        [DS, com_num, PV, score] = PCA(train_SM, 0.66,'ShowFigure');
        [pv,train_flag] = LVQ(score, train_class, [], (1:N)', 0.1, 1000,'ShowFigure');%LVQ
        test_flag = findMinIdx(test_SM*PV, pv);
        
    case 'BP'
        target = (train_class - 1) / 2;
        net = newff(train_SM',target',10,{'tansig','purelin'},'traingdx');
        net.divideFcn = '';
        net.trainParam.show = 50;
        net.trainParam.epochs = 1000;
        net.trainParam.goal = 0.001;
        net.trainParam.lr = 0.01;
        net = train(net,train_SM',target');
        
        out = sim(net,train_SM');
        train_flag = round(out*2+1)';
        out = sim(net,test_SM');
        test_flag = round(out*2+1)';
    otherwise
        fprintf('check method\n');
        return;
end

train_correct_cnt = sum(train_flag(:,1) == train_class(:,1));
train_accuracy = train_correct_cnt / train_cnt   %训练集准确率

test_correct_cnt = sum(test_flag(:,1) == test_class(:,1));
test_accuracy = test_correct_cnt / test_cnt   %训练集准确率

figure;
plot(1:test_cnt,test_class(:,1),'bo');
hold on;
plot(1:test_cnt,test_flag(:,1),'b*');
legend('实际测试集分类','预测测试集分类');

