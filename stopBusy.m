function stopBusy(handles,jObj,varargin)
%STOPBUSY Summary of this function goes here
%   Detailed explanation goes here

% Change the spinner method
if nargin == 3
    jObj.setBusyText(varargin{1});
end

% Stop the spinner
jObj.stop;

% Delete object from panel
if ~isempty(handles.uipanel_busy.Children)
    delete(handles.uipanel_busy.Children);
end

% Hide the panel
handles.uipanel_busy.Visible = 'off';

end

