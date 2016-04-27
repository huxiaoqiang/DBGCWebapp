% 20150829
close all;
clear;
clc;

% �Ƿ���ʹ�����Իع�
regressionUsed = 2;  % 0: ��ʹ��regression��1:ʹ�ú��ȫ��������ANN��2��ʹ�ú��interaction�ı�����ANN��-1:��regression 


inputStartLine = 4;
outputStartLine = 4;
sampleSize = xlsread('E:\hetanjin\GithubFiles\DBGCWebapp\demoForLocal\Matlab\DBGCVectors\DBGCVectors.xlsx','inputVectors','B2:B2');

inputData = xlsread('E:\hetanjin\GithubFiles\DBGCWebapp\demoForLocal\Matlab\DBGCVectors\DBGCVectors.xlsx','inputVectors',['F' num2str(inputStartLine) ':FS' num2str(inputStartLine+sampleSize-1)]);    % ��������

[~,speciesName,~] = xlsread('E:\hetanjin\GithubFiles\DBGCWebapp\demoForLocal\Matlab\DBGCVectors\DBGCVectors.xlsx','inputVectors',['FV' num2str(outputStartLine) ':FV' num2str(outputStartLine+sampleSize-1)]);



%%

test_X = inputData;
test_speciesName = speciesName;


regressionTruncate = 17;

load E:\hetanjin\GithubFiles\DBGCWebapp\demoForLocal\Matlab\savedNet\parameterizedAlgorithm 

if regressionUsed ==2
    predicted_test_Y = trained_ANN_net(test_X(:,regressionTruncate+1:end)');   
    predicted_test_Y = predicted_test_Y';
elseif regressionUsed ~= 2
    predicted_test_Y = trained_ANN_net(test_X');   
    predicted_test_Y = predicted_test_Y';
end

if regressionUsed ~= 0
    disp('hi');
    [ones(size(test_X,1),1),test_X(:,[1:regressionTruncate])]*reg_coeff
    predicted_test_Y
    predicted_test_Y = predicted_test_Y + [ones(size(test_X,1),1),test_X(:,[1:regressionTruncate])]*reg_coeff
%     predicted_test_Y = predicted_test_Y
end
if regressionUsed == -1
    disp('hi2');
    predicted_test_Y = [ones(size(test_X,1),1),test_X(:,[1:regressionTruncate])]*reg_coeff;
end

% disp('here');
% for i=inputStartLine:inputStartLine+sampleSize-1
%     xlswrite('DBGCVectors\DBGCVectors.xlsx',predicted_test_Y,'inputVectors',['FW' num2str(inputStartLine) ':FW' num2str(inputStartLine+sampleSize-1)]);
% end



