class BankAccount {
  final int id;
  final String namaBank;
  final String noRekening;
  final String pemilik;

  BankAccount({
    required this.id,
    required this.namaBank,
    required this.noRekening,
    required this.pemilik,
  });
}

class CompanyProfile {
  final String namaWebsite;
  final String email;
  final String noTelp;
  final String alamat;
  final String metaDeskripsi;
  final List<BankAccount> bankAccounts;

  CompanyProfile({
    required this.namaWebsite,
    required this.email,
    required this.noTelp,
    required this.alamat,
    required this.metaDeskripsi,
    required this.bankAccounts,
  });
}
