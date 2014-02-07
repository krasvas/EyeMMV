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

%calculate direction angle(grads & degrees)
%export direction angle in degrees
function a12=direction_angle(x1,y1,x2,y2)

dx=x2-x1;
dy=y2-y1;

a=(200/pi())*atan(abs(dx)/abs(dy));
a=abs(a);
a12=a;

if dx>0 & dy>0
a12=a;
elseif dx>0 & dy<0
a12=200-a;
elseif dx<0 & dy<0
a12=200+a;
elseif  dx<0 & dy>0
a12=400-a; 
else
a12=a;
end

if a12>400
a12=a12-400;
end

if a12<0
a12=a12+400;
end

a12=(360/400)*a12;
end