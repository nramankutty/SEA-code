function [ts,results] = wComp(VAR, EWD) 
%Compositing procedure for weather data

%load complete results record and weather data
emfile = ['C:\Users\Corey\Desktop\sea final\r2c1\geog_data\' EWD 'Pexcl.xlsx'];
loader = load(['C:\Users\Corey\Desktop\sea final\r2c1\' VAR '\' VAR '_mat']);
eval(['wdat = loader.' VAR '_mat;'])
em = xlsread(emfile);

%normalize and compile weather

results = NaN(length(em),9); 
for i = 1:length(em)
    
    c = em(i,1);
    y = em(i,2)-1960;
    wavg = (mean(wdat(c,y-3:y-1)) + mean(wdat(c,y+1:y+3)))/2;
    
    results(i,1) = c;
    results(i,2) = y;
    results(i,3) = wdat(c,y-3)/wavg;
    results(i,4) = wdat(c,y-2)/wavg;
    results(i,5) = wdat(c,y-1)/wavg;
    results(i,6) = wdat(c,y)/wavg;
    results(i,7) = wdat(c,y+1)/wavg;
    results(i,8) = wdat(c,y+2)/wavg;
    results(i,9) = wdat(c,y+3)/wavg;
    
end

for i = 1:length(results)
    for j = 1:size(results,2)
        
        if isnan(em(i,j))
            
            results(i,j) = NaN;
            
        end
        
    end
end

ts = nanmean(results(:,3:9));
return

end

