% 20150829
close all;
clear;
clc;

% 是否先使用线性回归
regressionUsed = 2;  % 0: 不使用regression，1:使用后对全部变量做ANN，2：使用后对interaction的变量做ANN，-1:纯regression 



formalizeType = 2;       % 1: 只规则化前7个变量 C/C/C2.0/H	C/C/H3	C/C2.0/H2	C/C2/C2.0	C/C2/H2	C/C3/H	C/C4，  2:全部规则化
isOutpuDataFormalized = 0 ;     % 1：表示输出数据进行格式化
inputStartLine = 4;
outputStartLine = 4;
% C13_start_point = 1206;
% C13_end_point = 1494;
trainSize = 2500; 
% deletePoint = [1495;1940];   % 删除的样本点
deletePoint = [];   % 删除的样本点 C2H4 CH4
inputDataFormalizedType = 3; 
outpuDataFormalizedType = 3; 

saveFlag = 0;        % 0: 不保存图和表，1：保存
isHandleDuplicated = 1;       % 0:不统计重复值，1：统计

hiddenLayerValue = 10;    % 隐藏层个数
transferFcnName = 'logsig';  % logsig [0 1], tansig [-1 1]


testMeanError = 0;   % 测试样本的平均误差
trainMeanError = 0;   % 训练样本的平均误差

sampleSize = 20000;
testSampleSize = 300;    % 测试样本数量
inputData = xlsread('DBGCVectors\DBGCVectors.xlsx','inputVectors',['F' num2str(inputStartLine) ':FS' num2str(inputStartLine+sampleSize-1)]);    % 所有样本

[~,speciesName,~] = xlsread('DBGCVectors\DBGCVectors.xlsx','inputVectors',['FV' num2str(outputStartLine) ':FV' num2str(outputStartLine+sampleSize-1)]);
        


%%

sampleSize = size(inputData,1);


% 训练
[uniqueSampleSize,sizeCol] = size(inputData);
    
    
    


test_X = inputData;

test_speciesName = speciesName;

C_Test_IndexSize = length(speciesName);

testSampleSize = length(speciesName);
    


regressionTruncate = 17;

load savedNet\parameterizedAlgorithm 

if regressionUsed ==2
    predicted_test_Y = trained_ANN_net(test_X(:,regressionTruncate+1:end)');   
    predicted_test_Y = predicted_test_Y';
elseif regressionUsed ~= 2
    predicted_test_Y = trained_ANN_net(test_X');   
    predicted_test_Y = predicted_test_Y';
end
    
if regressionUsed ~= 0
    disp('hi');
    predicted_test_Y = predicted_test_Y + [ones(size(test_X,1),1),test_X(:,[1:regressionTruncate])]*reg_coeff;
end
if regressionUsed == -1
    disp('hi2');
    predicted_test_Y = [ones(size(test_X,1),1),test_X(:,[1:regressionTruncate])]*reg_coeff;
end






