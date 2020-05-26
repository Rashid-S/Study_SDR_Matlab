clear all; clc;
Fs = 200e3; % ������� �������������, ������� � �
% ������������� ���������� ���������
TxSine.Frequency       = 100; 
TxSine.Amplitude       = 1;
TxSine.ComplexOutput   = true;
TxSine.SampleRate      = Fs; 
TxSine.SamplesPerFrame = 2048;
TxSine.OutputDataType  = 'double';
% ������������� ���������� ������� dsp.SineWave
hSineSource = dsp.SineWave (...
    'Frequency',       TxSine.Frequency, ...
    'Amplitude',       TxSine.Amplitude,...
    'ComplexOutput',   TxSine.ComplexOutput, ...
    'SampleRate',      TxSine.SampleRate, ...
    'SamplesPerFrame', TxSine.SamplesPerFrame, ...
    'OutputDataType',  TxSine.OutputDataType);
% ����������� ������������� ���������� USRP
connectedRadios = findsdru;
% ������������� ���� ���������� USRP
txradio.Platform = connectedRadios.Platform;
% ������������� ��������� ������ ���������� USRP
txradio.SerialNum = connectedRadios.SerialNum;
% ������������� ���������� �������� ���������� USRP
txradio.MasterClockRate = 20e6;  % �������� �������, ��
txradio.CenterFrequency = 450e6; % ����������� �������
txradio.Gain            = 40;    % ��������, �� 
% ����������� ������������
txradio.InterpolationFactor = txradio.MasterClockRate/Fs;
% ������������� ���������� ������� comm.SDRuTransmitter
txradio = comm.SDRuTransmitter( ...
      'Platform',            txradio.Platform, ...
      'SerialNum',           txradio.SerialNum, ...
      'MasterClockRate',     txradio.MasterClockRate, ...
      'CenterFrequency',     txradio.CenterFrequency -...
                                    TxSine.Frequency,...
      'Gain',                txradio.Gain,...
      'InterpolationFactor', txradio.InterpolationFactor);
% ������������� ���������� ������� dsp.SpectrumAnalyzer 
hSpectrumAnalyzer = dsp.SpectrumAnalyzer(...
    'Name',             '������ ���������� ���������',...
    'Title',            '������ ���������� ���������',...
    'FrequencySpan',    'Full', ...
    'SampleRate',       Fs, ...
    'SpectralAverages', 50, ...
    'FrequencySpan',    'Start and stop frequencies', ...
    'StartFrequency',   -10e3, ...
    'StopFrequency',    10e3);
% �������� ��������� ��� ��������� ����� ������
TotalFrames = 20000;
for iFrame = 1: TotalFrames
    sinewave =  hSineSource();  % ������������ ���������
    txradio(sinewave);          % �������� ��������� � ���������
    hSpectrumAnalyzer(sinewave);% ������ ���������
end
% ������������ ��������� ��������
release(txradio); release(hSineSource); 
release(hSpectrumAnalyzer); 