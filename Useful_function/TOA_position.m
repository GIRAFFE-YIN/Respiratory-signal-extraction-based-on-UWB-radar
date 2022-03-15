function [rm] = TOA_position(p1,p2,Rx)

p1 = 2;
p2 = 3.3;
N = size(Rx,2);

H = Rx(:,2:N)';
pseudo_H = pinv(H);

b2 = norm(Rx(:,2)).^2 - p2^2 + p1^2;

b = 0.5.*[b2];

rm = pseudo_H*b;

% disp(['The position from DOA is: ', num2str(rm(1)),' , ', num2str(rm(2)),' , ',num2str(rm(3))]);

% Circle(Rx(1,1),Rx(2,1),p1);
% Circle(Rx(1,2),Rx(2,2),p2);
% Circle(Rx(1,3),Rx(2,3),p3);
% Circle(Rx(1,4),Rx(2,4),p4);
% text(Rx(1,1),Rx(2,1),'Rx1'); hold on;
% text(Rx(1,2),Rx(2,2),'Rx2'); hold on;
% text(Rx(1,3),Rx(2,3),'Rx3'); hold on;
% text(Rx(1,4),Rx(2,4),'Rx4'); hold on;

end

