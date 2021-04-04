% Laplace Sandbox

% Based on the paper, "A Unified Mathematical Framework for Coding Time,
% Space, and Sequences in the Hippocampal Region." Marc Howard, Christopher
% MacDonald, Zorn Tiganj, Karthik Shankar, Quian Du, Michael Hasselmo, and
% Howard Eichenbaum.

% This script is an effort to reproduce Figure 2 of the paper. The larger 
% s, the shorter the time scales; the smaller s, the longer the time 
% scales. The time constant of each cell in the intermediate representation is just
% 1/s. Equation 4 is the solution to the DEQ describing dF/dt. The solution
% is an integration from a past time up until the present. This is the same
% as summing discrete samples from t = t_prime to t = N. t = N is equivalent to
% tau = 0 in the paper, the present moment. Each sample in f(t) has a phase
% equal to t-t_prime and an amplitude, both which "scale" a superposition
% of bases for that sample. 

% FLAGS

SHOWBASIS = 1;

% INITIALIZATIONS

numDecayRates = 100;                                                    % number of cells in Entorhinal Cortex (EC), the Laplace domain assembly
durationSeconds = 1;                                                    % duration of driving function, f(t) (seconds)
impulseMoment = [0.3, 0.9];                                             % seconds

Ck = 1;                                                                 % Initialize Ck for Post 1930 estimate of inverse Laplace transform
k = 6;                                                                  % used for calc of inverse Laplace; k = 4 was used in the cited paper

t = 0:0.001:durationSeconds;                                            % time vector (seconds, 1 ms resolution)
nSamples = length(t);
s = 1:numDecayRates;                                                    % Laplace independent variable
f = zeros(nSamples,1);                                                  % init external driving function; see Equation 2
idx_t_prime = floor(impulseMoment*nSamples/durationSeconds);            % index to impulse moment

f(idx_t_prime) = [1 0.01];                                              % delta function at impulse moments
figure; 
plot(t,f); 
title('Driving Function, f(t)')
xlabel('Time (s)');

basis = zeros(numDecayRates,nSamples);                                  % init Laplace basis functions to all zero

% Take Laplace transform

for idx = idx_t_prime                                                   % superimpose multiple impulse functions, one for each non-zero sample in f
    
    for i = 1:numDecayRates 
        tmpBasis = zeros(1,nSamples);
        tmpBasis(idx:end) = f(idx)*exp(-t(1:end-idx+1)*s(i));           % generate Laplace basis functions for each non-zero sample in f
        basis(i,:) = basis(i,:) + tmpBasis;
    end % for i
    
end % for idx = idx_t_prime

basisTranslated = basis .* repmat(exp(-s*.5)',1,1001);

if (SHOWBASIS)
    figure;
    for i = 1:25  
        plot(t,basis(i,:),'k-'); hold on;
        plot(t,basisTranslated(i,:),'g-'); hold on;
    end
    title({'Laplace Transform, F,','with 25 Slowest Time Constants'})
    xlabel('Time (s)')
    ylabel('Firing Rate')
end

% Take inverse Laplace transform using the Post approximation. These
% represent the firing rates of the cells in the hippocampus. 

der = basis(:,end);
derTranslated = basisTranslated(:,end);
for iter = 1:k                                                          % take k-th derivative  
    der = diff(der);
    derTranslated = diff(derTranslated);
end

f_tilde = Ck * s(1:numel(der)).^(k+1) .* der';                          % Post approximation              
t_star = -(1/k) * s(1:numel(der));

f_tildeTranslated = Ck * s(1:numel(derTranslated)).^(k+1) .* derTranslated';                          % Post approximation              
t_starTranslated = -(1/k) * s(1:numel(derTranslated));

figure;
plot(t_star,f_tilde);hold on; plot(t_star,f_tildeTranslated);
legend('f','f_tilde');
title({'Inverse Laplace Transform','Remembered Signal'})
xlabel('Past Time')