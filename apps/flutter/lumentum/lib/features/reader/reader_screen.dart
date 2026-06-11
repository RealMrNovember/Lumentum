import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lumentum/l10n/app_localizations.dart';
import 'package:lumentum_shared/lumentum_shared.dart';
import 'package:provider/provider.dart';

import '../../core/auth/auth_provider.dart';
import '../../core/i18n/language_switcher.dart';
import '../../core/reading/reading_preferences_provider.dart';
import 'widgets/rsvp_canvas.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({
    super.key,
    this.initialText,
    this.documentId,
    this.documentTitle,
    this.immersive = false,
  });

  final String? initialText;
  final String? documentId;
  final String? documentTitle;
  final bool immersive;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  late final TextEditingController _textController;
  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.initialText ??
          'Lumentum bilişsel okuma hızını artırır ve göz yorgunluğunu azaltır.',
    );
    final prefs = context.read<ReadingPreferencesProvider>();
    _speedFactor = prefs.speedFactor;

    if (widget.immersive) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _prepare());
    }
  }

  List<TokenData> _tokens = [];
  int _index = 0;
  bool _playing = false;
  bool _loading = false;
  double _speedFactor = 1.0;
  Timer? _timer;
  DateTime? _sessionStart;
  int _wordsShown = 0;

  @override
  void dispose() {
    _timer?.cancel();
    _textController.dispose();
    super.dispose();
  }

  double get _progress =>
      _tokens.isEmpty ? 0 : (_index / _tokens.length).clamp(0.0, 1.0);

  int get _estimatedWpm {
    if (_sessionStart == null || _wordsShown < 2) return 0;
    final elapsed = DateTime.now().difference(_sessionStart!).inSeconds;
    if (elapsed < 1) return 0;
    return ((_wordsShown / elapsed) * 60).round();
  }

  Future<void> _prepare() async {
    setState(() {
      _loading = true;
      _playing = false;
      _index = 0;
      _wordsShown = 0;
      _sessionStart = null;
    });
    _timer?.cancel();

    try {
      final api = context.read<AuthProvider>().api;
      final response = await api.processReading(_textController.text.trim());
      if (!mounted) return;
      setState(() => _tokens = response.result);
      if (widget.documentId != null) {
        await context
            .read<ReadingPreferencesProvider>()
            .setLastDocumentId(widget.documentId);
      }
    } on LumentumApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.body)),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _togglePlay() {
    if (_tokens.isEmpty) return;
    if (_playing) {
      _timer?.cancel();
      setState(() => _playing = false);
      return;
    }
    _sessionStart ??= DateTime.now();
    setState(() => _playing = true);
    _scheduleNext();
  }

  void _scheduleNext() {
    _timer?.cancel();
    if (_index >= _tokens.length) {
      _onComplete();
      return;
    }
    final pace = (_tokens[_index].paceMs / _speedFactor).round().clamp(20, 2000);
    _timer = Timer(Duration(milliseconds: pace), () {
      if (!mounted) return;
      setState(() {
        _index++;
        if (_tokens[_index - 1].token.trim().isNotEmpty) _wordsShown++;
      });
      if (_index < _tokens.length) {
        _scheduleNext();
      } else {
        _onComplete();
      }
    });
  }

  Future<void> _onComplete() async {
    _timer?.cancel();
    setState(() => _playing = false);
    await context.read<ReadingPreferencesProvider>().recordCompletedSession();
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _playing = false;
      _index = 0;
      _wordsShown = 0;
      _sessionStart = null;
    });
  }

  void _onSpeedChanged(double value) {
    setState(() => _speedFactor = value);
    context.read<ReadingPreferencesProvider>().setSpeedFactor(value);
    if (_playing) {
      _scheduleNext();
    }
  }

  TokenData? get _current =>
      _tokens.isEmpty || _index >= _tokens.length ? null : _tokens[_index];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final immersive = widget.immersive;

    return Scaffold(
      backgroundColor: const Color(0xFF080A0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          immersive
              ? (widget.documentTitle ?? l10n.startReading)
              : l10n.startReading,
        ),
        actions: const [
          LanguageSwitcher(compact: true),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          if (_tokens.isNotEmpty)
            LinearProgressIndicator(
              value: _progress,
              minHeight: 3,
              backgroundColor: Colors.white12,
            ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _tokens.isEmpty || _loading ? null : _togglePlay,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(child: RsvpCanvas(token: _current)),
                  if (_loading)
                    const CircularProgressIndicator()
                  else if (_tokens.isEmpty && immersive)
                    Text(
                      l10n.prepareFirst,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white54,
                          ),
                    )
                  else if (_tokens.isNotEmpty && !_playing)
                    Positioned(
                      bottom: 32,
                      child: Text(
                        l10n.tapToPlay,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white38,
                            ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          _ReaderControls(
            immersive: immersive,
            speedFactor: _speedFactor,
            loading: _loading,
            tokensReady: _tokens.isNotEmpty,
            playing: _playing,
            progress: _progress,
            estimatedWpm: _estimatedWpm,
            textController: immersive ? null : _textController,
            onSpeedChanged: _onSpeedChanged,
            onPrepare: _prepare,
            onTogglePlay: _togglePlay,
            onReset: _reset,
          ),
        ],
      ),
    );
  }
}

class _ReaderControls extends StatelessWidget {
  const _ReaderControls({
    required this.immersive,
    required this.speedFactor,
    required this.loading,
    required this.tokensReady,
    required this.playing,
    required this.progress,
    required this.estimatedWpm,
    required this.textController,
    required this.onSpeedChanged,
    required this.onPrepare,
    required this.onTogglePlay,
    required this.onReset,
  });

  final bool immersive;
  final double speedFactor;
  final bool loading;
  final bool tokensReady;
  final bool playing;
  final double progress;
  final int estimatedWpm;
  final TextEditingController? textController;
  final ValueChanged<double> onSpeedChanged;
  final VoidCallback onPrepare;
  final VoidCallback onTogglePlay;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.92),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + MediaQuery.paddingOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tokensReady)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.readingProgress((progress * 100).round()),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (estimatedWpm > 0)
                    Text(
                      l10n.wordsPerMinute(estimatedWpm),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                ],
              ),
            ),
          Row(
            children: [
              Icon(Icons.speed_rounded,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
              Expanded(
                child: Slider(
                  value: speedFactor,
                  min: 0.5,
                  max: 2.5,
                  divisions: 8,
                  label: '${speedFactor.toStringAsFixed(1)}x',
                  onChanged: onSpeedChanged,
                ),
              ),
              Text('${speedFactor.toStringAsFixed(1)}x',
                  style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
          if (!immersive && textController != null) ...[
            const SizedBox(height: 8),
            TextField(
              controller: textController,
              maxLines: 3,
              decoration: InputDecoration(labelText: l10n.pasteText),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              if (!immersive)
                Expanded(
                  child: OutlinedButton(
                    onPressed: loading ? null : onPrepare,
                    child: loading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.process),
                  ),
                ),
              if (!immersive) const SizedBox(width: 8),
              Expanded(
                flex: immersive ? 1 : 0,
                child: FilledButton.icon(
                  onPressed: tokensReady && !loading ? onTogglePlay : null,
                  icon: Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded),
                  label: Text(playing ? l10n.pause : l10n.play),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.outlined(
                onPressed: onReset,
                icon: const Icon(Icons.replay_rounded),
                tooltip: l10n.reset,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
