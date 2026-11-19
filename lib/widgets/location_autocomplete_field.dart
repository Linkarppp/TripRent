import 'package:flutter/material.dart';
import '../data/location_data.dart';
import '../theme/app_theme.dart';

class LocationAutocompleteField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? hintText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onLocationSelected;

  const LocationAutocompleteField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.hintText,
    this.validator,
    this.onLocationSelected,
  });

  @override
  State<LocationAutocompleteField> createState() => _LocationAutocompleteFieldState();
}

class _LocationAutocompleteFieldState extends State<LocationAutocompleteField> {
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;
  List<LocationItem> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _filteredSuggestions = LocationData.search(widget.controller.text);
    widget.controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (!mounted) return;
    setState(() {
      _filteredSuggestions = LocationData.search(widget.controller.text);
      if (_focusNode.hasFocus && _filteredSuggestions.isNotEmpty) {
        _showSuggestions = true;
      }
    });
  }

  void _onFocusChanged() {
    if (!mounted) return;
    setState(() {
      if (_focusNode.hasFocus) {
        _filteredSuggestions = LocationData.search(widget.controller.text);
        _showSuggestions = _filteredSuggestions.isNotEmpty;
      } else {
        // Delay closing so that tap on suggestion list item can register
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted && !_focusNode.hasFocus) {
            setState(() {
              _showSuggestions = false;
            });
          }
        });
      }
    });
  }

  void _selectLocation(LocationItem item) {
    widget.controller.text = item.title;
    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: item.title.length),
    );
    setState(() {
      _showSuggestions = false;
    });
    _focusNode.unfocus();
    widget.onLocationSelected?.call(item.title);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
          validator: widget.validator ??
              (val) {
                if (val == null || val.trim().isEmpty) {
                  return '${widget.label} tidak boleh kosong';
                }
                return null;
              },
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
            prefixIcon: Icon(widget.icon, color: AppTheme.primaryLight, size: 18),
            suffixIcon: widget.controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: AppTheme.textMuted, size: 16),
                    onPressed: () {
                      widget.controller.clear();
                      setState(() {
                        _filteredSuggestions = LocationData.search('');
                        _showSuggestions = _focusNode.hasFocus;
                      });
                    },
                  )
                : (_showSuggestions
                    ? IconButton(
                        icon: const Icon(Icons.keyboard_arrow_up_rounded, color: AppTheme.primaryLight, size: 20),
                        onPressed: () => setState(() => _showSuggestions = false),
                      )
                    : null),
            filled: true,
            fillColor: AppTheme.cardColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primaryLight, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.danger),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.danger),
            ),
          ),
        ),

        // Dropdown Suggestion List directly below the field
        if (_showSuggestions && _filteredSuggestions.isNotEmpty) ...[
          const SizedBox(height: 6),
          Container(
            constraints: const BoxConstraints(maxHeight: 220),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.primary.withValues(alpha: 0.4), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    color: AppTheme.surface.withValues(alpha: 0.8),
                    child: Row(
                      children: [
                        const Icon(Icons.saved_search_rounded, size: 15, color: AppTheme.primaryLight),
                        const SizedBox(width: 6),
                        Text(
                          'Saran Lokasi Terkait (${_filteredSuggestions.length})',
                          style: const TextStyle(
                            color: AppTheme.primaryLight,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => setState(() => _showSuggestions = false),
                          child: const Padding(
                            padding: EdgeInsets.all(2),
                            child: Icon(Icons.close_rounded, size: 14, color: AppTheme.textMuted),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppTheme.cardBorder),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: _filteredSuggestions.length,
                      separatorBuilder: (_, _) => const Divider(
                        height: 1,
                        indent: 48,
                        color: AppTheme.cardBorder,
                      ),
                      itemBuilder: (context, index) {
                        final item = _filteredSuggestions[index];
                        return InkWell(
                          onTap: () => _selectLocation(item),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primary.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    item.icon,
                                    color: AppTheme.primaryLight,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        item.title,
                                        style: const TextStyle(
                                          color: AppTheme.textPrimary,
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item.subtitle,
                                        style: const TextStyle(
                                          color: AppTheme.textMuted,
                                          fontSize: 11,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.cardColor,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: AppTheme.cardBorder),
                                  ),
                                  child: Text(
                                    item.typeLabel,
                                    style: const TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
        ],
      ],
    );
  }
}
