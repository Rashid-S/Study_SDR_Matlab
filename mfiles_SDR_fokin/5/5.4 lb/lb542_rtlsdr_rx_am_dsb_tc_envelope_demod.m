rtlsdr_fc        = 1200.0e6; % ����������� ������� � ��
rtlsdr_gain      = 30;       % �������� � ��
rtlsdr_fs        = 240e3;    % ������� ������������� 
rtlsdr_ppm       = 47;       % ��������� ������� � ppm
rtlsdr_frmlen    = 256*25;   % ������ ����� ������ (������ 5)
rtlsdr_datatype  = 'single'; % ��� �������� ������
audio_fs         = 48e3;     % fs ����� �����������
sim_time         = 1;        % ����� ������������� � �
DownsampleFactor = 5;        % ����������� ���������
rtlsdr_fc = rtlsdr_fc-40e3;  % fc � ������ ������ 40 ���
rtlsdr_frmtime = rtlsdr_frmlen/rtlsdr_fs; % ����� �����
% ��������� ������ ��������� RTL-SDR
obj_rtlsdr = comm.SDRRTLReceiver(...
    'CenterFrequency', rtlsdr_fc,...
    'EnableTunerAGC', false,...
    'TunerGain', rtlsdr_gain,...
    'SampleRate', rtlsdr_fs, ...
    'SamplesPerFrame', rtlsdr_frmlen,...
    'OutputDataType', rtlsdr_datatype,...
    'FrequencyCorrection', rtlsdr_ppm);
% ��������� ������ �������-����������
obj_decmtr = dsp.FIRDecimator(...
    'DecimationFactor', DownsampleFactor,...
    'Numerator',...
    firpm(100, [0 15e3 20e3 (240e3/2)]/(240e3/2),...
                [1 1 0 0], [1 1], 20));
% ��������� ������ ���������� �������
obj_bpf = dsp.FIRFilter('Numerator',...
    firpm(50,[0,20e3,25e3,55e3,60e3,240e3/2]/(240e3/2),...
                [0 0 1 1 0 0],[1 1 1],20));
% ��������� ������ ������������� �����������
obj_audio = audioDeviceWriter(audio_fs);   
% ������ ����������� ������� ��������������� �������
obj_spectrummod   = dsp.SpectrumAnalyzer(...
    'Name', '�� �������������� �� ������ �� ��',...
    'Title', '�� �������������� �� ������ �� ��',...
    'SpectrumType', 'Power density',...
    'FrequencySpan', 'Full',...
    'ShowLegend', true,...
    'SampleRate', rtlsdr_fs);
% ������ ����������� ������� ����������������� �������
obj_spectrumdemod = dsp.SpectrumAnalyzer(...
    'Name', '���������������� �������������� ������ �� 0�',...
    'Title','���������������� �������������� ������ �� 0�',...
    'SpectrumType', 'Power density',...
    'FrequencySpan', 'Full',...
    'SampleRate', audio_fs);
% ��������� ������ ������������� ��� �����������
% ��������������� �� ������� �� �� 40 ��� � ��� �� ���������
scope1 = dsp.TimeScope( ...
  'NumInputPorts',2, ...
  'Name','�������������� ����������� ���������', ...
  'SampleRate',[rtlsdr_fs,audio_fs], ...
  'TimeDisplayOffset',[50/rtlsdr_fs,0],...
  'TimeSpanSource','Property', ...
  'TimeSpan',2, ...
  'YLimits',[-1 1]);
run_time = 0; % ������������� ������� �������������
while run_time < sim_time % ���� ������
    rtlsdr_data = obj_rtlsdr(); % ����� ����� ������
    % ��������� ���������� �� 
    % ��������������� �� ������� �� �� 40 ���
    data_bpf = obj_bpf(rtlsdr_data);
    % ����������� �������� ��������������� 
    % �� ������� �� �� �� � ����� ��������� ����������
    obj_spectrummod([rtlsdr_data,data_bpf]);
    % �������� ����������� ��������� 
    % �� ������ �������������� ���������
    env_mag = abs(data_bpf);
    data_dec = obj_decmtr(env_mag);
    % ������ �� ����������������� ������� �� 0�
    obj_spectrumdemod(data_dec);
    % �� �������������� �� ������ �� �� � ��� �� ���������
    scope1(real(data_bpf),data_dec);
    % ����������� ���������������� �����������
    obj_audio(data_dec);
    % ��������� ������� ������������� ������������� �����
    run_time = run_time + rtlsdr_frmtime;
end