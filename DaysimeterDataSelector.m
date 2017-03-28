function varargout = DaysimeterDataSelector(varargin)
% DAYSIMETERDATASELECTOR MATLAB code for DaysimeterDataSelector.fig
%      DAYSIMETERDATASELECTOR, by itself, creates a new DAYSIMETERDATASELECTOR or raises the existing
%      singleton*.
%
%      H = DAYSIMETERDATASELECTOR returns the handle to a new DAYSIMETERDATASELECTOR or the handle to
%      the existing singleton*.
%
%      DAYSIMETERDATASELECTOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DAYSIMETERDATASELECTOR.M with the given input arguments.
%
%      DAYSIMETERDATASELECTOR('Property','Value',...) creates a new DAYSIMETERDATASELECTOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DaysimeterDataSelector_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DaysimeterDataSelector_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DaysimeterDataSelector

% Last Modified by GUIDE v2.5 27-Mar-2017 14:55:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @DaysimeterDataSelector_OpeningFcn, ...
    'gui_OutputFcn',  @DaysimeterDataSelector_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before DaysimeterDataSelector is made visible.
function DaysimeterDataSelector_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DaysimeterDataSelector (see VARARGIN)

% Choose default command line output for DaysimeterDataSelector
handles.output = hObject;

% Load data for testing
addpath('C:\Users\jonesg5\Documents\GitHub\d12pack');

% Create SourceData and initialize to empty value
handles.SourceData = [];

% Create Selections and initialize to empty value
handles.Selections = Selection.empty;

% Create ActiveDataIdx and initialize to zero
handles.ActiveDataIdx = 0;

% Create EditCount and initialize to zero
handles.EditCount = 0;

% Enable only valid buttons and menus
checkButtons(handles)
checkMenus(handles)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DaysimeterDataSelector wait for user response (see UIRESUME)
% uiwait(hObject);


% --- Outputs from this function are returned to the command line.
function varargout = DaysimeterDataSelector_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider_detailposition_Callback(hObject, eventdata, handles)
% hObject    handle to slider_detailposition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
reposition_detail_window(handles);


% --- Executes during object creation, after setting all properties.
function slider_detailposition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_detailposition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes when selected object is changed in uibuttongroup_zoom.
function uibuttongroup_zoom_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup_zoom
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

reposition_detail_window(handles);
setSliderStep(handles);


% --- Reposition detail window
function varargout = reposition_detail_window(handles)

zoomLevel = getXZoom(handles);

% Convert slider position to center point
XCenter = datetime(handles.slider_detailposition.Value,'ConvertFrom','datenum','TimeZone',handles.DisplayData.Time.TimeZone);

% Set detail window axis limits
XLim1 = XCenter - zoomLevel/2;
XLim2 = XCenter + zoomLevel/2;
handles.axes_detail.XLim = [XLim1, XLim2];

handles = reposition_overview_highlight(handles);

if nargout == 1
    varargout = {handles};
end


% --- Reposition overview highlight
function varargout = reposition_overview_highlight(handles)
yyaxis(handles.axes_detail,'left');
xHighlight = [handles.axes_detail.XLim(1),handles.axes_detail.XLim(1),handles.axes_detail.XLim(2),handles.axes_detail.XLim(2)];
yHighlight = [    0,    1,    1,    0];

handles.OverviewHighlight = findobj(handles.axes_overview,'Tag','OverviewHighlight');
set(handles.OverviewHighlight,'XData',xHighlight,'YData',yHighlight);

if nargout == 1
    varargout = {handles};
end


% --- Executes on button press in checkbox_ActivityIndex.
function checkbox_ActivityIndex_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_ActivityIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_ActivityIndex

setDataVisibility(handles,'ActivityIndex',hObject.Value)

% --- Executes on button press in checkbox_CircadianStimulus.
function checkbox_CircadianStimulus_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_CircadianStimulus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_CircadianStimulus

setDataVisibility(handles,'CircadianStimulus',hObject.Value)

% --- Executes on button press in checkbox_CircadianLight.
function checkbox_CircadianLight_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_CircadianLight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_CircadianLight

setDataVisibility(handles,'CircadianLight',hObject.Value)

% --- Executes on button press in checkbox_Illuminance.
function checkbox_Illuminance_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Illuminance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Illuminance

setDataVisibility(handles,'Illuminance',hObject.Value)

