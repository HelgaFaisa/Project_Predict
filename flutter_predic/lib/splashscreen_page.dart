import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _masterController;
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _particleController;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late AnimationController _glowController;
  late AnimationController _orbitalController;
  late AnimationController _sparkleController;
  
  late Animation<double> _logoSlideAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotateAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _orbitalAnimation;
  late Animation<double> _sparkleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Master controller untuk koordinasi
    _masterController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );
    
    // Logo animations
    _logoController = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this,
    );
    
    // Text animations
    _textController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    
    // Particle system
    _particleController = AnimationController(
      duration: Duration(milliseconds: 5000),
      vsync: this,
    )..repeat();
    
    // Pulse effect
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);
    
    // Wave effect
    _waveController = AnimationController(
      duration: Duration(milliseconds: 4000),
      vsync: this,
    )..repeat();
    
    // Glow effect
    _glowController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);
    
    // Orbital animation
    _orbitalController = AnimationController(
      duration: Duration(milliseconds: 8000),
      vsync: this,
    )..repeat();
    
    // Sparkle effect
    _sparkleController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    
    // Enhanced logo animations
    _logoSlideAnimation = Tween<double>(begin: -300.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );
    
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Interval(0.3, 0.9, curve: Curves.bounceOut),
      ),
    );
    
    _logoRotateAnimation = Tween<double>(begin: 0.0, end: 4.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Interval(0.0, 0.8, curve: Curves.easeInOutBack),
      ),
    );
    
    // Enhanced text animations
    _textSlideAnimation = Tween<double>(begin: 100.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOutBack,
      ),
    );
    
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Other animations
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_particleController);
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.3).animate(_pulseController);
    _waveAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(_waveController);
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(_glowController);
    _orbitalAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(_orbitalController);
    _sparkleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_sparkleController);
    
    // Start animations with delays
    _startAnimations();
    
    // Timer untuk pindah ke LoginPage setelah 5 detik
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }
  
  void _startAnimations() async {
    // Start logo animation immediately
    _logoController.forward();
    
    // Start text animation after short delay
    await Future.delayed(Duration(milliseconds: 1000));
    _textController.forward();
    
    // Start master controller
    _masterController.forward();
  }
  
  @override
  void dispose() {
    _masterController.dispose();
    _logoController.dispose();
    _textController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    _glowController.dispose();
    _orbitalController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Color(0xFF1565C0),    // Dark blue center
              Color(0xFF1976D2),    // Medium blue
              Color(0xFF42A5F5),    // Light blue
              Color(0xFF64B5F6),    // Lighter blue
              Color(0xFF90CAF9),    // Very light blue
              Color(0xFFE3F2FD),    // Almost white blue
            ],
            stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated geometric background
            AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: GeometricBackgroundPainter(_waveAnimation.value),
                  size: Size.infinite,
                );
              },
            ),
            
            // Enhanced floating particles with variety
            AnimatedBuilder(
              animation: _particleAnimation,
              builder: (context, child) {
                return Stack(
                  children: List.generate(20, (index) {
                    final progress = (_particleAnimation.value + index * 0.05) % 1.0;
                    final size = MediaQuery.of(context).size;
                    final xOffset = (index % 4) * (size.width * 0.25);
                    final yMovement = size.height * (1.2 * progress - 0.1);
                    final sideMovement = math.sin(progress * 4 * math.pi + index) * 40;
                    
                    return Positioned(
                      left: xOffset + sideMovement,
                      top: yMovement,
                      child: Opacity(
                        opacity: (math.sin(progress * math.pi) * 0.8).clamp(0.0, 1.0),
                        child: Container(
                          width: 3 + (index % 4) * 2.0,
                          height: 3 + (index % 4) * 2.0,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Colors.white,
                                Colors.white.withOpacity(0.4),
                                Colors.transparent,
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.6),
                                blurRadius: 8,
                                spreadRadius: 2,
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
            
            // Orbital elements around logo
            Center(
              child: AnimatedBuilder(
                animation: _orbitalAnimation,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Orbital rings
                      for (int i = 0; i < 3; i++)
                        Transform.rotate(
                          angle: _orbitalAnimation.value + i * (math.pi / 3),
                          child: Container(
                            width: 200 + i * 30.0,
                            height: 200 + i * 30.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1 - i * 0.02),
                                width: 1,
                              ),
                            ),
                            child: Stack(
                              children: [
                                // Orbital dots
                                Positioned(
                                  top: 0,
                                  left: (200 + i * 30.0) / 2 - 3,
                                  child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.8),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.4),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Enhanced animated logo with glow and sparkles
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _logoSlideAnimation,
                      _logoScaleAnimation,
                      _logoRotateAnimation,
                      _pulseAnimation,
                      _glowAnimation,
                      _sparkleAnimation,
                    ]),
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Glow effect
                          Transform.scale(
                            scale: _glowAnimation.value * 1.3,
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Color(0xFF42A5F5).withOpacity(0.3),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          
                          // Main logo
                          Transform.translate(
                            offset: Offset(0, _logoSlideAnimation.value),
                            child: Transform.scale(
                              scale: _logoScaleAnimation.value * _pulseAnimation.value,
                              child: Transform.rotate(
                                angle: _logoRotateAnimation.value * math.pi,
                                child: Container(
                                  width: 160,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                      colors: [
                                        Colors.white,
                                        Color(0xFFE3F2FD),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF1976D2).withOpacity(0.4),
                                        blurRadius: 40,
                                        spreadRadius: 10,
                                        offset: Offset(0, 20),
                                      ),
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.9),
                                        blurRadius: 20,
                                        spreadRadius: -5,
                                        offset: Offset(0, -10),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(30),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF42A5F5),
                                          Color(0xFF1976D2),
                                          Color(0xFF0D47A1),
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF1976D2).withOpacity(0.5),
                                          blurRadius: 15,
                                          offset: Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Heart icon with glow
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white.withOpacity(0.6),
                                                blurRadius: 20,
                                                spreadRadius: 5,
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            Icons.favorite,
                                            size: 70,
                                            color: Colors.white,
                                          ),
                                        ),
                                        
                                        // Medical cross overlay
                                        Icon(
                                          Icons.add,
                                          size: 30,
                                          color: Colors.white.withOpacity(0.7),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          // Sparkle effects
                          ...List.generate(8, (index) {
                            final angle = (index * math.pi * 2 / 8) + (_sparkleAnimation.value * math.pi * 2);
                            final distance = 120 + math.sin(_sparkleAnimation.value * math.pi * 2) * 20;
                            final sparkleOpacity = (math.sin(_sparkleAnimation.value * math.pi * 4 + index) + 1) / 2;
                            
                            return Transform.translate(
                              offset: Offset(
                                math.cos(angle) * distance,
                                math.sin(angle) * distance,
                              ),
                              child: Opacity(
                                opacity: sparkleOpacity * 0.8,
                                child: Icon(
                                  Icons.star,
                                  size: 12 + index % 3 * 4.0,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
                  
                  SizedBox(height: 60),
                  
                  // Enhanced animated title with gradient and shadow
                  AnimatedBuilder(
                    animation: Listenable.merge([_textSlideAnimation, _textFadeAnimation]),
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _textSlideAnimation.value),
                        child: Opacity(
                          opacity: _textFadeAnimation.value,
                          child: Column(
                            children: [
                              // Main title with enhanced styling
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Color(0xFFE3F2FD),
                                    Colors.white,
                                  ],
                                  stops: [0.0, 0.5, 1.0],
                                ).createShader(bounds),
                                child: Text(
                                  'DiabetaCare',
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 3.0,
                                    shadows: [
                                      Shadow(
                                        color: Color(0xFF0D47A1).withOpacity(0.5),
                                        offset: Offset(0, 6),
                                        blurRadius: 12,
                                      ),
                                      Shadow(
                                        color: Colors.white.withOpacity(0.5),
                                        offset: Offset(0, -2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              SizedBox(height: 8),
                              
                              // Decorative line
                              Container(
                                width: 100,
                                height: 3,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.white,
                                      Colors.transparent,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Enhanced animated subtitle
                  AnimatedBuilder(
                    animation: _textFadeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _textSlideAnimation.value * 0.3),
                        child: Opacity(
                          opacity: _textFadeAnimation.value * 0.9,
                          child: Text(
                            'Your Diabetes Monitoring Partner',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.9),
                              letterSpacing: 1.2,
                              shadows: [
                                Shadow(
                                  color: Color(0xFF0D47A1).withOpacity(0.3),
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  SizedBox(height: 100),
                  
                  // Advanced loading indicator with multiple rings
                  AnimatedBuilder(
                    animation: Listenable.merge([_particleAnimation, _pulseAnimation, _glowAnimation]),
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value * 0.7 + 0.5,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer glow ring
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.transparent,
                                    Color(0xFF42A5F5).withOpacity(0.2 * _glowAnimation.value),
                                  ],
                                ),
                              ),
                            ),
                            
                            // Rotating outer ring
                            Transform.rotate(
                              angle: _particleAnimation.value * 2 * math.pi,
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: SweepGradient(
                                    colors: [
                                      Color(0xFF42A5F5),
                                      Colors.transparent,
                                      Colors.transparent,
                                      Color(0xFF42A5F5),
                                    ],
                                  ),
                                ),
                                child: Container(
                                  margin: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF1565C0),
                                  ),
                                ),
                              ),
                            ),
                            
                            // Counter-rotating middle ring
                            Transform.rotate(
                              angle: -_particleAnimation.value * 1.5 * math.pi,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: SweepGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.8),
                                      Colors.transparent,
                                      Colors.transparent,
                                      Colors.white.withOpacity(0.8),
                                    ],
                                  ),
                                ),
                                child: Container(
                                  margin: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF1565C0),
                                  ),
                                ),
                              ),
                            ),
                            
                            // Center pulsing dot
                            Transform.scale(
                              scale: _glowAnimation.value,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.white,
                                      Color(0xFF42A5F5),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.8),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Enhanced loading text with typing effect
                  AnimatedBuilder(
                    animation: _textFadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _textFadeAnimation.value * 0.9,
                        child: Column(
                          children: [
                            Text(
                              'Loading',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2.0,
                                shadows: [
                                  Shadow(
                                    color: Color(0xFF0D47A1).withOpacity(0.5),
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Initializing Health Monitoring System...',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Enhanced custom painter for geometric background
class GeometricBackgroundPainter extends CustomPainter {
  final double animationValue;
  
  GeometricBackgroundPainter(this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;
    
    // Draw animated hexagons
    for (int i = 0; i < 6; i++) {
      final progress = (animationValue + i * 0.15) % 1.0;
      final opacity = (math.sin(progress * math.pi) * 0.1).abs();
      
      paint.color = Colors.white.withOpacity(opacity);
      
      final centerX = size.width * (0.2 + (i % 3) * 0.3);
      final centerY = size.height * (0.2 + (i ~/ 3) * 0.6) + 
                     math.sin(animationValue * 2 * math.pi + i) * 30;
      final radius = 40 + i * 10.0;
      
      final path = Path();
      for (int j = 0; j < 6; j++) {
        final angle = (j * math.pi / 3) + (progress * math.pi / 3);
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
    
    // Draw flowing waves at bottom
    final wavePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    
    final wavePath = Path();
    wavePath.moveTo(0, size.height * 0.8);
    
    for (double x = 0; x <= size.width; x += 4) {
      final y = size.height * 0.8 + 
               math.sin((x * 0.01) + (animationValue * 2 * math.pi)) * 30 +
               math.sin((x * 0.02) + (animationValue * math.pi)) * 15;
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