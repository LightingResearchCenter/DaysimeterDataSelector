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
selectionTypes   = vertcat(Selections.Type);
idxBed           = selectionTypes == SelectionType.Bed;
idxError         = selectionTypes == SelectionType.Error;
idxNoncompliance = selectionTypes == SelectionType.Noncompliance;
idxObservation   = selectionTypes == SelectionType.Observation;
idxWork          = selectionTypes == SelectionType.Work;

% Convert bed selections
if isBed
    if any(idxBed)
        bedSelections = Selections(idxBed);
        bedLim = vertcat(bedSelections.Lim);
        d12packObj.BedLog = d12pack.BedLogData(bedLim(:,1),bedLim(:,2));
    else
        d12packObj.BedLog = d12pack.BedLogData.empty;
    end
end

% Convert error selections
if isError
    if any(idxError)
        errorSelections = Selections(idxError);
        d12packObj.Error = errorSelections.Selection2Index(d12packObj.Time);
    else
        d12packObj.Error = false(size(d12packObj.Time));
    end
end

% Convert noncopmliance selections
if isNoncompliance
    if any(idxNoncompliance)
        noncomplianceSelections = Selections(idxNoncompliance);
        d12packObj.Compliance = ~noncomplianceSelections.Selection2Index(d12packObj.Time);
    else
        d12packObj.Compliance = true(size(d12packObj.Time));
    end
end

% Convert obaservation selection
if isObservation
    if any(idxObservation)
        observationSelections = Selections(idxObservation);
        d12packObj.Observation = observationSelections.Selection2Index(d12packObj.Time);
    else
        d12packObj.Observation = false(size(d12packObj.Time));
    end
end

% Convert work selections
if isWork
    if any(idxWork)
        workSelections = Selections(idxWork);
        workLim = vertcat(workSelections.Lim);
        workstations = vertcat(workSelections.Meta);
        d12packObj.WorkLog = d12pack.WorkLogData(workLim(:,1),workLim(:,2),false,workstations);
    else
        d12packObj.WorkLog = d12pack.WorkLogData.empty;
    end
end

end

