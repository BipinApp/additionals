clc 
clear
% the  co-ordinates should be clockwise direction
% NaN should be introduced to end the coordinates
easting = [431790, 462960, 462960, 431790, 462960,NaN]; ... X-axis
northing  = [3000930, 3000930, 2977110 ,2977110,3000930, NaN]; ...Y-axis
% zone needed to be defined 
zone = [34,34,34,34];

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
shapewrite(data,'C:\Users\bipin.raut\Documents\MATLAB\roi\Egypt 1\TuliOptimalROI.shp')

% 
%  roi = shaperead('C:\Users\bipin.raut\Documents\MATLAB\roi\niger 1\hyperionNiger.shp');
%  dbfspec = makedbfspec(roi);
%  % Testing ROI
%  shapewrite(roi,'Lib.shp')
% % roi2 = shaperead('Libya4ROI2.shp');
% % x = [20.54,20.54,20.28,20.28];
% % y = [9.20,9.53,9.20,9.53];


