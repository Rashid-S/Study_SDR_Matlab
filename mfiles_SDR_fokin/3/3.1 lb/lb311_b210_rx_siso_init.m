% Инициализация одноканального приемника на USRP B210
rxradio = ...
    comm.SDRuReceiver('Platform','B210','SerialNum','F4E642');
rxradio.ChannelMapping  = 1;       % схема каналов
rxradio.CenterFrequency = 2.5e9;   % центральная частота
rxradio.LocalOscillatorOffset = 0; % сдвиг частоты ОГ
rxradio.Gain = 20;                 % КУ
rxradio.PPSSource = 'Internal';    % внутренний источник PPS
rxradio.ClockSource = 'Internal';  % внутр. источник синхр.
rxradio.MasterClockRate = 32e6;    % тактовая частота 
rxradio.DecimationFactor = 512;    % коэффициент децимации 
rxradio.TransportDataType='int16'; % тип транспортных данных
% тип вых. данных
rxradio.OutputDataType = 'Same as transport data type'; 
rxradio.SamplesPerFrame = 362;      % число выборок на кадр 
rxradio.EnableBurstMode = false;    % откл. пакетного режима
% освобождение системного объекто rxradio
release(rxradio);