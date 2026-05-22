function y_tahmin = knn_siniflandirici(X_egitim, y_egitim, X_test, k)

n_test = size(X_test, 1);
y_tahmin = zeros(n_test, 1);

kare_eg   = sum(X_egitim .^ 2, 2);
kare_te   = sum(X_test   .^ 2, 2);
capraz    = X_test * X_egitim';
mesafe_kare = bsxfun(@plus, kare_te, kare_eg') - 2 .* capraz;
mesafe_kare = max(mesafe_kare, 0);

for i = 1:n_test
    [~, sira]  = sort(mesafe_kare(i, :), 'ascend');
    komsular   = y_egitim(sira(1:k));

    siniflar   = sort(unique(komsular));
    en_cok_oy  = 0;
    tahmin     = siniflar(1);

    for s = 1:length(siniflar)
        oy = sum(komsular == siniflar(s));
        if oy > en_cok_oy
            en_cok_oy = oy;
            tahmin    = siniflar(s);
        end
    end

    y_tahmin(i) = tahmin;
end

end
