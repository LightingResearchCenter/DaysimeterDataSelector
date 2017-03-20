function [jObj,handles] = startBusy(handles,message)
%STARTBUSY Summary of this function goes here
%   Detailed explanation goes here

% Check if notification panel exists
if ~isfield(handles, 'uipanel_busy') % field does not exist
    handles.uipanel_busy = makePanel(handles.figure1,100,100);
elseif ~isvalid(handles.uipanel_busy) % field is not valid
    handles.NotificationPanel = makePanel(handles.figure1,100,100);
end

% Check if jObj already exists delete it if it does
if ~isempty(handles.uipanel_busy.Children)
    delete(handles.uipanel_busy.Children);
end

% Make and start the spinner
jObj = makeSpinner(handles.uipanel_busy,message);
jObj.start;

% Make panel visible
handles.uipanel_busy.Visible = 'on';

% do some long operation...

end


function h = makePanel(Parent,width,height)

units = Parent.Units;
Parent.Units = 'pixels';
x = (Parent.Position(3)-width)/2;
y = (Parent.Position(4)-height)/2;
Parent.Units = units;
h = uipanel(Parent,'Visible','off','Title','','BorderType','none','Units','pixels','Position',[x,y,width,height]);

end


function jObj = makeSpinner(Parent,message)
try
    % R2010a and newer
    iconsClassName = 'com.mathworks.widgets.BusyAffordance$AffordanceSize';
    iconsSizeEnums = javaMethod('values',iconsClassName);
    SIZE_32x32 = iconsSizeEnums(2);  % (1) = 16x16,  (2) = 32x32
    jObj = com.mathworks.widgets.BusyAffordance(SIZE_32x32, message);  % icon, label
catch
    % R2009b and earlier
    redColor   = java.awt.Color(1,0,0);
    blackColor = java.awt.Color(0,0,0);
    jObj = com.mathworks.widgets.BusyAffordance(redColor, blackColor);
end
jObj.setPaintsWhenStopped(false);  % default = false
jObj.useWhiteDots(false);         % default = false (true is good for dark backgrounds)
javacomponent(jObj.getComponent, [10,10,80,80], Parent);
end