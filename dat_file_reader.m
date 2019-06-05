function [mean, solar, sensor ] = dat_file_reader( filename )
% This function is different from modis.txt function. The file format
% changed due to no Lat long information. Could have included a parameter
% to use same function. But didn't do that. Only change must be done in
% Line 23 where magic number 22 exist. This number defines not to read data
% till that line 22 in dat file. 
% If you want to change go ahead.
%{
    
  Mean TOA consist of the the following  Information
    B1 B2 B3 B4 B5 B6 B7 STD1 STD2 STD3 STD4 SDT5 STD6 STD7 Year DOY DATE
  
  Solar Angle Information Consist of the following Information
    Solar_Zenith Solar_Azimuth Year DOY Date (YYYYMMDD)
    
  Sensor Agnle Information consist of the following Information\
    Sensor_zenith sensor_azimuth Year DOY Data(YYYYMMDD
%}

fid = fopen(filename,'r');

%skipping file till line 25
% upto line 25 there is no data.
for line = 1:22
  (fgetl(fid));
end

modisValue = strsplit(fgetl(fid));
while ~feof(fid)
    x = strsplit(fgetl(fid));
    %checking if the first cell is empty
    if isempty(x{1})
        modisValue = [modisValue; {x{2:end}}];
    else 
        modisValue = [modisValue;x];
    end 
end
fclose(fid);

% generate the Data for with mean and std
[rows, cols] = size(modisValue);

data = modisValue(2:end,:);

%-1 to remove the header column
acquistionDate = zeros(rows-1,1);

%changing the date format to yyyymmdd format
for i = 1:rows-1
    date1 = strsplit(data{i,4},'/');
    if length(date1{1}) == 1
        mm = strcat('0',date1{1});
    else
        mm = date1{1};
    end
    if length(date1{2}) == 1
        dd = strcat('0',date1{2});
    else
        dd = date1{2};
    end
    acquistionDate(i) = str2double(strcat(date1{3},mm,dd));   
end

% calculating for the decimal year also
decimalYear = zeros(rows-1,1);
for i = 1:rows-1
    [~,~,dp] = date2doy(datenum(data{i,4}));
    decimalYear(i) = dp;   
end
% converting all the string into the double
for col =  1: cols
    field  =  modisValue{1,col};
    switch field
        case 'Year'
          solarAngle(:,3) = cellfun(@str2double,data(:,col));
          sensorAngle(:,3) = cellfun(@str2double,data(:,col));
          meanToa(:,15) = cellfun(@str2double,data(:,col));
        case 'DOY'
          solarAngle(:,4) = cellfun(@str2double,data(:,col));
          sensorAngle(:,4) = cellfun(@str2double,data(:,col));
          meanToa(:,16) = cellfun(@str2double,data(:,col));
       case 'Date'
           solarAngle(:,5) = acquistionDate;
           sensorAngle(:,5)= acquistionDate;
           meanToa(:,17)= acquistionDate;
       case 'M_B1'
           meanToa(:,1) = cellfun(@str2double,data(:,col));
       case 'M_B2'
           meanToa(:,2) = cellfun(@str2double,data(:,col));
       case 'M_B3'
           meanToa(:,3) = cellfun(@str2double,data(:,col));
       case 'M_B4'
           meanToa(:,4) = cellfun(@str2double,data(:,col));
       case 'M_B6'
           meanToa(:,6) = cellfun(@str2double,data(:,col));
       case 'M_B7'
           meanToa(:,7) = cellfun(@str2double,data(:,col));
       case 'M_B1_STD'
           meanToa(:,8) = cellfun(@str2double,data(:,col));
       case 'M_B2_STD'
           meanToa(:,9) = cellfun(@str2double,data(:,col));
       case 'M_B3_STD'
           meanToa(:,10) = cellfun(@str2double,data(:,col));
       case 'M_B4_STD'
           meanToa(:,11) = cellfun(@str2double,data(:,col));
       case 'M_B6_STD'
           meanToa(:,13) = cellfun(@str2double,data(:,col));
       case 'M_B7_STD'
           meanToa(:,14) = cellfun(@str2double,data(:,col));
       case 'E_Sol_Zen'
           solarAngle(:,1) = cellfun(@str2double,data(:,col));
       case 'E_Sol_Azi'
           solarAngle(:,2) = cellfun(@str2double,data(:,col));
       case 'E_Sen_Zen'
           sensorAngle(:,1) = cellfun(@str2double,data(:,col));
       case 'E_Sen_Azi'
           sensorAngle(:,2) = cellfun(@str2double,data(:,col));
    end
    
end 
mean = meanToa;
% adding the decimal year in the mean
mean(:,18) = decimalYear;

sensor = sensorAngle;
% adding the decimal year in the mean
sensor(:,6) =decimalYear;
% adding the decimal year in the mean
solar = solarAngle;
solar(:,6) =decimalYear;
end

