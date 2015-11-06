function [m,r] = wComp_control(VAR,vect,exbin)
%Resamples weather data using falsified 'disasters' to develop control
%distributions using same process and input variables as getFao functions. Process resamples
%same number of pseudo-disasters as real disasters per type and yields one
%composited control time series. Whole process repeats n times (100 works, you can change this to 1000).
%Output is 100 composited control time series (r) and mean control (m)

%input 'vect' is a vector of length 7 with year-specific sample sizes (which are
%not constant after disExcl) 

%input 'EWD' is not computed in this function and is only for result
%filename saving
dis = xlsread('C:\Users\Corey\Desktop\sea final\r2c1\geog_data\all_dis');   %load all disasters

len = max(vect);
n = 1000;        %number of repetitions

loader = load(['C:\Users\Corey\Desktop\sea final\r2c1\' VAR '\' VAR '_mat']);
eval(['wdat = loader.' VAR '_mat;'])

m = zeros(n,7);       %initialize vector to hold composited control time series
tic
for j = 1:n         %replicates
  
  
  r=[];%  r = zeros(231,7);        %results vector for this replicate

    while min(sum(~isnan(r))) < len        %resample/normalize
        
        y = floor(1964 + 44*rand())-1960;
        country =  floor(1 + 177*rand());   %x(floor(1+length(x)*rand()),1); 
        
        %exclude random disasters that are real disasters
        if exbin
            
            for i = 1:length(dis)
                
                if dis(i,1) == country
                    if dis(i,2) == (y + 1960)
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
                    
        wavg = mean(wdat(country,y-3:y+3)); % + mean(wdat(country,y+1:y+3)))/2;
        if wavg == 0;
            continue
        end
        
        r(size(r,1)+1,1) = wdat(country,y-3)/wavg;
        r(size(r,1),2) = wdat(country,y-2)/wavg;
        r(size(r,1),3) = wdat(country,y-1)/wavg;
        r(size(r,1),4) = wdat(country,y)/wavg;
        r(size(r,1),5) = wdat(country,y+1)/wavg;
        r(size(r,1),6) = wdat(country,y+2)/wavg;
        r(size(r,1),7) = wdat(country,y+3)/wavg;
        
        %r(any(isnan(r),2),:)=[]; 
        
        exvect = exVect(country, y, dis, 0);

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
    
    %m(j,:)=nanmean(r);                 %calculate composited control and stow
    
    %catch infinite weirdness in m
    if any(isinf(m(j,:)))
        return
    end
    
end
toc
%xlswrite(['C:\Users\Corey\Documents\MATLAB\duplicates\By Crop Excl\Controls\' EWD WRM PAY 'excl_controls.xlsx'], m)   %write control set
return

end
