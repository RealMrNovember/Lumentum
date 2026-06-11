import 'package:flutter/material.dart';
import 'package:lumentum/l10n/app_localizations.dart';

import '../../core/i18n/language_switcher.dart';
import '../../core/theme/app_theme.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';
import 'widgets/feature_card.dart';
import 'widgets/hero_orp_demo.dart';
import 'widgets/showcase_background.dart';

/// lumentum.cicibyte.com kök showcase — ürün tanıtımı + Signup/Login girişi.
class ShowcaseScreen extends StatelessWidget {
  const ShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width > 900;

    return Scaffold(
      body: ShowcaseBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.black.withValues(alpha: 0.25),
              surfaceTintColor: Colors.transparent,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bolt, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    l10n.appTitle,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              actions: [
                const LanguageSwitcher(compact: true),
                TextButton(
                  onPressed: () => _openLogin(context),
                  child: Text(l10n.login),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: FilledButton(
                    onPressed: () => _openRegister(context),
                    child: Text(l10n.startTrial14Days),
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 64 : 24,
                  vertical: 48,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(child: _heroText(context, l10n)),
                              const SizedBox(width: 48),
                              Expanded(child: _heroDemo(context, l10n)),
                            ],
                          )
                        : Column(
                            children: [
                              _heroText(context, l10n),
                              const SizedBox(height: 40),
                              _heroDemo(context, l10n),
                            ],
                          ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isWide ? 64 : 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final cols = constraints.maxWidth > 800 ? 3 : 1;
                        return GridView.count(
                          crossAxisCount: cols,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: cols == 1 ? 1.8 : 0.95,
                          children: [
                            FeatureCard(
                              icon: Icons.center_focus_strong,
                              title: l10n.showcaseFeatureOrpTitle,
                              description: l10n.showcaseFeatureOrpDesc,
                              accent: AppTheme.focusColor,
                            ),
                            FeatureCard(
                              icon: Icons.speed,
                              title: l10n.showcaseFeatureCpsTitle,
                              description: l10n.showcaseFeatureCpsDesc,
                              accent: Theme.of(context).colorScheme.primary,
                            ),
                            FeatureCard(
                              icon: Icons.visibility_outlined,
                              title: l10n.showcaseFeatureFocusTitle,
                              description: l10n.showcaseFeatureFocusDesc,
                              accent: const Color(0xFF8B5CF6),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  isWide ? 64 : 24,
                  64,
                  isWide ? 64 : 24,
                  24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.2),
                            AppTheme.focusColor.withValues(alpha: 0.12),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            l10n.showcaseCtaTitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.showcaseCtaSubtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: [
                              FilledButton.icon(
                                onPressed: () => _openRegister(context),
                                icon: const Icon(Icons.rocket_launch),
                                label: Text(l10n.startTrial14Days),
                              ),
                              OutlinedButton(
                                onPressed: () => _openLogin(context),
                                child: Text(l10n.login),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  l10n.showcaseFooter,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.35),
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _heroText(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.tagline.toUpperCase(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 2,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.showcaseHeroTitle,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.15,
                letterSpacing: -0.5,
              ),
        ),
        const SizedBox(height: 20),
        Text(
          l10n.showcaseHeroSubtitle,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
                height: 1.6,
              ),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: () => _openRegister(context),
              icon: const Icon(Icons.arrow_forward),
              label: Text(l10n.startTrial14Days),
            ),
            OutlinedButton(
              onPressed: () => _openLogin(context),
              child: Text(l10n.login),
            ),
          ],
        ),
      ],
    );
  }

  Widget _heroDemo(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        Text(
          l10n.showcaseOrpLabel.toUpperCase(),
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.45),
            letterSpacing: 1.5,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        const HeroOrpDemo(),
        const SizedBox(height: 20),
        const LanguageSwitcher(),
      ],
    );
  }

  void _openLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _openRegister(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }
}
