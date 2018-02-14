function trackNos = FindInTable(table,xtar,ytar,ztar, radius)
    xOptions = abs(table(:,1) - xtar) < radius;
    yOptions = abs(table(:,2) - ytar) < radius;
    zOptions = abs(table(:,3) - ztar) < radius;
    validPoints = xOptions & yOptions & zOptions;
    trackNos = unique(table(validPoints,13));
end
