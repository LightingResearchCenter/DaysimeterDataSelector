function d12packObj = selections2d12pack(Selections, d12packObj)
%SELECTIONS2D12PACK Summary of this function goes here
%   Detailed explanation goes here

% Short circuit if there are no selections
if isempty(Selections)
    return
end

% Check which selection types are supported by the d12pack object
isBed           = isprop(d12packObj, 'BedLog');
isError         = isprop(d12packObj, 'Error');
isNoncompliance = isprop(d12packObj, 'Compliance');
isObservation   = isprop(d12packObj, 'Observation');
isWork          = isprop(d12packObj, 'WorkLog');

% Filter selections based on type
selectionTypes   = vertcat(handles.Selections.Type);
idxBed           = selectionTypes == SelectionType.Bed;
idxError         = selectionTypes == SelectionType.Error;
idxNoncompliance = selectionTypes == SelectionType.Noncompliance;
idxObservation   = selectionTypes == SelectionType.Observation;
idxWork          = selectionTypes == SelectionType.Work;

% Convert bed selections
if isBed && any(idxBed)
    bedSelections = Selections(idxBed);
    bedLim = vertcat(bedSelections.Lim);
    d12packObj.BedLog = d12pack.BedLogData(bedLim(:,1),bedLim(:,2));
end

% Convert error selections
if isError && any(idxError)
    errorSelections = Selections(idxError);
    idx = false(size(d12packObj.Time));
    for iSel = 1:numel(errorSelections)
        idxSel = errorSelections(iSel).Selection2Index(d12packObj.Time);
        idx = idxSel | idx;
    end
    d12packObj.Error = idx;
end

% Convert noncopmliance selections
if isNoncompliance && any(idxNoncompliance)
    noncomplianceSelections = Selections(idxNoncompliance);
    idx = true(size(d12packObj.Time));
    for iSel = 1:numel(noncomplianceSelections)
        idxSel = ~noncomplianceSelections(iSel).Selection2Index(d12packObj.Time);
        idx = idxSel | idx;
    end
    d12packObj.Compliance = idx;
end

% Convert obaservation selection (there should only be one)
if isObservation && any(idxObservation)
    observationSelections = Selections(idxObservation);
    idx = observationSelections(1).Selection2Index(d12packObj.Time);
    d12packObj.Observation = idx;
end

% Convert work selections
if isWork && any(idxWork)
    workSelections = Selections(idxWork);
    workLim = vertcat(workSelections.Lim);
    d12packObj.WorkLog = d12pack.WorkLogData(workLim(:,1),workLim(:,2));
end


end

