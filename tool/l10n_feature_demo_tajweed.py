#!/usr/bin/env python3
"""Insert Tajweed App Demo l10n keys after settingsAppDemoLiveActivityCardSubtitle."""

from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib" / "l10n"
ANCHOR = "settingsAppDemoLiveActivityCardSubtitle"

EN = {
    "settingsAppDemoTajweedCardSubtitle":
        "Recite an ayah and get instant tajweed feedback.",
    "featureDemoTajweedTitle": "Tajweed",
    "featureDemoTajweedIntroTitle": "See how Tajweed practice works",
    "featureDemoTajweedIntroSubtitle":
        "Stay in DeenFocus. Open Tajweed drill, recite an ayah, and see word-by-word feedback.",
    "featureDemoTajweedQuranCallout": "Tap Tajweed drill to start",
    "featureDemoTajweedLegendCallout":
        "Color highlights show tajweed rules as you read",
    "featureDemoTajweedReciteCallout": "Tap Recite & check tajweed",
    "featureDemoTajweedDownloadCallout":
        "One-time download so practice works offline",
    "featureDemoTajweedMicCallout": "Tap the mic and start reciting",
    "featureDemoTajweedResultCallout":
        "See which words were correct, missed, or need work",
    "featureDemoTajweedCompletionTitle": "Tajweed, ready",
    "featureDemoTajweedCompletionSubtitle": "Recite with confidence, anytime.",
    "featureDemoTajweedCompletionBody":
        "Open Quran → Tajweed drill to practice any ayah with on-device scoring — fully offline after the first download.",
    "featureDemoTajweedSurahName": "Al-Fatihah",
    "featureDemoTajweedBaqarahName": "Al-Baqarah",
    "featureDemoTajweedSurahListSubtitle": "7 verses • Meccan",
    "featureDemoTajweedBaqarahSubtitle": "286 verses • Medinan",
    "featureDemoTajweedSurahHeaderSubtitle": "Al-Fatihah • 7 verses",
    "featureDemoTajweedSurahMeta": "SURAH 1 • MECCAN",
    "featureDemoTajweedAyahTranslation":
        "In the name of Allah, the Entirely Merciful, the Especially Merciful.",
    "featureDemoTajweedPracticeTitle": "Al-Fatihah · 1:1",
    "featureDemoTajweedPreparingTitle": "Preparing AI model",
    "featureDemoTajweedPreparingBody":
        "One-time download so Tajweed practice works fully offline afterwards. This only happens once.",
    "featureDemoTajweedResultEncouragement":
        "Keep practicing — listen to the reference and try again.",
    "featureDemoTajweedStatCorrect": "Correct",
    "featureDemoTajweedStatPronunciation": "Pronunciation",
    "featureDemoTajweedStatWrong": "Wrong word",
    "featureDemoTajweedStatMissed": "Missed",
    "featureDemoTajweedStatExtra": "Extra",
}

