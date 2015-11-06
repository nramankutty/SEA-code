function [ts] = getFao(EWD,WRM,PAY)

%Gathers fao data from matrix with years 1961-2010 as columns, countries
%1-177 as rows, corresponding to disasters in list given by EWD with column 1 = years, col 2 = country numbers
%normalizes data to 6 year averages, and aligns in -3:3 time, returns normalized composite time series
%
%   input params : (disaster type string('D','F','CW','HW'), wheat/rice/maize/allcereals ('W','R','M',''), production/yield/area ('P','Y','A'))  
%   output : normalized composite 7-yr time series

    emfile = [EWD '.xlsx'];    %build disaster filename from input strings
    em = xlsread(emfile);           %read disaster list
    faofile = [WRM PAY 'mat.xlsx'];     %build fao filename from input strings 
    fao =  xlsread(faofile);            %read fao file
    year=0;
   
    em(em(:,1) - 3 < 1961, :) = [];      %clear disasters that are too early or late to have complete FAO data
    em(em(:,1) + 3 > 2010, :) = [];

    results = zeros(length(em),9);      %initialize results matrix for speed

    for i = 1:length(em)
        
        country = em(i,2);          %pull country number from emdat list
        year = em(i,1) - 1960;      %pull year from emdat list and change to matrix row (year) number
        results(i,1) = country;     %assign country id to results
        results(i,2) = em(i,1);     %assign year to results    

        avg = (fao(country,year-3)+fao(country,year-2)+fao(country,year-1)+fao(country,year+1)+fao(country,year+2)+fao(country,year+3))/6;  %calculate 6 year avg
        results(i,3) = fao(country,year-3)/avg;     %normalize data values for years -3:3 and assign to results
        results(i,4) = fao(country,year-2)/avg;
        results(i,5) = fao(country,year-1)/avg;
        results(i,6) = fao(country,year)/avg;
        results(i,7) = fao(country,year+1)/avg;
        results(i,8) = fao(country,year+2)/avg;
        results(i,9) = fao(country,year+3)/avg;

    end  %end for

    results(any(results==0,2),:)=[];            %clear rows with missing data
    results(any(isnan(results),2),:)=[];
    ts = mean(results(:,3:9));                  %compute composite time series
    
    outputfile = ['/By Crop/' EWD WRM PAY '.xlsx'];   %set output filename string
    xlswrite(outputfile, results);          %output xls of results
    
    return
    
end %end function
