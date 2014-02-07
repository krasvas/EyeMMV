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

%function ROI_analysis
%analysis in predefined rectangle region of interest
%input parameters:
%-fixation_list: list of fixations(after fixation_detection)
%-rois: regions of interest file((x_left_up,y_left_up,x_right_down,y_right_down,ROIs ID)
%-roi_to_analyze: define the analyzed ROI from ROI ID (according to the IDs in rois file)
%export matlab matrix:
%-fixations_in_roi: fixations in the analyzed region of interest
%call function example:
%ROI_analysis(fixation_list,'ROIS.txt',2);
%fixation_list:matlab matrix as computed from fixation_detection

function fixations_in_roi=ROI_analysis(fixation_list,rois,roi_to_analyze)
rois=load(rois);
x_fix=fixation_list(:,1);
y_fix=fixation_list(:,2);
duration=fixation_list(:,7);
%number of ROIs
n_rois=size(rois);
n_rois=n_rois(1,1);

%classify fixations in ROis(0:indicates that fixation is out of ROI)
fixations_classification=zeros(length(x_fix),1);

for i=1:length(x_fix)
    for j=1:n_rois
        if ((x_fix(i)>=rois(j,1) && x_fix(i)<=rois(j,3)) &&  (y_fix(i)<=rois(j,2) && y_fix(i)>=rois(j,4)))
            fixations_classification(i)=rois(j,5);
        end
    end
end

fixation_list(:,8)=fixations_classification;


%build the matrix with fixations in selected roi
%initialize fixations_in_roi(x_fixation,y_fixation,duration)
fixations_in_roi=zeros(1,3);
for i=1:length(x_fix)
    if fixation_list(i,8)==roi_to_analyze
        fixations_in_roi=[fixations_in_roi;x_fix(i),y_fix(i),duration(i)];
    end
end
n_fixations=size(fixations_in_roi);
n_fixations=n_fixations(1,1);
if n_fixations>1
    fixations_in_roi=fixations_in_roi(2:n_fixations,:);
    
    %compute the number of fixations in roi
    number_fixations_in_roi=size(fixations_in_roi);
    number_fixations_in_roi=number_fixations_in_roi(1,1);
    
    %compute mean duration of fixations in roi
    mean_duration_roi=mean(fixations_in_roi(:,3));
    
    %compute % number of fixations in roi
    fixations_percentage_roi=number_fixations_in_roi/length(x_fix);
    
    %compute % duration of fixations in roi
    duration_percentage_roi=sum(fixations_in_roi(:,3))/sum(duration);
    
    %print results
    fprintf('           ROI Analysis\n')
    fprintf('\nID of selected ROI for analysis: %.f\n',roi_to_analyze)
    fprintf('Number of fixations in selected ROI: %.f\n',number_fixations_in_roi)
    if n_fixations>1
        fprintf('\nFixation List in ROI:\n')
        fprintf('  X_Fixation-Y_Fixation-Duration\n')
        for i=1:number_fixations_in_roi
            fprintf('  %.4f %.4f %.1f\n',fixations_in_roi(i,1),fixations_in_roi(i,2),fixations_in_roi(i,3))
        end
        
        fprintf('\nMean duration of fixations in ROI: %.1f\n',mean_duration_roi)
        fprintf('Number (%%) of fixations in ROI: %.2f%%\n',fixations_percentage_roi*100)
        fprintf('Duration (%%) of fixations in ROI: %.2f%%\n',duration_percentage_roi*100)
    end
    
    %plot_ROIs
    plot(x_fix,y_fix,'bo')
    hold on
    for i=1:n_rois
        roi_region=[rois(i,1),rois(i,2);rois(i,3),rois(i,2);rois(i,3),rois(i,4);rois(i,1),rois(i,4);rois(i,1),rois(i,2)];
        if i==roi_to_analyze
            fill(roi_region(:,1),roi_region(:,2),'r')
            alpha(0.7)
        end
        hold on
    end
    
    for i=1:n_rois
        roi_region=[rois(i,1),rois(i,2);rois(i,3),rois(i,2);rois(i,3),rois(i,4);rois(i,1),rois(i,4);rois(i,1),rois(i,2)];
        plot(roi_region(:,1),roi_region(:,2),'g-')
        hold on
    end
    
    
    axis('equal')
    title('Regions of Interest (ROIs) ','Color','k','FontSize',20)
    xlabel('Horizontal Coordinate','Color','k','FontSize',20)
    ylabel('Vertical Coordinate','Color','k','FontSize',20)
    set(gca,'FontSize',20)
    legend('Fixations','Selected ROI','ROIs','Location','SouthEastOutside')
else
    number_fixations_in_roi=0;
    fprintf('           ROI Analysis\n')
    fprintf('\nID of selected ROI for analysis: %.f\n',roi_to_analyze)
    fprintf('Number of fixations in selected ROI: %.f\n',number_fixations_in_roi)
end


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
