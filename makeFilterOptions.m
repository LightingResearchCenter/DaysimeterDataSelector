function varargout = makeFilterOptions(hObject, handles)
%MAKEFILTEROPTIONS Summary of this function goes here
%   Detailed explanation goes here

% Check if there is source data once and save result
isData = ~isempty(handles.SourceData);

% Check what properties the source data supports
if isData
    isBed           = isprop(handles.SourceData(handles.ActiveDataIdx), 'BedLog');
    isError         = isprop(handles.SourceData(handles.ActiveDataIdx), 'Error');
    isNoncompliance = isprop(handles.SourceData(handles.ActiveDataIdx), 'Compliance');
    isObservation   = isprop(handles.SourceData(handles.ActiveDataIdx), 'Observation');
    isWork          = isprop(handles.SourceData(handles.ActiveDataIdx), 'WorkLog');
else
    isBed           = false;
    isError         = false;
    isNoncompliance = false;
    isObservation   = false;
    isWork          = false;
end

% Construct cell string array
filterString = {'All Types'};
if isBed % Bed
    filterString = vertcat(filterString,{'Bed'});
end
if isError % Device Error
    filterString = vertcat(filterString,{'Device Error'});
end
if isNoncompliance % Noncompliance
    filterString = vertcat(filterString,{'Noncompliance'});
end
if isObservation % Observation
    filterString = vertcat(filterString,{'Observation'});
end
if isWork % Work
    filterString = vertcat(filterString,{'Work'});
end
handles.popupmenu_filtertype.String = filterString;

% Save changes to handles
guidata(hObject,handles);

% Return handles if requested
if nargout == 1
    varargout = {handles};
end

end

