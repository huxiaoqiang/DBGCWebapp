% 20150829
close all;
clear;
clc;
% rand('state',0);
rng('default');

% �Ƿ���ʹ�����Իع�
regressionUsed = 2;  % 0: ��ʹ��regression��1:ʹ�ú��ȫ��������ANN��2��ʹ�ú��interaction�ı�����ANN��-1:��regression 

% ��ȡ����
alkaneType = 3;   % 1:ֱ��������2:������,3:����ȫ��ֱ���ͻ�����
samplesClassification = 2;   % 1: ˳����࣬��testSampleSize��Ϊ����������2����̼������
testC = {'C14','C15','C16','C17','C18','C19','C20','C21','C22'};             % ���Լ��е�����
trainC = {'C3','C4','C5','C6','C7','C8','C9','C10','C11'};    % ѵ�����е�����
% trainC = {};
% testCyclicC = {'C11'};             % ���Լ��еĻ�����
% trainCyclicC = {'C3','C4','C5','C6','C7','C8','C9','C10'};    % ѵ�����еĻ�����
testCyclicC = {};             % ���Լ��еĻ�����
trainCyclicC = {};    % ѵ�����еĻ�����


justTestAlkene = 2;      % 0:����ϩ����������1��ֻ����ϩ��, 2:ֻ��������
justTrainAlkene = 2;      % 0:ѵ��ϩ����������1��ֻѵ��ϩ��, 2:ֻѵ������

testC_Num = length(testC);
trainC_Num = length(trainC);
testCyclicC_Num = length(testCyclicC);
trainCyclicC_Num = length(trainCyclicC);

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

if alkaneType == 1
    sampleSize = 2070;
    testSampleSize = 300;    % ������������
%     inputData = xlsread('groupData_B3631Gd_20150826_new\inputFile_1.xls','acyclic',['G' num2str(inputStartLine) ':AX' num2str(inputStartLine+sampleSize-1)]);
    inputData = xlsread('dataBase_20151111\inputFile_m2.xlsx','acyclic',['G' num2str(inputStartLine) ':AX' num2str(inputStartLine+sampleSize-1)]);
%     inputData = xlsread('20151006\dataBase_2015100601\all\inputFile_3.xls','acyclic',['G' num2str(inputStartLine) ':V' num2str(inputStartLine+sampleSize-1)]);
    outputData = xlsread('dataBase_20151111\inputFile_m2.xlsx','acyclic',['D' num2str(outputStartLine) ':D' num2str(outputStartLine+sampleSize-1)]);
    % outputData = xlsread('groupData_B3631Gd_20150826_new\database.xls','speciesInfo',['E' num2str(outputStartLine) ':E' num2str(outputStartLine+sampleSize-1)]);
    [~,speciesName,~] = xlsread('dataBase_20151111\inputFile_m2.xlsx','acyclic',['C' num2str(outputStartLine) ':C' num2str(outputStartLine+sampleSize-1)]);
elseif alkaneType == 2
    sampleSize = 483;
    testSampleSize = 50;    % ������������
    inputData = xlsread('groupData_B3631Gd_20150826_new\inputFile_m2.xls','cyclic',['G' num2str(inputStartLine) ':AX' num2str(inputStartLine+sampleSize-1)]);
    outputData = xlsread('groupData_B3631Gd_20150826_new\inputFile_m2.xls','cyclic',['D' num2str(outputStartLine) ':D' num2str(outputStartLine+sampleSize-1)]);
    [~,speciesName,~] = xlsread('groupData_B3631Gd_20150826_new\inputFile_m2.xls','acyclic',['C' num2str(outputStartLine) ':C' num2str(outputStartLine+sampleSize-1)]);
elseif alkaneType == 3
    sampleSize = 20000;
    testSampleSize = 300;    % ������������
    inputData = xlsread('dataBase_test\inputFile_m2.xls','acyclic',['F' num2str(inputStartLine) ':AN' num2str(inputStartLine+sampleSize-1)]);    % ��������
    outputData = xlsread('dataBase_test\inputFile_m2.xls','acyclic',['AQ' num2str(outputStartLine) ':AQ' num2str(outputStartLine+sampleSize-1)]);  % ��������
    [~,speciesName,~] = xlsread('dataBase_test\inputFile_m2.xls','acyclic',['AP' num2str(outputStartLine) ':AP' num2str(outputStartLine+sampleSize-1)]);
    
    inputDataCyclic = xlsread('dataBase_test\inputFile_m2.xls','cyclic',['F' num2str(inputStartLine) ':AN' num2str(inputStartLine+sampleSize-1)]);    % ������
    outputDataCyclic = xlsread('dataBase_test\inputFile_m2.xls','cyclic',['AQ' num2str(outputStartLine) ':AQ' num2str(outputStartLine+sampleSize-1)]);  % ������
    [~,speciesNameCyclic,~] = xlsread('dataBase_test\inputFile_m2.xls','cyclic',['AP' num2str(outputStartLine) ':AP' num2str(outputStartLine+sampleSize-1)]);
    
