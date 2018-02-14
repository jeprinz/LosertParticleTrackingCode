function trackNos = FindInTableSph(table,xtar,ytar,ztar, radius)
    xDist = table(:,1) - xtar;
    yDist = table(:,2) - ytar;
    zDist = table(:,3) - ztar;
    validPoints = xDist .^ 2 + yDist .^ 2 + zDist .^ 2 < radius .^ 2;
    trackNos = unique(table(validPoints,13));
end
