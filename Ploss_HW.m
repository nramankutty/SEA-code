
em = xlsread('HWlist.xlsx');
fao =  xlsread('MPmat.xlsx');

year=0;
r = 0;

em(em(:,1) < 1980, :) = [];      %clear disasters that are too early or late to have complete FAO data
em(em(:,1) + 3 > 2010, :) = [];

for i = 1:length(em)
    
        year=em(i,1)-1960;
        country=em(i,2);
        Bavg=mean(fao(country, year-3:year-1));
        Aavg=mean(fao(country, year+1:year+3));
        avg=(Bavg+Aavg)/2;
        if isnan(avg)
            disp(country)
            disp(em(i,1))
            continue
        end
        r(i) = 0.091*avg;
        
end

r(any(isnan(r),2),:)=[];

HP_total_loss=sum(r) 

xlswrite('Aggregate losses/HWP_Mlosses',r')
