%
%            EX30: data file for LF. The original data is taken from
%                     "An Investigation of Loadflow Problem"
%                           by L.L. Freris, A.M. Sasson
%                    IEE Proceedings, Vol.113, No.10, Oct. 1968
%
% Obs: line 27-28 was made 28-27 to be coerent with transformer model
%
%
nb=30;                          % number of busses
nl=41;                          % number of lines
biv=[1:nb]';                    % bus index vector
liv=[1:nl]';                    % line index vector

ifrom = [1   1  2  3  2  2  4  5  6  6  6  6  9  9  4 12 12 12 12 14 16 15 ...
         18 19 10 10 10 10 21 15 22 23 24 25 25 28 27 27 29  8  6]';
ito   = [2   3  4  4  5  6  6  7  7  8  9 10 11 10 12 13 14 15 16 15 17 18 ...
         19 20 20 17 21 22 22 23 24 24 25 26 27 27 29 30 30 28 28]';
 
a=ones(nl,1);
phi=zeros(nl,1);

r = [0.0192; 0.0452; 0.0570; 0.0132; 0.0472; 0.0581; 0.0119; 0.0460; 0.0267;...
     0.0120;    0.0;    0.0;    0.0;    0.0;    0.0;    0.0; 0.1231; 0.0662;...
     0.0945; 0.2210; 0.0824; 0.1070; 0.0639; 0.0340; 0.0936; 0.0324; 0.0348;...
     0.0727; 0.0116; 0.1000; 0.1150; 0.1320; 0.1885; 0.2544; 0.1093;    0.0;...
     0.2198; 0.3202; 0.2399; 0.0636; 0.0169];

x=  [0.0575; 0.1852; 0.1737; 0.0379; 0.1983; 0.1763; 0.0414; 0.1160; 0.0820;...
     0.0420; 0.2080; 0.5560; 0.2080; 0.1100; 0.2560; 0.1400; 0.2559; 0.1304;...
     0.1987; 0.1997; 0.1923; 0.2185; 0.1292; 0.0680; 0.2090; 0.0845; 0.0749;...
     0.1499; 0.0236; 0.2020; 0.1790; 0.2700; 0.3292; 0.3800; 0.2087; 0.3960;...
     0.4153; 0.6027; 0.4533; 0.2000; 0.0599];

bli= [0.0264; 0.0204; 0.0184; 0.0042; 0.0209; 0.0187; 0.0045; 0.0102; 0.0085;...
      0.0045;    0.0;    0.0;    0.0;    0.0;    0.0;    0.0;     0.0;   0.0;...
         0.0;    0.0;    0.0;    0.0;    0.0;    0.0;    0.0;     0.0;   0.0;...
         0.0;    0.0;    0.0;    0.0;    0.0;    0.0;    0.0;     0.0;   0.0;...
         0.0;    0.0;    0.0; 0.0214; 0.0065]*2;

pd = [0.0 21.7 2.4 7.6 94.2  0.0 22.8 30.0 0.0 5.8 0.0 11.2  0.0 6.2 8.2 ...
      3.5  9.0 3.2 9.5  2.2 17.5  0.0  3.2 8.7 0.0 3.5  0.0  0.0 2.4 10.6]';
qd = [0.0 12.7 1.2 1.6 19.0  0.0 10.9 30.0 0.0 2.0 0.0  7.5  0.0 1.6 2.5 ...
      1.8  5.8 0.9 3.4  0.7 11.2  0.0  1.6 6.7 0.0 2.3  0.0  0.0 0.9 1.9]';
pd=pd./100;
qd=qd./100;

sn=[ 3.3  3.3  0  0  3.3  0  0  3.3  0  0  3.3 0  3.3 0  0  0  0  0  0  0 ...
        0   0  0  0   0  0  0   0  0  0]';
