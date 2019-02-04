

blanks_l=zeros(726,1);
blanks_t=zeros(726,1);
zero_l=zeros(726,1);
ncols=zeros(726,1);
nrows=zeros(726,1);

ncolbin=zeros(726,1);
nrowbin=zeros(726,1);


p_offsets=zeros(726,1);
p_scales =zeros(726,1);
p_std    =zeros(726,1);



[image,header] = readimgpath('D:/MATS/2019-02-01 param1/', 0, 0);

ref_image=image;

for jj=1:726
     jj
    [image,header] = readimgpath('D:/MATS/2019-02-01 param1/', jj, 0);
    blanks_l(jj)=header.BlankLeadingValue;
    blanks_t(jj)=header.BlankTrailingValue;
    ncols(jj)=header.NCol;
    nrows(jj)=header.NRow;

    ncolbin(jj)=header.NRowBinCCD;
    nrowbin(jj)=header.NColBinCCD;
    
    zero_l(jj)=header.ZeroLevel;
    
    prim=predict_image(ref_image, header);
    
    [t_off, t_scl, t_std] = compare_image(prim, image);
    
    p_offsets(jj)=t_off;
    p_scales(jj) =t_scl;
    p_std(jj)    =t_std;
    
end