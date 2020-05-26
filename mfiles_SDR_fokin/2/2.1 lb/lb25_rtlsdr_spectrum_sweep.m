% Cканирование диапазона частот, 
% принимаемого устройством RTL-SDR 
% После выполнения просканированный 
% диапазон представляется на графике
clear all; clc;
% Параметры устройства RTL-SDR
location        = 'bonch_spb';% местоположение
start_freq      = 30e6;       % нижняя частота сканирования
stop_freq       = 40e6;     % верхняя частота сканирования
rtlsdr.id       = '0';        % идентификатор
rtlsdr.fs       = 2.4e6;      % частота дискретизации, Гц
rtlsdr.gain     = 40;         % усиление, дБ
rtlsdr.frmlen   = 4096;       % размер выходного кадра, выборок
rtlsdr.datatype = 'single';   % тип выходных данных
rtlsdr.ppm      = 0;          % коррекция сдвига частоты, ppm
% Параметры сканирования диапазона частот
nfrmhold        = 20;         % число принимаемых кадров
fft_hold        = 'avg';      % обработка БПФ: "max" или "avg"
nfft            = 4096;       % размерность БПФ
dec_factor      = 16;         % коэфф. дицимации для графика 
% перекрытие БПФ для компенсации 
% эффекта скругления фильтра (roll-off) 
overlap         = 0.5; 
% число кадров для сброса 
% (очистки) буфера после перенастройки  
nfrmdump        = 100;         
% диапазон сканирования в Гц
rtlsdr.tunerfreq  = start_freq:rtlsdr.fs*overlap:stop_freq;
% проверка верхнего предела диапазона сканирования
if( max(rtlsdr.tunerfreq) < stop_freq )
    % если предел диапазона сканирования меньше верхней 
    % частоты сканирования, добавляется  rtlsdr.fs*overlap
    rtlsdr.tunerfreq(length(rtlsdr.tunerfreq)+1) = ...
        max(rtlsdr.tunerfreq)+rtlsdr.fs*overlap;
end
% оценка числа перенастроек приемника 
% RTL-SDR по числу частот диапазона
nretunes = length(rtlsdr.tunerfreq); 
% разрешение по частоте
freq_bin_width = (rtlsdr.fs/nfft);  
% формирование шкалы частот сканируемого диапазона
freq_axis = ...
    (rtlsdr.tunerfreq(1)-rtlsdr.fs/2*overlap  : ...
    freq_bin_width*dec_factor  :...
    (rtlsdr.tunerfreq(end)+rtlsdr.fs/2*overlap)-...
    freq_bin_width)/1e6;
% вектрор-строка размером nfft для хранения БПФ 
rtlsdr.data_fft = zeros(1,nfft);
% матрица размера [nfrmhold x nfft*overlap] для хранения
% блоков переупорядоченного БПФ с компенсацией перекрытия
fft_reorder = zeros(nfrmhold,nfft*overlap);  
% матрица размера [nretunes x nfft*overlap/dec_factor] 
% для хранения всех блоков БПФ с компенсацией перекрытия
fft_dec = zeros(nretunes,nfft*overlap/dec_factor);  
% Инициализация системного объекта comm.SDRRTLReceiver
obj_rtlsdr = comm.SDRRTLReceiver(...
    rtlsdr.id,...
    'CenterFrequency',      rtlsdr.tunerfreq(1),...
    'EnableTunerAGC',       false,...
    'TunerGain',            rtlsdr.gain,...
    'SampleRate',           rtlsdr.fs, ...
    'SamplesPerFrame',      rtlsdr.frmlen,...
    'OutputDataType',       rtlsdr.datatype ,...
    'FrequencyCorrection',  rtlsdr.ppm );
% инициализация КИХ-фильтра дециматора
obj_decmtr = dsp.FIRDecimator(...
    'DecimationFactor',     dec_factor,...
    'Numerator',            fir1(300,1/dec_factor));

