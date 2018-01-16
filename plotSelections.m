function handles = plotSelections(handles)
%PLOTSELECTIONS Summary of this function goes here
%   Detailed explanation goes here

% Retrieve index of data to plot
idx = handles.ActiveDataIdx;

% Check if DisplayData exists
if ~isfield(handles, 'DisplayData') % DisplayData does not exist so make it
    handles.DisplayData = struct;
end
% Copy Time over to DisplayData
handles.DisplayData.Time = handles.SourceData(idx).Time;

varNames = {'Observation','Bed','Work','Noncompliance','Error'}; % order determines plot order

for iVar = 1:numel(varNames)
    % Convert data to simple form
    idxMatch = vertcat(handles.Selections.Type) == SelectionType(varNames{iVar});
    theseSelections = handles.Selections(idxMatch);
    handles.DisplayData.(varNames{iVar}) = theseSelections.Selection2Index(handles.DisplayData.Time);
        
    % Plot selections
    handles = overviewPlot(handles,varNames{iVar});
    handles = detailPlot(handles,varNames{iVar});
end

end


function handles = overviewPlot(handles,varName)
varNameOV = [varName,'_Overview'];
varNameCh = ['checkbox_',varName];

[color,displayName] = getVarProp(varName);
ax = handles.axes_overview;
yyaxis(ax,'left');

% Search for object with matching tag
hObj = findobj(ax,'Tag',varName);

if isempty(hObj) % If object does not exist make it
    hold(ax,'on');
    hObj = area(ax,...
        handles.DisplayData.Time,...
        ax.YLim(2)*handles.DisplayData.(varName),...
        'EdgeColor',   'none',...
        'FaceColor',   color,...
        'Visible',     'off',...
        'Tag',         varName,...
        'DisplayName', displayName,...
        'AlignVertexCenters', 'on');
    hold(ax,'off');
else % else modify it
    set(hObj, ...
        'XData', (handles.DisplayData.Time(:))', ...
        'YData', (ax.YLim(2)*handles.DisplayData.(varName)(:))');
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

[color,displayName] = getVarProp(varName);
ax = handles.axes_detail;
yyaxis(ax,'left');

% Format axes
if isfield(handles.DisplayData,'Error') && isfield(handles.DisplayData,'ActivityIndex')
    if any(handles.DisplayData.Error)
        yMaxLeft = 1;
    else
        yMaxLeft = max([1;handles.DisplayData.ActivityIndex]);
    end
    yMaxRight = max([10^5;handles.DisplayData.CircadianLight;handles.DisplayData.Illuminance]);
    yMaxRight = 10^(round(10*log10(yMaxRight))/10);
    
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
end

% Search for object with matching tag
hObj = findobj(ax,'Tag',varName);

if isempty(hObj) % If object does not exist make it
    hold(ax,'on');
    hObj = area(ax,...
        handles.DisplayData.Time,...
        ax.YLim(2)*handles.DisplayData.(varName),...
        'EdgeColor',   'none',...
        'FaceColor',   color,...
        'Visible',     'off',...
        'Tag',         varName,...
        'DisplayName', displayName,...
        'AlignVertexCenters', 'on');
    hold(ax,'off');
else % else modify it
    set(hObj, ...
        'XData', (handles.DisplayData.Time(:))', ...
        'YData', (ax.YLim(2)*handles.DisplayData.(varName)(:))');
end

if handles.(varNameCh).Value
    hObj.Visible = 'on';
else
    hObj.Visible = 'off';
end

handles.(varNameDV) = hObj;

end


function [color,displayName] = getVarProp(varName)
switch varName
    case 'Bed'
        color  = [0.416 0.239 0.604]; % dark purple
        displayName = 'Bed';
    case 'Error'
        color  = [0.984 0.604 0.600]; % pale red
        displayName = 'Device Error)';
    case 'Noncompliance'
        color  = [1 1 0.600]; % pale yellow
        displayName = 'Noncompliance';
    case 'Observation'
        color  = [1 1 1]; % white
        displayName = 'Observation';
    case 'Work'
        color  = [0.200 0.628 0.173]; % dark green
        displayName = 'Work';
    otherwise
        error('Unrecognized varName');
end

end

