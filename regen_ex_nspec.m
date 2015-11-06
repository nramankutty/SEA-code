function [m,r] = regen_ex_nspec(EWD,WRM,PAY,vect,exbin)
%Resamples FAO data using falsified 'disasters' to develop control
%distributions using same process and input variables as getFao functions. Process resamples
%same number of pseudo-disasters as real disasters per type and yields one
%composited control time series. Whole process repeats n times (100 works, you can change this to 1000).
%Output is 100 composited control time series (r) and mean control (m)

%input 'vect' is a vector of length 7 with year-specific sample sizes (which are
%not constant after disExcl) 

%input 'EWD' is not computed in this function and is only for result
%filename saving
dis = xlsread('C:\Users\Corey\Documents\MATLAB\all_dis');   %load all disasters

len = max(vect);
n = 200;        %number of repetitions
%em = xlsread(['C:\Users\Corey\Documents\MATLAB\duplicates\' EWD PAY 'excl.xlsx']);    %read EWD list      
fao = xlsread(['C:\Users\Corey\Documents\MATLAB\' WRM PAY 'mat.xlsx']);    %read fao data
exbool = [];
    
m = zeros(n,7);       %initialize vector to hold composited control time series
tic
for j = 1:n         %replicates
    
  r=[];%  r = zeros(231,7);        %results vector for this replicate

    while min(sum(~isnan(r))) < len        %resample/normalize
        
        year = floor(1964 + 44*rand())-1960;
        country =  floor(1 + 177*rand());   %x(floor(1+length(x)*rand()),1); 
        
        %exclude random disasters that are real disasters
        if exbin
                        
            for i = 1:length(dis)
                
                if dis(i,1) == country
                    if dis(i,2) == (year + 1960)
                        exbool = 1;
                        break
                    end
                end
            end
            
            if exbool
                exbool = 0;
                continue
            end 
            
        end
        %end random dis exclusion
                    
        
        Bavg=mean(fao(country, year-3:year-1));
        Aavg=mean(fao(country, year+1:year+3));
        avg=(Bavg+Aavg)/2;
        
        if avg == 0
            continue
        end
        
        r(size(r,1)+1,1)=fao(country,year-3)/avg;
        r(size(r,1),2)=fao(country,year-2)/avg;
        r(size(r,1),3)=fao(country,year-1)/avg;
        r(size(r,1),4)=fao(country,year)/avg;
        r(size(r,1),5)=fao(country,year+1)/avg;
        r(size(r,1),6)=fao(country,year+2)/avg;
        r(size(r,1),7)=fao(country,year+3)/avg;
        
        %r(any(isnan(r),2),:)=[]; 
        
        exvect = exVect(country, year, dis, 0);

        if ~isempty(find(exvect))
            r(size(r,1),find(exvect)) = NaN;
        end
              
    end 
    
    N = vect;
    
    for c = 1:7    
        
        B = r(~isnan(r(:,c)),c);
        B(N(c)+1:end) = NaN;
        m(j,c) = nanmean(B);
        
    end
    
   % m(j,:)=nanmean(r);                 %calculate composited control and stow
    
end

%xlswrite(['C:\Users\Corey\Documents\MATLAB\duplicates\By Crop Excl\Controls\' EWD WRM PAY 'excl_controls.xlsx'], m)   %write control set
return

end

