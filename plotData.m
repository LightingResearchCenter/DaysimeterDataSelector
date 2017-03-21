function handles = plotData(handles)
%PLOTDATA Summary of this function goes here
%   Detailed explanation goes here
% handles    structure with handles and user data (see GUIDATA)

% [jObj,handles] = startBusy(handles,'loading...');

% Retrieve index of data to plot
idx = handles.ActiveDataIdx;

% Check if DisplayData exists
if ~isfield(handles, 'DisplayData') % DisplayData does not exist so make it
    handles.DisplayData = struct;
end
% Copy Time over to DisplayData
handles.DisplayData.Time = handles.SourceData(idx).Time;

varNames = {'ActivityIndex','CircadianStimulus','CircadianLight','Illuminance'};

for iVar = 1:numel(varNames)
    % Conver data to simple form
    handles.DisplayData.(varNames{iVar}) = handles.SourceData(idx).(varNames{iVar});
    % Plot data
    handles = overviewPlot(handles,varNames{iVar});
    handles = detailPlot(handles,varNames{iVar});
end

% Format axes
yMaxLeft = max([1;handles.DisplayData.ActivityIndex]);
yMaxRight = max([1;handles.DisplayData.CircadianLight;handles.DisplayData.Illuminance]);

% Overview
yyaxis(handles.axes_overview,'left')
handles.axes_overview.XLimMode = 'manual';
handles.axes_overview.XLim = [handles.DisplayData.Time(1),handles.DisplayData.Time(end)];
handles.axes_overview.YLimMode = 'manual';
handles.axes_overview.YLim = [0,yMaxLeft];

yyaxis(handles.axes_overview,'right')
handles.axes_overview.XLimMode = 'manual';
handles.axes_overview.XLim = [handles.DisplayData.Time(1),handles.DisplayData.Time(end)];
handles.axes_overview.YLimMode = 'manual';
handles.axes_overview.YLim = [0.1,yMaxRight];

% Detail
yyaxis(handles.axes_detail,'left')
handles.axes_detail.YLimMode = 'manual';
handles.axes_detail.YLim = [0,yMaxLeft];

yyaxis(handles.axes_detail,'right')
handles.axes_detail.YLimMode = 'manual';
handles.axes_detail.YLim = [0.1,yMaxRight];

% stopBusy(handles,jObj,'done');

end


function handles = overviewPlot(handles,varName)
varNameOV = [varName,'_Overview'];
varNameCh = ['checkbox_',varName];

[axSide,color,displayName] = getVarProp(varName);
ax = handles.axes_overview;
yyaxis(ax,axSide);

% Search for object with matching tag
hObj = findobj(ax,'Tag',varName);

if isempty(hObj) % If object does not exist make it
    hold(ax,'on');
    hObj = plot(ax,...
        handles.DisplayData.Time,...
        handles.DisplayData.(varName),...
        '-',...
        'Color',       color,...
        'Visible',     'off',...
        'Tag',         varName,...
        'DisplayName', displayName);
    hold(ax,'off');
else % else modify it
    set(hObj, ...
        'XData', handles.DisplayData.Time, ...
        'YData', handles.DisplayData.(varName));
end

if handles.(varNameCh).Value
    hObj.Visible = 'on';
else
    hObj.Visible = 'off';
end

handles.(varNameOV) = hObj;

end


function handles = detailPlot(handles,varName)
varNameDV = [varName,'_Detail'];
varNameCh = ['checkbox_',varName];

[axSide,color,displayName] = getVarProp(varName);
ax = handles.axes_detail;
yyaxis(ax,axSide);

% Search for object with matching tag
hObj = findobj(ax,'Tag',varName);

if isempty(hObj) % If object does not exist make it
    hold(ax,'on');
    hObj = plot(ax,...
        handles.DisplayData.Time,...
        handles.DisplayData.(varName),...
        '-o',...
        'Color',       color,...
        'Visible',     'off',...
        'Tag',         varName,...
        'DisplayName', displayName);
    hold(ax,'off');
else % else modify it
    set(hObj, ...
        'XData', handles.DisplayData.Time, ...
        'YData', handles.DisplayData.(varName));
end

if handles.(varNameCh).Value
    hObj.Visible = 'on';
else
    hObj.Visible = 'off';
end

handles.(varNameDV) = hObj;

end


function [axSide,color,displayName] = getVarProp(varName)
switch varName
    case 'ActivityIndex'
        axSide = 'left';
        color = 'red';
        displayName = 'Activity Index (AI)';
    case 'CircadianStimulus'
        axSide = 'left';
        color = 'blue';
        displayName = 'Circadian Stimulus (CS)';
    case 'CircadianLight'
        axSide = 'right';
        color = 'green';
        displayName = 'Circadian Light (CLA)';
    case 'Illuminance'
        axSide = 'right';
        color = 'black';
        displayName = 'Illuminance (lux)';
    otherwise
        error('Unrecognized varName');
end

end