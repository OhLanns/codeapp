import '../models/motor_model.dart';

// Data Motor Yamaha
List<MotorModel> motorYamaha = [
  MotorModel(
    nama: "Yamaha NMAX",
    merek: "Yamaha",
    model: "NMAX 155",
    tahun: "2020-2024",
    gambarAsset: "assets/images/yamaha/nmax.png",
    kodeMotor: "NMAX155",
    masalahUmum: [
      "CVT getar saat awal gas",
      "Klakson lemah",
      "Lampu depan kurang terang",
      "Busi cepat kotor",
      "Bearing roda belakang cepat rusak"
    ],
    solusi: [
      "Servis CVT rutin 5000km, ganti roller",
      "Ganti klakson dengan aftermarket",
      "Upgrade ke LED atau tambah auxiliary light",
      "Ganti busi setiap 8000km",
      "Ganti bearing dengan kualitas original"
    ],
  ),
  MotorModel(
    nama: "Yamaha R15",
    merek: "Yamaha",
    model: "R15 V3/V4",
    tahun: "2019-2024",
    gambarAsset: "assets/images/yamaha/r15.png",
    kodeMotor: "R15",
    masalahUmum: [
      "Kopling berat",
      "Transmisi susah masuk gigi",
      "Bensin cepat panas",
      "Oli cepat habis",
      "Rem belakang kurang pakem"
    ],
    solusi: [
      "Ganti kampas kopling dan setel kabel kopling",
      "Ganti oli gardan rutin setiap 10.000km",
      "Gunakan bensin pertamax atau turbo",
      "Cek kebocoran mesin, ganti seal valve",
      "Bleeding rem dan ganti kampas rem"
    ],
  ),
  MotorModel(
    nama: "Yamaha Aerox",
    merek: "Yamaha",
    model: "Aerox 155",
    tahun: "2018-2024",
    gambarAsset: "assets/images/yamaha/aerox.png",
    kodeMotor: "AEROX155",
    masalahUmum: [
      "Shockbreaker belakang keras",
      "Konsumsi bensin boros",
      "Accelerator response lambat",
      "Suara knalpot kasar",
      "V-belt mudah putus"
    ],
    solusi: [
      "Ganti shockbreaker yss atau ohlins",
      "Servis injector dan ganti filter udara",
      "ECU remap atau gunakan racing CDI",
      "Ganti knalpot aftermarket",
      "Ganti v-belt tiap 10.000km dengan yamalube"
    ],
  ),
  MotorModel(
    nama: "Yamaha XMAX",
    merek: "Yamaha",
    model: "XMAX 250",
    tahun: "2021-2024",
    gambarAsset: "assets/images/yamaha/xmax.png",
    kodeMotor: "XMAX250",
    masalahUmum: [
      "Konsumsi bensin boros",
      "CVT selip",
      "Klakson mati total",
      "Kunci kontak sering macet",
      "Lampu sein cepat putus"
    ],
    solusi: [
      "Servis injector rutin",
      "Ganti kampas CVT dan roller",
      "Cek kabel dan relay klakson",
      "Bersihkan dengan contact cleaner",
      "Ganti dengan lampu sein LED"
    ],
  ),
];

