% ������ ������� �������� ��� ����������� (DDC) ��:
% (1) Cascade Integrate Comb Filter (CIC)
% (2) CIC Compensation Filter       (CFIR)
% (3) Square Root Raised Cosine     (RRC)
% ��������: 100 ���     12.5 ���     6.25 ���     1.5625 ���
% ����������� M:  CIC(*8)     CFIR(*2)      RRC(*4)  

% ��������� ������� CFIR (CIC)
DCFIR.Mfactor = 2;      % ����������� ��������� DCFIR
DCIC.D        = 1;      % ���������������� �������� DCIC
DCIC.N        = 5;      % ����� ������� ������� DCIC
DCIC.R        = 8;      % ����������� ��������� DCIC
DCFIR.Fp      = 1e6;    % ������� ������ ����������� DCFIR 
DCFIR.Fst     = 2e6;    % ������� ������ ����. DCFIR 
DCFIR.Ap      = 0.2;    % ��������������� ��� � ������ ����. DCFIR, ��
DCFIR.Ast     = 80;     % ���������� ��� � ������ ����. DCFIR, �� 
DCFIR.Fs      = 12.5e6; % ������� ������������� �� ������ �������

% ������ ������� DCFIR � ��������� ����������� 
dDCFIR = fdesign.decimator(DCFIR.Mfactor,'ciccomp', ...
    DCIC.D, DCIC.N, DCIC.R, 'Fp,Fst,Ap,Ast', ...
	DCFIR.Fp, DCFIR.Fst, DCFIR.Ap, DCFIR.Ast, DCFIR.Fs);
hDCFIR = design(dDCFIR,'equiripple','SystemObject',true);

% ��������� �������� DCIC
DCIC.Fs  = 100e6; % ������� ������������� �� ������ ������� DCIC
% ������ ������� DCIC � ��������� ����������� 
hDCIC = dsp.CICDecimator(DCIC.R, DCIC.D, DCIC.N);
% ����������� ��������������� �������� DCIC
DCIC.K = 1/(DCIC.R^DCIC.N); 

% ��������� �������� DRRC
DRRC.rolloff = 0.22; % ����������� ����������� ������� DRRC
DRRC.order   = 34;   % ������� ������� DRRC (������ ������� �� 1)
DRRC.Mfactor = 4;    % ����������� ��������� ������� DRRC
% ������ ������� DRRC � ��������� ����������� 
dDRRC = fdesign.pulseshaping(DRRC.Mfactor,...
    'Square Root Raised Cosine','N,Beta',...
    DRRC.order,DRRC.rolloff);
hDRRCtemp = design(dDRRC);
hDRRC = dsp.FIRDecimator(DRRC.Mfactor, hDRRCtemp.Numerator);
set(hDRRC,'FullPrecisionOverride',true);