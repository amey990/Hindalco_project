part of '../main.dart';

class EntrySectionHeader extends StatelessWidget {
  const EntrySectionHeader({
    required this.icon,
    required this.title,
    required this.status,
    required this.isFound,
    super.key,
  });

  final IconData icon;
  final String title;
  final String status;
  final bool isFound;

  @override
  Widget build(BuildContext context) {
    final color = isFound ? const Color(0xFF17A56B) : const Color(0xFFE08A00);

    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1BA7E1), size: 21),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class EntryLookupBanner extends StatelessWidget {
  const EntryLookupBanner({
    required this.icon,
    required this.title,
    required this.message,
    required this.color,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final Color color;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.32)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFF515A68),
                    fontSize: 12,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: onAction,
                    icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                    label: Text(actionLabel!),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: color,
                      side: BorderSide(color: color),
                      minimumSize: const Size(0, 38),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EntryStatusText extends StatelessWidget {
  const EntryStatusText({required this.text, required this.color, super.key});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w900),
    );
  }
}

class DriverPhotoCapture extends StatelessWidget {
  const DriverPhotoCapture({
    required this.photoPath,
    required this.onCapture,
    super.key,
  });

  final String? photoPath;
  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:
                photoPath == null
                    ? Container(
                      height: 54,
                      width: 54,
                      color: const Color(0xFFEAF6FC),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        color: Color(0xFF1BA7E1),
                      ),
                    )
                    : DriverPhotoImage(path: photoPath!, height: 54, width: 54),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              photoPath == null ? 'Driver Photo' : 'Photo uploaded',
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          IconButton.filledTonal(
            onPressed: onCapture,
            icon: const Icon(Icons.photo_camera_outlined),
            tooltip: 'Capture driver photo',
            color: const Color(0xFF1BA7E1),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFEAF6FC),
              fixedSize: const Size(44, 44),
            ),
          ),
        ],
      ),
    );
  }
}

class DriverPhotoImage extends StatelessWidget {
  const DriverPhotoImage({
    required this.path,
    required this.height,
    required this.width,
    super.key,
  });

  final String path;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('assets/')) {
      return Image.asset(path, height: height, width: width, fit: BoxFit.cover);
    }
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        height: height,
        width: width,
        fit: BoxFit.cover,
      );
    }
    return Image.file(
      File(path),
      height: height,
      width: width,
      fit: BoxFit.cover,
    );
  }
}

class DashboardTextField extends StatelessWidget {
  const DashboardTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.validator,
    this.readOnly = false,
    this.onTap,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      showCursor: !readOnly,
      enableInteractiveSelection: !readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      validator:
          validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label is required';
            }
            return null;
          },
      decoration: _dashboardInputDecoration(
        label,
        icon,
      ).copyWith(fillColor: readOnly ? const Color(0xFFF8FAFC) : Colors.white),
    );
  }
}

class DashboardDropdownField extends StatelessWidget {
  const DashboardDropdownField({
    required this.value,
    required this.label,
    required this.icon,
    required this.items,
    required this.onChanged,
    required this.onAddOption,
    this.canAddOption = true,
    super.key,
  });

  final String value;
  final String label;
  final IconData icon;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final VoidCallback onAddOption;
  final bool canAddOption;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            key: ValueKey('${items.length}-$value'),
            initialValue: items.contains(value) ? value : null,
            items:
                items
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(item, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
            onChanged: onChanged,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            decoration: _dashboardInputDecoration(label, icon),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$label is required';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 56,
          width: 56,
          child: IconButton.filledTonal(
            onPressed: onAddOption,
            icon: const Icon(Icons.edit_outlined),
            tooltip:
                canAddOption
                    ? 'Add material type'
                    : 'Only supervisors/admins can add new materials.',
            color:
                canAddOption
                    ? const Color(0xFF1BA7E1)
                    : const Color(0xFF9AA2AF),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFEAF6FC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DateTimeInfoField extends StatelessWidget {
  const DateTimeInfoField({required this.value, super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF6FC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD4EAF5)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.event_available_outlined,
            color: Color(0xFF1BA7E1),
            size: 21,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Date and Time',
                  style: TextStyle(
                    color: Color(0xFF515A68),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.lock_outline_rounded, color: Color(0xFF9AA2AF)),
        ],
      ),
    );
  }
}

class HighTemperatureBanner extends StatelessWidget {
  const HighTemperatureBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5484D)),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Color(0xFFE5484D)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'High Temperature Detected - Supervisor Notified',
              style: TextStyle(
                color: Color(0xFFE5484D),
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
