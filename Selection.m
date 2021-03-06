classdef Selection
    %SELECTION Summary of this class goes here
    %   Detailed explanation goes here
    
    %% Properties public
    properties % (Access = public)
        Lim  datetime = NaT(1,2,'TimeZone','local')
        Type SelectionType = SelectionType.Null
        Meta cell = {''} % Meta data, location for work log
    end
    
    %% Methods public
    methods % (Access = public)
        function obj = Selection(varargin)
            % Class constructor method
            if nargin > 0
                if islogical(varargin{1}) % If input is logical index and datetime arrays
                    p = inputParser;
                    isValidType = @(x) ischar(x) | isa(x,'SelectionType');
                    
                    addRequired(p,'Idx',@islogical);
                    addRequired(p,'datetimeArray',@isdatetime)
                    addOptional(p,'Type',SelectionType.Noncompliance,isValidType);
                    
                    parse(p,varargin{:});
                    idx = p.Results.Idx;
                    datetimeArray = p.Results.datetimeArray;
                    if ischar(p.Results.Type)
                        expectedTypes = {'Bed','Error','Noncompliance','Observation'};
                        TypeChar = validatestring(p.Results.Type,expectedTypes);
                        Type  = SelectionType(TypeChar);
                    else % isa(p.Results.Type,'SelectionType')
                        Type  = p.Results.Type;
                    end % end of ischarp.Results.Type)
                    
                    obj = Selection.Index2Selection(idx,datetimeArray,Type);
                else % If input is limits of selection
                    p = inputParser;
                    isValidLim  = @(x) isdatetime(x) & numel(x) == 2;
                    isValidType = @(x) ischar(x) | isa(x,'SelectionType');
                    
                    addRequired(p,'Lim',isValidLim);
                    addOptional(p,'Type',SelectionType.Noncompliance,isValidType);
                    addOptional(p,'Meta',{});
                    
                    parse(p,varargin{:});
                    
                    obj.Lim = sort(p.Results.Lim);
                    if ~isempty(p.Results.Meta)
                        obj.Meta = p.Results.Meta;
                    end
                    
                    if ischar(p.Results.Type)
                        expectedTypes = {'Bed','Error','Noncompliance','Observation','Work'};
                        TypeChar = validatestring(p.Results.Type,expectedTypes);
                        obj.Type  = SelectionType(TypeChar);
                    else % isa(p.Results.Type,'SelectionType')
                        obj.Type  = p.Results.Type;
                    end % end of ischar(p.Results.Type)
                end % end of if islogical(varargin{1})
            end % end of if nargin > 0
        end % end of class constructor method
        
        function idx = Selection2Index(obj,datetimeArray)
            % Convert to logical array for a given array of datetimes
            idx = false(size(datetimeArray));
            for iObj = 1:numel(obj) % loop through if there are multiple selections
                idx = idx | (datetimeArray >= obj(iObj).Lim(1) & datetimeArray <= obj(iObj).Lim(2));
            end % end of for
        end % end of Selection2Index method
        
        
        function T = table(obj)
            % Convert to table, overload table function
            Lim  = vertcat(obj.Lim);
            Type = vertcat(obj.Type);
            T = table(Lim,Type);
        end % end of table method
        
        function str = string(obj)
            lim    = vertcat(obj.Lim);
            type   = vertcat(obj.Type);
            idxStr = string(num2str((1:numel(obj))'));
            
            % remove NaT
            idxNaT = isnat(lim);
            idxNaT = idxNaT(:,1) | idxNaT(:,2);
            lim(idxNaT,:) = [];
            type(idxNaT) = [];
            idxStr(idxNaT) = [];
            
            lim1Str = string(datestr(lim(:,1),'mm/dd/yy HH:MM'));
            lim2Str = string(datestr(lim(:,2),'mm/dd/yy HH:MM'));
            typeStr = string(type);
            
            str = idxStr + "   " + lim1Str + " - " + lim2Str + "   " + typeStr;
        end
    end % end of public methods
    
    %% Methods static
    methods (Static)
        function obj = Index2Selection(idx,datetimeArray,Type)
            obj = Selection.empty;
            
            % Class constructor from logical array and datetime array
            startIdx = diff([false;idx]) == 1;
            stopIdx  = diff([idx;false]) == -1;
            
            startDT = datetimeArray(startIdx);
            stopDT  = datetimeArray(stopIdx);
            
            for iObj = numel(startDT):-1:1
                thisLim = [startDT(iObj),stopDT(iObj)];
                obj(iObj,1) = Selection(thisLim,Type);
            end % end of for
        end % end of Index2Selection method
    end % end of static methods
end % end of class definition

