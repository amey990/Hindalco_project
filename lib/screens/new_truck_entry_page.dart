part of '../main.dart';

class NewTruckEntryPage extends StatefulWidget {
  const NewTruckEntryPage({
    required this.existingEntries,
    required this.onLogout,
    required this.onSubmit,
    this.user,
    super.key,
  });

  final List<TruckEntry> existingEntries;
  final VoidCallback onLogout;
  final ValueChanged<TruckEntry> onSubmit;
  final AppUser? user;

  @override
  State<NewTruckEntryPage> createState() => _NewTruckEntryPageState();
}

class _NewTruckEntryPageState extends State<NewTruckEntryPage> {
  static const List<String> _fallbackCargoTypes = [
    'Raw Material',
    'Finished Goods',
    'Fuel',
    'Waste',
    'Other',
  ];
  final List<String> _cargoTypes = List<String>.from(_fallbackCargoTypes);
  final _formKey = GlobalKey<FormState>();
  final _searchPhoneController = TextEditingController();
  final _searchDriverNameController = TextEditingController();
  final _driverNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _truckNumberController = TextEditingController();
  final _temperatureController = TextEditingController();
  late final DateTime _entryDateTime;
  String _selectedCargoType = 'Raw Material';
  String? _driverPhotoPath;
  String? _capturedDriverPhotoPath;
  String? _uploadedDriverPhotoKey;
  List<MaterialOption> _materials = const [];
  bool _isCreatingNewDriver = false;
  bool _showEntryForm = false;
  bool _driverNotFound = false;
  bool _isSearchingDriver = false;
  String? _lastSearchedPhone;
  Driver? _matchedDriver;
  TruckEntry? _matchedTruck;
  GateEntrySubmitResult? _lastSubmissionResult;
  bool _isSubmitting = false;

  double? get _temperature =>
      double.tryParse(_temperatureController.text.trim());

  @override
  void initState() {
    super.initState();
    _entryDateTime = DateTime.now();
    _temperatureController.addListener(_refreshTemperatureWarning);
    _searchPhoneController.addListener(_refreshDriverSearch);
    _truckNumberController.addListener(_refreshTruckMatch);
    _loadMaterials();
  }

  @override
  void dispose() {
    _searchPhoneController.removeListener(_refreshDriverSearch);
    _truckNumberController.removeListener(_refreshTruckMatch);
    _temperatureController.removeListener(_refreshTemperatureWarning);
    _searchPhoneController.dispose();
    _searchDriverNameController.dispose();
    _driverNameController.dispose();
    _phoneController.dispose();
    _truckNumberController.dispose();
    _temperatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_lastSubmissionResult != null) {
      return EntryApprovalResultScreen(
        approval: _lastSubmissionResult!.approval,
        temperature: _lastSubmissionResult!.entry.temperature,
        onLogout: widget.onLogout,
        user: widget.user,
        onGoBack: _returnToEntryForm,
      );
    }

