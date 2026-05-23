import 'package:carte_app/data/api/api_service.dart';
import 'package:carte_app/data/api/user_api.dart';
import 'package:carte_app/data/notifiers.dart';
import 'package:carte_app/views/widget_tree.dart';
import 'package:carte_app/views/widgets/widget_horizontal_bar.dart';
import 'package:flutter/material.dart';
import 'package:carte_app/data/constants.dart';
import 'package:carte_app/views/widgets/widget_text_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color lightBlue = KColors.lightBlue;

    return Scaffold(
      backgroundColor: lightBlue,
      body: Center(
        child: Stack(
          children: [
            const Positioned.fill(child: _BlueBackground()),
            FractionallySizedBox(
              heightFactor: 0.55,
              widthFactor: 1,
              child: Container(
                width: 158,
                height: 158,
                decoration: const ShapeDecoration(shape: OvalBorder()),
                child: const Image(image: AssetImage("images/icon.png")),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: KColors.baseBg,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text(
                            'Get Started!',
                            style: TextStyle(
                              fontSize: KFont.fontSizeTitle,
                              fontFamily: KFont.fontFamilyTitle,
                              fontWeight: FontWeight.bold,
                              color: KColors.darkGray,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
                          child: WidgetHorizontalBar(
                            primaryColor: KColors.mediumBlue,
                          ),
                        ),

                        WidgetTextInput(
                          controller: _nameCtrl,
                          inputName: '',
                          hintText: 'Name',
                          hintStyle: TextStyle(
                            fontFamily: KFont.fontFamilyContentMedium,
                          ),
                        ),

                        WidgetTextInput(
                          controller: _emailCtrl,
                          inputName: '',
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            fontFamily: KFont.fontFamilyContentMedium,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: KColors.mediumBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            onPressed: _loading ? null : _onSubmit,
                            child: _loading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Enter',
                                    style: TextStyle(
                                      color: KColors.baseBg,
                                      fontSize: KFont.fontSizeButton,
                                      fontFamily: KFont.fontFamilyButton,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha nome e email.')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final api = UserApi(ApiService());
      final user = await api.loginOrCreate(name: name, email: email);
      currentUserNotifier.value = user;

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const WidgetTree()),
        (route) => false,
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ${e.statusCode}: ${e.body}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de conexão: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

class _BlueBackground extends StatelessWidget {
  const _BlueBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _BlueBackgroundPainter());
  }
}

class _BlueBackgroundPainter extends CustomPainter {
  final Color navy = KColors.darkBlue;
  final Color midBlue = KColors.mediumBlue;
  final Color lightBlue = KColors.lightBlue;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..color = lightBlue);

    canvas.drawCircle(
      Offset(-w * 0.02, -h * 0.15),
      h * 0.6,
      Paint()..color = midBlue,
    );

    final shadow = Paint()
      ..color = Colors.black.withAlpha(93)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset(-w * 0.02, -h * 0.15), h * 0.52, shadow);

    canvas.drawCircle(
      Offset(-w * 0.02, -h * 0.15),
      h * 0.5,
      Paint()..color = navy,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
