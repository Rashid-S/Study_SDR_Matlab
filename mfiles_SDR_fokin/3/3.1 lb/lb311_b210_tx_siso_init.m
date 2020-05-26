% ������������� �������������� ����������� �� USRP B210
txradio = ...
    comm.SDRuTransmitter('Platform','B210','SerialNum','F4E642');
txradio.ChannelMapping  = 1;        % ����� �������
txradio.CenterFrequency = 2.5e9;    % ����������� �������
txradio.LocalOscillatorOffset = 0;  % ����� ������� ��
txradio.Gain = 20;                  % ��
txradio.PPSSource = 'Internal';     % ���������� �������� PPS
txradio.ClockSource = 'Internal';   % �����. �������� �����.
txradio.MasterClockRate = 32e6;     % �������� �������
txradio.InterpolationFactor = 512;  % ����������� ������������ 
txradio.TransportDataType='int16';  % ��� ������������ ������
txradio.EnableBurstMode = false;    % ����. ��������� ������
% ������������ ���������� ������� txradio
release(txradio);