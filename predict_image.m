function [image] = predict_image(reference_image, header);

%
% this is a function to predict an image read out from the CCD
% with a given set of parameters, based on a reference image 
% (of size 511x2048)
%

ncol=header.NCol + 1;
nrow=header.NRow;

nrowskip=header.NRowSkip;
ncolskip=header.NColSkip;

nrowbin=header.NRowBinCCD;
ncolbinC=header.NColBinCCD;
ncolbinF=2^header.NColBinFPGA;

blank_off=blank-128;
blank=header.BlankLeadingValue + 10;
zerolevel=header.ZeroLevel;

if nrowbin==0 % no binning means beaning of one.
    nrowbin=1;
end;

if ncolbinC==0 % no binning means beaning of one.
    ncolbinC=1;
end;

if ncolbinF==0 % no binning means beaning of one.
    ncolbinF=1;
end;


image=zeros(nrow, ncol);

image(:,:)=128;                         % offset

for j_r=1:nrow
    for j_br=1:nrowbin                 % account for row binning on CCD
        for j_c=1:ncol
            for j_bcf=1:ncolbinF        % account for column binning in FPGA
                image(j_r,j_c)=image(j_r,j_c) + blank_off;  % here we add the blank
                for j_bcc=1:ncolbinC    % account for column binning on CCD
                    try
                        image(j_r,j_c)=image(j_r,j_c) - blank + ...
                            reference_image((j_r-1)*nrowbin+j_br+nrowskip, ...
                            (j_c-1)*ncolbinC*ncolbinF + ...
                            (j_bcf-1)*ncolbinF + j_bcc + ncolskip);
                    catch
                        image(j_r,j_c)=blank;
                    end
                end;
            end;
        end;
    end;
end;

end