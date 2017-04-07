function detailYLimCallback(hObject, eventdata, handles)
%DETAIL Summary of this function goes here
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
    
    hObjDrag = findobj(hObject,'Tag','draggable');
    if ~isempty(hObjDrag) % If a draggable line exists
        for iDrag = 1:numel(hObjDrag)
            hObjDrag(iDrag).YData(2) = hObject.YLim(2);
        end
    end
end

end

