import 'package:flutter/material.dart';

class ArticleDetailPage extends StatefulWidget {
  const ArticleDetailPage({
    super.key,
    required this.title,
    required this.source,
    required this.publishedAt,
    required this.content,
  });

  final String title;
  final String source;
  final DateTime publishedAt;
  final String content;

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  final ScrollController _scrollController = ScrollController();
  double _progress = 0;
  double _fontScale = 1.0; // 文字缩放：0.9 ~ 1.3

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double offset = _scrollController.offset;
    final double value = maxScroll <= 0 ? 0 : (offset / maxScroll).clamp(0, 1);
    if (value != _progress) {
      setState(() {
        _progress = value;
      });
    }
  }

  void _decreaseFont() {
    setState(() {
      _fontScale = (_fontScale - 0.1).clamp(0.9, 1.3);
    });
  }

  void _increaseFont() {
    setState(() {
      _fontScale = (_fontScale + 0.1).clamp(0.9, 1.3);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: colors.surface,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            tooltip: '减小字号',
            icon: const Icon(Icons.text_decrease),
            onPressed: _decreaseFont,
          ),
          IconButton(
            tooltip: '增大字号',
            icon: const Icon(Icons.text_increase),
            onPressed: _increaseFont,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          // 阅读进度条
          SizedBox(
            height: 4,
            child: LinearProgressIndicator(
              value: _progress == 0 ? null : _progress,
              backgroundColor: colors.surfaceContainerHighest,
              color: colors.primary,
            ),
          ),
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: _buildArticleContent(context),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Row(
            children: <Widget>[
              _ActionButton(
                icon: Icons.bookmark_border,
                label: '稍后读',
                onTap: () {},
              ),
              const SizedBox(width: 12),
              _ActionButton(
                icon: Icons.share_outlined,
                label: '分享',
                onTap: () {},
              ),
              const Spacer(),
              Text(
                '${(_progress * 100).round()}%',
                style: theme.textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleContent(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    final TextStyle titleStyle = theme.textTheme.headlineSmall!.copyWith(
      fontWeight: FontWeight.w700,
      height: 1.25,
    );
    final TextStyle metaStyle = theme.textTheme.bodySmall!.copyWith(
      color: colors.onSurfaceVariant,
    );
    final TextStyle bodyStyle = theme.textTheme.bodyLarge!.copyWith(
      height: 1.7,
      fontSize: theme.textTheme.bodyLarge!.fontSize! * _fontScale,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 标题
        Text(widget.title, style: titleStyle),
        const SizedBox(height: 10),
        // 元信息：来源 / 时间
        Row(
          children: <Widget>[
            Icon(Icons.public, size: 14, color: colors.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(widget.source, style: metaStyle),
            const SizedBox(width: 10),
            Container(width: 4, height: 4, decoration: BoxDecoration(color: colors.onSurfaceVariant, shape: BoxShape.circle)),
            const SizedBox(width: 10),
            Icon(Icons.access_time, size: 14, color: colors.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(_formatTime(widget.publishedAt), style: metaStyle),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(height: 1),
        const SizedBox(height: 16),
        // 正文
        Text(widget.content, style: bodyStyle),
        const SizedBox(height: 24),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final Duration diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return '刚刚';
    if (diff.inHours < 1) return '${diff.inMinutes} 分钟前';
    if (diff.inDays < 1) return '${diff.inHours} 小时前';
    if (diff.inDays < 7) return '${diff.inDays} 天前';
    return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}';
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 18, color: colors.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(label, style: theme.textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}


