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

%}
%%
% process start time
startTime = datetime('now');

% acquistion we are looking for
% definig the the time difference between the acquisition 
% defining the difference of 32 minutes between the images
acquistionTimeDifference = days((1/48));

% reading the mean reflectance, solar and sensor angle 
[acquistionDateModis] = DateInfoExtractDat('Libya4_ONLY_MODIS.dat');

% reading the date information of the hyperion Data
[acquistionDateHyperion] = DateInfoExtractMTL('Z:\ImageDrive\Hyperion\EO1\P181\R040\','L1T');

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
 coincidentDatesHyperion = unique(hyperionrepeatDate(posRowCo,posColCo));
 
 % dates on the Modis 
 coincidentDatesModis = unique(ModisrepeatDate(posRowCo,posColCo));
 
 % date Difference between the dates obtained
 differenceBetween  = abs(coincidentDatesHyperion - coincidentDatesModis);
 
 % Matching the positive co-incident dates
 hyperionRowCoMatch = ismember(acquistionDateHyperion.Time,coincidentDatesHyperion);
 
 % selecting the row for the matched co-incident dates
 hyperionRowCoSel = find(hyperionRowCoMatch == 1);
 
 % selecting the hyperion Date strings
 hyperionDateString  = acquistionDateHyperion.DATE_STRING(hyperionRowCoMatch);
 
 % finding all the modis details from the given dates
 % Matching the positive co-incident dates
 modisRowCoMatch = ismember(acquistionDateModis.Time,coincidentDatesModis);
 
 % selecting the row for the matched co-incident dates
 modisRowCoSel = find(modisRowCoMatch == 1);
 
 % selecting the hyperion strings
 modisDateString  = acquistionDateModis.DATE_STRING(modisRowCoMatch);
 
 % selecting the day since launch for the hyperion
 hyperionDSL = acquistionDateHyperion.DSL(hyperionRowCoMatch);
 
 % process ending time
 endTime = datetime('now');
 
 
 % putting all the information in the table as summary table
 summaryAcquisitionDate = table(coincidentDatesHyperion,coincidentDatesModis,...
     differenceBetween,unique(hyperionDateString),unique(modisDateString),hyperionRowCoSel,...
    modisRowCoSel,unique(hyperionDSL));
 summaryAcquisitionDate.Properties.VariableNames = {'Hyperion_Acquisition_Libya_1',...
     'Modis_Acquisition_Libya_1','Time_Difference','Hyperion_Date_String',...
     'Modis_Date_String','Hyperion_Row','Modis_Row','HyperionDSL'};
 save ('Modis_Hyperion_Libya_4_coincident.mat','summaryAcquisitionDate');
 



