% инициализация системного объекта rxsdr устройства RTL-SDR
rxsdr = comm.SDRRTLReceiver('0',...
    'CenterFrequency',88.9e6,...    
    'SampleRate',250000, ...
    'SamplesPerFrame',2048,...
    'EnableTunerAGC',true,...
    'OutputDataType','double');
% вывод настроек системного объекта rxsdr устройства RTL-SDR
radioInfo = info(rxsdr)
% прием 10 кадров системным объектом rxsdr устройства RTL-SDR
for p=1:10
    rxdata1 = rxsdr();
end
% перестройка центральной частоты
rxsdr.CenterFrequency = 103.1e6;
% вывод настроек системного объекта rxsdr устройства RTL-SDR
radioInfo = info(rxsdr)
% прием 10 кадров системным объектом на новой частоте 103.1e6
for p=1:10
    rxdata2 = rxsdr();
end
% освобождение устройства RTL-SDR от системного rxsdr
release(rxsdr);