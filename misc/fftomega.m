function [omega] = fftomega(N,fs)
omega = linspace(-0.5/fs, +0.5/fs, N);