% --------------------------------------------------------------------
function d = findDaysimeterData(s)
% s   struct containing possible Daysimeter data
% d   Daysimeter data
f = fieldnames(s);
nField = numel(f);
c = cell(nField,1);
for iField = nField
    if isa(s.(f{iField}),'d12pack.DaysimeterData')
        temp = s.(f{iField});
        c{iField} = temp(:); % Make sure data is in a vertical array.
    end
end
c(cellfun(@isempty,c)) = []; % Remove empty cells.
d = vertcat(c{:}); % Combine data into an array.


% --------------------------------------------------------------------
function zoomLevel = getXZoom(handles)
% handles    structure with handles and user data (see GUIDATA)

switch handles.uibuttongroup_zoom.SelectedObject.Tag
    case 'zoom48'
        zoomLevel = duration(48,0,0);
    case 'zoom24'
        zoomLevel = duration(24,0,0);
    case 'zoom12'
        zoomLevel = duration(12,0,0);
    case 'zoom06'
        zoomLevel = duration( 6,0,0);
    case 'zoom02'
        zoomLevel = duration( 2,0,0);
    otherwise
        warning(['Zoom level: ',handles.uibuttongroup_zoom.SelectedObject.Tag,' not recognized.']);
        zoomLevel = duration(48,0,0);
end


% --------------------------------------------------------------------
function setSliderLim(handles)
% handles    structure with handles and user data (see GUIDATA)

handles.slider_detailposition.Min = datenum(handles.DisplayData.Time(1));
handles.slider_detailposition.Max = datenum(handles.DisplayData.Time(end));
handles.slider_detailposition.Value = handles.slider_detailposition.Min;


% --------------------------------------------------------------------
function setSliderStep(handles)
% handles    structure with handles and user data (see GUIDATA)

zoomLevel_days = days(getXZoom(handles));
handles.slider_detailposition.SliderStep = [0.01*zoomLevel_days,0.1*zoomLevel_days];


% Menus