fp=[ 0.9  0.9  0  0  0.9  0  0  0.9  0  0  0.9 0  0.9 0  0  0  0  0  0  0 ...
        0   0  0  0   0  0  0   0  0  0]';
xs=[ 0.5224  0.5224  0  0  0.5224  0  0  0.5224  0  0  0.5224 0  0.5224 0  0  0  0  0  0  0 ...
        0   0  0  0   0  0  0   0  0  0]';

nm = zeros(30,1);    
nm(find(sn~=0))=1;          % n�mero de m�quinas em cada barra
nt = nb+sum(nm)-sum(nm>0); % n�mero de barras + n�mero de m�quinas adicionais nas barras de gera��o
miv= [1:nt]';              % machine index vector    
        
cap

qgmin = zeros(1,nb)';
qgmax = zeros(1,nb)';
qgmin(ger) = limites(1,:);
qgmax(ger) = limites(2,:);

% Calcula limites de reativos das barras
aux = nm>1;
aux = aux.*(nm-1);
is = 1:nb;
for i=2:nb
    is(i:nb) = is(i:nb) + aux(i-1);
end
for i=1:nb
    qgmaxt(i) = sum(qgmax(is(i):is(i)+aux(i)));
    qgmint(i) = sum(qgmin(is(i):is(i)+aux(i)));
end
qgmaxt = qgmaxt';
qgmint = qgmint';

% Limite de ativos das unidades geradoras
pgmax = zeros(nt,1);
pgmin = zeros(nt,1);
pgmaxt = [];
pgmint = [];

% Limites da regi�es do custo de pot�ncia reativa

