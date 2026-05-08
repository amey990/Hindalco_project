import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const HindalcoApp());
}

class HindalcoApp extends StatelessWidget {
  const HindalcoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hindalco',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D47A1)),
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Login to Access Your',
      highlightedTitle: 'Hindalco Account',
      imageHeight: 326,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const AuthTextField(
              hintText: 'Enter your email',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            AuthTextField(
              hintText: 'Enter your password',
              icon: Icons.lock_outline_rounded,
              obscureText: _obscurePassword,
              suffixIcon:
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
              onSuffixPressed:
                  () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged:
                      (value) => setState(() => _rememberMe = value ?? false),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: const BorderSide(color: Color(0xFFB8C0CC)),
                ),
                const Text(
                  'Remember me',
                  style: TextStyle(color: Color(0xFF7D8491), fontSize: 13),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _push(context, const ForgotPasswordPage()),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 36),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            PrimaryAuthButton(
              label: 'Login',
              onPressed: () => _submit(context),
            ),
            const SizedBox(height: 22),
            const AuthDivider(label: 'Or login with'),
            const SizedBox(height: 18),
            const SocialButtons(),
            const SizedBox(height: 24),
            AuthFooterAction(
              text: 'Don\'t have an account?',
              actionText: 'Create an account',
              onTap: () => _push(context, const SignUpPage()),
            ),
          ],
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const HomeDashboardPage()),
    );
  }
}

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({super.key});

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  static const _blue = Color(0xFF1BA7E1);
  int _selectedIndex = 0;

  final List<TruckEntry> _recentEntries = [
    TruckEntry(
      driverName: 'Ramesh Patil',
      driverPhone: '9876543210',
      truckNumber: 'MH 04 JK 2198',
      materialType: 'Raw Material',
      temperature: 98.4,
      entryDateTime: DateTime(2026, 5, 8, 9, 42),
    ),
    TruckEntry(
      driverName: 'Ajay Singh',
      driverPhone: '9876501122',
      truckNumber: 'GJ 18 BT 4421',
      materialType: 'Finished Goods',
      temperature: 99.1,
      entryDateTime: DateTime(2026, 5, 8, 9, 35),
    ),
    TruckEntry(
      driverName: 'Suresh Yadav',
      driverPhone: '9988776655',
      truckNumber: 'MH 12 AQ 7720',
      materialType: 'Fuel',
      temperature: 101.2,
      entryDateTime: DateTime(2026, 5, 8, 9, 21),
    ),
    TruckEntry(
      driverName: 'Iqbal Khan',
      driverPhone: '9123456780',
      truckNumber: 'RJ 27 TC 1187',
      materialType: 'Waste',
      temperature: 98.7,
      entryDateTime: DateTime(2026, 5, 8, 9, 3),
    ),
    TruckEntry(
      driverName: 'Mahesh Jadhav',
      driverPhone: '9001122334',
      truckNumber: 'MH 46 CD 9051',
      materialType: 'Raw Material',
      temperature: 97.9,
      entryDateTime: DateTime(2026, 5, 8, 8, 51),
    ),
    TruckEntry(
      driverName: 'Vikram Rana',
      driverPhone: '9556677880',
      truckNumber: 'GJ 05 LM 3320',
      materialType: 'Other',
      temperature: 100.8,
      entryDateTime: DateTime(2026, 5, 7, 17, 36),
    ),
    TruckEntry(
      driverName: 'Deepak More',
      driverPhone: '9445566778',
      truckNumber: 'MH 14 HX 6742',
      materialType: 'Finished Goods',
      temperature: 98.1,
      entryDateTime: DateTime(2026, 5, 7, 16, 18),
    ),
    TruckEntry(
      driverName: 'Nitin Pawar',
      driverPhone: '9334455667',
      truckNumber: 'KA 22 TR 8064',
      materialType: 'Fuel',
      temperature: 99.4,
      entryDateTime: DateTime(2026, 5, 6, 8, 2),
    ),
    TruckEntry(
      driverName: 'Salim Shaikh',
      driverPhone: '9223344556',
      truckNumber: 'MH 03 BN 5439',
      materialType: 'Waste',
      temperature: 98.9,
      entryDateTime: DateTime(2026, 5, 5, 7, 48),
    ),
    TruckEntry(
      driverName: 'Harish Verma',
      driverPhone: '9112233445',
      truckNumber: 'MP 09 KD 2290',
      materialType: 'Raw Material',
      temperature: 97.8,
      entryDateTime: DateTime(2026, 4, 30, 7, 31),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final normalCount = _recentEntries.where((entry) => entry.isNormal).length;
    final highCount = _recentEntries.length - normalCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _DashboardHome(
              recentEntries: _recentEntries.take(10).toList(),
              totalEntries: _recentEntries.length,
              normalTemperature: normalCount,
              highTemperature: highCount,
              trucksInside: 6,
              onNewEntry: () => setState(() => _selectedIndex = 1),
              onLogout: _logout,
            ),
            NewTruckEntryPage(onLogout: _logout, onSubmit: _addTruckEntry),
            RecordsPage(entries: _recentEntries, onLogout: _logout),
            ProfilePage(onLogout: _logout),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected:
            (index) => setState(() => _selectedIndex = index),
        backgroundColor: Colors.white,
        indicatorColor: _blue.withValues(alpha: 0.14),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: _blue),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline_rounded),
            selectedIcon: Icon(Icons.add_circle_rounded, color: _blue),
            label: 'New Entry',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded, color: _blue),
            label: 'Records',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: _blue),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _logout() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const LoginPage()),
    );
  }

  void _addTruckEntry(TruckEntry entry) {
    setState(() {
      _recentEntries.insert(0, entry);
      _selectedIndex = 0;
    });
    _showAuthMessage(context, 'Truck entry submitted successfully.');
  }
}

