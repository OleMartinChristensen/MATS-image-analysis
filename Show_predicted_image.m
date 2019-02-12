
[ref_image,ref_header] = readimgpath('H:/Workspace/MATS/FFT/2019-02-08 rand6/', 0, 0);

[image,header] = readimgpath('H:/Workspace/MATS/FFT/2019-02-08 rand6/', 5, 0);
    
figure(1)
colormap jet
hold off
subplot(1,1,1)
imagesc(image)
mean_img = mean(mean(image));
caxis([mean_img-100,mean_img+100])
colorbar();
title('CCD image')
xlabel('Pixels')
ylabel('Pixels')

if header.Ending == 'Wrong size'
    disp("Something wrong with the image");
else
    prim=predict_image(ref_image, header);

    figure(2)
    colormap jet
    hold off
    subplot(1,1,1)
    imagesc(prim)
    mean_img = mean(mean(prim));
    caxis([mean_img-100,mean_img+100])
    colorbar();
    title('CCD image')
    xlabel('Pixels')
    ylabel('Pixels')
end
