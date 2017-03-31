function backward(hObject, handles)
%BACKWARD Summary of this function goes here
% hObject    handle to forward (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

if handles.EditCount ~= 0
    qStr = 'You have unsaved changes would you like to save before continuing?';
    qTitle = 'Revert Changes?';
    button = questdlg(qStr,qTitle,'Yes (save)','No (revert)','Cancel','Yes (save)');
    
    switch button
        case 'Yes (save)'
            handles = saveChanges(hObject, handles);
            previous
        case 'No (revert)'
            handles = revertChanges(hObject, handles);
            previous
    end
else
    previous
end

    function previous
        if handles.ActiveDataIdx < numel(handles.SourceData)
            TargetDataIdx = handles.ActiveDataIdx - 1;
            changeDataSet(hObject,handles,TargetDataIdx);
        end
    end

end

