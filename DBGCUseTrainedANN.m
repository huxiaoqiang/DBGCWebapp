function [predicted_test_Y] = DBGCUseTrainedANN(VectorsFileName, NetworkName)
	% 20150829
	 close all;
	% clear;
	clc;

	regressionUsed = 2;


	inputStartLine = 4;
	outputStartLine = 4;
	disp(VectorsFileName);
	vectorFile = strcat('DBGCVectors\',VectorsFileName);
	sampleSize = xlsread(vectorFile,'inputVectors','B2:B2');

	inputData = xlsread(vectorFile,'inputVectors',['F' num2str(inputStartLine) ':FS' num2str(inputStartLine+sampleSize-1)]);

	[~,speciesName,~] = xlsread(vectorFile,'inputVectors',['FV' num2str(outputStartLine) ':FV' num2str(outputStartLine+sampleSize-1)]);
	test_X = inputData;
	test_speciesName = speciesName;

	regressionTruncate = 17;

	load(['savedNet\', NetworkName])
%	load savedNet\parameterizedAlgorithm 

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