    if (widget.user?.canCreateEntry == false) {
      return const AccessDeniedView();
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardHeader(onLogout: widget.onLogout, user: widget.user),
                  const SizedBox(height: 24),
                  const Text(
                    'New Truck Entry',
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Search driver by phone number before creating gate entry.',
                    style: TextStyle(
                      color: Color(0xFF7D8491),
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 22),
                  const EntrySectionHeader(
                    icon: Icons.search_rounded,
                    title: 'Search Driver',
                    status: 'Phone lookup',
                    isFound: true,
                  ),
                  const SizedBox(height: 12),
                  DashboardTextField(
                    controller: _searchPhoneController,
                    label: 'Driver Phone Number',
                    icon: Icons.call_outlined,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (value) {
                      final phone = value?.trim() ?? '';
                      if (phone.isEmpty) {
                        return 'Driver phone number is required';
                      }
                      if (phone.length < 10) {
                        return 'Enter a valid 10 digit phone number';
                      }
                      return null;
                    },
                  ),
                  if (_isSearchingDriver) ...[
                    const SizedBox(height: 10),
                    const LinearProgressIndicator(minHeight: 2),
                  ],
                  if (_matchedDriver != null) ...[
                    const SizedBox(height: 14),
                    DashboardTextField(
                      controller: _searchDriverNameController,
                      label: 'Driver Name',
                      icon: Icons.person_outline_rounded,
                      readOnly: true,
                      validator: (_) => null,
                    ),
                    const SizedBox(height: 8),
                    const EntryStatusText(
                      text: 'Driver is already in records',
                      color: Color(0xFF17A56B),
                    ),
                  ],
                  if (_driverNotFound) ...[
                    const SizedBox(height: 8),
                    const EntryStatusText(
                      text: 'Driver does not exist',
                      color: Color(0xFFE5484D),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: _createNewDriver,
                        icon: const Icon(Icons.person_add_alt_1_rounded),
                        label: const Text('Create New Entry'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFE5484D),
                          side: const BorderSide(color: Color(0xFFE5484D)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (_showEntryForm) ...[
                    const SizedBox(height: 22),
                    _buildEntryFields(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _refreshTemperatureWarning() {
    setState(() {});
  }

  Future<void> _loadMaterials() async {
    try {
      final materials = await MaterialService().getMaterials();
      if (!mounted) {
        return;
      }

      final activeMaterials =
          materials.where((material) => material.isActive).toList();
      final names = activeMaterials.map((material) => material.name).toList();

      setState(() {
        _materials = activeMaterials;
        _cargoTypes
          ..clear()
          ..addAll(names.isEmpty ? _fallbackCargoTypes : names);
        if (!_cargoTypes.contains(_selectedCargoType)) {
          _selectedCargoType = _cargoTypes.first;
        }
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _materials = const [];
        _cargoTypes
          ..clear()
          ..addAll(_fallbackCargoTypes);
        if (!_cargoTypes.contains(_selectedCargoType)) {
          _selectedCargoType = _cargoTypes.first;
        }
      });
      _showAuthMessage(context, _cleanAuthError(error));
    }
  }

  Widget _buildEntryFields() {
    final isExistingDriver = _matchedDriver != null && !_isCreatingNewDriver;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EntrySectionHeader(
          icon: Icons.assignment_outlined,
          title: isExistingDriver ? 'Entry Details' : 'Create New Entry',
          status: isExistingDriver ? 'Existing driver' : 'New driver',
          isFound: isExistingDriver,
        ),
        const SizedBox(height: 12),
        DashboardTextField(
          controller: _phoneController,
          label: 'Driver Phone Number',
          icon: Icons.call_outlined,
          readOnly: isExistingDriver,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (value) {
            final phone = value?.trim() ?? '';
            if (phone.isEmpty) {
              return 'Driver phone number is required';
            }
            if (phone.length < 10) {
              return 'Enter a valid 10 digit phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 14),
        DashboardTextField(
          controller: _driverNameController,
          label: 'Driver Name',
          icon: Icons.person_outline_rounded,
          readOnly: isExistingDriver,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 14),
        DashboardTextField(
          controller: _truckNumberController,
          label: 'Truck Number',
          icon: Icons.local_shipping_outlined,
          textCapitalization: TextCapitalization.characters,
          textInputAction: TextInputAction.next,
          inputFormatters: [
            UpperCaseTextFormatter(),
            LengthLimitingTextInputFormatter(16),
          ],
        ),
        const SizedBox(height: 14),
        DashboardDropdownField(
          value: _selectedCargoType,
          label: 'Material / Cargo Type',
          icon: Icons.inventory_2_outlined,
          items: _cargoTypes,
          onChanged:
              (value) => setState(
                () => _setSelectedCargoType(value ?? _cargoTypes.first),
              ),
          canAddOption: widget.user?.canAddMaterial ?? true,
          onAddOption: _showAddCargoTypeDialog,
        ),
        const SizedBox(height: 14),
        DashboardTextField(
          controller: _temperatureController,
          label: 'Temperature (F)',
          icon: Icons.thermostat_outlined,
          readOnly: true,
          onTap:
              () => _showAuthMessage(
                context,
                'Use Bluetooth thermometer to capture temperature.',
              ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          inputFormatters: [
            DecimalTemperatureFormatter(),
            LengthLimitingTextInputFormatter(5),
          ],
          validator: (value) {
            final temperature = double.tryParse(value?.trim() ?? '');
            if (temperature == null) {
              return 'Please capture temperature using Bluetooth thermometer.';
            }
            if (temperature < 50 || temperature > 120) {
              return 'Enter a valid temperature';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        DriverPhotoCapture(
          photoPath: _driverPhotoPath,
          onCapture: _captureDriverPhoto,
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _openBluetoothThermometer,
          icon: const Icon(Icons.bluetooth_searching_rounded),
          label: const Text('Connect Bluetooth Thermometer'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF1BA7E1),
            side: const BorderSide(color: Color(0xFF1BA7E1)),
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(height: 14),
        DateTimeInfoField(value: _formatDateTime(_entryDateTime)),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton(
            onPressed: _isSubmitting ? null : _submitEntry,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF111827),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            child: Text(_isSubmitting ? 'Submitting...' : 'Submit Entry'),
          ),
        ),
      ],
    );
  }

  void _refreshDriverSearch() {
    final phone = _searchPhoneController.text.trim();
    if (phone.length < 10) {
      setState(() {
        _matchedDriver = null;
        _matchedTruck = null;
        _driverNotFound = false;
        _showEntryForm = false;
        _isCreatingNewDriver = false;
        _isSearchingDriver = false;
        _lastSearchedPhone = null;
        _searchDriverNameController.clear();
      });
      return;
    }

    if (phone == _lastSearchedPhone || _isSearchingDriver) {
      return;
    }

    _searchDriverByPhone(phone);
  }

  Future<void> _searchDriverByPhone(String phone) async {
    setState(() {
      _isSearchingDriver = true;
      _lastSearchedPhone = phone;
      _driverNotFound = false;
      _matchedDriver = null;
      _searchDriverNameController.clear();
    });

    try {
      final result = await DriverService().searchDriverByPhone(phone);
      if (!mounted || _searchPhoneController.text.trim() != phone) {
        return;
      }

      if (result.found && result.driver != null) {
        _applyFoundDriver(result.driver!);
      } else {
        setState(() {
          _matchedDriver = null;
          _driverNotFound = true;
          _showEntryForm = false;
          _isCreatingNewDriver = false;
          _isSearchingDriver = false;
          _clearEntryFields(keepSearchPhone: true);
        });
      }
    } catch (error) {
      if (!mounted || _searchPhoneController.text.trim() != phone) {
        return;
      }

      setState(() {
        _isSearchingDriver = false;
        _lastSearchedPhone = null;
      });
      _showAuthMessage(context, _cleanAuthError(error));
    }
  }

  void _refreshTruckMatch() {
    final match = _findTruckMatch();
    if (match == _matchedTruck) {
      return;
    }
    setState(() => _matchedTruck = match);
  }

  void _applyFoundDriver(Driver driver) {
    setState(() {
      _matchedDriver = driver;
      _driverNotFound = false;
      _showEntryForm = true;
      _isCreatingNewDriver = false;
      _isSearchingDriver = false;
      _searchDriverNameController.text = driver.name;
      _phoneController.text = driver.phone;
      _driverNameController.text = driver.name;
      _truckNumberController.clear();
      _temperatureController.clear();
      _setSelectedCargoType(_cargoTypes.first);
      _driverPhotoPath = driver.latestPhotoUrl;
      _capturedDriverPhotoPath = null;
      _uploadedDriverPhotoKey = driver.latestPhotoKey;
      _matchedTruck = null;
    });
  }

  TruckEntry? _findTruckMatch() {
    final truckNumber = _normalizeTruckNumber(_truckNumberController.text);
    if (truckNumber.length < 6) {
      return null;
    }
    for (final entry in widget.existingEntries) {
      if (_normalizeTruckNumber(entry.truckNumber) == truckNumber) {
        return entry;
      }
    }
    return null;
  }

  void _clearEntryFields({bool keepSearchPhone = false}) {
    _phoneController.text = keepSearchPhone ? _searchPhoneController.text : '';
    _driverNameController.clear();
    _truckNumberController.clear();
    _temperatureController.clear();
    _setSelectedCargoType(_cargoTypes.first);
    _driverPhotoPath = null;
    _capturedDriverPhotoPath = null;
    _uploadedDriverPhotoKey = null;
    _matchedTruck = null;
  }

  void _createNewDriver() {
    setState(() {
      _matchedDriver = null;
      _isCreatingNewDriver = true;
      _showEntryForm = true;
      _driverNotFound = false;
      _clearEntryFields(keepSearchPhone: true);
    });
  }

  Future<void> _captureDriverPhoto() async {
    final photo = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 1200,
    );
    if (!mounted || photo == null) {
      return;
    }
    setState(() {
      _driverPhotoPath = photo.path;
      _capturedDriverPhotoPath = photo.path;
      _uploadedDriverPhotoKey = null;
    });
    _showAuthMessage(context, 'Driver photo captured.');
  }

  Future<void> _openBluetoothThermometer() async {
    final temperature = await showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const BleThermometerSheet(),
    );

    if (!mounted || temperature == null) {
      return;
    }

    final value = temperature.toStringAsFixed(1);
    setState(() => _temperatureController.text = value);
    final normalRangeMessage =
        temperature < 97 || temperature > 99
            ? ' This is outside the normal range.'
            : '';
    _showAuthMessage(
      context,
      'Temperature captured: $value°F.$normalRangeMessage',
    );
  }

  Future<void> _showAddCargoTypeDialog() async {
    if (widget.user?.canAddMaterial == false) {
      _showAuthMessage(
        context,
        'Only supervisors/admins can add new materials.',
      );
      return;
    }

    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    var isSaving = false;

    final newOption = await showDialog<MaterialOption>(
      context: context,
      builder:
          (dialogContext) => StatefulBuilder(
            builder: (dialogContext, setDialogState) {
              Future<void> saveMaterial() async {
                if (!(formKey.currentState?.validate() ?? false)) {
                  return;
                }

                setDialogState(() => isSaving = true);
                try {
                  final material = await MaterialService().addMaterial(
                    controller.text.trim(),
                  );
                  if (!dialogContext.mounted) {
                    return;
                  }
                  Navigator.of(dialogContext).pop(material);
                } catch (error) {
                  if (!dialogContext.mounted) {
                    return;
                  }
                  setDialogState(() => isSaving = false);
                  _showAuthMessage(dialogContext, _cleanAuthError(error));
                }
              }

              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: const Text(
                  'Add Material Type',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                content: Form(
                  key: formKey,
                  child: TextFormField(
                    controller: controller,
                    textCapitalization: TextCapitalization.words,
                    autofocus: true,
                    decoration: _dashboardInputDecoration(
                      'Material / Cargo Type',
                      Icons.inventory_2_outlined,
                    ),
                    validator: (value) {
                      final option = value?.trim() ?? '';
                      if (option.isEmpty) {
                        return 'Material type is required';
                      }
                      final exists = _cargoTypes.any(
                        (item) => item.toLowerCase() == option.toLowerCase(),
                      );
                      if (exists) {
                        return 'This material type already exists';
                      }
                      return null;
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed:
                        isSaving
                            ? null
                            : () => Navigator.of(dialogContext).pop(),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: isSaving ? null : saveMaterial,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF111827),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(isSaving ? 'Saving...' : 'Save'),
                  ),
                ],
              );
            },
          ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => controller.dispose());
    if (!mounted || newOption == null) {
      return;
    }

    setState(() {
      _materials = [
        ..._materials.where(
          (material) =>
              material.name.toLowerCase() != newOption.name.toLowerCase(),
        ),
        newOption,
      ];
      if (!_cargoTypes.any(
        (item) => item.toLowerCase() == newOption.name.toLowerCase(),
      )) {
        _cargoTypes.add(newOption.name);
      }
      _setSelectedCargoType(newOption.name);
    });
    _showAuthMessage(context, 'Material saved successfully.');
  }

  void _setSelectedCargoType(String value) {
    _selectedCargoType = value;
  }

  Future<void> _submitEntry() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      var photoKey = _uploadedDriverPhotoKey;
      final capturedPath = _capturedDriverPhotoPath;
      if (capturedPath != null && photoKey == null) {
        final uploadedPhoto = await UploadService().uploadDriverPhoto(
          capturedPath,
        );
        photoKey = uploadedPhoto.s3Key;
        _uploadedDriverPhotoKey = photoKey;
      }

      final result = await EntryService().createEntry(
        driverPhone: _phoneController.text.trim(),
        driverName: _driverNameController.text.trim(),
        truckNumber: _truckNumberController.text.trim().toUpperCase(),
        materialName: _selectedCargoType,
        temperatureFahrenheit: _temperature!,
        driverPhotoKey: photoKey,
      );
      if (!mounted) {
        return;
      }

      widget.onSubmit(result.entry);
      _formKey.currentState?.reset();
      _searchPhoneController.clear();
      _searchDriverNameController.clear();
      _clearEntryFields();
      setState(() {
        _lastSubmissionResult = result;
        _driverNotFound = false;
        _showEntryForm = false;
        _isCreatingNewDriver = false;
        _matchedDriver = null;
        _isSubmitting = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _isSubmitting = false);
      final message = _cleanAuthError(error);
      _showAuthMessage(
        context,
        message.toLowerCase().contains('photo')
            ? 'Photo upload failed. Please try again.'
            : message,
      );
    }
  }

  void _returnToEntryForm() {
    setState(() => _lastSubmissionResult = null);
  }
}

class EntryApprovalResultScreen extends StatelessWidget {
  const EntryApprovalResultScreen({
    required this.approval,
    required this.temperature,
    required this.onLogout,
    required this.user,
    required this.onGoBack,
    super.key,
  });

  final ApprovalResult approval;
  final double temperature;
  final VoidCallback onLogout;
  final AppUser? user;
  final VoidCallback onGoBack;

  @override
  Widget build(BuildContext context) {
    final isApproved = approval.isApproved;
    final color =
        isApproved ? const Color(0xFF17A56B) : const Color(0xFFE5484D);
    final softColor =
        isApproved ? const Color(0xFFEAF8F1) : const Color(0xFFFFEBEE);
    final icon = isApproved ? Icons.check_circle_rounded : Icons.cancel_rounded;
    final title =
        approval.title.isNotEmpty
            ? approval.title
            : isApproved
            ? 'Approved'
            : 'Not Approved';
    final message =
        approval.message.isNotEmpty
            ? approval.message
            : isApproved
            ? 'Temperature is within the healthy adult range.'
            : 'Temperature is outside the healthy adult range.';

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              children: [
                DashboardHeader(onLogout: onLogout, user: user),
                const Spacer(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withValues(alpha: 0.28)),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.08),
                        blurRadius: 22,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 104,
                        width: 104,
                        decoration: BoxDecoration(
                          color: softColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: color, size: 68),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: color,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF515A68),
                          fontSize: 14,
                          height: 1.45,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${temperature.toStringAsFixed(1)} F'
                        '${approval.normalRange.isEmpty ? '' : ' • ${approval.normalRange}'}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF7D8491),
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 26),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: FilledButton.icon(
                          onPressed: onGoBack,
                          icon: const Icon(Icons.arrow_back_rounded),
                          label: const Text('Go Back'),
                          style: FilledButton.styleFrom(
                            backgroundColor: color,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
