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

% Last Modified by GUIDE v2.5 21-Mar-2017 14:42:09

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

% Create SourceData and initialize to empty value;
handles.SourceData = [];

% Create ActiveDataIdx and initialize to zero
handles.ActiveDataIdx = 0;

% Enable only valid buttons and menus
checkButtons(handles)
checkMenus(handles)

% % Plot draggable lines
% x1 = handles.axes_detail.XLim(1) + 0.15*diff(handles.axes_detail.XLim);
% x2 = handles.axes_detail.XLim(2) - 0.15*diff(handles.axes_detail.XLim);
% handles.h_b_line = DraggableLine(handles.axes_detail, x1, 2, 'blue');
% handles.h_r_line = DraggableLine(handles.axes_detail, x2, 2, 'red');


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DaysimeterDataSelector wait for user response (see UIRESUME)
% uiwait(handles.figure1);


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
 

%% Menus

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


%%
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


% --- Executes on button press in pushbutton_removeselection.
function pushbutton_removeselection_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_removeselection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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


% --- Executes on button press in pushbutton_plusend.
function pushbutton_plusend_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plusend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_pickend.
function pushbutton_pickend_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_pickend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_minusstart.
function pushbutton_minusstart_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_minusstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_plusstart.
function pushbutton_plusstart_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_plusstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_pickstart.
function pushbutton_pickstart_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_pickstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% Change data set
function changeDataSet(hObject,handles,TargetDataIdx)

if TargetDataIdx == handles.ActiveDataIdx
    return
end

% Change the active data index to the target data index
handles.ActiveDataIdx = TargetDataIdx;

% Disable/Enable buttons
checkButtons(handles)

% Disable/Enable menus
checkMenus(handles)

% Plot data
handles = plotData(handles);

% Set title
handles.text_id.String = sprintf('ID: %s',handles.SourceData(handles.ActiveDataIdx).ID);

% Adjust slider settings to data
setSliderLim(handles);
setSliderStep(handles);

% Position detail window
handles = reposition_detail_window(handles);

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
hObj = findobj(handles.figure1,'Tag',varName);

for iObj = 1:numel(hObj)
    hObj(iObj).Visible = visString;
end