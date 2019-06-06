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

%function fixation_detection
%detect fixations from raw data
%input parameters:
%-data:raw data (x y t),x,y: in tracker units(cartesian coordinate system),t: time in ms
%-t1: spatial parameter t1 in tracker units
%-t2: spatial parameter t2 in tracker units
%-minDur: minimum value of fixation duration in ms
%-maxx: maximum horizontal coordinate in tracker coordinate system
%-maxy: maximum vertical coordinate in tracker coordinate system
%export matlab matrixes:
%-fixation_list_t2:list of fixations info computed with t1,t2,minDur criteria
%-fixation_list_3s:list of fixations info computed with t1,3s,minDur criteria
%call function example:
%fixation_detection('data.txt',0.250,0.100,150,1.25,1.00);
function [fixation_list_t2,fixation_list_3s]=fixation_detection(data,t1,t2,minDur,maxx,maxy)
%load data from file
data=load(data);
x=data(:,1);
y=data(:,2);
t=data(:,3);
n=length(t);
%build initial fixations list
%categorize each data point to a fixation cluster according to tolerance 1
fixations=[data,zeros(n,1)];
%initialize pointers
fixid=1; %fixation id
mx=0; %mean coordinate x
my=0; %mean coordinate y
d=0;  %dinstance between data point and mean point
fixpointer=1; %fixations pointer
for i=1:n
    mx=mean(x(fixpointer:i));
    my=mean(y(fixpointer:i));
    d=distance2p(mx,my,x(i),y(i));
    if d>t1
        fixid=fixid+1;
        fixpointer=i;
    end
    fixations(i,4)=fixid;
end
%end of clustering according to tolerance 1
%number of fixation after clustering (t1)
number_fixations=fixations(n,4);

%initialize fixations list according spatial criteria
%(Center x, Center y, Number of data points after t1, Number of data points
%after second criterion, Start time, End time, Duration)
fixation_list_t2=zeros(1,7);
fixation_list_3s=zeros(1,7);

%initialize the list of points which are not participate in fixation analysis
list_of_out_points=[0 0 0 -1];

%print fixation list according to spatial criteria
for i=1:number_fixations
    [centerx_t2,centery_t2,n_t1_t2,n_t2,t1_t2,t2_t2,d_t2,out_points]=fixations_t2(fixations,i,t2);
    [centerx_3s,centery_3s,n_t1_3s,n_3s,t1_3s,t2_3s,d_3s]=fixations_3s(fixations,i);
    %build list(t2)
    fixation_list_t2(i,1)=centerx_t2;
    fixation_list_t2(i,2)=centery_t2;
    fixation_list_t2(i,3)=n_t1_t2;
    fixation_list_t2(i,4)=n_t2;
    fixation_list_t2(i,5)=t1_t2;
    fixation_list_t2(i,6)=t2_t2;
    fixation_list_t2(i,7)=d_t2;
    %build list(3s)
    fixation_list_3s(i,1)=centerx_3s;
    fixation_list_3s(i,2)=centery_3s;
    fixation_list_3s(i,3)=n_t1_3s;
    fixation_list_3s(i,4)=n_3s;
    fixation_list_3s(i,5)=t1_3s;
    fixation_list_3s(i,6)=t2_3s;
    fixation_list_3s(i,7)=d_3s;
    
    %build list of points which are not used
    list_of_out_points=[list_of_out_points;out_points];
end

%remove from list of out points the zeros records
n_out=size(list_of_out_points);
n_out=n_out(1,1);
list=zeros(1,4);
for i=1:n_out
    if list_of_out_points(i,4)==0
    list=[list;list_of_out_points(i,:)];
    end
end
n_list=size(list);
n_list=n_list(1,1);
if n_out>1
    list_of_out_points=list(2:n_list,:);
else
    list_of_out_points=0;
end

%applying duration threshold
fixation_list_t2=min_duration(fixation_list_t2,minDur);
fixation_list_3s=min_duration(fixation_list_3s,minDur);

