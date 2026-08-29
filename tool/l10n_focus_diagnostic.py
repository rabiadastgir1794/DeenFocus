#!/usr/bin/env python3
"""Localize Focus tab App Lock diagnostic strings in all app_*.arb files."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib" / "l10n"

META = {
    "@focusDiagnosticIntroWithApp": {
        "placeholders": {
            "appName": {"type": "String"},
        },
    },
    "@focusDiagnosticRunning": {
        "placeholders": {
            "seconds": {"type": "int"},
        },
    },
}

EN = {
    "focusDiagnosticButton": "Diagnostic",
    "focusDiagnosticTitle": "Test App Lock",
    "focusDiagnosticIntro": (
        "Temporarily lock your selected apps for 60 seconds using the same "
        "App Lock used by Focus mode. Open a blocked app to confirm the "
        "DeenFocus lock screen appears."
    ),
    "focusDiagnosticIntroWithApp": (
        "Temporarily lock your selected apps for 60 seconds. Try opening "
        "{appName} to confirm the DeenFocus lock screen appears."
    ),
    "focusDiagnosticStart": "Start Test",
    "focusDiagnosticEndEarly": "End Test",
    "focusDiagnosticRunning": (
        "App Lock is on for {seconds}s. Switch to a selected app to test "
        "the lock screen."
    ),
    "focusDiagnosticSuccessTitle": "Test completed",
    "focusDiagnosticSuccessBody": (
        "App Lock was activated with your selected apps. If you saw the "
        "DeenFocus lock screen, App Lock is working."
    ),
    "focusDiagnosticCancelledTitle": "Test ended",
    "focusDiagnosticCancelledBody": (
        "The diagnostic lock was turned off. Your Focus modes and schedules "
        "were not changed."
    ),
    "focusDiagnosticMissingAppsTitle": "Select apps first",
    "focusDiagnosticMissingAppsBody": (
        "Choose at least one app to block before running the App Lock test."
    ),
    "focusDiagnosticMissingPermissionTitle": "Permission needed",
    "focusDiagnosticMissingPermissionBodyIos": (
        "Screen Time access is required to block apps. Allow Screen Time, "
        "then try again."
    ),
    "focusDiagnosticMissingPermissionBodyAndroid": (
        "Android Accessibility must be enabled for DeenFocus so App Lock "
        "can block selected apps."
    ),
    "focusDiagnosticFailedTitle": "Could not start test",
    "focusDiagnosticFailedBody": (
        "App Lock did not activate. Check permissions and selected apps, "
        "then try again."
    ),
    "focusDiagnosticClose": "Done",
    **META,
}

TRANSLATIONS: dict[str, dict] = {
    "en": EN,
    "ar": {
        **EN,
        "focusDiagnosticButton": "تشخيص",
        "focusDiagnosticTitle": "اختبار قفل التطبيقات",
        "focusDiagnosticIntro": (
            "اقفلي التطبيقات المحددة مؤقتًا لمدة 60 ثانية باستخدام نفس قفل "
            "التطبيقات في وضع التركيز. افتحي تطبيقًا محظورًا للتأكد من ظهور "
            "شاشة قفل DeenFocus."
        ),
        "focusDiagnosticIntroWithApp": (
            "اقفلي التطبيقات المحددة مؤقتًا لمدة 60 ثانية. جرّبي فتح "
            "{appName} للتأكد من ظهور شاشة قفل DeenFocus."
        ),
        "focusDiagnosticStart": "بدء الاختبار",
        "focusDiagnosticEndEarly": "إنهاء الاختبار",
        "focusDiagnosticRunning": (
            "قفل التطبيقات مفعّل لمدة {seconds} ثانية. انتقلي إلى أحد "
            "التطبيقات المحددة لاختبار شاشة القفل."
        ),
        "focusDiagnosticSuccessTitle": "اكتمل الاختبار",
        "focusDiagnosticSuccessBody": (
            "تم تفعيل قفل التطبيقات للتطبيقات المحددة. إذا ظهرت شاشة قفل "
            "DeenFocus، فالقفل يعمل بشكل صحيح."
        ),
        "focusDiagnosticCancelledTitle": "انتهى الاختبار",
        "focusDiagnosticCancelledBody": (
            "تم إيقاف قفل التشخيص. لم تتغير أوضاع التركيز أو الجداول."
        ),
        "focusDiagnosticMissingAppsTitle": "اختر التطبيقات أولًا",
        "focusDiagnosticMissingAppsBody": (
            "اختر تطبيقًا واحدًا على الأقل للحظر قبل تشغيل اختبار قفل "
            "التطبيقات."
        ),
        "focusDiagnosticMissingPermissionTitle": "يلزم إذن",
        "focusDiagnosticMissingPermissionBodyIos": (
            "يلزم الوصول إلى وقت الشاشة لحظر التطبيقات. اسمحي بوقت الشاشة "
            "ثم حاولي مرة أخرى."
        ),
        "focusDiagnosticMissingPermissionBodyAndroid": (
            "يجب تفعيل إمكانية الوصول لـ DeenFocus على Android حتى يعمل "
            "قفل التطبيقات."
        ),
        "focusDiagnosticFailedTitle": "تعذر بدء الاختبار",
        "focusDiagnosticFailedBody": (
            "لم يُفعَّل قفل التطبيقات. تحققي من الأذونات والتطبيقات "
            "المحددة ثم حاولي مرة أخرى."
        ),
        "focusDiagnosticClose": "تم",
    },
    "de": {
        **EN,
        "focusDiagnosticButton": "Diagnose",
        "focusDiagnosticTitle": "App-Sperre testen",
        "focusDiagnosticIntro": (
            "Sperre deine ausgewählten Apps 60 Sekunden lang vorübergehend "
            "mit derselben App-Sperre wie im Fokusmodus. Öffne eine "
            "gesperrte App, um zu prüfen, ob der DeenFocus-Sperrbildschirm "
            "erscheint."
        ),
        "focusDiagnosticIntroWithApp": (
            "Sperre deine ausgewählten Apps 60 Sekunden lang vorübergehend. "
            "Öffne {appName}, um zu prüfen, ob der DeenFocus-Sperrbildschirm "
            "erscheint."
        ),
        "focusDiagnosticStart": "Test starten",
        "focusDiagnosticEndEarly": "Test beenden",
        "focusDiagnosticRunning": (
            "App-Sperre ist für {seconds}s aktiv. Wechsle zu einer "
            "ausgewählten App, um den Sperrbildschirm zu testen."
        ),
        "focusDiagnosticSuccessTitle": "Test abgeschlossen",
        "focusDiagnosticSuccessBody": (
            "App-Sperre wurde mit deinen ausgewählten Apps aktiviert. Wenn du "
            "den DeenFocus-Sperrbildschirm gesehen hast, funktioniert die "
            "App-Sperre."
        ),
        "focusDiagnosticCancelledTitle": "Test beendet",
        "focusDiagnosticCancelledBody": (
            "Die Diagnose-Sperre wurde ausgeschaltet. Deine Fokusmodi und "
            "Zeitpläne wurden nicht geändert."
        ),
        "focusDiagnosticMissingAppsTitle": "Zuerst Apps auswählen",
        "focusDiagnosticMissingAppsBody": (
            "Wähle mindestens eine App zum Sperren, bevor du den "
            "App-Sperre-Test startest."
        ),
        "focusDiagnosticMissingPermissionTitle": "Berechtigung erforderlich",
        "focusDiagnosticMissingPermissionBodyIos": (
            "Bildschirmzeit-Zugriff ist zum Sperren von Apps erforderlich. "
            "Erlaube Bildschirmzeit und versuche es erneut."
        ),
        "focusDiagnosticMissingPermissionBodyAndroid": (
            "Android-Bedienungshilfen müssen für DeenFocus aktiviert sein, "
            "damit App-Sperre funktioniert."
        ),
        "focusDiagnosticFailedTitle": "Test konnte nicht gestartet werden",
        "focusDiagnosticFailedBody": (
            "App-Sperre wurde nicht aktiviert. Prüfe Berechtigungen und "
            "ausgewählte Apps und versuche es erneut."
        ),
        "focusDiagnosticClose": "Fertig",
    },
    "es": {
        **EN,
        "focusDiagnosticButton": "Diagnóstico",
        "focusDiagnosticTitle": "Probar bloqueo de apps",
        "focusDiagnosticIntro": (
            "Bloquea temporalmente tus apps seleccionadas durante 60 segundos "
            "con el mismo bloqueo del modo Enfoque. Abre una app bloqueada "
            "para confirmar que aparece la pantalla de bloqueo de DeenFocus."
        ),
        "focusDiagnosticIntroWithApp": (
            "Bloquea temporalmente tus apps seleccionadas durante 60 segundos. "
            "Prueba abrir {appName} para confirmar que aparece la pantalla "
            "de bloqueo de DeenFocus."
        ),
        "focusDiagnosticStart": "Iniciar prueba",
        "focusDiagnosticEndEarly": "Terminar prueba",
        "focusDiagnosticRunning": (
            "El bloqueo está activo durante {seconds}s. Cambia a una app "
            "seleccionada para probar la pantalla de bloqueo."
        ),
        "focusDiagnosticSuccessTitle": "Prueba completada",
        "focusDiagnosticSuccessBody": (
            "El bloqueo se activó con tus apps seleccionadas. Si viste la "
            "pantalla de bloqueo de DeenFocus, el bloqueo funciona."
        ),
        "focusDiagnosticCancelledTitle": "Prueba finalizada",
        "focusDiagnosticCancelledBody": (
            "Se desactivó el bloqueo de diagnóstico. Tus modos y horarios "
            "de Enfoque no cambiaron."
        ),
        "focusDiagnosticMissingAppsTitle": "Selecciona apps primero",
        "focusDiagnosticMissingAppsBody": (
            "Elige al menos una app para bloquear antes de ejecutar la prueba."
        ),
        "focusDiagnosticMissingPermissionTitle": "Permiso necesario",
        "focusDiagnosticMissingPermissionBodyIos": (
            "Se requiere acceso a Tiempo en pantalla. Permítelo e inténtalo "
            "de nuevo."
        ),
        "focusDiagnosticMissingPermissionBodyAndroid": (
            "Debes activar Accesibilidad para DeenFocus en Android para "
            "bloquear apps."
        ),
        "focusDiagnosticFailedTitle": "No se pudo iniciar la prueba",
        "focusDiagnosticFailedBody": (
            "El bloqueo no se activó. Revisa permisos y apps seleccionadas "
            "e inténtalo de nuevo."
        ),
        "focusDiagnosticClose": "Listo",
    },
    "fr": {
        **EN,
        "focusDiagnosticButton": "Diagnostic",
        "focusDiagnosticTitle": "Tester le verrouillage",
        "focusDiagnosticIntro": (
            "Verrouille temporairement tes apps sélectionnées pendant "
            "60 secondes avec le même verrouillage que le mode Focus. "
            "Ouvre une app bloquée pour confirmer l'écran de verrouillage "
            "DeenFocus."
        ),
        "focusDiagnosticIntroWithApp": (
            "Verrouille temporairement tes apps sélectionnées pendant "
            "60 secondes. Essaie d'ouvrir {appName} pour confirmer "
            "l'écran de verrouillage DeenFocus."
        ),
        "focusDiagnosticStart": "Lancer le test",
        "focusDiagnosticEndEarly": "Arrêter le test",
        "focusDiagnosticRunning": (
            "Verrouillage actif pendant {seconds}s. Passe à une app "
            "sélectionnée pour tester l'écran de verrouillage."
        ),
        "focusDiagnosticSuccessTitle": "Test terminé",
        "focusDiagnosticSuccessBody": (
            "Le verrouillage a été activé avec tes apps sélectionnées. "
            "Si tu as vu l'écran DeenFocus, le verrouillage fonctionne."
        ),
        "focusDiagnosticCancelledTitle": "Test arrêté",
        "focusDiagnosticCancelledBody": (
            "Le verrouillage de diagnostic a été désactivé. Tes modes "
            "Focus et horaires n'ont pas changé."
        ),
        "focusDiagnosticMissingAppsTitle": "Sélectionne des apps d'abord",
        "focusDiagnosticMissingAppsBody": (
            "Choisis au moins une app à bloquer avant de lancer le test."
        ),
        "focusDiagnosticMissingPermissionTitle": "Autorisation requise",
        "focusDiagnosticMissingPermissionBodyIos": (
            "L'accès Temps d'écran est requis. Autorise-le puis réessaie."
        ),
        "focusDiagnosticMissingPermissionBodyAndroid": (
            "L'accessibilité Android doit être activée pour DeenFocus "
            "afin de bloquer les apps."
        ),
        "focusDiagnosticFailedTitle": "Impossible de lancer le test",
        "focusDiagnosticFailedBody": (
            "Le verrouillage ne s'est pas activé. Vérifie les autorisations "
            "et les apps sélectionnées, puis réessaie."
        ),
        "focusDiagnosticClose": "Terminé",
    },
    "hi": {
        **EN,
        "focusDiagnosticButton": "निदान",
        "focusDiagnosticTitle": "ऐप लॉक का परीक्षण",
        "focusDiagnosticIntro": (
            "फ़ोकस मोड वाले उसी ऐप लॉक से 60 सेकंड के लिए चुने हुए ऐप्स "
            "को अस्थायी रूप से लॉक करें। DeenFocus लॉक स्क्रीन दिखे, "
            "इसकी पुष्टि के लिए कोई ब्लॉक किया ऐप खोलें।"
        ),
        "focusDiagnosticIntroWithApp": (
            "60 सेकंड के लिए चुने हुए ऐप्स को अस्थायी रूप से लॉक करें। "
            "DeenFocus लॉक स्क्रीन की पुष्टि के लिए {appName} खोलकर "
            "देखें।"
        ),
        "focusDiagnosticStart": "परीक्षण शुरू करें",
        "focusDiagnosticEndEarly": "परीक्षण समाप्त करें",
        "focusDiagnosticRunning": (
            "ऐप लॉक {seconds} सेकंड के लिए चालू है। लॉक स्क्रीन जाँचने "
            "के लिए किसी चुने हुए ऐप पर जाएँ।"
        ),
        "focusDiagnosticSuccessTitle": "परीक्षण पूरा",
        "focusDiagnosticSuccessBody": (
            "आपके चुने हुए ऐप्स के साथ ऐप लॉक सक्रिय हुआ। यदि DeenFocus "
            "लॉक स्क्रीन दिखी, तो ऐप लॉक काम कर रहा है।"
        ),
        "focusDiagnosticCancelledTitle": "परीक्षण समाप्त",
        "focusDiagnosticCancelledBody": (
            "निदान लॉक बंद कर दिया गया। आपके फ़ोकस मोड और शेड्यूल "
            "नहीं बदले।"
        ),
        "focusDiagnosticMissingAppsTitle": "पहले ऐप्स चुनें",
        "focusDiagnosticMissingAppsBody": (
            "ऐप लॉक परीक्षण से पहले कम से कम एक ऐप ब्लॉक करने के लिए चुनें।"
        ),
        "focusDiagnosticMissingPermissionTitle": "अनुमति आवश्यक",
        "focusDiagnosticMissingPermissionBodyIos": (
            "ऐप्स ब्लॉक करने के लिए स्क्रीन टाइम की अनुमति चाहिए। "
            "अनुमति दें और फिर कोशिश करें।"
        ),
        "focusDiagnosticMissingPermissionBodyAndroid": (
            "ऐप लॉक के लिए Android में DeenFocus की एक्सेसिबिलिटी "
            "सक्षम होनी चाहिए।"
        ),
        "focusDiagnosticFailedTitle": "परीक्षण शुरू नहीं हो सका",
        "focusDiagnosticFailedBody": (
            "ऐप लॉक सक्रिय नहीं हुआ। अनुमतियाँ और चुने ऐप्स जाँचें "
            "और फिर कोशिश करें।"
        ),
        "focusDiagnosticClose": "हो गया",
    },
    "it": {
        **EN,
        "focusDiagnosticButton": "Diagnostica",
        "focusDiagnosticTitle": "Prova blocco app",
        "focusDiagnosticIntro": (
            "Blocca temporaneamente le app selezionate per 60 secondi con "
            "lo stesso blocco del modo Focus. Apri un'app bloccata per "
            "confermare la schermata di blocco DeenFocus."
        ),
        "focusDiagnosticIntroWithApp": (
            "Blocca temporaneamente le app selezionate per 60 secondi. "
            "Prova ad aprire {appName} per confermare la schermata di "
            "blocco DeenFocus."
        ),
        "focusDiagnosticStart": "Avvia test",
        "focusDiagnosticEndEarly": "Termina test",
        "focusDiagnosticRunning": (
            "Blocco app attivo per {seconds}s. Passa a un'app selezionata "
            "per testare la schermata di blocco."
        ),
        "focusDiagnosticSuccessTitle": "Test completato",
        "focusDiagnosticSuccessBody": (
            "Il blocco app è stato attivato con le app selezionate. Se hai "
            "visto la schermata DeenFocus, il blocco funziona."
        ),
        "focusDiagnosticCancelledTitle": "Test terminato",
        "focusDiagnosticCancelledBody": (
            "Il blocco diagnostico è stato disattivato. Modalità Focus e "
            "programmi non sono stati modificati."
        ),
        "focusDiagnosticMissingAppsTitle": "Seleziona prima le app",
        "focusDiagnosticMissingAppsBody": (
            "Scegli almeno un'app da bloccare prima di avviare il test."
        ),
        "focusDiagnosticMissingPermissionTitle": "Autorizzazione necessaria",
        "focusDiagnosticMissingPermissionBodyIos": (
            "È richiesto l'accesso a Tempo di utilizzo. Consenti l'accesso "
            "e riprova."
        ),
        "focusDiagnosticMissingPermissionBodyAndroid": (
            "Su Android devi abilitare l'accessibilità per DeenFocus "
            "per bloccare le app."
        ),
        "focusDiagnosticFailedTitle": "Impossibile avviare il test",
        "focusDiagnosticFailedBody": (
            "Il blocco app non si è attivato. Controlla autorizzazioni e "
            "app selezionate, poi riprova."
        ),
        "focusDiagnosticClose": "Fine",
    },
    "nl": {
        **EN,
        "focusDiagnosticButton": "Diagnose",
        "focusDiagnosticTitle": "App-vergrendeling testen",
        "focusDiagnosticIntro": (
            "Vergrendel je geselecteerde apps tijdelijk 60 seconden met "
            "dezelfde app-vergrendeling als in Focusmodus. Open een "
            "geblokkeerde app om te controleren of het DeenFocus "
            "vergrendelscherm verschijnt."
        ),
        "focusDiagnosticIntroWithApp": (
            "Vergrendel je geselecteerde apps tijdelijk 60 seconden. "
            "Open {appName} om te controleren of het DeenFocus "
            "vergrendelscherm verschijnt."
        ),
        "focusDiagnosticStart": "Test starten",
        "focusDiagnosticEndEarly": "Test beëindigen",
        "focusDiagnosticRunning": (
            "App-vergrendeling staat {seconds}s aan. Schakel naar een "
            "geselecteerde app om het vergrendelscherm te testen."
        ),
        "focusDiagnosticSuccessTitle": "Test voltooid",
        "focusDiagnosticSuccessBody": (
            "App-vergrendeling is geactiveerd met je geselecteerde apps. "
            "Als je het DeenFocus-vergrendelscherm zag, werkt het."
        ),
        "focusDiagnosticCancelledTitle": "Test beëindigd",
        "focusDiagnosticCancelledBody": (
            "De diagnostische vergrendeling is uitgeschakeld. Je "
            "Focusmodi en schema's zijn niet gewijzigd."
        ),
        "focusDiagnosticMissingAppsTitle": "Selecteer eerst apps",
        "focusDiagnosticMissingAppsBody": (
            "Kies minstens één app om te blokkeren voordat je de test start."
        ),
        "focusDiagnosticMissingPermissionTitle": "Toestemming vereist",
        "focusDiagnosticMissingPermissionBodyIos": (
            "Schermtijd-toegang is vereist. Sta Schermtijd toe en "
            "probeer opnieuw."
        ),
        "focusDiagnosticMissingPermissionBodyAndroid": (
            "Android-toegankelijkheid moet voor DeenFocus zijn ingeschakeld "
            "om apps te blokkeren."
        ),
        "focusDiagnosticFailedTitle": "Test kon niet starten",
        "focusDiagnosticFailedBody": (
            "App-vergrendeling is niet geactiveerd. Controleer "
            "toestemmingen en geselecteerde apps en probeer opnieuw."
        ),
        "focusDiagnosticClose": "Klaar",
    },
    "pt": {
        **EN,
        "focusDiagnosticButton": "Diagnóstico",
        "focusDiagnosticTitle": "Testar bloqueio de apps",
        "focusDiagnosticIntro": (
            "Bloqueie temporariamente os apps selecionados por 60 segundos "
            "com o mesmo bloqueio do modo Foco. Abra um app bloqueado "
            "para confirmar a tela de bloqueio do DeenFocus."
        ),
        "focusDiagnosticIntroWithApp": (
            "Bloqueie temporariamente os apps selecionados por 60 segundos. "
            "Tente abrir {appName} para confirmar a tela de bloqueio "
            "do DeenFocus."
        ),
        "focusDiagnosticStart": "Iniciar teste",
        "focusDiagnosticEndEarly": "Encerrar teste",
        "focusDiagnosticRunning": (
            "Bloqueio ativo por {seconds}s. Mude para um app selecionado "
            "para testar a tela de bloqueio."
        ),
        "focusDiagnosticSuccessTitle": "Teste concluído",
        "focusDiagnosticSuccessBody": (
            "O bloqueio foi ativado com seus apps selecionados. Se você "
            "viu a tela do DeenFocus, o bloqueio está funcionando."
        ),
        "focusDiagnosticCancelledTitle": "Teste encerrado",
        "focusDiagnosticCancelledBody": (
            "O bloqueio de diagnóstico foi desativado. Seus modos Foco "
            "e horários não foram alterados."
        ),
        "focusDiagnosticMissingAppsTitle": "Selecione apps primeiro",
        "focusDiagnosticMissingAppsBody": (
            "Escolha pelo menos um app para bloquear antes de iniciar o teste."
        ),
        "focusDiagnosticMissingPermissionTitle": "Permissão necessária",
        "focusDiagnosticMissingPermissionBodyIos": (
            "É necessário acesso ao Tempo de Uso. Permita e tente novamente."
        ),
        "focusDiagnosticMissingPermissionBodyAndroid": (
            "A acessibilidade do Android deve estar ativada para o "
            "DeenFocus bloquear apps."
        ),
        "focusDiagnosticFailedTitle": "Não foi possível iniciar o teste",
        "focusDiagnosticFailedBody": (
            "O bloqueio não foi ativado. Verifique permissões e apps "
            "selecionados e tente novamente."
        ),
        "focusDiagnosticClose": "Concluir",
    },
    "ro": {
        **EN,
        "focusDiagnosticButton": "Diagnostic",
        "focusDiagnosticTitle": "Testează blocarea aplicațiilor",
        "focusDiagnosticIntro": (
            "Blochează temporar aplicațiile selectate timp de 60 de secunde "
            "cu aceeași blocare ca în modul Focus. Deschide o aplicație "
            "blocată pentru a confirma ecranul de blocare DeenFocus."
        ),
        "focusDiagnosticIntroWithApp": (
            "Blochează temporar aplicațiile selectate timp de 60 de secunde. "
            "Încearcă să deschizi {appName} pentru a confirma ecranul "
            "de blocare DeenFocus."
        ),
        "focusDiagnosticStart": "Pornește testul",
        "focusDiagnosticEndEarly": "Oprește testul",
        "focusDiagnosticRunning": (
            "Blocarea este activă {seconds}s. Comută la o aplicație "
            "selectată pentru a testa ecranul de blocare."
        ),
        "focusDiagnosticSuccessTitle": "Test finalizat",
        "focusDiagnosticSuccessBody": (
            "Blocarea a fost activată cu aplicațiile selectate. Dacă ai "
            "văzut ecranul DeenFocus, blocarea funcționează."
        ),
        "focusDiagnosticCancelledTitle": "Test oprit",
        "focusDiagnosticCancelledBody": (
            "Blocarea de diagnostic a fost oprită. Modurile Focus și "
            "programele nu au fost modificate."
        ),
        "focusDiagnosticMissingAppsTitle": "Selectează aplicații mai întâi",
        "focusDiagnosticMissingAppsBody": (
            "Alege cel puțin o aplicație de blocat înainte de test."
        ),
        "focusDiagnosticMissingPermissionTitle": "Permisiune necesară",
        "focusDiagnosticMissingPermissionBodyIos": (
            "Este necesar accesul la Timp de ecran. Permite accesul "
            "și încearcă din nou."
        ),
        "focusDiagnosticMissingPermissionBodyAndroid": (
            "Accesibilitatea Android trebuie activată pentru DeenFocus "
            "ca să blocheze aplicații."
        ),
        "focusDiagnosticFailedTitle": "Testul nu a putut porni",
        "focusDiagnosticFailedBody": (
            "Blocarea nu s-a activat. Verifică permisiunile și "
            "aplicațiile selectate, apoi încearcă din nou."
        ),
        "focusDiagnosticClose": "Gata",
    },
    "ru": {
        **EN,
        "focusDiagnosticButton": "Диагностика",
        "focusDiagnosticTitle": "Проверка блокировки",
        "focusDiagnosticIntro": (
            "Временно заблокируйте выбранные приложения на 60 секунд той же "
            "блокировкой, что и в режиме Фокус. Откройте заблокированное "
            "приложение, чтобы убедиться, что появляется экран DeenFocus."
        ),
        "focusDiagnosticIntroWithApp": (
            "Временно заблокируйте выбранные приложения на 60 секунд. "
            "Попробуйте открыть {appName}, чтобы проверить экран "
            "блокировки DeenFocus."
        ),
        "focusDiagnosticStart": "Начать тест",
        "focusDiagnosticEndEarly": "Завершить тест",
        "focusDiagnosticRunning": (
            "Блокировка активна {seconds} с. Перейдите в выбранное "
            "приложение, чтобы проверить экран блокировки."
        ),
        "focusDiagnosticSuccessTitle": "Тест завершён",
        "focusDiagnosticSuccessBody": (
            "Блокировка активирована для выбранных приложений. Если вы "
            "увидели экран DeenFocus, блокировка работает."
        ),
        "focusDiagnosticCancelledTitle": "Тест остановлен",
        "focusDiagnosticCancelledBody": (
            "Диагностическая блокировка отключена. Режимы Фокус и "
            "расписания не изменены."
        ),
        "focusDiagnosticMissingAppsTitle": "Сначала выберите приложения",
        "focusDiagnosticMissingAppsBody": (
            "Выберите хотя бы одно приложение для блокировки перед тестом."
        ),
        "focusDiagnosticMissingPermissionTitle": "Нужно разрешение",
        "focusDiagnosticMissingPermissionBodyIos": (
            "Для блокировки нужен доступ к «Экранному времени». "
            "Разрешите доступ и повторите."
        ),
        "focusDiagnosticMissingPermissionBodyAndroid": (
            "Для блокировки приложений включите специальные возможности "
            "DeenFocus в Android."
        ),
        "focusDiagnosticFailedTitle": "Не удалось начать тест",
        "focusDiagnosticFailedBody": (
            "Блокировка не активировалась. Проверьте разрешения и "
            "выбранные приложения и повторите."
        ),
        "focusDiagnosticClose": "Готово",
    },
    "zh": {
        **EN,
        "focusDiagnosticButton": "诊断",
        "focusDiagnosticTitle": "测试应用锁定",
        "focusDiagnosticIntro": (
            "使用与专注模式相同的应用锁定，暂时锁定所选应用 60 秒。"
            "打开被锁定的应用，确认 DeenFocus 锁定屏幕是否出现。"
        ),
        "focusDiagnosticIntroWithApp": (
            "暂时锁定所选应用 60 秒。尝试打开 {appName}，"
            "确认 DeenFocus 锁定屏幕是否出现。"
        ),
        "focusDiagnosticStart": "开始测试",
        "focusDiagnosticEndEarly": "结束测试",
        "focusDiagnosticRunning": (
            "应用锁定已开启 {seconds} 秒。切换到所选应用以测试锁定屏幕。"
        ),
        "focusDiagnosticSuccessTitle": "测试完成",
        "focusDiagnosticSuccessBody": (
            "已对你选择的应用启用锁定。若看到 DeenFocus 锁定屏幕，"
            "说明应用锁定正常工作。"
        ),
        "focusDiagnosticCancelledTitle": "测试已结束",
        "focusDiagnosticCancelledBody": (
            "诊断锁定已关闭。你的专注模式和时间表未更改。"
        ),
        "focusDiagnosticMissingAppsTitle": "请先选择应用",
        "focusDiagnosticMissingAppsBody": (
            "运行应用锁定测试前，请至少选择一个要阻止的应用。"
        ),
        "focusDiagnosticMissingPermissionTitle": "需要权限",
        "focusDiagnosticMissingPermissionBodyIos": (
            "阻止应用需要屏幕使用时间权限。请允许后重试。"
        ),
        "focusDiagnosticMissingPermissionBodyAndroid": (
            "必须在 Android 中为 DeenFocus 启用无障碍服务，"
            "才能阻止应用。"
        ),
        "focusDiagnosticFailedTitle": "无法开始测试",
        "focusDiagnosticFailedBody": (
            "应用锁定未激活。请检查权限和所选应用后重试。"
        ),
        "focusDiagnosticClose": "完成",
    },
    "az": {
        **EN,
        "focusDiagnosticButton": "Diaqnostika",
        "focusDiagnosticTitle": "Tətbiq kilidini sına",
        "focusDiagnosticIntro": (
            "Seçilmiş tətbiqləri Fokus rejimindəki eyni tətbiq kilidi ilə "
            "60 saniyəlik müvəqqəti kilidləyin. DeenFocus kilid ekranının "
            "göründüyünü yoxlamaq üçün bloklanmış tətbiqi açın."
        ),
        "focusDiagnosticIntroWithApp": (
            "Seçilmiş tətbiqləri 60 saniyəlik müvəqqəti kilidləyin. "
            "DeenFocus kilid ekranını yoxlamaq üçün {appName} açmağa "
            "cəhd edin."
        ),
        "focusDiagnosticStart": "Testi başlat",
        "focusDiagnosticEndEarly": "Testi bitir",
        "focusDiagnosticRunning": (
            "Tətbiq kilidi {seconds} saniyə aktivdir. Kilid ekranını "
            "sınamaq üçün seçilmiş tətbiqə keçin."
        ),
        "focusDiagnosticSuccessTitle": "Test tamamlandı",
        "focusDiagnosticSuccessBody": (
            "Seçilmiş tətbiqlərlə tətbiq kilidi aktivləşdirildi. "
            "DeenFocus kilid ekranını gördünüzsə, kilid işləyir."
        ),
        "focusDiagnosticCancelledTitle": "Test bitdi",
        "focusDiagnosticCancelledBody": (
            "Diaqnostik kilid söndürüldü. Fokus rejimləriniz və "
            "cədvəlləriniz dəyişmədi."
        ),
        "focusDiagnosticMissingAppsTitle": "Əvvəlcə tətbiqləri seçin",
        "focusDiagnosticMissingAppsBody": (
            "Testdən əvvəl bloklamaq üçün ən azı bir tətbiq seçin."
        ),
        "focusDiagnosticMissingPermissionTitle": "İcazə lazımdır",
        "focusDiagnosticMissingPermissionBodyIos": (
            "Tətbiqləri bloklamaq üçün Ekran vaxtı icazəsi lazımdır. "
            "İcazə verin və yenidən cəhd edin."
        ),
        "focusDiagnosticMissingPermissionBodyAndroid": (
            "Tətbiq kilidi üçün Android-də DeenFocus əlçatanlığı "
            "aktiv olmalıdır."
        ),
        "focusDiagnosticFailedTitle": "Test başladıla bilmədi",
        "focusDiagnosticFailedBody": (
            "Tətbiq kilidi aktivləşmədi. İcazələri və seçilmiş "
            "tətbiqləri yoxlayın və yenidən cəhd edin."
        ),
        "focusDiagnosticClose": "Hazırdır",
    },
}


def main() -> None:
    for locale, entries in TRANSLATIONS.items():
        path = ROOT / f"app_{locale}.arb"
        with path.open(encoding="utf-8") as f:
            data = json.load(f)
        for key, value in entries.items():
            data[key] = value
        with path.open("w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
            f.write("\n")
        print(f"Updated {path.name}")


if __name__ == "__main__":
    main()
