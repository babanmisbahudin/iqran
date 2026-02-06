import 'dart:math';

class HadithData {
  final String arabicText;
  final String indonesianText;
  final String source;

  const HadithData({
    required this.arabicText,
    required this.indonesianText,
    required this.source,
  });
}

final List<HadithData> dailyHadiths = [
  const HadithData(
    arabicText: 'خَيْرُكُمْ مَنْ تَعَلَّمَ الْقُرْآنَ وَعَلَّمَهُ',
    indonesianText: 'Sebaik-baik kalian adalah yang mempelajari Al-Qur\'an dan mengاajarkannya',
    source: 'HR. Bukhari',
  ),
  const HadithData(
    arabicText: 'اقْرَءُوا الْقُرْآنَ فَإِنَّهُ يَأْتِي يَوْمَ الْقِيَامَةِ شَفِيعًا لِأَصْحَابِهِ',
    indonesianText: 'Bacalah Al-Qur\'an, karena ia akan datang pada hari kiamat sebagai pemberi syafa\'at bagi pembacanya',
    source: 'HR. Muslim',
  ),
  const HadithData(
    arabicText: 'مَنْ قَرَأَ حَرْفًا مِنْ كِتَابِ اللَّهِ فَلَهُ بِهِ حَسَنَةٌ',
    indonesianText: 'Barang siapa membaca satu huruf dari Al-Qur\'an, maka baginya satu kebaikan',
    source: 'HR. Tirmidzi',
  ),
  const HadithData(
    arabicText: 'الْمَاهِرُ بِالْقُرْآنِ مَعَ السَّفَرَةِ الْكِرَامِ الْبَرَرَةِ',
    indonesianText: 'Orang yang mahir membaca Al-Qur\'an bersama para malaikat yang mulia dan taat',
    source: 'HR. Bukhari Muslim',
  ),
  const HadithData(
    arabicText: 'زَيِّنُوا الْقُرْآنَ بِأَصْوَاتِكُمْ',
    indonesianText: 'Hiasilah Al-Qur\'an dengan suara kalian',
    source: 'HR. Abu Daud',
  ),
  const HadithData(
    arabicText: 'لَا حَسَدَ إِلَّا فِي اثْنَتَيْنِ رَجُلٌ آتَاهُ اللَّهُ الْقُرْآنَ',
    indonesianText: 'Tidak boleh iri kecuali pada dua hal, salah satunya orang yang diberi Allah Al-Qur\'an',
    source: 'HR. Bukhari',
  ),
  const HadithData(
    arabicText: 'إِنَّ اللَّهَ يَرْفَعُ بِهَذَا الْكِتَابِ أَقْوَامًا',
    indonesianText: 'Sesungguhnya Allah meninggikan derajat kaum dengan kitab ini (Al-Qur\'an)',
    source: 'HR. Muslim',
  ),
  const HadithData(
    arabicText: 'أَهْلُ الْقُرْآنِ هُمْ أَهْلُ اللَّهِ وَخَاصَّتُهُ',
    indonesianText: 'Ahli Al-Qur\'an adalah keluarga Allah dan orang-orang pilihan-Nya',
    source: 'HR. Ahmad, Ibnu Majah',
  ),
  const HadithData(
    arabicText: 'تَعَاهَدُوا الْقُرْآنَ',
    indonesianText: 'Peliharalah (hafalan) Al-Qur\'an kalian',
    source: 'HR. Bukhari Muslim',
  ),
  const HadithData(
    arabicText: 'مَنْ قَرَأَ الْقُرْآنَ وَعَمِلَ بِمَا فِيهِ دُعِيَ بِأَبَوَيْهِ يَوْمَ الْقِيَامَةِ',
    indonesianText: 'Barang siapa membaca Al-Qur\'an dan mengamalkan isinya, maka orang tuanya dipanggil pada hari kiamat',
    source: 'HR. Abu Daud',
  ),
  const HadithData(
    arabicText: 'الْقُرْآنُ حَبْلُ اللَّهِ الْمَتِينُ',
    indonesianText: 'Al-Qur\'an adalah tali Allah yang sangat kuat',
    source: 'HR. Muslim',
  ),
  const HadithData(
    arabicText: 'مَنْ مَرَّ عَلَيْهِ بِالْقُرْآنِ لَيْلًا وَنَهَارًا لَمْ يَجِدِ',
    indonesianText: 'Barang siapa membaca Al-Qur\'an siang dan malam, maka... (akan mendapat pahala yang berlipat)',
    source: 'Hadits',
  ),
  const HadithData(
    arabicText: 'خَيْرُ الْعِبَادَةِ فِي هَذِهِ الْأُمَّةِ قِرَاءَةُ الْقُرْآنِ',
    indonesianText: 'Sebaik-baik ibadah di antara umat ini adalah membaca Al-Qur\'an',
    source: 'Hadits',
  ),
  const HadithData(
    arabicText: 'الْقُرْآنُ يَشْفَعُ لِصَاحِبِهِ يَوْمَ الْقِيَامَةِ',
    indonesianText: 'Al-Qur\'an akan memberikan syafa\'at untuk pembacanya pada hari kiamat',
    source: 'Hadits',
  ),
  const HadithData(
    arabicText: 'اقْرَأِ الْقُرْآنَ فَإِنَّهُ يَأْتِي يَوْمَ الْقِيَامَةِ',
    indonesianText: 'Bacalah Al-Qur\'an karena ia akan datang untuk menolong pada hari kiamat',
    source: 'HR. Muslim',
  ),
  const HadithData(
    arabicText: 'الَّذِي يَقْرَأُ الْقُرْآنَ وَيَتَعَاهَدُهُ أَشَدُّ اجْتِهَادًا',
    indonesianText: 'Orang yang membaca Al-Qur\'an dan menjaganya lebih bersungguh-sungguh',
    source: 'HR. Bukhari',
  ),
  const HadithData(
    arabicText: 'فَضْلُ الْقُرْآنِ عَلَى سَائِرِ الْكَلَامِ كَفَضْلِ اللَّهِ عَلَى خَلْقِهِ',
    indonesianText: 'Keutamaan Al-Qur\'an atas ucapan lain seperti keutamaan Allah atas makhluk-Nya',
    source: 'HR. Tirmidzi',
  ),
  const HadithData(
    arabicText: 'إِذَا دَخَلَ الرَّجُلُ الْجَنَّةَ حَبَّرَهُ بِالْقُرْآنِ',
    indonesianText: 'Ketika seseorang masuk surga, maka Al-Qur\'an akan memperindahnya',
    source: 'Hadits',
  ),
  const HadithData(
    arabicText: 'الْقُرْآنُ نُورٌ عَلَى نُورٍ',
    indonesianText: 'Al-Qur\'an adalah cahaya di atas cahaya',
    source: 'Hadits',
  ),
  const HadithData(
    arabicText: 'مَنْ أَحَبَّ الْقُرْآنَ أَحَبَّهُ اللَّهُ وَرَسُولُهُ',
    indonesianText: 'Barang siapa mencintai Al-Qur\'an, maka Allah dan Rasul-Nya juga akan mencintainya',
    source: 'Hadits',
  ),
];

// Get a random hadith
HadithData getRandomHadith() {
  final random = Random();
  return dailyHadiths[random.nextInt(dailyHadiths.length)];
}

// Get hadith by index
HadithData getHadithByIndex(int index) {
  if (index < 0 || index >= dailyHadiths.length) {
    return dailyHadiths[0];
  }
  return dailyHadiths[index];
}