class _DashboardHome extends StatelessWidget {
  const _DashboardHome({
    required this.recentEntries,
    required this.totalEntries,
    required this.normalTemperature,
    required this.highTemperature,
    required this.trucksInside,
    required this.onNewEntry,
    required this.onLogout,
  });

  final List<TruckEntry> recentEntries;
  final int totalEntries;
  final int normalTemperature;
  final int highTemperature;
  final int trucksInside;
  final VoidCallback onNewEntry;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DashboardHeader(onLogout: onLogout),
                const SizedBox(height: 22),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.48,
                  children: [
                    SummaryCard(
                      title: 'Total Entries Today',
                      value: '$totalEntries',
                      icon: Icons.local_shipping_outlined,
                      accentColor: const Color(0xFF1BA7E1),
                    ),
                    SummaryCard(
                      title: 'Normal Temperature',
                      value: '$normalTemperature',
                      icon: Icons.thermostat_outlined,
                      accentColor: const Color(0xFF17A56B),
                    ),
                    SummaryCard(
                      title: 'High Temperature',
                      value: '$highTemperature',
                      icon: Icons.warning_amber_rounded,
                      accentColor: const Color(0xFFE5484D),
                    ),
                    SummaryCard(
                      title: 'Trucks Inside',
                      value: '$trucksInside',
                      icon: Icons.warehouse_outlined,
                      accentColor: const Color(0xFF111827),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: FilledButton.icon(
                    onPressed: onNewEntry,
                    icon: const Icon(Icons.add_rounded, size: 26),
                    label: const Text('New Entry'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF111827),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                const Text(
                  'Recent Entries',
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          sliver: SliverList.separated(
            itemCount: recentEntries.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder:
                (context, index) =>
                    RecentEntryTile(entry: recentEntries[index]),
          ),
        ),
      ],
    );
  }
}

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({required this.onLogout, super.key});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 54,
          width: 54,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Image.asset('assets/splash_logo.png', fit: BoxFit.contain),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hindalco Entry',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Supervisor: Amit Sharma',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Color(0xFF7D8491), fontSize: 13),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          onPressed: onLogout,
          icon: const Icon(Icons.logout_rounded),
          color: const Color(0xFF111827),
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFFEAF6FC),
            fixedSize: const Size(46, 46),
          ),
        ),
      ],
    );
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
    super.key,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE7EAF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accentColor, size: 22),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF515A68),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class RecentEntryTile extends StatelessWidget {
  const RecentEntryTile({required this.entry, super.key});

  final TruckEntry entry;

  @override
  Widget build(BuildContext context) {
    final temperatureColor =
        entry.isNormal ? const Color(0xFF17A56B) : const Color(0xFFE5484D);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE7EAF0)),
      ),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF6FC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              color: Color(0xFF1BA7E1),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.driverName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  entry.truckNumber,
                  style: const TextStyle(
                    color: Color(0xFF7D8491),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.temperature.toStringAsFixed(1)} F',
                style: TextStyle(
                  color: temperatureColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                entry.entryTime,
                style: const TextStyle(color: Color(0xFF9AA2AF), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NewTruckEntryPage extends StatefulWidget {
  const NewTruckEntryPage({
    required this.onLogout,
    required this.onSubmit,
    super.key,
  });

  final VoidCallback onLogout;
  final ValueChanged<TruckEntry> onSubmit;

  @override
  State<NewTruckEntryPage> createState() => _NewTruckEntryPageState();
}

class _NewTruckEntryPageState extends State<NewTruckEntryPage> {
  static const _cargoTypes = [
    'Raw Material',
    'Finished Goods',
    'Fuel',
    'Waste',
    'Other',
  ];

  final _formKey = GlobalKey<FormState>();
  final _driverNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _truckNumberController = TextEditingController();
  final _temperatureController = TextEditingController();
  late final DateTime _entryDateTime;
  String _selectedCargoType = _cargoTypes.first;

  double? get _temperature =>
      double.tryParse(_temperatureController.text.trim());

  bool get _hasHighTemperature =>
      _temperature != null && _temperature! > TruckEntry.highTemperatureLimit;

  @override
  void initState() {
    super.initState();
    _entryDateTime = DateTime.now();
    _temperatureController.addListener(_refreshTemperatureWarning);
  }

  @override
  void dispose() {
    _driverNameController.dispose();
    _phoneController.dispose();
    _truckNumberController.dispose();
    _temperatureController
      ..removeListener(_refreshTemperatureWarning)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  DashboardHeader(onLogout: widget.onLogout),
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
                    'Log vehicle, driver, cargo, and gate temperature details.',
                    style: TextStyle(
                      color: Color(0xFF7D8491),
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 22),
                  DashboardTextField(
                    controller: _driverNameController,
                    label: 'Driver Name',
                    icon: Icons.person_outline_rounded,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 14),
                  DashboardTextField(
                    controller: _phoneController,
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
                    items: _cargoTypes,
                    onChanged:
                        (value) => setState(
                          () => _selectedCargoType = value ?? _cargoTypes.first,
                        ),
                  ),
                  const SizedBox(height: 14),
                  DashboardTextField(
                    controller: _temperatureController,
                    label: 'Temperature (F)',
                    icon: Icons.thermostat_outlined,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      DecimalTemperatureFormatter(),
                      LengthLimitingTextInputFormatter(5),
                    ],
                    validator: (value) {
                      final temperature = double.tryParse(value?.trim() ?? '');
                      if (temperature == null) {
                        return 'Temperature is required';
                      }
                      if (temperature < 90 || temperature > 110) {
                        return 'Enter a valid temperature';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed:
                        () => _showAuthMessage(
                          context,
                          'Bluetooth thermometer integration coming soon.',
                        ),
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
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child:
                        _hasHighTemperature
                            ? const Padding(
                              key: ValueKey('high-temperature-warning'),
                              padding: EdgeInsets.only(top: 14),
                              child: HighTemperatureBanner(),
                            )
                            : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 14),
                  DateTimeInfoField(value: _formatDateTime(_entryDateTime)),
                  const Spacer(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: _submitEntry,
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
                      child: const Text('Submit Entry'),
                    ),
                  ),
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

  void _submitEntry() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    widget.onSubmit(
      TruckEntry(
        driverName: _driverNameController.text.trim(),
        driverPhone: _phoneController.text.trim(),
        truckNumber: _truckNumberController.text.trim().toUpperCase(),
        materialType: _selectedCargoType,
        temperature: _temperature!,
        entryDateTime: _entryDateTime,
      ),
    );
    _formKey.currentState?.reset();
    _driverNameController.clear();
    _phoneController.clear();
    _truckNumberController.clear();
    _temperatureController.clear();
    setState(() => _selectedCargoType = _cargoTypes.first);
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

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
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
      decoration: _dashboardInputDecoration(label, icon),
    );
  }
}

class DashboardDropdownField extends StatelessWidget {
  const DashboardDropdownField({
    required this.value,
    required this.label,
    required this.items,
    required this.onChanged,
    super.key,
  });

  final String value;
  final String label;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items:
          items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
      onChanged: onChanged,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      decoration: _dashboardInputDecoration(label, Icons.inventory_2_outlined),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
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

enum RecordsFilter { all, today, week, highTemp }

class RecordsPage extends StatefulWidget {
  const RecordsPage({required this.entries, required this.onLogout, super.key});

  final List<TruckEntry> entries;
  final VoidCallback onLogout;

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  final _searchController = TextEditingController();
  RecordsFilter _selectedFilter = RecordsFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TruckEntry> get _filteredEntries {
    final query = _searchController.text.trim().toLowerCase();
    return widget.entries.where((entry) {
      final matchesSearch =
          query.isEmpty ||
          entry.driverName.toLowerCase().contains(query) ||
          entry.truckNumber.toLowerCase().contains(query);
      return matchesSearch && _matchesFilter(entry);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final entries = _filteredEntries;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DashboardHeader(onLogout: widget.onLogout),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Records',
                        style: TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed:
                          () => _showAuthMessage(
                            context,
                            'Export records UI is ready for integration.',
                          ),
                      icon: const Icon(Icons.download_rounded),
                      tooltip: 'Download records',
                      color: const Color(0xFF1BA7E1),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFEAF6FC),
                        fixedSize: const Size(46, 46),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  textInputAction: TextInputAction.search,
                  decoration: _dashboardInputDecoration(
                    'Search driver or truck number',
                    Icons.search_rounded,
                  ),
                ),
                const SizedBox(height: 14),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      RecordsFilterChip(
                        label: 'All',
                        selected: _selectedFilter == RecordsFilter.all,
                        onTap:
                            () => setState(
                              () => _selectedFilter = RecordsFilter.all,
                            ),
                      ),
                      RecordsFilterChip(
                        label: 'Today',
                        selected: _selectedFilter == RecordsFilter.today,
                        onTap:
                            () => setState(
                              () => _selectedFilter = RecordsFilter.today,
                            ),
                      ),
                      RecordsFilterChip(
                        label: 'This Week',
                        selected: _selectedFilter == RecordsFilter.week,
                        onTap:
                            () => setState(
                              () => _selectedFilter = RecordsFilter.week,
                            ),
                      ),
                      RecordsFilterChip(
                        label: 'High Temp Only',
                        selected: _selectedFilter == RecordsFilter.highTemp,
                        onTap:
                            () => setState(
                              () => _selectedFilter = RecordsFilter.highTemp,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  '${entries.length} record${entries.length == 1 ? '' : 's'} found',
                  style: const TextStyle(
                    color: Color(0xFF7D8491),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (entries.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyRecordsState(),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: SliverList.separated(
              itemCount: entries.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder:
                  (context, index) => RecordCard(
                    entry: entries[index],
                    onTap: () => _openRecordDetail(entries[index]),
                  ),
            ),
          ),
      ],
    );
  }

  bool _matchesFilter(TruckEntry entry) {
    final now = DateTime.now();
    return switch (_selectedFilter) {
      RecordsFilter.all => true,
      RecordsFilter.today => _isSameDate(entry.entryDateTime, now),
      RecordsFilter.week => entry.entryDateTime.isAfter(
        now.subtract(const Duration(days: 7)),
      ),
      RecordsFilter.highTemp => !entry.isNormal,
    };
  }

  void _openRecordDetail(TruckEntry entry) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => RecordDetailPage(entry: entry)),
    );
  }
}

