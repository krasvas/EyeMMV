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

%function visualizations
%export different visualizations in tracker units
%input parameters:
%-data: raw data corresponded to one stimuli
%-fixation_list: list of fixations(after fixation_detection)
%-maxr: maximum value of radius in tracker units to represent fixations durations
%call function example
%visualizations('data.txt',fixations_list,0.1)
function visualizations(data,fixations_list,maxr)
data=load(data);
%x,y,t
x=data(:,1);
y=data(:,2);
t=data(:,3);

%x_fix,y_fix,duration
x_fix=fixations_list(:,1);
y_fix=fixations_list(:,2);
duration=fixations_list(:,7);
n_fix=length(x_fix);

%x(t),y(t) visualizations
figure
plot(t,x,'r-')
hold on
plot(t,y,'b-')
title('Horizontal and Vertical Coordinates along Time','Color','k','FontSize',14)
xlabel('Time','Color','k','FontSize',12)
ylabel('Coordinates','Color','k','FontSize',12)
legend('x(t)','y(t)','Location','SouthEastOutside')
grid on

%raw data visualization
figure
plot(x,y,'r+')
title('Raw Data Distribution','Color','k','FontSize',14)
xlabel('Horizontal Coordinate','Color','k','FontSize',12)
ylabel('Vertical Coordinate','Color','k','FontSize',12)
hold on
plot(x,y,'b--')
axis('equal')
legend('Record Point','Records Trace','Location','SouthEastOutside')
grid on

%space-time-cube
figure
plot3(x,y,t,'r','LineWidth',1.5)
hold on
plot3(x,y,t,'b+')
title('Space-Time-Cube','Color','k','FontSize',14)
xlabel('Horizontal Coordinate','Color','k','FontSize',12)
ylabel('Vertical Coordinate','Color','k','FontSize',12)
zlabel('Time','Color','k','FontSize',12)
legend('Records Trace','Record Point','Location','SouthEastOutside')
grid on

%Scanpath visualization
figure
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


