#!/usr/bin/env python3
"""Upsert Settings About v2 l10n keys into all ARBs after settingsAboutFooter."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib" / "l10n"
ANCHOR = "settingsAboutFooter"
MARKER = "settingsAboutOffersHeading"

EN = {
    "settingsAboutFooter": "Stay consistent. Stay mindful. Stay connected to your Deen.",
    "settingsAboutOffersHeading": "What Deen Focus offers",
    "settingsAboutNewBadge": "New",
    "settingsAboutFooterCard":
        "Smart tools to help you stay mindful, consistent, and connected to your Deen — every day.",
    "settingsAboutOfferPrayerTimesTitle": "Accurate Prayer Times",
    "settingsAboutOfferPrayerTimesSubtitle":
        "Timely prayer alerts and beautiful widgets to keep you on track.",
    "settingsAboutOfferPrayerStreaksTitle": "Prayer Streaks",
    "settingsAboutOfferPrayerStreaksSubtitle":
        "Build consistency and grow in your Deen with daily and overall streak tracking.",
    "settingsAboutOfferCycleModeTitle": "Cycle Mode",
    "settingsAboutOfferCycleModeSubtitle":
        "For menstruation — pause prayers, keep your streak, and maintain your journey.",
    "settingsAboutOfferQuranTajweedTitle": "Al Quran Tajweed",
    "settingsAboutOfferQuranTajweedSubtitle":
        "Read, listen, and practice Tajweed with our AI-powered real-time feedback.",
    "settingsAboutOfferLiveActivitiesTitle": "Live Activities",
    "settingsAboutOfferLiveActivitiesSubtitle":
        "Stay updated with ongoing prayers and focus sessions right from your Lock Screen.",
    "settingsAboutOfferQiblaTitle": "Qibla & Masjid Finder",
    "settingsAboutOfferQiblaSubtitle":
        "Find Qibla direction anytime and discover nearby mosques wherever you are.",
    "settingsAboutOfferFocusModesTitle": "Focus Modes",
    "settingsAboutOfferFocusModesSubtitle":
        "Block distracting apps during Salah, sleep, study, or family time.",
    "settingsAboutOfferTasbihTitle": "Tasbih & Dhikr",
    "settingsAboutOfferTasbihSubtitle":
        "Digital Tasbih to help you remember Allah throughout the day.",
    "settingsAboutOfferCalendarTitle": "Islamic Calendar",
    "settingsAboutOfferCalendarSubtitle":
        "Hijri calendar with important Islamic dates and reminders.",
    "settingsAboutGridNamesTitle": "99 Names of Allah",
    "settingsAboutGridNamesSubtitle": "Learn and reflect on Asma ul-Husna.",
    "settingsAboutGridDuasTitle": "Duas & Adhkar",
    "settingsAboutGridDuasSubtitle": "Morning, evening and daily duas.",
    "settingsAboutGridPrayerTitle": "Prayer & Methods",
    "settingsAboutGridPrayerSubtitle": "Learn Salah, Wudu, Hajj and more.",
    "settingsAboutGridFiqhTitle": "Fiqh & Traditions",
    "settingsAboutGridFiqhSubtitle": "Explore authentic Islamic knowledge.",
}

TRANSLATIONS: dict[str, dict[str, str]] = {
    "en": EN,
    "ar": {
        **EN,
        "settingsAboutFooter": "ابقَ ثابتًا. كن واعيًا. ابقَ متصلاً بدينك.",
        "settingsAboutOffersHeading": "ما يقدمه دين فوكس",
        "settingsAboutNewBadge": "جديد",
        "settingsAboutFooterCard":
            "أدوات ذكية لمساعدتك على البقاء واعيًا وثابتًا ومتصلاً بدينك — كل يوم.",
        "settingsAboutOfferPrayerTimesTitle": "أوقات صلاة دقيقة",
        "settingsAboutOfferPrayerTimesSubtitle":
            "تنبيهات صلاة في الوقت المناسب وأدوات جميلة لتبقيك على المسار.",
        "settingsAboutOfferPrayerStreaksTitle": "سلسلة الصلاة",
        "settingsAboutOfferPrayerStreaksSubtitle":
            "ابنِ الاستمرارية ونمّ في دينك مع تتبع السلاسل اليومية والإجمالية.",
        "settingsAboutOfferCycleModeTitle": "وضع الدورة",
        "settingsAboutOfferCycleModeSubtitle":
            "للحيض — أوقفي الصلاة، احتفظي بسلسلتك، وواصلي رحلتك.",
        "settingsAboutOfferQuranTajweedTitle": "تجويد القرآن",
        "settingsAboutOfferQuranTajweedSubtitle":
            "اقرأ واستمع وتدرّب على التجويد مع ملاحظات فورية مدعومة بالذكاء الاصطناعي.",
        "settingsAboutOfferLiveActivitiesTitle": "الأنشطة المباشرة",
        "settingsAboutOfferLiveActivitiesSubtitle":
            "ابقَ على اطلاع بالصلوات الجارية وجلسات التركيز مباشرة من شاشة القفل.",
        "settingsAboutOfferQiblaTitle": "القبلة واكتشاف المساجد",
        "settingsAboutOfferQiblaSubtitle":
            "اعثر على اتجاه القبلة في أي وقت واكتشف المساجد القريبة أينما كنت.",
        "settingsAboutOfferFocusModesTitle": "أوضاع التركيز",
        "settingsAboutOfferFocusModesSubtitle":
            "احجب التطبيقات المشتتة أثناء الصلاة أو النوم أو الدراسة أو وقت العائلة.",
        "settingsAboutOfferTasbihTitle": "التسبيح والذكر",
        "settingsAboutOfferTasbihSubtitle":
            "تسبيح رقمي لمساعدتك على ذكر الله طوال اليوم.",
        "settingsAboutOfferCalendarTitle": "التقويم الإسلامي",
        "settingsAboutOfferCalendarSubtitle":
            "تقويم هجري مع تواريخ إسلامية مهمة وتذكيرات.",
        "settingsAboutGridNamesTitle": "أسماء الله الحسنى",
        "settingsAboutGridNamesSubtitle": "تعلّم وتأمل في الأسماء الحسنى.",
        "settingsAboutGridDuasTitle": "الأدعية والأذكار",
        "settingsAboutGridDuasSubtitle": "أدعية الصباح والمساء واليومية.",
        "settingsAboutGridPrayerTitle": "الصلاة والأحكام",
        "settingsAboutGridPrayerSubtitle": "تعلّم الصلاة والوضوء والحج والمزيد.",
        "settingsAboutGridFiqhTitle": "الفقه والسنن",
        "settingsAboutGridFiqhSubtitle": "استكشف المعرفة الإسلامية الأصيلة.",
    },
    "de": {
        **EN,
        "settingsAboutFooter": "Bleib beständig. Bleib achtsam. Bleib mit deinem Deen verbunden.",
        "settingsAboutOffersHeading": "Was Deen Focus bietet",
        "settingsAboutNewBadge": "Neu",
        "settingsAboutFooterCard":
            "Intelligente Tools, die dir helfen, achtsam, beständig und mit deinem Deen verbunden zu bleiben — jeden Tag.",
        "settingsAboutOfferPrayerTimesTitle": "Genaue Gebetszeiten",
        "settingsAboutOfferPrayerTimesSubtitle":
            "Rechtzeitige Gebetsbenachrichtigungen und schöne Widgets, damit du auf Kurs bleibst.",
        "settingsAboutOfferPrayerStreaksTitle": "Gebets-Streaks",
        "settingsAboutOfferPrayerStreaksSubtitle":
            "Baue Beständigkeit auf und wachse in deinem Deen mit täglicher und gesamter Streak-Verfolgung.",
        "settingsAboutOfferCycleModeTitle": "Zyklusmodus",
        "settingsAboutOfferCycleModeSubtitle":
            "Für die Menstruation — pausiere Gebete, behalte deinen Streak und setze deine Reise fort.",
        "settingsAboutOfferQuranTajweedTitle": "Al-Quran Tajweed",
        "settingsAboutOfferQuranTajweedSubtitle":
            "Lies, höre und übe Tajweed mit unserem KI-gestützten Echtzeit-Feedback.",
        "settingsAboutOfferLiveActivitiesTitle": "Live Activities",
        "settingsAboutOfferLiveActivitiesSubtitle":
            "Bleib über laufende Gebete und Fokussitzungen direkt vom Sperrbildschirm informiert.",
        "settingsAboutOfferQiblaTitle": "Qibla- & Moscheefinder",
        "settingsAboutOfferQiblaSubtitle":
            "Finde jederzeit die Qibla-Richtung und entdecke Moscheen in deiner Nähe.",
        "settingsAboutOfferFocusModesTitle": "Fokusmodi",
        "settingsAboutOfferFocusModesSubtitle":
            "Blockiere ablenkende Apps während Salah, Schlaf, Lernen oder Familienzeit.",
        "settingsAboutOfferTasbihTitle": "Tasbih & Dhikr",
        "settingsAboutOfferTasbihSubtitle":
            "Digitaler Tasbih, der dir hilft, Allah den ganzen Tag zu gedenken.",
        "settingsAboutOfferCalendarTitle": "Islamischer Kalender",
        "settingsAboutOfferCalendarSubtitle":
            "Hidschri-Kalender mit wichtigen islamischen Daten und Erinnerungen.",
        "settingsAboutGridNamesTitle": "99 Namen Allahs",
        "settingsAboutGridNamesSubtitle": "Lerne und reflektiere über Asma ul-Husna.",
        "settingsAboutGridDuasTitle": "Duas & Adhkar",
        "settingsAboutGridDuasSubtitle": "Morgen-, Abend- und tägliche Duas.",
        "settingsAboutGridPrayerTitle": "Gebet & Rituale",
        "settingsAboutGridPrayerSubtitle": "Lerne Salah, Wudu, Hajj und mehr.",
        "settingsAboutGridFiqhTitle": "Fiqh & Traditionen",
        "settingsAboutGridFiqhSubtitle": "Entdecke authentisches islamisches Wissen.",
    },
    "es": {
        **EN,
        "settingsAboutFooter": "Mantén la constancia. Mantén la atención plena. Mantente conectado a tu Deen.",
        "settingsAboutOffersHeading": "Lo que ofrece Deen Focus",
        "settingsAboutNewBadge": "Nuevo",
        "settingsAboutFooterCard":
            "Herramientas inteligentes para ayudarte a mantener la atención plena, la constancia y la conexión con tu Deen — cada día.",
        "settingsAboutOfferPrayerTimesTitle": "Horarios de oración precisos",
        "settingsAboutOfferPrayerTimesSubtitle":
            "Alertas oportunas de oración y widgets hermosos para mantenerte al día.",
        "settingsAboutOfferPrayerStreaksTitle": "Rachas de oración",
        "settingsAboutOfferPrayerStreaksSubtitle":
            "Construye constancia y crece en tu Deen con seguimiento de rachas diarias y totales.",
        "settingsAboutOfferCycleModeTitle": "Modo ciclo",
        "settingsAboutOfferCycleModeSubtitle":
            "Para la menstruación — pausa las oraciones, conserva tu racha y continúa tu camino.",
        "settingsAboutOfferQuranTajweedTitle": "Tajweed del Corán",
        "settingsAboutOfferQuranTajweedSubtitle":
            "Lee, escucha y practica el tajweed con nuestro feedback en tiempo real impulsado por IA.",
        "settingsAboutOfferLiveActivitiesTitle": "Live Activities",
        "settingsAboutOfferLiveActivitiesSubtitle":
            "Mantente al día con oraciones en curso y sesiones de enfoque desde la pantalla de bloqueo.",
        "settingsAboutOfferQiblaTitle": "Qibla y buscador de mezquitas",
        "settingsAboutOfferQiblaSubtitle":
            "Encuentra la dirección de la Qibla en cualquier momento y descubre mezquitas cercanas.",
        "settingsAboutOfferFocusModesTitle": "Modos de enfoque",
        "settingsAboutOfferFocusModesSubtitle":
            "Bloquea apps distractoras durante Salah, sueño, estudio o tiempo en familia.",
        "settingsAboutOfferTasbihTitle": "Tasbih y dhikr",
        "settingsAboutOfferTasbihSubtitle":
            "Tasbih digital para ayudarte a recordar a Allah durante todo el día.",
        "settingsAboutOfferCalendarTitle": "Calendario islámico",
        "settingsAboutOfferCalendarSubtitle":
            "Calendario hijri con fechas islámicas importantes y recordatorios.",
        "settingsAboutGridNamesTitle": "99 Nombres de Alá",
        "settingsAboutGridNamesSubtitle": "Aprende y reflexiona sobre Asma ul-Husna.",
        "settingsAboutGridDuasTitle": "Duas y adhkar",
        "settingsAboutGridDuasSubtitle": "Duas de la mañana, la tarde y diarias.",
        "settingsAboutGridPrayerTitle": "Oración y métodos",
        "settingsAboutGridPrayerSubtitle": "Aprende Salah, Wudu, Hajj y más.",
        "settingsAboutGridFiqhTitle": "Fiqh y tradiciones",
        "settingsAboutGridFiqhSubtitle": "Explora conocimiento islámico auténtico.",
    },
    "fr": {
        **EN,
        "settingsAboutFooter": "Restez constant. Restez attentif. Restez connecté à votre Deen.",
        "settingsAboutOffersHeading": "Ce que Deen Focus propose",
        "settingsAboutNewBadge": "Nouveau",
        "settingsAboutFooterCard":
            "Des outils intelligents pour vous aider à rester attentif, constant et connecté à votre Deen — chaque jour.",
        "settingsAboutOfferPrayerTimesTitle": "Heures de prière précises",
        "settingsAboutOfferPrayerTimesSubtitle":
            "Alertes de prière en temps voulu et beaux widgets pour rester sur la bonne voie.",
        "settingsAboutOfferPrayerStreaksTitle": "Séries de prières",
        "settingsAboutOfferPrayerStreaksSubtitle":
            "Construisez la régularité et progressez dans votre Deen avec le suivi des séries quotidiennes et globales.",
        "settingsAboutOfferCycleModeTitle": "Mode cycle",
        "settingsAboutOfferCycleModeSubtitle":
            "Pour les menstruations — mettez les prières en pause, gardez votre série et poursuivez votre chemin.",
        "settingsAboutOfferQuranTajweedTitle": "Tajweed du Coran",
        "settingsAboutOfferQuranTajweedSubtitle":
            "Lisez, écoutez et pratiquez le tajweed avec nos retours en temps réel propulsés par l'IA.",
        "settingsAboutOfferLiveActivitiesTitle": "Live Activities",
        "settingsAboutOfferLiveActivitiesSubtitle":
            "Restez informé des prières en cours et des sessions de focus depuis l'écran de verrouillage.",
        "settingsAboutOfferQiblaTitle": "Qibla et recherche de mosquées",
        "settingsAboutOfferQiblaSubtitle":
            "Trouvez la direction de la Qibla à tout moment et découvrez les mosquées à proximité.",
        "settingsAboutOfferFocusModesTitle": "Modes de concentration",
        "settingsAboutOfferFocusModesSubtitle":
            "Bloquez les apps distrayantes pendant Salah, le sommeil, les études ou le temps en famille.",
        "settingsAboutOfferTasbihTitle": "Tasbih et dhikr",
        "settingsAboutOfferTasbihSubtitle":
            "Tasbih numérique pour vous aider à vous souvenir d'Allah tout au long de la journée.",
        "settingsAboutOfferCalendarTitle": "Calendrier islamique",
        "settingsAboutOfferCalendarSubtitle":
            "Calendrier hijri avec dates islamiques importantes et rappels.",
        "settingsAboutGridNamesTitle": "99 Noms d'Allah",
        "settingsAboutGridNamesSubtitle": "Apprenez et méditez sur Asma ul-Husna.",
        "settingsAboutGridDuasTitle": "Duas et adhkar",
        "settingsAboutGridDuasSubtitle": "Duas du matin, du soir et quotidiennes.",
        "settingsAboutGridPrayerTitle": "Prière et méthodes",
        "settingsAboutGridPrayerSubtitle": "Apprenez Salah, Wudu, Hajj et plus encore.",
        "settingsAboutGridFiqhTitle": "Fiqh et traditions",
        "settingsAboutGridFiqhSubtitle": "Explorez un savoir islamique authentique.",
    },
    "hi": {
        **EN,
        "settingsAboutFooter": "निरंतर रहें। सजग रहें। अपने दीन से जुड़े रहें।",
        "settingsAboutOffersHeading": "दीन फोकस क्या प्रदान करता है",
        "settingsAboutNewBadge": "नया",
        "settingsAboutFooterCard":
            "स्मार्ट उपकरण जो आपको सजग, निरंतर और अपने दीन से जुड़े रहने में मदद करें — हर दिन।",
        "settingsAboutOfferPrayerTimesTitle": "सटीक नमाज़ के समय",
        "settingsAboutOfferPrayerTimesSubtitle":
            "समय पर नमाज़ अलर्ट और सुंदर विजेट जो आपको सही रास्ते पर रखें।",
        "settingsAboutOfferPrayerStreaksTitle": "नमाज़ स्ट्रीक",
        "settingsAboutOfferPrayerStreaksSubtitle":
            "दैनिक और कुल स्ट्रीक ट्रैकिंग के साथ निरंतरता बनाएं और अपने दीन में बढ़ें।",
        "settingsAboutOfferCycleModeTitle": "साइकल मोड",
        "settingsAboutOfferCycleModeSubtitle":
            "माहवारी के लिए — नमाज़ रोकें, अपनी स्ट्रीक बनाए रखें और अपनी यात्रा जारी रखें।",
        "settingsAboutOfferQuranTajweedTitle": "अल क़ुरआन तजवीद",
        "settingsAboutOfferQuranTajweedSubtitle":
            "हमारे AI-संचालित रीयल-टाइम फीडबैक के साथ पढ़ें, सुनें और तजवीद का अभ्यास करें।",
        "settingsAboutOfferLiveActivitiesTitle": "लाइव एक्टिविटीज़",
        "settingsAboutOfferLiveActivitiesSubtitle":
            "लॉक स्क्रीन से चल रही नमाज़ और फोकस सत्रों की जानकारी पाते रहें।",
        "settingsAboutOfferQiblaTitle": "क़िबला और मस्जिद खोजक",
        "settingsAboutOfferQiblaSubtitle":
            "कभी भी क़िबला दिशा खोजें और जहाँ भी हों, पास की मस्जिदें खोजें।",
        "settingsAboutOfferFocusModesTitle": "फोकस मोड",
        "settingsAboutOfferFocusModesSubtitle":
            "नमाज़, नींद, पढ़ाई या परिवार के समय में विचलित करने वाले ऐप्स ब्लॉक करें।",
        "settingsAboutOfferTasbihTitle": "तस्बीह और ज़िक्र",
        "settingsAboutOfferTasbihSubtitle":
            "पूरे दिन अल्लाह को याद रखने में मदद करने वाली डिजिटल तस्बीह।",
        "settingsAboutOfferCalendarTitle": "इस्लामी कैलेंडर",
        "settingsAboutOfferCalendarSubtitle":
            "महत्वपूर्ण इस्लामी तिथियों और रिमाइंडर के साथ हिजरी कैलेंडर।",
        "settingsAboutGridNamesTitle": "अल्लाह के ९९ नाम",
        "settingsAboutGridNamesSubtitle": "अस्मा उल-हुस्ना सीखें और उन पर विचार करें।",
        "settingsAboutGridDuasTitle": "दुआएँ और अज़कार",
        "settingsAboutGridDuasSubtitle": "सुबह, शाम और दैनिक दुआएँ।",
        "settingsAboutGridPrayerTitle": "नमाज़ और विधियाँ",
        "settingsAboutGridPrayerSubtitle": "नमाज़, वुज़ू, हज और अधिक सीखें।",
        "settingsAboutGridFiqhTitle": "फ़िक़्ह और परंपराएँ",
        "settingsAboutGridFiqhSubtitle": "प्रामाणिक इस्लामी ज्ञान का अन्वेषण करें।",
    },
    "it": {
        **EN,
        "settingsAboutFooter": "Resta costante. Resta consapevole. Resta connesso al tuo Deen.",
        "settingsAboutOffersHeading": "Cosa offre Deen Focus",
        "settingsAboutNewBadge": "Nuovo",
        "settingsAboutFooterCard":
            "Strumenti intelligenti per aiutarti a restare consapevole, costante e connesso al tuo Deen — ogni giorno.",
        "settingsAboutOfferPrayerTimesTitle": "Orari di preghiera precisi",
        "settingsAboutOfferPrayerTimesSubtitle":
            "Avvisi tempestivi e widget eleganti per restare in carreggiata.",
        "settingsAboutOfferPrayerStreaksTitle": "Serie di preghiere",
        "settingsAboutOfferPrayerStreaksSubtitle":
            "Costruisci costanza e cresci nel tuo Deen con il tracciamento delle serie giornaliere e totali.",
        "settingsAboutOfferCycleModeTitle": "Modalità ciclo",
        "settingsAboutOfferCycleModeSubtitle":
            "Per le mestruazioni — metti in pausa le preghiere, mantieni la serie e continua il tuo percorso.",
        "settingsAboutOfferQuranTajweedTitle": "Tajweed del Corano",
        "settingsAboutOfferQuranTajweedSubtitle":
            "Leggi, ascolta e pratica il tajweed con il nostro feedback in tempo reale basato sull'IA.",
        "settingsAboutOfferLiveActivitiesTitle": "Live Activities",
        "settingsAboutOfferLiveActivitiesSubtitle":
            "Resta aggiornato su preghiere in corso e sessioni di focus direttamente dalla schermata di blocco.",
        "settingsAboutOfferQiblaTitle": "Qibla e ricerca moschee",
        "settingsAboutOfferQiblaSubtitle":
            "Trova la direzione della Qibla in qualsiasi momento e scopri le moschee vicine.",
        "settingsAboutOfferFocusModesTitle": "Modalità focus",
        "settingsAboutOfferFocusModesSubtitle":
            "Blocca le app distraenti durante Salah, sonno, studio o tempo in famiglia.",
        "settingsAboutOfferTasbihTitle": "Tasbih e dhikr",
        "settingsAboutOfferTasbihSubtitle":
            "Tasbih digitale per aiutarti a ricordare Allah durante tutta la giornata.",
        "settingsAboutOfferCalendarTitle": "Calendario islamico",
        "settingsAboutOfferCalendarSubtitle":
            "Calendario hijri con date islamiche importanti e promemoria.",
        "settingsAboutGridNamesTitle": "99 Nomi di Allah",
        "settingsAboutGridNamesSubtitle": "Impara e rifletti su Asma ul-Husna.",
        "settingsAboutGridDuasTitle": "Duas e adhkar",
        "settingsAboutGridDuasSubtitle": "Duas del mattino, della sera e quotidiane.",
        "settingsAboutGridPrayerTitle": "Preghiera e metodi",
        "settingsAboutGridPrayerSubtitle": "Impara Salah, Wudu, Hajj e altro.",
        "settingsAboutGridFiqhTitle": "Fiqh e tradizioni",
        "settingsAboutGridFiqhSubtitle": "Esplora conoscenza islamica autentica.",
    },
    "nl": {
        **EN,
        "settingsAboutFooter": "Blijf consistent. Blijf mindful. Blijf verbonden met je Deen.",
        "settingsAboutOffersHeading": "Wat Deen Focus biedt",
        "settingsAboutNewBadge": "Nieuw",
        "settingsAboutFooterCard":
            "Slimme tools om je mindful, consistent en verbonden met je Deen te houden — elke dag.",
        "settingsAboutOfferPrayerTimesTitle": "Nauwkeurige gebedstijden",
        "settingsAboutOfferPrayerTimesSubtitle":
            "Tijdige gebedsmeldingen en mooie widgets om je op koers te houden.",
        "settingsAboutOfferPrayerStreaksTitle": "Gebedsstreaks",
        "settingsAboutOfferPrayerStreaksSubtitle":
            "Bouw consistentie op en groei in je Deen met dagelijkse en totale streak-tracking.",
        "settingsAboutOfferCycleModeTitle": "Cyclusmodus",
        "settingsAboutOfferCycleModeSubtitle":
            "Voor menstruatie — pauzeer gebeden, behoud je streak en zet je reis voort.",
        "settingsAboutOfferQuranTajweedTitle": "Al-Quran Tajweed",
        "settingsAboutOfferQuranTajweedSubtitle":
            "Lees, luister en oefen tajweed met onze AI-gestuurde realtime feedback.",
        "settingsAboutOfferLiveActivitiesTitle": "Live Activities",
        "settingsAboutOfferLiveActivitiesSubtitle":
            "Blijf op de hoogte van lopende gebeden en focussessies vanaf je vergrendelscherm.",
        "settingsAboutOfferQiblaTitle": "Qibla- & moskee-zoeker",
        "settingsAboutOfferQiblaSubtitle":
            "Vind de Qibla-richting op elk moment en ontdek moskeeën in de buurt.",
        "settingsAboutOfferFocusModesTitle": "Focusmodi",
        "settingsAboutOfferFocusModesSubtitle":
            "Blokkeer afleidende apps tijdens Salah, slaap, studie of familietijd.",
        "settingsAboutOfferTasbihTitle": "Tasbih & dhikr",
        "settingsAboutOfferTasbihSubtitle":
            "Digitale tasbih om je te helpen Allah de hele dag te gedenken.",
        "settingsAboutOfferCalendarTitle": "Islamitische kalender",
        "settingsAboutOfferCalendarSubtitle":
            "Hijri-kalender met belangrijke islamitische data en herinneringen.",
        "settingsAboutGridNamesTitle": "99 Namen van Allah",
        "settingsAboutGridNamesSubtitle": "Leer en reflecteer op Asma ul-Husna.",
        "settingsAboutGridDuasTitle": "Duas & adhkar",
        "settingsAboutGridDuasSubtitle": "Ochtend-, avond- en dagelijkse duas.",
        "settingsAboutGridPrayerTitle": "Gebed & methoden",
        "settingsAboutGridPrayerSubtitle": "Leer Salah, Wudu, Hajj en meer.",
        "settingsAboutGridFiqhTitle": "Fiqh & tradities",
        "settingsAboutGridFiqhSubtitle": "Ontdek authentieke islamitische kennis.",
    },
    "pt": {
        **EN,
        "settingsAboutFooter": "Mantenha a consistência. Mantenha a atenção plena. Mantenha-se conectado ao seu Deen.",
        "settingsAboutOffersHeading": "O que o Deen Focus oferece",
        "settingsAboutNewBadge": "Novo",
        "settingsAboutFooterCard":
            "Ferramentas inteligentes para ajudá-lo a manter a atenção plena, a consistência e a conexão com seu Deen — todos os dias.",
        "settingsAboutOfferPrayerTimesTitle": "Horários de oração precisos",
        "settingsAboutOfferPrayerTimesSubtitle":
            "Alertas oportunos de oração e widgets bonitos para mantê-lo no caminho certo.",
        "settingsAboutOfferPrayerStreaksTitle": "Sequências de oração",
        "settingsAboutOfferPrayerStreaksSubtitle":
            "Construa consistência e cresça no seu Deen com rastreamento de sequências diárias e totais.",
        "settingsAboutOfferCycleModeTitle": "Modo ciclo",
        "settingsAboutOfferCycleModeSubtitle":
            "Para menstruação — pause as orações, mantenha sua sequência e continue sua jornada.",
        "settingsAboutOfferQuranTajweedTitle": "Tajweed do Alcorão",
        "settingsAboutOfferQuranTajweedSubtitle":
            "Leia, ouça e pratique tajweed com nosso feedback em tempo real com IA.",
        "settingsAboutOfferLiveActivitiesTitle": "Live Activities",
        "settingsAboutOfferLiveActivitiesSubtitle":
            "Mantenha-se atualizado com orações em andamento e sessões de foco direto da tela de bloqueio.",
        "settingsAboutOfferQiblaTitle": "Qibla e buscador de mesquitas",
        "settingsAboutOfferQiblaSubtitle":
            "Encontre a direção da Qibla a qualquer momento e descubra mesquitas próximas.",
        "settingsAboutOfferFocusModesTitle": "Modos de foco",
        "settingsAboutOfferFocusModesSubtitle":
            "Bloqueie apps distratores durante Salah, sono, estudo ou tempo em família.",
        "settingsAboutOfferTasbihTitle": "Tasbih e dhikr",
        "settingsAboutOfferTasbihSubtitle":
            "Tasbih digital para ajudá-lo a lembrar de Allah ao longo do dia.",
        "settingsAboutOfferCalendarTitle": "Calendário islâmico",
        "settingsAboutOfferCalendarSubtitle":
            "Calendário hijri com datas islâmicas importantes e lembretes.",
        "settingsAboutGridNamesTitle": "99 Nomes de Allah",
        "settingsAboutGridNamesSubtitle": "Aprenda e reflita sobre Asma ul-Husna.",
        "settingsAboutGridDuasTitle": "Duas e adhkar",
        "settingsAboutGridDuasSubtitle": "Duas da manhã, da tarde e diárias.",
        "settingsAboutGridPrayerTitle": "Oração e métodos",
        "settingsAboutGridPrayerSubtitle": "Aprenda Salah, Wudu, Hajj e mais.",
        "settingsAboutGridFiqhTitle": "Fiqh e tradições",
        "settingsAboutGridFiqhSubtitle": "Explore conhecimento islâmico autêntico.",
    },
    "ro": {
        **EN,
        "settingsAboutFooter": "Rămâi constant. Rămâi conștient. Rămâi conectat la Deen-ul tău.",
        "settingsAboutOffersHeading": "Ce oferă Deen Focus",
        "settingsAboutNewBadge": "Nou",
        "settingsAboutFooterCard":
            "Instrumente inteligente care te ajută să rămâi conștient, constant și conectat la Deen-ul tău — în fiecare zi.",
        "settingsAboutOfferPrayerTimesTitle": "Ore de rugăciune precise",
        "settingsAboutOfferPrayerTimesSubtitle":
            "Alerte la timp și widget-uri frumoase pentru a rămâne pe drumul cel bun.",
        "settingsAboutOfferPrayerStreaksTitle": "Serii de rugăciuni",
        "settingsAboutOfferPrayerStreaksSubtitle":
            "Construiește consecvență și crește în Deen-ul tău cu urmărirea seriilor zilnice și totale.",
        "settingsAboutOfferCycleModeTitle": "Mod ciclu",
        "settingsAboutOfferCycleModeSubtitle":
            "Pentru menstruație — pune rugăciunile pe pauză, păstrează seria și continuă drumul.",
        "settingsAboutOfferQuranTajweedTitle": "Tajweed Coranic",
        "settingsAboutOfferQuranTajweedSubtitle":
            "Citește, ascultă și exersează tajweed cu feedback în timp real bazat pe IA.",
        "settingsAboutOfferLiveActivitiesTitle": "Live Activities",
        "settingsAboutOfferLiveActivitiesSubtitle":
            "Rămâi la curent cu rugăciunile în desfășurare și sesiunile de focus direct de pe ecranul de blocare.",
        "settingsAboutOfferQiblaTitle": "Qibla și găsitor de moschei",
        "settingsAboutOfferQiblaSubtitle":
            "Găsește direcția Qibla oricând și descoperă moschei din apropiere.",
        "settingsAboutOfferFocusModesTitle": "Moduri de focus",
        "settingsAboutOfferFocusModesSubtitle":
            "Blochează aplicațiile distragătoare în timpul Salah, somnului, studiului sau timpului cu familia.",
        "settingsAboutOfferTasbihTitle": "Tasbih și dhikr",
        "settingsAboutOfferTasbihSubtitle":
            "Tasbih digital care te ajută să-L amintești pe Allah pe parcursul zilei.",
        "settingsAboutOfferCalendarTitle": "Calendar islamic",
        "settingsAboutOfferCalendarSubtitle":
            "Calendar hijri cu date islamice importante și memento-uri.",
        "settingsAboutGridNamesTitle": "99 Nume ale lui Allah",
        "settingsAboutGridNamesSubtitle": "Învață și reflectează asupra Asma ul-Husna.",
        "settingsAboutGridDuasTitle": "Duas și adhkar",
        "settingsAboutGridDuasSubtitle": "Duas de dimineață, seară și zilnice.",
        "settingsAboutGridPrayerTitle": "Rugăciune și metode",
        "settingsAboutGridPrayerSubtitle": "Învață Salah, Wudu, Hajj și altele.",
        "settingsAboutGridFiqhTitle": "Fiqh și tradiții",
        "settingsAboutGridFiqhSubtitle": "Explorează cunoștințe islamice autentice.",
    },
    "ru": {
        **EN,
        "settingsAboutFooter": "Будьте последовательны. Будьте внимательны. Оставайтесь на связи со своим Дином.",
        "settingsAboutOffersHeading": "Что предлагает Deen Focus",
        "settingsAboutNewBadge": "Новое",
        "settingsAboutFooterCard":
            "Умные инструменты, которые помогают оставаться внимательными, последовательными и связанными со своим Дином — каждый день.",
        "settingsAboutOfferPrayerTimesTitle": "Точное время молитвы",
        "settingsAboutOfferPrayerTimesSubtitle":
            "Своевременные напоминания о молитве и красивые виджеты, чтобы держать вас на пути.",
        "settingsAboutOfferPrayerStreaksTitle": "Серии молитв",
        "settingsAboutOfferPrayerStreaksSubtitle":
            "Развивайте последовательность и растите в своём Дине с ежедневным и общим отслеживанием серий.",
        "settingsAboutOfferCycleModeTitle": "Режим цикла",
        "settingsAboutOfferCycleModeSubtitle":
            "Для менструации — приостановите молитвы, сохраните серию и продолжайте свой путь.",
        "settingsAboutOfferQuranTajweedTitle": "Тайвид Корана",
        "settingsAboutOfferQuranTajweedSubtitle":
            "Читайте, слушайте и практикуйте тайвид с обратной связью ИИ в реальном времени.",
        "settingsAboutOfferLiveActivitiesTitle": "Live Activities",
        "settingsAboutOfferLiveActivitiesSubtitle":
            "Будьте в курсе текущих молитв и сессий фокуса прямо с экрана блокировки.",
        "settingsAboutOfferQiblaTitle": "Кибла и поиск мечетей",
        "settingsAboutOfferQiblaSubtitle":
            "Находите направление Киблы в любое время и открывайте ближайшие мечети.",
        "settingsAboutOfferFocusModesTitle": "Режимы фокуса",
        "settingsAboutOfferFocusModesSubtitle":
            "Блокируйте отвлекающие приложения во время Салаха, сна, учёбы или семейного времени.",
        "settingsAboutOfferTasbihTitle": "Тасбих и зикр",
        "settingsAboutOfferTasbihSubtitle":
            "Цифровой тасбих, помогающий помнить Аллаха в течение дня.",
        "settingsAboutOfferCalendarTitle": "Исламский календарь",
        "settingsAboutOfferCalendarSubtitle":
            "Хиджри-календарь с важными исламскими датами и напоминаниями.",
        "settingsAboutGridNamesTitle": "99 Имён Аллаха",
        "settingsAboutGridNamesSubtitle": "Изучайте и размышляйте об Асма уль-Хусна.",
        "settingsAboutGridDuasTitle": "Дуа и азкары",
        "settingsAboutGridDuasSubtitle": "Утренние, вечерние и ежедневные дуа.",
        "settingsAboutGridPrayerTitle": "Молитва и методы",
        "settingsAboutGridPrayerSubtitle": "Изучайте Салах, Вуду, Хадж и многое другое.",
        "settingsAboutGridFiqhTitle": "Фикх и традиции",
        "settingsAboutGridFiqhSubtitle": "Изучайте подлинные исламские знания.",
    },
    "zh": {
        **EN,
        "settingsAboutFooter": "保持一致。保持专注。与您的信仰保持连接。",
        "settingsAboutOffersHeading": "Deen Focus 提供什么",
        "settingsAboutNewBadge": "新",
        "settingsAboutFooterCard":
            "智能工具助您每天保持专注、一致，并与您的信仰保持连接。",
        "settingsAboutOfferPrayerTimesTitle": "准确的礼拜时间",
        "settingsAboutOfferPrayerTimesSubtitle":
            "及时的礼拜提醒和精美小组件，助您保持正轨。",
        "settingsAboutOfferPrayerStreaksTitle": "礼拜连续记录",
        "settingsAboutOfferPrayerStreaksSubtitle":
            "通过每日和总体连续记录追踪，建立一致性并在信仰中成长。",
        "settingsAboutOfferCycleModeTitle": "生理期模式",
        "settingsAboutOfferCycleModeSubtitle":
            "适用于经期——暂停礼拜，保留连续记录，继续您的旅程。",
        "settingsAboutOfferQuranTajweedTitle": "古兰经塔吉维德",
        "settingsAboutOfferQuranTajweedSubtitle":
            "阅读、聆听并练习塔吉维德，获得 AI 驱动的实时反馈。",
        "settingsAboutOfferLiveActivitiesTitle": "实时活动",
        "settingsAboutOfferLiveActivitiesSubtitle":
            "从锁屏直接了解正在进行的礼拜和专注会话。",
        "settingsAboutOfferQiblaTitle": "朝拜方向与清真寺查找",
        "settingsAboutOfferQiblaSubtitle":
            "随时查找朝拜方向，无论身在何处都能发现附近的清真寺。",
        "settingsAboutOfferFocusModesTitle": "专注模式",
        "settingsAboutOfferFocusModesSubtitle":
            "在礼拜、睡眠、学习或家庭时间屏蔽干扰应用。",
        "settingsAboutOfferTasbihTitle": "赞珠与记主",
        "settingsAboutOfferTasbihSubtitle":
            "电子赞珠，帮助您全天记念真主。",
        "settingsAboutOfferCalendarTitle": "伊斯兰日历",
        "settingsAboutOfferCalendarSubtitle":
            "带有重要伊斯兰日期和提醒的回历日历。",
        "settingsAboutGridNamesTitle": "安拉的九十九个美名",
        "settingsAboutGridNamesSubtitle": "学习并思考至美名（Asma ul-Husna）。",
        "settingsAboutGridDuasTitle": "杜阿与记念",
        "settingsAboutGridDuasSubtitle": "晨间、晚间和每日杜阿。",
        "settingsAboutGridPrayerTitle": "礼拜与方法",
        "settingsAboutGridPrayerSubtitle": "学习礼拜、小净、朝觐等。",
        "settingsAboutGridFiqhTitle": "法学与传统",
        "settingsAboutGridFiqhSubtitle": "探索正宗的伊斯兰知识。",
    },
    "az": {
        **EN,
        "settingsAboutFooter": "Ardıcıl olun. Diqqətli olun. Dininizə bağlı qalın.",
        "settingsAboutOffersHeading": "Deen Focus nə təklif edir",
        "settingsAboutNewBadge": "Yeni",
        "settingsAboutFooterCard":
            "Hər gün diqqətli, ardıcıl və dininizə bağlı qalmağınıza kömək edən ağıllı alətlər.",
        "settingsAboutOfferPrayerTimesTitle": "Dəqiq namaz vaxtları",
        "settingsAboutOfferPrayerTimesSubtitle":
            "Vaxtında namaz xəbərdarlıqları və sizi yolda saxlayan gözəl vidjetlər.",
        "settingsAboutOfferPrayerStreaksTitle": "Namaz seriyaları",
        "settingsAboutOfferPrayerStreaksSubtitle":
            "Gündəlik və ümumi seriya izləməsi ilə ardıcıllıq qurun və dininizdə böyüyün.",
        "settingsAboutOfferCycleModeTitle": "Tsikl rejimi",
        "settingsAboutOfferCycleModeSubtitle":
            "Menstruasiya üçün — namazları dayandırın, seriyanızı saxlayın və yolunuzu davam etdirin.",
        "settingsAboutOfferQuranTajweedTitle": "Quran təcvidi",
        "settingsAboutOfferQuranTajweedSubtitle":
            "Süni intellektlə real vaxt rəy ilə oxuyun, dinləyin və təcvid məşqi edin.",
        "settingsAboutOfferLiveActivitiesTitle": "Live Activities",
        "settingsAboutOfferLiveActivitiesSubtitle":
            "Kilid ekranından davam edən namazlar və fokus sessiyaları haqqında məlumatlı qalın.",
        "settingsAboutOfferQiblaTitle": "Qiblə və məscid axtarışı",
        "settingsAboutOfferQiblaSubtitle":
            "İstənilən vaxt qiblə istiqamətini tapın və harada olursunuzsa, yaxınlıqdakı məscidləri kəşf edin.",
        "settingsAboutOfferFocusModesTitle": "Fokus rejimləri",
        "settingsAboutOfferFocusModesSubtitle":
            "Namaz, yuxu, təhsil və ya ailə vaxtında diqqət yayındıran tətbiqləri bloklayın.",
        "settingsAboutOfferTasbihTitle": "Təsbih və zikr",
        "settingsAboutOfferTasbihSubtitle":
            "Gün ərzində Allaha xatırlatmağa kömək edən rəqəmsal təsbih.",
        "settingsAboutOfferCalendarTitle": "İslam təqvimi",
        "settingsAboutOfferCalendarSubtitle":
            "Vacib islam tarixləri və xatırlatmalarla hicri təqvim.",
        "settingsAboutGridNamesTitle": "Allahın 99 adı",
        "settingsAboutGridNamesSubtitle": "Əsməül-Hüsna öyrənin və üzərində düşünün.",
        "settingsAboutGridDuasTitle": "Dualar və zikrlər",
        "settingsAboutGridDuasSubtitle": "Səhər, axşam və gündəlik dualar.",
        "settingsAboutGridPrayerTitle": "Namaz və üsullar",
        "settingsAboutGridPrayerSubtitle": "Namaz, abdest, Həcc və daha çoxunu öyrənin.",
        "settingsAboutGridFiqhTitle": "Fiqh və ənənələr",
        "settingsAboutGridFiqhSubtitle": "Həqiqi islam biliklərini kəşf edin.",
    },
}


def insert_after_anchor(data: dict, anchor: str, new_entries: dict) -> None:
    if MARKER in data:
        for key, value in new_entries.items():
            data[key] = value
        return

    keys = list(data.keys())
    if anchor not in keys:
        raise KeyError(f"Anchor {anchor!r} not found")
    ordered: dict = {}
    for key in keys:
        if key == anchor:
            ordered[key] = new_entries.get(anchor, data[key])
            for nk, nv in new_entries.items():
                if nk != anchor:
                    ordered[nk] = nv
        elif key not in new_entries:
            ordered[key] = data[key]
    data.clear()
    data.update(ordered)


def main() -> None:
    for locale, entries in TRANSLATIONS.items():
        path = ROOT / f"app_{locale}.arb"
        with path.open(encoding="utf-8") as f:
            data = json.load(f)
        insert_after_anchor(data, ANCHOR, entries)
        with path.open("w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
            f.write("\n")
        print(f"Updated {path.name}")


if __name__ == "__main__":
    main()
