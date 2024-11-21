import 'package:flutter/material.dart';
import '../models/journal_entry.dart';

class JournalEntryForm extends StatefulWidget {
  final JournalEntry? initialEntry;
  final Function(String content, String? imageUrl, List<String> tags) onSubmit;

  const JournalEntryForm({
    super.key,
    this.initialEntry,
    required this.onSubmit,
  });

  @override
  State<JournalEntryForm> createState() => _JournalEntryFormState();
}

class _JournalEntryFormState extends State<JournalEntryForm> {
  late final TextEditingController _contentController;
  String? _imageUrl;
  final List<String> _tags = [];
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(
      text: widget.initialEntry?.content ?? '',
    );
    _imageUrl = widget.initialEntry?.imageUrl;
    if (widget.initialEntry?.tags != null) {
      _tags.addAll(widget.initialEntry!.tags);
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      widget.onSubmit(_contentController.text, _imageUrl, _tags);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _contentController,
            maxLines: null,
            minLines: 3,
            decoration: InputDecoration(
              hintText: 'What are you thinking?',
              filled: true,
              fillColor: theme.colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your thoughts';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.image_outlined),
                onPressed: () {
                  // TODO: Implement image upload
                },
                tooltip: 'Add Image',
              ),
              IconButton(
                icon: const Icon(Icons.tag_outlined),
                onPressed: () {
                  // Show tag input dialog
                  showDialog(
                    context: context,
                    builder: (context) => _AddTagDialog(
                      onAddTag: (tag) {
                        if (!_tags.contains(tag)) {
                          setState(() => _tags.add(tag));
                        }
                      },
                    ),
                  );
                },
                tooltip: 'Add Tag',
              ),
              const Spacer(),
              FilledButton(
                onPressed: _isSubmitting ? null : _handleSubmit,
                child: Text(_isSubmitting ? 'Posting...' : 'Post'),
              ),
            ],
          ),
          if (_tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _tags.map((tag) {
                return Chip(
                  label: Text(tag),
                  onDeleted: () {
                    setState(() => _tags.remove(tag));
                  },
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  deleteIconColor: theme.colorScheme.onSecondaryContainer,
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _AddTagDialog extends StatefulWidget {
  final Function(String) onAddTag;

  const _AddTagDialog({required this.onAddTag});

  @override
  State<_AddTagDialog> createState() => _AddTagDialogState();
}

class _AddTagDialogState extends State<_AddTagDialog> {
  final _tagController = TextEditingController();

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Tag'),
      content: TextField(
        controller: _tagController,
        decoration: const InputDecoration(
          hintText: 'Enter tag',
        ),
        autofocus: true,
        textCapitalization: TextCapitalization.words,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final tag = _tagController.text.trim();
            if (tag.isNotEmpty) {
              widget.onAddTag(tag);
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
