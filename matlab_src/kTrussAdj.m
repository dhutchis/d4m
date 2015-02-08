function A = kTrussAdj(A,k)
% Compute k-Truss subgraph of Undirected Incidence Assoc E.
if k < 3 || isempty(A)  % short-circuit trivial cases; every graph is a 2-truss.
    return
end
A = Abs0(A+A.'); % Make unweighted, undirected.
% todo: what is a triangle for a self-edge?

A2 = A*A;
% Compute edges that violate k-Truss: are part of < k-2 triangles
%   Case 1: Edge is part of 0 triangles = edges in A2 but not A.
%   Case 2: Edge is part of 0<numTriangles<k-2 = <k-2 2-step paths to a neighbor
%noTri = logical(A)-(logical(A2) & logical(A));  % PROFILING: expensive: '&', '-' 
noTri = EntriesMinusNot(A,A2);
fewTri= logical(A2 < k-2) & logical(A);         % PROFILING: expensive: '&', '<' 
R = noTri + fewTri;     % Part of Adjacency Assoc that violates kTruss.
%        ^^^ PROFILING: + is faster than |
while ~isempty(R)       % While there are edges violating kTruss,
    % math: (A-R)^2 = A*A - R*A - A*R + R*R
    % A and R are symmetric, so A*R = (R*A).';  R*R = (A*R) & (R*A)
    % Could also just recompute A2 = A*A;
    
    %RA = R*A;
    %A2 = A2 - RA - RA.' + (RA & RA.');  % Update A^2.
    %PROFILING: Recomputing "A2 = A*A" is faster than the above: removing the part of A2 that is taken away. 
    
    A = A - R;                          % Update A.
    %   ^^^^^ PROFILING: "A-R" is faster than "double(logical(A2 >= k-2) & logical(A))"
    
    A2 = A*A;
    
    %noTri = logical(A)-(logical(A2) & logical(A));
    noTri = EntriesMinusNot(A,A2);
    fewTri= logical(A2 < k-2) & logical(A);
    R = noTri + fewTri;                 % Update R.
end

end

function Aminus = EntriesMinusNot(A1,A2)
% Get entries in A1 that are zero (not present) in A2.
% ~6x faster than logical(A1)-(logical(A2) & logical(A1))
[r1,c1,v1] = find(A1);
r1 = Str2mat(r1); c1 = Str2mat(c1);
[r2,c2,~] = find(A2);
r2 = Str2mat(r2); c2 = Str2mat(c2);
tmp = ~ismember([r1,c1],[r2,c2],'rows');
Aminus = Assoc(Mat2str(r1(tmp,:)), Mat2str(c1(tmp,:)), v1(tmp));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% D4M: Dynamic Distributed Dimensional Data Model
% Architect: Dr. Jeremy Kepner (kepner@ll.mit.edu)
% Software Engineer: Dr. Jeremy Kepner (kepner@ll.mit.edu)
% MIT Lincoln Laboratory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (c) <2010> Massachusetts Institute of Technology
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%