%     inputData = xlsread('dataBase_20151115\conventionalGA.xlsx','acyclic',['F' num2str(inputStartLine) ':X' num2str(inputStartLine+sampleSize-1)]);    % ��������
%     outputData = xlsread('dataBase_20151115\conventionalGA.xlsx','acyclic',['C' num2str(outputStartLine) ':C' num2str(outputStartLine+sampleSize-1)]);  % ��������
%     [~,speciesName,~] = xlsread('dataBase_20151115\conventionalGA.xlsx','acyclic',['B' num2str(outputStartLine) ':B' num2str(outputStartLine+sampleSize-1)]);
%     
%     inputDataCyclic = xlsread('dataBase_20151115\conventionalGA.xlsx','cyclic',['F' num2str(inputStartLine) ':X' num2str(inputStartLine+sampleSize-1)]);    % ������
%     outputDataCyclic = xlsread('dataBase_20151115\conventionalGA.xlsx','cyclic',['C' num2str(outputStartLine) ':C' num2str(outputStartLine+sampleSize-1)]);  % ������
%     [~,speciesNameCyclic,~] = xlsread('dataBase_20151115\conventionalGA.xlsx','cyclic',['B' num2str(outputStartLine) ':B' num2str(outputStartLine+sampleSize-1)]);

end

%%
% ȥ��delete point 
inputData(deletePoint,:) = [];
outputData(deletePoint,:) = [];
speciesName(deletePoint) = [];


% ѡȡ���ظ�������
inputDataOriginal = inputData;
outputDataOriginal = outputData;
speciesNameOriginal = speciesName;
% [~, uniqueInputIndex] = unique(inputData,'rows','first');
% uniqueInputIndex = sort(uniqueInputIndex);
% inputData = inputData(uniqueInputIndex,:);
% outputData = outputData(uniqueInputIndex);
% speciesName = speciesName(uniqueInputIndex);

% if alkaneType == 3
%     inputDataOriginalCyclic = inputDataCyclic;
%     outputDataOriginalCyclic = outputDataCyclic;
%     speciesNameOriginalCyclic = speciesNameCyclic;
% 
%     [~, uniqueInputIndexCyclic] = unique(inputDataCyclic,'rows','first');
%     uniqueInputIndexCyclic = sort(uniqueInputIndexCyclic);
%     inputDataCyclic = inputDataCyclic(uniqueInputIndexCyclic,:);
%     outputDataCyclic = outputDataCyclic(uniqueInputIndexCyclic);
%     speciesNameCyclic = speciesNameCyclic(uniqueInputIndexCyclic);
% end

sampleSize = length(outputData);

% % ɾ��ֵʼ��Ϊ0�ı���
% sumCol = sum(abs(inputData));
% inputData(:,find(sumCol==0))=[];
% inputDataOriginal(:,find(sumCol==0))=[];

% if alkaneType == 3
%     inputDataCyclic(:,find(sumCol==0))=[];
%     inputDataOriginalCyclic(:,find(sumCol==0))=[];
% end


% ����������Сֵ
maxOutput = max(outputData);
minOutput = min(outputData);

% % ��ʽ���������
% inputData = NormalizationData(inputData,5);
% outputData = NormalizationData(outputData,2);
% ѵ��
[uniqueSampleSize,sizeCol] = size(inputData);

% if formalizeType == 1
%     inputData = [NormalizationData(inputData(:,1:7),inputDataFormalizedType) inputData(:,8:sizeCol)];
% elseif formalizeType == 2
%     inputData = NormalizationData(inputData,inputDataFormalizedType);
%     inputDataOriginal = NormalizationData(inputDataOriginal,inputDataFormalizedType);
% end
% 
% if isOutpuDataFormalized == 1
%     outputData = NormalizationData(outputData,outpuDataFormalizedType);
% end


