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

%x:horizontal coord from all records
%y:vertical coord from all records
function n_records_region=points_in_region(x,y,left_up_edge_x,left_up_edge_y,right_down_edge_x,right_down_edge_y)

%edges of region
right_up_edge_x=right_down_edge_x;
right_up_edge_y=left_up_edge_y;
left_down_edge_x=left_up_edge_x;
left_down_edge_y=right_down_edge_y;

%total number of records
n=size(x);
n=n(1,1);

%number of records in region 
n_records_region=0;
for i=1:n
    if (x(i)>left_up_edge_x || x(i)==left_up_edge_x) &&( x(i)<right_up_edge_x || x(i)==right_up_edge_x )&& (y(i)>left_up_edge_y || y(i)==left_up_edge_y) &&( y(i)<left_down_edge_y || y(i)==left_down_edge_y)
        n_records_region=n_records_region+1;
    end
end

end


