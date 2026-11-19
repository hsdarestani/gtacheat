import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

const bg = Color(0xFF110E19);
const surface = Color(0xFF271D30);
const edge = Color(0xFF75536B);
const coral = Color(0xFFFFBA96);
const pink = Color(0xFFFF8CB8);
const mint = Color(0xFFA6E6D0);
const muted = Color(0xFFBDA8BC);
const groups = ['Alle', 'Spieler', 'Kampf', 'Fahrzeuge', 'Umwelt', 'Bildfilter'];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ViceCodes());
}

class Cheat {
  final String id, category, title, description, unlock, sequence;
  const Cheat(this.id, this.category, this.title, this.description, this.unlock, this.sequence);
  factory Cheat.fromJson(Map<String, dynamic> x) => Cheat(
    x['id'] as String, x['category'] as String, x['title'] as String,
    x['description'] as String, x['unlock'] as String, x['sequence'] as String,
  );
  String get code => sequence.split(' ').map((e) => const {
    'U': 'OBEN', 'D': 'UNTEN', 'L': 'LINKS', 'R': 'RECHTS'
  }[e] ?? e).join(' · ');
}

class ViceCodes extends StatelessWidget {
  const ViceCodes({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Vice Codes',
    theme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(primary: coral, secondary: pink, surface: surface),
    ),
    home: const MainScreen(),
  );
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Cheat> data = [];
  Set<String> saved = {}, done = {};
  SharedPreferences? storage;
  final searchController = TextEditingController();
  String query = '';
  int tab = 0, group = 0, console = 0;
  bool loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final content = await rootBundle.loadString('assets/cheats.json');
    final parsed = jsonDecode(content) as Map<String, dynamic>;
    final cheats = (parsed['cheats'] as List).map((x) => Cheat.fromJson(x as Map<String, dynamic>)).toList();
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      data = cheats;
      storage = prefs;
      saved = (prefs.getStringList('saved-v1') ?? []).toSet();
      done = (prefs.getStringList('done-v1') ?? []).toSet();
      loading = false;
    });
  }

  @override
  void dispose() { searchController.dispose(); super.dispose(); }

  List<Cheat> get filtered => data.where((item) {
    if (tab == 1 && !saved.contains(item.id)) return false;
    if (group != 0 && item.category != groups[group]) return false;
    final text = (item.title + ' ' + item.description + ' ' + item.unlock + ' ' + item.category).toLowerCase();
    return text.contains(query.trim().toLowerCase());
  }).toList();

  void _favorite(Cheat item) {
    HapticFeedback.selectionClick();
    setState(() { saved.contains(item.id) ? saved.remove(item.id) : saved.add(item.id); });
    storage?.setStringList('saved-v1', saved.toList());
  }

  void _complete(Cheat item) {
    HapticFeedback.selectionClick();
    setState(() { done.contains(item.id) ? done.remove(item.id) : done.add(item.id); });
    storage?.setStringList('done-v1', done.toList());
  }

  void _changeTab(int i) {
    HapticFeedback.selectionClick();
    setState(() {
      tab = i; group = 0; query = ''; searchController.clear();
    });
  }

  Color accent(String cat) => switch(cat) {
    'Spieler' => pink,
    'Kampf' => coral,
    'Fahrzeuge' => const Color(0xFF94E6E6),
    'Umwelt' => mint,
    'Bildfilter' => const Color(0xFFD3BAFF),
    _ => coral,
  };

  IconData categoryIcon(String cat) => switch(cat) {
    'Spieler' => Icons.theater_comedy_outlined,
    'Kampf' => Icons.adjust,
    'Fahrzeuge' => Icons.directions_car_filled_outlined,
    'Umwelt' => Icons.park_outlined,
    'Bildfilter' => Icons.camera_outlined,
    _ => Icons.star_border,
  };

  Widget label(String s) => Text(s, style: const TextStyle(
    fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1.9, color: pink,
  ));

  Widget title(String s, {double size = 27}) => Text(s, style: TextStyle(
    fontSize: size, fontWeight: FontWeight.w900, letterSpacing: -0.7, height: 1.05,
  ));

  Widget panel(Widget child) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: edge)),
    child: child,
  );

  Widget _button(String text, IconData icon, VoidCallback onTap, {bool highlighted = false}) => FilledButton(
    onPressed: onTap,
    style: FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(45),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      backgroundColor: highlighted ? coral : const Color(0xFF4B3045),
      foregroundColor: highlighted ? bg : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, size: 16), const SizedBox(width: 5),
      Flexible(child: Text(text, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10))),
    ]),
  );

  void _details(Cheat cheat) {
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context, isScrollControlled: true, useSafeArea: true, showDragHandle: true,
      backgroundColor: const Color(0xFF24192B),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(builder: (ctx, updateModal) => Padding(
        padding: EdgeInsets.fromLTRB(20, 2, 20, 24 + MediaQuery.viewInsetsOf(ctx).bottom),
        child: SingleChildScrollView(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
          children: [
            label(cheat.category.toUpperCase() + ' · ' + (console == 0 ? 'PS5' : 'XBOX')),
            const SizedBox(height: 10), title(cheat.title.toUpperCase(), size: 32),
            const SizedBox(height: 10),
            Text(cheat.description, style: const TextStyle(color: muted, fontSize: 13)),
            const SizedBox(height: 19), label('FREISCHALTUNG'), const SizedBox(height: 9),
            panel(Row(children: [
              const Icon(Icons.emoji_events_outlined, color: coral),
              const SizedBox(width: 10),
              Expanded(child: Text(cheat.unlock, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            ])),
            const SizedBox(height: 20), label('TASTENKOMBINATION'), const SizedBox(height: 10),
            Wrap(spacing: 6, runSpacing: 6, children: cheat.code.split(' · ').map((part) => Container(
              constraints: const BoxConstraints(minWidth: 52),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(color: coral, borderRadius: BorderRadius.circular(6)),
              child: Text(part, textAlign: TextAlign.center, style: const TextStyle(color: bg, fontWeight: FontWeight.w900, fontSize: 11)),
            )).toList()),
            const SizedBox(height: 22),
            Row(children: [
              Expanded(child: _button(saved.contains(cheat.id) ? 'GEMERKT' : 'MERKEN', Icons.star_outline, () {
                _favorite(cheat); updateModal(() {});
              })),
              const SizedBox(width: 9),
              Expanded(child: _button(done.contains(cheat.id) ? 'ERLEDIGT' : 'MARKIEREN', Icons.check_circle_outline, () {
                _complete(cheat); updateModal(() {});
              })),
            ]),
            const SizedBox(height: 9),
            Row(children: [
              Expanded(child: _button('KOPIEREN', Icons.copy_outlined, () async {
                await Clipboard.setData(ClipboardData(text: cheat.code));
                if (ctx.mounted) ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Code kopiert')));
              }, highlighted: true)),
              const SizedBox(width: 9),
              Expanded(child: _button('TEILEN', Icons.ios_share, () {
                Share.share(cheat.title + '\n' + cheat.code + '\nVice Codes · Inoffizieller GTA VI Guide');
              })),
            ]),
            const SizedBox(height: 15),
            const Text('Codes aus öffentlichen Spiele-Guides. Nicht selbst im Spiel getestet. Inoffizielles Fan-Projekt.', style: TextStyle(fontSize: 10, color: muted)),
          ],
        )),
      )),
    );
  }

  Widget _card(Cheat cheat) {
    final color = accent(cheat.category);
    return InkWell(
      onTap: () => _details(cheat),
      borderRadius: BorderRadius.circular(13),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(13), border: Border.all(color: edge)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(child: Stack(children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Color.lerp(color, bg, .55)!, surface, Color.lerp(color, bg, .8)!],
              )),
              child: Center(child: Icon(categoryIcon(cheat.category), color: color, size: 61)),
            ),
            Positioned(top: 7, right: 7, child: GestureDetector(
              onTap: () => _favorite(cheat),
              child: Container(
                width: 32, height: 32,
                decoration: BoxDecoration(color: bg.withValues(alpha: .88), borderRadius: BorderRadius.circular(8), border: Border.all(color: edge)),
                child: Icon(saved.contains(cheat.id) ? Icons.star : Icons.star_border, size: 20, color: saved.contains(cheat.id) ? pink : Colors.white),
              ),
            )),
            if (done.contains(cheat.id)) const Positioned(top: 9, left: 9, child: Icon(Icons.check_circle, color: mint, size: 22)),
          ])),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(cheat.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
              const SizedBox(height: 4),
              Text(cheat.category.toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: muted)),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _progress() {
    final ratio = data.isEmpty ? 0.0 : done.length / data.length;
    return panel(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('DEIN FORTSCHRITT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
      const SizedBox(height: 10),
      Text((ratio * 100).round().toString() + ' %', style: const TextStyle(color: coral, fontWeight: FontWeight.w900, fontSize: 30)),
      const SizedBox(height: 5),
      ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(value: ratio, color: coral, backgroundColor: bg, minHeight: 7)),
      const SizedBox(height: 8),
      Text(done.length.toString() + ' / ' + data.length.toString() + ' freigeschaltet · ' + saved.length.toString() + ' Favoriten', style: const TextStyle(fontSize: 11, color: muted)),
    ]));
  }

  Widget _filters() => Column(children: [
    TextField(
      controller: searchController,
      onChanged: (v) => setState(() => query = v),
      decoration: InputDecoration(
        hintText: 'Cheat oder Fahrzeug suchen',
        hintStyle: const TextStyle(color: muted, fontSize: 13),
        prefixIcon: const Icon(Icons.search, color: pink),
        filled: true, fillColor: surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: edge)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: edge)),
      ),
    ),
    const SizedBox(height: 10),
    Row(children: [
      for (var i = 0; i < 2; i++)
        Expanded(child: Padding(
          padding: EdgeInsets.only(right: i == 0 ? 4 : 0, left: i == 1 ? 4 : 0),
          child: _button(i == 0 ? 'PLAYSTATION 5' : 'XBOX SERIES', Icons.sports_esports_outlined, () {
            HapticFeedback.selectionClick(); setState(() => console = i);
          }, highlighted: console == i),
        )),
    ]),
    const SizedBox(height: 21),
    SizedBox(
      height: 86,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: groups.length,
        separatorBuilder: (context, i) => const SizedBox(width: 7),
        itemBuilder: (context, i) => InkWell(
          borderRadius: BorderRadius.circular(11),
          onTap: () { HapticFeedback.selectionClick(); setState(() => group = i); },
          child: Container(
            width: 87,
            decoration: BoxDecoration(
              color: group == i ? const Color(0xFF563149) : surface,
              border: Border.all(color: group == i ? coral : edge),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(categoryIcon(groups[i]), color: accent(groups[i]), size: 29),
              const SizedBox(height: 5),
              Text(groups[i], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 10)),
            ]),
          ),
        ),
      ),
    ),
  ]);

  Widget _listPage() => LayoutBuilder(builder: (context, limits) {
    final items = filtered;
    final cols = limits.maxWidth < 340 ? 1 : limits.maxWidth > 720 ? 3 : 2;
    const gap = 9.0;
    final cardWidth = (limits.maxWidth - (cols - 1) * gap) / cols;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (tab == 0) Container(
        height: 206, width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF683653), Color(0xFF34253A), Color(0xFF17424A)]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: edge),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          label('DEIN GUIDE DURCH LEONIDA'),
          const SizedBox(height: 9),
          title('GTA VI', size: 60),
          title('CHEATS', size: 43),
          const Spacer(),
          Text(data.length.toString() + ' CODES · PS5 & XBOX', style: const TextStyle(color: coral, fontSize: 11, fontWeight: FontWeight.w900)),
        ]),
      ),
      const SizedBox(height: 20),
      _filters(),
      const SizedBox(height: 24),
      Row(children: [
        Expanded(child: title(tab == 1 ? 'FAVORITEN' : 'CHEAT-DATENBANK')),
        Text(items.length.toString() + ' CODES', style: const TextStyle(color: coral, fontSize: 11, fontWeight: FontWeight.w900)),
      ]),
      const SizedBox(height: 15),
      if (items.isEmpty) panel(Center(child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(tab == 1 ? 'Noch keine Favoriten' : 'Keine Treffer', style: const TextStyle(color: muted)),
      )))
      else Wrap(
        spacing: gap, runSpacing: gap,
        children: items.asMap().entries.map((entry) {
          final lastOdd = cols == 2 && items.length.isOdd && entry.key == items.length - 1;
          return SizedBox(width: lastOdd ? limits.maxWidth : cardWidth, height: 178, child: _card(entry.value));
        }).toList(),
      ),
      const SizedBox(height: 20),
      _progress(),
      const SizedBox(height: 20),
      const Center(child: Text('Unabhängiger Fan-Guide · Nicht offiziell', style: TextStyle(fontSize: 10, color: muted))),
    ]);
  });

  Widget _infoCard(String no, String heading, String body) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: panel(Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(no, style: const TextStyle(color: coral, fontSize: 25, fontWeight: FontWeight.w900)),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(heading, style: const TextStyle(fontWeight: FontWeight.w900)),
        const SizedBox(height: 6),
        Text(body, style: const TextStyle(color: muted, fontSize: 12)),
      ])),
    ])),
  );

  Widget _guide() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    label('KURZANLEITUNG'),
    const SizedBox(height: 9), title('CHEATS AKTIVIEREN', size: 32),
    const SizedBox(height: 22),
    _infoCard('01', 'STORY BEENDEN', 'Schließe die Hauptgeschichte ab.'),
    _infoCard('02', 'FREISCHALTEN', 'Erfülle die Bedingung für den gewünschten Cheat.'),
    _infoCard('03', 'HANDY ÖFFNEN', 'Steuerkreuz nach oben, dann L1 + R1 auf PS5 oder LB + RB auf Xbox halten und die Richtungen eingeben.'),
    _infoCard('04', 'VORHER SPEICHERN', 'Aktive Cheats verhindern Speichern und Trophäen in der Sitzung.'),
  ]);

  Widget _about() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    label('VICE CODES'),
    const SizedBox(height: 9), title('ÜBER DIE APP', size: 32),
    const SizedBox(height: 20),
    _infoCard('VI', 'INOFFIZIELLER GUIDE', 'Kein offizielles Produkt von Rockstar Games oder Take-Two Interactive.'),
    _infoCard('19', 'RECHERCHIERTE CODES', 'Codes aus GamesRadar+ und PC Gamer. Die Eingaben wurden nicht selbst im Spiel getestet.'),
    _infoCard('✓', 'DEINE DATEN', 'Favoriten und Fortschritt bleiben nur auf deinem Gerät. Keine Anmeldung.'),
    const SizedBox(height: 13),
    _button('GAMESRADAR+ QUELLE', Icons.open_in_new, () {
      launchUrl(Uri.parse('https://www.gamesradar.com/games/grand-theft-auto/gta-6-cheats/'), mode: LaunchMode.externalApplication);
    }),
    const SizedBox(height: 10),
    _button('PC GAMER QUELLE', Icons.open_in_new, () {
      launchUrl(Uri.parse('https://www.pcgamer.com/games/grand-theft-auto/gta-6-cheats-list/'), mode: LaunchMode.externalApplication);
    }),
  ]);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(18, 9, 18, 12),
        child: Row(children: [
          Container(
            width: 39, height: 39,
            alignment: Alignment.center,
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [coral, pink]), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.park, color: bg, size: 29),
          ),
          const SizedBox(width: 11),
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('VICE CODES', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 19)),
            Text('GTA VI · FAN-GUIDE', style: TextStyle(color: pink, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
          ]),
        ]),
      ),
      const Divider(height: 1, color: edge),
      Expanded(child: loading
        ? const Center(child: CircularProgressIndicator(color: pink))
        : ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 20), children: [
            if (tab == 0 || tab == 1) _listPage() else if (tab == 2) _guide() else _about(),
          ])),
    ])),
    bottomNavigationBar: SafeArea(top: false, child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      decoration: const BoxDecoration(color: surface, border: Border(top: BorderSide(color: edge))),
      child: Row(children: [
        _nav(Icons.sports_esports_outlined, 'CHEATS', 0),
        _nav(Icons.star_outline, 'MERKLISTE', 1),
        _nav(Icons.menu_book_outlined, 'HILFE', 2),
        _nav(Icons.info_outline_rounded, 'INFO', 3),
      ]),
    )),
  );

  Widget _nav(IconData icon, String text, int index) => Expanded(child: InkWell(
    onTap: () => _changeTab(index),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(color: tab == index ? const Color(0xFF51334C) : Colors.transparent, borderRadius: BorderRadius.circular(9)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: tab == index ? pink : muted, size: 22),
        const SizedBox(height: 4),
        Text(text, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: tab == index ? Colors.white : muted)),
      ]),
    ),
  ));
}
