import 'package:flutter/material.dart';

class AudioPlayer extends StatelessWidget {
  const AudioPlayer({
    super.key,
    required this.isPlaying,
    required this.progress,
    required this.duration,
    required this.onPlayPause,
    required this.onSeek,
  });

  final bool isPlaying;
  final Duration progress;
  final Duration duration;
  final VoidCallback onPlayPause;
  final Function(Duration) onSeek;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressValue = duration.inMilliseconds > 0 
        ? progress.inMilliseconds / duration.inMilliseconds 
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 进度条
          Slider(
            value: progressValue.clamp(0.0, 1.0),
            onChanged: (value) {
              final newPosition = Duration(
                milliseconds: (value * duration.inMilliseconds).round(),
              );
              onSeek(newPosition);
            },
            activeColor: theme.colorScheme.primary,
            inactiveColor: theme.colorScheme.outline,
          ),
          
          // 时间显示和控制按钮
          Row(
            children: [
              Text(
                _formatDuration(progress),
                style: theme.textTheme.bodySmall,
              ),
              const Spacer(),
              
              // 播放/暂停按钮
              IconButton(
                onPressed: onPlayPause,
                icon: Icon(
                  isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
              ),
              
              const Spacer(),
              Text(
                _formatDuration(duration),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }
}

