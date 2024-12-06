function [transferFunction] = squareFilter(filteredFileName,unfilteredFileName,frequency)
%   'frequency' argument is the freq in Hz of the square wave used, and the
%   'amplitude' argument is the amplitude in volts of the square wave used.
%   Remember it has to be the same square wave used for both the unfiltered
%   and filtered data.
filteredData = readmatrix(filteredFileName);
unfilteredData = readmatrix(unfilteredFileName);

% Handles if the two provided data files are different lengths.
filteredLength = size(filteredData,1);
unfilteredLength = size(unfilteredData,1);
length = min(filteredLength,unfilteredLength);

filteredData = filteredData(7:length,:);
unfilteredData = unfilteredData(7:length,:);

% Finds the amplitude of the square wave (filtered and unfiltered) 
% for use in finding the cutoff frequency, assuming a square wave. 
% We want to ensure that the frequency harmonics are
% larger than electrical noise if we're determining gain with it.
filteredDCoffset = mean(filteredData(:,2));
unfilteredDCoffset = mean(unfilteredData(:,2));

offFilteredData(:,2) = filteredData(:,2)-filteredDCoffset;
offUnfilteredData(:,2) = unfilteredData(:,2)-unfilteredDCoffset;

filteredAmp = sqrt(mean(offFilteredData(:,2).*offFilteredData(:,2)));
unfilteredAmp = sqrt(mean(offUnfilteredData(:,2).*offUnfilteredData(:,2)));
amplitude = min(filteredAmp,unfilteredAmp);

% Takes the fourier transforms to find the gain for each frequency
filterF = fft(filteredData(:,2));
filterF = filterF(1:end/2);
normalF = fft(unfilteredData(:,2));
normalF = normalF(1:end/2);

maxFreq = .5/(filteredData(5,1)-filteredData(4,1));
minFreq =  abs(.5/(filteredData(end,1)-filteredData(1,1)));

% Finds cutoff frequency so that we only use signals larger than noise.
% Noise is assumed to be ~ 1mV in magnitude (that is the 0.001 in nCutoff)
nHarmonic = round(frequency/minFreq);
nCutoff = round(amplitude/0.001);
freqCutoff = min([1+nHarmonic*(nCutoff+1),length,500000]); % Matlab doesn't like larger than 500,000

% Creates the output matrix, where the first column is a list of frequencies
% and the second column is the gain of the filter at those frequencies.
freqs = (1:1:(size(normalF,1)))./size(normalF,1)*maxFreq;
transferFunction = transpose([freqs(1+nHarmonic:2*nHarmonic:freqCutoff); transpose(abs(filterF(1+nHarmonic:2*nHarmonic:freqCutoff))./abs(normalF(1+nHarmonic:2*nHarmonic:freqCutoff)))]);

% Code that is no longer used, but can be used to plot the gain profile:
%figure()
%subplot(3,1,1)
%semilogy(freqs, abs(filterF))
%subplot(3,1,2)
%semilogy(freqs, abs(normalF))
%subplot(3,1,3)
%semilogy(freqs, abs(filterF)./abs(normalF)) % Not just the harmonics, thus noisier
%figure()
%semilogy(freqs(1+nHarmonic:2*nHarmonic:freqCutoff), abs(filterF(1+nHarmonic:2*nHarmonic:freqCutoff))./abs(normalF(1+nHarmonic:2*nHarmonic:freqCutoff)))


end