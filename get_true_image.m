function [true_image] = get_true_image (image, header)

% Calculate true image by removing readout offset, pixel blank value and
% normalizaing the signal level according to readout time

ncolbinC=header.NColBinCCD;
if (ncolbinC == 0)
    ncolbinC = 1;
end

% Remove gain
true_image = image * 2^bitand(header.Gain,255);

% Bad column analysis
[n_read, n_coadd] = binning_bc(header.NCol + 1,header.NColSkip,2^header.NColBinFPGA,ncolbinC,header.BadCol);

% Go throught the columns
for j_c=1:header.NCol + 1
    % Remove blank values and readout offsets
    true_image(1:header.NRow,j_c)= true_image(1:header.NRow,j_c) - n_read(j_c)*(header.BlankTrailingValue-128) - 128;
    
    % Compensate for bad columns
    true_image(1:header.NRow,j_c)= true_image(1:header.NRow,j_c) * (2^header.NColBinFPGA*ncolbinC/n_coadd(j_c));
end

end