% 2015 10 23  Process beampattern data and save to folder

pname = 'E:\Desktop\bp_proc_main_folder';
fname = 'SPECIES_DATE_file_match.xlsx';

trial_to_proc = 1;
chk_indiv_call = 0;
track_cut_idx = 1:400;
save_dir = ['E:\Desktop\bp_proc_main_folder\proc_output'];
if ~exist(save_dir,'dir')
    mkdir(save_dir);
end
load('bpf30.mat');

axis_orient = [1 2 3];%axis orientation ([3 1 2] for small space beampatter 2015 data)

zero_bat2mic_angle=1;%mics are pointed at bat at all times

head_aim_prescribed=1;%head aim is prescribed (suing value for head_aim_prescribe and head_n_prescribe)

for tnum = trial_to_proc
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    data.track.fs = 100;   % frame rate [Hz]
    data.track.smooth_len = 10;  % number of points used to smooth tracks
    data.track.head_aim_est_time_diff = 50; % [ms] time span between points used for estimating head aim from bat position
    data.track.head_aim_prescribe = [0,-1,0];  % precribed head aim vector (only used in 1-marker case, ignored in 3-marker case)
    data.track.head_n_prescribe = [0 0 1];% precribed head normal vector (only used in 1-marker case, ignored in 3-marker case)
    
    
    data.param.tempF = 75;  % temperature [deg F]
    data.param.humid = 50;  % humidity (relative in %)
    data.param.extract_call_len = 5;  % [ms]
    data.param.call_short_len = 0.5;  % desired length of extracted call [sec]
    data.param.call_portion_front = 0.2;         % proportion of extracted call before the peak
    data.param.tolernace = 2;
    data.param.tukeywin_proportion = 0.25;  % proportional of tukeywin for call tapering
    data.param.dura_flag = 1;   % 1-use duration marked in the mic detect file (FM bats)
                                % 0-use default detection stuff (Rousettus)
    data.param.click_th = 0.1;  % threshold for extracting click ranges, only used when dura_flag=1
    data.param.click_bpf = bpf30;     % bandpass filter for use in click range estimation, only used when dura_flag=1
    data.param.mic_floor_idx = [4,5,7,17,24,26,27];  % index of mics on floor, used to estimate head normal vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    data = bp_proc(data,pname,fname,tnum,chk_indiv_call,track_cut_idx,axis_orient,zero_bat2mic_angle,head_aim_prescribed);
    ff = [data.files.mic_data,'_bp_proc.mat'];
    save(fullfile(save_dir,ff),'-struct','data');
    
    clear data
end

