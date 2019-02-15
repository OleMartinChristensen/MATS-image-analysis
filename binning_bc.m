function [n_read, n_coadd] = binning_bc(Ncol,Ncolskip,NcolbinFPGA,NcolbinCCD,BadColumns);

%
% a routine to estimate the correction factors for column binning with
% bad columns
%
% n_read  - array, containing the number of individually read superpixels
%           contributing to the given superpixel
% n_coadd - array, containing the number of co-added individual pixels
%
% Input - as per ICD. BadColumns - array containing the index of bad
%           columns (the index of first column is 0)
%

n_read =1:Ncol;
n_coadd=1:Ncol;

col_index=Ncolskip;

n_read(:)=0;
n_coadd(:)=0;

for j_col=1:Ncol 
    for j_FPGA=1:NcolbinFPGA
        continuous=0;
        for j_CCD=1:NcolbinCCD
            if ismember(col_index, BadColumns)
                if (continuous == 1)
                    n_read(j_col)=n_read(j_col)+1;
                end
                continuous=0;
            else
                continuous = 1;
                n_coadd(j_col)=n_coadd(j_col)+1;
            end
            
            col_index=col_index + 1;
        end
        if (continuous == 1) 
            n_read(j_col)=n_read(j_col)+1;
        end
    end
end
