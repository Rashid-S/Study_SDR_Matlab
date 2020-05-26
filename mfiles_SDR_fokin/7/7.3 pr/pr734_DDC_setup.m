% Синтез каскада фильтров для понижающего (DDC) ПЧ:
% (1) Cascade Integrate Comb Filter (CIC)
% (2) CIC Compensation Filter       (CFIR)
% (3) Square Root Raised Cosine     (RRC)
% скорости: 100 МГц     12.5 МГц     6.25 МГц     1.5625 МГц
% коэффициент M:  CIC(*8)     CFIR(*2)      RRC(*4)  

% параметры фильтра CFIR (CIC)
DCFIR.Mfactor = 2;      % коэффициент децимации DCFIR
DCIC.D        = 1;      % дифференциальная задержка DCIC
DCIC.N        = 5;      % число уровней фильтра DCIC
DCIC.R        = 8;      % коэффициент децимации DCIC
DCFIR.Fp      = 1e6;    % частота полосы пропускания DCFIR 
DCFIR.Fst     = 2e6;    % частоты полосы загр. DCFIR 
DCFIR.Ap      = 0.2;    % неравномерность АЧХ в полосе проп. DCFIR, дБ
DCFIR.Ast     = 80;     % ослабление АЧХ в полосе загр. DCFIR, дБ 
DCFIR.Fs      = 12.5e6; % частота дискретизации на выходе фильтра

% синтез фильтра DCFIR с заданными параметрами 
dDCFIR = fdesign.decimator(DCFIR.Mfactor,'ciccomp', ...
    DCIC.D, DCIC.N, DCIC.R, 'Fp,Fst,Ap,Ast', ...
	DCFIR.Fp, DCFIR.Fst, DCFIR.Ap, DCFIR.Ast, DCFIR.Fs);
hDCFIR = design(dDCFIR,'equiripple','SystemObject',true);

% параметры фильттра DCIC
DCIC.Fs  = 100e6; % частота дискретизации на выходе фильтра DCIC
% синтез фильтра DCIC с заданными параметрами 
hDCIC = dsp.CICDecimator(DCIC.R, DCIC.D, DCIC.N);
% коэффициент масштабирования фильттра DCIC
DCIC.K = 1/(DCIC.R^DCIC.N); 

% параметры фильттра DRRC
DRRC.rolloff = 0.22; % коэффициент сглаживания фильтра DRRC
DRRC.order   = 34;   % порядок фильтра DRRC (меньше фильтра на 1)
DRRC.Mfactor = 4;    % коэффициент децимации фильтра DRRC
% синтез фильтра DRRC с заданными параметрами 
dDRRC = fdesign.pulseshaping(DRRC.Mfactor,...
    'Square Root Raised Cosine','N,Beta',...
    DRRC.order,DRRC.rolloff);
hDRRCtemp = design(dDRRC);
hDRRC = dsp.FIRDecimator(DRRC.Mfactor, hDRRCtemp.Numerator);
set(hDRRC,'FullPrecisionOverride',true);