% --------------------------------------------------------------------
function menu_file_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_data_Callback(hObject, eventdata, handles)
% hObject    handle to menu_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_preferences_Callback(hObject, eventdata, handles)
% hObject    handle to menu_preferences (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function autosave_Callback(hObject, eventdata, handles)
% hObject    handle to autosave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function forward_Callback(hObject, eventdata, handles)
% hObject    handle to forward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.ActiveDataIdx < numel(handles.SourceData)
    TargetDataIdx = handles.ActiveDataIdx + 1;
    changeDataSet(hObject,handles,TargetDataIdx);
end

% --------------------------------------------------------------------
function back_Callback(hObject, eventdata, handles)
% hObject    handle to back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.ActiveDataIdx > 1
    TargetDataIdx = handles.ActiveDataIdx - 1;
    changeDataSet(hObject,handles,TargetDataIdx);
end

% --------------------------------------------------------------------
function jump_Callback(hObject, eventdata, handles)
% hObject    handle to jump (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = {handles.SourceData.ID};
[TargetDataIdx,ok] = listdlg('PromptString','Jump to data set with ID:',...
    'SelectionMode','single',...
    'ListString',str);
if ok
    changeDataSet(hObject,handles,TargetDataIdx);
end

% --------------------------------------------------------------------
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName] = uigetfile('*.mat','Select the MATLAB data file');

if FileName == 0
    return
end

s = load(fullfile(PathName,FileName));
handles.SourceData = findDaysimeterData(s);
handles.ActiveDataIdx = 0;
changeDataSet(hObject,handles,1);

% --------------------------------------------------------------------
function import_Callback(hObject, eventdata, handles)
% hObject    handle to import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function quit_Callback(hObject, eventdata, handles)
% hObject    handle to quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function autosave_onoff_Callback(hObject, eventdata, handles)
% hObject    handle to autosave_onoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function autosave_location_Callback(hObject, eventdata, handles)
% hObject    handle to autosave_location (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function context_autosave_location_Callback(hObject, eventdata, handles)
% hObject    handle to context_autosave_location (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_back.
function pushbutton_back_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.ActiveDataIdx > 1
    TargetDataIdx = handles.ActiveDataIdx - 1;
    changeDataSet(hObject,handles,TargetDataIdx);
end

% --- Executes on button press in pushbutton_forward.
function pushbutton_forward_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_forward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.ActiveDataIdx < numel(handles.SourceData)
    TargetDataIdx = handles.ActiveDataIdx + 1;
    changeDataSet(hObject,handles,TargetDataIdx);
end

% --- Executes on button press in pushbutton_revertchanges.
function pushbutton_revertchanges_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_revertchanges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_savechanges.
function pushbutton_savechanges_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_savechanges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox_selections.
function listbox_selections_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_selections (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_selections contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_selections

handles.ActiveSelectionIdx = getSelectionIndex(handles);

handles = updateActiveSelection(hObject,handles);

refocusSelection(hObject,handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function listbox_selections_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_selections (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_filtertype.
function popupmenu_filtertype_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_filtertype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_filtertype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_filtertype

handles = updateSelectionList(hObject,handles);
handles = updateActiveSelection(hObject,handles);
% Refocus
refocusSelection(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_filtertype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_filtertype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_addselection.
function pushbutton_addselection_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_addselection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Switch axes side
yyaxis(handles.axes_detail,'left')

% Calculate position to start at
x1 = handles.axes_detail.XLim(1) + 0.15*diff(handles.axes_detail.XLim);
x2 = handles.axes_detail.XLim(2) - 0.15*diff(handles.axes_detail.XLim);

filter = handles.popupmenu_filtertype.String{handles.popupmenu_filtertype.Value};

switch filter
    case 'All Types'
        type = SelectionType.Noncompliance;
    case 'Bed'
        type = SelectionType.Bed;
    case 'Device Error'
        type = SelectionType.Error;
    case 'Noncompliance'
        type = SelectionType.Noncompliance;
    case 'Observation'
        type = SelectionType.Observation;
    case 'Work'
        type = SelectionType.Work;
    otherwise
        error('Filter not recognized.');
end

% Change ActiveSelectionIdx to 1 more than the max
idx = numel(handles.Selections)+1;

% Create a new selection and add it to the list
handles.Selections(idx,1) = Selection([x1,x2],type);
handles = markEdit(hObject,handles);

handles.ActiveSelectionIdx = idx;

% Update the selection list
handles = updateSelectionList(hObject,handles);

% Update the editor
handles = updateActiveSelection(hObject,handles);

guidata(hObject,handles)

% --- Executes on button press in pushbutton_removeselection.
function pushbutton_removeselection_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_removeselection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
qStr = 'Are you sure you want to remove this selection(s)?';
qTitle = 'Remove Selection(s)?';
button = questdlg(qStr,qTitle,'Yes','No','No');

if strcmpi(button,'Yes') % Only delete data if response is Yes
    handles.Selections(handles.ActiveSelectionIdx) = [];
    handles = markEdit(hObject,handles);
    
    handles.ActiveSelectionIdx = 0;
    
    % Update the selection list
    handles = updateSelectionList(hObject,handles);
    
    % Update the editor
    handles = updateActiveSelection(hObject,handles);
    
    % Refocus
    refocusSelection(hObject,handles);
    
    guidata(hObject,handles)
end


% --- Executes on button press in pushbutton_autoselect.
function pushbutton_autoselect_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_autoselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_minusend.
function pushbutton_minusend_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_minusend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[~,idx] = min(abs(handles.Selections(handles.ActiveSelectionIdx).Lim(2)-handles.DisplayData.Time));
if idx > 1
    idx = idx - 1;
end
position = handles.DisplayData.Time(idx);
handles.Selections(handles.ActiveSelectionIdx).Lim(2) = position;
handles = markEdit(hObject,handles);

% Update editor
handles = updateActiveSelection(hObject,handles);
% Update list
handles = updateSelectionList(hObject,handles);

%Update app data
guidata(hObject,handles);

% --- Executes on button press in pushbutton_plusend.
function pushbutton_plusend_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plusend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[~,idx] = min(abs(handles.Selections(handles.ActiveSelectionIdx).Lim(2)-handles.DisplayData.Time));
if idx < numel(handles.DisplayData.Time)
    idx = idx + 1;
end
position = handles.DisplayData.Time(idx);
handles.Selections(handles.ActiveSelectionIdx).Lim(2) = position;
handles = markEdit(hObject,handles);

% Update editor
handles = updateActiveSelection(hObject,handles);
% Update list
handles = updateSelectionList(hObject,handles);

%Update app data
guidata(hObject,handles);

% --- Executes on button press in pushbutton_pickend.
function pushbutton_pickend_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_pickend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tz = handles.DisplayData.Time.TimeZone;
position = datetime(handles.slider_detailposition.Value,'ConvertFrom','datenum','TimeZone',tz);
position = Snap(position,handles);
handles.Selections(handles.ActiveSelectionIdx).Lim(2) = position;
handles = markEdit(hObject,handles);

% Update editor
handles = updateActiveSelection(hObject,handles);
% Update list
handles = updateSelectionList(hObject,handles);

%Update app data
guidata(hObject,handles);

% --- Executes on button press in pushbutton_minusstart.
function pushbutton_minusstart_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_minusstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[~,idx] = min(abs(handles.Selections(handles.ActiveSelectionIdx).Lim(1)-handles.DisplayData.Time));
if idx > 1
    idx = idx - 1;
end
position = handles.DisplayData.Time(idx);
handles.Selections(handles.ActiveSelectionIdx).Lim(1) = position;
handles = markEdit(hObject,handles);

% Update editor
handles = updateActiveSelection(hObject,handles);
% Update list
handles = updateSelectionList(hObject,handles);

%Update app data
guidata(hObject,handles);

% --- Executes on button press in pushbutton_plusstart.
function pushbutton_plusstart_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plusstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[~,idx] = min(abs(handles.Selections(handles.ActiveSelectionIdx).Lim(1)-handles.DisplayData.Time));
if idx < numel(handles.DisplayData.Time)
    idx = idx + 1;
end
position = handles.DisplayData.Time(idx);
handles.Selections(handles.ActiveSelectionIdx).Lim(1) = position;
handles = markEdit(hObject,handles);

% Update editor
handles = updateActiveSelection(hObject,handles);
% Update list
handles = updateSelectionList(hObject,handles);

%Update app data
guidata(hObject,handles);

% --- Executes on button press in pushbutton_pickstart.
function pushbutton_pickstart_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_pickstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tz = handles.DisplayData.Time.TimeZone;
position = datetime(handles.slider_detailposition.Value,'ConvertFrom','datenum','TimeZone',tz);
position = Snap(position,handles);
handles.Selections(handles.ActiveSelectionIdx).Lim(1) = position;
handles = markEdit(hObject,handles);

% Update editor
handles = updateActiveSelection(hObject,handles);
% Update list
handles = updateSelectionList(hObject,handles);

%Update app data
guidata(hObject,handles);

% Change data set
function changeDataSet(hObject,handles,TargetDataIdx)

if TargetDataIdx == handles.ActiveDataIdx
    return
end

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

% Disable/Enable buttons
checkButtons(handles);

% Disable/Enable menus
checkMenus(handles);

% Disable/Enable selection types
checkTypes(handles);

% Set title
handles.text_id.String = sprintf('ID: %s',handles.SourceData(handles.ActiveDataIdx).ID);

% Adjust slider settings to data
setSliderLim(handles);
setSliderStep(handles);

% Position detail window
handles = reposition_detail_window(handles);

% Refocus selection
refocusSelection(hObject,handles)

% Update handles structure
guidata(hObject, handles);


function checkButtons(handles)

if handles.ActiveDataIdx == 1 || handles.ActiveDataIdx == 0
    handles.pushbutton_back.Enable = 'off';
else
    handles.pushbutton_back.Enable = 'on';
end

if handles.ActiveDataIdx == numel(handles.SourceData)
    handles.pushbutton_forward.Enable = 'off';
else
    handles.pushbutton_forward.Enable = 'on';
end

if isedited(handles)
    handles.pushbutton_savechanges.Enable   = 'on';
    handles.pushbutton_revertchanges.Enable = 'on';
else
    handles.pushbutton_savechanges.Enable   = 'off';
    handles.pushbutton_revertchanges.Enable = 'off';
end



function checkMenus(handles)

if isempty(handles.SourceData)
    handles.menu_data.Enable = 'off';
else
    handles.menu_data.Enable = 'on';
    
    if handles.ActiveDataIdx == 1 || handles.ActiveDataIdx == 0
        handles.back.Enable = 'off';
    else
        handles.back.Enable = 'on';
    end
    
    if handles.ActiveDataIdx == numel(handles.SourceData)
        handles.forward.Enable = 'off';
    else
        handles.forward.Enable = 'on';
    end
end

function checkTypes(handles)
filterString = {'All Types'};

if isprop(handles.SourceData(handles.ActiveDataIdx),'BedLog')
    handles.radiobutton_bed.Enable = 'on';
    filterString = vertcat(filterString,{'Bed'});
else
    handles.radiobutton_bed.Enable = 'off';
end

if isprop(handles.SourceData(handles.ActiveDataIdx),'Error')
    handles.radiobutton_error.Enable = 'on';
    filterString = vertcat(filterString,{'Device Error'});
else
    handles.radiobutton_error.Enable = 'off';
end

if isprop(handles.SourceData(handles.ActiveDataIdx),'Compliance')
    handles.radiobutton_noncompliance.Enable = 'on';
    filterString = vertcat(filterString,{'Noncompliance'});
else
    handles.radiobutton_noncompliance.Enable = 'off';
end

if isprop(handles.SourceData(handles.ActiveDataIdx),'Observation')
    handles.radiobutton_observation.Enable = 'on';
    filterString = vertcat(filterString,{'Observation'});
else
    handles.radiobutton_observation.Enable = 'off';
end

if isprop(handles.SourceData(handles.ActiveDataIdx),'WorkLog')
    handles.radiobutton_work.Enable = 'on';
    filterString = vertcat(filterString,{'Work'});
else
    handles.radiobutton_work.Enable = 'off';
end

handles.popupmenu_filtertype.String = filterString;

% --- Executes during object creation, after setting all properties.
function axes_detail_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_detail (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_detail

% Make dual axis
yyaxis(hObject,'right')
hObject.YScale = 'log';


% --- Executes during object creation, after setting all properties.
function axes_overview_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_overview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_overview

% Make dual axis
yyaxis(hObject,'right')
hObject.YScale = 'log';

% Create highlight
yyaxis(hObject,'left')
hold(hObject,'on');
area(hObject,datetime('now','TimeZone','local')+[0,0,1,1],[0,1,1,0],'FaceColor',[1, 1, 1],'EdgeColor','none','Tag','OverviewHighlight');

function setDataVisibility(handles,varName,visState)

if visState
    visString = 'on';
else
    visString = 'off';
end

% Search for object with matching tag
hObj = findobj(hObject,'Tag',varName);

for iObj = 1:numel(hObj)
    hObj(iObj).Visible = visString;
end

function varargout = updateSelectionList(hObject,handles)

filter = handles.popupmenu_filtertype.String{handles.popupmenu_filtertype.Value};

switch filter
    case 'All Types'
        idxFilter = true(size(handles.Selections));
    case 'Bed'
        idxFilter = vertcat(handles.Selections.Type) == SelectionType.Bed;
    case 'Device Error'
        idxFilter = vertcat(handles.Selections.Type) == SelectionType.Error;
    case 'Noncompliance'
        idxFilter = vertcat(handles.Selections.Type) == SelectionType.Noncompliance;
    case 'Observation'
        idxFilter = vertcat(handles.Selections.Type) == SelectionType.Observation;
    case 'Work'
        idxFilter = vertcat(handles.Selections.Type) == SelectionType.Work;
    otherwise
        error('Filter not recognized.');
end

if any(idxFilter)
    listString = handles.Selections.string;
    listString = listString(idxFilter);
    enable = 'on';
    idx = str2idx(listString);
    if numel(handles.ActiveSelectionIdx) == 1 && any(ismember(handles.ActiveSelectionIdx,idx))
        [lia,locb] = ismember(handles.ActiveSelectionIdx,idx);
        value = locb(lia);
    else
        value = 1;
    end
else
    listString = 'none';
    enable = 'off';
    value = 1;
end

handles.listbox_selections.Value = value;
handles.listbox_selections.String = listString;
handles.listbox_selections.Max = numel(listString);
handles.listbox_selections.Enable = enable;

handles.ActiveSelectionIdx = getSelectionIndex(handles);

if nargout == 1
    varargout{1} = handles;
end

guidata(hObject,handles)


function idx = getSelectionIndex(handles)

string = handles.listbox_selections.String;
value  = handles.listbox_selections.Value;
sel    = string(value);

if any(strcmpi(sel,'none'))
    idx = 0;
else
    idx = str2idx(sel);
end

function idx = str2idx(str)
% Convert string entries in listbox to Selection indicies

expression = '^\s*(\d+)\s.*$'; % Extract just the first number
idx = str2double(regexprep(str,expression,'$1'));

function varargout = updateActiveSelection(hObject,handles)

if numel(handles.ActiveSelectionIdx) == 1 && handles.ActiveSelectionIdx > 0
    Lim  = handles.Selections(handles.ActiveSelectionIdx).Lim;
    
    handles.dragLine1.Position = Lim(1);
    handles.dragLine2.Position = Lim(2);
    
    dateFormat =  1; % 'dd-mmm-yyyy', ex. 01-Mar-2000
    timeFormat = 13; % 'HH:MM:SS', ex. 15:45:17
    
    sDate = datestr(Lim(1),dateFormat);
    sTime = datestr(Lim(1),timeFormat);
    startString = sprintf('%s\n%s',sDate,sTime);
    
    eDate = datestr(Lim(2),dateFormat);
    eTime = datestr(Lim(2),timeFormat);
    endString = sprintf('%s\n%s',eDate,eTime);
    
    enable = 'on';
    
    Type = handles.Selections(handles.ActiveSelectionIdx).Type;
    buttonTag = ['radiobutton_',lower(char(Type(1)))];
    button = findobj(handles.uibuttongroup_type,'Tag',buttonTag);
    handles.uibuttongroup_type.SelectedObject = button;
else
    startString = '';
    endString = '';
    
    enable = 'off';
end

handles.text_start.String = startString;
handles.text_end.String   = endString;

handles.text_startLabel.Enable = enable;
handles.text_endLabel.Enable   = enable;

handles.dragLine1.Visible = enable;
handles.dragLine2.Visible = enable;

% Buttons
handles.pushbutton_pickstart.Enable  = enable;
handles.pushbutton_plusstart.Enable  = enable;
handles.pushbutton_minusstart.Enable = enable;

handles.pushbutton_pickend.Enable  = enable;
handles.pushbutton_plusend.Enable  = enable;
handles.pushbutton_minusend.Enable = enable;

if nargout == 1
    varargout{1} = handles;
end

guidata(hObject,handles);


function StopDragFcn(hObject,eventdata,handles)

if numel(handles.ActiveSelectionIdx) == 1 && handles.ActiveSelectionIdx >0
    handles.dragLine1.Position = Snap(handles.dragLine1.Position,handles);
    handles.dragLine2.Position = Snap(handles.dragLine2.Position,handles);
    
    Lim = sort([handles.dragLine1.Position,handles.dragLine2.Position]);
    handles.Selections(handles.ActiveSelectionIdx).Lim = Lim;
    handles = markEdit(hObject,handles);
end

handles = updateActiveSelection(hObject,handles);
handles = updateSelectionList(hObject,handles);

guidata(hObject,handles);

function closest = Snap(position,handles)
[~,idx] = min(abs(position - handles.DisplayData.Time));
closest = handles.DisplayData.Time(idx);

function refocusSelection(hObject,handles)

if numel(handles.ActiveSelectionIdx) == 1 && handles.ActiveSelectionIdx > 0
    Lim = handles.Selections(handles.ActiveSelectionIdx).Lim;
    zoomLevel = getXZoom(handles);
    if (Lim(2)-Lim(1)) <= zoomLevel
        value = datenum(Lim(1) + (Lim(2)-Lim(1))/2);
    else
        value = datenum(Lim(1));
    end
    handles.slider_detailposition.Value = value;
    % Position detail window
    handles = reposition_detail_window(handles);
end

guidata(hObject,handles);


% --- Executes when selected object is changed in uibuttongroup_type.
function uibuttongroup_type_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup_type
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch eventdata.NewValue.String
    case 'All Types'
        type = SelectionType.Noncompliance;
    case 'Bed'
        type = SelectionType.Bed;
    case 'Device Error'
        type = SelectionType.Error;
    case 'Noncompliance'
        type = SelectionType.Noncompliance;
    case 'Observation'
        type = SelectionType.Observation;
    case 'Work'
        type = SelectionType.Work;
    otherwise
        error('Selection type not recognized.');
end

handles.Selections(handles.ActiveSelectionIdx).Type = type;
handles = markEdit(hObject,handles);

handles = updateSelectionList(hObject,handles);

guidata(hObject,handles);

function tf = isedited(handles)

tf = handles.EditCount ~= 0;

function handles = markEdit(hObject,handles)

handles.EditCount = handles.EditCount + 1;

% Disable/Enable buttons
checkButtons(handles);

guidata(hObject,handles);