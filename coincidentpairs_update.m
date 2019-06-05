clc 
clear 
close all

%{
This files finds the coincident pairs between the two sensor if given the 
date as input. It uses "DateInfoExtractDat" and "DateInfoExtractMTL" function 
to get date information from the dat file and MTL file. 

The summary of the calculation is provided in the 'summaryAcquisitionDate'
Table. It provides information on the co-incident pairs between the sensor
and time difference. Define the the time difference you want to search for
in the variable "acquistionTimeDifference". It is duration varible. 

This file reports a lot of warning on the terminal. The warnings are
reported warning rather than just warning thrown by matlab.

%}
%%
% process start time
startTime = datetime('now');

% acquistion we are looking for
% definig the the time difference between the acquisition 
% defining the difference of 30 minutes between the images
acquistionTimeDifference = days((5));

% sudan dat file doesn't have valid data to line 22 so skipping the data
% till 22
skipLine = 22;
fileNameModis  = 'C:\Users\bipin.raut\Documents\MATLAB\Egypt1\datFiles\Egypt1_ONLY_MODIS.dat';
directoryOfHyperion = 'Z:\ImageDrive\Hyperion\EO1\P179\R041\';
hyperionProduct = 'L1T';

% reading the mean reflectance, solar and sensor angle 
[acquistionDateModis] = DateInfoExtractDat(fileNameModis,skipLine);

% reading the date information of the hyperion Data
[acquistionDateHyperion] = DateInfoExtractMTL(directoryOfHyperion,hyperionProduct);

%  sizes of the row
[Hyrow,~] = size(acquistionDateHyperion);
[Mrow,~] = size(acquistionDateModis);

 % cummulative addition of the DOY to get the DSL
 dsl = dataset({cumsum(acquistionDateHyperion.DOY) 'DSL'});
 
 % concatenating the dataset
 acquistionDateHyperion = [acquistionDateHyperion dsl];

% Hyperion images will always be less than the Modis.
% selecting the hyperion time acquistion
hyperionDateSel = transpose(acquistionDateHyperion.Time);

% repeating the hyperion images 
hyperionrepeatDate = repmat((hyperionDateSel),Mrow,1); 

%repeating the Modis images
ModisrepeatDate  = repmat(acquistionDateModis.Time,1,Hyrow);

%taking the Date subraction to find the coincident pairs 
timeDifference  = ModisrepeatDate - hyperionrepeatDate;

% elspsed duration in units of days by changing the format
timeDifference.Format = 'd';

% taking the absolute of all the time 
timeDifference = abs(timeDifference);

%finding the days less than 60 mins
[posRowCo,posColCo] = find(timeDifference < acquistionTimeDifference);

% finding the date of acqusition  
% using unique to remove the repeated dates in the matrix
% dates on the Hyperion
for i = 1:size(posRowCo)
  coincidentDatesHyperion(i) = (hyperionrepeatDate(posRowCo(i),posColCo(i)));
  
  % finding the  match with the Hyperion
  match = find(coincidentDatesHyperion(i)== acquistionDateHyperion.Time);
  
  % finding the Date string
  hyperionDateString(i) = acquistionDateHyperion.DATE_STRING(match);
  
  % finding the DSL
  hyperionDSL(i) = acquistionDateHyperion.DSL(match);
  
  %finding the match
  hyperionRowCoSel(i) = match;
end
 % dates on the Modis 
for i = 1:size(posRowCo)
  coincidentDatesModis(i) = (ModisrepeatDate(posRowCo(i),posColCo(i)));
  
  % finding the  match with the Modis
  match = find(coincidentDatesModis(i) == acquistionDateModis.Time);
  
  % finding the DSL
  modisDateString(i) = acquistionDateModis.DATE_STRING(match);
   %finding the match
  modisRowCoSel(i) = match;
end
 % date Difference between the dates obtained
 differenceBetween  = abs(coincidentDatesHyperion- coincidentDatesModis);
 


 % process ending time
 endTime = datetime('now');

 % putting all the information in the table as summary table
 summaryAcquisitionDate = table(coincidentDatesHyperion',coincidentDatesModis',...
     differenceBetween',(hyperionDateString'),(modisDateString'),hyperionRowCoSel',...
    modisRowCoSel',(hyperionDSL)');
 summaryAcquisitionDate.Properties.VariableNames = {'Hyperion_Acquisition_Egypt_1',...
     'Modis_Acquisition_Egypt_1','Time_Difference','Hyperion_Date_String',...
     'Modis_Date_String','Hyperion_Row','Modis_Row','HyperionDSL'};
 save ('Modis_Hyperion_Egypt_1_coincident.mat','summaryAcquisitionDate');
%  
% 
% 

