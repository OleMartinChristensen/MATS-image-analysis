% MATS data chain for raw images
% This script deals with
% 1. Image prediction from reference image according to header
% 2. Applying bad column correction and removing offsets to get "true images"
% 3. Compensating bad columns in MATS payload OBC
% 4. Getting "true image" from compensated one in MATS payload OBC


image_display_adjustment = 100;

% Import two reference images for the CCD in high and low signal modes
% Reference image depends on the temperature
[ref_hsm_image,hsm_header] = readimgpath('H:/Workspace/MATS/FFT/2019-02-08 rand6/', 0, 0);
[ref_lsm_image,lsm_header] = readimgpath('H:/Workspace/MATS/FFT/2019-02-08 rand6/', 4, 0);

% Import the actual received from CRB
[recv_image,recv_header] = readimgpath('H:/Workspace/MATS/FFT/2019-02-08 rand6/', 30, 0);


% Step 1
% Predict the received from refernce image according to header
[pred_image, pred_header] = predict_image(ref_hsm_image, hsm_header, ref_lsm_image, lsm_header, recv_header);

% Step 2
% Make actual image out both received and predicted images
% These can be compare if no compression is used
recv_true_image = get_true_image (recv_image, recv_header);
recv_true_image = desmear_true_image(recv_true_image, recv_header);

pred_true_image = get_true_image (pred_image, pred_header);

% Step 3
% Bad column compensation for MATS payload OBC
recv_comp_image = compensate_bad_columns(recv_image, recv_header);

% Step 4
% Getting "true image" from compensated one in MATS payload OBC
true_comp_image = get_true_image_from_compensated(recv_comp_image, recv_header);
true_comp_image = desmear_true_image(true_comp_image, recv_header);

figure(1)
colormap jet
hold off
subplot(1,1,1)
imagesc(recv_image)
mean_img = mean(mean(recv_image));
caxis([mean_img-image_display_adjustment,mean_img+image_display_adjustment])
colorbar();
title('CCD image')

figure(2)
colormap jet
hold off
subplot(1,1,1)
imagesc(pred_image)
caxis([mean_img-image_display_adjustment,mean_img+image_display_adjustment])
colorbar();
title('Predicted image')

figure(3)
colormap jet
hold off
subplot(1,1,1)
imagesc(recv_true_image)
true_mean_img = mean(mean(recv_true_image));
caxis([true_mean_img-image_display_adjustment,true_mean_img+image_display_adjustment])
colorbar();
title('CCD true image')

figure(4)
colormap jet
hold off
subplot(1,1,1)
imagesc(pred_true_image)
caxis([true_mean_img-image_display_adjustment,true_mean_img+image_display_adjustment])
colorbar();
title('Predicted true image')

figure(5)
colormap jet
hold off
subplot(1,1,1)
imagesc(recv_comp_image)
caxis([mean_img-image_display_adjustment,mean_img+image_display_adjustment])
colorbar();
title('Compensated in OBC image')

figure(6)
colormap jet
hold off
subplot(1,1,1)
imagesc(true_comp_image)
caxis([true_mean_img-image_display_adjustment,true_mean_img+image_display_adjustment])
colorbar();
title('True image after compensation in OBC software')
