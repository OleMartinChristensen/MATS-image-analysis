function [image] = compensate_bad_columns(image, header)

%
% this is a function compensates bad columns if the image
%

ncol=header.NCol + 1;
nrow=header.NRow;

ncolskip=header.NColSkip;

ncolbinC=header.NColBinCCD;
ncolbinF=2^header.NColBinFPGA;

% Change to Leading if Trailing does not work properly
blank=header.BlankTrailingValue;

gain=2^bitand(header.Gain,255);

if ncolbinC==0 % no binning means beaning of one.
    ncolbinC=1;
end;

if ncolbinF==0 % no binning means beaning of one.
    ncolbinF=1;
end;

% Bad column analysis
[n_read, n_coadd] = binning_bc(ncol,ncolskip,ncolbinF,ncolbinC,header.BadCol);

if ncolbinC > 1
    for j_c=1:ncol
        if (ncolbinC*ncolbinF ~= n_coadd(j_c))
            % Remove gain adjustment
            image(1:nrow,j_c)= image(1:nrow,j_c)*gain;
            
            % Remove added superpixel value due to bad columns and readout offset
            image(1:nrow,j_c)= image(1:nrow,j_c) - n_read(j_c)*(blank-128) - 128;

            % Multiply by number of binned column to actual number readout ratio
            image(1:nrow,j_c)=image(1:nrow,j_c) * ((ncolbinC*ncolbinF)/n_coadd(j_c));

            % Add number of FPGA binned
            image(1:nrow,j_c)=image(1:nrow,j_c) + ncolbinF*(blank-128) + 128;
            
            % Add gain adjustment back
            image(1:nrow,j_c)= image(1:nrow,j_c)/gain;
            
            fprintf('Col: %d, n_read: %d, n_coadd: %d, binned pixels: %d\n', j_c, n_read(j_c), n_coadd(j_c), ncolbinC*ncolbinF); 
        end
    end
end

end