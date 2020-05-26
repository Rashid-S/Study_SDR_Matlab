% C����������� ��������� ������, 
% ������������ ����������� RTL-SDR 
% ����� ���������� ���������������� 
% �������� �������������� �� �������
clear all; clc;
% ��������� ���������� RTL-SDR
location        = 'bonch_spb';% ��������������
start_freq      = 30e6;       % ������ ������� ������������
stop_freq       = 40e6;     % ������� ������� ������������
rtlsdr.id       = '0';        % �������������
rtlsdr.fs       = 2.4e6;      % ������� �������������, ��
rtlsdr.gain     = 40;         % ��������, ��
rtlsdr.frmlen   = 4096;       % ������ ��������� �����, �������
rtlsdr.datatype = 'single';   % ��� �������� ������
rtlsdr.ppm      = 0;          % ��������� ������ �������, ppm
% ��������� ������������ ��������� ������
nfrmhold        = 20;         % ����� ����������� ������
fft_hold        = 'avg';      % ��������� ���: "max" ��� "avg"
nfft            = 4096;       % ����������� ���
dec_factor      = 16;         % �����. ��������� ��� ������� 
% ���������� ��� ��� ����������� 
% ������� ���������� ������� (roll-off) 
overlap         = 0.5; 
% ����� ������ ��� ������ 
% (�������) ������ ����� �������������  
nfrmdump        = 100;         
% �������� ������������ � ��
rtlsdr.tunerfreq  = start_freq:rtlsdr.fs*overlap:stop_freq;
% �������� �������� ������� ��������� ������������
if( max(rtlsdr.tunerfreq) < stop_freq )
    % ���� ������ ��������� ������������ ������ ������� 
    % ������� ������������, �����������  rtlsdr.fs*overlap
    rtlsdr.tunerfreq(length(rtlsdr.tunerfreq)+1) = ...
        max(rtlsdr.tunerfreq)+rtlsdr.fs*overlap;
end
% ������ ����� ������������ ��������� 
% RTL-SDR �� ����� ������ ���������
nretunes = length(rtlsdr.tunerfreq); 
% ���������� �� �������
freq_bin_width = (rtlsdr.fs/nfft);  
% ������������ ����� ������ ������������ ���������
freq_axis = ...
    (rtlsdr.tunerfreq(1)-rtlsdr.fs/2*overlap  : ...
    freq_bin_width*dec_factor  :...
    (rtlsdr.tunerfreq(end)+rtlsdr.fs/2*overlap)-...
    freq_bin_width)/1e6;
% �������-������ �������� nfft ��� �������� ��� 
rtlsdr.data_fft = zeros(1,nfft);
% ������� ������� [nfrmhold x nfft*overlap] ��� ��������
% ������ ������������������ ��� � ������������ ����������
fft_reorder = zeros(nfrmhold,nfft*overlap);  
% ������� ������� [nretunes x nfft*overlap/dec_factor] 
% ��� �������� ���� ������ ��� � ������������ ����������
fft_dec = zeros(nretunes,nfft*overlap/dec_factor);  
% ������������� ���������� ������� comm.SDRRTLReceiver
obj_rtlsdr = comm.SDRRTLReceiver(...
    rtlsdr.id,...
    'CenterFrequency',      rtlsdr.tunerfreq(1),...
    'EnableTunerAGC',       false,...
    'TunerGain',            rtlsdr.gain,...
    'SampleRate',           rtlsdr.fs, ...
    'SamplesPerFrame',      rtlsdr.frmlen,...
    'OutputDataType',       rtlsdr.datatype ,...
    'FrequencyCorrection',  rtlsdr.ppm );
% ������������� ���-������� ����������
obj_decmtr = dsp.FIRDecimator(...
    'DecimationFactor',     dec_factor,...
    'Numerator',            fir1(300,1/dec_factor));

