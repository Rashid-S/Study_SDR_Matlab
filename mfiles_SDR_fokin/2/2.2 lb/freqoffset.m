function freq_offset  = freqoffset(rxsig)
% freq_offset - входной сигнал
% freq_offset - сдвиг частот, Гц
nfft = 8192; % размерность БПФ
fs = 2e6;    % частота дискретизации входного сигнала, Гц
delta_f = fs/nfft; % БПФ разрешение по частоте // fft bin
% Вычисление БПФ сигнала rxsig: [+ve freqs , -ve freqs]
fft_sig = fft(rxsig,nfft);    
% Преобразование сигнала fft_sig: [-ve freqs , +ve freqs]
fft_sig = fftshift(fft_sig);
% Нахождение индекса максимальной выборки fft_sig
[~, max_idx] = max(fft_sig); 
% Оценка индекса сдвига частот по индексу max_idx: 
% преобразование max_idx для симметрии относительно 0
offset_idx = max_idx-1-nfft/2;   
% Отображение индекса сдвига частот в значение сдвига частот
freq_offset = offset_idx*delta_f; 
end