% % �����ظ�����
% if isHandleDuplicated == 1
%     plotIndex = 0;
%     figure,
%     duplicatedName=[];
%     deltaOutputDuplicated = [];
%     for uniqueSampleIndex = 1:uniqueSampleSize
%         memerberFlag = ismember(inputDataOriginal,inputData(uniqueSampleIndex,:),'rows');
%         memerberIndex=find(memerberFlag==1);
%         duplicatedNum = length(memerberIndex);
%         if duplicatedNum>1
%     %         duplicatedNum
%             tempDuplicatedOutput = outputDataOriginal(memerberIndex);
%             tempDuplicatedName = speciesNameOriginal(memerberIndex);
%             maxDuplicatedOutput = max(tempDuplicatedOutput);
%             minDuplicatedOutput = min(tempDuplicatedOutput);
%             tempDeltaDuplicatedOutput(1) = maxDuplicatedOutput;
%             tempDeltaDuplicatedOutput(2) = minDuplicatedOutput;
%             tempDeltaDuplicatedOutput(3) = maxDuplicatedOutput-minDuplicatedOutput;
%             outputData(uniqueSampleIndex) = minDuplicatedOutput;         % ȡ�ظ���������С�����ֵ��Ϊ���
% 
%             [duplicatedNameRow,duplicatedNameCol]=size(duplicatedName);
%             if duplicatedNameCol<duplicatedNum
%                 temp = cell(duplicatedNameRow,duplicatedNum);
%                 temp(:,1:duplicatedNameCol) = duplicatedName;
%                 duplicatedName = temp;
%                 duplicatedName=[duplicatedName;tempDuplicatedName'];  
%                 deltaOutputDuplicated = [deltaOutputDuplicated;tempDeltaDuplicatedOutput];
%             else
%                 temp = cell(1,duplicatedNameCol);
%                 temp(1,1:duplicatedNum) = tempDuplicatedName';
%                 duplicatedName=[duplicatedName;temp];  
%                 deltaOutputDuplicated = [deltaOutputDuplicated;tempDeltaDuplicatedOutput];
%             end
% 
%             plotIndex = plotIndex+1;
%             duplicatedArray(plotIndex) = duplicatedNum;
%             plotX = zeros(duplicatedNum,1)+plotIndex;
%             plotY = outputDataOriginal(memerberIndex,1);
% %             plot(plotX,plotY,'.'); hold on
%         end
%     end
%       
%    % �����������ظ���ȡ��Сֵ
%    if alkaneType == 3
%         [uniqueSampleSizeCyclic,sizeColCyclic] = size(inputDataCyclic);
%          for uniqueSampleIndex = 1:uniqueSampleSizeCyclic
%             memerberFlag = ismember(inputDataOriginalCyclic,inputDataCyclic(uniqueSampleIndex,:),'rows');
%             memerberIndex=find(memerberFlag==1);
%             duplicatedNum = length(memerberIndex);
%             if duplicatedNum>1
%         %         duplicatedNum
%                 tempDuplicatedOutput = outputDataOriginalCyclic(memerberIndex);
%                 tempDuplicatedName = speciesNameOriginalCyclic(memerberIndex);
%                 minDuplicatedOutput = min(tempDuplicatedOutput);
% 
%                 outputDataCyclic(uniqueSampleIndex) = minDuplicatedOutput;         % ȡ�ظ���������С�����ֵ��Ϊ���
%            end
%          end
%      end
%         
%     
%     set(gca,'fontsize',16);
%     set(gcf, 'PaperPositionMode', 'manual');
%     set(gcf, 'PaperUnits', 'inches');
%     set(gcf, 'PaperPosition', [2 1 8 6]);
% 
%     if(~isdir('duplicatedSamples'))
%         mkdir('duplicatedSamples');
%     end
%     filename1 = ['duplicatedSamples\duplicatedSamples.tiff'];
%     if saveFlag == 1
%         print('-dtiff','-r1000', filename1 );
%         [deltaOutputDuplicatedValue, deltaOutputDuplicatedIndex] = sort(deltaOutputDuplicated(:,3),'descend');     % ��������������
%         xlswrite('duplicatedSamples\duplicatedSamples.xlsx',deltaOutputDuplicated(deltaOutputDuplicatedIndex,:),'duplicatedSamples','A2');
%         xlswrite('duplicatedSamples\duplicatedSamples.xlsx',duplicatedName(deltaOutputDuplicatedIndex,:),'duplicatedSamples','D2');
%     end
% 
% end


% �������� 
if samplesClassification == 1
    trainingSampleSize = sampleSize-testSampleSize;
    if trainSize>trainingSampleSize
        trainSize = trainingSampleSize;
        msgbox(['trainSize cannnot larger than ' num2str(trainingSampleSize)]);
    end
    randIndex = randperm(trainingSampleSize,trainSize);
    train_X = inputData(randIndex,:);
    train_Y = outputData(randIndex,:);
%     train_X = inputData(1:trainingSampleSize,:);
%     train_Y = outputData(1:trainingSampleSize,:);
%     train_speciesName = speciesName(1:trainingSampleSize);
    train_speciesName = speciesName(randIndex);
    test_X = inputData((trainingSampleSize+1):sampleSize,:);
    test_Y = outputData((trainingSampleSize+1):sampleSize,:);
    test_speciesName = speciesName((trainingSampleSize+1):sampleSize);
elseif samplesClassification == 2
    if(justTestAlkene == 1)
        % ���Լ���ֻ����ϩ��
        C_Test_Index=[];
        C_Test_IndexCyclic=[];
        C_Train_IndexCyclic=[];
        for testIndex = 1:testC_Num
            speciesPreName = testC{testIndex};
            speciesPreNameLength = length(speciesPreName);
            C_Num = str2num(speciesPreName(2:speciesPreNameLength));
            H_Num = C_Num*2;
%             testSpeciesPreName = [speciesPreName 'H' num2str(H_Num)];
%             testSpeciesPreNameLength = length(testSpeciesPreName);
%             Temp_C_Test_Index = find(strncmp(speciesName,testSpeciesPreName,testSpeciesPreNameLength));
            testNamePattern = ['^' speciesPreName 'H' num2str(H_Num) '_+[0-9]+$'];
            testMatch = regexp(speciesName,testNamePattern);
            Temp_C_Test_Index = find(cellfun(@(x) length(x)>0, testMatch));
            C_Test_Index=[C_Test_Index;Temp_C_Test_Index]
        end
    elseif(justTestAlkene == 2)
          % ���Լ���ֻ��������
        C_Test_Index=[];
        C_Test_IndexCyclic=[];
        C_Train_IndexCyclic=[];
        for testIndex = 1:testC_Num
            speciesPreName = testC{testIndex};
            speciesPreNameLength = length(speciesPreName);
            C_Num = str2num(speciesPreName(2:speciesPreNameLength));
            H_Num = C_Num*2+2;
%             testSpeciesPreName = [speciesPreName 'H' num2str(H_Num)];
%             testSpeciesPreNameLength = length(testSpeciesPreName);
%             Temp_C_Test_Index = find(strncmp(speciesName,testSpeciesPreName,testSpeciesPreNameLength));            
            testNamePattern = ['^' speciesPreName 'H' num2str(H_Num) '_+[0-9]+$'];
            testMatch = regexp(speciesName,testNamePattern);
            Temp_C_Test_Index = find(cellfun(@(x) length(x)>0, testMatch));                
            C_Test_Index=[C_Test_Index;Temp_C_Test_Index];
        end
        C_Test_IndexSize = length(C_Test_Index);
        
        % ���뻷�����Ĳ��Ժ�ѵ����
%         testCyclicC_Num = length(testCyclicC);
%         trainCyclicC_Num = length(trainCyclicC);
        if alkaneType == 3
            C_Test_IndexCyclic=[];     % �������еĲ����������
            for testIndex = 1:testCyclicC_Num
                speciesPreName = testCyclicC{testIndex};
                testSpeciesPreNameLength = length(speciesPreName);
                Temp_C_Test_Index = find(strncmp(speciesNameCyclic,speciesPreName,testSpeciesPreNameLength));
                C_Test_IndexCyclic=[C_Test_IndexCyclic;Temp_C_Test_Index];
            end
            
            C_Train_IndexCyclic=[];     % �������е�ѵ���������
            for trainIndex = 1:trainCyclicC_Num
                speciesPreName = trainCyclicC{trainIndex};
                trainSpeciesPreNameLength = length(speciesPreName);
                Temp_C_Train_Index = find(strncmp(speciesNameCyclic,speciesPreName,trainSpeciesPreNameLength));
                C_Train_IndexCyclic=[C_Train_IndexCyclic;Temp_C_Train_Index];
            end
            
        end
        
    elseif(justTestAlkene == 0)
        C_Test_Index=[];
        C_Test_IndexCyclic=[];
        C_Train_IndexCyclic=[];
        for testIndex = 1:testC_Num         
            speciesPreName = testC{testIndex};
            speciesPreNameLength = length(speciesPreName);
            C_Num = str2num(speciesPreName(2:speciesPreNameLength));
            H_Num = C_Num*2+2;
            if C_Num >= 10
                testNamePattern = ['^' speciesPreName 'H' num2str(H_Num) '_+[0-9]+_r[0-9]+.*$'];
                testMatch = regexp(speciesName,testNamePattern);
                Temp_C_Test_Index = find(cellfun(@(x) length(x)>0, testMatch));                
                C_Test_Index=[C_Test_Index;Temp_C_Test_Index];
            end
            
            speciesPreName = testC{testIndex};
            speciesPreNameLength = length(speciesPreName);
            C_Num = str2num(speciesPreName(2:speciesPreNameLength));
            H_Num = C_Num*2;
            if C_Num >= 9
                testNamePattern = ['^' speciesPreName 'H' num2str(H_Num) '_+[0-9]+_r[0-9]+.*$'];
                testMatch = regexp(speciesName,testNamePattern);
                Temp_C_Test_Index = find(cellfun(@(x) length(x)>0, testMatch));                
                C_Test_Index=[C_Test_Index;Temp_C_Test_Index];
            end          
        end
    else
        mgmox(['Error value of justTestAlkene']);
    end

    % ��Ҫ��ȥ��ѵ�����е�������ϩ��
    if(justTrainAlkene == 1)
        % ѵ������ֻ����ϩ��
        removed_Train_Index=[];
        for trainIndex = 1:trainC_Num
            speciesPreName = trainC{trainIndex};
            speciesPreNameLength = length(speciesPreName);
            C_Num = str2num(speciesPreName(2:speciesPreNameLength));
            H_Num = C_Num*2+2;
            trainSpeciesPreName = [speciesPreName 'H' num2str(H_Num)];
            trainSpeciesPreNameLength = length(trainSpeciesPreName);
            Temp_C_Train_Index = find(strncmp(speciesName,trainSpeciesPreName,trainSpeciesPreNameLength));
            removed_Train_Index=[removed_Train_Index;Temp_C_Train_Index];
        end
        for testIndex = 1:testC_Num
            speciesPreName = trainC{testIndex};
            speciesPreNameLength = length(speciesPreName);
            C_Num = str2num(speciesPreName(2:speciesPreNameLength));
            H_Num = C_Num*2+2;
            testSpeciesPreName = [speciesPreName 'H' num2str(H_Num)];
            testSpeciesPreNameLength = length(testSpeciesPreName);
            Temp_C_Train_Index = find(strncmp(speciesName,testSpeciesPreName,testSpeciesPreNameLength));
            removed_Train_Index=[removed_Train_Index;Temp_C_Train_Index];
        end
     elseif(justTrainAlkene == 2)
          % ѵ������ֻ��������
        Train_Index=[];
        for trainIndex = 1:trainC_Num
            speciesPreName = trainC{trainIndex};
            speciesPreNameLength = length(speciesPreName);
            C_Num = str2num(speciesPreName(2:speciesPreNameLength));
            H_Num = C_Num*2+2;
%             trainSpeciesPreName = [speciesPreName 'H' num2str(H_Num)];
%             trainSpeciesPreNameLength = length(trainSpeciesPreName);
%             Temp_C_Train_Index = find(strncmp(speciesName,trainSpeciesPreName,trainSpeciesPreNameLength));
            testNamePattern = ['^' speciesPreName 'H' num2str(H_Num) '_+[0-9]+$'];
            testMatch = regexp(speciesName,testNamePattern);
            Temp_C_Train_Index = find(cellfun(@(x) length(x)>0, testMatch));    
            Train_Index=[Train_Index;Temp_C_Train_Index];            
        end
%         for testIndex = 1:testC_Num
%             speciesPreName = testC{testIndex};
%             speciesPreNameLength = length(speciesPreName);
%             C_Num = str2num(speciesPreName(2:speciesPreNameLength));
%             H_Num = C_Num*2;
%             trainSpeciesPreName = [speciesPreName 'H' num2str(H_Num)];
%             trainSpeciesPreNameLength = length(trainSpeciesPreName);
%             Temp_C_Train_Index = find(strncmp(speciesName,trainSpeciesPreName,trainSpeciesPreNameLength));
%             removed_Train_Index=[removed_Train_Index;Temp_C_Train_Index];            
%         end
%         removed_Train_IndexSize = length(removed_Train_Index);
     elseif(justTrainAlkene == 0)
          % ѵ��������ϩ��������
        Train_Index=[];
        for trainIndex = 1:trainC_Num
            speciesPreName = trainC{trainIndex};
            speciesPreNameLength = length(speciesPreName);
            C_Num = str2num(speciesPreName(2:speciesPreNameLength));
            H_Num = C_Num*2+2;
            trainSpeciesPreName = [speciesPreName 'H' num2str(H_Num)];
            trainSpeciesPreNameLength = length(trainSpeciesPreName);
            Temp_C_Train_Index = find(strncmp(speciesName,trainSpeciesPreName,trainSpeciesPreNameLength));
            
            if C_Num < 10
                testNamePattern = ['^' speciesPreName 'H' num2str(H_Num) '_+[0-9]+.*$'];
            elseif C_Num >= 10
                testNamePattern = ['^' speciesPreName 'H' num2str(H_Num) '_+[0-9]+$'];
            end
            testMatch = regexp(speciesName,testNamePattern);
            Temp_C_Train_Index = find(cellfun(@(x) length(x)>0, testMatch));    
            
            Train_Index=[Train_Index;Temp_C_Train_Index];            
        end
        tmp_trainC = {'C3','C4','C5','C6','C7','C8'};
        for trainIndex = 1:length(tmp_trainC)
            speciesPreName = tmp_trainC{trainIndex};
            speciesPreNameLength = length(speciesPreName);
            C_Num = str2num(speciesPreName(2:speciesPreNameLength));
            H_Num = C_Num*2;
            trainSpeciesPreName = [speciesPreName 'H' num2str(H_Num)];
            trainSpeciesPreNameLength = length(trainSpeciesPreName);
            Temp_C_Train_Index = find(strncmp(speciesName,trainSpeciesPreName,trainSpeciesPreNameLength));
            Train_Index=[Train_Index;Temp_C_Train_Index];            
        end        
     else
        mgmox(['Error value of justTestAlkene']);
     end
    
%         
%     train_X = inputData;
%     train_Y = outputData;
%     train_speciesName = speciesName;
%     train_X(C13_start_point:C13_end_point,:) = [];
%     train_Y(C13_start_point:C13_end_point) = [];


%     removedIndex = [C_Test_Index;removed_Train_Index];
%     train_X(removedIndex,:) = [];
%     train_Y(removedIndex,:) = [];
%     train_speciesName(removedIndex) = [];
 
    train_X  = inputData(Train_Index,:);
    train_Y = outputData(Train_Index,:);
    train_speciesName  = speciesName(Train_Index,:);
    
    train_YSize = size(train_Y);
    
    % ��ӻ�������ѵ������
    if alkaneType == 3
%         train_X_Cyclic = inputDataCyclic;
%         train_Y_Cyclic = outputDataCyclic;
%         train_speciesName_Cyclic = speciesNameCyclic;
%         train_X_Cyclic(C_Test_IndexCyclic,:) = [];
%         train_Y_Cyclic(C_Test_IndexCyclic,:) = [];
%         train_speciesName_Cyclic(C_Test_IndexCyclic,:) = [];
        
        train_X_Cyclic = inputDataCyclic(C_Train_IndexCyclic,:);
        train_Y_Cyclic = outputDataCyclic(C_Train_IndexCyclic,:);
        train_speciesName_Cyclic = speciesNameCyclic(C_Train_IndexCyclic,:);
        
        train_X = [train_X;train_X_Cyclic];
        train_Y = [train_Y;train_Y_Cyclic];
        train_speciesName = [train_speciesName;train_speciesName_Cyclic];
    end
    
    
    trainingSampleSize = size(train_Y,1);
    if trainSize>trainingSampleSize
        trainSize = trainingSampleSize;
        msgbox(['trainSize cannnot larger than ' num2str(trainingSampleSize)]);
    end
%     ע����������Ǹ�α������Ժ�Ҫ�Ľ���
    randIndex = randperm(trainingSampleSize,trainSize);

    train_X = train_X(randIndex,:);
    train_Y = train_Y(randIndex,:);
    train_speciesName  = train_speciesName(randIndex,:);
    
    test_X = inputData(C_Test_Index,:);
    test_Y = outputData(C_Test_Index,:);
    test_speciesName = speciesName(C_Test_Index);
    C_Test_IndexSize = length(C_Test_Index);
        % ��ӻ�������ѵ������
    if alkaneType == 3
        test_X_Cyclic = inputDataCyclic(C_Test_IndexCyclic,:);
        test_Y_Cyclic = outputDataCyclic(C_Test_IndexCyclic,:);
        test_speciesName_Cyclic = speciesNameCyclic(C_Test_IndexCyclic,:);
    
        test_X = [test_X;test_X_Cyclic];
        test_Y = [test_Y;test_Y_Cyclic];
        test_speciesName = [test_speciesName;test_speciesName_Cyclic];
    end
    
%     trainingSampleSize = length(train_Y);
    testSampleSize = length(test_Y);
    
end

regressionTruncate = 17;
% regressionTruncate = size(train_X,2);
if regressionUsed ~= 0
    [reg_coeff reg_coeffint reg_resid reg_residint reg_stats]=regress(train_Y, [ones(size(train_X,1),1),train_X(:,[1:regressionTruncate])]);
    train_Y_regress = [ones(size(train_X,1),1),train_X(:,[1:regressionTruncate])]*reg_coeff;
    train_Y = train_Y - train_Y_regress;
end

ANN_net = fitnet(hiddenLayerValue);
ANN_net.trainFcn='trainlm';         % trainlm, trainscg
ANN_net.performFcn='mse';
ANN_net.layers{1}.transferFcn = transferFcnName;  % logsig [0 1], tansig [-1 1]
ANN_net.layers{2}.transferFcn = 'purelin';  % purelin
ANN_net.divideParam.trainRatio = 80/100;
ANN_net.divideParam.valRatio = 10/100;
ANN_net.divideParam.testRatio = 10/100;
ANN_net.trainParam.goal = 1e-8;
ANN_net.trainParam.min_grad = 1e-10;
ANN_net.trainParam.showWindow = 1;
ANN_net.trainParam.epochs = 100;
ANN_net.trainParam.max_fail = 10;

if regressionUsed ==2
    % ѵ��
    [trained_ANN_net,~]=train(ANN_net,train_X(:,regressionTruncate+1:end)',train_Y');
    % �洢����
    save savedNet\trainedANN trained_ANN_net
    predicted_test_Y = trained_ANN_net(test_X(:,regressionTruncate+1:end)');   
    predicted_test_Y = predicted_test_Y';
    predicted_train_Y = trained_ANN_net(train_X(:,regressionTruncate+1:end)'); 
    predicted_train_Y = predicted_train_Y';
elseif regressionUsed ~= 2
    % ѵ��
    [trained_ANN_net,~]=train(ANN_net,train_X',train_Y');
    % �洢����
    save savedNet\trainedANN trained_ANN_net
    predicted_test_Y = trained_ANN_net(test_X');   
    predicted_test_Y = predicted_test_Y';
    predicted_train_Y = trained_ANN_net(train_X'); 
    predicted_train_Y = predicted_train_Y';
end
    
if regressionUsed ~= 0
    disp('hi');
    predicted_test_Y = predicted_test_Y + [ones(size(test_X,1),1),test_X(:,[1:regressionTruncate])]*reg_coeff;
    predicted_train_Y = predicted_train_Y + train_Y_regress;
    train_Y = train_Y + train_Y_regress;
end
if regressionUsed == -1
    disp('hi2');
    predicted_test_Y = [ones(size(test_X,1),1),test_X(:,[1:regressionTruncate])]*reg_coeff;
    predicted_train_Y = train_Y_regress;
end

% ������ݸ�ʽת��
if isOutpuDataFormalized == 1
    outputData = reNormalizationData(outputData,outpuDataFormalizedType,maxOutput,minOutput);
    predicted_test_Y = reNormalizationData(predicted_test_Y,outpuDataFormalizedType,maxOutput,minOutput);
    predicted_train_Y = reNormalizationData(predicted_train_Y,outpuDataFormalizedType,maxOutput,minOutput);
    train_Y = reNormalizationData(train_Y,outpuDataFormalizedType,maxOutput,minOutput);
    test_Y = reNormalizationData(test_Y,outpuDataFormalizedType,maxOutput,minOutput);
end


% ������
%  R^2 
R_square_test_samples = 1 - sum((test_Y-predicted_test_Y).^2) / sum((test_Y-mean(test_Y)).^2)
R_square_train_samples = 1 - sum((train_Y-predicted_train_Y).^2) / sum((train_Y-mean(train_Y)).^2)

% �������
A_error_test_samples = test_Y-predicted_test_Y;
A_error_train_samples = train_Y-predicted_train_Y;
Ratio_less_1_test_samples = (length(find(abs(A_error_test_samples)<=1)) / testSampleSize)*100;
Ratio_less_2_test_samples = (length(find(abs(A_error_test_samples)<=2)) / testSampleSize)*100;
Ratio_less_1_train_samples = (length(find(abs(A_error_train_samples)<=1)) / trainSize)*100;
Ratio_less_2_train_samples = (length(find(abs(A_error_train_samples)<=2)) / trainSize)*100;
testMeanError = mean(abs(A_error_test_samples));
trainMeanError = mean(abs(A_error_train_samples));

% ���ÿ�����������
if(~isdir('Error'))
    mkdir('Error');
end
delete('Error\Sorted_error_test_samplesValue.xlsx');
delete('Error\Sorted_error_train_samplesValue.xlsx');

[error_test_samplesValue, error_test_samplesIndex] = sort(abs(A_error_test_samples),'descend');
cell_error_test_samplesValue = [test_speciesName(error_test_samplesIndex) num2cell(A_error_test_samples(error_test_samplesIndex))];
cell_error_samplesValue_Title={'SpeciesName','Error','Mean Error'};
if saveFlag == 1
    save('Error\A_error_test_samples.txt','-ascii','A_error_test_samples');
    save('Error\A_error_train_samples.txt','-ascii','A_error_train_samples');
    xlswrite('Error\Sorted_error_test_samplesValue.xlsx',cell_error_samplesValue_Title,'SortedErrors','B1');
    xlswrite('Error\Sorted_error_test_samplesValue.xlsx',cell_error_test_samplesValue,'SortedErrors','B2');
    xlswrite('Error\Sorted_error_test_samplesValue.xlsx',testMeanError,'SortedErrors','D2');
end

[error_train_samplesValue, error_train_samplesIndex] = sort(abs(A_error_train_samples),'descend');
cell_error_train_samplesValue = [train_speciesName(error_train_samplesIndex) num2cell(A_error_train_samples(error_train_samplesIndex))];
if saveFlag == 1
    xlswrite('Error\Sorted_error_train_samplesValue.xlsx',cell_error_samplesValue_Title,'SortedErrors','B1');
    xlswrite('Error\Sorted_error_train_samplesValue.xlsx',cell_error_train_samplesValue,'SortedErrors','B2');
    xlswrite('Error\Sorted_error_train_samplesValue.xlsx',trainMeanError,'SortedErrors','D2');
    dlmwrite('Error\A_error_test_samples.txt',A_error_test_samples,'precision',6);
    dlmwrite('Error\A_error_train_samples.txt',A_error_train_samples,'precision',6);
end

% ���Լ�Ԥ��
figure
plot(test_Y, predicted_test_Y, '.'); hold on
plot(test_Y(find(abs(A_error_test_samples)>=1)), predicted_test_Y(find(abs(A_error_test_samples)>=1)), 'g.'); hold on
plot(test_Y(find(abs(A_error_test_samples)>=2)), predicted_test_Y(find(abs(A_error_test_samples)>=2)), 'r.'); hold on
title(['Test samples, R^2 : ' num2str(R_square_test_samples)]);
xlabel('Original value');
ylabel('ANN prediction');
xPosition_min = min(test_Y);
xPosition_max = max(test_Y);
yPosition_min = min(predicted_test_Y);
yPosition_max = max(predicted_test_Y);
text(xPosition_min+(xPosition_max-xPosition_min)*0.1,yPosition_min+(yPosition_max-yPosition_min)*0.9,[num2str(Ratio_less_1_test_samples,3) '% less than 1 kcal'],'fontsize',14);
text(xPosition_min+(xPosition_max-xPosition_min)*0.1,yPosition_min+(yPosition_max-yPosition_min)*0.82,[num2str(Ratio_less_2_test_samples,3) '% less than 2 kcal'],'fontsize',14);
set(gca,'fontsize',16);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 1 8 6]);

if(~isdir('Figure'))
    mkdir('Figure');
end
filename1 = ['Figure\testSamples.tiff'];
if saveFlag == 1
    print('-dtiff','-r1000', filename1 );
end

% ѵ����Ԥ��
figure,
plot(train_Y, predicted_train_Y, '.'); hold
plot(train_Y(find(abs(A_error_train_samples)>=1)), predicted_train_Y(find(abs(A_error_train_samples)>=1)), 'g.'); hold on
plot(train_Y(find(abs(A_error_train_samples)>=2)), predicted_train_Y(find(abs(A_error_train_samples)>=2)), 'r.'); hold on
title(['Train samples, R^2 : ' num2str(R_square_train_samples)]);
xlabel('Original value');
ylabel('ANN prediction');
xPosition_min = min(train_Y);
xPosition_max = max(train_Y);
yPosition_min = min(predicted_train_Y);
yPosition_max = max(predicted_train_Y);
text(xPosition_min+(xPosition_max-xPosition_min)*0.1,yPosition_min+(yPosition_max-yPosition_min)*0.9,[num2str(Ratio_less_1_train_samples) '% less than 1 kcal'],'fontsize',14)
text(xPosition_min+(xPosition_max-xPosition_min)*0.1,yPosition_min+(yPosition_max-yPosition_min)*0.82,[num2str(Ratio_less_2_train_samples) '% less than 2 kcal'],'fontsize',14)
set(gca,'fontsize',16);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 1 8 6]);
filename2 = ['Figure\trainSamples.tiff'];
if saveFlag == 1
	print('-dtiff','-r1000', filename2 ); 
end
% figure(3)
% plotregression(train_Y,predicted_train_Y,'Regression');










