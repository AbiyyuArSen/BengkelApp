import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Privacy & Security',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '1. Pengumpulan Data\n'
              'Kami mengumpulkan informasi yang Anda berikan secara langsung kepada kami, seperti saat Anda membuat atau mengubah akun, memesan layanan, menghubungi dukungan pelanggan, atau berkomunikasi dengan kami.\n\n'
              '2. Penggunaan Informasi\n'
              'Kami menggunakan informasi yang kami kumpulkan untuk mengoperasikan, memelihara, dan meningkatkan aplikasi dan layanan kami, serta untuk memproses transaksi dan mengirimkan pemberitahuan terkait.\n\n'
              '3. Berbagi Informasi\n'
              'Kami tidak akan membagikan informasi pribadi Anda dengan pihak ketiga kecuali sebagaimana dijelaskan dalam Kebijakan Privasi ini atau dengan persetujuan Anda.\n\n'
              '4. Keamanan Data\n'
              'Kami mengambil langkah-langkah yang wajar untuk membantu melindungi informasi tentang Anda dari kehilangan, pencurian, penyalahgunaan, dan akses tidak sah, pengungkapan, perubahan, dan perusakan.\n\n'
              '5. Perubahan pada Kebijakan\n'
              'Kami dapat memperbarui kebijakan privasi ini dari waktu ke waktu. Jika kami melakukan perubahan yang material, kami akan memberi tahu Anda melalui aplikasi atau sarana lainnya.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Security',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Aplikasi BengkelKu menggunakan enkripsi standar industri untuk melindungi transmisi data antara perangkat Anda dan server kami. Kami juga menerapkan langkah-langkah keamanan fisik, elektronik, dan prosedural yang dirancang untuk melindungi informasi pribadi Anda.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
