function handles = plotData(handles)
%PLOTDATA Summary of this function goes here
%   Detailed explanation goes here
% handles    structure with handles and user data (see GUIDATA)

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
    % Convert data to simple form
    handles.DisplayData.(varNames{iVar}) = handles.SourceData(idx).(varNames{iVar});
    
    % Force low values to 0.1 for data that is displayed on a log scale
    if ismember(varNames{iVar},{'CircadianLight','Illuminance'})
        idxLow = handles.DisplayData.(varNames{iVar}) < 0.1;
        handles.DisplayData.(varNames{iVar})(idxLow) = 0.1;
    end
    
    % Plot data
    handles = overviewPlot(handles,varNames{iVar});
    handles = detailPlot(handles,varNames{iVar});
end

% Format axes
yMaxLeft = max([1;handles.DisplayData.ActivityIndex]);
yMaxRight = max([10^5;handles.DisplayData.CircadianLight;handles.DisplayData.Illuminance]);
yMaxRight = 10^(round(10*log10(yMaxRight))/10);

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
handles.axes_detail.YTick = 0:0.1:yMaxLeft;
n = numel(handles.axes_detail.YTick);

yyaxis(handles.axes_detail,'right')
handles.axes_detail.YLimMode = 'manual';
handles.axes_detail.YLim = [0.1,yMaxRight];

expoInc = (log10(yMaxRight) - log10(0.1))/(n-1);
expo = log10(0.1):expoInc:log10(yMaxRight);
handles.axes_detail.YTick = 10.^(expo);
ylabels = "10^{" + regexprep(string(num2str(expo')),'\s*','') + "}";
ylabels(1) = "(0)";
handles.axes_detail.YTickLabel = ylabels;

% Plot draggable lines
handles = dragLines(handles);

% Create detail highlight in overview if it doesn't exist
if ~isfield(handles,'OverviewHighlight') || isempty(handles.OverviewHighlight)
    % Create highlight
    yyaxis(handles.axes_overview,'left')
    handles.axes_overview.YColor = [0.15 0.15 0.15];
    hold(handles.axes_overview,'on');
    xHighlight = [handles.axes_detail.XLim(1),handles.axes_detail.XLim(1),handles.axes_detail.XLim(2),handles.axes_detail.XLim(2)];
    yHighlight = [    0,    1,    1,    0];
    handles.OverviewHighlight = area(handles.axes_overview, xHighlight, yHighlight, ...
        'FaceColor', 'none', ...
        'EdgeColor', [0.8 0.8 0.8], ...
        'LineWidth', 1.5, ...
        'LineStyle', ':', ...
        'Tag', 'OverviewHighlight');
end

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
        color  = [0 0 0]; % black
        displayName = 'Activity Index (AI)';
    case 'CircadianStimulus'
        axSide = 'left';
        color  = [0.651 0.808 0.890]; % light blue
        displayName = 'Circadian Stimulus (CS)';
    case 'CircadianLight'
        axSide = 'right';
        color  = [0.698 0.875 0.541]; % light green
        displayName = 'Circadian Light (CLA)';
    case 'Illuminance'
        axSide = 'right';
        color  = [0.992 0.749 0.435]; % light orange
        displayName = 'Illuminance (lux)';
    otherwise
        error('Unrecognized varName');
end

end

function handles = dragLines(handles)
% Switch axes side
yyaxis(handles.axes_detail,'left')

% Define line colors
color1 = [0.122 0.471 0.706]; % dark blue
color2 = [0.890 0.102 0.110]; % dark red

% Calculate position to start lines at
x1 = handles.axes_detail.XLim(1) + 0.15*diff(handles.axes_detail.XLim);
x2 = handles.axes_detail.XLim(2) - 0.15*diff(handles.axes_detail.XLim);

% See if handle already exists
if ~isfield(handles, 'dragLine1') || ~isfield(handles, 'dragLine2')
    % Check for leftover draggable lines and remove them
    hObj = findobj(handles.axes_detail,'Tag','draggable');
    delete(hObj);
    
    % Create new lines
    handles.dragLine1 = DraggableLine(handles.axes_detail, x1, 2, color1);
    handles.dragLine2 = DraggableLine(handles.axes_detail, x2, 2, color2);
    
    handles.dragLine1.Handle.DisplayName = 'Selection Start';
    handles.dragLine2.Handle.DisplayName = 'Selection End';
else
    handles.dragLine1.Position = x1;
    handles.dragLine2.Position = x2;
end

% Set line visibility
handles.dragLine1.Visible = 'off';
handles.dragLine2.Visible = 'off';

end