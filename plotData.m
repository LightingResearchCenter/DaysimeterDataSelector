function handles = plotData(handles)
%PLOTDATA Summary of this function goes here
%   Detailed explanation goes here
% handles    structure with handles and user data (see GUIDATA)

[jObj,handles] = startBusy(handles,'loading...');

% Retrieve index of data to plot
idx = handles.ActiveDataIdx;

% Convert data to simple form
if ~isfield(handles, 'DisplayData') % DisplayData does not exist so make it
    handles.DisplayData = struct;
end
handles.DisplayData.Time              = handles.SourceData(idx).Time;
handles.DisplayData.ActivityIndex     = handles.SourceData(idx).ActivityIndex;
handles.DisplayData.CircadianStimulus = handles.SourceData(idx).CircadianStimulus;
handles.DisplayData.CircadianLight    = handles.SourceData(idx).CircadianLight;
handles.DisplayData.Illuminance       = handles.SourceData(idx).Illuminance;

% Overview plots
% Activity Index
if isfield(handles, 'ActivityIndex_Overview') % Check if plot handle exists
    if isvalid(handles.ActivityIndex_Overview) % Check if plot handle is still valid
        set(handles.ActivityIndex_Overview, 'XData', handles.DisplayData.Time, 'YData', handles.DisplayData.ActivityIndex);
    else
        hold(handles.axes_overview,'on');
        handles.ActivityIndex_Overview = plot(handles.axes_overview,handles.DisplayData.Time,handles.DisplayData.ActivityIndex,'-');
    end
else
    hold(handles.axes_overview,'on');
    handles.ActivityIndex_Overview = plot(handles.axes_overview,handles.DisplayData.Time,handles.DisplayData.ActivityIndex,'-');
end
if handles.checkbox_ai.Value
    handles.ActivityIndex_Overview.Visible = 'on';
else
    handles.ActivityIndex_Overview.Visible = 'off';
end

yMax = max([1;handles.DisplayData.ActivityIndex]);


handles.axes_overview.XLimMode = 'manual';
handles.axes_overview.XLim = [handles.DisplayData.Time(1),handles.DisplayData.Time(end)];
handles.axes_overview.YLim = [0,yMax];
hold(handles.axes_detail,'on');
plot(handles.axes_detail,handles.DisplayData.Time,handles.DisplayData.ActivityIndex,'-o');
handles.axes_detail.YLim = [0,yMax];

stopBusy(handles,jObj,'done');

end
