function [tsexcl] = disExcl(EWD,WRM,PAY)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
 

dis = xlsread('H:\Disasters\duplicates\all_dis.xlsx');   %load all disasters

em = xlsread(['By crop\MYD\' EWD WRM PAY '.xlsx']);

switch EWD
    
    case 'HW'
        disid = 1;   
    case 'F'
        disid = 2;    
    case 'SYD'
        disid = 3;      
    case 'CW'
        disid = 4;
    
end

ts = mean(em(:,3:9));

yrs = zeros(length(em),8);
yrs(:,1) = em(:,1);
yrs(:,2) = em(:,2)-3;
yrs(:,3) = em(:,2)-2;
yrs(:,4) = em(:,2)-1;
yrs(:,5) = em(:,2);
yrs(:,6) = em(:,2)+1;
yrs(:,7) = em(:,2)+2;
yrs(:,8) = em(:,2)+3;


for i = 1:size(em,1)    %move through disaster list
    
    for k = 1:7         %move through 7-year window
        
        for j = 1:size(dis,1)    %for disaster i, year k, search for co-occurring disasters
            
            if dis(j,1) == yrs(i,1) && dis(j,2) == yrs(i,k+1)  %if co-occurring disaster: country and year same as disaster i
                
                if k == 4 && dis(j,3) == disid   %if matching disaster is disaster i (i.e., if k = 4 and disaster id numbers match)
                    
                         % do nothing to data
                         
                else
                    
                    em(i,k+2)=NaN;     %set disaster value to NaN
                    
                end
                
            end

        end
        
    end

end


xlswrite(['C:\Users\Corey\Documents\MATLAB\duplicates\By Crop Excl\' EWD WRM PAY 'excl.xlsx'], em)   %write processed disaster data
t = [-3:3];          % time var
tsexcl = nanmean(em(:,3:9));   %compositing
plot(t,tsexcl,'b',t,ts,'r')
legend('with exclusion','without exclusion')
title([EWD WRM PAY])

return

end

