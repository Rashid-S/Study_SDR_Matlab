% ������������� ���������� ������� rxsdr ���������� RTL-SDR
rxsdr = comm.SDRRTLReceiver;
% ������������� ������� ���������� ��� ������ ������ rxdata
rxdata = [];
% ����� 10 ������ � �� ������ � ���������� rxdata
for p=1:10
    rxdata = [rxdata; rxsdr()];
end
% ������������ ���������� RTL-SDR �� ���������� rxsdr
release(rxsdr);