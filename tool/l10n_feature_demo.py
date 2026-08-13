#!/usr/bin/env python3
"""Upsert Widgets / Live Activity App Demo keys into all app_*.arb files."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib" / "l10n"

# English source of truth; other locales get full translations below.
EN = {
    "settingsAppDemoHomeFeaturesTitle": "Stay connected at a glance",
    "settingsAppDemoHomeFeaturesSubtitle":
        "See how Home Screen widgets and Live Activity keep prayer times close — without opening the app.",
    "settingsAppDemoWidgetsCardSubtitle":
        "Daily verse and prayer times on your Home Screen, always up to date.",
    "settingsAppDemoLiveActivityCardSubtitle":
        "Current and next prayer on your Lock Screen and Dynamic Island.",
    "featureDemoContinue": "Continue",
    "featureDemoWidgetsTitle": "Widgets",
    "featureDemoWidgetsIntroTitle": "See your Home Screen widgets",
    "featureDemoWidgetsIntroSubtitle":
        "Stay in DeenFocus. On the next screen, tap the widget to see daily verse and prayer times at a glance.",
    "featureDemoWidgetsShowcaseCallout": "Tap the DeenFocus widget",
    "featureDemoWidgetsDetailsTitle": "Glanceable prayer guidance",
    "featureDemoWidgetsDetailsBody":
        "Your Medium widget shows today’s verse and all five prayer times — refreshed when you open DeenFocus.",
    "featureDemoWidgetsCompletionTitle": "Widgets, ready",
    "featureDemoWidgetsCompletionSubtitle": "Faith reminders on your Home Screen.",
    "featureDemoWidgetsCompletionBody":
        "Add DeenFocus widgets from your phone’s widget gallery after this demo — then open the app once to sync.",
    "featureDemoWidgetsHomeHint": "Wednesday, 13 August",
    "featureDemoWidgetSampleDate": "Wed, Aug 13",
    "featureDemoWidgetSampleVerse":
        "It is You we worship and You we ask for help.",
    "featureDemoWidgetSampleSource": "Surah 1:5",
    "featureDemoLiveActivityTitle": "Live Activity",
    "featureDemoLiveActivityIntroTitle": "See Live Activity in action",
    "featureDemoLiveActivityIntroSubtitle":
        "Stay in DeenFocus. On the next screen, tap the Live Activity to see current and next prayer updates.",
    "featureDemoLiveActivityShowcaseCallout": "Tap the Live Activity",
    "featureDemoLiveActivityDetailsTitle": "Prayer updates, always visible",
    "featureDemoLiveActivityDetailsBody":
        "Live Activity keeps Maghrib, Isha, and the countdown close on your Lock Screen — turn it on in Settings anytime.",
    "featureDemoLiveActivityCompletionTitle": "Live Activity, ready",
    "featureDemoLiveActivityCompletionSubtitle": "Next prayer, always nearby.",
    "featureDemoLiveActivityCompletionBody":
        "Enable Live Activity in Settings → Prayer Calculation to show prayer updates on your Lock Screen.",
    "featureDemoLiveActivityLockHint": "Wednesday, 13 August",
    "featureDemoLiveActivitySampleTime": "6:48 PM",
    "featureDemoLiveActivitySampleNextTime": "8:11 PM",
}

TRANSLATIONS: dict[str, dict[str, str]] = {
    "en": EN,
    "ar": {
        **{k: v for k, v in EN.items()},
        "settingsAppDemoHomeFeaturesTitle": "ابقَ على تواصل بنظرة",
        "settingsAppDemoHomeFeaturesSubtitle":
            "شاهد كيف تُبقي أدوات الشاشة الرئيسية والنشاط المباشر أوقات الصلاة قريبة — دون فتح التطبيق.",
        "settingsAppDemoWidgetsCardSubtitle":
            "آية اليوم وأوقات الصلاة على شاشتك الرئيسية، محدّثة دائمًا.",
        "settingsAppDemoLiveActivityCardSubtitle":
            "الصلاة الحالية والتالية على شاشة القفل والجزر الديناميكي.",
        "featureDemoContinue": "متابعة",
        "featureDemoWidgetsTitle": "الأدوات",
        "featureDemoWidgetsIntroTitle": "شاهد أدوات الشاشة الرئيسية",
        "featureDemoWidgetsIntroSubtitle":
            "ابقَ في DeenFocus. في الشاشة التالية، اضغط على الأداة لترى آية اليوم وأوقات الصلاة بنظرة.",
        "featureDemoWidgetsShowcaseCallout": "اضغط على أداة DeenFocus",
        "featureDemoWidgetsDetailsTitle": "إرشاد صلاة بنظرة واحدة",
        "featureDemoWidgetsDetailsBody":
            "تعرض الأداة المتوسطة آية اليوم وأوقات الصلوات الخمس — وتُحدَّث عند فتح DeenFocus.",
        "featureDemoWidgetsCompletionTitle": "الأدوات جاهزة",
        "featureDemoWidgetsCompletionSubtitle": "تذكيرات إيمانية على شاشتك الرئيسية.",
        "featureDemoWidgetsCompletionBody":
            "أضف أدوات DeenFocus من معرض الأدوات بعد هذه التجربة — ثم افتح التطبيق مرة لمزامنتها.",
        "featureDemoWidgetsHomeHint": "الأربعاء، ١٣ أغسطس",
        "featureDemoWidgetSampleDate": "أربعاء، ١٣ أغسطس",
        "featureDemoWidgetSampleVerse": "إياك نعبد وإياك نستعين.",
        "featureDemoWidgetSampleSource": "سورة 1:5",
        "featureDemoLiveActivityTitle": "النشاط المباشر",
        "featureDemoLiveActivityIntroTitle": "شاهد النشاط المباشر",
        "featureDemoLiveActivityIntroSubtitle":
            "ابقَ في DeenFocus. في الشاشة التالية، اضغط على النشاط المباشر لترى تحديثات الصلاة الحالية والتالية.",
        "featureDemoLiveActivityShowcaseCallout": "اضغط على النشاط المباشر",
        "featureDemoLiveActivityDetailsTitle": "تحديثات الصلاة دائمًا ظاهرة",
        "featureDemoLiveActivityDetailsBody":
            "يبقي النشاط المباشر المغرب والعشاء والعدّ التنازلي قريبين على شاشة القفل — فعّله من الإعدادات في أي وقت.",
        "featureDemoLiveActivityCompletionTitle": "النشاط المباشر جاهز",
        "featureDemoLiveActivityCompletionSubtitle": "صلاتك التالية دائمًا قريبة.",
        "featureDemoLiveActivityCompletionBody":
            "فعّل النشاط المباشر من الإعدادات → حساب الصلاة لإظهار التحديثات على شاشة القفل.",
        "featureDemoLiveActivityLockHint": "الأربعاء، ١٣ أغسطس",
        "featureDemoLiveActivitySampleTime": "٦:٤٨ م",
        "featureDemoLiveActivitySampleNextTime": "٨:١١ م",
    },
    "zh": {
        **EN,
        "settingsAppDemoHomeFeaturesTitle": "一眼掌握动态",
        "settingsAppDemoHomeFeaturesSubtitle":
            "看看主屏幕小组件和实时活动如何让礼拜时间近在咫尺——无需打开应用。",
        "settingsAppDemoWidgetsCardSubtitle": "主屏幕上的每日经文与礼拜时间，始终最新。",
        "settingsAppDemoLiveActivityCardSubtitle": "锁屏与灵动岛上的当前与下一场礼拜。",
        "featureDemoContinue": "继续",
        "featureDemoWidgetsTitle": "小组件",
        "featureDemoWidgetsIntroTitle": "查看主屏幕小组件",
        "featureDemoWidgetsIntroSubtitle":
            "留在 DeenFocus。下一屏点击小组件，一眼查看每日经文与礼拜时间。",
        "featureDemoWidgetsShowcaseCallout": "点击 DeenFocus 小组件",
        "featureDemoWidgetsDetailsTitle": "一目了然的礼拜指引",
        "featureDemoWidgetsDetailsBody":
            "中号小组件显示今日经文与五番礼拜时间——打开 DeenFocus 后会刷新。",
        "featureDemoWidgetsCompletionTitle": "小组件已就绪",
        "featureDemoWidgetsCompletionSubtitle": "信仰提醒就在主屏幕上。",
        "featureDemoWidgetsCompletionBody":
            "演示结束后从手机小组件库添加 DeenFocus 小组件，并打开应用一次以同步。",
        "featureDemoWidgetsHomeHint": "8月13日星期三",
        "featureDemoWidgetSampleDate": "周三，8月13日",
        "featureDemoWidgetSampleVerse": "我们只崇拜你，只向你求助。",
        "featureDemoWidgetSampleSource": "古兰经 1:5",
        "featureDemoLiveActivityTitle": "实时活动",
        "featureDemoLiveActivityIntroTitle": "体验实时活动",
        "featureDemoLiveActivityIntroSubtitle":
            "留在 DeenFocus。下一屏点击实时活动，查看当前与下一场礼拜更新。",
        "featureDemoLiveActivityShowcaseCallout": "点击实时活动",
        "featureDemoLiveActivityDetailsTitle": "礼拜更新始终可见",
        "featureDemoLiveActivityDetailsBody":
            "实时活动在锁屏上显示昏礼、宵礼与倒计时——可随时在设置中开启。",
        "featureDemoLiveActivityCompletionTitle": "实时活动已就绪",
        "featureDemoLiveActivityCompletionSubtitle": "下一场礼拜始终在身边。",
        "featureDemoLiveActivityCompletionBody":
            "在设置 → 礼拜计算中启用实时活动，即可在锁屏显示礼拜更新。",
        "featureDemoLiveActivityLockHint": "8月13日星期三",
        "featureDemoLiveActivitySampleTime": "下午 6:48",
        "featureDemoLiveActivitySampleNextTime": "晚上 8:11",
    },
    "fr": {
        **EN,
        "settingsAppDemoHomeFeaturesTitle": "Restez connecté d’un coup d’œil",
        "settingsAppDemoHomeFeaturesSubtitle":
            "Voyez comment les widgets et l’activité en direct gardent les heures de prière proches — sans ouvrir l’app.",
        "settingsAppDemoWidgetsCardSubtitle":
            "Verset du jour et horaires de prière sur l’écran d’accueil, toujours à jour.",
        "settingsAppDemoLiveActivityCardSubtitle":
            "Prière actuelle et suivante sur l’écran de verrouillage et Dynamic Island.",
        "featureDemoContinue": "Continuer",
        "featureDemoWidgetsTitle": "Widgets",
        "featureDemoWidgetsIntroTitle": "Découvrez vos widgets",
        "featureDemoWidgetsIntroSubtitle":
            "Restez dans DeenFocus. Sur l’écran suivant, touchez le widget pour voir le verset et les prières d’un coup d’œil.",
        "featureDemoWidgetsShowcaseCallout": "Touchez le widget DeenFocus",
        "featureDemoWidgetsDetailsTitle": "Guidance de prière d’un coup d’œil",
        "featureDemoWidgetsDetailsBody":
            "Le widget moyen affiche le verset du jour et les cinq prières — mis à jour à l’ouverture de DeenFocus.",
        "featureDemoWidgetsCompletionTitle": "Widgets prêts",
        "featureDemoWidgetsCompletionSubtitle": "Des rappels de foi sur votre écran d’accueil.",
        "featureDemoWidgetsCompletionBody":
            "Ajoutez les widgets DeenFocus depuis la galerie, puis ouvrez l’app une fois pour synchroniser.",
        "featureDemoWidgetsHomeHint": "Mercredi 13 août",
        "featureDemoWidgetSampleDate": "Mer. 13 août",
        "featureDemoWidgetSampleVerse":
            "C’est Toi que nous adorons et c’est Toi dont nous implorons le secours.",
        "featureDemoWidgetSampleSource": "Sourate 1:5",
        "featureDemoLiveActivityTitle": "Activité en direct",
        "featureDemoLiveActivityIntroTitle": "Voir l’activité en direct",
        "featureDemoLiveActivityIntroSubtitle":
            "Restez dans DeenFocus. Sur l’écran suivant, touchez l’activité pour voir la prière actuelle et la suivante.",
        "featureDemoLiveActivityShowcaseCallout": "Touchez l’activité en direct",
        "featureDemoLiveActivityDetailsTitle": "Mises à jour de prière toujours visibles",
        "featureDemoLiveActivityDetailsBody":
            "L’activité en direct garde Maghrib, Isha et le compte à rebours sur l’écran de verrouillage — activez-la dans Réglages.",
        "featureDemoLiveActivityCompletionTitle": "Activité en direct prête",
        "featureDemoLiveActivityCompletionSubtitle": "La prochaine prière, toujours proche.",
        "featureDemoLiveActivityCompletionBody":
            "Activez l’activité en direct dans Réglages → Calcul de prière pour l’afficher sur l’écran de verrouillage.",
        "featureDemoLiveActivityLockHint": "Mercredi 13 août",
        "featureDemoLiveActivitySampleTime": "18:48",
        "featureDemoLiveActivitySampleNextTime": "20:11",
    },
    "es": {
        **EN,
        "settingsAppDemoHomeFeaturesTitle": "Mantente al día de un vistazo",
        "settingsAppDemoHomeFeaturesSubtitle":
            "Mira cómo los widgets y la Live Activity mantienen los horarios de oración cerca — sin abrir la app.",
        "settingsAppDemoWidgetsCardSubtitle":
            "Verso del día y horarios de oración en tu pantalla de inicio, siempre actualizados.",
        "settingsAppDemoLiveActivityCardSubtitle":
            "Oración actual y siguiente en la pantalla de bloqueo y Dynamic Island.",
        "featureDemoContinue": "Continuar",
        "featureDemoWidgetsTitle": "Widgets",
        "featureDemoWidgetsIntroTitle": "Mira tus widgets",
        "featureDemoWidgetsIntroSubtitle":
            "Quédate en DeenFocus. En la siguiente pantalla, toca el widget para ver el verso y las oraciones de un vistazo.",
        "featureDemoWidgetsShowcaseCallout": "Toca el widget de DeenFocus",
        "featureDemoWidgetsDetailsTitle": "Orientación de oración de un vistazo",
        "featureDemoWidgetsDetailsBody":
            "El widget mediano muestra el verso del día y las cinco oraciones — se actualiza al abrir DeenFocus.",
        "featureDemoWidgetsCompletionTitle": "Widgets listos",
        "featureDemoWidgetsCompletionSubtitle": "Recordatorios de fe en tu pantalla de inicio.",
        "featureDemoWidgetsCompletionBody":
            "Añade los widgets de DeenFocus desde la galería y abre la app una vez para sincronizar.",
        "featureDemoWidgetsHomeHint": "Miércoles, 13 de agosto",
        "featureDemoWidgetSampleDate": "Mié, 13 ago",
        "featureDemoWidgetSampleVerse": "Solo a Ti adoramos y solo de Ti pedimos ayuda.",
        "featureDemoWidgetSampleSource": "Sura 1:5",
        "featureDemoLiveActivityTitle": "Live Activity",
        "featureDemoLiveActivityIntroTitle": "Mira Live Activity en acción",
        "featureDemoLiveActivityIntroSubtitle":
            "Quédate en DeenFocus. En la siguiente pantalla, toca la Live Activity para ver la oración actual y la siguiente.",
        "featureDemoLiveActivityShowcaseCallout": "Toca la Live Activity",
        "featureDemoLiveActivityDetailsTitle": "Actualizaciones de oración siempre visibles",
        "featureDemoLiveActivityDetailsBody":
            "Live Activity mantiene Maghrib, Isha y la cuenta atrás en la pantalla de bloqueo — actívala en Ajustes.",
        "featureDemoLiveActivityCompletionTitle": "Live Activity lista",
        "featureDemoLiveActivityCompletionSubtitle": "La próxima oración, siempre cerca.",
        "featureDemoLiveActivityCompletionBody":
            "Activa Live Activity en Ajustes → Cálculo de oración para mostrarla en la pantalla de bloqueo.",
        "featureDemoLiveActivityLockHint": "Miércoles, 13 de agosto",
        "featureDemoLiveActivitySampleTime": "6:48 p. m.",
        "featureDemoLiveActivitySampleNextTime": "8:11 p. m.",
    },
    "de": {
        **EN,
        "settingsAppDemoHomeFeaturesTitle": "Auf einen Blick verbunden",
        "settingsAppDemoHomeFeaturesSubtitle":
            "Sieh, wie Widgets und Live Activity Gebetszeiten nah halten — ohne die App zu öffnen.",
        "settingsAppDemoWidgetsCardSubtitle":
            "Tagesvers und Gebetszeiten auf deinem Home-Bildschirm, stets aktuell.",
        "settingsAppDemoLiveActivityCardSubtitle":
            "Aktuelles und nächstes Gebet auf Sperrbildschirm und Dynamic Island.",
        "featureDemoContinue": "Weiter",
        "featureDemoWidgetsTitle": "Widgets",
        "featureDemoWidgetsIntroTitle": "Sieh deine Home-Screen-Widgets",
        "featureDemoWidgetsIntroSubtitle":
            "Bleib in DeenFocus. Tippe auf dem nächsten Bildschirm auf das Widget, um Vers und Gebetszeiten zu sehen.",
        "featureDemoWidgetsShowcaseCallout": "Tippe auf das DeenFocus-Widget",
        "featureDemoWidgetsDetailsTitle": "Gebetsführung auf einen Blick",
        "featureDemoWidgetsDetailsBody":
            "Das Medium-Widget zeigt den Tagesvers und alle fünf Gebete — aktualisiert beim Öffnen von DeenFocus.",
        "featureDemoWidgetsCompletionTitle": "Widgets bereit",
        "featureDemoWidgetsCompletionSubtitle": "Glaubenserinnerungen auf deinem Home-Bildschirm.",
        "featureDemoWidgetsCompletionBody":
            "Füge DeenFocus-Widgets aus der Widget-Galerie hinzu und öffne die App einmal zum Synchronisieren.",
        "featureDemoWidgetsHomeHint": "Mittwoch, 13. August",
        "featureDemoWidgetSampleDate": "Mi., 13. Aug.",
        "featureDemoWidgetSampleVerse": "Dir allein dienen wir, und Dich allein bitten wir um Hilfe.",
        "featureDemoWidgetSampleSource": "Sure 1:5",
        "featureDemoLiveActivityTitle": "Live Activity",
        "featureDemoLiveActivityIntroTitle": "Live Activity erleben",
        "featureDemoLiveActivityIntroSubtitle":
            "Bleib in DeenFocus. Tippe auf dem nächsten Bildschirm auf die Live Activity für aktuelles und nächstes Gebet.",
        "featureDemoLiveActivityShowcaseCallout": "Tippe auf die Live Activity",
        "featureDemoLiveActivityDetailsTitle": "Gebets-Updates immer sichtbar",
        "featureDemoLiveActivityDetailsBody":
            "Live Activity hält Maghrib, Isha und den Countdown auf dem Sperrbildschirm nah — in den Einstellungen aktivieren.",
        "featureDemoLiveActivityCompletionTitle": "Live Activity bereit",
        "featureDemoLiveActivityCompletionSubtitle": "Das nächste Gebet, immer in der Nähe.",
        "featureDemoLiveActivityCompletionBody":
            "Aktiviere Live Activity unter Einstellungen → Gebetsberechnung für Updates auf dem Sperrbildschirm.",
        "featureDemoLiveActivityLockHint": "Mittwoch, 13. August",
        "featureDemoLiveActivitySampleTime": "18:48",
        "featureDemoLiveActivitySampleNextTime": "20:11",
    },
}

# Locales that fall back to English with light overlays where missing.
for code in ("az", "hi", "it", "nl", "pt", "ro", "ru"):
    TRANSLATIONS.setdefault(code, dict(EN))

# Fill remaining locales with more natural translations.
TRANSLATIONS["it"] = {
    **EN,
    "settingsAppDemoHomeFeaturesTitle": "Resta aggiornato a colpo d’occhio",
    "settingsAppDemoHomeFeaturesSubtitle":
        "Scopri come widget e Live Activity tengono vicine le ore di preghiera — senza aprire l’app.",
    "settingsAppDemoWidgetsCardSubtitle":
        "Versetto del giorno e orari di preghiera sulla Home, sempre aggiornati.",
    "settingsAppDemoLiveActivityCardSubtitle":
        "Preghiera attuale e successiva su Lock Screen e Dynamic Island.",
    "featureDemoContinue": "Continua",
    "featureDemoWidgetsTitle": "Widget",
    "featureDemoWidgetsIntroTitle": "Guarda i widget sulla Home",
    "featureDemoWidgetsIntroSubtitle":
        "Resta in DeenFocus. Nella schermata successiva tocca il widget per vedere versetto e preghiere.",
    "featureDemoWidgetsShowcaseCallout": "Tocca il widget DeenFocus",
    "featureDemoWidgetsDetailsTitle": "Guida alla preghiera a colpo d’occhio",
    "featureDemoWidgetsDetailsBody":
        "Il widget medio mostra il versetto del giorno e le cinque preghiere — si aggiorna aprendo DeenFocus.",
    "featureDemoWidgetsCompletionTitle": "Widget pronti",
    "featureDemoWidgetsCompletionSubtitle": "Promemoria di fede sulla Home.",
    "featureDemoWidgetsCompletionBody":
        "Aggiungi i widget DeenFocus dalla galleria, poi apri l’app una volta per sincronizzare.",
    "featureDemoLiveActivityTitle": "Live Activity",
    "featureDemoLiveActivityIntroTitle": "Vedi la Live Activity",
    "featureDemoLiveActivityIntroSubtitle":
        "Resta in DeenFocus. Nella schermata successiva tocca la Live Activity per vedere preghiera attuale e successiva.",
    "featureDemoLiveActivityShowcaseCallout": "Tocca la Live Activity",
    "featureDemoLiveActivityDetailsTitle": "Aggiornamenti preghiera sempre visibili",
    "featureDemoLiveActivityDetailsBody":
        "La Live Activity tiene Maghrib, Isha e il conto alla rovescia sulla Lock Screen — attivala nelle Impostazioni.",
    "featureDemoLiveActivityCompletionTitle": "Live Activity pronta",
    "featureDemoLiveActivityCompletionSubtitle": "La prossima preghiera, sempre vicina.",
    "featureDemoLiveActivityCompletionBody":
        "Attiva la Live Activity in Impostazioni → Calcolo preghiera per mostrarla sulla Lock Screen.",
}

TRANSLATIONS["nl"] = {
    **EN,
    "settingsAppDemoHomeFeaturesTitle": "In één oogopslag verbonden",
    "settingsAppDemoHomeFeaturesSubtitle":
        "Zie hoe widgets en Live Activity gebedstijden dichtbij houden — zonder de app te openen.",
    "settingsAppDemoWidgetsCardSubtitle":
        "Dagvers en gebedstijden op je beginscherm, altijd bijgewerkt.",
    "settingsAppDemoLiveActivityCardSubtitle":
        "Huidig en volgend gebed op het vergrendelscherm en Dynamic Island.",
    "featureDemoContinue": "Doorgaan",
    "featureDemoWidgetsTitle": "Widgets",
    "featureDemoWidgetsIntroTitle": "Bekijk je beginscherm-widgets",
    "featureDemoWidgetsIntroSubtitle":
        "Blijf in DeenFocus. Tik op het volgende scherm op de widget om vers en gebeden te zien.",
    "featureDemoWidgetsShowcaseCallout": "Tik op de DeenFocus-widget",
    "featureDemoLiveActivityTitle": "Live Activity",
    "featureDemoLiveActivityIntroTitle": "Bekijk Live Activity",
    "featureDemoLiveActivityShowcaseCallout": "Tik op de Live Activity",
    "featureDemoContinue": "Doorgaan",
}

TRANSLATIONS["pt"] = {
    **EN,
    "settingsAppDemoHomeFeaturesTitle": "Fique por dentro de relance",
    "settingsAppDemoHomeFeaturesSubtitle":
        "Veja como widgets e Live Activity mantêm os horários de oração por perto — sem abrir o app.",
    "settingsAppDemoWidgetsCardSubtitle":
        "Verso do dia e horários de oração na tela inicial, sempre atualizados.",
    "settingsAppDemoLiveActivityCardSubtitle":
        "Oração atual e seguinte na tela de bloqueio e Dynamic Island.",
    "featureDemoContinue": "Continuar",
    "featureDemoWidgetsTitle": "Widgets",
    "featureDemoLiveActivityTitle": "Live Activity",
    "featureDemoWidgetsShowcaseCallout": "Toque no widget do DeenFocus",
    "featureDemoLiveActivityShowcaseCallout": "Toque na Live Activity",
}

TRANSLATIONS["ro"] = {
    **EN,
    "settingsAppDemoHomeFeaturesTitle": "Rămâi conectat dintr-o privire",
    "settingsAppDemoHomeFeaturesSubtitle":
        "Vezi cum widgeturile și Live Activity țin orele de rugăciune aproape — fără a deschide aplicația.",
    "featureDemoContinue": "Continuă",
    "featureDemoWidgetsTitle": "Widgeturi",
    "featureDemoLiveActivityTitle": "Live Activity",
}

TRANSLATIONS["ru"] = {
    **EN,
    "settingsAppDemoHomeFeaturesTitle": "Всё под рукой с первого взгляда",
    "settingsAppDemoHomeFeaturesSubtitle":
        "Как виджеты и Live Activity держат время намаза рядом — не открывая приложение.",
    "featureDemoContinue": "Продолжить",
    "featureDemoWidgetsTitle": "Виджеты",
    "featureDemoLiveActivityTitle": "Live Activity",
    "featureDemoWidgetsShowcaseCallout": "Нажмите виджет DeenFocus",
    "featureDemoLiveActivityShowcaseCallout": "Нажмите Live Activity",
}

TRANSLATIONS["hi"] = {
    **EN,
    "settingsAppDemoHomeFeaturesTitle": "एक नज़र में जुड़े रहें",
    "settingsAppDemoHomeFeaturesSubtitle":
        "देखें कि विजेट और लाइव गतिविधि नमाज़ के समय को पास कैसे रखते हैं — ऐप खोले बिना।",
    "featureDemoContinue": "जारी रखें",
    "featureDemoWidgetsTitle": "विजेट",
    "featureDemoLiveActivityTitle": "लाइव गतिविधि",
}

TRANSLATIONS["az"] = {
    **EN,
    "settingsAppDemoHomeFeaturesTitle": "Bir baxışda bağlı qalın",
    "featureDemoContinue": "Davam et",
    "featureDemoWidgetsTitle": "Vidjetlər",
    "featureDemoLiveActivityTitle": "Canlı Fəaliyyət",
}


def upsert(path: Path, locale: str) -> None:
    data = json.loads(path.read_text(encoding="utf-8"))
    values = TRANSLATIONS.get(locale, EN)
    for key, value in values.items():
        data[key] = value
    # Ensure English has every key even if a locale map was incomplete.
    if locale != "en":
        for key, value in EN.items():
            data.setdefault(key, value)
    path.write_text(
        json.dumps(data, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(f"updated {path.name}")


def main() -> None:
    for path in sorted(ROOT.glob("app_*.arb")):
        if path.name.endswith(".bak"):
            continue
        locale = path.stem.removeprefix("app_")
        upsert(path, locale)


if __name__ == "__main__":
    main()
