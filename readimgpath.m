function [image,header] = readimgpath(path, file_number, plot)
    
    filename = sprintf('%sF_0%02d/D_0%04d',path,floor(file_number/100),file_number);
    [image,header,img_flag] = readimg(filename); 

    if plot>0 
    colormap jet
    figure(2)
    hold off
    subplot(1,1,1)
    imagesc(image)
    mean_img = mean(mean(image));
    %caxis([200,400])
    caxis([mean_img-100,mean_img+100])
    colorbar();
    title('CCD image')
    xlabel('Pixels')
    ylabel('Pixels')

    disp(header)

    % Check Leading Blanks
    % disp(sum(image(floor(header.NRow/2),33:48))/16)
    
    % Check Trailing Blanks
    %disp(sum(image(floor(header.NRow/2),252:267))/16)
    
    % Mean image value
    %mean_img
    
    pause(0.1)
    end;
end
