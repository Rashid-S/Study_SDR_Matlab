% Синтез каскада фильтров для повышающего ПЧ (DUC):
% (1) Square Root Raised Cosine     (RRC)
% (2) CIC Compensation Filter       (CFIR)
% (3) Cascade Integrate Comb Filter (CIC)
% скорости: 1.5625 МГц     6.25 МГц    12.5 МГц    100 МГц
% коэффициент L:     RRC(*4)     CFIR(*2)    CIC(*8)             

% параметры фильттра RRC
RRC.rolloff = 0.22; % коэффициент сглаживания фильтра RRC
RRC.order   = 34;   % порядок фильтра RRC (меньше фильтра на 1)
RRC.Lfactor = 4;    % коэффициент интерполяции фильтра RRC
% синтез фильтра RRC с заданными параметрами 
dRRC = fdesign.pulseshaping(RRC.Lfactor,...
    'Square Root Raised Cosine','N,Beta',...
    RRC.order,RRC.rolloff);
hRRCtemp = design(dRRC);
hRRC = dsp.FIRInterpolator(RRC.Lfactor, hRRCtemp.Numerator);
set(hRRC,'FullPrecisionOverride',true);

% параметры фильттра CFIR
CFIR.Lfactor =2; % коэффициент интерполяции CFIR
CIC.D    = 1;    % дифференциальная задержка CIC
CIC.N    = 5;    % число уровней фильтра CIC
CIC.R    = 8;    % коэффициент интерполяции CIC
CFIR.Fp  = 1e6;  % частота полосы пропускания CFIR 
CFIR.Fst = 2e6;  % частоты полосы загр. CFIR 
CFIR.Ap  = 0.2;  % неравномерность АЧХ в полосе проп. CFIR, дБ
CFIR.Ast = 80;   % ослабление АЧХ в полосе загр. CFIR, дБ 
CFIR.Fs  = 12.5e6; % частота дискретизации на выходе фильтра
% синтез фильтра CFIR с заданными параметрами 
dCFIR = fdesign.interpolator(CFIR.Lfactor,'ciccomp', ...
    CIC.D, CIC.N, CIC.R, 'Fp,Fst,Ap,Ast', ...
	CFIR.Fp, CFIR.Fst, CFIR.Ap, CFIR.Ast, CFIR.Fs);
hCFIR = design(dCFIR,'equiripple','SystemObject',true);

% параметры фильттра CIC
CIC.Fs  = 100e6; % частота дискретизации на выходе фильтра CIC
% синтез фильтра CIC с заданными параметрами 
hCIC = dsp.CICInterpolator(CIC.R, CIC.D, CIC.N);
% коэффициент масштабирования фильттра CIC
CIC.K = 1/(CIC.R^CIC.N); 

% % Синтез каскада фильтров
% hCASC=dsp.FilterCascade(hRRC,hCFIR,hCIC);
% fv(1)=fvtool(hRRC,'Fs',6.25e6,'ShowReference','off'); hold on;
% addfilter(fv(1), hCFIR,'Fs',12.5e6,'ShowReference','off');
% addfilter(fv(1), hCIC,'Fs',100e6,'ShowReference','off');
% addfilter(fv(1), hCASC, 'Fs', 100e6,'ShowReference','off');
% hold off; grid on; title('АЧХ каскада фильтров RRC+CFIR+CIC');
% legend(fv(1),'RRC','CFIR','CIC','RRC+CFIR+CIC');