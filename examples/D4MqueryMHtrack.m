function MHtrack = D4MqueryMHtrack(p)
% Returns multiple hypothesis track for p.
  global D4MqueryGlobal

  % Specify track keys.
  nl = char(13);
  t=['TIME/*' nl];    l=['NE_LOCATION/*' nl];

  MHtrack = Reuters3MHtracks(D4MqueryGlobal.DbA,p,t,l);

end

