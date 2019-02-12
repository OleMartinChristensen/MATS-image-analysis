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

blank=header.BlankLeadingValue + 10
blank_off=blank-128;
zerolevel=header.ZeroLevel;

gain=2^bitand(header.Gain,255);

bad_columns=header.BadCol;

if nrowbin==0 % no binning means beaning of one.
    nrowbin=1;
end;

if ncolbinC==0 % no binning means beaning of one.
    ncolbinC=1;
end;

if ncolbinF==0 % no binning means beaning of one.
    ncolbinF=1;
end;

ncolbintotal=ncolbinC*ncolbinF;

image=zeros(nrow, ncol);

image(:,:)=128;                         % offset

for j_r=1:nrow
    for j_br=1:nrowbin                 % account for row binning on CCD
        for j_c=1:ncol
            image(j_r,j_c)=image(j_r,j_c) + blank_off;  % here we add the blank value
            for j_bc=1:ncolbintotal        % account for column binning
                if ismember((j_c-1)*ncolbinC*ncolbinF + j_bc + ncolskip, bad_columns + 1)% Why + 1?
                    continue
                else
                    try
                        % Add only the actual signal from every pixel (minus blank)
                        image(j_r,j_c)=image(j_r,j_c) - blank + ...
                            reference_image((j_r-1)*nrowbin+j_br+nrowskip, ...
                            (j_c-1)*ncolbinC*ncolbinF + j_bc + ncolskip);
                    catch
                        image(j_r,j_c)=blank;
                    end
                end
            end;
        end;
    end;
end;

image = image/gain;

end