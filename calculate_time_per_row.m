function [T_row_extra, T_delay] = calculate_time_per_row(header)

% timing.m
%
% This script provides some useful timing data
% for the CCD readout
%
% Note that minor "transition" states may have been omitted
% resulting in somewhat shorter readout times (<0.1 %).
%
%   Default timing setting is:
%   ccd_r_timing <= x"A4030206141D"&x"010303090313";
%
%   All pixel timing setting is the final count of a
%   counter that starts at 0, so the number of clock
%   cycles exceeds the setting by 1

% Image parameters
ncol=header.NCol + 1;
ncolbinC=header.NColBinCCD;
if (ncolbinC == 0)
    ncolbinC = 1;
end
ncolbinF=2^header.NColBinFPGA;

nrow=header.NRow;
nrowbin=header.NRowBinCCD;
if (nrowbin == 0)
    nrowbin = 1;
end
nrowskip=header.NRowSkip;

n_flush=header.N_flush;

% Timing settings
full_timing = 1; %TODO

% Full pixel readout timing
time0       = 1+   19; % x13%TODO
time1       = 1+    3; % x03%TODO
time2       = 1+    9; % x09%TODO
time3       = 1+    3; % x03%TODO
time4       = 1+    3; % x03%TODO
time_ovl    = 1+    1; % x01%TODO

% Fast pixel readout timing
timefast    = 1+    2; % x02%TODO
timefastr   = 1+    3; % x03%TODO

% Row shift timing
row_step       = 1+   164; % xA4 %TODO

clock_period = 30.517; % master clock period, ns 32.768 MHz

% There is one extra clock cycle, effectively adding to time0 %
Time_pixel_full = (1 + time0 + time1 + time2 + time3 + time4 + ...
    3*time_ovl)*clock_period;

% This the fast timing pixel period
Time_pixel_fast = (1 + 4*timefast + 3*time_ovl + timefastr)*clock_period;

%
%
%
% here we calculage the number of fast and slow pixels
%  NOTE: the effect of bad pixels is disregarded here
if (full_timing == 1)
    n_pixels_full = 2148;
    n_pixels_fast = 0;
else
    if (ncolbinC < 2) % no CCD binning
        n_pixels_full = ncol * ncolbinF;   
    else % there are two "slow" pixels for one superpixel to be read out.
        n_pixels_full = 2*ncol * ncolbinF; 
    end
    n_pixels_fast = 2148 - n_pixels_full;
end

%
%
%
%  Time to read out one row
T_row_read = n_pixels_full*Time_pixel_full + n_pixels_fast*Time_pixel_fast;

% Shift time of a signle row
T_row_shift = (64 + row_step * 10)*clock_period;

% time of the exposure start delay from the start_exp signal % n_flush=1023;
T_delay = T_row_shift * n_flush;

% Total time of the readout
T_readout = T_row_read*(nrow+nrowskip+1) + T_row_shift*(1+ nrowbin*nrow);

%
%
%
% "Smearing time"
% (This is the time that any pixel collects electrons in a wrong
% row, during the shifting). For smearing correction, this is the
% "extra exposure time" for each of the rows.
T_row_extra = (T_row_read + T_row_shift*nrowbin) / 1e9;

% all times are displayed in seconds
disp('Row read time: ');
disp(T_row_read/1e9)
disp('Total readout time: ');
disp(T_readout/1e9)
disp('Smearing time: ');
disp(T_row_extra)

end
