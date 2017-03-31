function varargout = revertChanges(hObject, handles)
%REVERTCHANGES Revert Selections to previously saved version
%   Detailed explanation goes here

% Convert data to selections
handles.Selections = d12pack2selections(handles.SourceData(handles.ActiveDataIdx));

% Set active selection slection index
if numel(handles.Selections) > 0
    handles.ActiveSelectionIdx = 1;
else
    handles.ActiveSelectionIdx = 0;
end

% Update list
handles = updateSelectionList(hObject,handles);

% Update editor
handles = updateActiveSelection(hObject,handles);

% Construct filter options
handles = makeFilterOptions(hObject, handles);

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

end

