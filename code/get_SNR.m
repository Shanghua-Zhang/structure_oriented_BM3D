function SNR =  get_SNR(signal,noise)

signal_power = norm(signal(:)).^2;

noise_power = norm(noise(:)).^2;

SNR = 10*log10(signal_power / noise_power);

fprintf('SNR值为: %.4f dB\n', SNR);

end