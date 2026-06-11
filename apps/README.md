# Lumentum Apps (Platform İstemcileri)

İnce istemciler — **iş mantığı burada yazılmaz**, `packages/` shared katmanından veri çekilir.

```
apps/
└── flutter/
    └── lumentum/     # Web + Android + iOS (tek Flutter projesi)
```

## Kurallar

- API çağrıları: `lumentum_shared` → `LumentumApiClient`
- Modeller: `lumentum_shared` modelleri (`TokenData`, vb.)
- Yeni ekran/feature: önce contracts'ta sözleşme var mı kontrol et
- Motor/pacing/lisans mantığını bu dizine kopyalama

## Geliştirme

```bash
cd apps/flutter/lumentum
flutter pub get
flutter run -d chrome    # Web
flutter run              # Mobil / Desktop
```
