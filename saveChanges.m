function varargout = saveChanges(hObject, handles)
%SAVECHANGES Summary of this function goes here
%   Detailed explanation goes here

% Save the ID
handles.SourceData(handles.ActiveDataIdx).ID = handles.edit_id.String;

% Convert changes back to d12pack object
handles.SourceData(handles.ActiveDataIdx) = selections2d12pack(handles.Selections, handles.SourceData(handles.ActiveDataIdx));

% Reset edit counter
handles.EditCount = 0;

% Validate controls
handles = validateControls(hObject, handles);

guidata(hObject, handles)

if nargout == 1
    varargout = {handles};
end

end

