function handles = plotData(handles,dataIdx)
%PLOTDATA Summary of this function goes here
%   Detailed explanation goes here
% handles    structure with handles and user data (see GUIDATA)

% Check if data has been converted
if isfield(handles, 'DisplayData')
    
else % DisplayData does not exist so make it
    handles.DisplayData = struct;
end

% Overview plots
% Activity Index
if isfield(handles, 'ActivityIndex_Overview') % Check if plot handle exists
    if isvalid(handles.ActivityIndex_Overview) % Check if plot handle is still valid
        set(handles.ActivityIndex_Overview, 'XData', handles.Temp.Time, 'YData', handles.Temp.ActivityIndex);
    else
        hold(handles.axes_overview,'on');
        handles.ActivityIndex_Overview = plot(handles.axes_overview,handles.Temp.Time,handles.Temp.ActivityIndex,'-');
    end
else
    hold(handles.axes_overview,'on');
    handles.ActivityIndex_Overview = plot(handles.axes_overview,handles.Temp.Time,handles.Temp.ActivityIndex,'-');
end
if handles.checkbox_ai.Value
    handles.ActivityIndex_Overview.Visible = 'on';
else
    handles.ActivityIndex_Overview.Visible = 'off';
end

yMax = max([1;handles.Temp.ActivityIndex]);


handles.axes_overview.XLimMode = 'manual';
handles.axes_overview.XLim = [handles.Temp.Time(1),handles.Temp.Time(end)];
handles.axes_overview.YLim = [0,yMax];
hold(handles.axes_detail,'on');
plot(handles.axes_detail,handles.Temp.Time,handles.Temp.ActivityIndex,'-o');
handles.axes_detail.YLim = [0,yMax];

end
