

Nimages = 100;

imagetoskip = [0];

blanks_l=zeros(Nimages,1);
blanks_t=zeros(Nimages,1);
zero_l=zeros(Nimages,1);
ncols=zeros(Nimages,1);
nrows=zeros(Nimages,1);

ncolbin=zeros(Nimages,1);
nrowbin=zeros(Nimages,1);


p_offsets=zeros(Nimages,1);
p_scales =zeros(Nimages,1);
p_std    =zeros(Nimages,1);



[ref_hsm_image,ref_header] = readimgpath('H:/Workspace/MATS/FFT/2019-02-08 rand6/', 0, 0);

[ref_lsm_image,ref_header] = readimgpath('H:/Workspace/MATS/FFT/2019-02-08 rand6/', 4, 0);

for jj=1:Nimages
    if ismember(jj, imagetoskip)
        continue
    end
    try
        [image,header] = readimgpath('H:/Workspace/MATS/FFT/2019-02-08 rand6/', jj, 0);
    catch error_data
        fprintf('Image %d cannot be read\n', jj);
    end
            
    blanks_l(jj)=header.BlankLeadingValue;
    blanks_t(jj)=header.BlankTrailingValue;
    ncols(jj)=header.NCol;
    nrows(jj)=header.NRow;

    ncolbin(jj)=header.NRowBinCCD;
    nrowbin(jj)=header.NColBinCCD;
    
    zero_l(jj)=header.ZeroLevel;
    
    if (header.Ending == 'Wrong size') | (header.BlankLeadingValue == 0)
        continue
    end
    
    try
        prim=predict_image(ref_hsm_image ,ref_lsm_image, header);
        
        [t_off, t_scl, t_std] = compare_image(prim, image, header);
        
        p_offsets(jj)=t_off;
        p_scales(jj) =t_scl;
        p_std(jj)    =t_std;
    catch error_data
       fprintf('Image prediction did not work for image %d\n', jj);
    end
    
    
    
end