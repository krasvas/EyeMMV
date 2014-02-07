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

%function visualizations_stimulus
%export different visualizations with stimulus image
%input parameters:
%-data: raw data corresponded to one stimuli
%-stimulus: stimulus image
%-fixation_list: list of fixations(after fixation_detection)
%-maxr: maximum value of radius in pixels to represent fixations durations
%call function example
%visualizations_stimulus('data.txt','stimulus.bmp',fixations_list,100)
function visualizations_stimulus(data,stimulus,fixations_list,maxr);
data=load(data);
stimulus=imread(stimulus);
%x,y,t
x=data(:,1);
y=data(:,2);
t=data(:,3);

%x_fix,y_fix,duration
x_fix=fixations_list(:,1);
y_fix=fixations_list(:,2);
duration=fixations_list(:,7);
n_fix=length(x_fix);

%stimulus_size
stimulus_size=size(stimulus);
stimulus_vertical_size=stimulus_size(1,1);
stimulus_horizontal_size=stimulus_size(1,2);

%transform data to pixel coordinate system
x=stimulus_vertical_size*x;
y=stimulus_vertical_size*(1-y);
x_fix=stimulus_vertical_size*x_fix;
y_fix=stimulus_vertical_size*(1-y_fix);


%raw data visualization
figure
imshow(stimulus)
hold on
plot(x,y,'r+')
title('Raw Data Distribution','Color','k','FontSize',14)
xlabel('Horizontal Coordinate','Color','k','FontSize',12)
ylabel('Vertical Coordinate','Color','k','FontSize',12)
hold on
plot(x,y,'b--')
axis('equal')
legend('Record Point','Records Trace','Location','SouthEastOutside')

%Scanpath visualization
figure
imshow(stimulus)
hold on
plot(x_fix,y_fix,'gs')
hold on
plot(x_fix,y_fix,'-b')
title('Scanpath (Fixations Duration & Saccades) ','Color','k','FontSize',14)
axis('equal')
%create circle points
c=linspace(0,2*pi);
%compute maxr_par
maxr_par=maxr/max(sqrt(duration)); %max r corresponds to max duration
for i=1:n_fix
    hold on
    %create circle with duration
    x_center=x_fix(i);
    y_center=y_fix(i);
    xc=(maxr_par*sqrt(duration(i)))*cos(c);
    yc=(maxr_par*sqrt(duration(i)))*sin(c);
    fill(x_center+xc,y_center+yc,'r');
    text(x_center,y_center,num2str(i),'HorizontalAlignment','Left','VerticalAlignment','Bottom','Color','m')
end
alpha(0.6)
legend('Fixation Center','Saccade','Radius represents the duration','Location','SouthEastOutside')
xlabel('Horizontal Coordinate','Color','k','FontSize',10)
ylabel('Vertical Coordinate','Color','k','FontSize',10)
fprintf('\nVisualizations are plotted successfully\n')
fprintf('\nVisualizations with stimulus are plotted successfully\n')


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

