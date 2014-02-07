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

%function metrics_analysis
%eye movement metrics computations
%input parameters:
%-fixation_list: list of fixations(after fixation_detection)
%-repeat_fixation_threshold: threshold in tracker units for repeat fixations
%-spacing_scanpath: interval in tracker units to compute scanpath density
%-spacing_transition: interval in tracker units to compute transition matrix density
%-maxx: maximum horizontal coordinate in tracker coordinate system
%-maxy: maximum vertical coordinate in tracker coordinate system
%export matlab matrixes:
%-repeat_fixations: list of repeat fixations
%-saccades: list of saccadic movements
%-transition_matrix: transition matrix according the giving sapcing
%call function example:
%metrics_analysis(fixation_list,0.10,0.25,0.25,1.25,1.00);
%fixation_list:matlab matrix as computed from fixation_detection

function [repeat_fixations,saccades,transition_matrix]=metrics_analysis(fixation_list,repeat_fixation_threshold,spacing_scanpath,spacing_transition,maxx,maxy)

%Fixation analysis
%compute total number of fixations
total_number_fixations=size(fixation_list);
total_number_fixations=total_number_fixations(1,1);

%compute mean duration of fixations
mean_durations_fixations=mean(fixation_list(:,7));

%compute time to first fixation
time_to_first_fixation=fixation_list(1,5);

%compute repeat fixations
%initialize distances between fixations(fixation1,fixation2,distance_between_two_fixations)
distances_between_fixations=zeros(1,3);
for i=1:total_number_fixations
    for j=1:total_number_fixations
        if i~=j && i<j
            distances_between_fixations=[distances_between_fixations;[i,j,(distance2p(fixation_list(i,1),fixation_list(i,2),fixation_list(j,1),fixation_list(j,2)))]];
        end
    end
end
n_distances_between_fixations=size(distances_between_fixations);
n_distances_between_fixations=n_distances_between_fixations(1,1);
distances_between_fixations=distances_between_fixations(2:n_distances_between_fixations,:);
%initialize matrix of repeat fixations
repeat_fixations=zeros(1,3);
for i=1:(n_distances_between_fixations-1)
    if distances_between_fixations(i,3)<repeat_fixation_threshold
        repeat_fixations=[repeat_fixations;distances_between_fixations(i,:)];
    end
end

n_repeat_fixations=size(repeat_fixations);
n_repeat_fixations=n_repeat_fixations(1,1);
if n_repeat_fixations>1
    repeat_fixations=repeat_fixations(2:n_repeat_fixations,:);
end

%compute total duration of fixations
total_duration_fixations=sum(fixation_list(:,7));

%Saccade analysis
%build saccades list (x_start_point,y_start_point,x_end_point,y_end_point, duration, amplitude, direction angle,start_fixation,end_fixation)
if total_number_fixations>2 || total_number_fixations==2
    total_number_saccades=total_number_fixations-1;
    %initialize saccades list
    saccades=zeros(total_number_saccades,9);
    j=2;%pointer
    for i=1:(total_number_fixations-1)
        %import start and end points in list
        saccades(i,1)=fixation_list(i,1);
        saccades(i,2)=fixation_list(i,2);
        saccades(i,3)=fixation_list(j,1);
        saccades(i,4)=fixation_list(j,2);
        
        %compute saccades durations
        saccades(i,5)=fixation_list(j,5)-fixation_list(i,6);
        
        %compute amplitude
        saccades(i,6)=distance2p(saccades(i,1),saccades(i,2),saccades(i,3),saccades(i,4));
        
        %compute direction angle
        saccades(i,7)=direction_angle(saccades(i,1),saccades(i,2),saccades(i,3),saccades(i,4));
        
        %name start and end fixations in each saccade
        saccades(i,8)=i;
        saccades(i,9)=j;
        
        j=j+1;
    end
    
    %compute mean duration of saccades
    mean_durations_saccades=mean(saccades(:,5));
else
    total_number_saccades=0;
end

%Scanpath analysis
%compute scanpath length
scanpath_length=sum(saccades(:,6));

%compute scanpath duration
scanpath_duration=fixation_list(total_number_fixations,6)-fixation_list(1,5);

%compute saccade/fixation ratio
ratio_sf=sum(saccades(:,5))/sum(fixation_list(:,7));

%compute scanpath spatial density
%build points_areas_matrix(x,y,area_id)
%initialize
points_areas_matrix=zeros(1,3);
for i=1:total_number_fixations
    area=find_point_area(fixation_list(i,1),fixation_list(i,2),maxx,maxy,spacing_scanpath);
    points_areas_matrix(i,1)=area(1);
    points_areas_matrix(i,2)=area(2);
    points_areas_matrix(i,3)=area(3);
    
end
n_scanpath_areas=area(4);
%compute the number of unique areas between points areas
number_different_areas=length(unique(points_areas_matrix(:,3)));
%scanpath_density
scanpath_density=number_different_areas/n_scanpath_areas;

