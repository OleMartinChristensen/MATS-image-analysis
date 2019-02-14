
function [image,header,img_flag] = readimg(filename)
fileID = fopen(filename);
data_arr = fread(fileID, '*ubit16');
fclose(fileID) ;
% Convert header to binary
header_bin = dec2bin(double(data_arr(1:12)),16);
% Read header:
Frame_count = bin2dec(header_bin(1,:));
NRow = bin2dec(header_bin(2,:));
NRowBinCCD = bin2dec(header_bin(3,11:16));
NRowSkip = bin2dec(header_bin(4,9:16));
NCol = bin2dec(header_bin(5,:));
NColBinFPGA = bin2dec(header_bin(6,3:8));
NColBinCCD = bin2dec(header_bin(6,9:16));
NColSkip = bin2dec(header_bin(7,6:16));
N_flush = bin2dec(header_bin(8,:));
Texposure_MSB = bin2dec(header_bin(9,:));
Texposure_LSB = bin2dec(header_bin(10,:));
Gain = bin2dec(header_bin(11,:));
SignalMode = bitand(Gain,4096);
Temperature_read = bin2dec(header_bin(12,:));

% Read image
if length(data_arr) < NRow*(NCol+1)/(2^(NColBinFPGA))
    img_flag = 0;
    image = 0;
    Noverflow = 0;
    BlankLeadingValue = 0;
    BlankTrailingValue = 0;
    ZeroLevel = 0;
    
    Reserved1 = 0;
    Reserved2 = 0;
    
    Version = 0;
    VersionDate = 0;
    NBadCol = 0;
    BadCol = 0;
    Ending = 'Wrong size';
else
    img_flag = 1;
    image = reshape(double(data_arr(12+1:NRow*(NCol+1)+12)), [NCol+1,NRow]);
    image = image';
    
    % Trailer
    trailer_bin = dec2bin(double(data_arr(NRow*(NCol+1)+12+1:end)),16);
    
    Noverflow = bin2dec(trailer_bin(1,:));
    BlankLeadingValue = bin2dec(trailer_bin(2,:));
    BlankTrailingValue = bin2dec(trailer_bin(3,:));
    ZeroLevel = bin2dec(trailer_bin(4,:));
    
    Reserved1 = bin2dec(trailer_bin(5,:));
    Reserved2 = bin2dec(trailer_bin(6,:));
    
    Version = bin2dec(trailer_bin(7,:));
    VersionDate = bin2dec(trailer_bin(8,:));
    NBadCol = bin2dec(trailer_bin(9,:));
    BadCol = [];
    Ending = bin2dec(trailer_bin(end,:));
    
    if NBadCol>0
        BadCol = zeros(1,NBadCol);
        for k_bc = 1:NBadCol
            BadCol(k_bc) =  bin2dec(trailer_bin(9+k_bc,:));
        end
    end
end
header = struct(...
    'Size', length(data_arr),...
    'Frame_count', Frame_count,...
    'NRow', NRow,...
    'NRowBinCCD', NRowBinCCD,...
    'NRowSkip', NRowSkip,...
    'NCol', NCol,...
    'NColBinFPGA', NColBinFPGA,...
    'NColBinCCD', NColBinCCD,...
    'NColSkip', NColSkip,...
    'N_flush', N_flush,...
    'Texposure_MSB', Texposure_MSB,...
    'Texposure_LSB', Texposure_LSB,...
    'Gain', bitand(Gain,255),...
    'SignalMode', SignalMode,...
    'Temperature_read', Temperature_read,...
    'Noverflow', Noverflow,...
    'BlankLeadingValue', BlankLeadingValue,...
    'BlankTrailingValue', BlankTrailingValue,...
    'ZeroLevel', ZeroLevel,...
    'Reserved1', Reserved1,...
    'Reserved2', Reserved2,...
    'Version', Version,...
    'VersionDate', VersionDate,...
    'NBadCol', NBadCol,...
    'BadCol', BadCol,...
    'Ending', Ending);

end