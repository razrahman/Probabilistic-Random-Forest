function [TrainingData,TestingData,OriginalTrain,OriginalTest,FoldedIndex]=CreateFoldedData1fold(ParcentEC50,Original)

DrugNumber=size(Original,1);
Index=[1:DrugNumber];


FoldedIndex=randsample(Index,floor(DrugNumber*2/5));
Index=setdiff(Index,FoldedIndex);

TestingIndex=FoldedIndex;
TrainingIndex=Index;
TrainingData{1}=ParcentEC50(TrainingIndex,:);
TestingData{1}=ParcentEC50(TestingIndex,:);
OriginalTrain{1}=Original(TrainingIndex,:);
OriginalTest{1}=Original(TestingIndex,:);