%create transition matrix
%build fixation_transition_areas(x_fixation,y_fixation,x_center,y_center,transition_area)
%initialize fixation_transition areas
fixation_transition_areas=zeros(1,5);
for i=1:total_number_fixations
    fixation_transition_areas(i,1)=fixation_list(i,1);
    fixation_transition_areas(i,2)=fixation_list(i,2);
    area=find_point_area(fixation_list(i,1),fixation_list(i,2),maxx,maxy,spacing_transition);
    fixation_transition_areas(i,3:5)=area(1:3);
end
%transitions
transitions=fixation_transition_areas(:,5);
%transition dimension corresponds to maximun number of areas
transition_dimension=area(4);
%build transition matrix(>=1:indicates transition, 0: indicates no transition)
%initialize
transition_matrix=zeros(transition_dimension);

for i=1:(total_number_fixations-1)
    for j=1:transition_dimension
        if j==transitions(i)
            transition_matrix(transitions(i+1),j)=transition_matrix(transitions(i+1),j)+1;
        end
    end
end

%compute the number of transitions
%initialize number
number_transitions=0;
for i=1:transition_dimension
    for j=1:transition_dimension
        if transition_matrix(i,j)>0
            number_transitions=number_transitions+1;
        end
    end
end

%compute transition density
transition_density=number_transitions/(transition_dimension^2);


%print results
fprintf('Eye Movement metrics analysis\n\n')
fprintf('Input Parameters: \n')
fprintf('   Threshold for repeat fixations: %.3f\n',repeat_fixation_threshold)
fprintf('   Scanpath spacing (spatial density computation): %.3f\n',spacing_scanpath)
fprintf('   Transition matrix spacing: %.3f\n',spacing_transition)

fprintf('\nFixation Metrics Analysis:\n')
fprintf('  Total number of fixations: %.f\n',total_number_fixations)
fprintf('  Mean duration of fixations: %.1f\n',mean_durations_fixations)
fprintf('  Time to first fixation: %.1f\n',time_to_first_fixation)
if n_repeat_fixations>1
    fprintf('  Repeat Fixations:\n')
    fprintf('    (Fixation_1_id-Fixation_2_id-Distance)\n')
    for i=1:(n_repeat_fixations-1)
        fprintf('    %.f %.f %.3f  \n',repeat_fixations(i,1),repeat_fixations(i,2),repeat_fixations(i,3))
    end
end
fprintf('  Total duration of all fixations: %.1f\n',total_duration_fixations)

fprintf('\nSaccades Analysis:\n')
fprintf('   Total number of saccades: %.f\n',total_number_saccades)
if total_number_saccades>1
   fprintf('   Saccades list:\n')
   fprintf('      (ID-X_Start_Point-Y_Start_Point-X_End_Point-Y_End_Point-\n       Duration-Amplitude-Direction_angle-Start_Fixation-End_Fixation)\n')
   for i=1:total_number_saccades
       fprintf('      %.f %.4f %.4f %.4f %.4f %.1f %.3f %.3f %.f %.f\n',i,saccades(i,1),saccades(i,2),saccades(i,3),saccades(i,4),saccades(i,5),saccades(i,6),saccades(i,7),saccades(i,8),saccades(i,9))
   end
end

fprintf('\nScanpath Analysis:\n')
fprintf('   Scanpath length: %.3f\n',scanpath_length)
fprintf('   Scanpath duration: %.1f\n',scanpath_duration)
fprintf('   Saccades/Fixations Ratio: %.3f\n',ratio_sf)
fprintf('   Scanpath Spatial Density: %.3f\n',scanpath_density)
fprintf('   Transition Matrix:\n')
fprintf('       ')
for i=1:transition_dimension
fprintf('-%.f',i)
end
fprintf('\n')
for i=1:transition_dimension
    fprintf('   %.f-',i)
    for j=1:transition_dimension
        fprintf('   %.f',transition_matrix(i,j))
    end
    fprintf('\n')
end
fprintf('Transition Density: %.3f\n',transition_density)
fprintf('________________________________________________________\n')
fprintf('\nEnd of Metrics Analysis Report\n')


fprintf('\n EyeMMV toolbox (Eye Movements Metrics & Visualizations): An eye movement post-analysis tool. \n')
fprintf(' Copyright (C) 2014 Vassilios Krassanakis (National Technical University of Athens) \n')
fprintf('\n')
fprintf(' This program is free software: you can redistribute it and/or modify\n')
fprintf(' it under the terms of the GNU General Public License as published by\n')
fprintf(' the Free Software Foundation, either version 3 of the License, or\n')
fprintf(' (at your option) any later version.\n')
fprintf('\n')
fprintf(' This program is distributed in the hope that it will be useful,\n')
fprintf(' but WITHOUT ANY WARRANTY; without even the implied warranty of\n')
fprintf(' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n')
fprintf(' GNU General Public License for more details.\n')
fprintf('\n')
fprintf(' You should have received a copy of the GNU General Public License\n')
fprintf(' along with this program.  If not, see <http://www.gnu.org/licenses/>.\n')
fprintf('\n')
fprintf(' For further information, please email me: krasanakisv@gmail.com or krasvas@mail.ntua.gr\n')
end