class RecordsFilterChip extends StatelessWidget {
  const RecordsFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        selectedColor: const Color(0xFF111827),
        backgroundColor: Colors.white,
        side: BorderSide(
          color: selected ? const Color(0xFF111827) : const Color(0xFFE5E7EB),
        ),
        labelStyle: TextStyle(
          color: selected ? Colors.white : const Color(0xFF515A68),
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class RecordCard extends StatelessWidget {
  const RecordCard({required this.entry, required this.onTap, super.key});

  final TruckEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final temperatureColor =
        entry.isNormal ? const Color(0xFF17A56B) : const Color(0xFFE5484D);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE7EAF0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.driverName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    '${entry.temperature.toStringAsFixed(1)} F',
                    style: TextStyle(
                      color: temperatureColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: RecordMetaText(value: entry.truckNumber)),
                  const SizedBox(width: 10),
                  RecordMetaText(value: entry.materialType),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    color: Color(0xFF9AA2AF),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      entry.dateTimeLabel,
                      style: const TextStyle(
                        color: Color(0xFF7D8491),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF9AA2AF),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecordMetaText extends StatelessWidget {
  const RecordMetaText({required this.value, super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Color(0xFF515A68),
        fontSize: 12,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class EmptyRecordsState extends StatelessWidget {
  const EmptyRecordsState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.search_off_rounded, color: Color(0xFF9AA2AF), size: 48),
          SizedBox(height: 12),
          Text(
            'No matching records',
            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Try changing the search or selected filter.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF7D8491), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class RecordDetailPage extends StatelessWidget {
  const RecordDetailPage({required this.entry, super.key});

  final TruckEntry entry;

  @override
  Widget build(BuildContext context) {
    final temperatureColor =
        entry.isNormal ? const Color(0xFF17A56B) : const Color(0xFFE5484D);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.chevron_left_rounded),
                    color: const Color(0xFF111827),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: const Size(46, 46),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Record Details',
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE7EAF0)),
                ),
                child: Column(
                  children: [
                    DetailRow(label: 'Driver Name', value: entry.driverName),
                    DetailRow(label: 'Driver Phone', value: entry.driverPhone),
                    DetailRow(label: 'Truck Number', value: entry.truckNumber),
                    DetailRow(
                      label: 'Material Type',
                      value: entry.materialType,
                    ),
                    DetailRow(
                      label: 'Temperature',
                      value: '${entry.temperature.toStringAsFixed(1)} F',
                      valueColor: temperatureColor,
                    ),
                    DetailRow(
                      label: 'Temperature Status',
                      value: entry.isNormal ? 'Normal' : 'High Temperature',
                      valueColor: temperatureColor,
                    ),
                    DetailRow(
                      label: 'Date & Time',
                      value: entry.dateTimeLabel,
                      showDivider: false,
                    ),
                  ],
                ),
              ),
              if (!entry.isNormal) ...[
                const SizedBox(height: 16),
                const HighTemperatureBanner(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  const DetailRow({
    required this.label,
    required this.value,
    this.valueColor = const Color(0xFF111827),
    this.showDivider = true,
    super.key,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF7D8491),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: valueColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        if (showDivider)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: Color(0xFFE7EAF0)),
          ),
      ],
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({required this.onLogout, super.key});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              children: [
                DashboardHeader(onLogout: onLogout),
                const SizedBox(height: 26),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 24, 18, 22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE7EAF0)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 82,
                        width: 82,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEAF6FC),
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          'AS',
                          style: TextStyle(
                            color: Color(0xFF1BA7E1),
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Amit Sharma',
                        style: TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'amit.sharma@hindalco.com',
                        style: TextStyle(
                          color: Color(0xFF7D8491),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Row(
                        children: [
                          Expanded(
                            child: ProfileInfoPill(
                              label: 'Role',
                              value: 'Supervisor',
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ProfileInfoPill(
                              label: 'Plant Name',
                              value: 'Hindalco',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE7EAF0)),
                  ),
                  child: Column(
                    children: [
                      ProfileOptionTile(
                        icon: Icons.lock_reset_rounded,
                        title: 'Change Password',
                        onTap:
                            () => _showAuthMessage(
                              context,
                              'Change password UI is ready for integration.',
                            ),
                      ),
                      const ProfileOptionDivider(),
                      ProfileOptionTile(
                        icon: Icons.notifications_outlined,
                        title: 'Notification Settings',
                        onTap:
                            () => _showAuthMessage(
                              context,
                              'Notification settings UI is ready for integration.',
                            ),
                      ),
                      const ProfileOptionDivider(),
                      ProfileOptionTile(
                        icon: Icons.info_outline_rounded,
                        title: 'About App',
                        onTap:
                            () => _showAuthMessage(
                              context,
                              'Hindalco Truck Entry App v1.0.0',
                            ),
                      ),
                      const ProfileOptionDivider(),
                      ProfileOptionTile(
                        icon: Icons.logout_rounded,
                        title: 'Logout',
                        isDestructive: true,
                        onTap: onLogout,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const SizedBox(height: 24),
                const Text(
                  'App Version 1.0.0',
                  style: TextStyle(
                    color: Color(0xFF9AA2AF),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileInfoPill extends StatelessWidget {
  const ProfileInfoPill({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE7EAF0)),
      ),
      child: Column(
        children: [
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF7D8491),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileOptionTile extends StatelessWidget {
  const ProfileOptionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color =
        isDestructive ? const Color(0xFFE5484D) : const Color(0xFF111827);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
          child: Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color:
                      isDestructive
                          ? const Color(0xFFFFEBEE)
                          : const Color(0xFFEAF6FC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color:
                      isDestructive
                          ? const Color(0xFFE5484D)
                          : const Color(0xFF1BA7E1),
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: color.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileOptionDivider extends StatelessWidget {
  const ProfileOptionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 64),
      child: Divider(height: 1, color: Color(0xFFE7EAF0)),
    );
  }
}

class TruckEntry {
  static const highTemperatureLimit = 99.5;

  const TruckEntry({
    required this.driverName,
    required this.driverPhone,
    required this.truckNumber,
    required this.materialType,
    required this.temperature,
    required this.entryDateTime,
  });

  final String driverName;
  final String driverPhone;
  final String truckNumber;
  final String materialType;
  final double temperature;
  final DateTime entryDateTime;

  bool get isNormal => temperature <= highTemperatureLimit;

  String get entryTime => _formatTime(entryDateTime);

  String get dateTimeLabel => _formatDateTime(entryDateTime);
}

InputDecoration _dashboardInputDecoration(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Color(0xFF7D8491), fontSize: 13),
    prefixIcon: Icon(icon, color: const Color(0xFF1BA7E1), size: 21),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF1BA7E1), width: 1.4),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFE5484D)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFE5484D), width: 1.4),
    ),
  );
}

String _formatDateTime(DateTime dateTime) {
  final date = '${_twoDigits(dateTime.day)}/${_twoDigits(dateTime.month)}';
  final year = dateTime.year;
  return '$date/$year, ${_formatTime(dateTime)}';
}

String _formatTime(DateTime dateTime) {
  final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
  final minute = _twoDigits(dateTime.minute);
  final period = dateTime.hour >= 12 ? 'PM' : 'AM';
  return '${_twoDigits(hour)}:$minute $period';
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');

bool _isSameDate(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

class DecimalTemperatureFormatter extends TextInputFormatter {
  final RegExp _pattern = RegExp(r'^\d{0,3}(\.\d?)?$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty || _pattern.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Sign Up to Access',
      highlightedTitle: 'Hindalco',
      imageHeight: 246,
      imagePath: 'assets/industry.jpg',
      showBackButton: true,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const AuthTextField(
              hintText: 'Enter your name',
              icon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 12),
            const AuthTextField(
              hintText: 'Enter your email',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            AuthTextField(
              hintText: 'Enter your password',
              icon: Icons.lock_outline_rounded,
              obscureText: _obscurePassword,
              suffixIcon:
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
              onSuffixPressed:
                  () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            const SizedBox(height: 12),
            AuthTextField(
              hintText: 'Confirm password',
              icon: Icons.lock_outline_rounded,
              obscureText: _obscureConfirmPassword,
              suffixIcon:
                  _obscureConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
              onSuffixPressed:
                  () => setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged:
                      (value) => setState(() => _rememberMe = value ?? false),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: const BorderSide(color: Color(0xFFB8C0CC)),
                ),
                const Text(
                  'Remember me',
                  style: TextStyle(color: Color(0xFF7D8491), fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 18),
            PrimaryAuthButton(
              label: 'Sign Up',
              onPressed: () => _submit(context),
            ),
            const SizedBox(height: 22),
            AuthFooterAction(
              text: 'Already have an account?',
              actionText: 'Login',
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      _showAuthMessage(context, 'Signup flow is ready for API integration.');
    }
  }
}

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return AuthScaffold(
      title: 'Forgot Password? Reset',
      highlightedTitle: 'Your Access Here',
      imageHeight: 370,
      imagePath: 'assets/industry2.jpg',
      showBackButton: true,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const AuthTextField(
              hintText: 'Enter your email',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            PrimaryAuthButton(
              label: 'Submit',
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  _push(context, const OtpVerificationPage());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = List.generate(4, (_) => TextEditingController());
  final _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Verify Your',
      highlightedTitle: 'Reset Code',
      imageHeight: 330,
      imagePath: 'assets/industry2.jpg',
      showBackButton: true,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text(
              'Enter the 4-digit code sent to your registered email.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF7D8491),
                fontSize: 13,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                4,
                (index) => OtpDigitField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  onChanged: (value) => _moveOtpFocus(index, value),
                ),
              ),
            ),
            const SizedBox(height: 18),
            TextButton(
              onPressed:
                  () => _showAuthMessage(context, 'A new OTP has been sent.'),
              child: const Text(
                'Resend code',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 18),
            PrimaryAuthButton(
              label: 'Verify',
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _push(context, const ResetPasswordPage());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _moveOtpFocus(int index, String value) {
    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }
}

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Create New',
      highlightedTitle: 'Password',
      imageHeight: 330,
      imagePath: 'assets/industry2.jpg',
      showBackButton: true,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AuthTextField(
              hintText: 'Enter new password',
              icon: Icons.lock_outline_rounded,
              controller: _passwordController,
              obscureText: _obscurePassword,
              suffixIcon:
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
              onSuffixPressed:
                  () => setState(() => _obscurePassword = !_obscurePassword),
              validator: _validatePassword,
            ),
            const SizedBox(height: 14),
            AuthTextField(
              hintText: 'Confirm new password',
              icon: Icons.lock_outline_rounded,
              obscureText: _obscureConfirmPassword,
              suffixIcon:
                  _obscureConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
              onSuffixPressed:
                  () => setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                  ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Confirm password is required';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            PrimaryAuthButton(
              label: 'Reset Password',
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final messenger = ScaffoldMessenger.of(context);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  messenger
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Password reset successfully. Please login.',
                        ),
                      ),
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'New password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }
}

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    required this.title,
    required this.highlightedTitle,
    required this.child,
    required this.imageHeight,
    this.imagePath = 'assets/login_page_img.jpg',
    this.showBackButton = false,
    super.key,
  });

  final String title;
  final String highlightedTitle;
  final Widget child;
  final double imageHeight;
  final String imagePath;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ClipPath(
                          clipper: BottomArcClipper(),
                          child: SizedBox(
                            height: imageHeight,
                            width: double.infinity,
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: IgnorePointer(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.white.withValues(alpha: 0.06),
                                    Colors.white.withValues(alpha: 0.18),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (showBackButton)
                          Positioned(
                            top: MediaQuery.paddingOf(context).top + 16,
                            left: 22,
                            child: Material(
                              color: Colors.white,
                              shape: const CircleBorder(),
                              elevation: 1,
                              child: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.chevron_left_rounded),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 14, 28, 24),
                      child: Column(
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF121827),
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              height: 1.18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            highlightedTitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF1BA7E1),
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              height: 1.18,
                            ),
                          ),
                          const SizedBox(height: 28),
                          child,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class BottomArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height - 34)
      ..quadraticBezierTo(
        size.width / 2,
        size.height + 30,
        size.width,
        size.height - 34,
      )
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    required this.hintText,
    required this.icon,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.onSuffixPressed,
    this.validator,
    super.key,
  });

  final String hintText;
  final IconData icon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixPressed;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator:
          validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return hintText
                  .replaceFirst('Enter your ', '')
                  .capitalizeRequired();
            }
            return null;
          },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF9AA2AF), fontSize: 13),
        prefixIcon: Icon(icon, color: const Color(0xFF9AA2AF), size: 20),
        suffixIcon:
            suffixIcon == null
                ? null
                : IconButton(
                  onPressed: onSuffixPressed,
                  icon: Icon(
                    suffixIcon,
                    color: const Color(0xFF9AA2AF),
                    size: 20,
                  ),
                ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26),
          borderSide: const BorderSide(color: Color(0xFF1BA7E1), width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26),
          borderSide: const BorderSide(color: Color(0xFFE5484D)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26),
          borderSide: const BorderSide(color: Color(0xFFE5484D), width: 1.4),
        ),
      ),
    );
  }
}

