function [x,y,a] = clicksubplot
while 1 == 1
    w = waitforbuttonpress;
      switch w
          case 1 % keyboard
              key = get(gcf,'currentcharacter');
              if key==27 % (the Esc key)
                  try; delete(h); end
                  break
              end
          case 0 % mouse click
              mousept = get(gca,'currentPoint');
              [x,y] = ginput(1); %find center point
              try; delete(h); end
              a = get(gca,'tag');
           break
      end
 end
% function [x,y,a] = clicksubplot
% while 1 == 1
%     w = waitforbuttonpress;
%       switch w 
%           case 1 % keyboard 
%               key = get(gcf,'currentcharacter'); 
%               if key==27 % (the Esc key) 
%                   try; delete(h); end
%                   break
%               end
%           case 0 % mouse click 
%               mousept = get(gca,'currentPoint');
%               x = mousept(1,1);
%               y = mousept(1,2);
%               try; delete(h); end
%               a = get(gca,'tag');
%            break
%       end
%  end