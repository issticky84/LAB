function f = plot_Lab(mode,Lab,createnewfig,markercolor,markersize,storeme)
% This function visualizes several different CIE-Lab_plot plots from 
% CIE-Lab coordinate data in 'Lab'. Either 2D, 3D or projected 3D, with 
% samples projected on the ab, La and Lb plane are supported option for
% 'mode'. 
% -> Run 'plot_Lab(0,0,0,0,0,0)' for a demo of all plot types!!
%
% INPUT:   mode        [scalar]   -> 1: 2D cielab subplots pseudocolor
%                                    2: 2D cielab subplots true color
%                                    3: 3D cielab plot pseudocolor
%                                    4: 3D cielab plor true color
%                                    5: 3D surface projection pseudocolor
%                                    6: 3D surface projection true color
%                                    0: demo plot!
%          Lab         [3 x n]    -> Lab coordinates of n datapoints
%          createnewfig[flag]     -> shall the data be plotted in the
%                                    curretn figure (0), or a new one (1)
%          markercolor [string]   -> color to plot the data. Input either 
%                         or         color string (eg. 'r') or
%                      [1 x 3]    -> RGB triplet. Each values has to be 
%                                    within the range [0-1]. If a true color
%                                    plot is used (mode=2|4|6), this 
%                                    variable is ignored!
%          markersize  [scalar]   -> Size of the marker for each sample
%          storeme     [string]   -> if it is not a string, do not export. 
%                                    Else, export with filename in variable 
%                                    'storeme'.
%
% OUTPUT:  f           [handle]   -> figure handle where the plot was
%                                    created
%
% Dependencies: if exporting the figure is used, 'plot2svg.m' by 
%               Juerg Schwizer is required! Download from:
%               http://www.mathworks.es/matlabcentral/fileexchange/
%               7401-scalable-vector-graphics-svg-export-of-figures
%
% Author:  Timo Eckhard - timo.eckhard@gmx.com
%          Miguel ?ngel Mart?nez Domingo - m.martinez.domingo@gmx.com
%
% Version: V1: 28.11.2013: merged Migue and Timo function
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
linewidth = 1;      %width of the axis lines in the plot

if mode==0
    demo();
    return;
end


%% figure where to plot in
if createnewfig
    f = figure;
else
    f = gcf;
end
set(f,'PaperUnits','centimeters');
set(f,'name','plot_Lab - colorimg@ugr.es');
set(0,'units','pixels') ;
screen = get(0,'screensize');
set(f,'Position',[200,screen(4)-screen(4)/3-200,screen(3)/2,screen(4)/3]);