// Data Motor Honda
List<MotorModel> motorHonda = [
  MotorModel(
    nama: "Honda PCX",
    merek: "Honda",
    model: "PCX 160",
    tahun: "2021-2024",
    gambarAsset: "assets/images/honda/pcx.png",
    kodeMotor: "PCX160",
    masalahUmum: [
      "Idle stop tidak berfungsi",
      "Klakson kurang nyaring",
      "Body panel longgar",
      "Kunci kontak macet",
      "Aki cepat soak"
    ],
    solusi: [
      "Cek sensor dan setel ulang ECU",
      "Ganti klakson bawaan",
      "Kencangkan baut body",
      "Bersihkan lubang kunci dengan WD40",
      "Ganti aki dengan spec lebih besar"
    ],
  ),
  MotorModel(
    nama: "Honda Vario 160",
    merek: "Honda",
    model: "Vario 160",
    tahun: "2022-2024",
    gambarAsset: "assets/images/honda/vario.png",
    kodeMotor: "VARIO160",
    masalahUmum: [
      "Tarikan awal berat",
      "Suara CVT kasar",
      "Rem kurang pakem",
      "Body mudah lecet",
      "Spakbor depan miring"
    ],
    solusi: [
      "Ganti roller lebih ringan",
      "Servis CVT setiap 5000km",
      "Bleeding rem dan ganti kampas",
      "Pasang pelindung body",
      "Spooring dan cek dudukan spakbor"
    ],
  ),
  MotorModel(
    nama: "Honda CBR250RR",
    merek: "Honda",
    model: "CBR250RR",
    tahun: "2020-2024",
    gambarAsset: "assets/images/honda/cbr.png",
    kodeMotor: "CBR250RR",
    masalahUmum: [
      "Mesin cepat panas",
      "Kopling berat",
      "Busi cepat mati",
      "Oli mudah habis",
      "Sensor check engine sering nyala"
    ],
    solusi: [
      "Ganti coolant dan cek radiator",
      "Ganti kampas kopling racing",
      "Gunakan busi iridium",
      "Cek kebocoran pada seal mesin",
      "Reset ECU dan cek sensor"
    ],
  ),
  MotorModel(
    nama: "Honda Beat",
    merek: "Honda",
    model: "Beat 110",
    tahun: "2015-2024",
    gambarAsset: "assets/images/honda/beat.png",
    kodeMotor: "BEAT110",
    masalahUmum: [
      "Busi cepat kotor",
      "CVT getar saat gas kecil",
      "Klakson lemah",
      "Lampu depan redup",
      "Aki cepat tekor"
    ],
    solusi: [
      "Setel ulang campuran bahan bakar dan udara",
      "Servis CVT rutin setiap 5000km",
      "Ganti klakson dengan aftermarket",
      "Upgrade ke lampu LED atau tambah auxiliary light",
      "Ganti aki dengan kapasitas lebih besar"
    ],
  ),
];
// Data Motor Suzuki
List<MotorModel> motorSuzuki = [
  MotorModel(
    nama: "Suzuki Satria F150",
    merek: "Suzuki",
    model: "Satria F150",
    tahun: "2015-2024",
    gambarAsset: "assets/images/suzuki/satria.png",
    kodeMotor: "SATRIA150",
    masalahUmum: [
      "Transmisi kasar",
      "Busi cepat mati",
      "Kopling tidak halus",
      "Knalpot cepat panas",
      "Handle shock keras"
    ],
    solusi: [
      "Gunakan oli gardan SAE 90",
      "Gunakan busi NGK iridium",
      "Ganti kampas kopling merk original",
      "Lapisi knalpot dengan heat shield",
      "Setel ulang shockbreaker"
    ],
  ),
  MotorModel(
    nama: "Suzuki Address 115",
    merek: "Suzuki",
    model: "Address 115",
    tahun: "2018-2024",
    gambarAsset: "assets/images/suzuki/address.png",
    kodeMotor: "ADDRESS115",
    masalahUmum: [
      "Aki cepat soak",
      "Klakson lemah",
      "Lampu redup",
      "CVT getar",
      "Busi hitam pekat"
    ],
    solusi: [
      "Ganti aki dengan kapasitas lebih besar",
      "Ganti klakson aftermarket",
      "Upgrade ke lampu LED",
      "Servis CVT dan ganti roller",
      "Setel ulang campuran bahan bakar"
    ],
  ),
  MotorModel(
    nama: "Suzuki GSX-R150",
    merek: "Suzuki",
    model: "GSX-R150",
    tahun: "2019-2024",
    gambarAsset: "assets/images/suzuki/gsx.png",
    kodeMotor: "GSXR150",
    masalahUmum: [
      "Kopling selip",
      "Sensor O2 sering error",
      "Rantai cepat kendor",
      "Busi mati total",
      "Bahan bakar boros"
    ],
    solusi: [
      "Ganti kampas kopling racing",
      "Bersihkan atau ganti sensor O2",
      "Setel rantai setiap 1000km",
      "Ganti busi NGK",
      "Servis injector dan setel ECU"
    ],
  ),
  MotorModel(
    nama: "Suzuki Nex II",
    merek: "Suzuki",
    model: "Nex II",
    tahun: "2016-2024",
    gambarAsset: "assets/images/suzuki/next.png",
    kodeMotor: "NEX115",
    masalahUmum: [
      "Busi hitam kerak",
      "Aki cepet tekor",
      "CVT ngadat",
      "Karburator bermasalah",
      "Knalpot bocor"
    ],
    solusi: [
      "Setel ulang campuran udara bensin",
      "Ganti aki baru dengan kapasitas sesuai",
      "Servis CVT berkala",
      "Bersihkan karburator",
      "Las atau ganti knalpot baru"
    ],
  ),
];

