function forward(hObject, handles)
%FORWARD Summary of this function goes here
% hObject    handle to forward (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

if handles.EditCount ~= 0
    qStr = 'You have unsaved changes would you like to save before continuing?';
    qTitle = 'Revert Changes?';
    button = questdlg(qStr,qTitle,'Yes (save)','No (revert)','Cancel','Yes (save)');
    
    switch button
        case 'Yes (save)'
            handles = saveChanges(hObject, handles);
            advance
        case 'No (revert)'
            handles = revertChanges(hObject, handles);
            advance
    end
else
    advance
end

    function advance
        if handles.ActiveDataIdx < numel(handles.SourceData)
            TargetDataIdx = handles.ActiveDataIdx + 1;
            changeDataSet(hObject,handles,TargetDataIdx);
        end
    end

end

