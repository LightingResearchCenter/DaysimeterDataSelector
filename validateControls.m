function varargout = validateControls(hObject, handles)
%VALIDATECONTROLS Checks which controls should be enabled or disabled
%   Detailed explanation goes here

% Check if there is source data once and save result
isData = ~isempty(handles.SourceData);

% Check the number of source data sets and save result
nSourceData = numel(handles.SourceData);

% Check the number of active selections and save result
if isData
    nActiveSelection = numel(handles.ActiveSelectionIdx);
    if handles.ActiveSelectionIdx == 0
        nActiveSelection = 0;
    end
else
    nActiveSelection = 0;
end

% Check if one selection is active
isOneSelection = nActiveSelection == 1;

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

%% Menus
%% -> File
%  --> Save
if isData
    enable('save')
else
    disable('save')
end
%% -> Data
if isData
    enable('menu_data')
else
    disable('menu_data')
end
%  --> Back
if isData && handles.ActiveDataIdx > 1
    enable('back')
else
    disable('back')
end
%  --> Forward
if isData && handles.ActiveDataIdx < nSourceData
    enable('forward')
else
    disable('forward')
end
%  --> Jump to...
if isData && nSourceData > 1
    enable('jump')
else
    disable('jump')
end

%% Selections Panel
% Filter
if isData
    enable('popupmenu_filtertype')
else
    disable('popupmenu_filtertype')
end
% Add Selection
if isData
    enable('pushbutton_addselection')
else
    disable('pushbutton_addselection')
end
% Remove Selection(s)
if isData && nActiveSelection > 0
    enable('pushbutton_removeselection')
else
    disable('pushbutton_removeselection')
end

%% Selection Editor Panel
%% Selection Type Sub-Panel
% Bed
if isOneSelection && isBed
    enable('radiobutton_bed')
else
    disable('radiobutton_bed')
end
% Device Error
if isOneSelection && isError
    enable('radiobutton_error')
else
    disable('radiobutton_error')
end
% Noncompliance
if isOneSelection && isNoncompliance
    enable('radiobutton_noncompliance')
else
    disable('radiobutton_noncompliance')
end
% Observation
if isOneSelection && isObservation
    enable('radiobutton_observation')
else
    disable('radiobutton_observation')
end
% Work
if isOneSelection && isWork
    enable('radiobutton_work')
else
    disable('radiobutton_work')
end
%% Start & End Sub-Panels

if isData && isOneSelection
    % Start
    enable('pushbutton_pickstart')
    enable('pushbutton_plusstart')
    enable('pushbutton_minusstart')
    enable('text_startLabel')
    % End
    enable('pushbutton_pickend')
    enable('pushbutton_plusend')
    enable('pushbutton_minusend')
    enable('text_endLabel')
else
    % Start
    disable('pushbutton_pickstart')
    disable('pushbutton_plusstart')
    disable('pushbutton_minusstart')
    disable('text_startLabel')
    % End
    disable('pushbutton_pickend')
    disable('pushbutton_plusend')
    disable('pushbutton_minusend')
    disable('text_endLabel')
end

%% Zoom Level Panel
if isData
    enable('zoom48')
    enable('zoom24')
    enable('zoom12')
    enable('zoom06')
    enable('zoom02')
else
    disable('zoom48')
    disable('zoom24')
    disable('zoom12')
    disable('zoom06')
    disable('zoom02')
end

%% Data Display Panel
if isData
    enable('checkbox_ActivityIndex')
    enable('checkbox_CircadianStimulus')
    enable('checkbox_CircadianLight')
    enable('checkbox_Illuminance')
else
    disable('checkbox_ActivityIndex')
    disable('checkbox_CircadianStimulus')
    disable('checkbox_CircadianLight')
    disable('checkbox_Illuminance')
end

%% Selection Display Panel
% None
if isData
    enable('checkbox_none')
else
    disable('checkbox_none')
end
% Bed
if isBed
    enable('checkbox_bed')
else
    disable('checkbox_bed')
end
% Device Error
if isError
    enable('checkbox_error')
else
    disable('checkbox_error')
end
% Noncompliance
if isNoncompliance
    enable('checkbox_noncompliance')
else
    disable('checkbox_noncompliance')
end
% Observation
if isObservation
    enable('checkbox_observation')
else
    disable('checkbox_observation')
end
% Work
if isWork
    enable('checkbox_work')
else
    disable('checkbox_work')
end

%% Data Set Panel
% Save Changes and Revert Changes
if isData && handles.EditCount ~= 0
    enable('pushbutton_savechanges')
    enable('pushbutton_revertchanges')
else
    disable('pushbutton_savechanges')
    disable('pushbutton_revertchanges')
end
% Back
if isData && handles.ActiveDataIdx > 1
    enable('pushbutton_back')
else
    disable('pushbutton_back')
end
% Forward
if isData && handles.ActiveDataIdx < nSourceData
    enable('pushbutton_forward')
else
    disable('pushbutton_forward')
end

%%
% Save changes to handles
guidata(hObject,handles);

% Return handles if requested
if nargout == 1
    varargout = {handles};
end

%% Nested utility functions
% Enable the object that matches the tag
    function enable(tag)
        handles.(tag).Enable = 'on';
    end

% Disable the object that matches the tag
    function disable(tag)
        handles.(tag).Enable = 'off';
    end

end