% ������������� ������� ������ ������������
tic; disp(' '); 
tune_progress = 0; % ���������� ���������� ������������
% ���� �� ����� ������������
for ntune = 1:1:nretunes
    % ��������� ���������� RTL-SDR �� ����������� �������
    obj_rtlsdr.CenterFrequency = rtlsdr.tunerfreq(ntune);
    % ������������ ������ ��� ������� ������
    for frm = 1:1:nfrmdump
        % ����� ����� ������ ����������� RTL-SDR
        rtlsdr.data = obj_rtlsdr();
    end
    % ����������� ������� ����������� �������
    disp([' fc = ',...
        num2str(rtlsdr.tunerfreq(ntune)/1e6),' ���']);
    
    % ���� �� ����� ����������� ������ nfrmhold 
    for frm = 1:1:nfrmhold
        % ����� ����� ������ ����������� RTL-SDR
        rtlsdr.data = step(obj_rtlsdr);
        % ���������� ���������� ������������
        rtlsdr.data = rtlsdr.data - mean(rtlsdr.data);
        % ��� // find fft [ +ve , -ve ]
        rtlsdr.data_fft = abs(fft(rtlsdr.data,nfft))';
        % ����������������� ���: ������ � ������� 
        % fft_reorder nfrmhold ������ ���; � ���������� 
        % ���������� ������� fft_reorder �������� 
        % [nfrmhold x overlap*nfft] � ���������������� 
        % ��������� �� ������������� � ������������� 
        % �������� [ -ve , +ve ]
        % -ve
        fft_reorder(frm,(1:(overlap*nfft/2))) = ...
            rtlsdr.data_fft((overlap*nfft/2)+(nfft/2)+1:end );
        % +ve
        fft_reorder(frm,((overlap*nfft/2)+1:end )) = ...
            rtlsdr.data_fft(1:(overlap*nfft/2));             
    end
    % ��������� ������� ��� � ������� fft_reorder 
    % �� �������; � ���������� ���������� ������-������ 
    % fft_reorder_proc �������� [1 x overlap*nfft] 
    if strcmp(fft_hold,'avg')       % ���������� ��������
        fft_reorder_proc = mean(fft_reorder); 
    elseif strcmp(fft_hold,'max')    % ���������� ���������
        fft_reorder_proc = max(fft_reorder); 
    end
    % ��������� ������� ��� � ������-������ fft_reorder;
    % � ���������� ���������� ������-������ �������� 
    % [1 x overlap*nfft/dec_factor], ������� ������������
    % � ������� fft_dec �������� 
    % [ntune x overlap*nfft/dec_factor] c �������� ntune
    fft_dec(ntune,:) = step(obj_decmtr,fft_reorder_proc')';
    % �������� ���������� ������������ 
    % � % ������ 10% (ntune*10/nretunes)
    if floor(ntune*10/nretunes) ~= tune_progress
        tune_progress = floor(ntune*10/nretunes);
        disp([' �������������� = ',...
            num2str(tune_progress*10),'%']);
    end
end
% ������������������ ������ � �������-������
fft_masterreshape = ...
    reshape(fft_dec',1,ntune*nfft*overlap/dec_factor); 
y_data = ((fft_masterreshape/nfft).^2)/50; 
y_data_dbm = 10*log10(((fft_masterreshape/nfft).^2)/50);
% ���������� ������� ����������������� ���������
subplot(2,1,1); 
plot(freq_axis,y_data,'r','linewidth',2); axis('tight'); 
xlabel('�������, ���'); 
ylabel('�������� (�������� 50 ��), ��'); grid on;
title(['��������: ',num2str(start_freq/1e6),' ��� - ',...
    num2str(stop_freq/1e6), ' ���. Bin Width = ',...
    num2str(freq_bin_width*dec_factor/1e3),...
    ' ���. BinsNum = ',num2str(length(freq_axis)),...
    '. ������������ ', num2str(nretunes)]);
%xlim([start_freq/1e6,stop_freq/1e6]);
subplot(2,1,2); 
plot(freq_axis,y_data_dbm,'linewidth',2); axis('tight'); 
xlabel('�������, ���'); 
ylabel('�������� (�������� 50 ��), ��'); grid on;
% ������������� ������� ���������� ������������
disp(' '); disp(['  run time = ',num2str(toc),'s']); disp(' ');
% ���������� ������ ������������ � ����
filename = ['rtlsdr.rx_',num2str(start_freq/1e6),...
    'MHz_',num2str(stop_freq/1e6),'MHz_',location,'.fig'];
savefig(filename);