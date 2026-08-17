#!/usr/bin/env python3
"""Upsert interactive Widgets / Live Activity demo strings into all ARBs."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib" / "l10n"

EN = {
    "featureDemoWidgetsIntroSubtitleIos":
        "Stay in DeenFocus. Long-press the Home Screen, add a widget, and try all three sizes.",
    "featureDemoWidgetsIntroSubtitleAndroid":
        "Stay in DeenFocus. Long-press the Home Screen, open the widget picker, and try all three sizes.",
    "featureDemoWidgetsLongPressCalloutIos": "Long-press the Home Screen to edit widgets",
    "featureDemoWidgetsLongPressCalloutAndroid": "Long-press the Home Screen to edit widgets",
    "featureDemoWidgetsAddCallout": "Tap + to choose a DeenFocus widget",
    "featureDemoWidgetsAddSlotLabel": "Add Widget",
    "featureDemoWidgetsGalleryTitle": "Choose a DeenFocus widget",
    "featureDemoWidgetsGallerySubtitle": "Switch between Small, Medium, and Large — then add it to your Home Screen.",
    "featureDemoWidgetsAddCta": "Add Widget",
    "featureDemoWidgetsAddCtaAndroid": "Add widget",
    "featureDemoWidgetsChangeCta": "Change size",
    "featureDemoWidgetSizeSmall": "Small",
    "featureDemoWidgetSizeMedium": "Medium",
    "featureDemoWidgetSizeLarge": "Large",
    "featureDemoWidgetSizeSmallSubtitle": "Compact prayer times at a glance",
    "featureDemoWidgetSizeMediumSubtitle": "Daily verse plus all five prayers",
    "featureDemoWidgetSizeLargeSubtitle": "Prayer progress with today’s schedule",
    "featureDemoLiveActivityIntroSubtitleIos":
        "Stay in DeenFocus. Enable Live Activity in Settings, then see Lock Screen and Dynamic Island updates.",
    "featureDemoLiveActivityIntroSubtitleAndroid":
        "Stay in DeenFocus. Enable Live Activity in Settings, then see the ongoing prayer notification and shade.",
    "featureDemoLiveOpenPrayerCalcCallout": "Tap Prayer Calculation",
    "featureDemoLiveEnableToggleCallout": "Turn on Enable Live Activity",
    "featureDemoLiveLockScreenCallout": "Your prayer Live Activity on the Lock Screen",
    "featureDemoLiveCompactTitle": "Compact Dynamic Island",
    "featureDemoLiveCompactCallout": "Current prayer stays visible at the top",
    "featureDemoLiveExpandCta": "Expand Dynamic Island",
    "featureDemoLiveExpandedTitle": "Expanded Dynamic Island",
    "featureDemoLiveExpandedCallout": "See current time and the next prayer together",
    "featureDemoLiveActivityCompletionSubtitleIos": "Lock Screen and Dynamic Island, ready.",
    "featureDemoLiveActivityCompletionSubtitleAndroid": "Ongoing prayer updates, ready.",
    "featureDemoLiveActivityCompletionBodyIos":
        "Enable Live Activity in Settings → Prayer Calculation to show prayer updates on your Lock Screen and Dynamic Island.",
    "featureDemoLiveActivityCompletionBodyAndroid":
        "Enable Live Activity in Settings → Prayer Calculation to show an ongoing prayer notification on Android.",
    "featureDemoAndroidStatusBarHint": "Ongoing notification",
    "featureDemoAndroidOngoingTitle": "Live prayer notification",
    "featureDemoAndroidOngoingCallout": "Silent ongoing update — current and next prayer",
    "featureDemoAndroidOpenShadeCta": "Open notification shade",
    "featureDemoAndroidShadeTitle": "Notification shade",
    "featureDemoAndroidShadeCallout": "Expand to see the full current and next prayer status",
    "featureDemoAndroidOngoingBadge": "Ongoing",
}

# Keep older keys in sync / override intro strings used by copy.
EN_OVERRIDES = {
    "featureDemoWidgetsIntroSubtitle": EN["featureDemoWidgetsIntroSubtitleIos"],
    "featureDemoLiveActivityIntroSubtitle": EN["featureDemoLiveActivityIntroSubtitleIos"],
    "featureDemoWidgetsShowcaseCallout": EN["featureDemoWidgetsLongPressCalloutIos"],
    "featureDemoLiveActivityShowcaseCallout": EN["featureDemoLiveOpenPrayerCalcCallout"],
}

TRANSLATIONS: dict[str, dict[str, str]] = {
    "en": {**EN, **EN_OVERRIDES},
    "fr": {
        **EN,
        **EN_OVERRIDES,
        "featureDemoWidgetsIntroSubtitleIos":
            "Restez dans DeenFocus. Appuyez longuement sur l’écran d’accueil, ajoutez un widget et essayez les 3 tailles.",
        "featureDemoWidgetsIntroSubtitleAndroid":
            "Restez dans DeenFocus. Appuyez longuement sur l’écran d’accueil, ouvrez le sélecteur et essayez les 3 tailles.",
        "featureDemoWidgetsLongPressCalloutIos": "Appuyez longuement sur l’écran d’accueil",
        "featureDemoWidgetsLongPressCalloutAndroid": "Appuyez longuement sur l’écran d’accueil",
        "featureDemoWidgetsAddCallout": "Touchez + pour choisir un widget DeenFocus",
        "featureDemoWidgetsAddSlotLabel": "Ajouter un widget",
        "featureDemoWidgetsGalleryTitle": "Choisissez un widget DeenFocus",
        "featureDemoWidgetsGallerySubtitle": "Passez de Petit à Moyen à Grand — puis ajoutez-le à l’écran d’accueil.",
        "featureDemoWidgetsAddCta": "Ajouter le widget",
        "featureDemoWidgetsAddCtaAndroid": "Ajouter le widget",
        "featureDemoWidgetsChangeCta": "Changer la taille",
        "featureDemoWidgetSizeSmall": "Petit",
        "featureDemoWidgetSizeMedium": "Moyen",
        "featureDemoWidgetSizeLarge": "Grand",
        "featureDemoWidgetSizeSmallSubtitle": "Horaires de prière compacts",
        "featureDemoWidgetSizeMediumSubtitle": "Verset du jour et les cinq prières",
        "featureDemoWidgetSizeLargeSubtitle": "Progression des prières et planning du jour",
        "featureDemoLiveActivityIntroSubtitleIos":
            "Restez dans DeenFocus. Activez l’activité en direct, puis voyez l’écran de verrouillage et Dynamic Island.",
        "featureDemoLiveActivityIntroSubtitleAndroid":
            "Restez dans DeenFocus. Activez l’activité en direct, puis voyez la notification permanente et le panneau.",
        "featureDemoLiveOpenPrayerCalcCallout": "Touchez Calcul de prière",
        "featureDemoLiveEnableToggleCallout": "Activez « Activer l’activité en direct »",
        "featureDemoLiveLockScreenCallout": "Votre activité de prière sur l’écran de verrouillage",
        "featureDemoLiveCompactTitle": "Dynamic Island compacte",
        "featureDemoLiveCompactCallout": "La prière actuelle reste visible en haut",
        "featureDemoLiveExpandCta": "Agrandir Dynamic Island",
        "featureDemoLiveExpandedTitle": "Dynamic Island agrandie",
        "featureDemoLiveExpandedCallout": "Heure actuelle et prochaine prière ensemble",
        "featureDemoAndroidOngoingTitle": "Notification de prière en direct",
        "featureDemoAndroidOpenShadeCta": "Ouvrir le panneau de notifications",
        "featureDemoAndroidShadeTitle": "Panneau de notifications",
        "featureDemoAndroidOngoingBadge": "En cours",
    },
    "zh": {
        **EN,
        **EN_OVERRIDES,
        "featureDemoWidgetsIntroSubtitleIos": "留在 DeenFocus。长按主屏幕，添加小组件，并试用全部 3 种尺寸。",
        "featureDemoWidgetsIntroSubtitleAndroid": "留在 DeenFocus。长按主屏幕，打开小组件选择器，试用全部 3 种尺寸。",
        "featureDemoWidgetsLongPressCalloutIos": "长按主屏幕以编辑小组件",
        "featureDemoWidgetsLongPressCalloutAndroid": "长按主屏幕以编辑小组件",
        "featureDemoWidgetsAddCallout": "点击 + 选择 DeenFocus 小组件",
        "featureDemoWidgetsAddSlotLabel": "添加小组件",
        "featureDemoWidgetsGalleryTitle": "选择 DeenFocus 小组件",
        "featureDemoWidgetsChangeCta": "更换尺寸",
        "featureDemoWidgetSizeSmall": "小号",
        "featureDemoWidgetSizeMedium": "中号",
        "featureDemoWidgetSizeLarge": "大号",
        "featureDemoLiveOpenPrayerCalcCallout": "点击礼拜计算",
        "featureDemoLiveEnableToggleCallout": "打开“启用实时活动”",
        "featureDemoLiveCompactTitle": "紧凑灵动岛",
        "featureDemoLiveExpandCta": "展开灵动岛",
        "featureDemoLiveExpandedTitle": "展开的灵动岛",
        "featureDemoAndroidOngoingTitle": "实时礼拜通知",
        "featureDemoAndroidOpenShadeCta": "打开通知栏",
        "featureDemoAndroidShadeTitle": "通知栏",
        "featureDemoAndroidOngoingBadge": "进行中",
    },
    "ar": {
        **EN,
        **EN_OVERRIDES,
        "featureDemoWidgetsLongPressCalloutIos": "اضغط مطولًا على الشاشة الرئيسية لتعديل الأدوات",
        "featureDemoWidgetsAddCallout": "اضغط + لاختيار أداة DeenFocus",
        "featureDemoWidgetsAddSlotLabel": "إضافة أداة",
        "featureDemoWidgetsGalleryTitle": "اختر أداة DeenFocus",
        "featureDemoWidgetsChangeCta": "تغيير الحجم",
        "featureDemoWidgetSizeSmall": "صغير",
        "featureDemoWidgetSizeMedium": "متوسط",
        "featureDemoWidgetSizeLarge": "كبير",
        "featureDemoLiveOpenPrayerCalcCallout": "اضغط على حساب الصلاة",
        "featureDemoLiveEnableToggleCallout": "فعّل «تفعيل النشاط المباشر»",
        "featureDemoAndroidOngoingTitle": "إشعار الصلاة المباشر",
        "featureDemoAndroidOpenShadeCta": "افتح ظل الإشعارات",
        "featureDemoAndroidShadeTitle": "ظل الإشعارات",
    },
    "de": {
        **EN,
        **EN_OVERRIDES,
        "featureDemoWidgetsLongPressCalloutIos": "Lange auf den Home-Bildschirm tippen",
        "featureDemoWidgetsAddCallout": "Tippe auf +, um ein DeenFocus-Widget zu wählen",
        "featureDemoWidgetsGalleryTitle": "DeenFocus-Widget wählen",
        "featureDemoWidgetSizeSmall": "Klein",
        "featureDemoWidgetSizeMedium": "Mittel",
        "featureDemoWidgetSizeLarge": "Groß",
        "featureDemoLiveOpenPrayerCalcCallout": "Tippe auf Gebetsberechnung",
        "featureDemoLiveEnableToggleCallout": "Live Activity aktivieren",
        "featureDemoAndroidOpenShadeCta": "Benachrichtigungsleiste öffnen",
    },
    "es": {
        **EN,
        **EN_OVERRIDES,
        "featureDemoWidgetsLongPressCalloutIos": "Mantén pulsada la pantalla de inicio",
        "featureDemoWidgetsAddCallout": "Toca + para elegir un widget de DeenFocus",
        "featureDemoWidgetsGalleryTitle": "Elige un widget de DeenFocus",
        "featureDemoWidgetSizeSmall": "Pequeño",
        "featureDemoWidgetSizeMedium": "Mediano",
        "featureDemoWidgetSizeLarge": "Grande",
        "featureDemoLiveOpenPrayerCalcCallout": "Toca Cálculo de oración",
        "featureDemoAndroidOpenShadeCta": "Abrir panel de notificaciones",
    },
}

for code in ("az", "hi", "it", "nl", "pt", "ro", "ru"):
    TRANSLATIONS.setdefault(code, {**EN, **EN_OVERRIDES})


def upsert(path: Path, locale: str) -> None:
    data = json.loads(path.read_text(encoding="utf-8"))
    values = TRANSLATIONS.get(locale, {**EN, **EN_OVERRIDES})
    for key, value in values.items():
        data[key] = value
    for key, value in {**EN, **EN_OVERRIDES}.items():
        data.setdefault(key, value)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"updated {path.name}")


def main() -> None:
    for path in sorted(ROOT.glob("app_*.arb")):
        if path.name.endswith(".bak"):
            continue
        upsert(path, path.stem.removeprefix("app_"))


if __name__ == "__main__":
    main()
