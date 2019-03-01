function [image] = desmear_true_image(image, header)

%
%

nrow=header.NRow;
ncol=header.NCol + 1;

% Calculate extra time per row
[T_row_extra, T_delay] = calculate_time_per_row(header);
T_exposure=header.Texposure;

for irow=2:nrow
   for krow=1:irow
     image(irow,1:ncol)=image(irow,1:ncol) - mean(image(krow,1:ncol))*(T_row_extra/T_exposure);
   end
end
% row 1 here is the first row to read out from the chip!


end