% инициализация системного объекта rxsdr устройства RTL-SDR
rxsdr = comm.SDRRTLReceiver;
% инициализация массива переменной для приема данных rxdata
rxdata = [];
% прием 10 кадров и их запись в переменную rxdata
for p=1:10
    rxdata = [rxdata; rxsdr()];
end
% освобождение устройства RTL-SDR от системного rxsdr
release(rxsdr);