% ������ ������� �������� ��� ����������� �� (DUC):
% (1) Square Root Raised Cosine     (RRC)
% (2) CIC Compensation Filter       (CFIR)
% (3) Cascade Integrate Comb Filter (CIC)
% ��������: 1.5625 ���     6.25 ���    12.5 ���    100 ���
% ����������� L:     RRC(*4)     CFIR(*2)    CIC(*8)             

% ��������� �������� RRC
RRC.rolloff = 0.22; % ����������� ����������� ������� RRC
RRC.order   = 34;   % ������� ������� RRC (������ ������� �� 1)
RRC.Lfactor = 4;    % ����������� ������������ ������� RRC
% ������ ������� RRC � ��������� ����������� 
dRRC = fdesign.pulseshaping(RRC.Lfactor,...
    'Square Root Raised Cosine','N,Beta',...
    RRC.order,RRC.rolloff);
hRRCtemp = design(dRRC);
hRRC = dsp.FIRInterpolator(RRC.Lfactor, hRRCtemp.Numerator);
set(hRRC,'FullPrecisionOverride',true);

% ��������� �������� CFIR
CFIR.Lfactor =2; % ����������� ������������ CFIR
CIC.D    = 1;    % ���������������� �������� CIC
CIC.N    = 5;    % ����� ������� ������� CIC
CIC.R    = 8;    % ����������� ������������ CIC
CFIR.Fp  = 1e6;  % ������� ������ ����������� CFIR 
CFIR.Fst = 2e6;  % ������� ������ ����. CFIR 
CFIR.Ap  = 0.2;  % ��������������� ��� � ������ ����. CFIR, ��
CFIR.Ast = 80;   % ���������� ��� � ������ ����. CFIR, �� 
CFIR.Fs  = 12.5e6; % ������� ������������� �� ������ �������
% ������ ������� CFIR � ��������� ����������� 
dCFIR = fdesign.interpolator(CFIR.Lfactor,'ciccomp', ...
    CIC.D, CIC.N, CIC.R, 'Fp,Fst,Ap,Ast', ...
	CFIR.Fp, CFIR.Fst, CFIR.Ap, CFIR.Ast, CFIR.Fs);
hCFIR = design(dCFIR,'equiripple','SystemObject',true);

% ��������� �������� CIC
CIC.Fs  = 100e6; % ������� ������������� �� ������ ������� CIC
% ������ ������� CIC � ��������� ����������� 
hCIC = dsp.CICInterpolator(CIC.R, CIC.D, CIC.N);
% ����������� ��������������� �������� CIC
CIC.K = 1/(CIC.R^CIC.N); 

% % ������ ������� ��������
% hCASC=dsp.FilterCascade(hRRC,hCFIR,hCIC);
% fv(1)=fvtool(hRRC,'Fs',6.25e6,'ShowReference','off'); hold on;
% addfilter(fv(1), hCFIR,'Fs',12.5e6,'ShowReference','off');
% addfilter(fv(1), hCIC,'Fs',100e6,'ShowReference','off');
% addfilter(fv(1), hCASC, 'Fs', 100e6,'ShowReference','off');
% hold off; grid on; title('��� ������� �������� RRC+CFIR+CIC');
% legend(fv(1),'RRC','CFIR','CIC','RRC+CFIR+CIC');