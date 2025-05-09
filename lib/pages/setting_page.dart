import 'package:flutter/material.dart';
import 'package:koperasi_undiksha/widgets/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:koperasi_undiksha/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:another_flushbar/flushbar.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isNotificationEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationSetting();
  }

  Future<void> _loadNotificationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isNotificationEnabled = prefs.getBool('notifications') ?? false;
    });
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Konfirmasi Logout'),
            content: const Text('Apakah Anda yakin ingin keluar?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await Provider.of<UserProvider>(context, listen: false).logout();
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Logout gagal: $e')));
        }
      }
    }
  }

  void _showChangePasswordDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _oldPasswordController = TextEditingController();
    final _newPasswordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();
    bool _isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Ubah Kata Sandi"),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _oldPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Kata Sandi Lama",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap masukkan password lama';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Kata Sandi Baru",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap masukkan password baru';
                        }
                        if (value.length < 6) {
                          return 'Minimal 6 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Konfirmasi Kata Sandi Baru",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value != _newPasswordController.text) {
                          return 'Password tidak cocok';
                        }
                        return null;
                      },
                    ),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed:
                      _isLoading
                          ? null
                          : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => _isLoading = true);
                              try {
                                final userProvider = Provider.of<UserProvider>(
                                  context,
                                  listen: false,
                                );
                                await userProvider.changePassword(
                                  oldPassword: _oldPasswordController.text,
                                  newPassword: _newPasswordController.text,
                                );
                                if (mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Password berhasil diubah!",
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Gagal: $e"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } finally {
                                if (mounted) {
                                  setState(() => _isLoading = false);
                                }
                              }
                            }
                          },
                  child: const Text("Simpan"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showFlushNotification(bool isEnabled) {
    final message =
        isEnabled
            ? 'Notifikasi berhasil diaktifkan'
            : 'Notifikasi berhasil dinonaktifkan';

    Flushbar(
      message: message,
      duration: const Duration(seconds: 3),
      icon: Icon(
        isEnabled ? Icons.notifications_active : Icons.notifications_off,
        size: 28.0,
        color: Colors.white,
      ),
      leftBarIndicatorColor: isEnabled ? Colors.green : Colors.red,
      backgroundColor: isEnabled ? Colors.green.shade600 : Colors.red.shade600,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
      animationDuration: const Duration(milliseconds: 500),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed:
              () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingItem(
            icon: Icons.lock,
            title: "Ubah Kata Sandi",
            onTap: () => _showChangePasswordDialog(context),
          ),
          _SettingItem(
            icon: Icons.notifications,
            title: "Notifikasi",
            trailing: Switch(
              value: _isNotificationEnabled,
              onChanged: (value) async {
                setState(() => _isNotificationEnabled = value);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('notifications', value);
                _showFlushNotification(value);
              },
            ),
          ),
          const Divider(height: 20),
          _SettingItem(
            icon: Icons.logout,
            title: "Keluar",
            titleColor: Colors.red,
            iconColor: Colors.red,
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? iconColor;
  final Color? titleColor;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _SettingItem({
    Key? key,
    required this.icon,
    required this.title,
    this.iconColor,
    this.titleColor,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? Theme.of(context).primaryColor),
        title: Text(title, style: TextStyle(color: titleColor)),
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
