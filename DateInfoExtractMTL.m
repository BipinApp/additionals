function [ data ] = DateInfoExtractMTL(path, productLevel )
%
%
 dirName = path;
 product = productLevel ;
  %get the directory list
 dir_list = dir(dirName);

 % removing the first two rows
 dir_list = dir_list(~ismember({dir_list.name},{'.','..'}));

 % number of images in the directory
 numberOfImages = length(dir_list);
 
 % store empty acquisition for removal
 empty_acquisition = [];
 
 % 6 represents the number of column on which we are inserting information
 acquisition = zeros(numberOfImages,6);
  
 
 for dateAcqui = 1:numberOfImages 
     imageLocation = fullfile(dir_list(dateAcqui).folder,dir_list(dateAcqui).name,product);
     
     % print to terminal to see the processing
     warning('Directory Processing : %s',imageLocation);
     
     if exist(imageLocation,'dir')~= 7
       warning('on')
       warningText = strcat('Folder not Found', imageLocation);
       warning(warningText);
       %emptyDir(dateAqui) = 1;
       empty_acquisition = [empty_acquisition, dateAcqui];
       continue;
     end
     
    %searching the directory for the files
    file_list = ls(imageLocation);
    name = file_list(3,:);
    
    %reading the common string in the filename
    baseName = name(1:22);
    
    %clearing the file_list
    clear file_list
    
   %reading the mtl file using the built in function name MTLParserHyperion
    mtlFileName = fullfile(imageLocation,strcat(baseName,'_','MTL_',product,'.txt'));
    if exist(mtlFileName,'file') ~=2
        warningText = strcat('MTL file not Found ',mtlFileName);
        warning(warningText);
        empty_acquisition = [empty_acquisition, dateAcqui];
        continue;
    end
    MTLList = MTL_parser_hyperion(mtlFileName);
    acquistionDateRead = split(MTLList.PRODUCT_METADATA.ACQUISITION_DATE,'-'); 
    % reading the year with doy and time details
    dateInfo = split(MTLList.PRODUCT_METADATA.END_TIME);
    
    % saving the year information
    acquisition(dateAcqui,1) = dateInfo(1);
    
    % saving the Doy information
    acquisition(dateAcqui,2) = dateInfo(2);
    
    % spltting the time information to get the hrs, minute and second
    dateInfo_time = split(dateInfo(3),':');
    
    % saving the hours information
    acquisition(dateAcqui,3) = dateInfo_time(1);
    
    %saving the minute information
    acquisition(dateAcqui,4) = dateInfo_time(2);
    
    %saving the time information
    acquisition(dateAcqui,5) = dateInfo_time(3);
    
    %saving the yyyymmdd information as string
    acquisition(dateAcqui,6) = strcat(acquistionDateRead(1),acquistionDateRead(2) ...
        ,acquistionDateRead(3));
    
    dateTimeNum = datenum(str2double(acquistionDateRead(1)),str2double(acquistionDateRead(2)) ...
        ,str2double(acquistionDateRead(3)),str2double(dateInfo_time(1))...
        ,str2double(dateInfo_time(2)),str2double(dateInfo_time(3)));
    
    dateTimeEvec = datevec(dateTimeNum);
    
    % date and time information on the each acquisition date
    timeSample(dateAcqui) = datetime(dateTimeEvec);
 end
 
 % removing the empty acquistions 
 %acquisition(empty_acquisition,:) = [];
 %timeSample(empty_acquisition) = [];
 
 % implemented Dataset as it provides the information of the variables 
 data = dataset({acquisition 'Year','DOY','HR','MIN','SEC','DATE_STRING'});
 data2 = dataset({transpose(timeSample) 'Time'});
 
 % adding two data set 
 data = [data data2];

end

