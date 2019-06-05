

% The m files also uses the lat long function "deg2utm" to calculate the 
% shape file.If lat and long isn't available. UTM co-ordinates can be passed to get 
% the shape of the region of interest.
% Libya 4 ROI
%yMin = 28.451201; yMax = 28.649610;
%xMin = 23.291413; xMax = 23.488039;

% Libya 4 Hyperion ROI
yMin = 24.56; yMax = 24.86; 
xMin = 13.32 ; xMax = 13.67;

% define the name of the roi
name = 'Libya1_SDSU.shp';

% directory you want to save the ROI shape file 
dirName = 'C:\Users\bipin.raut\Documents\MATLAB\roi\Libya 1';

% full Information of the directory 
saveFile = strcat(dirName,name);

% calling the funtion roiSel to make the conversion 
% the function takes input yMin,yMin,xMin,xMax
% 1 is for the lat and log co-ordintes 
% O id for the UTM co-ordinates
% if selected UTM-cordintes, it doesn't provide zone information
% zone infromation has to be provided explicilty.
[easting, northing,zone] = roiSel(yMin,yMax,xMin,xMax,1);

% getting the min and max value for boundary selection
xMin = min(easting);
xMax = max(easting);
yMin = min(northing);
yMax = max(northing);
boundingBox = [xMin,yMax ; xMax,yMin];

% defining the boundary shape type
data.Geometry = 'Polygon';

% defining the coordinates to map 
data.X = easting;
data.Y =  northing ;
data.BoundingBox = boundingBox;

% defining the classs name for the ROI
data.CLASS_NAME = 'ROI_SELECT#1';

% defining the  class ID
data.CLASS_ID  = '1';
 
%definign the Class Clrs
data.CLASS_CLRS = '0,255,255';
 
% writing the shape file 
shapewrite(data,fullfile(dirName,name))



% roi = shaperead('Z:\SpecialNeeds\BIPIN RAUT\Libya4ROIENVI\LibyaRoi.shp');
% dbfspec = makedbfspec(roi);
% % Testing ROI
% shapewrite(roi,'Lib.shp')
% roi2 = shaperead('Libya4ROI2.shp');
% x = [20.54,20.54,20.28,20.28];
% y = [9.20,9.53,9.20,9.53];


function [ xList, yList,zone ] = roiSel(yMin,yMax,xMin,xMax,latLong )
if(nargin == 4)
    utm_co  = 0;
elseif (nargin == 5)
    utm_co = latLong;
end

if utm_co == 0
    % The co-ordinates provided must be utm co-ordinates 
    % y means nothing and X means easting
    xList = [xMin,xMax,xMax,xMin,xMin,NaN];
    yList = [yMax, yMax, yMin, yMin,yMax,NaN];
    zone = [];
else
    % the co-ordinates provided must be lat Long co-ordinates
    % y-cordinates must be latitude and x must be longitude
    latList = [yMax, yMin];
    longList = [xMax, xMin];
    
    % xlist represents the easting and ylist represents the northing
    [easting,northing,zone] = deg2utm(latList,longList);
    xList = [easting(2),easting(1),easting(1),easting(2),easting(2)];
    yList = [northing(1),northing(1),northing(2),northing(2),northing(1)];
    % adding the NaN value at the end of the xlist and Ylist
    xList = [xList, NaN];
    yList = [yList,NaN];
end
end
