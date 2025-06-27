import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_notifier.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(
                'assets/images/profile_placeholder.png',
              ),
              backgroundColor: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'Nome do Usuário',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'email@example.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: Icon(
                Icons.brightness_6,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Alternar Tema'),
              trailing: Consumer<ThemeNotifier>(
                builder: (context, notifier, child) {
                  return Switch(
                    value: notifier.themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      notifier.toggleTheme();
                    },
                  );
                },
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Configurações'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary),
              title: const Text('Sobre o App'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Tá na Mesa',
                  applicationVersion: '1.0.0',
                  applicationIcon: Image.asset(
                    'assets/images/logo_icone.png',
                    width: 48,
                    height: 48,
                  ),
                  applicationLegalese:
                      '© 2025 Grupo do curso de flutter ETG. Todos os direitos reservados.',
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Este aplicativo foi desenvolvido com ❤️ por '
                          'Handerson com a ajuda de Emily, Frederico, e Pedro, entusiastas de tecnologia.'),
                    ),
                  ],
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Sair'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logout realizado com sucesso!'),
                    duration: Duration(seconds: 2),
                  ),
                );
                Future.delayed(const Duration(milliseconds: 2500), () {
                  SystemNavigator.pop();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
