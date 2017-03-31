function varargout = changeDataSet(hObject, handles, TargetDataIdx)
%CHANGEDATASET Summary of this function goes here
%   Detailed explanation goes here
% Change data set

% Short circut if target is the same as current
if TargetDataIdx == handles.ActiveDataIdx
    return
end

[jObj,handles] = startBusy(handles,'loading...');

% Change the active data index to the target data index
handles.ActiveDataIdx = TargetDataIdx;

% Convert data to selections
handles.Selections = d12pack2selections(handles.SourceData(handles.ActiveDataIdx));

% Set active selection slection index
if numel(handles.Selections) > 0
    handles.ActiveSelectionIdx = 1;
else
    handles.ActiveSelectionIdx = 0;
end

% Plot data
handles = plotData(handles);

% Update list
handles = updateSelectionList(hObject,handles);

% Update editor
handles = updateActiveSelection(hObject,handles);

% Construct filter options
handles = makeFilterOptions(hObject, handles);

% Set class
cStr = class(handles.SourceData(handles.ActiveDataIdx));
handles.text_class.String = sprintf('Class: %s',cStr);

% Set serial number
sn = handles.SourceData(handles.ActiveDataIdx).SerialNumber;
handles.text_sn.String = sprintf('Serial Number: %u',sn);

% Set ID
id = handles.SourceData(handles.ActiveDataIdx).ID;
handles.text_id.String = sprintf('Identifier: %s',id);

% Adjust slider settings to data
setSliderLim(handles);
setSliderStep(handles);

% Position detail window
handles = reposition_detail_window(handles);

% Refocus selection
refocusSelection(hObject,handles)

% Reset edit counter
handles.EditCount = 0;

% Validate controls
handles = validateControls(hObject, handles);

% Update handles structure
guidata(hObject, handles);

if nargout == 1
    varargout = {handles};
end

stopBusy(handles,jObj,'done');

end

