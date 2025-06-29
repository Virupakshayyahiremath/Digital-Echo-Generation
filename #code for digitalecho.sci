// === Parameters ===
// Path to your recorded audio file (update as needed)
audioFile = "C:\Users\Virupakshayya\Downloads\audio.wav";

// Echo parameters
delay_sec = 0.3;  // Echo delay in seconds
alpha = 0.6;      // Echo attenuation factor

// === Load audio ===
[x, fs] = wavread(audioFile);

// Convert stereo to mono if necessary
if size(x, 2) == 2 then
    x = mean(x, "c"); // average the two channels
end

// Ensure x is a row vector for processing
x = x(:)';

// Calculate delay in samples
D = round(delay_sec * fs);

// === Create echoed signal ===
x_echo = zeros(1, length(x) + D);
x_echo(1:length(x)) = x;
x_echo(D+1:D+length(x)) = x_echo(D+1:D+length(x)) + alpha * x;

// Normalize to avoid clipping
x_echo = x_echo / max(abs(x_echo));

// === Save output files ===
wavwrite(x', fs, 16, "original.wav");
wavwrite(x_echo', fs, 16, "voice_with_echo.wav");

// === Playback (Windows only) ===
disp("Playing original audio...");
host("start original.wav");
sleep(9000); // wait 3 seconds before playing echoed audio
disp("Playing audio with echo...");
host("start voice_with_echo.wav");

// === Plot signals ===
clf;
t = 0:1/fs:(length(x)-1)/fs;
subplot(2,1,1);
plot(t, x);
xtitle("Original Voice");

t_echo = 0:1/fs:(length(x_echo)-1)/fs;
subplot(2,1,2);
plot(t_echo, x_echo);
xtitle("Voice with Echo");
