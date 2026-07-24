import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:frontend/models/timeline_model.dart';
import 'package:frontend/repositories/dashboard_repository.dart';

final timelineProvider = FutureProvider.autoDispose<TimelineData>((ref) async {
  final repo = DashboardRepository();
  return await repo.fetchTimeline();
});

class OperationalTimeline extends ConsumerWidget {
  final int maxEvents;

  const OperationalTimeline({super.key, this.maxEvents = 8});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(timelineProvider);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, color: Colors.blueGrey[700]),
                const SizedBox(width: 8),
                Text('Operational Timeline', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            asyncData.when(
              data: (data) {
                final events = data.events.take(maxEvents).toList();
                if (events.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No recent events recorded.', style: TextStyle(color: Colors.grey)),
                  );
                }
                
                return Column(
                  children: List.generate(events.length, (index) {
                    return _AnimatedTimelineEvent(
                      event: events[index],
                      isLast: index == events.length - 1,
                      index: index,
                    );
                  }),
                );
              },
              loading: () => const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator())),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Failed to load timeline: $e', style: const TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedTimelineEvent extends StatefulWidget {
  final TimelineEvent event;
  final bool isLast;
  final int index;

  const _AnimatedTimelineEvent({
    required this.event,
    required this.isLast,
    required this.index,
  });

  @override
  State<_AnimatedTimelineEvent> createState() => _AnimatedTimelineEventState();
}

class _AnimatedTimelineEventState extends State<_AnimatedTimelineEvent> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Staggered start based on index
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color getSeverityColor(String severity) {
      switch (severity.toLowerCase()) {
        case 'critical': return Colors.red;
        case 'warning': return Colors.orange;
        case 'resolved': return Colors.green;
        case 'info':
        default: return Colors.blue;
      }
    }
    
    IconData getSeverityIcon(String severity) {
      switch (severity.toLowerCase()) {
        case 'critical': return Icons.error;
        case 'warning': return Icons.warning;
        case 'resolved': return Icons.check_circle;
        case 'info':
        default: return Icons.info;
      }
    }

    final color = getSeverityColor(widget.event.severity);
    final icon = getSeverityIcon(widget.event.severity);
    final timeStr = DateFormat('HH:mm').format(widget.event.timestamp.toLocal());

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Time column
              SizedBox(
                width: 48,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text(timeStr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blueGrey)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              
              // Timeline line and dot
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 16),
                  ),
                  if (!widget.isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: Colors.grey.shade300,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              
              // Content column
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0, top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.event.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4)
                            ),
                            child: Text(
                              widget.event.severity.toUpperCase(),
                              style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.event.description,
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
