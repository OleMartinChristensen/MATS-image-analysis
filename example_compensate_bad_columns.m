
image_index =9;
image_display_adjustment = 50;

[image,header] = readimgpath('H:/Workspace/MATS/FFT/2019-02-08 rand6/', image_index, 0);
    
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

prim=compensate_bad_columns(image, header);

figure(2)
colormap jet
hold off
subplot(1,1,1)
imagesc(prim)
pred_mean_img = mean(mean(prim));
caxis([pred_mean_img-image_display_adjustment,pred_mean_img+image_display_adjustment])
colorbar();
title('With bad columns compensated')
xlabel('Pixels')
ylabel('Pixels')
    
fprintf('Leading Blank: %d Trailing blank: %d\n', header.BlankLeadingValue, header.BlankTrailingValue);
fprintf('nrowbin: %d, ncolbinC: %d, ncolbinF: %d, gain: %d\n', header.NRowBinCCD, header.NColBinCCD, header.NColBinFPGA, header.Gain);
