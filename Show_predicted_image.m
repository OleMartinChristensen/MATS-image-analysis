
[ref_hsm_image,ref_header] = readimgpath('H:/Workspace/MATS/FFT/2019-02-08 rand6/', 0, 0);

[ref_lsm_image,ref_header] = readimgpath('H:/Workspace/MATS/FFT/2019-02-08 rand6/', 4, 0);

image_index = 17;

image_display_adjustment = 200;
[image,header] = readimgpath('H:/Workspace/MATS/FFT/2019-02-14 bin2/', image_index, 0);

    
figure(1)
colormap jet
hold off
subplot(1,1,1)
imagesc(image)
mean_img = mean(mean(image));
caxis([mean_img-image_display_adjustment,mean_img+image_display_adjustment])
colorbar();
title('CCD image')
xlabel('Pixels')
ylabel('Pixels')

if header.Ending == 'Wrong size'
    disp("Something wrong with the image");
else
    prim=predict_image(ref_hsm_image, hsm_header, ref_lsm_image, lsm_header, header);

    figure(2)
    colormap jet
    hold off
    subplot(1,1,1)
    imagesc(prim)
    pred_mean_img = mean(mean(prim));
    caxis([pred_mean_img-image_display_adjustment,pred_mean_img+image_display_adjustment])
    colorbar();
    title('Generated from reference')
    xlabel('Pixels')
    ylabel('Pixels')
end

fprintf('Image %d CCD image mean: %d, Predicted image mean: %d, Blank: %d\n', image_index, mean_img, pred_mean_img, header.BlankLeadingValue);
fprintf('nrowbin: %d, ncolbinC: %d, ncolbinF: %d, gain: %d\n', header.NRowBinCCD, header.NColBinCCD, header.NColBinFPGA, header.Gain);
