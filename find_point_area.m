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

%function find_point_area
%input parameters
%(x,y): coordinates of point
%max_hor: maximum horizontal dimension of coordinate system
%max_ver: maximum vertical dimension of coordinate system
%spacing: spacing parameter to create transition matrix
%export Point_area(x_center,y_center,area,maximum_number_of_areas)

function Point_area=find_point_area(x,y,max_hor,max_ver,spacing)

hor_spacing=[0:spacing:max_hor];
ver_spacing=[0:spacing:max_ver];

%build matrix with the coordinates of centers of transition matrix squares
%initialization (x,y,ID)
centers=zeros((length(hor_spacing)-1)*(length(ver_spacing)-1),3);
centers(1,1)=spacing/2;
centers(1,2)=spacing/2;

for i=2:(length(hor_spacing)-1)
    centers(i,1)=centers(i-1,1)+spacing;
    centers(i,2)=centers(1,2);
end

for i=length(hor_spacing):length(hor_spacing)-1:((length(hor_spacing)-1)*(length(ver_spacing)-1))
    centers(i:(i-2+length(hor_spacing)),1)=centers(1:(length(hor_spacing)-1),1);
    centers(i:(i-2+length(hor_spacing)),2)=centers((i-((length(hor_spacing)-1))):(i-1),2)+spacing;
end

%create areas id
%the matrix centers contains the square areas (x_center,y_center,id) of transition matrix
for i=1:(length(hor_spacing)-1)*(length(ver_spacing)-1)
    centers(i,3)=i;
end

%compute number of areas
n_areas=(length(hor_spacing)-1)*(length(ver_spacing)-1);

%find in which area the point is located
%compute distances between point and centers
%initialize distances(distance center from point,x_center,y_center,area)
distances=zeros(n_areas,4);
for i=1:n_areas
    distances(i,1)=distance2p(x,y,centers(i,1),centers(i,2));
    distances(i,2)=centers(i,1);
    distances(i,3)=centers(i,2);
    distances(i,4)=centers(i,3);
end

%the area corresponds to the minimum value of distance
min_value=min(distances(:,1));

%find point corresponded center
for i=1:n_areas
    if distances(i,1)==min_value
        Point_area=distances(i,2:4);
    end
end

%maximun number of areas
Point_area=[Point_area,n_areas];

end

