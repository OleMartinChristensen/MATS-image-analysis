function [image] = predict_image(reference_image, lsm_image, header);

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

if header.SignalMode == 1
    reference_image = lsm_image;
end

image=zeros(nrow, ncol);

image(:,:)=128;                         % offset

finished_row = 0;
finished_col = 0;
for j_r=1:nrow
    for j_br=1:nrowbin                 % account for row binning on CCD
        for j_c=1:ncol
            image(j_r,j_c)=image(j_r,j_c) + ncolbinF*blank_off;  % Here we add the blank value
            for j_bc=1:ncolbintotal        % account for column binning
                if ismember((j_c-1)*ncolbinC*ncolbinF + j_bc + ncolskip, bad_columns + 1)% +1 because Ncol is +1
                    continue
                else
                    try
                        % Add only the actual signal from every pixel (minus blank)
                        image(j_r,j_c)=image(j_r,j_c) - blank + ...
                            reference_image((j_r-1)*nrowbin+j_br+nrowskip, ...
                            (j_c-1)*ncolbinC*ncolbinF + j_bc + ncolskip);
                    catch
                        % Out of reference image range
                        if (j_r-1)*nrowbin+j_br+nrowskip > 511
                            finished_row = 1;
                            image(j_r+1:nrow,j_c:ncol) = blank; 
                        elseif (j_c-1)*ncolbinC*ncolbinF + j_bc + ncolskip> 2048
                            finished_col = 1;
                            image(j_r,j_c+1:ncol) = blank; 
                        end
                        break
                    end
                end
            end;
            if finished_row | finished_col
                break
            end
        end;
        if finished_row
            break
        end
    end;
    if finished_row
        break
    end
end;

image = image/gain;

end