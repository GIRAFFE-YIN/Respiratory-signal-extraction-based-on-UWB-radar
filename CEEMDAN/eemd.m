function [modos,its]=eemd(x,Nstd,NR,MaxIter)

% EEMD algorithm

% This code is part of the Advanced Signal Processing coursework. 
% It performs the EMD over an ensemble of the signal plus Gaussian white noise. 
% The addition of white Gaussian noise solves the mode mixing problem by populating 
% the whole time-frequency space to take advantage of the dyadic filter
% bank behavior of the EMD.

% Please place the emd.m file in the path when using it.

%  OUTPUT
%   modos: contain the obtained modes in a matrix with the rows being the modes
%   its: contain the iterations needed for each mode for each realization
%
%  INPUT
%  x: signal to decompose
%  Nstd: noise standard deviation
%  NR: number of realizations
%  MaxIter: maximum number of sifting iterations allowed.

% Reference
% Wu Z. and Huang N.
% "Ensemble Empirical Mode Decomposition: A noise-assisted data analysis method". 
% Advances in Adaptive Data Analysis. vol 1. pp 1-41, 2009.

% By Maowen Yin 
% Jan 2021

desvio_estandar=std(x);
x=x/desvio_estandar;
xconruido=x+Nstd*randn(size(x));
[modos, ~, it]=emd(xconruido,'MAXITERATIONS',MaxIter);
modos=modos/NR;
iter=it;
if NR>=2
    for i=2:NR
        xconruido=x+Nstd*randn(size(x));
        [temp, ~, it]=emd(xconruido,'MAXITERATIONS',MaxIter);
        temp=temp/NR;
        lit=length(it);
        [p, liter]=size(iter);
        if lit<liter
            it=[it zeros(1,liter-lit)];
        end
        if liter<lit
            iter=[iter zeros(p,lit-liter)];
        end
        
        iter=[iter;it];
        
        [filas, ~]=size(temp);
        [alto, ancho]=size(modos);
        diferencia=alto-filas;
        if filas>alto
            modos=[modos; zeros(abs(diferencia),ancho)];
        end
        if alto>filas
            temp=[temp;zeros(abs(diferencia),ancho)];
        end
        
        modos=modos+temp;
    end
end
its=iter;
modos=modos*desvio_estandar;