% ������������� �������������� ��������� �� USRP B210
rxradio = ...
    comm.SDRuReceiver('Platform','B210','SerialNum','F4E642');
rxradio.ChannelMapping  = 1;       % ����� �������
rxradio.CenterFrequency = 2.5e9;   % ����������� �������
rxradio.LocalOscillatorOffset = 0; % ����� ������� ��
rxradio.Gain = 20;                 % ��
rxradio.PPSSource = 'Internal';    % ���������� �������� PPS
rxradio.ClockSource = 'Internal';  % �����. �������� �����.
rxradio.MasterClockRate = 32e6;    % �������� ������� 
rxradio.DecimationFactor = 512;    % ����������� ��������� 
rxradio.TransportDataType='int16'; % ��� ������������ ������
% ��� ���. ������
rxradio.OutputDataType = 'Same as transport data type'; 
rxradio.SamplesPerFrame = 362;      % ����� ������� �� ���� 
rxradio.EnableBurstMode = false;    % ����. ��������� ������
% ������������ ���������� ������� rxradio
release(rxradio);