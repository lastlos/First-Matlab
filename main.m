
clc; clear; close all;

RENKLER   = [0.00 0.45 0.74;
             0.85 0.33 0.10;
             0.47 0.67 0.19];
ACIK_RENK = [0.70 0.82 0.95;
             0.98 0.78 0.72;
             0.80 0.93 0.74];

[X_egitim, X_test, y_egitim, y_test, ozellik_adlari, sinif_adlari] = ...
    yukle_ve_isle(0.2, 42);

k_degerleri   = [1, 3, 5, 7, 9, 11];
n_k           = length(k_degerleri);
n_test        = length(y_test);
dogruluklar   = zeros(1, n_k);
hata_sayilari = zeros(1, n_k);
tum_tahminler = cell(1, n_k);

for i = 1:n_k
    y_tahmin         = knn_siniflandirici(X_egitim, y_egitim, X_test, k_degerleri(i));
    tum_tahminler{i} = y_tahmin;
    hata_sayilari(i) = sum(y_tahmin ~= y_test);
    dogruluklar(i)   = (1 - hata_sayilari(i) / n_test) * 100;
end

[en_iyi_dogruluk, en_iyi_indeks] = max(dogruluklar);
en_iyi_k      = k_degerleri(en_iyi_indeks);
en_iyi_tahmin = tum_tahminler{en_iyi_indeks};

fprintf('\n');
fprintf('=================================================================\n');
fprintf('  Iris KNN Siniflandirma Sonuclari\n');
fprintf('=================================================================\n');
fprintf('  %-6s   %-22s   %-12s\n', 'K', 'Test Dogrulugu (%)', 'Hata Sayisi');
fprintf('-----------------------------------------------------------------\n');
for i = 1:n_k
    isaretci = '';
    if k_degerleri(i) == en_iyi_k
        isaretci = ' <-- en iyi';
    end
    fprintf('  %-6d   %-22.2f   %-12d%s\n', ...
        k_degerleri(i), dogruluklar(i), hata_sayilari(i), isaretci);
end
fprintf('=================================================================\n');
fprintf('  En iyi K = %d  |  Dogruluk = %.2f%%  |  Hata = %d / %d\n', ...
    en_iyi_k, en_iyi_dogruluk, hata_sayilari(en_iyi_indeks), n_test);
fprintf('=================================================================\n\n');

% =========================================================================
%  SEKIL 1 — K'ya Gore Dogruluk
% =========================================================================
figure(1);
clf;

plot(k_degerleri, dogruluklar, 'o-', ...
     'Color', [0.20 0.45 0.75], 'LineWidth', 2.5, ...
     'MarkerSize', 8, 'MarkerFaceColor', [0.20 0.45 0.75]);
hold on;
plot(en_iyi_k, en_iyi_dogruluk, 'p', ...
     'MarkerSize', 16, 'MarkerFaceColor', [0.93 0.69 0.13], ...
     'MarkerEdgeColor', [0.60 0.40 0.00], 'LineWidth', 1.5);

ylim([max(0, min(dogruluklar)-5), min(100, max(dogruluklar)+5)]);
xlim([min(k_degerleri)-1, max(k_degerleri)+1]);
set(gca, 'XTick', k_degerleri);
grid on; box on;

xlabel('K (Komsu Sayisi)', 'FontSize', 12);
ylabel('Test Dogrulugu (%)', 'FontSize', 12);
title('K Degerine Gore KNN Test Dogrulugu', 'FontSize', 14, 'FontWeight', 'bold');
legend({'Test Dogrulugu', sprintf('En Iyi K = %d  (%.1f%%)', en_iyi_k, en_iyi_dogruluk)}, ...
       'Location', 'southeast', 'FontSize', 10);

% =========================================================================
%  SEKIL 2 — Karisiklik Matrisi (en iyi k)
% =========================================================================
karisiklik_m = zeros(3, 3);
for idx = 1:n_test
    r = y_test(idx);
    c = en_iyi_tahmin(idx);
    karisiklik_m(r, c) = karisiklik_m(r, c) + 1;
end

figure(2);
clf;

