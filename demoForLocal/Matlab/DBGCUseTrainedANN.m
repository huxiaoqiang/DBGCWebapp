function DBGCUseTrainedANN()
	% 20150829
	close all;
	clear;
	clc;

	% 是否先使用线性回归
	regressionUsed = 2;  % 0: 不使用regression，1:使用后对全部变量做ANN，2：使用后对interaction的变量做ANN，-1:纯regression 


	inputStartLine = 4;
	outputStartLine = 4;
	sampleSize = xlsread('DBGCVectors\DBGCVectors.xlsx','inputVectors','B2:B2');

	inputData = xlsread('DBGCVectors\DBGCVectors.xlsx','inputVectors',['F' num2str(inputStartLine) ':FS' num2str(inputStartLine+sampleSize-1)]);    % 所有样本

	[~,speciesName,~] = xlsread('DBGCVectors\DBGCVectors.xlsx','inputVectors',['FV' num2str(outputStartLine) ':FV' num2str(outputStartLine+sampleSize-1)]);
	        


	%%

	test_X = inputData;
	test_speciesName = speciesName;


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
	
	% disp('here');
	% for i=inputStartLine:inputStartLine+sampleSize-1
	%     xlswrite('DBGCVectors\DBGCVectors.xlsx',predicted_test_Y,'inputVectors',['FW' num2str(inputStartLine) ':FW' num2str(inputStartLine+sampleSize-1)]);
	% end