TRANSLATIONS: dict[str, dict[str, str]] = {
    "en": EN,
    "ar": {
        **EN,
        "settingsAppDemoTajweedCardSubtitle": "رتّل آية واحصل على ملاحظات التجويد فورًا.",
        "featureDemoTajweedTitle": "تجويد",
        "featureDemoTajweedIntroTitle": "شاهد كيف يعمل تمرين التجويد",
        "featureDemoTajweedIntroSubtitle":
            "ابقَ في DeenFocus. افتح تمرين التجويد، رتّل آية، وشاهد الملاحظات كلمة بكلمة.",
        "featureDemoTajweedQuranCallout": "اضغط تمرين التجويد للبدء",
        "featureDemoTajweedLegendCallout": "الألوان تُظهر أحكام التجويد أثناء القراءة",
        "featureDemoTajweedReciteCallout": "اضغط رتّل وتحقق من التجويد",
        "featureDemoTajweedDownloadCallout": "تنزيل لمرة واحدة ليعمل التمرين دون اتصال",
        "featureDemoTajweedMicCallout": "اضغط الميكروفون وابدأ التلاوة",
        "featureDemoTajweedResultCallout": "شاهد الكلمات الصحيحة والناقصة والتي تحتاج مراجعة",
        "featureDemoTajweedCompletionTitle": "التجويد جاهز",
        "featureDemoTajweedCompletionSubtitle": "رتّل بثقة في أي وقت.",
        "featureDemoTajweedCompletionBody":
            "افتح القرآن ← تمرين التجويد لتتدرب على أي آية بالتقييم على الجهاز — دون اتصال بعد التنزيل الأول.",
        "featureDemoTajweedSurahName": "الفاتحة",
        "featureDemoTajweedBaqarahName": "البقرة",
        "featureDemoTajweedSurahListSubtitle": "٧ آيات • مكية",
        "featureDemoTajweedBaqarahSubtitle": "٢٨٦ آية • مدنية",
        "featureDemoTajweedSurahHeaderSubtitle": "الفاتحة • ٧ آيات",
        "featureDemoTajweedSurahMeta": "سورة ١ • مكية",
        "featureDemoTajweedAyahTranslation": "بسم الله الرحمن الرحيم.",
        "featureDemoTajweedPracticeTitle": "الفاتحة · ١:١",
        "featureDemoTajweedPreparingTitle": "جارٍ تجهيز نموذج الذكاء الاصطناعي",
        "featureDemoTajweedPreparingBody":
            "تنزيل لمرة واحدة حتى يعمل تمرين التجويد بالكامل دون اتصال بعد ذلك. يحدث هذا مرة واحدة فقط.",
        "featureDemoTajweedResultEncouragement": "واصل التمرين — استمع للمرجع وحاول مرة أخرى.",
        "featureDemoTajweedStatCorrect": "صحيح",
        "featureDemoTajweedStatPronunciation": "النطق",
        "featureDemoTajweedStatWrong": "كلمة خاطئة",
        "featureDemoTajweedStatMissed": "ناقص",
        "featureDemoTajweedStatExtra": "زائد",
    },
    "de": {
        **EN,
        "settingsAppDemoTajweedCardSubtitle": "Rezitiere einen Vers und erhalte sofortiges Tadschwid-Feedback.",
        "featureDemoTajweedTitle": "Tadschwid",
        "featureDemoTajweedIntroTitle": "So funktioniert die Tadschwid-Übung",
        "featureDemoTajweedIntroSubtitle":
            "Bleib in DeenFocus. Öffne Tadschwid-Übung, rezitiere einen Vers und sieh Wort-für-Wort-Feedback.",
        "featureDemoTajweedQuranCallout": "Tippe auf Tadschwid-Übung, um zu starten",
        "featureDemoTajweedLegendCallout": "Farbmarkierungen zeigen Tadschwid-Regeln beim Lesen",
        "featureDemoTajweedReciteCallout": "Tippe auf Rezitieren & Tadschwid prüfen",
        "featureDemoTajweedDownloadCallout": "Einmaliger Download, damit die Übung offline funktioniert",
        "featureDemoTajweedMicCallout": "Tippe auf das Mikrofon und beginne zu rezitieren",
        "featureDemoTajweedResultCallout": "Sieh, welche Wörter korrekt, verpasst oder zu üben sind",
        "featureDemoTajweedCompletionTitle": "Tadschwid, bereit",
        "featureDemoTajweedCompletionSubtitle": "Jederzeit selbstsicher rezitieren.",
        "featureDemoTajweedCompletionBody":
            "Öffne Quran → Tadschwid-Übung, um jeden Vers geräteintern zu bewerten — nach dem ersten Download vollständig offline.",
        "featureDemoTajweedSurahListSubtitle": "7 Verse • Mekkanisch",
        "featureDemoTajweedBaqarahSubtitle": "286 Verse • Medinensisch",
        "featureDemoTajweedSurahHeaderSubtitle": "Al-Fatihah • 7 Verse",
        "featureDemoTajweedSurahMeta": "SURE 1 • MEKKANISCH",
        "featureDemoTajweedAyahTranslation":
            "Im Namen Allahs, des Allerbarmers, des Barmherzigen.",
        "featureDemoTajweedPreparingTitle": "KI-Modell wird vorbereitet",
        "featureDemoTajweedPreparingBody":
            "Einmaliger Download, damit die Tadschwid-Übung danach vollständig offline funktioniert. Das passiert nur einmal.",
        "featureDemoTajweedResultEncouragement": "Weiter üben — hör die Referenz und versuch es erneut.",
        "featureDemoTajweedStatCorrect": "Richtig",
        "featureDemoTajweedStatPronunciation": "Aussprache",
        "featureDemoTajweedStatWrong": "Falsches Wort",
        "featureDemoTajweedStatMissed": "Verpasst",
        "featureDemoTajweedStatExtra": "Zusätzlich",
    },
    "es": {
        **EN,
        "settingsAppDemoTajweedCardSubtitle": "Recita un aleya y recibe feedback de tayyid al instante.",
        "featureDemoTajweedTitle": "Tayyid",
        "featureDemoTajweedIntroTitle": "Así funciona la práctica de tayyid",
        "featureDemoTajweedIntroSubtitle":
            "Quédate en DeenFocus. Abre el ejercicio de tayyid, recita un aleya y ve el feedback palabra por palabra.",
        "featureDemoTajweedQuranCallout": "Toca Ejercicio de tayyid para empezar",
        "featureDemoTajweedLegendCallout": "Los colores muestran las reglas de tayyid al leer",
        "featureDemoTajweedReciteCallout": "Toca Recitar y comprobar tayyid",
        "featureDemoTajweedDownloadCallout": "Una descarga única para practicar sin conexión",
        "featureDemoTajweedMicCallout": "Toca el micrófono y empieza a recitar",
        "featureDemoTajweedResultCallout": "Mira qué palabras fueron correctas, omitidas o a mejorar",
        "featureDemoTajweedCompletionTitle": "Tayyid, listo",
        "featureDemoTajweedCompletionSubtitle": "Recita con confianza, cuando quieras.",
        "featureDemoTajweedCompletionBody":
            "Abre Corán → Ejercicio de tayyid para practicar cualquier aleya con puntuación en el dispositivo — totalmente sin conexión tras la primera descarga.",
        "featureDemoTajweedSurahListSubtitle": "7 aleyas • Meca",
        "featureDemoTajweedBaqarahSubtitle": "286 aleyas • Medina",
        "featureDemoTajweedSurahHeaderSubtitle": "Al-Fatihah • 7 aleyas",
        "featureDemoTajweedSurahMeta": "SURA 1 • MECA",
        "featureDemoTajweedAyahTranslation":
            "En el nombre de Alá, el Compasivo, el Misericordioso.",
        "featureDemoTajweedPreparingTitle": "Preparando el modelo de IA",
        "featureDemoTajweedPreparingBody":
            "Una descarga única para que la práctica de tayyid funcione totalmente sin conexión después. Solo ocurre una vez.",
        "featureDemoTajweedResultEncouragement": "Sigue practicando: escucha la referencia e inténtalo de nuevo.",
        "featureDemoTajweedStatCorrect": "Correcto",
        "featureDemoTajweedStatPronunciation": "Pronunciación",
        "featureDemoTajweedStatWrong": "Palabra incorrecta",
        "featureDemoTajweedStatMissed": "Omitida",
        "featureDemoTajweedStatExtra": "Extra",
    },
    "fr": {
        **EN,
        "settingsAppDemoTajweedCardSubtitle": "Récitez un verset et recevez un retour tajwid immédiat.",
        "featureDemoTajweedTitle": "Tajwid",
        "featureDemoTajweedIntroTitle": "Découvrez la pratique du tajwid",
        "featureDemoTajweedIntroSubtitle":
            "Restez dans DeenFocus. Ouvrez l’exercice tajwid, récitez un verset et voyez le retour mot par mot.",
        "featureDemoTajweedQuranCallout": "Touchez Exercice tajwid pour commencer",
        "featureDemoTajweedLegendCallout": "Les couleurs montrent les règles de tajwid à la lecture",
        "featureDemoTajweedReciteCallout": "Touchez Réciter et vérifier le tajwid",
        "featureDemoTajweedDownloadCallout": "Téléchargement unique pour pratiquer hors ligne",
        "featureDemoTajweedMicCallout": "Touchez le micro et commencez à réciter",
        "featureDemoTajweedResultCallout": "Voyez les mots justes, manqués ou à retravailler",
        "featureDemoTajweedCompletionTitle": "Tajwid, prêt",
        "featureDemoTajweedCompletionSubtitle": "Récitez en confiance, à tout moment.",
        "featureDemoTajweedCompletionBody":
            "Ouvrez Coran → Exercice tajwid pour pratiquer n’importe quel verset avec un score sur l’appareil — entièrement hors ligne après le premier téléchargement.",
        "featureDemoTajweedSurahListSubtitle": "7 versets • Mecquoise",
        "featureDemoTajweedBaqarahSubtitle": "286 versets • Médinoise",
        "featureDemoTajweedSurahHeaderSubtitle": "Al-Fatiha • 7 versets",
        "featureDemoTajweedSurahMeta": "SOURATE 1 • MECQUOISE",
        "featureDemoTajweedAyahTranslation":
            "Au nom d’Allah, le Tout Miséricordieux, le Très Miséricordieux.",
        "featureDemoTajweedPreparingTitle": "Préparation du modèle d’IA",
        "featureDemoTajweedPreparingBody":
            "Téléchargement unique pour que la pratique du tajwid fonctionne ensuite entièrement hors ligne. Cela n’arrive qu’une fois.",
        "featureDemoTajweedResultEncouragement": "Continuez à pratiquer — écoutez la référence et réessayez.",
        "featureDemoTajweedStatCorrect": "Correct",
        "featureDemoTajweedStatPronunciation": "Prononciation",
        "featureDemoTajweedStatWrong": "Mot incorrect",
        "featureDemoTajweedStatMissed": "Manqué",
        "featureDemoTajweedStatExtra": "En trop",
    },
    "it": {
        **EN,
        "settingsAppDemoTajweedCardSubtitle": "Recita un versetto e ricevi feedback tajwid immediato.",
        "featureDemoTajweedTitle": "Tajwid",
        "featureDemoTajweedIntroTitle": "Scopri la pratica del tajwid",
        "featureDemoTajweedIntroSubtitle":
            "Resta in DeenFocus. Apri l’esercizio tajwid, recita un versetto e vedi il feedback parola per parola.",
        "featureDemoTajweedQuranCallout": "Tocca Esercizio tajwid per iniziare",
        "featureDemoTajweedLegendCallout": "I colori mostrano le regole del tajwid durante la lettura",
        "featureDemoTajweedReciteCallout": "Tocca Recita e controlla il tajwid",
        "featureDemoTajweedDownloadCallout": "Download unico per praticare offline",
        "featureDemoTajweedMicCallout": "Tocca il microfono e inizia a recitare",
        "featureDemoTajweedResultCallout": "Vedi quali parole sono corrette, mancanti o da rivedere",
        "featureDemoTajweedCompletionTitle": "Tajwid, pronto",
        "featureDemoTajweedCompletionSubtitle": "Recita con sicurezza, quando vuoi.",
        "featureDemoTajweedCompletionBody":
            "Apri Corano → Esercizio tajwid per esercitarti su qualsiasi versetto con punteggio sul dispositivo — completamente offline dopo il primo download.",
        "featureDemoTajweedSurahListSubtitle": "7 versetti • Meccani",
        "featureDemoTajweedBaqarahSubtitle": "286 versetti • Medinesi",
        "featureDemoTajweedSurahHeaderSubtitle": "Al-Fatiha • 7 versetti",
        "featureDemoTajweedSurahMeta": "SURA 1 • MECCANA",
        "featureDemoTajweedAyahTranslation":
            "Nel nome di Allah, il Compassionevole, il Misericordioso.",
        "featureDemoTajweedPreparingTitle": "Preparazione del modello IA",
        "featureDemoTajweedPreparingBody":
            "Download unico così la pratica del tajwid funziona completamente offline. Succede una sola volta.",
        "featureDemoTajweedResultEncouragement": "Continua a esercitarti: ascolta il riferimento e riprova.",
        "featureDemoTajweedStatCorrect": "Corretto",
        "featureDemoTajweedStatPronunciation": "Pronuncia",
        "featureDemoTajweedStatWrong": "Parola errata",
        "featureDemoTajweedStatMissed": "Mancata",
        "featureDemoTajweedStatExtra": "In più",
    },
    "nl": {
        **EN,
        "settingsAppDemoTajweedCardSubtitle": "Reciteer een aya en krijg direct tajweed-feedback.",
        "featureDemoTajweedTitle": "Tajweed",
        "featureDemoTajweedIntroTitle": "Zo werkt tajweed-oefening",
        "featureDemoTajweedIntroSubtitle":
            "Blijf in DeenFocus. Open tajweed-oefening, reciteer een aya en zie feedback woord voor woord.",
        "featureDemoTajweedQuranCallout": "Tik op Tajweed-oefening om te starten",
        "featureDemoTajweedLegendCallout": "Kleuren tonen tajweed-regels tijdens het lezen",
        "featureDemoTajweedReciteCallout": "Tik op Reciteer en controleer tajweed",
        "featureDemoTajweedDownloadCallout": "Eenmalige download zodat oefenen offline werkt",
        "featureDemoTajweedMicCallout": "Tik op de microfoon en begin te reciteren",
        "featureDemoTajweedResultCallout": "Zie welke woorden goed, gemist of te oefenen zijn",
        "featureDemoTajweedCompletionTitle": "Tajweed, klaar",
        "featureDemoTajweedCompletionSubtitle": "Reciteer vol vertrouwen, wanneer je wilt.",
        "featureDemoTajweedCompletionBody":
            "Open Koran → Tajweed-oefening om elke aya op het apparaat te scoren — volledig offline na de eerste download.",
        "featureDemoTajweedSurahListSubtitle": "7 verzen • Mekkaans",
        "featureDemoTajweedBaqarahSubtitle": "286 verzen • Medinees",
        "featureDemoTajweedSurahHeaderSubtitle": "Al-Fatihah • 7 verzen",
        "featureDemoTajweedSurahMeta": "SOERA 1 • MEKKAANS",
        "featureDemoTajweedAyahTranslation":
            "In de naam van Allah, de Erbarmer, de Barmhartige.",
        "featureDemoTajweedPreparingTitle": "AI-model voorbereiden",
        "featureDemoTajweedPreparingBody":
            "Eenmalige download zodat tajweed-oefening daarna volledig offline werkt. Dit gebeurt maar één keer.",
        "featureDemoTajweedResultEncouragement": "Blijf oefenen — luister naar de referentie en probeer opnieuw.",
        "featureDemoTajweedStatCorrect": "Juist",
        "featureDemoTajweedStatPronunciation": "Uitspraak",
        "featureDemoTajweedStatWrong": "Verkeerd woord",
        "featureDemoTajweedStatMissed": "Gemist",
        "featureDemoTajweedStatExtra": "Extra",
    },
    "pt": {
        **EN,
        "settingsAppDemoTajweedCardSubtitle": "Recite um versículo e receba feedback de tajweed na hora.",
        "featureDemoTajweedTitle": "Tajweed",
        "featureDemoTajweedIntroTitle": "Veja como funciona a prática de tajweed",
        "featureDemoTajweedIntroSubtitle":
            "Fique no DeenFocus. Abra o exercício de tajweed, recite um versículo e veja o feedback palavra por palavra.",
        "featureDemoTajweedQuranCallout": "Toque em Exercício de tajweed para começar",
        "featureDemoTajweedLegendCallout": "As cores mostram as regras de tajweed na leitura",
        "featureDemoTajweedReciteCallout": "Toque em Recitar e verificar tajweed",
        "featureDemoTajweedDownloadCallout": "Download único para praticar offline",
        "featureDemoTajweedMicCallout": "Toque no microfone e comece a recitar",
        "featureDemoTajweedResultCallout": "Veja quais palavras estavam corretas, omitidas ou a melhorar",
        "featureDemoTajweedCompletionTitle": "Tajweed, pronto",
        "featureDemoTajweedCompletionSubtitle": "Recite com confiança, a qualquer hora.",
        "featureDemoTajweedCompletionBody":
            "Abra Alcorão → Exercício de tajweed para praticar qualquer versículo com pontuação no aparelho — totalmente offline após o primeiro download.",
        "featureDemoTajweedSurahListSubtitle": "7 versículos • Meca",
        "featureDemoTajweedBaqarahSubtitle": "286 versículos • Medina",
        "featureDemoTajweedSurahHeaderSubtitle": "Al-Fatihah • 7 versículos",
        "featureDemoTajweedSurahMeta": "SURATA 1 • MECA",
        "featureDemoTajweedAyahTranslation":
            "Em nome de Allah, o Clemente, o Misericordioso.",
        "featureDemoTajweedPreparingTitle": "Preparando o modelo de IA",
        "featureDemoTajweedPreparingBody":
            "Download único para que a prática de tajweed funcione totalmente offline depois. Isso acontece só uma vez.",
        "featureDemoTajweedResultEncouragement": "Continue praticando — ouça a referência e tente de novo.",
        "featureDemoTajweedStatCorrect": "Correto",
        "featureDemoTajweedStatPronunciation": "Pronúncia",
        "featureDemoTajweedStatWrong": "Palavra errada",
        "featureDemoTajweedStatMissed": "Omitida",
        "featureDemoTajweedStatExtra": "Extra",
    },
    "zh": {
        **EN,
        "settingsAppDemoTajweedCardSubtitle": "诵读一节经文，立即获得读经反馈。",
        "featureDemoTajweedTitle": "读经",
        "featureDemoTajweedIntroTitle": "了解读经练习如何运作",
        "featureDemoTajweedIntroSubtitle":
            "留在 DeenFocus。打开读经练习，诵读一节经文，并逐词查看反馈。",
        "featureDemoTajweedQuranCallout": "点按读经练习开始",
        "featureDemoTajweedLegendCallout": "颜色高亮会在阅读时标示读经规则",
        "featureDemoTajweedReciteCallout": "点按诵读并检查读经",
        "featureDemoTajweedDownloadCallout": "一次性下载后即可离线练习",
        "featureDemoTajweedMicCallout": "点按麦克风开始诵读",
        "featureDemoTajweedResultCallout": "查看哪些词正确、遗漏或需要改进",
        "featureDemoTajweedCompletionTitle": "读经已就绪",
        "featureDemoTajweedCompletionSubtitle": "随时自信诵读。",
        "featureDemoTajweedCompletionBody":
            "打开古兰经 → 读经练习，在设备上为任意经文评分 — 首次下载后即可完全离线。",
        "featureDemoTajweedSurahListSubtitle": "7 节 • 麦加章",
        "featureDemoTajweedBaqarahSubtitle": "286 节 • 麦地那章",
        "featureDemoTajweedSurahHeaderSubtitle": "开端章 • 7 节",
        "featureDemoTajweedSurahMeta": "第 1 章 • 麦加",
        "featureDemoTajweedAyahTranslation": "奉至仁至慈的真主之名。",
        "featureDemoTajweedPracticeTitle": "开端章 · 1:1",
        "featureDemoTajweedPreparingTitle": "正在准备 AI 模型",
        "featureDemoTajweedPreparingBody":
            "一次性下载，之后读经练习即可完全离线。只需一次。",
        "featureDemoTajweedResultEncouragement": "继续练习 — 听参考音频再试一次。",
        "featureDemoTajweedStatCorrect": "正确",
        "featureDemoTajweedStatPronunciation": "发音",
        "featureDemoTajweedStatWrong": "错词",
        "featureDemoTajweedStatMissed": "遗漏",
        "featureDemoTajweedStatExtra": "多余",
    },
}


def block_for(locale: str) -> str:
    values = TRANSLATIONS.get(locale, EN)
    lines = []
    for key in EN:
        lines.append(f'  {json.dumps(key)}: {json.dumps(values[key], ensure_ascii=False)},')
    return "\n".join(lines)


def upsert(path: Path, locale: str) -> None:
    text = path.read_text(encoding="utf-8")
    if "featureDemoTajweedTitle" in text:
        print(f"skip {path.name} (already present)")
        return
    pattern = rf'(  "{ANCHOR}": .*?,)\n'
    match = re.search(pattern, text)
    if not match:
        raise SystemExit(f"anchor missing in {path.name}")
    text = text[: match.end()] + block_for(locale) + "\n" + text[match.end() :]
    path.write_text(text, encoding="utf-8")
    print(f"updated {path.name}")


def main() -> None:
    for path in sorted(ROOT.glob("app_*.arb")):
        upsert(path, path.stem.removeprefix("app_"))


if __name__ == "__main__":
    main()
