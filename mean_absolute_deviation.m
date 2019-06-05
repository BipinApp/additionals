function [ outliersIndex ] = mean_absolute_deviation(reflectance,bands,sigmaValue)
%{
The function takes the whole Reflectance array. 
Define the sigma value to filter 2\sigma, 3\sigma filtering
bands defines the number of column you want to use.
This function returns the outliers Row index present in the bands
%}
if(nargin == 1)
   % defining the default band selection from 1 to 7 
   bands = 7;
   % defining the default sigma value of 1
   sigmaValue = 1;
   warning('Using default value of band = 7 and sigma = 1');
elseif (nargin == 2)
    % defining the sigma value of 1 if not defined
    sigmaValue = 1;
    warning('Using default value of sigma = 1');
else
    % Don't care of this condition
end

% designing the mean absolute deviation mean method 
meanToaSel = reflectance(:,1:bands);

% Mean value of the TOA Reflectance of the Each band
meanValue =  mean(meanToaSel);

% taking the standard deviation of the Mean TOA Reflectance
stdOfMeanTOA = std(meanToaSel);

% compute the absolute differences
absoluteDeviation = abs(meanToaSel - meanValue);

% defining the threshold value for filtering the data
thresholdValue = stdOfMeanTOA*sigmaValue;

% checking for the outliers
outliers = absoluteDeviation >  thresholdValue;

% ROW OF THE EACH OUTLIER PRESENT 
[row,~] = find(outliers == 1);

% removing the duplicate row index
outliersIndex = unique(row);

end

