%% =====================================================================
%% SKRIP UTAMA UNTUK RUN DATA SET E & SET C (GROUP 5)
%% =====================================================================

% 1. Senarai nama fail berdasarkan screenshot folder anda
Filename = {'0075', '1206', '2433', '3630', '4137', '5580', '6255', '7565', '8299', '9472'};

% Kita perlu proses folder secara dinamik (Run Set E dulu, kemudian Set C)
Folders = {'./Set-E/', './Set-C/'}; 

Fs = 16000; % Sampling rate 16kHz
Time = 0.10;   % Ambil had optimum mengikut jadual slide (t = 0.01 hingga 0.10) [cite: 405, 465]
Threshold = 1.4; % [cite: 407]
winsize = 256;

% Buat folder output jika belum wujud
if ~exist('./result', 'dir'), mkdir('./result'); end
FOut = fopen('./result/record_Group5.txt','wt');

fprintf(FOut,'Information on Group 5 (Set E & Set C) Patterns\n');
fprintf(FOut,'Time Tolerance = %1.2f\tThreshold = %1.2f\tWin Size = %d\n\n', Time, Threshold, winsize);
fprintf(FOut,'Rate-->  \tP(M)\tP(O)\tP(I)\n');

N_total = 0;   % Jumlah keseluruhan titik auto
P_total = 0;   % Jumlah keseluruhan titik rujukan (manual)
M_total = 0;   % Jumlah keseluruhan match

% Loop melintasi semua folder (Set_E dan Set_C)
for f_idx = 1:length(Folders)
    current_folder = Folders{f_idx};
    fprintf('Memproses folder: %s\n', current_folder);
    
    for n=1:length(Filename)
        % Pembatasan nama fail secara tepat
        FILE_SEG = strcat(current_folder, Filename{n}, '.seg');
        FILE_WAV = strcat(current_folder, Filename{n}, '.wav');
        
        % Semak jika fail wujud untuk elak error
        if ~exist(FILE_SEG, 'file') || ~exist(FILE_WAV, 'file')
            fprintf('Fail %s tidak dijumpai, skip.\n', Filename{n});
            continue;
        end
        
        % Baca rujukan .seg
        f1 = fopen(FILE_SEG,'r');
        S1 = fscanf(f1,'%g');
        fclose(f1);
        S1 = S1 * Fs;   % Tukar ke unit sampel
          
        % Baca audio .wav
        Y = audioread(FILE_WAV);
        
        % Jalankan Algorithm 1
        [S2, K] = Algorithm1(Y, Threshold, winsize);
               
        % Papar plot perbandingan
        figure('Name', [current_folder, Filename{n}], 'NumberTitle','on');
        PlotSegment(Y, S1, S2);         
         
        % Kira perlawanan (Match)
        Match = Find_Match(S1, S2, Time);
        
        % Akumulasi untuk pengiraan total akhir
        N_total = N_total + K;
        M_total = M_total + Match;
        P_total = P_total + length(S1); % Dinamik ikut saiz sebenar rujukan
        
        % Nilai pembagi mengikut bilangan sempadan asal fail tersebut
        ref_count = length(S1);
        PM = Match / ref_count; 
        PO = (ref_count - Match) / ref_count; 
        if K > 0
            PI = (K - Match) / K;  
        else
            PI = 0;
        end
          
        fprintf(FOut,'\t%s %s\t%2.2f \t%2.2f \t%2.2f\n', current_folder, Filename{n}, PM, PO, PI);
        
        drawnow; % Kemaskini plot di skrin
        pause(0.5); % Berhenti seketika untuk melihat graf sebelum ke fail seterusnya
        close all; % Tutup graf supaya ram tidak penuh
    end
end
         
% Hitung prestasi keseluruhan untuk Laporan Akhir
MatchRate     = M_total / P_total;        
OmissionRate  = (P_total - M_total) / P_total;
if N_total > 0
    InsertionRate = (N_total - M_total) / N_total;
else
    InsertionRate = 0;
end

% Cetak statistik rumusan ke dalam fail teks
fprintf(FOut,'\n\nTotal P: %d Total N: %d Total M: %d\n', P_total, N_total, M_total);      
fprintf(FOut,'Total Match Rate = %2.2f\n', MatchRate);
fprintf(FOut,'Total Omission Rate = %2.2f\n', OmissionRate);
fprintf(FOut,'Total Insertion Rate = %2.2f\n', InsertionRate);

fclose(FOut);
disp('Eksperimen Selesai! Keputusan telah disimpan dalam folder ./result/record_Group5.txt');