qg01=[1 1 0 0 1 0 0 1 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';
qg12=[2 2 0 0 2 0 0 2 0 0 2 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';
qg03=-qg01;
qg34=-qg12;

xx=1*ones(nb,1);
yy=2*ones(nb,1);
zz=3*ones(nb,1);

pfmax=zeros(nb,1);
pfmin=zeros(nb,1);
qfmax=zeros(nb,1);
qfmin=zeros(nb,1);

bb=[0.2 0.1  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';
aa=[8.0 10.0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';

vmax=ones(size(biv))*1.05;
vmin=ones(size(biv))*0.95;

bmax=zeros(size(biv));
bmin=zeros(size(biv));

amax=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ...
      1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ]';
amin=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ...
      1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 ]';
phimin=zeros(nl,1);
phimax=zeros(nl,1);
%phimin(42)=-0.1;
%phimax(42)=0.1;
xmin=x;
xmax=x;
%xmin(42)=0.6*x(42);
%xmax(42)=1.4*x(42);
flmax=0.7*1./x;
%flmax(3)=0.43;
flmin=-flmax;
%
% initialization using load flow results

pginit=[2.6140 0.4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';

qginit=[-0.1278 0.3770 0.0000 0.0000 0.3840 0.0000 0.0000 0.3655 0.000 0.000 ...
         0.1496 0.0000 0.2306 0.0000 0.0000 0.0000 0.0000 0.0000 0.000 0.000 ...
         0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.000 0.00]';

binit= (bmax+bmin)/2;
binit(10)=0.189;
binit(24)=0.0429;

vinit=[1.0499 1.0400 1.0204 1.0136 1.0100 1.0098 1.0021 1.0100 1.0199 1.0107 ...
       1.0499 1.0187 1.0499 1.0037 0.9996 1.0079 1.0044 0.9909 0.9890 0.9936 ...
       0.9977 0.9981 0.9896 0.9850 0.9814 0.9630 0.9880 1.0063 0.9674 0.9555 ...
	]';

dinit=[0.000 -0.0995 -0.1436 -0.1732 -0.2560 -0.2033 -0.2342 -0.2165 -0.2612 ...
     -0.2918 -0.2612 -0.2793 -0.2793 -0.2957 -0.2973 -0.2898 -0.2951 -0.3084 ...
     -0.3114 -0.3075 -0.3000 -0.2997 -0.3040 -0.3064 -0.2977 -0.3056 -0.2875 ...
     -0.2143 -0.3105 -0.3271 ]';
ainit=ones(nl,1);
phinit=zeros(nl,1);
pfinit=zeros(nb,1);
qfinit=zeros(nb,1);

alinit=ones(size(biv))*(-sum(2.*bb.*(pgmax+pgmin)./2+aa)./nb);
beinit=ones(24,1);
lainit=zeros(size(biv));
gainit=zeros(size(biv));
roinit=zeros(6,1);
miinit=zeros(size(biv));
qsinit=zeros(nl,1);
etainit=zeros(nl,1);
tauinit=zeros(nl,1);
zeinit=zeros(nb,1);
ioinit=zeros(nb,1);

% initialization using opf results min. w4 only

%dinit=[    0 -0.0921 -0.1406 -0.1697 -0.2524 -0.1998 -0.2307 -0.2133 -0.2583...
%     -0.2892 -0.2583 -0.2767 -0.2767 -0.2932 -0.2948 -0.2872 -0.2925 -0.3060...
%     -0.3090 -0.3051 -0.2975 -0.2973 -0.3015 -0.3039 -0.2951 -0.3031 -0.2847...
%     -0.2110 -0.3081 -0.3248]';

%vinit=[1.0500 1.0303 1.0159 1.0082 1.0033 1.0042 0.9960 1.0049 1.0164 1.0066...
%      1.0500 1.0144 1.0465 0.9994 0.9952 1.0036 1.0001 0.9865 0.9847 0.9893...
%      0.9933 0.9938 0.9851 0.9804 0.9763 0.9579 0.9828 1.0008 0.9620 0.9500]';

%pginit=[2.5080 0.5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';

%qginit=[-0.1261 0.2989 0.0000 0.0000 0.4000 0.0000 0.0000 0.4000 0.000 0.000...
%        0.1694 0.0000 0.2400 0.0000 0.0000 0.0000 0.0000 0.0000 0.000 0.000...
%        0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000 0.000 0.000]';

%binit= zeros(size(biv));
%binit(10)=0.1900;
%binit(24)=0.0430;

%alinit=1.0e3*[0.0068 -0.0279 -0.0531 -0.0780 -0.0866 -0.1095 -0.1072 -0.1241...
%             -0.1091 -0.1118 -0.1091 -0.0997 -0.0997 -0.1159 -0.1315 -0.1097...
%             -0.1149 -0.1364 -0.1360 -0.1306 -0.1311 -0.1343 -0.1706 -0.2148...
%             -0.3583 -0.3982 -0.4092 -0.1664 -0.8718 -1.3632]';

%beinit=1.0e3*[0.1041 -0.0253 -0.1089 -0.1512 -0.1150 -0.2051 -0.1696 -0.2247...
%             -0.1972 -0.2971 -0.0087 -0.2698 -0.2531 -0.2988 -0.3231 -0.2840...
%             -0.2955 -0.3185 -0.3146 -0.3107 -0.3497 -0.3643 -0.4279 -0.5646...
%             -1.0755 -1.1030 -1.3818 -0.3281 -2.0685 -2.7989]';

%lainit= 1.0e3*[3.5355 0 0 0 0 0 0 0 0 0 0.9131 0 0 0 0 0 0 0 0 0 0 0 0 0 0...
%              0 0 0 0 -3.6331]';

%gainit=1.e3*[0 .0037 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]';

%roinit= 1.0e3*[0 0 0 0 0.0750 0 0 0.1984 0 0 0 0 0.2374 0 0 0 0 0 0 0 0 0 0...
%              0 0 0 0 0 0 0]';

%miinit=1.0e3*[0 0 0 0 0 0 0 0 0 0.2820 0 0 0 0 0 0 0 0 0 0 0 0 0 0.5383 0 0...
%              0 0 0 0]';
