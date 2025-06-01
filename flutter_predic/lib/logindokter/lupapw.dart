import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../api/lupapw_api.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> 
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  // Animation controllers
  late AnimationController _backgroundController;
  late AnimationController _cardController;
  late AnimationController _particleController;
  late AnimationController _glowController;
  late AnimationController _iconController;
  late AnimationController _formController;
  
  // Animations
  late Animation<double> _backgroundAnimation;
  late Animation<double> _cardSlideAnimation;
  late Animation<double> _cardScaleAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _iconRotateAnimation;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _formFadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Background animation
    _backgroundController = AnimationController(
      duration: Duration(milliseconds: 8000),
      vsync: this,
    )..repeat();

    // Card entrance animation
    _cardController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    // Particle system
    _particleController = AnimationController(
      duration: Duration(milliseconds: 6000),
      vsync: this,
    )..repeat();

    // Glow effect
    _glowController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    // Icon animation
    _iconController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    // Form animation
    _formController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    // Define animations
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi)
        .animate(_backgroundController);

    _cardSlideAnimation = Tween<double>(begin: 300.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _cardController,
        curve: Curves.elasticOut,
      ),
    );

    _cardScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _cardController,
        curve: Curves.bounceOut,
      ),
    );

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(_particleController);

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0)
        .animate(_glowController);

    _iconRotateAnimation = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: Curves.elasticOut,
      ),
    );

    _iconScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: Curves.bounceOut,
      ),
    );

    _formFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _formController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _startAnimations() async {
    // Start card animation
    _cardController.forward();
    
    // Start icon animation with delay
    await Future.delayed(Duration(milliseconds: 500));
    _iconController.forward();
    
    // Start form animation with delay
    await Future.delayed(Duration(milliseconds: 300));
    _formController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _cardController.dispose();
    _particleController.dispose();
    _glowController.dispose();
    _iconController.dispose();
    _formController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await ForgotPasswordService.sendResetCode(
        _emailController.text.trim(),
      );

      if (response.success) {
        Navigator.pushNamed(
          context,
          '/verify-reset-code',
          arguments: {
            'email': _emailController.text.trim(),
            'message': response.message,
          },
        );
      } else {
        _showErrorDialog(response.message);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[600], size: 28),
            SizedBox(width: 12),
            Text(
              'Error',
              style: TextStyle(
                color: Colors.red[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.red[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color(0xFF1565C0),
              Color(0xFF1976D2),
              Color(0xFF42A5F5),
              Color(0xFF64B5F6),
              Color(0xFF90CAF9),
              Color(0xFFE3F2FD),
            ],
            stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated geometric background
            AnimatedBuilder(
              animation: _backgroundAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: GeometricBackgroundPainter(_backgroundAnimation.value),
                  size: Size.infinite,
                );
              },
            ),

            // Floating particles
            AnimatedBuilder(
              animation: _particleAnimation,
              builder: (context, child) {
                return Stack(
                  children: List.generate(15, (index) {
                    final progress = (_particleAnimation.value + index * 0.07) % 1.0;
                    final size = MediaQuery.of(context).size;
                    final xOffset = (index % 3) * (size.width * 0.33);
                    final yMovement = size.height * (1.2 * progress - 0.1);
                    final sideMovement = math.sin(progress * 3 * math.pi + index) * 30;
                    
                    return Positioned(
                      left: xOffset + sideMovement,
                      top: yMovement,
                      child: Opacity(
                        opacity: (math.sin(progress * math.pi) * 0.6).clamp(0.0, 1.0),
                        child: Container(
                          width: 4 + (index % 3) * 2.0,
                          height: 4 + (index % 3) * 2.0,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Colors.white,
                                Colors.white.withOpacity(0.3),
                                Colors.transparent,
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.4),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),

            // Safe area content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Custom app bar
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Lupa Password',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Color(0xFF0D47A1).withOpacity(0.5),
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 48), // Balance the back button
                      ],
                    ),

                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: AnimatedBuilder(
                            animation: Listenable.merge([
                              _cardSlideAnimation,
                              _cardScaleAnimation,
                            ]),
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, _cardSlideAnimation.value),
                                child: Transform.scale(
                                  scale: _cardScaleAnimation.value,
                                  child: Container(
                                    constraints: BoxConstraints(maxWidth: 400),
                                    margin: EdgeInsets.symmetric(horizontal: 16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.white.withOpacity(0.25),
                                          Colors.white.withOpacity(0.1),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(32),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF0D47A1).withOpacity(0.2),
                                          blurRadius: 40,
                                          spreadRadius: 5,
                                          offset: Offset(0, 20),
                                        ),
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.1),
                                          blurRadius: 20,
                                          spreadRadius: -5,
                                          offset: Offset(0, -10),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(32),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Animated icon with glow
                                            AnimatedBuilder(
                                              animation: Listenable.merge([
                                                _iconRotateAnimation,
                                                _iconScaleAnimation,
                                                _glowAnimation,
                                              ]),
                                              builder: (context, child) {
                                                return Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    // Glow effect
                                                    Transform.scale(
                                                      scale: _glowAnimation.value * 1.5,
                                                      child: Container(
                                                        width: 120,
                                                        height: 120,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          gradient: RadialGradient(
                                                            colors: [
                                                              Colors.white.withOpacity(0.3),
                                                              Colors.transparent,
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    
                                                    // Main icon
                                                    Transform.scale(
                                                      scale: _iconScaleAnimation.value,
                                                      child: Transform.rotate(
                                                        angle: _iconRotateAnimation.value * math.pi,
                                                        child: Container(
                                                          width: 100,
                                                          height: 100,
                                                          decoration: BoxDecoration(
                                                            gradient: LinearGradient(
                                                              begin: Alignment.topLeft,
                                                              end: Alignment.bottomRight,
                                                              colors: [
                                                                Colors.white,
                                                                Colors.white.withOpacity(0.8),
                                                              ],
                                                            ),
                                                            shape: BoxShape.circle,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.white.withOpacity(0.5),
                                                                blurRadius: 20,
                                                                spreadRadius: 5,
                                                              ),
                                                              BoxShadow(
                                                                color: Color(0xFF1976D2).withOpacity(0.3),
                                                                blurRadius: 15,
                                                                offset: Offset(0, 8),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Icon(
                                                            Icons.lock_reset,
                                                            size: 50,
                                                            color: Color(0xFF1976D2),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),

                                            SizedBox(height: 32),

                                            // Animated title and subtitle
                                            AnimatedBuilder(
                                              animation: _formFadeAnimation,
                                              builder: (context, child) {
                                                return Opacity(
                                                  opacity: _formFadeAnimation.value,
                                                  child: Column(
                                                    children: [
                                                      ShaderMask(
                                                        shaderCallback: (bounds) => LinearGradient(
                                                          colors: [
                                                            Colors.white,
                                                            Colors.white.withOpacity(0.9),
                                                          ],
                                                        ).createShader(bounds),
                                                        child: Text(
                                                          'Lupa Password?',
                                                          style: TextStyle(
                                                            fontSize: 28,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                            shadows: [
                                                              Shadow(
                                                                color: Color(0xFF0D47A1).withOpacity(0.5),
                                                                offset: Offset(0, 2),
                                                                blurRadius: 4,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      
                                                      SizedBox(height: 12),
                                                      
                                                      Text(
                                                        'Masukkan email Anda untuk menerima\nkode reset password',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white.withOpacity(0.9),
                                                          height: 1.5,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),

                                            SizedBox(height: 40),

                                            // Animated email field
                                            AnimatedBuilder(
                                              animation: _formFadeAnimation,
                                              builder: (context, child) {
                                                return Transform.translate(
                                                  offset: Offset(0, (1 - _formFadeAnimation.value) * 20),
                                                  child: Opacity(
                                                    opacity: _formFadeAnimation.value,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(16),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.white.withOpacity(0.1),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 5),
                                                          ),
                                                        ],
                                                      ),
                                                      child: TextFormField(
                                                        controller: _emailController,
                                                        keyboardType: TextInputType.emailAddress,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                        ),
                                                        decoration: InputDecoration(
                                                          labelText: 'Email',
                                                          labelStyle: TextStyle(
                                                            color: Colors.white.withOpacity(0.8),
                                                          ),
                                                          hintText: 'Masukkan alamat email Anda',
                                                          hintStyle: TextStyle(
                                                            color: Colors.white.withOpacity(0.6),
                                                          ),
                                                          prefixIcon: Icon(
                                                            Icons.email,
                                                            color: Colors.white.withOpacity(0.8),
                                                          ),
                                                          filled: true,
                                                          fillColor: Colors.white.withOpacity(0.15),
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(16),
                                                            borderSide: BorderSide.none,
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(16),
                                                            borderSide: BorderSide(
                                                              color: Colors.white.withOpacity(0.3),
                                                              width: 1,
                                                            ),
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(16),
                                                            borderSide: BorderSide(
                                                              color: Colors.white,
                                                              width: 2,
                                                            ),
                                                          ),
                                                          errorBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(16),
                                                            borderSide: BorderSide(
                                                              color: Colors.red[300]!,
                                                              width: 1,
                                                            ),
                                                          ),
                                                          focusedErrorBorder: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(16),
                                                            borderSide: BorderSide(
                                                              color: Colors.red[300]!,
                                                              width: 2,
                                                            ),
                                                          ),
                                                          errorStyle: TextStyle(
                                                            color: Colors.red[300],
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        validator: (value) {
                                                          if (value == null || value.isEmpty) {
                                                            return 'Email tidak boleh kosong';
                                                          }
                                                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                                            return 'Format email tidak valid';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),

                                            SizedBox(height: 32),

                                            // Animated send button
                                            AnimatedBuilder(
                                              animation: _formFadeAnimation,
                                              builder: (context, child) {
                                                return Transform.translate(
                                                  offset: Offset(0, (1 - _formFadeAnimation.value) * 30),
                                                  child: Opacity(
                                                    opacity: _formFadeAnimation.value,
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: 56,
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                          colors: _isLoading 
                                                            ? [
                                                                Colors.grey[400]!,
                                                                Colors.grey[500]!,
                                                              ]
                                                            : [
                                                                Colors.white,
                                                                Colors.white.withOpacity(0.9),
                                                              ],
                                                        ),
                                                        borderRadius: BorderRadius.circular(16),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.white.withOpacity(0.3),
                                                            blurRadius: 15,
                                                            offset: Offset(0, 8),
                                                          ),
                                                          BoxShadow(
                                                            color: Color(0xFF0D47A1).withOpacity(0.2),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 4),
                                                          ),
                                                        ],
                                                      ),
                                                      child: ElevatedButton(
                                                        onPressed: _isLoading ? null : _sendResetCode,
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.transparent,
                                                          shadowColor: Colors.transparent,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(16),
                                                          ),
                                                        ),
                                                        child: _isLoading
                                                          ? SizedBox(
                                                              height: 24,
                                                              width: 24,
                                                              child: CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                                  Color(0xFF1976D2),
                                                                ),
                                                              ),
                                                            )
                                                          : Text(
                                                              'Kirim Kode Reset',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.bold,
                                                                color: Color(0xFF1976D2),
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),

                                            SizedBox(height: 24),

                                            // Back to login button
                                            AnimatedBuilder(
                                              animation: _formFadeAnimation,
                                              builder: (context, child) {
                                                return Transform.translate(
                                                  offset: Offset(0, (1 - _formFadeAnimation.value) * 40),
                                                  child: Opacity(
                                                    opacity: _formFadeAnimation.value * 0.9,
                                                    child: TextButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      style: TextButton.styleFrom(
                                                        padding: EdgeInsets.symmetric(
                                                          horizontal: 24,
                                                          vertical: 12,
                                                        ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'Kembali ke Login',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 16,
                                                          shadows: [
                                                            Shadow(
                                                              color: Color(0xFF0D47A1).withOpacity(0.3),
                                                              offset: Offset(0, 1),
                                                              blurRadius: 2,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Geometric background painter (reused from splash screen)
class GeometricBackgroundPainter extends CustomPainter {
  final double animationValue;
  
  GeometricBackgroundPainter(this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;
    
    // Draw animated hexagons
    for (int i = 0; i < 4; i++) {
      final progress = (animationValue + i * 0.2) % 1.0;
      final opacity = (math.sin(progress * math.pi) * 0.08).abs();
      
      paint.color = Colors.white.withOpacity(opacity);
      
      final centerX = size.width * (0.3 + (i % 2) * 0.4);
      final centerY = size.height * (0.3 + (i ~/ 2) * 0.4) + 
                     math.sin(animationValue * 1.5 * math.pi + i) * 25;
      final radius = 30 + i * 8.0;
      
      final path = Path();
      for (int j = 0; j < 6; j++) {
        final angle = (j * math.pi / 3) + (progress * math.pi / 4);
        final x = centerX + radius * math.cos(angle);
        final y = centerY + radius * math.sin(angle);
        
        if (j == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      
      canvas.drawPath(path, paint);
    }
    
    // Draw flowing waves
    final wavePaint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..style = PaintingStyle.fill;
    
    final wavePath = Path();
    wavePath.moveTo(0, size.height * 0.85);
    
    for (double x = 0; x <= size.width; x += 3) {
      final y = size.height * 0.85 + 
               math.sin((x * 0.008) + (animationValue * 1.5 * math.pi)) * 20 +
               math.sin((x * 0.015) + (animationValue * 0.8 * math.pi)) * 10;
      wavePath.lineTo(x, y);
    }
    
    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();
    
    canvas.drawPath(wavePath, wavePaint);
  }
  
  @override
  bool shouldRepaint(GeometricBackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}