function [ data ] = DateInfoExtractDat( fileName )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
fid = fopen(fileName,'r');

%skipping file till line 25
% upto line 25 there is no data.
for line = 1:24
    fgetl(fid);
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
    monthValue(i) = str2double(mm);
    dayValue(i)  = str2double(dd);
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
          acquisition(:,1) = cellfun(@str2double,data(:,col));
        case 'DOY'
          acquisition(:,2) = cellfun(@str2double,data(:,col));
       case 'Date'
           acquisition(:,6) = acquistionDate;
        case 'HR'
            acquisition(:,3) = cellfun(@str2double,data(:,col));
        case 'MIN'
            acquisition(:,4) = cellfun(@str2double,data(:,col));
        case 'SEC'
            acquisition(:,5) = cellfun(@str2double,data(:,col));
    end
end 
% converting to the date number 
dateTimeNum = datenum(acquisition(:,1), transpose(monthValue) ...
        ,transpose(dayValue),acquisition(:,3)...
        ,acquisition(:,4),acquisition(:,5));
% converts date and time to vector of components
dateEvec = datevec(dateTimeNum);

% converting to the date instance
dateTime = datetime(dateEvec);

% implemented Dataset as it provides the information of the variables 
data = dataset({acquisition 'Year','DOY','HR','MIN','SEC','DATE_STRING'});
data2 = dataset({(dateTime) ,'Time'});

% concatenating the two data
data = [data data2];
end