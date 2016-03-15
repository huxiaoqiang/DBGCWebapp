% 20150829
close all;
clear;
clc;

% �Ƿ���ʹ�����Իع�
regressionUsed = 2;  % 0: ��ʹ��regression��1:ʹ�ú��ȫ��������ANN��2��ʹ�ú��interaction�ı�����ANN��-1:��regression 



formalizeType = 2;       % 1: ֻ����ǰ7������ C/C/C2.0/H	C/C/H3	C/C2.0/H2	C/C2/C2.0	C/C2/H2	C/C3/H	C/C4��  2:ȫ������
isOutpuDataFormalized = 0 ;     % 1����ʾ������ݽ��и�ʽ��
inputStartLine = 4;
outputStartLine = 4;
% C13_start_point = 1206;
% C13_end_point = 1494;
trainSize = 2500; 
% deletePoint = [1495;1940];   % ɾ����������
deletePoint = [];   % ɾ���������� C2H4 CH4
inputDataFormalizedType = 3; 
outpuDataFormalizedType = 3; 

saveFlag = 0;        % 0: ������ͼ�ͱ�1������
isHandleDuplicated = 1;       % 0:��ͳ���ظ�ֵ��1��ͳ��

hiddenLayerValue = 10;    % ���ز����
transferFcnName = 'logsig';  % logsig [0 1], tansig [-1 1]


testMeanError = 0;   % ����������ƽ�����
trainMeanError = 0;   % ѵ��������ƽ�����

sampleSize = 20000;
testSampleSize = 300;    % ������������
inputData = xlsread('DBGCVectors\DBGCVectors.xlsx','inputVectors',['F' num2str(inputStartLine) ':FS' num2str(inputStartLine+sampleSize-1)]);    % ��������

[~,speciesName,~] = xlsread('DBGCVectors\DBGCVectors.xlsx','inputVectors',['FV' num2str(outputStartLine) ':FV' num2str(outputStartLine+sampleSize-1)]);
        


%%

sampleSize = size(inputData,1);


% ѵ��
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






