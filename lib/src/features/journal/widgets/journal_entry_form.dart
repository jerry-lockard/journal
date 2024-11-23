import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/journal_entry.dart';
import '../providers/journal_provider.dart';

class JournalEntryForm extends ConsumerStatefulWidget {
  final JournalEntry? initialEntry;
  final VoidCallback? onSuccess;

  const JournalEntryForm({
    super.key,
    this.initialEntry,
    this.onSuccess,
    required Future<Null> Function(
            dynamic content, dynamic imageUrl, dynamic tags)
        onSubmit,
  });

  @override
  ConsumerState<JournalEntryForm> createState() => _JournalEntryFormState();
}

class _JournalEntryFormState extends ConsumerState<JournalEntryForm> {
  late final TextEditingController _contentController;
  String? _imageUrl;
  String? _localImagePath;
  final List<String> _tags = [];
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  final _imagePicker = ImagePicker();

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

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _localImagePath = pickedFile.path;
          _imageUrl = null; // Clear previous image URL
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final journalNotifier = ref.read(journalNotifierProvider.notifier);
      String? finalImageUrl = _imageUrl;

      // Upload new image if selected
      if (_localImagePath != null) {
        final imageFile = File(_localImagePath!);
        finalImageUrl = await journalNotifier.uploadImage(imageFile);
      }

      if (widget.initialEntry != null) {
        // Update existing entry
        final updatedEntry = widget.initialEntry!.copyWith(
          content: _contentController.text,
          imageUrl: finalImageUrl,
          tags: _tags,
          updatedAt: DateTime.now(),
        );
        await journalNotifier.updateEntry(updatedEntry);
      } else {
        // Create new entry
        await journalNotifier.createEntry(
          content: _contentController.text,
          imageUrl: finalImageUrl,
          tags: _tags,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Journal entry saved successfully!')),
        );
        widget.onSuccess?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving journal entry: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
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
          if (_localImagePath != null || _imageUrl != null) ...[
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _localImagePath != null
                      ? Image.file(
                          File(_localImagePath!),
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          _imageUrl!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _localImagePath = null;
                        _imageUrl = null;
                      });
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.surface,
                      foregroundColor: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
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
                onPressed: _isSubmitting ? null : _pickImage,
                tooltip: 'Add Image',
              ),
              IconButton(
                icon: const Icon(Icons.tag_outlined),
                onPressed: _isSubmitting
                    ? null
                    : () {
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
                child: Text(_isSubmitting ? 'Saving...' : 'Save'),
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
                  onDeleted: _isSubmitting
                      ? null
                      : () {
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
