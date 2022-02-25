import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:justcast_app/screen/legal/agb.dart';
import 'package:justcast_app/screen/legal/impressum.dart';
import 'package:justcast_app/services/globals.dart';
import 'package:justcast_app/services/navigation_service.dart';
import 'package:justcast_app/widget/change_theme_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class DataSecure extends StatelessWidget {
  const DataSecure({Key? key}) : super(key: key);

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
                              'Datenschutz',
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
                      text: TextSpan(
                          children: <TextSpan>[
                            const TextSpan(text: 'Einleitung\n\n', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const TextSpan(text: 'Mit der folgenden Datenschutzerklärung möchten wir Sie darüber aufklären, '
                                'welche Arten Ihrer personenbezogenen Daten (nachfolgend auch kurz als "Daten“ bezeichnet) '
                                'wir zu welchen Zwecken und in welchem Umfang im Rahmen der Bereitstellung unserer Applikation verarbeiten.\n\n'),
                            const TextSpan(text: 'Die verwendeten Begriffe sind nicht geschlechtsspezifisch.\n\n'),
                            const TextSpan(text: 'Stand: 21. Februar 2022\n\n'),

                            const TextSpan(text: 'Verantwortlicher\n\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const TextSpan(text: 'JustCast\n'),
                            const TextSpan(text: 'Inh.: Christian Steinbach\n'),
                            const TextSpan(text: 'Stettener Weg 2\n'),
                            const TextSpan(text: '89584 Ehingen\n\n'),

                            const TextSpan(text: 'Kontakt\n'),
                            const TextSpan(text: 'Telefon: 07391-7816405\n'),
                            const TextSpan(text: 'E-Mail: team@justcast.org\n\n'),

                            const TextSpan(text: 'Vertretungsberechtigte Personen:\n'),
                            const TextSpan(text: 'Fabian Groß\n\n'),
                            const TextSpan(text: 'E-Mail-Adresse:\n'),
                            const TextSpan(text: 'team@justcast.org\n\n'),
                            const TextSpan(text: 'Impressum:\n'),
                            TextSpan(text:'https://www.justcast.org/legal/imprint\n\n', style: const TextStyle(color: Colors.blue), recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final url = 'https://www.justcast.org/legal/imprint';
                                if (await canLaunch(url)) {
                                  await launch(
                                    url,
                                    forceSafariVC: false,
                                  );
                                }
                              },
                            ),

                            const TextSpan(text: 'Übersicht der Verarbeitungen\n\n', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const TextSpan(text: 'Die nachfolgende Übersicht fasst die Arten der verarbeiteten Daten und die Zwecke ihrer Verarbeitung zusammen und verweist '
                                'auf die betroffenen Personen.\n\n'),

                            const TextSpan(text: 'Arten der verarbeiteten Daten\n\n', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: '•	Bestandsdaten\n•	Kontaktdaten.\n•	Inhaltsdaten.\n•	Vertragsdaten.\n•	Nutzungsdaten.\n•	Meta-/Kommunikationsdaten.\n\n'),

                            const TextSpan(text: 'Kategorien betroffener Personen\n\n', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: '•	Kunden.\n•	Kommunikationspartner.\n•	Nutzer.\n\n'),

                            const TextSpan(text: 'Zwecke der Verarbeitung\n\n', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: '•	Erbringung vertraglicher Leistungen und Kundenservice.\n•	Kontaktanfragen und Kommunikation.\n•	Sicherheitsmaßnahmen.\n'
                                '•	Verwaltung und Beantwortung von Anfragen.\n•	Feedback.\n•	Marketing.\n•	Bereitstellung unseres Onlineangebotes und Nutzerfreundlichkeit.'
                                '\n\n'),

                            const TextSpan(text: 'Maßgebliche Rechtsgrundlagen\n\n', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Im Folgenden erhalten Sie eine Übersicht der Rechtsgrundlagen der DSGVO, auf deren Basis wir personenbezogene Daten '
                                'verarbeiten. Bitte nehmen Sie zur Kenntnis, dass neben den Regelungen der DSGVO nationale Datenschutzvorgaben in Ihrem bzw. unserem Wohn- '
                                'oder Sitzland gelten können. Sollten ferner im Einzelfall speziellere Rechtsgrundlagen maßgeblich sein, teilen wir Ihnen diese in der '
                                'Datenschutzerklärung mit.\n\n'),

                            const TextSpan(text: '•	Einwilligung (Art. 6 Abs. 1 S. 1 lit. a. DSGVO) ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: '- Die betroffene Person hat ihre Einwilligung in die Verarbeitung der sie betreffenden personenbezogenen Daten für '
                                'einen spezifischen Zweck oder mehrere bestimmte Zwecke gegeben.\n'),
                            const TextSpan(text: '•	Vertragserfüllung und vorvertragliche Anfragen (Art. 6 Abs. 1 S. 1 lit. b. DSGVO) ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: '- Die Verarbeitung ist für die Erfüllung eines Vertrags, dessen Vertragspartei die betroffene Person ist, oder zur '
                                'Durchführung vorvertraglicher Maßnahmen erforderlich, die auf Anfrage der betroffenen Person erfolgen.\n'),
                            const TextSpan(text: '•	Rechtliche Verpflichtung (Art. 6 Abs. 1 S. 1 lit. c. DSGVO) ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: '- Die Verarbeitung ist zur Erfüllung einer rechtlichen Verpflichtung erforderlich, der der Verantwortliche unterliegt.\n'),
                            const TextSpan(text: '•	Berechtigte Interessen (Art. 6 Abs. 1 S. 1 lit. f. DSGVO) ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: '- Die Verarbeitung ist zur Wahrung der berechtigten Interessen des Verantwortlichen oder eines Dritten erforderlich, '
                                'sofern nicht die Interessen oder Grundrechte und Grundfreiheiten der betroffenen Person, die den Schutz personenbezogener Daten erfordern, überwiegen.\n\n'),

                            const TextSpan(text: 'Zusätzlich zu den Datenschutzregelungen der Datenschutz-Grundverordnung gelten nationale Regelungen zum Datenschutz in '
                                'Deutschland. Hierzu gehört insbesondere das Gesetz zum Schutz vor Missbrauch personenbezogener Daten bei der Datenverarbeitung '
                                '(Bundesdatenschutzgesetz – BDSG). Das BDSG enthält insbesondere Spezialregelungen zum Recht auf Auskunft, zum Recht auf Löschung, '
                                'zum Widerspruchsrecht, zur Verarbeitung besonderer Kategorien personenbezogener Daten, zur Verarbeitung für andere Zwecke und zur '
                                'Übermittlung sowie automatisierten Entscheidungsfindung im Einzelfall einschließlich Profiling. Des Weiteren regelt es die Datenverarbeitung '
                                'für Zwecke des Beschäftigungsverhältnisses (§ 26 BDSG), insbesondere im Hinblick auf die Begründung, Durchführung oder Beendigung von '
                                'Beschäftigungsverhältnissen sowie die Einwilligung von Beschäftigten. Ferner können Landesdatenschutzgesetze der einzelnen Bundesländer '
                                'zur Anwendung gelangen.\n\n'),

                            const TextSpan(text: 'Sicherheitsmaßnahmen\n\n', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const TextSpan(text: 'Wir treffen nach Maßgabe der gesetzlichen Vorgaben unter Berücksichtigung des Stands der Technik, der Implementierungskosten '
                                'und der Art, des Umfangs, der Umstände und der Zwecke der Verarbeitung sowie der unterschiedlichen Eintrittswahrscheinlichkeiten und des '
                                'Ausmaßes der Bedrohung der Rechte und Freiheiten natürlicher Personen geeignete technische und organisatorische Maßnahmen, um ein dem Risiko '
                                'angemessenes Schutzniveau zu gewährleisten.\n\n'),
                            const TextSpan(text: 'Zu den Maßnahmen gehören insbesondere die Sicherung der Vertraulichkeit, Integrität und Verfügbarkeit von Daten durch Kontrolle '
                                'des physischen und elektronischen Zugangs zu den Daten als auch des sie betreffenden Zugriffs, der Eingabe, der Weitergabe, der Sicherung der '
                                'Verfügbarkeit und ihrer Trennung. Des Weiteren haben wir Verfahren eingerichtet, die eine Wahrnehmung von Betroffenenrechten, die Löschung von '
                                'Daten und Reaktionen auf die Gefährdung der Daten gewährleisten. Ferner berücksichtigen wir den Schutz personenbezogener Daten bereits bei der '
                                'Entwicklung bzw. Auswahl von Hardware, Software sowie Verfahren entsprechend dem Prinzip des Datenschutzes, durch Technikgestaltung und durch '
                                'datenschutzfreundliche Voreinstellungen.\n\n'),
                            const TextSpan(text: 'SSL-Verschlüsselung (https): Um Ihre via unserem Online-Angebot übermittelten Daten zu schützen, nutzen wir eine SSL-Verschlüsselung. '
                                'Sie erkennen derart verschlüsselte Verbindungen an dem Präfix https:// in der Adresszeile Ihres Browsers.\n\n'),

                            const TextSpan(text: 'Übermittlung von personenbezogenen Daten\n\n', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const TextSpan(text: 'Im Rahmen unserer Verarbeitung von personenbezogenen Daten kommt es vor, dass die Daten an andere Stellen, Unternehmen, '
                                'rechtlich selbstständige Organisationseinheiten oder Personen übermittelt oder sie ihnen gegenüber offengelegt werden. Zu den Empfängern '
                                'dieser Daten können z.B. mit IT-Aufgaben beauftragte Dienstleister oder Anbieter von Diensten und Inhalten, die in eine Webseite eingebunden '
                                'werden, gehören. In solchen Fall beachten wir die gesetzlichen Vorgaben und schließen insbesondere entsprechende Verträge bzw. Vereinbarungen, '
                                'die dem Schutz Ihrer Daten dienen, mit den Empfängern Ihrer Daten ab.\n\n'),

                            const TextSpan(text: 'Datenverarbeitung in Drittländern\n\n', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const TextSpan(text: 'Sofern wir Daten in einem Drittland (d.h., außerhalb der Europäischen Union (EU), des Europäischen Wirtschaftsraums (EWR)) '
                                'verarbeiten oder die Verarbeitung im Rahmen der Inanspruchnahme von Diensten Dritter oder der Offenlegung bzw. Übermittlung von Daten an andere '
                                'Personen, Stellen oder Unternehmen stattfindet, erfolgt dies nur im Einklang mit den gesetzlichen Vorgaben.\n\n'),
                            const TextSpan(text: 'Vorbehaltlich ausdrücklicher Einwilligung oder vertraglich oder gesetzlich erforderlicher Übermittlung verarbeiten oder lassen '
                                'wir die Daten nur in Drittländern mit einem anerkannten Datenschutzniveau, vertraglichen Verpflichtung durch sogenannte Standardschutzklauseln '
                                'der EU-Kommission, beim Vorliegen von Zertifizierungen oder verbindlicher internen Datenschutzvorschriften verarbeiten '
                                '(Art. 44 bis 49 DSGVO, Informationsseite der EU-Kommission: '),
                            TextSpan(text:'https://ec.europa.eu/info/law/law-topic/data-protection/international-dimension-data-protection_de).\n\n', style: const TextStyle(color: Colors.blue), recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final url = 'https://ec.europa.eu/info/law/law-topic/data-protection/international-dimension-data-protection_de).';
                                if (await canLaunch(url)) {
                                  await launch(
                                    url,
                                    forceSafariVC: false,
                                  );
                                }
                              },
                            ),

                            const TextSpan(text: 'Löschung von Daten\n\n', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const TextSpan(text: 'Die von uns verarbeiteten Daten werden nach Maßgabe der gesetzlichen Vorgaben gelöscht, sobald deren zur Verarbeitung erlaubten '
                                'Einwilligungen widerrufen werden oder sonstige Erlaubnisse entfallen (z.B. wenn der Zweck der Verarbeitung dieser Daten entfallen ist oder sie '
                                'für den Zweck nicht erforderlich sind).\n\n'),
                            const TextSpan(text: 'Sofern die Daten nicht gelöscht werden, weil sie für andere und gesetzlich zulässige Zwecke erforderlich sind, wird deren '
                                'Verarbeitung auf diese Zwecke beschränkt. D.h., die Daten werden gesperrt und nicht für andere Zwecke verarbeitet. Das gilt z.B. für Daten, '
                                'die aus handels- oder steuerrechtlichen Gründen aufbewahrt werden müssen oder deren Speicherung zur Geltendmachung, Ausübung oder Verteidigung von '
                                'Rechtsansprüchen oder zum Schutz der Rechte einer anderen natürlichen oder juristischen Person erforderlich ist.\n\n'),
                            const TextSpan(text: 'Unsere Datenschutzhinweise können ferner weitere Angaben zu der Aufbewahrung und Löschung von Daten beinhalten, die für die '
                                'jeweiligen Verarbeitungen vorrangig gelten.\n\n'),

                            const TextSpan(text: 'Bereitstellung des Onlineangebotes und Webhosting\n\n', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const TextSpan(text: 'Um unser Onlineangebot sicher und effizient bereitstellen zu können, nehmen wir die Leistungen von einem oder mehreren '
                                'Webhosting-Anbietern in Anspruch, von deren Servern (bzw. von ihnen verwalteten Servern) das Onlineangebot abgerufen werden kann. Zu diesen '
                                'Zwecken können wir Infrastruktur- und Plattformdienstleistungen, Rechenkapazität, Speicherplatz und Datenbankdienste sowie Sicherheitsleistungen '
                                'und technische Wartungsleistungen in Anspruch nehmen.\n\n'),
                            const TextSpan(text: 'Zu den im Rahmen der Bereitstellung des Hostingangebotes verarbeiteten Daten können alle die Nutzer unseres Onlineangebotes '
                                'betreffenden Angaben gehören, die im Rahmen der Nutzung und der Kommunikation anfallen. Hierzu gehören regelmäßig die IP-Adresse, die notwendig '
                                'ist, um die Inhalte von Onlineangeboten an Browser ausliefern zu können, und alle innerhalb unseres Onlineangebotes oder von Webseiten getätigten Eingaben.\n\n'),
                            const TextSpan(text: '•	Verarbeitete Datenarten: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Inhaltsdaten (z.B. Eingaben in Onlineformularen); Nutzungsdaten (z.B. besuchte Webseiten, Interesse an Inhalten, Zugriffszeiten); '
                                'Meta-/Kommunikationsdaten (z.B. Geräte-Informationen, IP-Adressen).\n'),
                            const TextSpan(text: '•	Betroffene Personen: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Nutzer (z.B. Webseitenbesucher, Nutzer von Onlinediensten).\n'),
                            const TextSpan(text: '•	Zwecke der Verarbeitung: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Bereitstellung unseres Onlineangebotes und Nutzerfreundlichkeit.\n'),
                            const TextSpan(text: '•	Rechtsgrundlagen: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Berechtigte Interessen (Art. 6 Abs. 1 S. 1 lit. f. DSGVO).\n\n'),

                            const TextSpan(text: 'Weitere Hinweise zu Verarbeitungsprozessen, Verfahren und Diensten:\n\n', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: '•	Erhebung von Zugriffsdaten und Logfiles: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Wir selbst (bzw. unser Webhostinganbieter) erheben Daten zu jedem Zugriff auf den Server (sogenannte Serverlogfiles). '
                                'Zu den Serverlogfiles können die Adresse und Name der abgerufenen Webseiten und Dateien, Datum und Uhrzeit des Abrufs, übertragene Datenmengen, '
                                'Meldung über erfolgreichen Abruf, Browsertyp nebst Version, das Betriebssystem des Nutzers, Referrer URL (die zuvor besuchte Seite) und im '
                                'Regelfall IP-Adressen und der anfragende Provider gehören. Die Serverlogfiles können zum einen zu Zwecken der Sicherheit eingesetzt werden, '
                                'z.B., um eine Überlastung der Server zu vermeiden (insbesondere im Fall von missbräuchlichen Angriffen, sogenannten DDoS-Attacken) und zum '
                                'anderen, um die Auslastung der Server und ihre Stabilität sicherzustellen;\n'),
                            const TextSpan(text: 'Löschung von Daten: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Logfile-Informationen werden für die Dauer von maximal 30 Tagen gespeichert und danach gelöscht oder anonymisiert. Daten, '
                                'deren weitere Aufbewahrung zu Beweiszwecken erforderlich ist, sind bis zur endgültigen Klärung des jeweiligen Vorfalls von der Löschung ausgenommen.\n\n'),

                            const TextSpan(text: 'Registrierung, Anmeldung und Nutzerkonto\n\n', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const TextSpan(text: 'Nutzer können ein Nutzerkonto anlegen. Im Rahmen der Registrierung werden den Nutzern die erforderlichen Pflichtangaben mitgeteilt '
                                'und zu Zwecken der Bereitstellung des Nutzerkontos auf Grundlage vertraglicher Pflichterfüllung verarbeitet. Zu den verarbeiteten Daten gehören '
                                'insbesondere die Login-Informationen (Nutzername, Passwort sowie eine E-Mail-Adresse).\n\n'),

                            const TextSpan(text: 'Im Rahmen der Inanspruchnahme unserer Registrierungs- und Anmeldefunktionen sowie der Nutzung des Nutzerkontos speichern wir '
                                'die IP-Adresse und den Zeitpunkt der jeweiligen Nutzerhandlung. Die Speicherung erfolgt auf Grundlage unserer berechtigten Interessen als auch '
                                'jener der Nutzer an einem Schutz vor Missbrauch und sonstiger unbefugter Nutzung. Eine Weitergabe dieser Daten an Dritte erfolgt grundsätzlich '
                                'nicht, es sei denn, sie ist zur Verfolgung unserer Ansprüche erforderlich oder es besteht eine gesetzliche Verpflichtung hierzu.\n\n'),
                            const TextSpan(text: 'Die Nutzer können über Vorgänge, die für deren Nutzerkonto relevant sind, wie z.B. technische Änderungen, per E-Mail informiert werden.\n\n'),

                            const TextSpan(text: '•	Verarbeitete Datenarten: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Bestandsdaten (z.B. Namen, Adressen); Kontaktdaten (z.B. E-Mail, Telefonnummern); Inhaltsdaten (z.B. Eingaben in Onlineformularen); '
                                'Meta-/Kommunikationsdaten (z.B. Geräte-Informationen, IP-Adressen).\n'),
                            const TextSpan(text: '•	Betroffene Personen: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Nutzer (z.B. Webseitenbesucher, Nutzer von Onlinediensten).\n'),
                            const TextSpan(text: '•	Zwecke der Verarbeitung: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Erbringung vertraglicher Leistungen und Kundenservice; Sicherheitsmaßnahmen; Verwaltung und Beantwortung von Anfragen.\n'),
                            const TextSpan(text: '•	Rechtsgrundlagen: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Vertragserfüllung und vorvertragliche Anfragen (Art. 6 Abs. 1 S. 1 lit. b. DSGVO); Berechtigte Interessen (Art. 6 Abs. 1 S. 1 lit. f. DSGVO).\n\n'),

                            const TextSpan(text: 'Weitere Hinweise zu Verarbeitungsprozessen, Verfahren und Diensten:\n\n', style: const TextStyle(fontWeight: FontWeight.bold)),

                            const TextSpan(text: '•	Registrierung mit Pseudonymen: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Nutzer dürfen statt Klarnamen Pseudonyme als Nutzernamen verwenden.\n'),
                            const TextSpan(text: '•	Profile der Nutzer sind öffentlich: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Die Profile der Nutzer sind öffentlich sichtbar und zugänglich.\n'),
                            const TextSpan(text: '•	Löschung von Daten nach Kündigung: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Wenn Nutzer ihr Nutzerkonto gekündigt haben, werden deren Daten im Hinblick auf das Nutzerkonto, '
                                'vorbehaltlich einer gesetzlichen Erlaubnis, Pflicht oder Einwilligung der Nutzer, gelöscht.\n'),
                            const TextSpan(text: '•	Keine Aufbewahrungspflicht für Daten: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Es obliegt den Nutzern, ihre Daten bei erfolgter Kündigung vor dem Vertragsende zu sichern. '
                                'Wir sind berechtigt, sämtliche während der Vertragsdauer gespeicherte Daten des Nutzers unwiederbringlich zu löschen.\n\n'),

                            const TextSpan(text: 'Kontakt- und Anfragenverwaltung\n\n', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const TextSpan(text: 'Bei der Kontaktaufnahme mit uns (z.B. per Kontaktformular, E-Mail, Telefon oder via soziale Medien) sowie im Rahmen '
                                'bestehender Nutzer- und Geschäftsbeziehungen werden die Angaben der anfragenden Personen verarbeitet soweit dies zur Beantwortung der '
                                'Kontaktanfragen und etwaiger angefragter Maßnahmen erforderlich ist.\n\n'),
                            const TextSpan(text: 'Die Beantwortung der Kontaktanfragen sowie die Verwaltung von Kontakt- und Anfragedaten im Rahmen von vertraglichen oder '
                                'vorvertraglichen Beziehungen erfolgt zur Erfüllung unserer vertraglichen Pflichten oder zur Beantwortung von (vor)vertraglichen Anfragen und '
                                'im Übrigen auf Grundlage der berechtigten Interessen an der Beantwortung der Anfragen und Pflege von Nutzer- bzw. Geschäftsbeziehungen.\n\n'),

                            const TextSpan(text: '•	Verarbeitete Datenarten: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Bestandsdaten (z.B. Namen, Adressen); Kontaktdaten (z.B. E-Mail, Telefonnummern); Inhaltsdaten (z.B. Eingaben in Onlineformularen).\n'),
                            const TextSpan(text: '•	Betroffene Personen: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Kommunikationspartner.\n'),
                            const TextSpan(text: '•	Zwecke der Verarbeitung: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Kontaktanfragen und Kommunikation; Erbringung vertraglicher Leistungen und Kundenservice.\n'),
                            const TextSpan(text: '•	Rechtsgrundlagen: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Vertragserfüllung und vorvertragliche Anfragen (Art. 6 Abs. 1 S. 1 lit. b. DSGVO); '
                                'Berechtigte Interessen (Art. 6 Abs. 1 S. 1 lit. f. DSGVO); Rechtliche Verpflichtung (Art. 6 Abs. 1 S. 1 lit. c. DSGVO).\n\n'),

                            const TextSpan(text: 'Weitere Hinweise zu Verarbeitungsprozessen, Verfahren und Diensten:\n\n', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: '•	Kontaktformular: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Wenn Nutzer über unser Kontaktformular, E-Mail oder andere Kommunikationswege mit uns in Kontakt treten, verarbeiten wir die '
                                'uns in diesem Zusammenhang mitgeteilten Daten zur Bearbeitung des mitgeteilten Anliegens. Zu diesem Zweck verarbeiten wir personenbezogene Daten '
                                'im Rahmen vorvertraglicher und vertraglicher Geschäftsbeziehungen, soweit dies zu deren Erfüllung erforderlich ist und im Übrigen auf Grundlage '
                                'unserer berechtigten Interessen sowie der Interessen der Kommunikationspartner an der Beantwortung der Anliegen und unserer gesetzlichen Aufbewahrungspflichten.\n\n'),

                            const TextSpan(text: 'Kundenrezensionen und Bewertungsverfahren\n\n', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

                            const TextSpan(text: 'Wir nehmen an Rezensions- und Bewertungsverfahren teil, um unsere Leistungen zu evaluieren, zu optimieren und zu bewerben. Wenn Nutzer uns '
                                'über die beteiligten Bewertungsplattformen oder -verfahren bewerten oder anderweitig Feedback geben, gelten zusätzlich die Allgemeinen Geschäfts- '
                                'oder Nutzungsbedingungen und die Datenschutzhinweise der Anbieter. Im Regelfall setzt die Bewertung zudem eine Registrierung bei den jeweiligen '
                                'Anbietern voraus. \n\n'),

                            const TextSpan(text: 'Um sicherzustellen, dass die bewertenden Personen tatsächlich unsere Leistungen in Anspruch genommen haben, '
                                'übermitteln wir mit Einwilligung der Kunden die hierzu erforderlichen Daten im Hinblick auf den Kunden und die in Anspruch genommene Leistung an '
                                'die jeweilige Bewertungsplattform (einschließlich Name, E-Mail-Adresse und Bestellnummer bzw. Artikelnummer). Diese Daten werden alleine zur '
                                'Verifizierung der Authentizität des Nutzers verwendet. \n\n'),

                            const TextSpan(text: '•	Verarbeitete Datenarten: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Vertragsdaten (z.B. Vertragsgegenstand, Laufzeit, Kundenkategorie); Nutzungsdaten (z.B. besuchte Webseiten, '
                                'Interesse an Inhalten, Zugriffszeiten); Meta-/Kommunikationsdaten (z.B. Geräte-Informationen, IP-Adressen).\n'),
                            const TextSpan(text: '•	Betroffene Personen: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Kunden; Nutzer (z.B. Webseitenbesucher, Nutzer von Onlinediensten).\n'),
                            const TextSpan(text: '•	Zwecke der Verarbeitung: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Feedback (z.B. Sammeln von Feedback via Online-Formular); Marketing.\n'),
                            const TextSpan(text: '•	Rechtsgrundlagen: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Einwilligung (Art. 6 Abs. 1 S. 1 lit. a. DSGVO); Berechtigte Interessen (Art. 6 Abs. 1 S. 1 lit. f. DSGVO).\n\n'),

                            const TextSpan(text: 'Weitere Hinweise zu Verarbeitungsprozessen, Verfahren und Diensten:\n\n', style: const TextStyle(fontWeight: FontWeight.bold)),

                            const TextSpan(text: '•	Bewertungs-Widget: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Wir binden in unser Onlineangebot sogenannte "Bewertungs-Widgets“ ein. Ein Widget ist ein in unser Onlineangebot eingebundenes '
                                'Funktions- und Inhaltselement, das veränderliche Informationen anzeigt. Es kann z.B. in Form eines Siegels oder vergleichbaren Elements, zum Teil '
                                'auch "Badge" genannt, dargestellt werden. Dabei wird der entsprechende Inhalt des Widgets zwar innerhalb unseres Onlineangebotes dargestellt, '
                                'er wird aber in diesem Moment von den Servern des jeweiligen Widgets-Anbieters abgerufen. Nur so kann immer der aktuelle Inhalt gezeigt werden, '
                                'vor allem die jeweils aktuelle Bewertung. Dafür muss eine Datenverbindung von der innerhalb unseres Onlineangebotes aufgerufenen Webseite zu dem '
                                'Server des Widgets-Anbieters aufgebaut werden und der Widgets-Anbieter erhält gewisse technische Daten (Zugriffsdaten, inklusive IP-Adresse), die '
                                'nötig sind, damit der Inhalt des Widgets an den Browser des Nutzers ausgeliefert werden kann. Des Weiteren erhält der Widgets-Anbieter Informationen '
                                'darüber, dass Nutzer unser Onlineangebot besucht haben. Diese Informationen können in einem Cookie gespeichert und von dem Widgets-Anbieter verwendet '
                                'werden, um zu erkennen, welche Onlineangebote, die am dem Bewertungsverfahren teilnehmen, von dem Nutzer besucht worden sind. Die Informationen können '
                                'in einem Nutzerprofil gespeichert und für Werbe- oder Marktforschungszwecke verwendet werden.\n\n'),

                            const TextSpan(text: 'Präsenzen in sozialen Netzwerken (Social Media)\n\n', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const TextSpan(text: 'Wir unterhalten Onlinepräsenzen innerhalb sozialer Netzwerke und verarbeiten in diesem Rahmen Daten der Nutzer, um mit den dort '
                                'aktiven Nutzern zu kommunizieren oder um Informationen über uns anzubieten.\n\n'),
                            const TextSpan(text: 'Wir weisen darauf hin, dass dabei Daten der Nutzer außerhalb des Raumes der Europäischen Union verarbeitet werden können. '
                                'Hierdurch können sich für die Nutzer Risiken ergeben, weil so z.B. die Durchsetzung der Rechte der Nutzer erschwert werden könnte.\n\n'),
                            const TextSpan(text: 'Ferner werden die Daten der Nutzer innerhalb sozialer Netzwerke im Regelfall für Marktforschungs- und Werbezwecke verarbeitet. '
                                'So können z.B. anhand des Nutzungsverhaltens und sich daraus ergebender Interessen der Nutzer Nutzungsprofile erstellt werden. Die Nutzungsprofile können '
                                'wiederum verwendet werden, um z.B. Werbeanzeigen innerhalb und außerhalb der Netzwerke zu schalten, die mutmaßlich den Interessen der Nutzer entsprechen. '
                                'Zu diesen Zwecken werden im Regelfall Cookies auf den Rechnern der Nutzer gespeichert, in denen das Nutzungsverhalten und die Interessen der Nutzer gespeichert '
                                'werden. Ferner können in den Nutzungsprofilen auch Daten unabhängig der von den Nutzern verwendeten Geräte gespeichert werden (insbesondere, wenn die Nutzer '
                                'Mitglieder der jeweiligen Plattformen sind und bei diesen eingeloggt sind).\n\n'),
                            const TextSpan(text: 'Für eine detaillierte Darstellung der jeweiligen Verarbeitungsformen und der Widerspruchsmöglichkeiten (Opt-Out) verweisen wir auf die '
                                'Datenschutzerklärungen und Angaben der Betreiber der jeweiligen Netzwerke.\n\n'),
                            const TextSpan(text: 'Auch im Fall von Auskunftsanfragen und der Geltendmachung von Betroffenenrechten weisen wir darauf hin, dass diese am effektivsten bei den '
                                'Anbietern geltend gemacht werden können. Nur die Anbieter haben jeweils Zugriff auf die Daten der Nutzer und können direkt entsprechende Maßnahmen ergreifen '
                                'und Auskünfte geben. Sollten Sie dennoch Hilfe benötigen, dann können Sie sich an uns wenden.\n\n'),

                            const TextSpan(text: '•	Verarbeitete Datenarten: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Kontaktdaten (z.B. E-Mail, Telefonnummern); Inhaltsdaten (z.B. Eingaben in Onlineformularen); Nutzungsdaten (z.B. besuchte Webseiten, '
                                'Interesse an Inhalten, Zugriffszeiten); Meta-/Kommunikationsdaten (z.B. Geräte-Informationen, IP-Adressen).\n'),
                            const TextSpan(text: '•	Betroffene Personen: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Nutzer (z.B. Webseitenbesucher, Nutzer von Onlinediensten).\n'),
                            const TextSpan(text: '•	Zwecke der Verarbeitung: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Kontaktanfragen und Kommunikation; Feedback (z.B. Sammeln von Feedback via Online-Formular); Marketing.\n'),
                            const TextSpan(text: '•	Rechtsgrundlagen: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Berechtigte Interessen (Art. 6 Abs. 1 S. 1 lit. f. DSGVO).\n\n'),

                            const TextSpan(text: 'Änderung und Aktualisierung der Datenschutzerklärung\n\n', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const TextSpan(text: 'Wir bitten Sie, sich regelmäßig über den Inhalt unserer Datenschutzerklärung zu informieren. Wir passen die Datenschutzerklärung an, '
                                'sobald die Änderungen der von uns durchgeführten Datenverarbeitungen dies erforderlich machen. Wir informieren Sie, sobald durch die Änderungen eine '
                                'Mitwirkungshandlung Ihrerseits (z.B. Einwilligung) oder eine sonstige individuelle Benachrichtigung erforderlich wird.\n\n'),
                            const TextSpan(text: 'Sofern wir in dieser Datenschutzerklärung Adressen und Kontaktinformationen von Unternehmen und Organisationen angeben, bitten wir '
                                'zu beachten, dass die Adressen sich über die Zeit ändern können und bitten die Angaben vor Kontaktaufnahme zu prüfen.\n\n'),

                            const TextSpan(text: 'Rechte der betroffenen Personen\n\n', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const TextSpan(text: 'Ihnen stehen als Betroffene nach der DSGVO verschiedene Rechte zu, die sich insbesondere aus Art. 15 bis 21 DSGVO ergeben:\n\n'),

                            const TextSpan(text: '•	Widerspruchsrecht: Sie haben das Recht, aus Gründen, die sich aus Ihrer besonderen Situation ergeben, jederzeit gegen die '
                                'Verarbeitung der Sie betreffenden personenbezogenen Daten, die aufgrund von Art. 6 Abs. 1 lit. e oder f DSGVO erfolgt, Widerspruch einzulegen; '
                                'dies gilt auch für ein auf diese Bestimmungen gestütztes Profiling. Werden die Sie betreffenden personenbezogenen Daten verarbeitet, um '
                                'Direktwerbung zu betreiben, haben Sie das Recht, jederzeit Widerspruch gegen die Verarbeitung der Sie betreffenden personenbezogenen Daten zum '
                                'Zwecke derartiger Werbung einzulegen; dies gilt auch für das Profiling, soweit es mit solcher Direktwerbung in Verbindung steht.\n',
                                style: const TextStyle(fontWeight: FontWeight.bold)),

                            const TextSpan(text: '•	Widerrufsrecht bei Einwilligungen: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Sie haben das Recht, erteilte Einwilligungen jederzeit zu widerrufen.\n'),
                            const TextSpan(text: '•	Auskunftsrecht: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Sie haben das Recht, eine Bestätigung darüber zu verlangen, ob betreffende Daten verarbeitet werden und auf Auskunft '
                                'über diese Daten sowie auf weitere Informationen und Kopie der Daten entsprechend den gesetzlichen Vorgaben.\n'),
                            const TextSpan(text: '•	Recht auf Berichtigung: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Sie haben entsprechend den gesetzlichen Vorgaben das Recht, die Vervollständigung der Sie betreffenden Daten oder die '
                                'Berichtigung der Sie betreffenden unrichtigen Daten zu verlangen.\n'),
                            const TextSpan(text: '•	Recht auf Löschung und Einschränkung der Verarbeitung: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Sie haben nach Maßgabe der gesetzlichen Vorgaben das Recht, zu verlangen, dass Sie betreffende Daten unverzüglich gelöscht '
                                'werden, bzw. alternativ nach Maßgabe der gesetzlichen Vorgaben eine Einschränkung der Verarbeitung der Daten zu verlangen.\n'),
                            const TextSpan(text: '•	Recht auf Datenübertragbarkeit: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Sie haben das Recht, Sie betreffende Daten, die Sie uns bereitgestellt haben, nach Maßgabe der gesetzlichen Vorgaben in '
                                'einem strukturierten, gängigen und maschinenlesbaren Format zu erhalten oder deren Übermittlung an einen anderen Verantwortlichen zu fordern.\n'),
                            const TextSpan(text: '•	Beschwerde bei Aufsichtsbehörde: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Sie haben unbeschadet eines anderweitigen verwaltungsrechtlichen oder gerichtlichen Rechtsbehelfs das Recht auf Beschwerde '
                                'bei einer Aufsichtsbehörde, insbesondere in dem Mitgliedstaat ihres gewöhnlichen Aufenthaltsorts, ihres Arbeitsplatzes oder des Orts des '
                                'mutmaßlichen Verstoßes, wenn Sie der Ansicht sind, dass die Verarbeitung der Sie betreffenden personenbezogenen Daten gegen die Vorgaben der '
                                'DSGVO verstößt.\n\n'),

                            const TextSpan(text: 'Begriffsdefinitionen\n\n', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const TextSpan(text: 'In diesem Abschnitt erhalten Sie eine Übersicht über die in dieser Datenschutzerklärung verwendeten Begrifflichkeiten. '
                                'Viele der Begriffe sind dem Gesetz entnommen und vor allem im Art. 4 DSGVO definiert. Die gesetzlichen Definitionen sind verbindlich. '
                                'Die nachfolgenden Erläuterungen sollen dagegen vor allem dem Verständnis dienen. Die Begriffe sind alphabetisch sortiert.\n\n'),
                            const TextSpan(text: '•	Personenbezogene Daten: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: '"Personenbezogene Daten“ sind alle Informationen, die sich auf eine identifizierte oder identifizierbare natürliche Person '
                                '(im Folgenden "betroffene Person“) beziehen; als identifizierbar wird eine natürliche Person angesehen, die direkt oder indirekt, insbesondere '
                                'mittels Zuordnung zu einer Kennung wie einem Namen, zu einer Kennnummer, zu Standortdaten, zu einer Online-Kennung (z.B. Cookie) oder zu einem '
                                'oder mehreren besonderen Merkmalen identifiziert werden kann, die Ausdruck der physischen, physiologischen, genetischen, psychischen, '
                                'wirtschaftlichen, kulturellen oder sozialen Identität dieser natürlichen Person sind. \n'),
                            const TextSpan(text: '•	Verantwortlicher: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Als "Verantwortlicher“ wird die natürliche oder juristische Person, Behörde, Einrichtung oder andere Stelle, die allein oder '
                                'gemeinsam mit anderen über die Zwecke und Mittel der Verarbeitung von personenbezogenen Daten entscheidet, bezeichnet.\n'),
                            const TextSpan(text: '•	Verarbeitung: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: '"Verarbeitung" ist jeder mit oder ohne Hilfe automatisierter Verfahren ausgeführte Vorgang oder jede solche Vorgangsreihe im '
                                'Zusammenhang mit personenbezogenen Daten. Der Begriff reicht weit und umfasst praktisch jeden Umgang mit Daten, sei es das Erheben, das Auswerten, '
                                'das Speichern, das Übermitteln oder das Löschen. \n'),
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