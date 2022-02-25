import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:justcast_app/screen/legal/datasecure.dart';
import 'package:justcast_app/screen/legal/impressum.dart';
import 'package:justcast_app/services/globals.dart';
import 'package:justcast_app/services/navigation_service.dart';
import 'package:justcast_app/widget/change_theme_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AGB extends StatelessWidget {
  const AGB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: Theme.of(context).backgroundColor,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () async {
                      launch('https://discord.gg/WYfmfzskwr');
                    },
                    icon: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: AssetImage('assets/images/discord.png')),),),
                  ),
            Expanded(
              flex: 1,
              child: Image.asset(
                  isDarkMode
                      ? 'assets/images/logo_white.png'
                      : 'assets/images/logo_black.png',
                  fit: BoxFit.contain,
                  height: 80,
                ),
            ),
              ]
          ),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  if(userAuth.isNotEmpty)
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text("Meine Anfragen"),
                    ),
                  if(isCaster == true && userAuth.isNotEmpty)
                    const PopupMenuItem<int>(
                      value: 4,
                      child: Text("Angefragte Spiele"),
                    ),
                  if(userAuth.isNotEmpty)
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text("Mein Profil"),
                    ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Column(
                        children: [
                          const ChangeThemeButtonWidget(),
                        ]
                    ),
                  ),
                  if(userAuth.isNotEmpty)
                    const PopupMenuItem<int>(
                      value: 3,
                      child: Text("Logout"),
                    ),
                  if(userAuth.isEmpty)
                    const PopupMenuItem(
                        value: 5,
                        child: Text("Login"),
                    ),
                ];
              },
              onSelected: (value) {
                if(value == 0) {
                  NavigationService.onPressedDashboard(context);
                }else if(value == 4) {
                  NavigationService.onPressedCasterDashboard(context);
                }else if(value == 1) {
                  NavigationService.onPressedProfile(context);
                }else if(value == 2) {
                  ;
                }else if(value == 3) {
                  userAuth = "";
                  NavigationService.onPressedLogout(context);
                }else if(value == 5) {
                  NavigationService.onPressedLogin(context);
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Column(
                          children: const [
                            Text(
                              'AGB',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]
                      ),
                    ),
                  ),
                  const SizedBox(
                    height:  5,
                  ),
                  RichText(
                      text: const TextSpan(
                          children: <TextSpan>[
                            TextSpan(text: '1. Anwendungsbereich\n\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            TextSpan(text: 'Gegenstand dieser AGB ist die Nutzung der JustCast IT Plattform, welche von der '
                                'NextLevelNation Inh.: Christian Steinbach, nachfolgend NextLevelNation, betrieben wird. Die NextLevelNation '
                                'stellt dem Endnutzer für die Dauer dieses Vertrages die Plattform in der jeweils aktuellen Version über das Internet '
                                'unentgeltlich zur Nutzung zur Verfügung.\n\n'),
                            TextSpan(text: 'Die Vertragsbeziehung zwischen der NextLevelNation und dem Endnutzer kommt mit der Registrierung eines '
                                'Benutzeraccounts zustande. Mit der Registrierung erkennt der Endnutzer die vorliegende AGB ausdrücklich an.\n\n'),
                            TextSpan(text: 'Allfällige Allgemeine Geschäftsbedingungen bzw. Allgemeine Einkaufsbedingungen des Endnutzer werden '
                                'hiermit ausdrücklich ausgeschlossen, sofern sie von der NextLevelNation nicht ausdrücklich und schriftlich anerkannt werden.\n\n'),

                            TextSpan(text: '2. Verantwortlichkeiten und Leistungen der NextLevelNation\n\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            TextSpan(text: 'Die NextLevelNation ist für den Betrieb der Plattform verantwortlich. Diese umfassen den zuverlässigen und '
                                'sicheren Betrieb der technischen Infrastruktur, Installation und Instandhaltung der Software, Betrieb eines Backup-Systems, '
                                'sowie die zur Aufrechterhaltung der Betriebstüchtigkeit erforderlichen Massnahmen.\n\n'),

                            TextSpan(text: '3. Verantwortlichkeiten des Endnutzer\n\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            TextSpan(text: 'Der Endnutzer bleibt abgesehen von der JustCast Plattform für den Betrieb, die Sicherheit und den Zustand '
                                'seiner Website und allen weiteren elektronischen/digitalen Medien, auf denen die JustCast Plattform zum Einsatz kommt '
                                'vollumfänglich verantwortlich (Hardware, Software, Betrieb, Sicherheit etc.). Der Endnutzer trägt sämtliche im Zusammenhang '
                                'mit der Wahrnehmung seiner Verantwortlichkeiten entstehenden Kosten.\n\n'),

                            TextSpan(text: '4. Systemverfügbarkeit\n\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            TextSpan(text: 'Die JustCast Plattform Leistungen werden nach "best effort" Grundsätzen erbracht. Die NextLevelNation '
                                'ergreift die zumutbaren Massnahmen, um eine möglichst unterbrechungsfreie Nutzung der Plattform zu gewährleisten. Der Endnutzer '
                                'ist sich jedoch bewusst, dass es sich bei den Leistungen und weiteren Komponenten von Drittpartnern, deren Funktionstüchtigkeit '
                                'von der NextLevelNation nicht beeinflusst werden kann, um ein technisch komplexes System handelt, weshalb die NextLevelNation '
                                'keine Garantie für die ständige und vollständige Verfügbarkeit dieser Komponenten übernehmen kann. Unterbrüche aufgrund von '
                                'Systemwartungen, Updates etc.) im Voraus angekündigt, wobei bei planbaren Arbeiten eine Frist von 2 Arbeitstagen eingehalten wird. '
                                'Unmittelbar notwendige Arbeiten, die einen Unterbruch in der Verfügbarkeit auslösen, können im Sinne einer schnellen Problembehebung '
                                'oder Abwendung von Gefährdungspotential (z.B. Virenbefall) ohne Vorankündigung vorgenommen werden.\n\n'),
                            TextSpan(text:'4.1. Gefährdung der Datensicherheit\nErkennt die NextLevelNation eine Gefährdung des ordnungsgemäßen Betriebs durch '
                                'fahrlässige oder mutwillige Aktivitäten externer Urheber (DOS Attacken, Virenangriff u.ä.), ist die NextLevelNation befugt, '
                                'umgehend alle notwendigen Schritte zu unternehmen, um die eigene Infrastruktur und Software vor Schaden zu bewahren.\n\n'),

                            TextSpan(text: '5. Support\n\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            TextSpan(text: 'Der Support steht über den Discord Channel oder per E-Mail aus dem Impressum bereit.\n\n'),

                            TextSpan(text: '6. Datenschutz und Datensicherheit\n\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            TextSpan(text: 'Die NextLevelNation wird die Daten des Endnutzer mit höchster Sorgfalt behandeln und sie vor Missbrauch und '
                                'Verlust schützen. Dazu trifft die NextLevelNation technische und organisatorische Massnahmen, welche mindestens den gültigen Anforderungen '
                                'der DSGVO entsprechen. Die Daten werden in Europa gespeichert. I.d.R. in Deutschland. Spezielle Vereinbarungen zu Serverstandorten können '
                                'im Rahmen von technischen Möglichkeiten getroffen werden.\n\n'),
                            TextSpan(text: '6.1. Der Endnutzer ist für die Rechtmässigkeit der Datenweitergabe bzw. deren Verwendung verantwortlich. Alle von der NextLevelNation '
                                'gespeicherten und bearbeiteten Daten des Endnutzer sind ausschliessliches Eigentum des Endnutzer und werden von der NextLevelNation ausschliesslich '
                                'zu Zwecken der Vertragserfüllung genutzt.\n\n'),
                            TextSpan(text: '6.2. Der Endnutzer gestattet die NextLevelNation, soweit dies gesetzlich erlaubt ist, die anonymisierte Auswertung der bei der '
                                'NextLevelNation für den Endnutzer gespeicherten Daten, etwa für statistische Zwecke, sowie die Verwertung der Auswertungen durch die NextLevelNation.\n\n'),

                            TextSpan(text: '7. Gewährleistung\n\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            TextSpan(text: 'Die NextLevelNation gewährleistet, dass die Dienstleistungen technisch korrekt erbracht werden.\n\n'),

                            TextSpan(text: '8. Haftung\n\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            TextSpan(text: 'Die NextLevelNation distanziert sich von allen illegalen Aktivitäten, welche über die Funktionen, Kommentare oder Mitteilungen verbreitet '
                                'werden. Die Haftung liegt bei dem Endnutzer.\n\n'),

                            TextSpan(text: '9. Schlussbestimmungen\n\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            TextSpan(text: '9.1 Änderungen und Ergänzungen des Vertrages bedürfen zu ihrer Gültigkeit der Schriftform.\n\n'),
                            TextSpan(text: '9.2 Der Vertrag oder einzelne daraus abgeleitete Rechte dürfen nur nach vorgängiger schriftlicher Zustimmung der anderen Partei an '
                                'Dritte abgetreten werden.\n\n'),
                            TextSpan(text: '9.3 Sollte eine Bestimmung dieses Vertrages unwirksam oder undurchführbar sein, bleibt die Wirksamkeit der übrigen Bestimmungen dieses Vertrages '
                                'hiervon unberührt. Die Parteien haben die unwirksame oder undurchführbare Bestimmung durch eine Vorschrift zu ersetzen, die ihrem wirtschaftlichen Ergebnis '
                                'entspricht.\n\n'),
                            TextSpan(text: '9.4 Sämtliche Bestimmungen des Vertrages, welche sich aufgrund ihrer Natur über dessen Beendigung ausdehnen, verbleiben in Kraft, bis sie erfüllt '
                                'sind, unter Einschluss der Vertraulichkeit, des massgebenden Rechts, der Vergütung, des geistigen Eigentums, der Haftung sowie der Gewährleistung.\n\n'),
                            TextSpan(text: '9.5 Bei Meinungsverschiedenheiten werden die Parteien vor Anrufung des Richters eine gütliche Einigung, in letzter Instanz auf Geschäftsleitungsebene, '
                                'anstreben. Sollte eine solche aus der Sicht einer Partei nicht möglich sein, kann der Richter angerufen werden.\n\n'),

                            TextSpan(text: 'Ehingen (Donau), 22.02.2022'),
                          ])

                  )
                ],
              ),
            ),
          ),
        ),
      persistentFooterButtons: [
        GestureDetector(
          onTap: (){
            Navigator.pushReplacement(context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const AGB(),
                ));
          },
          child:  const Text(
            'AGB',
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            Navigator.pushReplacement(context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const DataSecure(),
                ));
          },
          child:  const Text(
            'Datenschutz',
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            Navigator.pushReplacement(context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const Impressum(),
                ));
          },
          child:  const Text(
            'Impressum',
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}