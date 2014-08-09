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

%import fixations list after t1 criterion,fixation id and t2 parameter
%output:(fixx,fixy,number_t1,number_t2,duration,list_out_points)
%fixx,fixy: coordinates of the center
%number_t1: number of points before t2 criterion
%number_t2:number of points after t2 criterion
%list_out_points:points which are not used after t2 criterion
function [fixx,fixy,number_t1,number_t2,start_time,end_time,duration,list_out_points]=fixations_t2(fixations,fixation_id,t2) %fixations after t1 criterion
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
number_t1=number_t1(1,1); %number of points before t2
%initialize mean values of center
fixx=mean(fixations_id(:,1));
fixy=mean(fixations_id(:,2));
d=0; %distance between cluster point and mean point
for i=1:number_t1
    d=distance2p(x(i),y(i),fixx,fixy);
    if d>t2
        fixations_id(i,4)=0;
    end
end


%initialize new list (data points according to t2)
fixations_list_t2=zeros(1,4);

%initialize list of points which are nto used aftere t2 criterion
list_out_points=zeros(1,4);

for i=1:number_t1
    if fixations_id(i,4)>0
        fixations_list_t2=[fixations_list_t2;fixations_id(i,:)];
    else
        list_out_points=[list_out_points;fixations_id(i,:)];
    end
end
n=size(fixations_list_t2);
n=n(1,1);
fixations_list_t2=fixations_list_t2(2:n,:);

number_t2=size(fixations_list_t2);
number_t2=number_t2(1,1);
fixx=mean(fixations_list_t2(:,1));
fixy=mean(fixations_list_t2(:,2));


if number_t2>0
start_time=fixations_list_t2(1,3);
end_time=fixations_list_t2(number_t2,3);
duration=fixations_list_t2(number_t2,3)-fixations_list_t2(1,3);
else
    start_time=0;
    end_time=0;
    duration=0;
end


list_out_points;
n_out=size(list_out_points);
n_out=n_out(1,1);

if n_out>1
    list_out_points=list_out_points(2:n_out,:);
else
    list_out_points=[0 0 0 -1];%indicates that there are not points which are not used
end


end

