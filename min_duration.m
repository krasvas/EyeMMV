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

%import the list of fixations (Center x, Center y, Number of data points
%after t1, Number of data points after second criterion, Start time, End
%time, Duration) and minimum duration
function fixations=min_duration(fixation_list,minDur)
n=size(fixation_list);
n=n(1,1);

%initialize new fixation list
fixations=zeros(1,7);
for i=1:n
    if fixation_list(i,7)>minDur
        fixations=[fixations;fixation_list(i,:)];
    end
end
n=size(fixations);
n=n(1,1);
fixations=fixations(2:n,:);
end
