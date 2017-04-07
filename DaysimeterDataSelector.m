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

% Last Modified by GUIDE v2.5 07-Apr-2017 13:45:24

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

% Enable dependencies
if ~isdeployed
    [GitHubDir,~,~] = fileparts(pwd);
    addpath(fullfile(GitHubDir,'d12pack'));
end

% Create SourceData and initialize to empty value
handles.SourceData = [];

% Create Selections and initialize to empty value
handles.Selections = Selection.empty;

% Create ActiveDataIdx and initialize to zero
handles.ActiveDataIdx = 0;

% Create EditCount and initialize to zero
handles.EditCount = 0;

% Contrsuct filter options
handles = makeFilterOptions(hObject, handles);

% Validate controls
handles = validateControls(hObject, handles);

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
function forward_Callback(hObject, ~, handles)
% hObject    handle to forward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

forward(hObject, handles)

% --------------------------------------------------------------------
function back_Callback(hObject, eventdata, handles)
% hObject    handle to back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

backward(hObject, handles)

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

if isfield(handles,'LastDir') && ~isempty(handles.LastDir)
    filterSpec = fullfile(handles.LastDir,'*.mat');
else
    filterSpec = '*.mat';
end

[FileName,PathName] = uigetfile(filterSpec,'Select the MATLAB data file');

if FileName ~= 0
    handles.SourcePath = fullfile(PathName,FileName);
    handles.LastDir = PathName;
    s = load(handles.SourcePath);
    handles.SourceData = findDaysimeterData(s);
    handles.ActiveDataIdx = 0;
    changeDataSet(hObject,handles,1);
end

% --------------------------------------------------------------------
function import_Callback(hObject, eventdata, handles)
% hObject    handle to import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'LastDir') && ~isempty(handles.LastDir)
    DefaultName = handles.LastDir;
else
    DefaultName = '';
end
FilterSpec = {'*.txt;*.cdf','raw (*.txt) & CDF-files (*cdf)'};
[FileName,PathName] = uigetfile(FilterSpec,'Select files to import',DefaultName,'MultiSelect','on');

if iscell(FileName) || FileName ~= 0
    handles.SourcePath = '';
    handles.LastDir = PathName;
    filePaths = fullfile(PathName, FileName);
    importData(hObject, handles, filePaths)
end


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

backward(hObject, handles)

% --- Executes on button press in pushbutton_forward.
function pushbutton_forward_Callback(hObject, ~, handles)
% hObject    handle to pushbutton_forward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

forward(hObject, handles)

% --- Executes on button press in pushbutton_revertchanges.
function pushbutton_revertchanges_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_revertchanges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
qStr = 'Are you sure you want to revert unsaved changes to previous state?';
qTitle = 'Revert Changes?';
button = questdlg(qStr,qTitle,'Yes','Cancel','Cancel');

if strcmpi(button,'Yes') % Only revert if response is Yes
    revertChanges(hObject, handles);
end

% --- Executes on button press in pushbutton_savechanges.
function pushbutton_savechanges_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_savechanges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

saveChanges(hObject, handles);

