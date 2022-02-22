import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:justcast_app/screen/datasecure.dart';
import 'package:justcast_app/screen/impressum.dart';
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
                const SizedBox(
                  width: 50,
                ),
                Image.asset(
                  isDarkMode
                      ? 'assets/images/logo_white.png'
                      : 'assets/images/logo_black.png',
                  fit: BoxFit.contain,
                  height: 80,
                ),
              ]
          ),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("Meine Anfragen"),
                  ),
                  if(isCaster == true)
                    const PopupMenuItem<int>(
                      value: 4,
                      child: Text("Angefragte Spiele"),
                    ),
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
                  const PopupMenuItem<int>(
                    value: 3,
                    child: Text("Logout"),
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
                      text: TextSpan(
                          children: <TextSpan>[
                            const TextSpan(text: 'Angaben gemäß § 5 TMG \n\n'),
                            const TextSpan(text: 'JustCast\n', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Inh.: Christian Steinbach\n'),
                            const TextSpan(text: 'Stettener Weg 2\n'),
                            const TextSpan(text: '89584 Ehingen\n\n'),

                            const TextSpan(text: 'Kontakt\n', style: TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Telefon: 07391-7816405\n'),
                            const TextSpan(text: 'E-Mail: team@justcast.org\n\n'),

                            const TextSpan(text: 'Vertreten durch:', style: TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Fabian Groß\n'),
                            const TextSpan(text: 'Dorfstraße 13\n'),
                            const TextSpan(text: '52076 Aachen\n\n'),

                            const TextSpan(text: 'EU-Streitschlichtung', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Die Europäische Kommission stellt eine Plattform zur Online-Streitbeilegung (OS) bereit:'),
                            TextSpan(text:'https://ec.europa.eu/consumers/odr.', style: const TextStyle(color: Colors.blue), recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final url = 'https://ec.europa.eu/consumers/odr';
                                if (await canLaunch(url)) {
                                  await launch(
                                    url,
                                    forceSafariVC: false,
                                  );
                                }
                              },
                            ),
                            const TextSpan(text: 'Unsere E-Mail-Adresse finden Sie oben im Impressum.\n\n'),

                            const TextSpan(text: 'Verbraucherstreitbeilegung/Universalschlichtungsstelle', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Wir sind nicht bereit oder verpflichtet, an Streitbeilegungsverfahren vor einer Verbraucherschlichtungsstelle teilzunehmen.\n\n'),

                            const TextSpan(text: 'Haftung für Inhalte', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Als Diensteanbieter sind wir gemäß § 7 Abs.1 TMG für eigene Inhalte auf diesen Seiten nach den allgemeinen Gesetzen verantwortlich. '
                                'Nach §§ 8 bis 10 TMG sind wir als Diensteanbieter jedoch nicht verpflichtet, übermittelte oder gespeicherte fremde Informationen zu überwachen oder nach Umständen '
                                'zu forschen, die auf eine rechtswidrige Tätigkeit hinweisen. Verpflichtungen zur Entfernung oder Sperrung der Nutzung von Informationen nach den allgemeinen '
                                'Gesetzen bleiben hiervon unberührt. Eine diesbezügliche Haftung ist jedoch erst ab dem Zeitpunkt der Kenntnis einer konkreten Rechtsverletzung möglich. '
                                'Bei Bekanntwerden von entsprechenden Rechtsverletzungen werden wir diese Inhalte umgehend entfernen.\n\n'),

                            const TextSpan(text: 'Haftung für Links', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Unser Angebot enthält Links zu externen Websites Dritter, auf deren Inhalte wir keinen Einfluss haben. Deshalb können wir für diese fremden Inhalte '
                                'auch keine Gewähr übernehmen. Für die Inhalte der verlinkten Seiten ist stets der jeweilige Anbieter oder Betreiber der Seiten verantwortlich. Die verlinkten Seiten '
                                'wurden zum Zeitpunkt der Verlinkung auf mögliche Rechtsverstöße überprüft. Rechtswidrige Inhalte waren zum Zeitpunkt der Verlinkung nicht erkennbar. Eine permanente '
                                'inhaltliche Kontrolle der verlinkten Seiten ist jedoch ohne konkrete Anhaltspunkte einer Rechtsverletzung nicht zumutbar. Bei Bekanntwerden von Rechtsverletzungen '
                                'werden wir derartige Links umgehend entfernen.\n\n'),

                            const TextSpan(text: 'Urheberrecht', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(text: 'Die durch die Seitenbetreiber erstellten Inhalte und Werke auf diesen Seiten unterliegen dem deutschen Urheberrecht. Die Vervielfältigung, '
                                'Bearbeitung, Verbreitung und jede Art der Verwertung außerhalb der Grenzen des Urheberrechtes bedürfen der schriftlichen Zustimmung des jeweiligen Autors bzw. '
                                'Erstellers.Downloads und Kopien dieser Seite sind nur für den privaten, nicht für den kommerziellen gebrauch gestattet.\n\n'),
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