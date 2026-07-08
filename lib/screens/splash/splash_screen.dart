import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/vcreations_logo.dart';
import '../auth/login_screen.dart';
import '../client/main_client_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _entrerController;
  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late Animation<double> _entrerFade;
  late Animation<double> _lineHeight;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _entrerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );
    _entrerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entrerController, curve: Curves.easeIn),
    );
    _lineHeight = Tween<double>(begin: 0, end: 40).animate(
      CurvedAnimation(parent: _entrerController, curve: Curves.easeOut),
    );

    _logoController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _entrerController.forward();
      });
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _entrerController.dispose();
    super.dispose();
  }

  void _enter() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MainClientScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Subtle radial glow behind logo
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.gold.withOpacity(0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Main content
          Column(
            children: [
              Expanded(
                child: Center(
                  child: FadeTransition(
                    opacity: _logoFade,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: const VCreationsLogo(size: 130),
                    ),
                  ),
                ),
              ),
              // ENTRER section
              FadeTransition(
                opacity: _entrerFade,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 72),
                  child: GestureDetector(
                    onTap: _enter,
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Vertical line above
                        AnimatedBuilder(
                          animation: _lineHeight,
                          builder: (_, __) => Container(
                            width: 1,
                            height: _lineHeight.value,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'E N T R E R',
                          style: TextStyle(
                            color: AppColors.white.withOpacity(0.7),
                            fontSize: 12,
                            letterSpacing: 6,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 14),
                        // Vertical line below
                        Container(
                          width: 1,
                          height: 40,
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Quick login links (top right) — hidden but accessible via long press
          Positioned(
            top: 50,
            right: 20,
            child: GestureDetector(
              onLongPress: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
              child: const SizedBox(width: 40, height: 40),
            ),
          ),
        ],
      ),
    );
  }
}
