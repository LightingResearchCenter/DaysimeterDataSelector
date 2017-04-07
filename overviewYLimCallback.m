function [ output_args ] = overviewYLimCallback(hObject, eventdata, handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if isstruct(handles) && ~strcmp(hObject.YScale,'log')
    yyaxis(hObject,'left');
    
    varNames = {'Observation','Bed','Work','Noncompliance','Error'};
    for iVar = 1:numel(varNames)
        % Search for object with matching tag
        hObjSel = findobj(hObject,'Tag',varNames{iVar});
        if ~isempty(hObjSel) % If object exists
            YData = hObject.YLim(2)*hObjSel.YData/max(hObjSel.YData);
            hObjSel.YData = YData;
        end
    end
    
    yHighlight = [0, handles.axes_overview.YLim(2), handles.axes_overview.YLim(2), 0];

    hObjHi = findobj(handles.axes_overview,'Tag','OverviewHighlight');
    if ~isempty(hObjHi) % If a highlight box exists
        YData = hObject.YLim(2)*hObjHi.YData/max(hObjHi.YData);
        hObjHi.YData = YData;
    end
end

end

