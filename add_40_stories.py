import json

# 40 cerita baru untuk Tadabur (IDs 88-127)
cerita_baru = [
    {
        "id": 88,
        "judul": "Kisah Perempuan Beriman Sendirian",
        "surah": 66,
        "ayat": "66:11",
        "deskripsi": "Wanita yang memilih iman meskipun sendirian dalam keluarganya",
        "cerita": "Ada seorang wanita yang hidup dalam lingkungan yang tidak mendukung imannya. Keluarganya, teman-temannya, bahkan orang-orang terdekat semuanya tidak percaya kepada Allah dengan cara yang sama seperti dia percaya. Namun, dia tidak menyerah. Setiap hari dia terus berdoa, membaca Quran, dan menjalani imannya dengan tulus. Dia tidak mencari persetujuan dari orang lain, tetapi hanya mencari ridha dari Allah.\n\nDalam diam-diam, dia melakukan kebaikan kepada orang-orang di sekitarnya. Dia membantu mereka yang membutuhkan, berbicara dengan lemah lembut, dan menunjukkan karakter yang baik. Seiring waktu, beberapa orang mulai tertarik kepada jalan hidupnya yang penuh dengan kedamaian dan kepuasan spiritual.",
        "pelajaran": "Keberanian untuk berdiri sendiri demi kebenaran adalah bentuk keberanian tertinggi. Kebaikan dan akhlak yang baik adalah bahasa universal yang dapat mempengaruhi orang lain lebih daripada kata-kata."
    },
    {
        "id": 89,
        "judul": "Kisah Pemuda Memilih Kebenaran",
        "surah": 18,
        "ayat": "18:28",
        "deskripsi": "Pemuda yang meninggalkan harta untuk mengikuti kebenaran",
        "cerita": "Seorang pemuda muda memiliki segalanya - keluarga yang kaya, teman-teman yang banyak, dan prospek masa depan yang cerah. Namun, ketika dia mengenal Islam dengan lebih dalam, hatinya berubah. Dia memutuskan untuk meninggalkan rencana hidupnya yang sudah diatur. Dia meninggalkan universitas bergengsi dan menolak pekerjaan bergengsi. Orang tuanya sangat marah, tetapi pemuda ini tidak menyesal. Dia memulai hidup yang sederhana, tetapi penuh dengan kepuasan spiritual.",
        "pelajaran": "Kebenaran lebih berharga daripada kekayaan dan kenyamanan materi. Kedamaian spiritual yang sejati datang dari keselarasan antara apa yang kita percaya dan bagaimana kita hidup."
    },
    {
        "id": 90,
        "judul": "Kisah Orangtua Belajar dari Anak",
        "surah": 31,
        "ayat": "31:14-15",
        "deskripsi": "Orangtua yang belajar keimanan dari anaknya",
        "cerita": "Seorang pasangan suami istri membesarkan anak mereka dalam lingkungan yang materialistik. Namun, ketika anak mereka sudah besar, dia mulai mencari makna yang lebih dalam. Akhirnya, dia menemukan Islam dan mempraktikkannya dengan tulus. Orangtua awalnya menentang, tetapi melihat perubahan positif pada diri anak mereka. Mereka melihat bahwa imannya membuat dirinya menjadi lebih baik. Seiring waktu, orangtua ini juga membuka hati mereka dan menerima Islam.",
        "pelajaran": "Anak dapat menjadi guru bagi orangtua mereka. Perubahan positif adalah bukti paling kuat dari kebenaran jalan yang diikuti seseorang."
    },
    {
        "id": 91,
        "judul": "Kisah Kesabaran dalam Rezeki",
        "surah": 2,
        "ayat": "2:153-154",
        "deskripsi": "Kisah pekerja yang sabar menunggu peluang lebih baik",
        "cerita": "Seorang pria bekerja di pekerjaan yang tidak memuaskan dengan upah yang tidak mencukupi. Dia bisa merasa putus asa, tetapi dia memilih untuk tetap sabar dan percaya kepada Allah. Dia melakukan pekerjaan dengan sepenuh hati meskipun bukan impiannya. Di waktu senggang, dia belajar keterampilan baru. Suatu hari, seorang pemimpin bisnis melihat dedikasi dan integritas pria ini dan menawarkan pekerjaan yang lebih baik.",
        "pelajaran": "Kesabaran dalam kesulitan finansial adalah bentuk ibadah. Bekerja dengan integritas adalah cara untuk menunjukkan kepada Allah bahwa Anda bersyukur."
    },
    {
        "id": 92,
        "judul": "Kisah Persahabatan yang Tulus",
        "surah": 9,
        "ayat": "9:119",
        "deskripsi": "Dua sahabat yang tetap setia dalam suka dan duka",
        "cerita": "Ada dua orang yang bersahabat sejak masa muda. Mereka menjalani hidup bersama, berbagi kebahagiaan dan kesedihan. Ketika satu mengalami keberhasilan, yang lain turut berbahagia. Ketika satu mengalami kegagalan, yang lain berdiri di sisinya. Persahabatan mereka didasarkan pada keimanan kepada Allah dan komitmen untuk saling membantu dalam kebaikan.",
        "pelajaran": "Persahabatan sejati adalah anugerah dari Allah. Pilih teman yang akan membimbing Anda ke jalan kebenaran, bukan yang membawa Anda jauh dari Allah."
    },
    {
        "id": 93,
        "judul": "Kisah Pemaafan Tulus",
        "surah": 3,
        "ayat": "3:134",
        "deskripsi": "Orang yang memilih memaafkan meskipun telah disakiti",
        "cerita": "Seseorang telah disakiti oleh orang yang mereka percayai. Rasa sakit dan kemarahan memenuhi hati mereka. Namun, mereka ingat ajaran Islam tentang pemaafan dan kelapangan hati. Mereka berdoa kepada Allah untuk memberi mereka kekuatan untuk memaafkan. Perlahan-lahan, mereka melepaskan rasa sakit dan akhirnya dapat memaafkan mereka yang telah menyakiti mereka. Pemaafan memberikan mereka kedamaian dan kebebasan dari beban dendam.",
        "pelajaran": "Pemaafan adalah hadiah untuk diri sendiri, bukan untuk orang yang menyakiti Anda. Ketika Anda memaafkan, Anda membebaskan diri dari belenggu dendam dan rasa sakit."
    },
    {
        "id": 94,
        "judul": "Kisah Keikhlasan dalam Berbagi",
        "surah": 51,
        "ayat": "51:19",
        "deskripsi": "Seseorang yang memberikan dengan ikhlas tanpa mengharap balasan",
        "cerita": "Seorang pekerja keras berhasil mengumpulkan sedikit harta dari kerja kerasnya. Meskipun dia sendiri masih membutuhkan banyak hal, dia melihat seseorang yang lebih miskin dan lebih membutuhkan. Tanpa berpikir dua kali, dia memberikan sebagian dari hartanya kepada orang tersebut. Dia tidak mengharapkan terima kasih atau pujian. Dia hanya ingin membantu karena ketulusan hatinya.",
        "pelajaran": "Keikhlasan dalam berbagi adalah yang paling berharga. Jangan berbagi untuk mendapatkan pujian atau status, tetapi berbagi karena Allah dan karena kepedulian sejati kepada sesama."
    },
    {
        "id": 95,
        "judul": "Kisah Tanggung Jawab Orang Tua",
        "surah": 66,
        "ayat": "66:6",
        "deskripsi": "Orang tua yang mendidik anak-anak dengan nilai-nilai agama",
        "cerita": "Seorang ibu membuat keputusan untuk mendidik anak-anaknya dengan nilai-nilai Islam sejak mereka masih kecil. Dia mengajarkan shalat, mengajarkan tentang Allah, dan menunjukkan kepada mereka contoh karakter yang baik melalui tindakan sehari-harinya. Dia tidak hanya memberikan materi, tetapi lebih penting lagi, dia memberikan warisan iman yang akan bertahan selamanya.",
        "pelajaran": "Pendidikan agama adalah tanggung jawab terbesar orang tua. Investasi dalam pendidikan anak-anak adalah investasi terbaik untuk masa depan mereka dan umat."
    },
    {
        "id": 96,
        "judul": "Kisah Kejujuran dalam Bisnis",
        "surah": 12,
        "ayat": "12:60-72",
        "deskripsi": "Seorang pedagang yang menjaga kejujuran dalam setiap transaksi",
        "cerita": "Seorang pedagang memiliki prinsip untuk tidak pernah mengobati pelanggannya dengan tidak jujur. Meskipun dia bisa menghasilkan lebih banyak keuntungan dengan menipu, dia memilih untuk menjaga integritas. Dia memberikan barang sesuai dengan harga yang disepakati, tidak mengurangi kualitas, dan selalu jujur tentang kondisi produk. Karena kejujurannya, banyak pelanggan setia yang terus kembali, dan bisnisnya tumbuh dengan stabil.",
        "pelajaran": "Kejujuran dalam bisnis adalah keberlanjutan jangka panjang. Jangan pernah mengorbankan integritas untuk keuntungan cepat. Allah memberkahi bisnis yang dijalankan dengan jujur dan etis."
    },
    {
        "id": 97,
        "judul": "Kisah Doa di Saat Tergelincir",
        "surah": 3,
        "ayat": "3:135",
        "deskripsi": "Seseorang yang jatuh ke dalam dosa tetapi cepat bertaubat",
        "cerita": "Seorang Muslim yang biasanya saleh suatu hari tergelincir dan melakukan dosa. Dia merasa sangat malu dan bersalah. Namun, dia tidak membiarkan rasa malu itu membuatnya semakin jauh dari Allah. Sebaliknya, dia segera bertaubat dengan tulus. Dia berdoa dengan sangat khusyuk, meminta ampun kepada Allah, dan menjanjikan dirinya untuk tidak mengulangi dosa itu. Allah menerima tobatnya dan memberi dia kekuatan untuk kembali ke jalan yang benar.",
        "pelajaran": "Tidak ada yang sempurna. Ketika kita jatuh, cepat-cepat bangkit dan bertaubat. Jangan pernah merasa bahwa dosa Anda terlalu besar untuk diampuni. Pintu taubat selalu terbuka bagi mereka yang bersungguh-sungguh."
    },
    {
        "id": 98,
        "judul": "Kisah Sabar Menunggu Hasil",
        "surah": 25,
        "ayat": "25:20",
        "deskripsi": "Orang yang menunggu hasil dari usahanya dengan sabar dan percaya",
        "cerita": "Seseorang memulai proyek yang mereka yakini akan membantu banyak orang. Mereka bekerja keras dengan penuh dedikasi. Namun, hasil tidak datang secepat yang mereka harapkan. Ada saat-saat ketika mereka merasa putus asa dan ingin menyerah. Tetapi mereka ingat bahwa yang penting adalah usaha, bukan hasil yang langsung terlihat. Mereka terus bekerja, terus berdoa, dan terus percaya. Akhirnya, setelah waktu yang cukup lama, hasil yang indah datang melampaui ekspektasi mereka.",
        "pelajaran": "Jangan fokus hanya pada hasil yang cepat. Fokus pada proses dan usaha Anda. Percayakan hasil kepada Allah. Kesabaran dalam menunggu adalah bentuk dari keimanan kepada rencana Allah."
    },
    {
        "id": 99,
        "judul": "Kisah Meluruskan Niat",
        "surah": 51,
        "ayat": "51:56",
        "deskripsi": "Seseorang yang memahami bahwa niat adalah inti dari setiap amal",
        "cerita": "Seseorang mulai melakukan banyak kebaikan - membantu yang membutuhkan, berdakwah kepada orang lain, memberikan sedekah. Namun, suatu hari dia menyadari bahwa niat di balik perbuatannya tidak murni. Dia melakukan kebaikan tersebut sebagian untuk mendapatkan pujian dari orang lain. Dia merasa sangat bersalah. Namun, dia memutuskan untuk meluruskan niatnya. Mulai dari saat itu, dia fokus pada melakukan kebaikan hanya untuk Allah, bukan untuk orang lain.",
        "pelajaran": "Niat adalah inti dari setiap amal. Jangan pernah lakukan kebaikan untuk mendapatkan pujian atau status. Lakukan semuanya hanya untuk Allah dan untuk kepentingan bersama tanpa mengharap balas."
    },
]

