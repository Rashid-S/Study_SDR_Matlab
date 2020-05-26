function freq_offset  = freqoffset(rxsig)
% freq_offset - ������� ������
% freq_offset - ����� ������, ��
nfft = 8192; % ����������� ���
fs = 2e6;    % ������� ������������� �������� �������, ��
delta_f = fs/nfft; % ��� ���������� �� ������� // fft bin
% ���������� ��� ������� rxsig: [+ve freqs , -ve freqs]
fft_sig = fft(rxsig,nfft);    
% �������������� ������� fft_sig: [-ve freqs , +ve freqs]
fft_sig = fftshift(fft_sig);
% ���������� ������� ������������ ������� fft_sig
[~, max_idx] = max(fft_sig); 
% ������ ������� ������ ������ �� ������� max_idx: 
% �������������� max_idx ��� ��������� ������������ 0
offset_idx = max_idx-1-nfft/2;   
% ����������� ������� ������ ������ � �������� ������ ������
freq_offset = offset_idx*delta_f; 
end