-- Verilənlər bazasının strukturunun yaradılması və optimallaşdırılması
CREATE LANGUAGE plpgsql;
-- 1. Cədvəllərin yaradılması
CREATE TABLE Grup (
    GrupId SERIAL PRIMARY KEY,
    GrupAd VARCHAR(50) NOT NULL
);

CREATE TABLE Mehsul (
    MehsulId SERIAL PRIMARY KEY,
    MehsulAd VARCHAR(50) UNIQUE NOT NULL,
    MehsulQiymet NUMERIC(10,2) NOT NULL,
    MehsulGrupId INTEGER NOT NULL,
    CONSTRAINT fk_grup FOREIGN KEY (MehsulGrupId) REFERENCES Grup(GrupId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Vezife (
    VezifeId SERIAL PRIMARY KEY,
    VezifeAd VARCHAR(50) UNIQUE NOT NULL,
    VezifeMaas NUMERIC(10,2) NOT NULL
);

CREATE TABLE Isci (
    IsciId SERIAL PRIMARY KEY,
    IsciAd VARCHAR(50) NOT NULL,
    IsciSoyad VARCHAR(50) NOT NULL,
    IsciAtaAd VARCHAR(50) NOT NULL,
    IsciTel VARCHAR(50) UNIQUE NOT NULL,
    IsciVezifeId INTEGER NOT NULL,
    CONSTRAINT fk_vezife FOREIGN KEY (IsciVezifeId) REFERENCES Vezife(VezifeId) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT isci_unique_combination UNIQUE (IsciAd, IsciSoyad, IsciAtaAd)
);

CREATE TABLE Stok (
    StokId SERIAL PRIMARY KEY,
    StokAd VARCHAR(50) UNIQUE NOT NULL,
    StokMehsulId INTEGER NOT NULL,
    StokMehsulSay INTEGER NOT NULL,
    StokYer VARCHAR(100),
    CONSTRAINT fk_mehsul FOREIGN KEY (StokMehsulId) REFERENCES Mehsul(MehsulId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Istehsalci (
    IstehsalciId SERIAL PRIMARY KEY,
    IstehsalciAd VARCHAR(50) UNIQUE NOT NULL,
    IstehsalciTel VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Musteri (
    MusteriId SERIAL PRIMARY KEY,
    MusteriAd VARCHAR(50) NOT NULL,
    MusteriSoyad VARCHAR(50) NOT NULL,
    MusteriAtaAd VARCHAR(50) NOT NULL,
    MusteriUnvan VARCHAR(150) NOT NULL,
    MusteriTel VARCHAR(50) UNIQUE NOT NULL,
    MusteriEpoct VARCHAR(150) UNIQUE NOT NULL,
    CONSTRAINT musteri_unique_combination UNIQUE (MusteriAd, MusteriSoyad, MusteriAtaAd)
);

CREATE TABLE Satis (
    SatisId SERIAL PRIMARY KEY,
    SatisMehsulId INTEGER NOT NULL,
    SatisIsciId INTEGER NOT NULL,
    SatisStokId INTEGER NOT NULL,
    SatisIstehsalciId INTEGER NOT NULL,
    SatisMusteriId INTEGER NOT NULL,
    SatisTarix DATE NOT NULL,
    SatisMehsulSay INTEGER NOT NULL,
    SatisUmumiMebleg NUMERIC(10,2) NOT NULL,
    CONSTRAINT fk_mehsul FOREIGN KEY (SatisMehsulId) REFERENCES Mehsul(MehsulId) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_isci FOREIGN KEY (SatisIsciId) REFERENCES Isci(IsciId) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_stok FOREIGN KEY (SatisStokId) REFERENCES Stok(StokId) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_istehsalci FOREIGN KEY (SatisIstehsalciId) REFERENCES Istehsalci(IstehsalciId) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_musteri FOREIGN KEY (SatisMusteriId) REFERENCES Musteri(MusteriId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Meneger (
    MenegerId INTEGER PRIMARY KEY,
    MenegerAd VARCHAR(50) NOT NULL,
    MenegerSoyad VARCHAR(50) NOT NULL,
    MenegerIsciId INTEGER,
    CONSTRAINT fk_isci FOREIGN KEY (MenegerIsciId) REFERENCES Isci(IsciId) ON DELETE SET NULL ON UPDATE CASCADE
);

-- 2. Indekslərin əlavə edilməsi
CREATE INDEX idx_mehsul_grupid ON Mehsul(MehsulGrupId);
CREATE INDEX idx_satis_mehsulid ON Satis(SatisMehsulId);
CREATE INDEX idx_satis_isciid ON Satis(SatisIsciId);
CREATE INDEX idx_satis_stokid ON Satis(SatisStokId);
CREATE INDEX idx_satis_istehsalciid ON Satis(SatisIstehsalciId);
CREATE INDEX idx_satis_musteriid ON Satis(SatisMusteriId);

-- 3. Məlumatların daxil edilməsi
INSERT INTO Grup (GrupAd) VALUES
('Xəstəliklər üçün'),
('Vitamin və minerallar'),
('Kozmetik məhsullar'),
('Medikal avadanlıqlar'),
('Xidmətlər'),
('Gıda əlavələri'),
('Kafedra tələbləri');

INSERT INTO Mehsul (MehsulAd, MehsulQiymet, MehsulGrupId) VALUES
('Aspirin', 4.09, 1),
('Parasetamol', 0.15, 1),
('Vitamin C', 29.40, 2),
('Vitamin D', 28.40, 2),
('La Rosche-Posay Kerium', 52.90, 3),
('Berdoues 1902 edc Tonique Odekalon', 30.90, 3),
('Qlükometr "Beuer" GL44', 39.90, 4),
('Sensolite Nova', 18.60, 4),
('"Swiss Energy" Omega3', 26.30, 6),
('Süd içkisi "Mamako 3"', 12.20, 6),
('Pulsoksimetr', 94.90, 7),
('Hava nəmləndirici aromatizator', 109.90, 7);

INSERT INTO Istehsalci (IstehsalciAd, IstehsalciTel) VALUES
('Teva', '+49 (0)731 402 - 02'),
('Pfizer', '+49 (0) 30 / 55 00 55-51000'),
('Beurer', '+49 (0) 30 / 87 24 30-91630'),
('Sanofi', '(012) 437 16 48'),
('AstraZeneca', '0800 22 88 660');

INSERT INTO Vezife (VezifeAd, VezifeMaas) VALUES
('Müdir', 3200.00),
('Satış agenti', 900.00),
('Məhsul idarəçisi', 1200.00),
('Məhsul alma agenti', 1100.00),
('Məlumat üzrə işçi', 1300.00),
('Kuryer', 800.00),
('Finans mütəxəssisi', 2500.00),
('Anbar işçisi', 850.00),
('Təchizatçı', 1250.00);

INSERT INTO Stok (StokAd, StokMehsulId, StokMehsulSay) VALUES
('Aspirin', 1, 200),
('Aromatizator', 12, 300),
('Qlükometr', 7, 150),
('Pulsoksimetr', 11, 250),
('Vitamin D', 4, 100),
('Vitamin C', 3, 200);

INSERT INTO Isci (IsciAd, IsciSoyad, IsciAtaAd, IsciTel, IsciVezifeId) VALUES
('Elçin', 'Həsənov', 'Rəşid', '070 456 12 34', 1),
('Günay', 'Əliyeva', 'Kamran', '055 321 98 76', 2),
('Tural', 'Səfərov', 'Əkbər', '077 654 23 01', 3),
('Aygün', 'Rəhimova', 'Nəsir', '050 789 45 67', 4),
('Fərid', 'Qədirli', 'Əli', '051 234 87 90', 5),
('Samir', 'Əhmədov', 'Tahir', '070 890 12 34', 6),
('Nigar', 'Cəfərova', 'Vəli', '055 567 34 89', 7),
('Rovşən', 'İsmayılov', 'Hüseyn', '077 123 67 90', 8),
('Zəhra', 'Xəlilova', 'Əziz', '050 345 89 12', 9);

INSERT INTO Musteri (MusteriAd, MusteriSoyad, MusteriAtaAd, MusteriUnvan, MusteriTel, MusteriEpoct) VALUES
('Adil', 'Nəzirli', 'Azad', 'Zaqatala şəhəri,A. Qardaşov 11, ev 20', '050 111 22 33', 'adil.nezirli@gmail.com'),
('Həmzət', 'Nəzirli', 'Azad', 'Zaqatala şəhəri, A. Qardaşov 11, ev 20 ', '055 222 33 44', 'hamzat.nezirli@yahoo.com'),
('Oruc', 'Aslanov', 'Hacı', 'Zaqatala şəhəri, Şah İsmayıl küçəsi, ev 89', '070 333 44 55', 'oruc.aslanov@outlook.com'),
('Ramazan', 'Əliyev', 'Əhməd', 'Zaqatala şəhəri, Nizami küçəsi, ev 5A', '077 444 55 66', 'ramazan.aliyev@gmail.com'),
('İmran', 'Vəliyev', 'Həbib', 'Zaqatala şəhəri, Heydər Əliyev prospekti, ev 29', '055 555 66 77', 'imran.veliyev@protonmail.com'),
('İlqar', 'Yekeyev', 'Ramin', 'Zaqatala şəhəri, Azadlıq küçəsi, ev 3', '051 666 77 88', 'ilqar.yekeyev@aol.com'),
('Fatma', 'Zamanova', 'Abdullah', 'Zaqatala şəhəri, Əhməd Cavad küçəsi, ev 17', '055 777 88 99', 'fatma.zamanova@live.com'),
('Cuma', 'Arixov', 'Fikrət', 'Zaqatala şəhəri, Məşədi Əzizbəyov küçəsi, ev 34', '051 888 99 00', 'cuma.arixov@icloud.com'),
('Sevinc', 'İsayeva', 'İsmət', 'Zaqatala şəhəri, Qara Qarayev küçəsi, ev 4', '070 999 00 11', 'sevinc.isayeva@zoho.com'),
('Aysu', 'Əsədova', 'Saleh', 'Zaqatala şəhəri, Təbriz Xəlqov küçəsi, ev 21', '070 111 22 33', 'aysu.asedova@yahoo.com'),
('Xanım', 'Məmmədli', 'Elman', 'Zaqatala şəhəri, Məhəmməd Hadi küçəsi, ev 19A', '050 222 33 44', 'xanim.mammedli@gmail.com'),
('Nicad', 'Ağayev', 'Nizami', 'Zaqatala şəhəri, Şərifzade Əliyev küçəsi, ev 7B', '077 333 44 55', 'nicad.agayev@outlook.com');

INSERT INTO Satis (SatisMehsulId, SatisIsciId, SatisStokId, SatisIstehsalciId, SatisMusteriId, SatisTarix, SatisMehsulSay, SatisUmumiMebleg) VALUES
(1, 10, 1, 1, 1, '2023-03-12', 2, 8.18),
(12, 11, 2, 3, 2, '2023-04-15', 1, 109.90),
(7, 12, 3, 2, 5, '2023-03-01', 1, 39.90),
(11, 7, 4, 4, 7, '2023-04-10', 1, 94.90),
(4, 13, 5, 5, 8, '2023-01-11', 1, 28.40),
(3, 12, 6, 1, 10, '2023-04-13', 1, 29.40),
(1, 7, 1, 2, 12, '2023-02-25', 3, 12.12),
(12, 12, 2, 3, 9, '2023-01-30', 1, 109.90),
(7, 10, 3, 4, 3, '2023-03-31', 1, 39.90),
(11, 7, 4, 5, 4, '2023-02-05', 1, 94.90),
(4, 10, 5, 5, 11, '2023-02-09', 1, 28.40),
(3, 11, 6, 2, 6, '2023-03-22', 1, 29.40),
(1, 12, 1, 1, 1, '2023-04-19', 3, 12.12),
(12, 13, 2, 4, 5, '2023-01-04', 1, 109.90),
(7, 11, 3, 3, 10, '2023-02-17', 1, 39.90);

INSERT INTO Meneger (MenegerId, MenegerAd, MenegerSoyad, MenegerIsciId) VALUES
(1, 'Aysun', 'Ağazadə', NULL),
(2, 'Cavad', 'Nəzirli', 3),
(3, 'Vasif', 'Babazadə', 6),
(4, 'Aytən', 'Mehdiyeva', 9),
(5, 'Rəvan', 'Ağayev', 1);

-- 4. Prosedurların yaradılması
CREATE OR REPLACE PROCEDURE MehsulInsert(
    p_MehsulAd VARCHAR,
    p_MehsulQiymet NUMERIC(10,2),
    p_MehsulGrupId INTEGER
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Mehsul (MehsulAd, MehsulQiymet, MehsulGrupId)
    VALUES (p_MehsulAd, p_MehsulQiymet, p_MehsulGrupId);
END;
$$;

CALL MehsulInsert('Valerian', 2.00, 1);

CREATE OR REPLACE PROCEDURE VezifeMaasArtimi(p_VezifeId INTEGER)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE Vezife
    SET VezifeMaas = VezifeMaas + VezifeMaas * 0.05
    WHERE VezifeId = p_VezifeId;
END;
$$;

CALL VezifeMaasArtimi(4);

CREATE OR REPLACE PROCEDURE IsciMaasArtimi(p_IsciId INTEGER)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE Vezife
    SET VezifeMaas = VezifeMaas + VezifeMaas * 0.05
    WHERE VezifeId = (SELECT IsciVezifeId FROM Isci WHERE IsciId = p_IsciId);
END;
$$;

CALL IsciMaasArtimi(4);

-- 5. Triger və funksiyanın yaradılması
CREATE OR REPLACE FUNCTION Func_SatisAlgoritmi()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT StokMehsulSay FROM Stok WHERE StokId = NEW.SatisStokId) < NEW.SatisMehsulSay THEN
        RAISE EXCEPTION 'Stokda kifayət qədər məhsul yoxdur!';
    END IF;
    UPDATE Stok
    SET StokMehsulSay = StokMehsulSay - NEW.SatisMehsulSay
    WHERE StokId = NEW.SatisStokId;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Trig_SatisAlgoritmi
AFTER INSERT ON Satis
FOR EACH ROW
EXECUTE FUNCTION Func_SatisAlgoritmi();

-- 6. Görünüşlərin yaradılması
CREATE OR REPLACE VIEW IsinTeskili AS
SELECT i.IsciAd AS Ad, i.IsciSoyad AS Soyad, v.VezifeAd AS Vezife, v.VezifeMaas AS Maas
FROM Isci i
INNER JOIN Vezife v ON i.IsciVezifeId = v.VezifeId;

CREATE OR REPLACE VIEW SatisHesabati AS
SELECT s.SatisId AS SatisID, s.SatisTarix AS Tarix, s.SatisUmumiMebleg AS ToplamMebleg,
       s.SatisMehsulSay AS MehsulSay, m.MehsulAd AS Mehsul, i.IsciAd AS SaticiAd,
       i.IsciSoyad AS SaticiSoyad, mu.MusteriAd AS MusteriAd, mu.MusteriSoyad AS MusteriSoyad
FROM Satis s
INNER JOIN Mehsul m ON s.SatisMehsulId = m.MehsulId
INNER JOIN Isci i ON s.SatisIsciId = i.IsciId
INNER JOIN Musteri mu ON s.SatisMusteriId = mu.MusteriId;

-- 7. Sorğular
-- Mehsul və Grup cədvəllərinin birləşdirilməsi
SELECT m.MehsulAd, m.MehsulQiymet, g.GrupAd
FROM Mehsul m
RIGHT JOIN Grup g ON m.MehsulGrupId = g.GrupId;

-- İşçi və Vəzifə cədvəllərinin birləşdirilməsi
SELECT i.IsciAd, i.IsciSoyad, v.VezifeAd, v.VezifeMaas
FROM Isci i
FULL JOIN Vezife v ON i.IsciVezifeId = v.VezifeId;

-- Satış məlumatlarının tam birləşdirilməsi
SELECT s.SatisId, s.SatisTarix, s.SatisUmumiMebleg, m.MehsulAd, i.IsciAd, i.IsciSoyad,
       st.StokAd, ist.IstehsalciAd, mu.MusteriAd, mu.MusteriSoyad
FROM Satis s
INNER JOIN Mehsul m ON s.SatisMehsulId = m.MehsulId
INNER JOIN Isci i ON s.SatisIsciId = i.IsciId
INNER JOIN Stok st ON s.SatisStokId = st.StokId
INNER JOIN Istehsalci ist ON s.SatisIstehsalciId = ist.IstehsalciId
INNER JOIN Musteri mu ON s.SatisMusteriId = mu.MusteriId;

-- Şərtli sorğular
SELECT VezifeAd, VezifeMaas
FROM Vezife
WHERE VezifeMaas >= 1000 AND VezifeAd = 'Müdir';

SELECT VezifeAd, VezifeMaas
FROM Vezife
WHERE VezifeMaas <= 1000 AND VezifeAd != 'Kuryer';

SELECT VezifeAd, VezifeMaas
FROM Vezife
WHERE VezifeMaas <= 1000 OR VezifeAd = 'Müdir';

SELECT MehsulAd, MehsulQiymet
FROM Mehsul
LIMIT 5;

SELECT DISTINCT VezifeAd
FROM Vezife;

SELECT VezifeAd, VezifeMaas
FROM Vezife
ORDER BY VezifeMaas DESC;

-- Qruplaşdırma sorğuları
SELECT StokAd, COUNT(StokMehsulSay) AS MehsulSay
FROM Stok
GROUP BY StokAd;

SELECT g.GrupAd, SUM(m.MehsulQiymet) AS ToplamQiymet
FROM Mehsul m
INNER JOIN Grup g ON m.MehsulGrupId = g.GrupId
GROUP BY g.GrupAd
ORDER BY ToplamQiymet DESC;

SELECT s.SatisId, s.SatisIsciId, SUM(s.SatisMehsulSay) AS ToplamMehsulSay
FROM Satis s
GROUP BY s.SatisId, s.SatisIsciId
ORDER BY s.SatisId;

SELECT s.SatisId, s.SatisTarix
FROM Satis s
GROUP BY s.SatisId, s.SatisTarix;

SELECT CAST(s.SatisTarix AS DATE) AS Tarix, SUM(s.SatisUmumiMebleg) AS ToplamMebleg
FROM Satis s
GROUP BY CAST(s.SatisTarix AS DATE);

SELECT s.SatisId, SUM(s.SatisUmumiMebleg) AS ToplamMebleg
FROM Satis s
GROUP BY s.SatisId
HAVING SUM(s.SatisUmumiMebleg) > 30;

-- UNION və digər birləşdirmələr
SELECT IsciAd, IsciSoyad, IsciAtaAd
FROM Isci
UNION
SELECT MusteriAd, MusteriSoyad, MusteriAtaAd
FROM Musteri;

SELECT IsciAd, IsciSoyad, IsciAtaAd
FROM Isci
UNION ALL
SELECT MusteriAd, MusteriSoyad, MusteriAtaAd
FROM Musteri;

SELECT IsciAtaAd
FROM Isci
INTERSECT
SELECT MusteriAtaAd
FROM Musteri;

SELECT IsciAd, IsciSoyad, IsciAtaAd
FROM Isci
EXCEPT
SELECT MusteriAd, MusteriSoyad, MusteriAtaAd
FROM Musteri;

-- Qruplaşdırma dəstləri
SELECT SatisId, SatisIsciId, SUM(SatisUmumiMebleg) AS ToplamMebleg
FROM Satis
GROUP BY GROUPING SETS ((SatisId, SatisIsciId), (SatisId), (SatisIsciId), ());

SELECT SatisId, SatisMehsulSay, SUM(SatisUmumiMebleg) AS ToplamMebleg
FROM Satis
GROUP BY SatisId, ROLLUP(SatisMehsulSay);

-- Alt sorğular
SELECT VezifeAd, VezifeMaas
FROM Vezife
WHERE VezifeMaas > (SELECT AVG(VezifeMaas) FROM Vezife);

SELECT i.IsciId, i.IsciAd, i.IsciSoyad
FROM Isci i
WHERE i.IsciId IN (
    SELECT v.VezifeId
    FROM Vezife v
    INNER JOIN Isci i2 ON v.VezifeId = i2.IsciVezifeId
    WHERE v.VezifeId = 6
);

SELECT i.IsciAd, i.IsciSoyad
FROM Isci i
WHERE EXISTS (
    SELECT 1
    FROM Vezife v
    WHERE v.VezifeId = i.IsciVezifeId
);

SELECT m.MehsulAd
FROM Mehsul m
WHERE m.MehsulQiymet > ANY (
    SELECT AVG(s.SatisUmumiMebleg)
    FROM Satis s
);

SELECT m.MehsulAd
FROM Mehsul m
WHERE m.MehsulQiymet > ALL (
    SELECT AVG(s.SatisUmumiMebleg)
    FROM Satis s
);

SELECT m.MehsulAd
FROM Mehsul m
WHERE m.MehsulId = ANY (
    SELECT s.StokId
    FROM Stok s
    WHERE s.StokId < 4
);

-- Test sorğusu
INSERT INTO Satis (SatisMehsulId, SatisIsciId, SatisStokId, SatisIstehsalciId, SatisMusteriId, SatisTarix, SatisMehsulSay, SatisUmumiMebleg)
VALUES (2, 10, 1, 1, 8, '2023-05-08', 1, 0.15);

SELECT * FROM Stok;
SELECT * FROM IsinTeskili;
SELECT * FROM SatisHesabati;
