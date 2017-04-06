function varargout = importData(hObject, handles, filePaths)
%IMPORTDATA Summary of this function goes here
%   Detailed explanation goes here
opts = {'HumanData';'MobileData';'StaticData';'DaysimeterData'};
str = 'Select a data class';
dataClass = choosedialog(opts,str);
% Short circuit if there is no selection made
if isempty(dataClass)
    if nargout == 1
        varargout = {handles};
    end
    return
end

% Check if there is already data open
if isfield(handles,'SourceData') && ~isempty(handles.SourceData)
    qstring = {'Would you like to replace or append the open data?'; ...
        'Creating a new file will cause any unsvaed changes to be lost.'};
    button = questdlg(qstring,'Import Options','Replace','Append','Cancel','Replace');
    
    switch button
        case {'Cancel',''}
            % Short circuit if there is no selection made
            if nargout == 1
                varargout = {handles};
            end
            return
    end
else
    button = 'Replace';
end

% Ask for time zones
tzLaunch = timezoneDlg('Select time zone Daysimeters were LAUNCHED in.');
tzDeploy = timezoneDlg('Select time zone Daysimeters were DEPLOYED to');

[jObj,handles] = startBusy(handles,'importing...');

% Seperate files by type
fileTag = regexprep(filePaths,'.*(DATA\.txt|LOG\.txt|\.cdf)$','$1','ignorecase');

dataIdx = strcmpi(fileTag,'DATA.txt');
logIdx  = strcmpi(fileTag,'LOG.txt');
cdfIdx  = strcmpi(fileTag,'.cdf');

dataPaths = filePaths(dataIdx);
logPaths  = filePaths(logIdx);
cdfPaths  = filePaths(cdfIdx);

nData = numel(dataPaths);
SourceData(nData,1) = d12pack.(dataClass);
if exist(SourceData(nData).CalibrationPath,'file') == 2
    calPath = SourceData(nData).CalibrationPath;
else
    calPath = which('calibration_log.csv');
end

for iData = 1:nData
    thisDataPath = dataPaths{iData};
    thisLogPath = regexprep(thisDataPath,'-DATA\.txt','-LOG.txt','ignorecase');
    thisCdfPath = regexprep(thisDataPath,'-DATA\.txt','.cdf','ignorecase');
    
    if ismember(thisCdfPath,cdfPaths)
        cdfData = readcdf(thisCdfPath);
        thisID  = cdfData.GlobalAttributes.subjectID;
    else
        thisID  = 'unknown';
    end
    
    if ismember(thisLogPath,logPaths)
        
        SourceData(iData).CalibrationPath = calPath;
        SourceData(iData).RatioMethod     = 'normal';
        SourceData(iData).TimeZoneLaunch  = tzLaunch;
        SourceData(iData).TimeZoneDeploy  = tzDeploy;
        
        % Import the original data
        SourceData(iData).log_info = SourceData(iData).readloginfo(thisLogPath);
        SourceData(iData).data_log = SourceData(iData).readdatalog(thisDataPath);
        
        % Add ID
        SourceData(iData).ID = thisID;
    end
end

% Remove empty data sets
idxEmpty = cellfun(@isempty,{SourceData.SerialNumber}');
SourceData(idxEmpty) = [];

switch button
    case 'Replace'
        handles.SourceData = SourceData;
        handles.ActiveDataIdx = 0;
        handles = changeDataSet(hObject,handles,1);
    case 'Append'
        n = numel(handles.SourceData);
        handles.SourceData = vartcat(handles.SourceData,SourceData);
        handles.ActiveDataIdx = 0;
        handles = changeDataSet(hObject,handles,n+1);
    case {'Cancel',''}
        % Short circuit if there is no selection made
        if nargout == 1
            varargout = {handles};
        end
        return
end

%
guidata(hObject, handles)

if nargout == 1
    varargout = {handles};
end

%
stopBusy(handles,jObj,'done');

end


function choice = choosedialog(opts,str)

d = dialog('Name','Select One');
d.Position = [d.Position(1) d.Position(2) 250 150];

txt = uicontrol('Parent',d,...
    'Style','text',...
    'Position',[20 80 210 40],...
    'String',str);

popup = uicontrol('Parent',d,...
    'Style','popup',...
    'Position',[75 70 100 25],...
    'String',opts,...
    'Callback',@popup_callback);

btn = uicontrol('Parent',d,...
    'Position',[89 20 70 25],...
    'String','OK',...
    'Callback','delete(gcf)');

choice = opts{1}; % Default choice if window is closed

% Wait for d to close before running to completion
uiwait(d);

    function popup_callback(popup,event)
        idx = popup.Value;
        popup_items = popup.String;
        choice = char(popup_items(idx,:));
    end
end


function Data = readcdf(filePath)
%READCDF Summary of this function goes here
%   Detailed explanation goes here

Data = struct('Variables',[],'GlobalAttributes',[],'VariableAttributes',[]);

cdfId = cdflib.open(filePath);

fileInfo = cdflib.inquire(cdfId);

% Read in variables
nVars = fileInfo.numVars;

for iVar = 0:nVars-1
    varInfo = cdflib.inquireVar(cdfId,iVar);
    
    % Determine the number of records allocated for the first variable in the file.
    maxRecNum = cdflib.getVarMaxWrittenRecNum(cdfId,iVar);
    
    % Retrieve all data in records for variable.
    if maxRecNum > 0
        varData = cdflib.hyperGetVarData(cdfId,iVar,[0 maxRecNum+1 1]);
    else
        varData = cdflib.getVarData(cdfId,iVar,0);
    end
    
    Data.Variables.(varInfo.name) = varData;
end

% Read in attributes
nAttrs = fileInfo.numvAttrs + fileInfo.numgAttrs;

for iAttr = 0:nAttrs-1
    attrInfo = cdflib.inquireAttr(cdfId,iAttr);
    switch attrInfo.scope
        case 'GLOBAL_SCOPE'
            nEntry = cdflib.getAttrMaxgEntry(cdfId,iAttr) + 1;
            if nEntry == 1
                attrData = cdflib.getAttrgEntry(cdfId,iAttr,0);
                Data.GlobalAttributes.(attrInfo.name) = attrData;
            else
                Data.GlobalAttributes.(attrInfo.name) = cell(nEntry,1);
                for iEntry = 0:nEntry-1
                    attrData = cdflib.getAttrgEntry(cdfId,iAttr,iEntry);
                    Data.GlobalAttributes.(attrInfo.name){iEntry+1,1} = attrData;
                end
            end
        case 'VARIABLE_SCOPE'
            nEntry = cdflib.getAttrMaxEntry(cdfId,iAttr) + 1;
            for iEntry = 0:nEntry-1
                varName = cdflib.getVarName(cdfId,iEntry);
                attrData = cdflib.getAttrEntry(cdfId,iAttr,iEntry);
                Data.VariableAttributes.(varName).(attrInfo.name) = attrData;
            end
        otherwise
            error('Unknown attribute scope.');
    end
end

% Clean up
cdflib.close(cdfId)

clear cdfId
end

