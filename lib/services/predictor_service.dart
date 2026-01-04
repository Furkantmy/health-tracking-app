class PredictorService {
  static bool _modelLoaded = false;

  static Future<void> loadModel() async {
    // Model yükleme simülasyonu
    await Future.delayed(const Duration(seconds: 1));
    _modelLoaded = true;
  }

  static String classify(double steps, double sleepHours) {
    if (!_modelLoaded) {
      return "Model yüklenmedi";
    }

    // Basit sınıflandırma algoritması
    if (steps >= 10000 && sleepHours >= 7) {
      return "Mükemmel";
    } else if (steps >= 8000 && sleepHours >= 6) {
      return "İyi";
    } else if (steps >= 5000 && sleepHours >= 5) {
      return "Orta";
    } else {
      return "Geliştirilebilir";
    }
  }
}