mavi_harita = [linspace(1, 0.10, 256)', linspace(1, 0.35, 256)', linspace(1, 0.85, 256)'];
imagesc(karisiklik_m);
colormap(mavi_harita);
colorbar;
axis square;

cm_maks = max(karisiklik_m(:));
for ii = 1:3
    for jj = 1:3
        if karisiklik_m(ii, jj) > cm_maks * 0.5
            metin_rengi = [1 1 1];
        else
            metin_rengi = [0 0 0];
        end
        text(jj, ii, num2str(karisiklik_m(ii, jj)), ...
             'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
             'FontSize', 16, 'FontWeight', 'bold', 'Color', metin_rengi);
    end
end

set(gca, 'XTick', 1:3, 'XTickLabel', sinif_adlari, 'FontSize', 11);
set(gca, 'YTick', 1:3, 'YTickLabel', sinif_adlari, 'FontSize', 11);
xlabel('Tahmin Edilen Sinif', 'FontSize', 12);
ylabel('Gercek Sinif', 'FontSize', 12);
title(sprintf('Karisiklik Matrisi  (K = %d)', en_iyi_k), ...
      'FontSize', 14, 'FontWeight', 'bold');

% =========================================================================
%  SEKIL 3 — Karar Siniri (ozellik 3 ve 4: tac yaprak)
% =========================================================================
X_eg34 = X_egitim(:, 3:4);
X_te34 = X_test(:,   3:4);

x3_min  = min(X_eg34(:,1)) - 0.08;
x3_maks = max(X_eg34(:,1)) + 0.08;
x4_min  = min(X_eg34(:,2)) - 0.08;
x4_maks = max(X_eg34(:,2)) + 0.08;

cozunurluk = 150;
f3_aralik = linspace(x3_min, x3_maks, cozunurluk);
f4_aralik = linspace(x4_min, x4_maks, cozunurluk);
[XX, YY]     = meshgrid(f3_aralik, f4_aralik);
ag_noktalari = [XX(:), YY(:)];

tahminler_ag = knn_siniflandirici(X_eg34, y_egitim, ag_noktalari, en_iyi_k);

figure(3);
clf;
hold on;

for s = 1:3
    maske = tahminler_ag == s;
    scatter(ag_noktalari(maske, 1), ag_noktalari(maske, 2), ...
            4, ACIK_RENK(s,:), 'filled');
end

isaretler = {'o', 's', '^'};
for s = 1:3
    maske_eg = y_egitim == s;
    scatter(X_eg34(maske_eg, 1), X_eg34(maske_eg, 2), ...
            55, RENKLER(s,:), isaretler{s}, 'filled');
end
for s = 1:3
    maske_te = y_test == s;
    scatter(X_te34(maske_te, 1), X_te34(maske_te, 2), ...
            80, RENKLER(s,:), isaretler{s}, 'LineWidth', 2.0);
end

xlim([x3_min, x3_maks]);
ylim([x4_min, x4_maks]);
grid on; box on;

xlabel(ozellik_adlari{3}, 'FontSize', 12);
ylabel(ozellik_adlari{4}, 'FontSize', 12);
title(sprintf('Karar Siniri  (K = %d,  Tac Yaprak Ozellikleri)', en_iyi_k), ...
      'FontSize', 13, 'FontWeight', 'bold');
legend(sinif_adlari, 'Location', 'northwest', 'FontSize', 10);

% =========================================================================
%  SEKIL 4 — Ozellik Cifti Dagilim Matrisi
% =========================================================================
X_tum = [X_egitim; X_test];
y_tum = [y_egitim; y_test];

figure(4);
clf;

lejant_ilk = true;

for i = 1:4
    for j = 1:4
        subplot(4, 4, (i-1)*4 + j);
        hold on;

        if i == j
            bin_kenarlari = linspace(min(X_tum(:,i))-0.01, max(X_tum(:,i))+0.01, 13);
            n_bins = length(bin_kenarlari) - 1;
            for s = 1:3
                deger = X_tum(y_tum == s, i);
                n_say = histc(deger, bin_kenarlari);
                n_say = n_say(1:end-1);
                x_adim = zeros(1, 2*n_bins);
                y_adim = zeros(1, 2*n_bins);
                for b = 1:n_bins
                    x_adim(2*b-1) = bin_kenarlari(b);
                    x_adim(2*b)   = bin_kenarlari(b+1);
                    y_adim(2*b-1) = n_say(b);
                    y_adim(2*b)   = n_say(b);
                end
                plot(x_adim, y_adim, 'Color', RENKLER(s,:), 'LineWidth', 2.2);
            end
        else
            for s = 1:3
                scatter(X_tum(y_tum == s, j), X_tum(y_tum == s, i), ...
                        10, RENKLER(s,:), 'filled');
            end
            if lejant_ilk
                legend(sinif_adlari, 'Location', 'best', 'FontSize', 6.5);
                lejant_ilk = false;
            end
        end

        grid on;
        set(gca, 'FontSize', 7.5);

        if i == 4
            xlabel(ozellik_adlari{j}, 'FontSize', 8);
        end
        if j == 1
            ylabel(ozellik_adlari{i}, 'FontSize', 8);
        end
    end
end

axes('Position', [0 0 1 1], 'Visible', 'off');
text(0.5, 0.99, 'Ozellik Cifti Dagilim Matrisi  (Gercek Sinif Etiketi)', ...
     'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', ...
     'FontSize', 13, 'FontWeight', 'bold');
