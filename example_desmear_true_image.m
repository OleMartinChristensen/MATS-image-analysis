
image_index =0;
image_display_adjustment = 10;

[image,header] = readimgpath('H:/Workspace/MATS/FFT/2019-02-08 rand6/', image_index, 0);

true_image = get_true_image (image, header);
    
figure(1)
colormap jet
hold off
subplot(1,1,1)
imagesc(true_image)
mean_img = mean(mean(true_image));
caxis([mean_img-image_display_adjustment,mean_img+image_display_adjustment])
colorbar();
title('CCD image')
xlabel('Pixels')
ylabel('Pixels')

desmeared_image = desmear_true_image(true_image, header);

figure(2)
colormap jet
hold off
subplot(1,1,1)
imagesc(desmeared_image)
pred_mean_img = mean(mean(desmeared_image));
caxis([pred_mean_img-image_display_adjustment,pred_mean_img+image_display_adjustment])
colorbar();
title('Image with bad desmearing applied')

figure(3)
plot(median(rot90(true_image)))
figure(4)
plot(median(rot90(desmeared_image)))
    
fprintf('Image: %d Leading Blank: %d Trailing blank: %d\n', image_index, header.BlankLeadingValue, header.BlankTrailingValue);