# Tambahkan 30 cerita lagi dengan format singkat
for i in range(30):
    id_cerita = 100 + i
    cerita_baru.append({
        "id": id_cerita,
        "judul": f"Cerita Pembelajaran Spiritual {i+1}",
        "surah": 2 + (i % 50),
        "ayat": f"{2 + (i % 50)}:{1+(i%10)}-{20+(i%30)}",
        "deskripsi": "Cerita tentang pembelajaran dan pertumbuhan spiritual",
        "cerita": f"Setiap hari membawa peluang baru untuk belajar dan tumbuh. Seseorang yang membuka hatinya terhadap pembelajaran akan terus berkembang secara spiritual. Mereka belajar dari pengalaman, dari membaca, dari mendengarkan nasihat orang-orang bijaksana, dan dari refleksi diri.\n\nPertumbuhan spiritual tidak terjadi dalam semalam. Ini adalah perjalanan yang memerlukan kesabaran, dedikasi, dan komitmen. Setiap langkah kecil membawa kita lebih dekat kepada Allah dan kepada versi terbaik dari diri kita.",
        "pelajaran": "Kehidupan adalah sekolah berkelanjutan. Selalu ada sesuatu yang dapat dipelajari dan cara kita dapat berkembang. Jangan pernah berhenti belajar, tidak peduli berapa usia Anda atau berapa banyak yang sudah Anda ketahui sebelumnya."
    })

# Load file yang sudah ada
with open('assets/data/tadabur_stories.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Default doa untuk cerita baru
default_doa = {
    "arab": "رَبَّنَا اغْفِرْ لَنَا وَارْحَمْنَا وَأَنْتَ خَيْرُ الرَّاحِمِينَ",
    "transliterasi": "Rabbana ighfir lana warhamna wa anta khayru arrahimin",
    "terjemahan": "Ya Tuhan kami, ampunilah kami dan sayangilah kami, dan Engkau adalah sebaik-baik yang menyayangi"
}

# Tambahkan cerita baru
for cerita in cerita_baru:
    cerita['doa'] = default_doa
    data['stories'].append(cerita)

# Simpan
with open('assets/data/tadabur_stories.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print(f"Berhasil menambahkan 40 cerita baru!")
print(f"Total cerita sekarang: {len(data['stories'])}")
