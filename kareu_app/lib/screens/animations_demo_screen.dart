import 'package:flutter/material.dart';
import '../constants/app_design_system.dart';
import '../widgets/animated_list.dart';
import '../widgets/loading_animations.dart';

class AnimationsDemoScreen extends StatefulWidget {
  const AnimationsDemoScreen({super.key});

  @override
  State<AnimationsDemoScreen> createState() => _AnimationsDemoScreenState();
}

class _AnimationsDemoScreenState extends State<AnimationsDemoScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppDesignSystem.styledAppBar(
        title: 'Animações e Efeitos',
        context: context,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animações de entrada
            FadeInUpAnimation(
              duration: const Duration(milliseconds: 800),
              child: _buildSectionCard(
                title: 'Animações de Entrada',
                child: Column(
                  children: [
                    const Text('Elementos aparecem suavemente de baixo para cima'),
                    const SizedBox(height: 16),
                    BounceInAnimation(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppDesignSystem.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('Bounce Animation'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Cards animados
            FadeInUpAnimation(
              duration: const Duration(milliseconds: 1000),
              child: _buildSectionCard(
                title: 'Cards Interativos',
                child: AnimatedGridView(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: List.generate(4, (index) {
                    return AnimatedCard(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppDesignSystem.primaryColor.withOpacity(0.1),
                              AppDesignSystem.accentColor.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star,
                              color: AppDesignSystem.primaryColor,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Card ${index + 1}',
                              style: AppDesignSystem.bodyStyle.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Loading animations
            FadeInUpAnimation(
              duration: const Duration(milliseconds: 1200),
              child: _buildSectionCard(
                title: 'Estados de Loading',
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = !_isLoading;
                        });
                      },
                      child: Text(_isLoading ? 'Parar Loading' : 'Iniciar Loading'),
                    ),
                    const SizedBox(height: 16),
                    if (_isLoading)
                      Column(
                        children: [
                          const CardSkeleton(itemCount: 3),
                          const SizedBox(height: 16),
                          LoadingAnimation(
                            width: double.infinity,
                            height: 60,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Botões com gradiente
            FadeInUpAnimation(
              duration: const Duration(milliseconds: 1400),
              child: _buildSectionCard(
                title: 'Botões com Gradiente',
                child: Column(
                  children: [
                    GradientButton(
                      text: 'Botão Principal',
                      onPressed: () {},
                    ),
                    const SizedBox(height: 16),
                    GradientButton(
                      text: 'Botão com Loading',
                      onPressed: () {},
                      isLoading: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Animação de pulso
            FadeInUpAnimation(
              duration: const Duration(milliseconds: 1600),
              child: _buildSectionCard(
                title: 'Animação de Pulso',
                child: PulseAnimation(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppDesignSystem.successColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppDesignSystem.successColor,
                        width: 2,
                      ),
                    ),
                    child: const Text('Elemento com pulso'),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return AppDesignSystem.styledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppDesignSystem.h3Style.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