%% prepare the color data
if mode==2 || mode==4 || mode==6
    cform = makecform('lab2srgb','AdaptedWhitePoint',whitepoint('D65'));
    RGB = applycform(Lab',cform);
else
    RGB = markercolor;
end

%% prepare the axis limits
%use L 0->100, a,b -100->100, if no values out of range. If values out of that
%range, use the maximum or minimum value of the data
min_Lab = min(Lab,[],2);
max_Lab = max(Lab,[],2);

if min_Lab(1) > 0
    min_Lab(1) = 0;
end
if min_Lab(2) > -100
    min_Lab(2) = -100;
end
if min_Lab(3) > -100
    min_Lab(3) = -100;
end

if max_Lab(1) < 100
    max_Lab(1) = 100;
end
if max_Lab(2) < 100
    max_Lab(2) = 100;
end
if max_Lab(3) < 100
    max_Lab(3) = 100;
end


%% plot the figure
switch mode
    case {1,2} %2D subplots
        subplot(1,3,1);scatter(Lab(3,:),Lab(2,:),markersize,RGB,'fill');
        xlabel('b*'),ylabel('a*');title('CIE-a*b* coordinates');
        axis([min_Lab(3) max_Lab(3) min_Lab(2) max_Lab(2)]);grid on;hold on;
        
        subplot(1,3,2);scatter(Lab(2,:),Lab(1,:),markersize,RGB,'fill');
        xlabel('a*'),ylabel('L*');title('CIE-L*a* coordinates');
        axis([min_Lab(2) max_Lab(2) min_Lab(1) max_Lab(1)]);grid on;hold on;
        
        subplot(1,3,3);scatter(Lab(3,:),Lab(1,:),markersize,RGB,'fill');
        xlabel('b*'),ylabel('L*');title('CIE-L*b* coordinates');
        axis([min_Lab(3) max_Lab(3) min_Lab(1) max_Lab(1)]);grid on;hold on;
        
        % draw black lines indicating axis
        subplot(1,3,1)
        line([min_Lab(3) max_Lab(3)],[0 0],'color',[0 0 0],'lineWidth',linewidth)   % Axis a* == 0
        line([0 0],[min_Lab(2) max_Lab(2)],'color',[0 0 0],'lineWidth',linewidth)   % Axis b* == 0
        
        subplot(1,3,2)
        line([min_Lab(2) max_Lab(2)],[0 0],'color',[0 0 0],'lineWidth',linewidth)   % Axis L* == 0
        line([0 0],[min_Lab(1) max_Lab(1)],'color',[0 0 0],'lineWidth',linewidth)   % Axis a* == 0
        
        subplot(1,3,3)
        line([min_Lab(3) max_Lab(3)],[0 0],'color',[0 0 0],'lineWidth',linewidth)   % Axis L* == 0
        line([0 0],[min_Lab(1) max_Lab(1)],'color',[0 0 0],'lineWidth',linewidth)   % Axis b* == 0
        
        
        %export the figure
        if ischar(storeme)
            plot2svg(['Lab_coordinates_2D_',storeme,'.svg'],f,'png');
        end
        
    case {3,4} %3D plot
        scatter3(Lab(3,:),Lab(2,:),Lab(1,:),markersize,RGB,'fill');
        xlabel('b*'),ylabel('a*'),zlabel('L*');
        title('CIE-L*a*b* coordinates');
        axis([min_Lab(3) max_Lab(3) min_Lab(2) max_Lab(2) min_Lab(1) max_Lab(1)]);grid on;hold on;
                
        % draw black lines indicating axis
        line([min_Lab(3) max_Lab(3)],[0 0],[0 0],'color',[0 0 0],'lineWidth',linewidth);     % Axis L* == a* == 0
        line([0 0],[min_Lab(2) max_Lab(2)],[0 0],'color',[0 0 0],'lineWidth',linewidth);     % Axis L* == b* == 0
        line([0 0],[0 0],[min_Lab(1) max_Lab(1)],'color',[0 0 0],'lineWidth',linewidth);     % Axis a* == b* == 0
                
        %export the figure
        if ischar(storeme)
            plot2svg(['Lab_coordinates_3D_',storeme,'.svg'],f,'png');
        end

    case {5,6} %3D projection plot
        scatter3(Lab(3,:),Lab(2,:),zeros(size(Lab,2),1),markersize,RGB,'fill');hold on;
        scatter3(Lab(3,:),100*ones(size(Lab,2),1),Lab(1,:),markersize,RGB,'fill');
        scatter3(100*ones(size(Lab,2),1),Lab(2,:),Lab(1,:),markersize,RGB,'fill');
        xlabel('b*'),ylabel('a*'),zlabel('L*');
        title('CIE-L*a*b* coordinates');
        axis([min_Lab(3) max_Lab(3) min_Lab(2) max_Lab(2) min_Lab(1) max_Lab(1)]);grid on;hold on;
        
        % draw black lines indicating axis
        line([min_Lab(3) max_Lab(3)],[0 0],[0 0],'color',[0 0 0],'lineWidth',linewidth);                    % Axis L* == a* == 0
        line([0 0],[min_Lab(2) max_Lab(2)],[0 0],'color',[0 0 0],'lineWidth',linewidth);                    % Axis L* == b* == 0
        
        line([0 0],[max_Lab(2) max_Lab(2)],[min_Lab(1) max_Lab(1)],'color',[0 0 0],'lineWidth',linewidth);  % Axis b* == 0; a* == max
        line([max_Lab(3) max_Lab(3)],[0 0],[min_Lab(1) max_Lab(1)],'color',[0 0 0],'lineWidth',linewidth);  % Axis a* == 0; b* == max
        
        line([max_Lab(3) max_Lab(3)],[min_Lab(2) max_Lab(2)],[50 50],'color',[0 0 0],'lineWidth',linewidth);% Axis L* == 50; b* == max
        line([min_Lab(3) max_Lab(3)],[max_Lab(2) max_Lab(2)],[50 50],'color',[0 0 0],'lineWidth',linewidth);% Axis L* == 50; a* == max
        
        %export the figure
        if ischar(storeme)
            %check if the function is now available
            if exist('plot2svg')==2
                plot2svg(['Lab_coordinates_3D_projected_',storeme,'.svg'],f,'png');
            else
                warning('-> plot_Lab.m: exporting figures requires the plot2svg function which is not found onthis machine!'); 
            end
        end
        
end

disp('');
disp('-> plot_Lab.m developed by: Timo Eckhard - timo.eckhard@gmx.com, Miguel ?ngel Mart?nez Domingo - m.martinez.domingo@gmx.com');

end


function demo()
%function used to illustrate the different modi of the plot_Lab function

%% generate example data
n = 1000;
s = RandStream('mt19937ar','Seed',0815);
Lab = zeros(3,n);
Lab(1,:) = 50 + 10.*randn(s,1,n);
Lab(2:3,:) = 0 + 25.*randn(s,2,n);

%% plot 2D plot with pseudocolor marker
plot_Lab(1,Lab,1,'r',12,0);

%% plot 2D plot with true color marker
plot_Lab(2,Lab,1,'',12,0);

%% plot 3D plot with pseudocolor marker
plot_Lab(3,Lab,1,'r',12,0);

%% plot 3D plot with true color marker
plot_Lab(4,Lab,1,'',12,0);

%% plot 3D projection plot with pseudocolor marker
plot_Lab(5,Lab,1,'r',12,0);

%% plot 3D projection plot with true color marker
plot_Lab(6,Lab,1,'',12,0);

end