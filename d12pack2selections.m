function Selections = d12pack2selections(d12packObj)
%D12PACK2SELECTIONS Summary of this function goes here
%   Detailed explanation goes here

Selections = Selection.empty;

if isprop(d12packObj,'BedLog') && ~isempty(d12packObj.BedLog)
    for iBed = numel(d12packObj.BedLog):-1:1
        Lim = [d12packObj.BedLog(iBed).BedTime,d12packObj.BedLog(iBed).RiseTime];
        sBed(iBed,1) = Selection(Lim,SelectionType.Bed);
    end
    Selections = vertcat(Selections,sBed);
end

if isprop(d12packObj,'Error') && ~isempty(d12packObj.Error)
    sError = Selection(d12packObj.Error,d12packObj.Time,SelectionType.Error);
    Selections = vertcat(Selections,sError);
end


if isprop(d12packObj,'Compliance') && ~isempty(d12packObj.Compliance)
    sNoncompliance = Selection(~d12packObj.Compliance,d12packObj.Time,SelectionType.Noncompliance);
    Selections = vertcat(Selections,sNoncompliance);
end

if isprop(d12packObj,'Observation') && ~isempty(d12packObj.Observation)
    sObservation = Selection(d12packObj.Observation,d12packObj.Time,SelectionType.Observation);
    Selections = vertcat(Selections,sObservation);
end

if isprop(d12packObj,'WorkLog') && ~isempty(d12packObj.WorkLog)
    for iWork = numel(d12packObj.WorkLog):-1:1
        Lim = [d12packObj.WorkLog(iWork).StartTime,d12packObj.WorkLog(iWork).EndTime];
        sWork(iWork,1) = Selection(Lim,SelectionType.Work);
    end
    Selections = vertcat(Selections,sWork);
end

end