% ИНИЦИАЛИЗАЦИЯ ТАЙМЕРА НАЧАЛА СКАНИРОВАНИЯ
tic; disp(' '); 
tune_progress = 0; % переменная активности сканирования
% цикл по числу перенастроек
for ntune = 1:1:nretunes
    % настройка устройства RTL-SDR на центральную частоту
    obj_rtlsdr.CenterFrequency = rtlsdr.tunerfreq(ntune);
    % отбрасывание кадров для очистки буфера
    for frm = 1:1:nfrmdump
        % прием кадра данных устройством RTL-SDR
        rtlsdr.data = obj_rtlsdr();
    end
    % отображение текущей центральной частоты
    disp([' fc = ',...
        num2str(rtlsdr.tunerfreq(ntune)/1e6),' МГц']);
    
    % цикл по числу принимаемых кадров nfrmhold 
    for frm = 1:1:nfrmhold
        % прием кадра данных устройством RTL-SDR
        rtlsdr.data = step(obj_rtlsdr);
        % исключение постоянной составляющей
        rtlsdr.data = rtlsdr.data - mean(rtlsdr.data);
        % БПФ // find fft [ +ve , -ve ]
        rtlsdr.data_fft = abs(fft(rtlsdr.data,nfft))';
        % переупорядоченное БПФ: запись в матрицу 
        % fft_reorder nfrmhold блоков БПФ; в результате 
        % получается матрица fft_reorder размером 
        % [nfrmhold x overlap*nfft] с перекрывающимися 
        % отсчетами на положительных и отрицательных 
        % частотах [ -ve , +ve ]
        % -ve
        fft_reorder(frm,(1:(overlap*nfft/2))) = ...
            rtlsdr.data_fft((overlap*nfft/2)+(nfft/2)+1:end );
        % +ve
        fft_reorder(frm,((overlap*nfft/2)+1:end )) = ...
            rtlsdr.data_fft(1:(overlap*nfft/2));             
    end
    % обработка выборок БПФ в матрице fft_reorder 
    % по стобцам; в результате получается вектор-строка 
    % fft_reorder_proc размером [1 x overlap*nfft] 
    if strcmp(fft_hold,'avg')       % нахождение среднего
        fft_reorder_proc = mean(fft_reorder); 
    elseif strcmp(fft_hold,'max')    % нахождение максимума
        fft_reorder_proc = max(fft_reorder); 
    end
    % децимация выборок БПФ в вектор-строке fft_reorder;
    % в результате получается вектор-строка размером 
    % [1 x overlap*nfft/dec_factor], которая записывается
    % в матрицу fft_dec размером 
    % [ntune x overlap*nfft/dec_factor] c индексом ntune
    fft_dec(ntune,:) = step(obj_decmtr,fft_reorder_proc')';
    % прогресс выполнения сканирования 
    % в % каждые 10% (ntune*10/nretunes)
    if floor(ntune*10/nretunes) ~= tune_progress
        tune_progress = floor(ntune*10/nretunes);
        disp([' просканировано = ',...
            num2str(tune_progress*10),'%']);
    end
end
% Переупорядочивание данных в вектрор-строку
fft_masterreshape = ...
    reshape(fft_dec',1,ntune*nfft*overlap/dec_factor); 
y_data = ((fft_masterreshape/nfft).^2)/50; 
y_data_dbm = 10*log10(((fft_masterreshape/nfft).^2)/50);
% Построение графика просканированного диапазона
subplot(2,1,1); 
plot(freq_axis,y_data,'r','linewidth',2); axis('tight'); 
xlabel('Частота, МГц'); 
ylabel('Мощность (нагрузка 50 Ом), Вт'); grid on;
title(['Диапазон: ',num2str(start_freq/1e6),' МГц - ',...
    num2str(stop_freq/1e6), ' МГц. Bin Width = ',...
    num2str(freq_bin_width*dec_factor/1e3),...
    ' кГц. BinsNum = ',num2str(length(freq_axis)),...
    '. Перенастроек ', num2str(nretunes)]);
%xlim([start_freq/1e6,stop_freq/1e6]);
subplot(2,1,2); 
plot(freq_axis,y_data_dbm,'linewidth',2); axis('tight'); 
xlabel('Частота, МГц'); 
ylabel('Мощность (нагрузка 50 Ом), дБ'); grid on;
% Инициализация таймера завершения сканирования
disp(' '); disp(['  run time = ',num2str(toc),'s']); disp(' ');
% сохранение данных сканирования в файл
filename = ['rtlsdr.rx_',num2str(start_freq/1e6),...
    'MHz_',num2str(stop_freq/1e6),'MHz_',location,'.fig'];
savefig(filename);