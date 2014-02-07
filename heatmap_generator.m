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

%Heatmap generator
%Generate Heatmap Visualization computed from Raw Data 
%input parameters:
%-records: list of records(x,y) from all subjects,x,y:in tracker units
%-scene: stimulus image
%-spacing: interval to define heatmap density
%-max_hor: maximum horizontal value of tracker coordinate system
%-max_ver: maximum vertical value of tracker coordinate system
%-kernel_size_gaussian: kernel size for gaussian filtering
%-s_gaussian:sigma for gaussian filtering
%export matlab matrixes:
%-heatmapRGB:heatmap values RGB
%-heatmap:heatmap grayscale
%call function example:
%heatmap_generator('data.txt','stimulus.bmp',0.0833,1.25,1.00,5,3);

function [heatmapRGB,heatmap]=heatmap_generator(records,scene,spacing,max_hor,max_ver,kernel_size_gaussian,s_gaussian)

records=load(records);
scene=imread(scene);
x=records(:,1);
y=records(:,2);
n_scene=size(scene);
n_1_scene=n_scene(1,1);
n_2_scene=n_scene(1,2);

%total number of points
n=size(records);
n=n(1,1);

%create heatmap matrix
%heatmap values: records frequency
%heatmap dimensions
heatmap_ver_values=(0:spacing:max_ver);
heatmap_hor_values=(0:spacing:max_hor);
heatmap_ver_number=size(heatmap_ver_values);
heatmap_ver_number=heatmap_ver_number(1,2)-1;%number of vertical elements in heatmap matrix
heatmap_hor_number=size(heatmap_hor_values);
heatmap_hor_number=heatmap_hor_number(1,2)-1;%number of vertical elements in heatmap matrix
%heatmap matrix initialization
heatmap=zeros(heatmap_ver_number,heatmap_hor_number);

%frequencies
f=zeros(heatmap_hor_number*heatmap_ver_number,1);
n_f=size(f);
n_f=n_f(1,1);
%initialize counters
j=0;
i=1;
for l=1:heatmap_ver_number
    for k=1:heatmap_hor_number
        i;
        j=j+1;
        heatmap(i,j)=points_in_region(x,y,heatmap_hor_values(k),heatmap_ver_values(l),heatmap_hor_values(k+1),heatmap_ver_values(l+1));
    end
    i=i+1;
    j=0;
end
heatmap_frequencies=heatmap;

%adjust frequenies values to range 0-255
%255:max frequency
%0:no frequency
heatmap=(255/max(max(heatmap)))*heatmap;
heatmap=floor(heatmap);%integer values
%take the inverse image
%heatmap=255-heatmap;
heatmap=uint8(heatmap);

%resize heatmap to adjust to scene resolution
heatmap=imresize(heatmap,[n_1_scene n_2_scene],'bicubic');

%create RGB heatmap
heatmapRGB=zeros(n_1_scene,n_2_scene,3);
%initialize R,G,B
R=zeros(n_1_scene,n_2_scene);
G=zeros(n_1_scene,n_2_scene);
B=zeros(n_1_scene,n_2_scene);

for i=1:1024
    for j=1:1280
        if (heatmap(i,j)==0 || heatmap(i,j)>0) && (heatmap(i,j)==25 || heatmap(i,j)<25)
            R(i,j)=10;
            G(i,j)=10;
            B(i,j)=10;
            
        elseif (heatmap(i,j)==26 || heatmap(i,j)>26) && (heatmap(i,j)==50 || heatmap(i,j)<50)
            R(i,j)=60;
            G(i,j)=60;
            B(i,j)=60;
            
            
        elseif (heatmap(i,j)==51 || heatmap(i,j)>51) && (heatmap(i,j)==75 || heatmap(i,j)<75)
            R(i,j)=0;
            G(i,j)=0;
            B(i,j)=255;
            
        elseif (heatmap(i,j)==76 || heatmap(i,j)>76) && (heatmap(i,j)==100 || heatmap(i,j)<100)
            R(i,j)=0;
            G(i,j)=255;
            B(i,j)=210;
            
        elseif (heatmap(i,j)==101 || heatmap(i,j)>101) && (heatmap(i,j)==125 || heatmap(i,j)<125)
            R(i,j)=0;
            G(i,j)=255;
            B(i,j)=75;
            
        elseif (heatmap(i,j)==126 || heatmap(i,j)>126) && (heatmap(i,j)==150 || heatmap(i,j)<150)
            R(i,j)=192;
            G(i,j)=255;
            B(i,j)=0;
            
        elseif (heatmap(i,j)==151 || heatmap(i,j)>151) && (heatmap(i,j)==175 || heatmap(i,j)<175)
            R(i,j)=255;
            G(i,j)=240;
            B(i,j)=0;
            
        elseif (heatmap(i,j)==176 || heatmap(i,j)>176) && (heatmap(i,j)==200 || heatmap(i,j)<200)
            R(i,j)=255;
            G(i,j)=192;
            B(i,j)=0;
            
        elseif (heatmap(i,j)==201 || heatmap(i,j)>201) && (heatmap(i,j)==225 || heatmap(i,j)<225)
            R(i,j)=255;
            G(i,j)=150;
            B(i,j)=0;
            
        else
            R(i,j)=255;
            G(i,j)=0;
            B(i,j)=0;
        end
        
    end
end
R=uint8(R);
G=uint8(G);
B=uint8(B);
heatmapRGB(:,:,1)=R;
heatmapRGB(:,:,2)=G;
heatmapRGB(:,:,3)=B;
heatmapRGB=uint8(heatmapRGB);


%show heatmap after gaussian filtering
figure
imshow(scene)
hold on
h = fspecial('gaussian',kernel_size_gaussian,s_gaussian);
imshow(imfilter(heatmapRGB,h,'replicate'));
title('Heatmap','Color','k','FontSize',14)
alpha(0.6)

fprintf('\nHeatmap Visualization is completed successfully\n')



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

