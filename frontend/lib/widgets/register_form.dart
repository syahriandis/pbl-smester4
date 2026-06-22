import 'package:flutter/material.dart';

class RegisterForm extends StatelessWidget {
  final TextEditingController name;
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController confirmPassword;
  final TextEditingController tanggalLahir; 

  final String? gender;
  final Function(String?) onGenderChanged;
  final VoidCallback onRegisterPressed; 

  const RegisterForm({
    super.key,
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.tanggalLahir, 
    required this.gender,
    required this.onGenderChanged,
    required this.onRegisterPressed,
  });

  InputDecoration inputStyle(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.person_add_alt_1, size: 80, color: Colors.green),
          const SizedBox(height: 15),
          const Text(
            "Buat Akun",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),

          TextField(
            controller: name,
            decoration: inputStyle("Nama Lengkap", Icons.person),
          ),
          const SizedBox(height: 18),

          TextField(
            controller: email,
            keyboardType: TextInputType.emailAddress, // ✔ Menampilkan keyboard khusus email di HP
            decoration: inputStyle("Email", Icons.email),
          ),
          const SizedBox(height: 18),

          TextField(
            controller: password,
            obscureText: true,
            decoration: inputStyle("Password", Icons.lock),
          ),
          const SizedBox(height: 18),

          TextField(
            controller: confirmPassword,
            obscureText: true,
            decoration: inputStyle("Konfirmasi Password", Icons.lock_outline),
          ),
          const SizedBox(height: 18),

          TextField(
            controller: tanggalLahir,
            readOnly: true, 
            decoration: inputStyle("Tanggal Lahir", Icons.calendar_month),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime(2000), 
                firstDate: DateTime(1940),   
                lastDate: DateTime.now(),    
              );

              if (pickedDate != null) {
                String y = pickedDate.year.toString();
                String m = pickedDate.month.toString().padLeft(2, "0");
                String d = pickedDate.day.toString().padLeft(2, "0");
                
                tanggalLahir.text = "$y-$m-$d";
              }
            },
          ),
          const SizedBox(height: 18),

          DropdownButtonFormField<String>(
            value: gender,
            decoration: inputStyle("Pilih Gender", Icons.people),
            items: ["Laki-laki", "Perempuan"]
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onGenderChanged,
          ),
          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                if (name.text.isEmpty || email.text.isEmpty || password.text.isEmpty || tanggalLahir.text.isEmpty || gender == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Semua kolom wajib diisi")),
                  );
                  return;
                }

                // ✔ VALIDASI KEDUA: Cek format email sebelum lanjut gess
                final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                if (!emailRegex.hasMatch(email.text.trim())) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Format penulisan email salah (Contoh: nama@email.com)")),
                  );
                  return;
                }

                if (password.text != confirmPassword.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password tidak sama")),
                  );
                  return;
                }

                onRegisterPressed();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text(
                "Daftar",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Sudah punya akun?"),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Login", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}