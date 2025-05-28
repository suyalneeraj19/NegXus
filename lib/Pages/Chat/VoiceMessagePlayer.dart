import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

class VoiceMessagePlayer extends StatefulWidget {
  final String audioUrl;
  final bool isComming;
  const VoiceMessagePlayer({super.key, required this.audioUrl, required this.isComming});

  @override
  State<VoiceMessagePlayer> createState() => _VoiceMessagePlayerState();
}

class _VoiceMessagePlayerState extends State<VoiceMessagePlayer> {
  late AudioPlayer _player;
  late PlayerController _waveController;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  String? _localPath;
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _waveController = PlayerController();
    _prepareAudio();
  }

  Future<void> _prepareAudio() async {
    try {
      if (widget.audioUrl.isEmpty) {
        if (mounted) setState(() => _isError = true);
        return;
      }
      _localPath = await _downloadAudioFile(widget.audioUrl);
      if (!File(_localPath!).existsSync()) {
        if (mounted) setState(() => _isError = true);
        return;
      }
      await _player.setFilePath(_localPath!);
      _duration = _player.duration ?? Duration.zero;
      await _waveController.preparePlayer(path: _localPath!);
      _player.positionStream.listen((p) {
        if (mounted) setState(() => _position = p);
      });
      _player.playerStateStream.listen((state) {
        if (mounted) setState(() => _isPlaying = state.playing);
      });
      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      if (mounted)
        setState(() {
          _isError = true;
          _isLoading = false;
        });
    }
  }

  Future<String> _downloadAudioFile(String url) async {
    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';
    final file = File(filePath);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } else {
      throw Exception('Failed to download audio');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _togglePlay() async {
    if (_isPlaying) {
      await _player.pause();
      _waveController.pausePlayer();
    } else {
      await _player.play();
      _waveController.startPlayer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = widget.isComming ? Colors.purpleAccent.withOpacity(0.7) : Colors.blueAccent.withOpacity(0.7);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_isError) {
      return const Text("Audio unavailable", style: TextStyle(color: Colors.red));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: accentColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(2, 2),
                )
              ],
            ),
            child: IconButton(
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
              onPressed: _togglePlay,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AudioFileWaveforms(
              playerController: _waveController,
              size: const Size(double.infinity, 40),
              playerWaveStyle: PlayerWaveStyle(
                fixedWaveColor: accentColor,
                liveWaveColor: accentColor.withOpacity(0.5),
                spacing: 4,
                waveThickness: 2,
                showSeekLine: false,
                showBottom: false,
                showTop: false,
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "${_position.inSeconds}/${_duration.inSeconds}s",
            style: TextStyle(
              fontSize: 13,
              color: accentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