class OtpDigitField extends StatelessWidget {
  const OtpDigitField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      height: 58,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '';
          }
          return null;
        },
        onChanged: onChanged,
        decoration: InputDecoration(
          counterText: '',
          errorStyle: const TextStyle(height: 0, fontSize: 0),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF1BA7E1), width: 1.4),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE5484D)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE5484D), width: 1.4),
          ),
        ),
      ),
    );
  }
}

class PrimaryAuthButton extends StatelessWidget {
  const PrimaryAuthButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF111827),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class AuthDivider extends StatelessWidget {
  const AuthDivider({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFE7EAF0))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFFA1A8B3), fontSize: 12),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE7EAF0))),
      ],
    );
  }
}

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return const SocialButton(label: 'Google');
  }
}

class SocialButton extends StatelessWidget {
  const SocialButton({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _showAuthMessage(context, '$label auth coming soon.'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF111827),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(vertical: 13),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/google.png',
            height: 20,
            width: 20,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 9),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthFooterAction extends StatelessWidget {
  const AuthFooterAction({
    required this.text,
    required this.actionText,
    required this.onTap,
    super.key,
  });

  final String text;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '$text ',
          style: const TextStyle(color: Color(0xFF9097A3), fontSize: 12),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

extension RequiredMessage on String {
  String capitalizeRequired() {
    if (isEmpty) {
      return 'This field is required';
    }
    return '${this[0].toUpperCase()}${substring(1)} is required';
  }
}

void _push(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
}

void _showAuthMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