%export results
n_t2=size(fixation_list_t2);
n_t2=n_t2(1,1);
n_3s=size(fixation_list_3s);
n_3s=n_3s(1,1);

fprintf('                Fixation Detection Report \n\n')
fprintf('Import Parameters: \n')
fprintf('  Spatial Parameter t1: %.3f\n',t1)
fprintf('  Spatial Parameter t2: %.3f\n',t2)
fprintf('  Minimum Fixation Duration: %.2f\n',minDur)
fprintf('  Maximum Coordinate in Horizontal Dimension: %.2f\n',maxx)
fprintf('  Maximum Coordinate in Vertical Dimension: %.2f\n\n',maxy)

fprintf('Number of Raw Data: %.f\n',n)
fprintf('Number of Data used in the analysis(t1,t2,minDur): %.f\n',sum(fixation_list_t2(:,4)))
fprintf('Number of Data used in the analysis(t1,3s,minDur): %.f\n',sum(fixation_list_3s(:,4)))

fprintf('\nFixations: \n')
fprintf('  Total Number of Fixations(t1,t2,minDur): %.f\n',n_t2)
fprintf('  Total Number of Fixations(t1,3s,minDur): %.f\n',n_3s)

fprintf('\nt1,t2,minDur:\n')
fprintf('  ID-Xcenter-Ycenter-Nt1-Nt2-StartTime-EndTime-Duration\n')
for i=1:n_t2
    fprintf('  %.f %.4f %.4f %.f %.f %.4f %.4f %.4f\n',i,fixation_list_t2(i,1),fixation_list_t2(i,2),fixation_list_t2(i,3),fixation_list_t2(i,4),fixation_list_t2(i,5),fixation_list_t2(i,6),fixation_list_t2(i,7))
end
fprintf('\n')
fprintf('t1,3s,minDur:\n')
fprintf('  ID-Xcenter-Ycenter-Nt1-N3s-StartTime-EndTime-Duration\n')
for i=1:n_3s
    fprintf('  %.f %.4f %.4f %.f %.f %.4f %.4f %.4f\n',i,fixation_list_3s(i,1),fixation_list_3s(i,2),fixation_list_3s(i,3),fixation_list_3s(i,4),fixation_list_3s(i,5),fixation_list_3s(i,6),fixation_list_3s(i,7))
end


%plot records and fixations
figure
plot(x,y,'co')
set(gca,'Fontsize',20)
hold on
plot(fixation_list_t2(:,1),fixation_list_t2(:,2),'r+')
text(fixation_list_t2(:,1),fixation_list_t2(:,2),num2str(fixation_list_t2(:,7)),'HorizontalAlignment','Left','VerticalAlignment','Bottom','FontSize',20,'Color','r')
hold on
plot(fixation_list_3s(:,1),fixation_list_3s(:,2),'bs')
text(fixation_list_3s(:,1),fixation_list_3s(:,2),num2str(fixation_list_3s(:,7)),'HorizontalAlignment','Right','VerticalAlignment','Top','FontSize',20,'Color','b')
hold on 
plot(list_of_out_points(:,1),list_of_out_points(:,2),'go')
legend('Raw Data','Fixations (t1, t2, minDur)','Fixations (t1, 3s, minDur)','Points out of analysis (t1,t2,minDur)','Location','Best')
title(['Raw Data and Fixations  (t1=',num2str(t1),', t2=',num2str(t2),', minDur=',num2str(minDur),')'],'FontSize',20)
xlabel('Horizontal Coordinate','Color','k','FontSize',20)
ylabel('Vertical Coordinate','Color','k','FontSize',20)
axis('equal')
%plot screen outline
screen=[0,0;maxx,0;maxx,maxy;0,maxy;0,0]; %sreen region
hold on
plot(screen(:,1),screen(:,2),'-r')

fprintf('\n Raw Data and Fixations are visualized successfully\n')
fprintf('________________________________________________________\n')

fprintf('End of Fixation Detection report\n')


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
