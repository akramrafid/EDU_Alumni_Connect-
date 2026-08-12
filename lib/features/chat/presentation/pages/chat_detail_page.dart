import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class _Message {
  final String text;
  final String time;
  final bool isMe;
  final String? type; // 'text', 'image', 'document', 'voice'
  final String? mediaUrl;
  final String? duration; // for voice
  final String? fileName; // for document
  final String? fileSize; // for document
  final List<String> reactions;

  _Message({
    required this.text,
    required this.time,
    required this.isMe,
    this.type = 'text',
    this.mediaUrl,
    this.duration,
    this.fileName,
    this.fileSize,
    List<String>? reactions,
  }) : reactions = reactions ?? [];
}

class ChatDetailPage extends ConsumerStatefulWidget {
  final String? conversationId;
  const ChatDetailPage({super.key, this.conversationId});

  @override
  ConsumerState<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends ConsumerState<ChatDetailPage> {
  final List<_Message> _messages = [
    _Message(
      text: 'Hello! I saw your recent post about the upcoming FinTech summit. Are you planning to attend the keynote panel?',
      time: '10:42 AM',
      isMe: false,
    ),
    _Message(
      text: 'Hi Dr. Vance! Yes, I wouldn\'t miss it. The discussion on blockchain applications in institutional banking looks particularly relevant to my current project.',
      time: '10:45 AM',
      isMe: true,
    ),
    _Message(
      text: 'Excellent. Let\'s try to connect during the networking lunch. I have a few contacts there I\'d love to introduce you to.',
      time: '10:47 AM',
      isMe: false,
    ),
  ];

  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isRecording = false;
  int _recordingSeconds = 0;
  Timer? _recordingTimer;
  bool _isTyping = true;
  String? _pendingImage;
  String? _pendingDocName;
  String? _pendingDocSize;

  @override
  void initState() {
    super.initState();
    // Simulate user typing indicator at first
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _recordingTimer?.cancel();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty && _pendingImage == null && _pendingDocName == null) return;

    final now = DateTime.now();
    final timeStr = "${now.hour > 12 ? now.hour - 12 : now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";

    setState(() {
      if (_pendingImage != null) {
        _messages.add(_Message(
          text: text.isNotEmpty ? text : 'Sent an image',
          time: timeStr,
          isMe: true,
          type: 'image',
          mediaUrl: _pendingImage,
        ));
        _pendingImage = null;
      } else if (_pendingDocName != null) {
        _messages.add(_Message(
          text: text.isNotEmpty ? text : 'Sent a document',
          time: timeStr,
          isMe: true,
          type: 'document',
          fileName: _pendingDocName,
          fileSize: _pendingDocSize,
        ));
        _pendingDocName = null;
        _pendingDocSize = null;
      } else {
        _messages.add(_Message(
          text: text,
          time: timeStr,
          isMe: true,
        ));
      }
      _textController.clear();
      _isTyping = false; // Stop initial typing indicator
    });

    _scrollToBottom();

    // Simulate reply after sending
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isTyping = true;
      });
      _scrollToBottom();
      Timer(const Duration(milliseconds: 2500), () {
        if (!mounted) return;
        setState(() {
          _isTyping = false;
          _messages.add(_Message(
            text: 'That sounds perfect! Let\'s catch up and discuss it in detail.',
            time: 'Just now',
            isMe: false,
          ));
        });
        _scrollToBottom();
      });
    });
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordingSeconds = 0;
    });
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingSeconds++;
      });
    });
  }

  void _stopAndSendRecording() {
    _recordingTimer?.cancel();
    if (_recordingSeconds < 1) {
      setState(() {
        _isRecording = false;
      });
      return;
    }

    final now = DateTime.now();
    final timeStr = "${now.hour > 12 ? now.hour - 12 : now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";
    final durationStr = "${_recordingSeconds ~/ 60}:${(_recordingSeconds % 60).toString().padLeft(2, '0')}";

    setState(() {
      _messages.add(_Message(
        text: 'Voice message',
        time: timeStr,
        isMe: true,
        type: 'voice',
        duration: durationStr,
      ));
      _isRecording = false;
    });
    _scrollToBottom();
  }

  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Share Attachment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAttachmentItem(
                      icon: Icons.photo,
                      label: 'Photo',
                      color: Colors.blue,
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _pendingImage = 'https://images.unsplash.com/photo-1531403009284-440f080d1e12?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80';
                        });
                      },
                    ),
                    _buildAttachmentItem(
                      icon: Icons.insert_drive_file,
                      label: 'Document',
                      color: Colors.orange,
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _pendingDocName = 'EDU_Alumni_Project_Scope.pdf';
                          _pendingDocSize = '2.4 MB';
                        });
                      },
                    ),
                    _buildAttachmentItem(
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      color: Colors.teal,
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _pendingImage = 'https://images.unsplash.com/photo-1542751371-adc38448a05e?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80';
                        });
                      },
                    ),
                    _buildAttachmentItem(
                      icon: Icons.location_on,
                      label: 'Location',
                      color: Colors.red,
                      onTap: () {
                        Navigator.pop(context);
                        final now = DateTime.now();
                        final timeStr = "${now.hour > 12 ? now.hour - 12 : now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";
                        setState(() {
                          _messages.add(_Message(
                            text: 'East Delta University Campus',
                            time: timeStr,
                            isMe: true,
                            type: 'document',
                            fileName: 'Shared Location.gpx',
                            fileSize: 'Map Location',
                          ));
                        });
                        _scrollToBottom();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttachmentItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF700000),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=9'),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Dr. Ananya Chowdhury',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Alumni Mentor',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(24),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return _buildTypingIndicator();
                }
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          if (_pendingImage != null || _pendingDocName != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  if (_pendingImage != null)
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(_pendingImage!, width: 60, height: 60, fit: BoxFit.cover),
                        ),
                        Positioned(
                          right: -4,
                          top: -4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _pendingImage = null;
                              });
                            },
                            child: const CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.red,
                              child: Icon(Icons.close, size: 12, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (_pendingDocName != null)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.insert_drive_file, color: Color(0xFF700000)),
                          const SizedBox(width: 8),
                          Text(
                            _pendingDocName!,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _pendingDocName = null;
                                _pendingDocSize = null;
                              });
                            },
                            child: const Icon(Icons.close, size: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(_Message message) {
    final isMe = message.isMe;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: GestureDetector(
              onDoubleTap: () {
                setState(() {
                  if (!message.reactions.contains('❤️')) {
                    message.reactions.add('❤️');
                  } else {
                    message.reactions.remove('❤️');
                  }
                });
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF700000) : Colors.grey.shade200,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(isMe ? 20 : 4),
                        bottomRight: Radius.circular(isMe ? 4 : 20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        if (message.type == 'image' && message.mediaUrl != null) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              message.mediaUrl!,
                              height: 160,
                              width: 220,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        if (message.type == 'document' && message.fileName != null) ...[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.insert_drive_file, color: isMe ? Colors.white : const Color(0xFF700000), size: 28),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message.fileName!,
                                      style: TextStyle(
                                        color: isMe ? Colors.white : Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      message.fileSize ?? '',
                                      style: TextStyle(
                                        color: (isMe ? Colors.white : Colors.black54).withOpacity(0.7),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.download, color: isMe ? Colors.white70 : Colors.black54, size: 20),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                        if (message.type == 'voice' && message.duration != null) ...[
                          SizedBox(
                            width: 220,
                            child: _VoicePlayerWidget(duration: message.duration!, isMe: isMe),
                          ),
                          const SizedBox(height: 8),
                        ] else ...[
                          Text(
                            message.text,
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black87,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ],
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              message.time,
                              style: TextStyle(
                                color: isMe ? Colors.white70 : Colors.black45,
                                fontSize: 10,
                              ),
                            ),
                            if (isMe) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.done_all,
                                color: Colors.white70,
                                size: 14,
                              ),
                            ]
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (message.reactions.isNotEmpty)
                    Positioned(
                      bottom: -8,
                      right: isMe ? null : -8,
                      left: isMe ? -8 : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Text(
                          message.reactions.join(' '),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 12,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=9'),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                _TypingDot(),
                SizedBox(width: 4),
                _TypingDot(),
                SizedBox(width: 4),
                _TypingDot(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.black54),
              onPressed: _showAttachmentMenu,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _isRecording
                  ? Row(
                      children: [
                        const Icon(Icons.mic, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          'Recording ${_recordingSeconds ~/ 60}:${(_recordingSeconds % 60).toString().padLeft(2, "0")}',
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        const _VoiceRecordingPulse(),
                      ],
                    )
                  : TextField(
                      controller: _textController,
                      onChanged: (val) {
                        setState(() {}); // refresh build to switch mic/send icons
                      },
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: Colors.black38),
                        border: InputBorder.none,
                      ),
                    ),
            ),
            if (_isRecording) ...[
              IconButton(
                icon: const Icon(Icons.cancel_outlined, color: Colors.black54),
                onPressed: () {
                  _recordingTimer?.cancel();
                  setState(() {
                    _isRecording = false;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.red),
                onPressed: _stopAndSendRecording,
              ),
            ] else ...[
              if (_textController.text.trim().isNotEmpty || _pendingImage != null || _pendingDocName != null)
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF700000),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.white, size: 16),
                  ),
                )
              else
                GestureDetector(
                  onLongPress: _startRecording,
                  onLongPressEnd: (_) => _stopAndSendRecording,
                  onTap: () {
                    // Tap to record or notify
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Hold the microphone icon to record a voice message.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.mic, color: Colors.black54),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _VoicePlayerWidget extends StatefulWidget {
  final String duration;
  final bool isMe;
  const _VoicePlayerWidget({required this.duration, required this.isMe});

  @override
  State<_VoicePlayerWidget> createState() => _VoicePlayerWidgetState();
}

class _VoicePlayerWidgetState extends State<_VoicePlayerWidget> {
  bool _isPlaying = false;
  double _sliderValue = 0.0;
  Timer? _playbackTimer;

  void _togglePlay() {
    if (_isPlaying) {
      _playbackTimer?.cancel();
      setState(() {
        _isPlaying = false;
      });
    } else {
      setState(() {
        _isPlaying = true;
      });
      _playbackTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
        setState(() {
          _sliderValue += 0.05;
          if (_sliderValue >= 1.0) {
            _sliderValue = 0.0;
            _isPlaying = false;
            _playbackTimer?.cancel();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isMe ? Colors.white : const Color(0xFF700000);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
          color: color,
          iconSize: 36,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: _togglePlay,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                  activeTrackColor: color,
                  inactiveTrackColor: color.withOpacity(0.3),
                  thumbColor: color,
                ),
                child: Slider(
                  value: _sliderValue,
                  onChanged: (val) {
                    setState(() {
                      _sliderValue = val;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '0:00',
                      style: TextStyle(color: color.withOpacity(0.7), fontSize: 10),
                    ),
                    Text(
                      widget.duration,
                      style: TextStyle(color: color.withOpacity(0.7), fontSize: 10),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _TypingDot extends StatefulWidget {
  const _TypingDot();

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.2, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _VoiceRecordingPulse extends StatefulWidget {
  const _VoiceRecordingPulse();

  @override
  State<_VoiceRecordingPulse> createState() => _VoiceRecordingPulseState();
}

class _VoiceRecordingPulseState extends State<_VoiceRecordingPulse> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 4.0, end: 12.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: _animation.value,
          height: _animation.value,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
