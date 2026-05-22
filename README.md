# First Matlab Project — Iris Veri Seti ile K-En Yakın Komşu Sınıflandırması

Bu proje, MATLAB'ın yerleşik `fisheriris` veri seti üzerinde K-En Yakın Komşu (KNN) algoritmasını **sıfırdan** (Statistics Toolbox kullanmadan) uygulayan bir makine öğrenmesi portfolyo çalışmasıdır. Amaç; veri ön işleme, el yapımı KNN ve görselleştirme adımlarını tek bir tutarlı proje içinde sunmaktır.

---

## Algoritma Hakkında — KNN Nasıl Çalışır?

K-En Yakın Komşu (K-Nearest Neighbors), parametrik olmayan, tembelci (lazy) bir sınıflandırıcıdır. Eğitim aşamasında hiçbir model öğrenmez; tüm hesaplama tahmin anında yapılır.

**Tahmin adımları:**
1. Test noktası ile tüm eğitim noktaları arasındaki Öklid mesafeleri hesaplanır.
2. En yakın `k` komşu seçilir.
3. Bu komşular arasında hangi sınıf çoğunluktaysa o sınıf tahmin edilir (çoğunluk oylaması).
4. Beraberlik durumunda en küçük sınıf indeksi seçilir.

**k değerinin önemi:** Küçük k aşırı öğrenmeye (overfitting), büyük k ise yetersiz öğrenmeye (underfitting) yol açabilir. Bu projede k = {1, 3, 5, 7, 9, 11} denenerek en iyi k seçilir.

---

## Dosya Yapısı

| Dosya | Tür | Açıklama |
|---|---|---|
| `yukle_ve_isle.m` | Fonksiyon | Veri yükleme, etiket dönüşümü, stratified bölme, Min-Max normalizasyon |
| `knn_siniflandirici.m` | Fonksiyon | Sıfırdan KNN — vektörize Öklid mesafesi, çoğunluk oylaması |
| `main.m` | Betik | Tüm adımları çalıştırır, özet tabloyu yazdırır, 4 grafik üretir |
| `README.md` | Belge | Bu dosya |

---

## Nasıl Çalıştırılır?

**Gereksinimler:** MATLAB R2020b veya üzeri. Ek toolbox gerekmez.

**Adımlar:**

1. MATLAB'ı açın.
2. Bu klasörü (tüm `.m` dosyalarının bulunduğu dizini) MATLAB çalışma dizini olarak ayarlayın:
   ```matlab
   cd('<bu_klasörün_yolu>')
   ```
3. Komut penceresine aşağıdakini yazın ve Enter'a basın:
   ```matlab
   main
   ```
4. MATLAB konsola özet tabloyu yazdırır ve 4 grafik penceresi açılır.

> **Not:** `main.m` bir betik (script) olduğu için `run('main.m')` komutuyla da çalıştırılabilir.

---

## Üretilen Çıktılar

### Konsol — Özet Tablo

```
=================================================================
  Iris KNN Siniflandirma Sonuclari
=================================================================
  K        Test Dogrulugu (%)     Hata Sayisi
-----------------------------------------------------------------
  1        96.67                  1           
  3        96.67                  1           
  5        96.67                  1            <-- en iyi
  ...
=================================================================
```

### Şekil 1 — K Değerine Göre Doğruluk
Her k değeri için test doğruluğunu gösteren çizgi grafiği. En iyi k altın yıldızla işaretlenir.

### Şekil 2 — Karışıklık Matrisi (En İyi k)
`imagesc` ile mavi tonlu ısı haritası. Her hücre gerçek/tahmin sınıf çiftinin örnek sayısını gösterir. Yüksek değerli hücrelerde beyaz, düşük değerli hücrelerde siyah yazı kullanılır.

### Şekil 3 — Karar Sınırı (Özellik 3 ve 4)
Taç yaprak uzunluğu ve genişliği kullanılarak oluşturulan 2B karar sınırı. Arka plan rengi hangi bölgenin hangi sınıfa ait olduğunu gösterir; gerçek örnekler işaretçilerle üzerine çizilir.

| Renk | Sınıf |
|---|---|
| Mavi | Setosa |
| Kırmızı | Versicolor |
| Yeşil | Virginica |

### Şekil 4 — Özellik Çifti Dağılım Matrisi
4×4 alt grafik ızgarası. **Köşegen:** her sınıf için üst üste bindirme histogramı. **Köşegen dışı:** iki özelliğin birbirine karşı scatter grafiği, gerçek sınıf rengine göre boyalı.

---

## Teknik Notlar

- **MATLAB versiyonu:** R2020b ve üzeri (`sgtitle`, `bsxfun` uyumluluğu için).
- **Toolbox bağımlılığı:** Yoktur. `pdist`, `knnsearch`, `ClassificationKNN` gibi Statistics and Machine Learning Toolbox fonksiyonları kullanılmamıştır.
- **Veri seti:** MATLAB yerleşik `fisheriris` — 150 örnek, 4 özellik, 3 sınıf (her sınıftan 50 örnek).
- **Normalizasyon:** Min-Max; normalizasyon parametreleri yalnızca eğitim verisinden hesaplanır, test verisine uygulanır (data leakage yoktur).
- **Bölme stratejisi:** Her sınıftan eşit oranda (%80 eğitim / %20 test) stratified örnekleme; `rng(42)` ile tekrarlanabilirlik sağlanır.
- **Mesafe hesabı:** `||a − b||² = ||a||² + ||b||² − 2aᵀb` açılımıyla tüm test–eğitim mesafeleri tek matris çarpımında hesaplanır.