% --- Executes on selection change in listbox_selections.
function listbox_selections_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_selections (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_selections contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_selections

handles.ActiveSelectionIdx = getSelectionIndex(handles);

handles = updateActiveSelection(hObject,handles);

handles = validateControls(hObject, handles);

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
handles = validateControls(hObject, handles);
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
button = questdlg(qStr,qTitle,'Yes','Cancel','Cancel');

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

% --- Executes on button press in pushbutton_centerend.
function pushbutton_centerend_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_centerend (see GCBO)
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

% --- Executes on button press in pushbutton_centerstart.
function pushbutton_centerstart_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_centerstart (see GCBO)
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


% --- Executes during object creation, after setting all properties.
function axes_detail_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_detail (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_detail

% Make dual axis
yyaxis(hObject,'left')

% Format left axis
hObject.YColor = [0.15 0.15 0.15];
n = numel(hObject.YTick);
ylabel(hObject,'Activity Index (AI) & Circadian Stimulus (CS)')

% Add listener to YLim
addlistener(hObject, 'YLim', 'PostSet', @(src,eventdata)detailYLimCallback(eventdata.AffectedObject,eventdata,guidata(eventdata.AffectedObject)));

% Format right axis
yyaxis(hObject,'right')
hObject.YScale = 'log';
hObject.YColor = [0.15 0.15 0.15];
hObject.YLim = [0.1, 10^5];
expoInc = (log10(hObject.YLim(2)) - log10(hObject.YLim(1)))/(n-1);
expo = log10(hObject.YLim(1)):expoInc:log10(hObject.YLim(2));
hObject.YTick = 10.^(expo);
yTickLabels = "10^{" + regexprep(string(num2str(expo')),'\s*','') + "}";
yTickLabels(1) = "(0)";
hObject.YTickLabel = yTickLabels;
ylabel(hObject,'Circadian Light (CL_A) & Photopic Illuminance (Lux)')

% --- Executes during object creation, after setting all properties.
function axes_overview_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_overview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_overview

% Make dual axis
yyaxis(hObject,'right')
hObject.YScale = 'log';
hObject.YColor = [0.15 0.15 0.15];
hObject.YTick = [];


% Add listener to YLim
addlistener(hObject, 'YLim', 'PostSet', @(src,eventdata)overviewYLimCallback(eventdata.AffectedObject,eventdata,guidata(eventdata.AffectedObject)));


function setDataVisibility(handles,varName,visState)

if visState
    visString = 'on';
else
    visString = 'off';
end

% Search for object with matching tag
hObj = findobj(handles.figure1,'Tag',varName);

for iObj = 1:numel(hObj)
    hObj(iObj).Visible = visString;
end

function StopDragFcn(hObject,eventdata,handles)

if numel(handles.ActiveSelectionIdx) == 1 && handles.ActiveSelectionIdx >0
    handles.dragLine1.Position = Snap(handles.dragLine1.Position,handles);
    handles.dragLine2.Position = Snap(handles.dragLine2.Position,handles);
    
    Lim = sort([handles.dragLine1.Position,handles.dragLine2.Position]);
    if any(Lim ~= handles.Selections(handles.ActiveSelectionIdx).Lim)
        handles.Selections(handles.ActiveSelectionIdx).Lim = Lim;
        handles = markEdit(hObject,handles);
    end
end

handles = updateActiveSelection(hObject,handles);
handles = updateSelectionList(hObject,handles);

guidata(hObject,handles);

function closest = Snap(position,handles)
[~,idx] = min(abs(position - handles.DisplayData.Time));
closest = handles.DisplayData.Time(idx);


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


function handles = markEdit(hObject,handles)

handles.EditCount = handles.EditCount + 1;

% Validate controls
handles = validateControls(hObject, handles);

% Update selection display
handles = plotSelections(handles);

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function axes10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes10
hold(hObject,'on');
hObject.Color  = 'none';
hObject.XColor = 'none';
hObject.YColor = 'none';
% AI
plot(hObject,[-2,0,2],[5,5,5],'-o','Color',[0 0 0])
% CS
plot(hObject,[-2,0,2],[4,4,4],'-o','Color',[0.651 0.808 0.890])
% CLA
plot(hObject,[-2,0,2],[2,2,2],'-o','Color',[0.698 0.875 0.541])
% Illuminance
plot(hObject,[-2,0,2],[1,1,1],'-o','Color',[0.992 0.749 0.435])


% --- Executes on button press in checkbox_Bed.
function checkbox_Bed_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Bed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Bed

handles.checkbox_None.Value = false;
setDataVisibility(handles,'Bed',hObject.Value)

% --- Executes on button press in checkbox_Error.
function checkbox_Error_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Error (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Error

handles.checkbox_None.Value = false;
setDataVisibility(handles,'Error',hObject.Value)

% --- Executes on button press in checkbox_Noncompliance.
function checkbox_Noncompliance_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Noncompliance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Noncompliance

handles.checkbox_None.Value = false;
setDataVisibility(handles,'Noncompliance',hObject.Value)

% --- Executes on button press in checkbox_Observation.
function checkbox_Observation_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Observation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Observation

handles.checkbox_None.Value = false;
setDataVisibility(handles,'Observation',hObject.Value)

% --- Executes on button press in checkbox_Work.
function checkbox_Work_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Work (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Work

handles.checkbox_None.Value = false;
setDataVisibility(handles,'Work',hObject.Value)

% --- Executes on button press in checkbox_None.
function checkbox_None_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_None (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_None

setDataVisibility(handles, 'Bed',           ~hObject.Value)
setDataVisibility(handles, 'Error',         ~hObject.Value)
setDataVisibility(handles, 'Noncompliance', ~hObject.Value)
setDataVisibility(handles, 'Observation',   ~hObject.Value)
setDataVisibility(handles, 'Work',          ~hObject.Value)

handles.checkbox_Bed.Value           = ~hObject.Value;
handles.checkbox_Error.Value         = ~hObject.Value;
handles.checkbox_Noncompliance.Value = ~hObject.Value;
handles.checkbox_Observation.Value   = ~hObject.Value;
handles.checkbox_Work.Value          = ~hObject.Value;

% --------------------------------------------------------------------
function revertchanges_Callback(hObject, eventdata, handles)
% hObject    handle to revertchanges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
qStr = 'Are you sure you want to revert unsaved changes to previous state?';
qTitle = 'Revert Changes?';
button = questdlg(qStr,qTitle,'Yes','Cancel','Cancel');

if strcmpi(button,'Yes') % Only delete data if response is Yes
    revertChanges(hObject, handles);
end


% --------------------------------------------------------------------
function savechanges_Callback(hObject, eventdata, handles)
% hObject    handle to savechanges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

saveChanges(hObject, handles);


% --------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.SourcePath)
    [jObj,handles] = startBusy(handles,'Saving to file...');
    handles = saveChanges(hObject, handles);
    objArray = handles.SourceData;
    save(handles.SourcePath,'objArray');
    stopBusy(handles,jObj,'File saved.')
else
    saveas_Callback(hObject, eventdata, handles)
end


% --------------------------------------------------------------------
function saveas_Callback(hObject, eventdata, handles)
% hObject    handle to saveas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'LastDir') && ~isempty(handles.LastDir)
    filterSpec = fullfile(handles.LastDir,'*.mat');
else
    filterSpec = '*.mat';
end

[FileName,PathName] = uiputfile(filterSpec,'Save Data with Selections As');

if FileName ~= 0
    [jObj,handles] = startBusy(handles,'Saving to file...');
    handles.SourcePath = fullfile(PathName,FileName);
    handles.LastDir = PathName;
    handles = saveChanges(hObject, handles);
    objArray = handles.SourceData;
    save(handles.SourcePath,'objArray');
    stopBusy(handles,jObj,'File saved.')
end


% --- Executes during object creation, after setting all properties.
function axes13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes13

hold(hObject,'on');
hObject.Color  = 'none';
hObject.XColor = 'none';
hObject.YColor = 'none';
% Bed
rectangle(hObject,'Position',[0,8,1,1],'EdgeColor','none','FaceColor',[0.416 0.239 0.604])
% Device Error
rectangle(hObject,'Position',[0,6,1,1],'EdgeColor','none','FaceColor',[0.984 0.604 0.600])
% Noncompliance
rectangle(hObject,'Position',[0,4,1,1],'EdgeColor','none','FaceColor',[1 1 0.600])
% Observation
rectangle(hObject,'Position',[0,2,1,1],'EdgeColor','none','FaceColor',[1 1 1])
% Work
rectangle(hObject,'Position',[0,0,1,1],'EdgeColor','none','FaceColor',[0.200 0.628 0.173])



function edit_id_Callback(hObject, eventdata, handles)
% hObject    handle to edit_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_id as text
%        str2double(get(hObject,'String')) returns contents of edit_id as a double

markEdit(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit_id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function importbedlog_Callback(hObject, eventdata, handles)
% hObject    handle to importbedlog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'LastDir') && ~isempty(handles.LastDir)
    DefaultName = handles.LastDir;
else
    DefaultName = '';
end
FilterSpec = {'*.xlsx;*.xls','Excel-file (*.xlsx,*.xls)'};
[FileName,PathName] = uigetfile(FilterSpec,'Select bed log',DefaultName);

if FileName ~= 0
    handles.LastDir = PathName;
    bedLogPath = fullfile(PathName, FileName);
    handles.SourceData(handles.ActiveDataIdx).BedLog = handles.SourceData(handles.ActiveDataIdx).BedLog.import(bedLogPath);
    TargetDataIdx = handles.ActiveDataIdx;
    handles = markEdit(hObject,handles);
    handles.ActiveDataIdx = 0;
    changeDataSet(hObject, handles, TargetDataIdx);
end


% --------------------------------------------------------------------
function importworklog_Callback(hObject, eventdata, handles)
% hObject    handle to importworklog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'LastDir') && ~isempty(handles.LastDir)
    DefaultName = handles.LastDir;
else
    DefaultName = '';
end
FilterSpec = {'*.xlsx;*.xls','Excel-file (*.xlsx,*.xls)'};
[FileName,PathName] = uigetfile(FilterSpec,'Select work log',DefaultName);

if FileName ~= 0
    handles.LastDir = PathName;
    workLogPath = fullfile(PathName, FileName);
    handles.SourceData(handles.ActiveDataIdx).WorkLog = handles.SourceData(handles.ActiveDataIdx).WorkLog.import(workLogPath);
    TargetDataIdx = handles.ActiveDataIdx;
    handles = markEdit(hObject,handles);
    handles.ActiveDataIdx = 0;
    changeDataSet(hObject, handles, TargetDataIdx);
end


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
