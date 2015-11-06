function [exvect] = exVect(country, year, dis, con_dis_bool)
% Produces vector used to clear co-occurring disasters from one repetition
% of control resampling

if con_dis_bool 
    
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
    
end

%ts = mean(em(:,3:9));

yrs = zeros(1,8);
yrs(1,1) = country;
yrs(1,2) = year-3+1960;
yrs(1,3) = year-2+1960;
yrs(1,4) = year-1+1960;
yrs(1,5) = year+1960;
yrs(1,6) = year+1+1960;
yrs(1,7) = year+2+1960;
yrs(1,8) = year+3+1960;

exvect = zeros(1,7);

for k = 1:7         %move through 7-year window

    for j = 1:size(dis,1)    %for disaster i, year k, search for co-occurring disasters

        if dis(j,1) == yrs(1,1) && dis(j,2) == yrs(1,k+1)  %if co-occurring disaster: country and year same as disaster i

            %if k == 4 && dis(j,3) == disid   %if matching disaster is disaster i (i.e., if k = 4 and disaster id numbers match)

                     % do nothing to data

            %else

               exvect(1,k) = 1;     %set disaster value to NaN

            %end

        end

    end

end



return

end

