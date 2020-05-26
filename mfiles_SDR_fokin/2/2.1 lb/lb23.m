% ������������� ���������� ������� rxsdr ���������� RTL-SDR
rxsdr = comm.SDRRTLReceiver('0',...
    'CenterFrequency',88.9e6,...    
    'SampleRate',250000, ...
    'SamplesPerFrame',2048,...
    'EnableTunerAGC',true,...
    'OutputDataType','double');
% ����� �������� ���������� ������� rxsdr ���������� RTL-SDR
radioInfo = info(rxsdr)
% ����� 10 ������ ��������� �������� rxsdr ���������� RTL-SDR
for p=1:10
    rxdata1 = rxsdr();
end
% ����������� ����������� �������
rxsdr.CenterFrequency = 103.1e6;
% ����� �������� ���������� ������� rxsdr ���������� RTL-SDR
radioInfo = info(rxsdr)
% ����� 10 ������ ��������� �������� �� ����� ������� 103.1e6
for p=1:10
    rxdata2 = rxsdr();
end
% ������������ ���������� RTL-SDR �� ���������� rxsdr
release(rxsdr);