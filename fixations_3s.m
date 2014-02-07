%     EyeMMV toolbox (Eye Movements Metrics & Visualizations): An eye movement post-analysis tool.
%     Copyright (C) 2014 Vassilios Krassanakis (National Technical University of Athens)
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
% 
%     For further information, please email me: krasanakisv@gmail.com or krasvas@mail.ntua.gr 

%applying 3s criterion
%import fixations list after t1 criterion, fixation id
%output:(fixx,fixy,number_t1,number_t2,duration)
%fixx,fixy: coordinates of the center
%number_t1: number of points before t2 criterion
%number_3s:number of points after 3s criterion
function [fixx,fixy,number_t1,number_3s,start_time,end_time,duration]=fixations_3s(fixations,fixation_id) %fixations after t1 criterion
n=size(fixations);
n=n(1,1); %number of all points
fixations_id=zeros(1,4);

for i=1:n
    if fixations(i,4)==fixation_id
        fixations_id=[fixations_id;fixations(i,:)];
    end
end

n=size(fixations_id);
n=n(1,1);
fixations_id=fixations_id(2:n,:); %list of data points with the defined id

%clustering according to criterion t2
number_t1=size(fixations_id);
x=fixations_id(:,1);
y=fixations_id(:,2);
t=fixations_id(:,3);
number_t1=number_t1(1,1); %number of points before 3s criterion
%initialize mean values of center
fixx=mean(fixations_id(:,1));
fixy=mean(fixations_id(:,2));
%compute standard deviation of cluster
sx=std(x);
sy=std(y);
s=sqrt((sx^2)+(sy^2));
d=0; %distance between cluster point and mean point


for i=1:number_t1
    d=distance2p(x(i),y(i),fixx,fixy);
    if d>(3*s)
        fixations_id(i,4)=0;
    end
end
%initialize new list (data points according to 3s criterion)
fixations_list_3s=zeros(1,4);

for i=1:number_t1
    if fixations_id(i,4)>0
        fixations_list_3s=[fixations_list_3s;fixations_id(i,:)];
    end
end

n=size(fixations_list_3s);
n=n(1,1);
fixations_list_3s=fixations_list_3s(2:n,:);

number_3s=size(fixations_list_3s);
number_3s=number_3s(1,1);
fixx=mean(fixations_list_3s(:,1));
fixy=mean(fixations_list_3s(:,2));
start_time=fixations_list_3s(1,3);
end_time=fixations_list_3s(number_3s,3);
duration=fixations_list_3s(number_3s,3)-fixations_list_3s(1,3);

end

