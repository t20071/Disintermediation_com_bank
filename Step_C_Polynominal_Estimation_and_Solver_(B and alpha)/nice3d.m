function [] = nice3d(funXYZ,xr,yr,head,xlab,ylab,zlab,pts,ptscol)

% mgross@imf.org

% The function produces a three-dimensional surface plot based on a
% function handle funXYZ that relates z to x and y.

%% Inputs
%  funXYZ  function handle to map x and y into z
%  xr      1x2 vector, min and max of x
%  yr      1x2 vector, min and max of y
%  head    string, title
%  xlab    string
%  ylab    string
%  zlab    string
%  pts     matrix, can be []; or 3xK for [x,y,z]-coordinates of up to K points to locate in the space
%  ptscol  1xK cell array, color of the lines to locate the pts

%% Example:
%  fxyz = @(x1,x2) -6*x1.^3.*x2+10*x1.^2-3*x1;
%  pt1 = [0.6 -0.15 fxyz(0.5,-0.15)+3]';
%  pt2 = [0.3 0.2 fxyz(0.3,0.2)+1]';
%  pts = [pt1 pt2]; ptscol = {'r','b'};
%  nice3d(fxyz,[0 1],[-.5 .5],'Country 1','Unemployment Rate','House Price Growth','PD',pts,ptscol)
%  nice3d(fxyz,[0 1],[-.5 .5],'Country 1','Unemployment Rate','House Price Growth','PD',[],[])

[x1,x2] = meshgrid(linspace(xr(1),xr(2),50),linspace(yr(1),yr(2),50));
surf(x1,x2,funXYZ(x1,x2),'EdgeColor',[17 17 17]/255,'FaceLighting','gouraud')
alpha 0.8, box on, colormap summer, axis tight, set(gcf,'color',[1 1 1])
xlabel(xlab), ylabel(ylab), zlabel(zlab), title(head,'fontsize',13)

if ~isempty(pts)
    hold on
    for k=1:size(pts,2)
        scatter3(pts(1,k),pts(2,k),pts(3,k))
        plot3([pts(1,k) pts(1,k)],[yr(2) pts(2,k)],[pts(3,k) pts(3,k)],['-' char(ptscol(k))])
        plot3([xr(2) pts(1,k)],[pts(2,k) pts(2,k)],[pts(3,k) pts(3,k)],['-' char(ptscol(k))])
        %plot3([pts(1,k) pts(1,k)],[pts(2,k) pts(2,k)],[pts(3,k) funXYZ(pts(1,k),pts(2,k))],['--' char(ptscol(k))]) % line from pt to surface
    end
end

