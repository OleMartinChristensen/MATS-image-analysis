function [true_image] = get_true_image_from_compensated (image, header)

% Calculate true image by removing readout offset, pixel blank value and
% normalizaing the signal level according to readout time

% Remove gain
true_image = image * 2^bitand(header.Gain,255);

% Go throught the columns
for j_c=1:header.NCol + 1
    % Remove blank values and readout offsets
    true_image(1:header.NRow,j_c)= true_image(1:header.NRow,j_c) - ...
        2^header.NColBinFPGA*(header.BlankTrailingValue-128) - 128;
end

end