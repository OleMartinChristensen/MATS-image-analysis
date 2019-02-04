function [t_off, t_scl, t_std] = compare_image(image1, image2);

%
% this is a function to compare two images of
% the same size
% One comparison is a linear fit of columns
% the other comparison is a linear fit of rows
% the third is a linear fit of the whole image
%

sz1=size(image1);
sz2=size(image2);

if (sz1(1) ~= sz2(1))  | (sz1(2) ~= sz2(2))
    disp('sizes of input images do not match!');
end

nrow=sz1(1);
ncol=sz1(2);

for jj=1:nrow
    x=[ones(ncol,1), image1(jj,:)'];
    y=image2(jj,:)';
    bb=x\y;
    ft=x(:,2).*bb(2) + bb(1);

    adf=abs(y-ft);
    sigma=std(y-ft);
    
    inside=(adf < 2*sigma);
    bb=x(inside,:)\y(inside);
    
    ft=x(:,2).*bb(2) + bb(1);
    
    r_scl(jj)=bb(2);
    r_off(jj)=bb(1);
    r_std(jj)=std(y(inside)-ft(inside));
    
end;

% 
% figure(1)
% hold off
% plot(r_scl);
% figure(5)
% plot(r_off);
% figure(6)
% plot(r_std);


for jj=1:ncol
    x=[ones(nrow,1), image1(:,jj)];
    y=image2(:,jj);
    bb=x\y;
    
    ft=x(:,2).*bb(2) + bb(1);

    
    adf=abs(y-ft);
    sigma=std(y-ft);
    
    inside=(adf < 2*sigma);
    bb=x(inside,:)\y(inside);
    
%     figure(3);
%     hold off
%     plot(x(:,2), y, '.');
%     hold on
%     plot(x(:,2), ft, 'r');
%     
%      figure(1);
%      hold off
%      plot(x(:,2));
%      hold on
%           plot(y,'r');
%      plot(ft, 'g');    
%      input(' ');

    ft=x(:,2).*bb(2) + bb(1);

    c_scl(jj)=bb(2);
    c_off(jj)=bb(1);
    c_std(jj)=std(y(inside)-ft(inside));
end;


% figure(11)
% hold off
% plot(c_scl);
% figure(15)
% plot(c_off);
% figure(16)
% plot(c_std);

nsz=sz1(1)*sz1(2);
la_1=reshape(image1,[nsz,1]);
la_2=reshape(image2,[nsz,1]);

x=[ones(nsz,1), la_1];
    y=la_2;
    bb=x\y;    
    ft=x(:,2).*bb(2) + bb(1);
    
    adf=abs(y-ft);
    sigma=std(y-ft);
    
    inside=(adf < 3*sigma);
    bb=x(inside,:)\y(inside);
    
    ft=x(:,2).*bb(2) + bb(1);
    
    t_off=bb(1);
    t_scl=bb(2);
    t_std=std(y(inside)-ft(inside));

rows=0;

end