// Data Motor Kawasaki
List<MotorModel> motorKawasaki = [
  MotorModel(
    nama: "Kawasaki Ninja 250",
    merek: "Kawasaki",
    model: "Ninja 250SL",
    tahun: "2015-2020",
    gambarAsset: "assets/images/kawasaki/ninja.png",
    kodeMotor: "NINJA250",
    masalahUmum: [
      "Radiator cepat panas",
      "Busy motor starter",
      "Kopling selip",
      "Bensin cepat habis",
      "Sensor O2 sering error"
    ],
    solusi: [
      "Bersihkan radiator dan ganti coolant",
      "Ganti sikat arang starter",
      "Ganti kampas kopling racing",
      "Setel ulang ECU",
      "Ganti sensor O2 dengan original"
    ],
  ),
  MotorModel(
    nama: "Kawasaki Ninja 650",
    merek: "Kawasaki",
    model: "Ninja 650",
    tahun: "2018-2024",
    gambarAsset: "assets/images/kawasaki/ninja2.png",
    kodeMotor: "NINJA650",
    masalahUmum: [
      "Busi cepat aus",
      "Kopling aus sebelum waktunya",
      "Rantai cepat mulur",
      "Oli mesin cepat hitam",
      "Sensor suhu sering error"
    ],
    solusi: [
      "Ganti busi setiap 10.000km",
      "Gunakan oli kopling berkualitas",
      "Setel rantai setiap 500km",
      "Ganti oli lebih cepat (setiap 3000km)",
      "Cek konektor dan ganti sensor"
    ],
  ),
  MotorModel(
    nama: "Kawasaki W175",
    merek: "Kawasaki",
    model: "W175",
    tahun: "2020-2024",
    gambarAsset: "assets/images/kawasaki/w175.png",
    kodeMotor: "W175",
    masalahUmum: [
      "Rem kurang pakem",
      "Lampu redup",
      "Body berkarat",
      "Klakson putus",
      "Busi mati"
    ],
    solusi: [
      "Ganti kampas rem dan bleeding",
      "Upgrade ke lampu LED",
      "Lapisi anti karat",
      "Cek kabel dan ganti klakson",
      "Ganti busi baru"
    ],
  ),
  MotorModel(
    nama: "Kawasaki ZX-25R",
    merek: "Kawasaki",
    model: "ZX-25R",
    tahun: "2021-2024",
    gambarAsset: "assets/images/kawasaki/zx.png",
    kodeMotor: "ZX25R",
    masalahUmum: [
      "Mesin cepat panas",
      "Kopling berat",
      "Bahan bakar boros",
      "Busi cepat kotor",
      "Suara mesin kasar"
    ],
    solusi: [
      "Ganti coolant setiap 10.000km",
      "Ganti kampas kopling racing",
      "Setel ulang ECU",
      "Ganti busi iridium",
      "Servis rutin di bengkel resmi"
    ],
  ),
];