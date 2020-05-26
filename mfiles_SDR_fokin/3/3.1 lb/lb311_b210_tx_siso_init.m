% Инициализация одноканального передатчика на USRP B210
txradio = ...
    comm.SDRuTransmitter('Platform','B210','SerialNum','F4E642');
txradio.ChannelMapping  = 1;        % схема каналов
txradio.CenterFrequency = 2.5e9;    % центральная частота
txradio.LocalOscillatorOffset = 0;  % сдвиг частоты ОГ
txradio.Gain = 20;                  % КУ
txradio.PPSSource = 'Internal';     % внутренний источник PPS
txradio.ClockSource = 'Internal';   % внутр. источник синхр.
txradio.MasterClockRate = 32e6;     % тактовая частота
txradio.InterpolationFactor = 512;  % коэффициент интерполяции 
txradio.TransportDataType='int16';  % тип транспортных данных
txradio.EnableBurstMode = false;    % откл. пакетного режима
% освобождение системного объекта txradio
release(txradio);