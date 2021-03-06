function T = subsref(DB, s)
%(),subsref: Create DBtable object binding to a specific database table; creates tables if they don't exist.
%Database user function.
%  Usage:
%    T = DB(table)
%    T = DB(table,tableTranspose)
%  Inputs:
%    DB = database object with a binding to a specific database
%    table = name of table in database
%    tableTranspose = name of table transpose in database
% Outputs:
%    T = database table or table pair object

subs = s.subs;

if (numel(subs) == 1)
    table = subs{1};
    % Check if table is in DB.
    if strcmp(DB.type,'BigTableLike') || strcmp(DB.type,'Accumulo')
        if isempty( StrSubsref(ls(DB),[table ' ']) )
            disp(['Creating ' table ' in ' DB.host ' ' DB.type]);
            DBcreate(DB.instanceName,DB.host,table,DB.user,DB.pass,DB.type);  % Create table.
        end
    end
    if strcmp(DB.type,'sqlserver')
        if (strcmp(lower(table(1:7)),'select '))
            disp(['Binding to query.']);
        elseif isempty( strfind(ls(DB),[table ',']) )
            disp([table ' not in ' DB.host ' ' DB.type]);
        end
    end
    if strcmp(DB.type,'scidb')
        [tableName tableSchema] = SplitSciDBstr(table);
        nl = char(10);  tab = char(9);                        % Set constants.
        lsStr = ls(DB);
        Atable = Assoc('','','');
        if (NumStr(lsStr) > 1)
          A = CSVstr2assoc(lsStr,nl,tab);                      % Get table list.
          Atable = A(:,['name' tab]) == [tableName tab];        % Find table matching argument.
        end
    
        if nnz(Atable)
            table = Val(A(Row(Atable),['schema' tab]));        % Get table schema.
            [tableName tableSchema] = SplitSciDBstr(table);
            disp(['Binding to table: ' table]);
        else
            if isempty(tableSchema);
                disp(['Binding to Table - need schema to create SciDB table.']);
            else
                disp(['Creating ' table ' in ' DB.host ' ' DB.type]);
                urlport = DB.host;
                
                %[sessionID,success]=urlread([urlport 'new_session']);
                [stat, sessionID] = system(['wget -q -O - "' urlport 'new_session" --http-user=' ...
                    DB.user ' --http-password=' DB.pass]);
                sessionID = deblank(sessionID);
                
                [stat, queryID] = system(['wget -q -O - "' urlport 'execute_query?id=' sessionID ...
                    '&query=create_array(' tableName ',' tableSchema ')&release=1" --http-user='  ...
                    DB.user ' --http-password=' DB.pass]);
                
                %queryStr = strrep(queryStr,' ','%20');
                %[queryID,success]=urlread(queryStr);
            end
        end
    end
    T = DBtable(DB,table);
end

if (numel(subs) == 2)
    table1 = subs{1};
    % Check if tables is in DB.
    if isempty( StrSubsref(ls(DB),[table1 ' ']) )
        disp(['Creating ' table1 ' in ' DB.host ' ' DB.type]);
        DBcreate(DB.instanceName,DB.host,table1,DB.user,DB.pass, DB.type);  % Create table.
    end
    table2 = subs{2};
    % Check if tables is in DB.
    if isempty( StrSubsref(ls(DB),[table2 ' ']) )
        disp(['Creating ' table2 ' in ' DB.host ' ' DB.type]);
        DBcreate(DB.instanceName,DB.host,table2,DB.user,DB.pass, DB.type);  % Create table.
    end
    T = DBtablePair(DB,table1,table2);
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% D4M: Dynamic Distributed Dimensional Data Model
% Architect: Dr. Jeremy Kepner (kepner@ll.mit.edu)
% Software Engineer: Dr. Jeremy Kepner (kepner@ll.mit.edu), Dr. Vijay
% Gadepally (vijayg@ll.mit.edu)
% MIT Lincoln Laboratory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (c) <2010> Massachusetts Institute of Technology
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
