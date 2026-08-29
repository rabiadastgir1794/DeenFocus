#!/usr/bin/env python3
"""Localize iOS Screen Time authorization error snackbars."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib" / "l10n"

EN = {
    "focusScreenTimeAuthPasscodeRequired": (
        "This iPhone needs a device passcode before Apple will allow Screen Time "
        "access. Set a passcode in iPhone Settings, then try again."
    ),
    "focusScreenTimeAuthCanceled": (
        "Screen Time access was canceled before Apple finished granting it. "
        "Please try again and complete the Apple prompt."
    ),
    "focusScreenTimeAuthConflict": (
        "Another app is already managing Family Controls on this iPhone. "
        "Turn that off first, then try again."
    ),
    "focusScreenTimeAuthInvalidAccount": (
        "Sign in with a valid iCloud account on this iPhone, then try Screen Time "
        "access again."
    ),
    "focusScreenTimeAuthNetwork": (
        "This iPhone needs an internet connection before Apple can grant Screen "
        "Time access."
    ),
    "focusScreenTimeAuthRestricted": (
        "Family Controls is restricted on this iPhone, so DeenFocus cannot request "
        "Screen Time access here."
    ),
    "focusScreenTimeAuthUnavailable": (
        "Family Controls is currently unavailable on this iPhone."
    ),
    "focusScreenTimeAuthIosVersion": (
        "Screen Time app blocking requires iOS 16 or later."
    ),
    "focusScreenTimeAuthInvalidArgument": (
        "The Screen Time authorization request was invalid. Please try again."
    ),
    "focusScreenTimeAuthFailedGeneric": (
        "Screen Time access could not be granted on this iPhone."
    ),
}

TRANSLATIONS: dict[str, dict[str, str]] = {
    "en": EN,
    "zh": {
        **EN,
        "focusScreenTimeAuthPasscodeRequired": "此 iPhone 需先设置设备密码，Apple 才会允许“屏幕使用时间”访问。请在设置中设置密码后重试。",
        "focusScreenTimeAuthCanceled": "屏幕使用时间授权在完成前被取消。请重试并完成 Apple 提示。",
        "focusScreenTimeAuthConflict": "另一款应用已在管理此 iPhone 上的“家人控制”。请先关闭后再试。",
        "focusScreenTimeAuthInvalidAccount": "请使用有效的 iCloud 账户登录此 iPhone，然后再次尝试屏幕使用时间访问。",
        "focusScreenTimeAuthNetwork": "此 iPhone 需要联网后，Apple 才能授予屏幕使用时间访问权限。",
        "focusScreenTimeAuthRestricted": "此 iPhone 上的“家人控制”受限，因此 DeenFocus 无法在此请求屏幕使用时间访问。",
        "focusScreenTimeAuthUnavailable": "此 iPhone 上暂时无法使用“家人控制”。",
        "focusScreenTimeAuthIosVersion": "屏幕使用时间应用拦截需要 iOS 16 或更高版本。",
        "focusScreenTimeAuthInvalidArgument": "屏幕使用时间授权请求无效。请重试。",
        "focusScreenTimeAuthFailedGeneric": "无法在此 iPhone 上授予屏幕使用时间访问权限。",
    },
    "ar": {
        **EN,
        "focusScreenTimeAuthPasscodeRequired": "يحتاج هذا الآيفون إلى رمز مرور قبل أن تسمح آبل بالوصول إلى مدة استخدام الجهاز. عيّن رمزًا في الإعدادات ثم أعد المحاولة.",
        "focusScreenTimeAuthCanceled": "أُلغي الوصول إلى مدة استخدام الجهاز قبل أن تُكمل آبل منحه. أعد المحاولة وأكمل مطالبة آبل.",
        "focusScreenTimeAuthConflict": "تطبيق آخر يدير عناصر التحكم العائلية على هذا الآيفون. أوقف ذلك أولاً ثم أعد المحاولة.",
        "focusScreenTimeAuthInvalidAccount": "سجّل الدخول بحساب آي كلاود صالح على هذا الآيفون ثم أعد محاولة الوصول إلى مدة استخدام الجهاز.",
        "focusScreenTimeAuthNetwork": "يحتاج هذا الآيفون إلى اتصال بالإنترنت قبل أن تمنح آبل الوصول إلى مدة استخدام الجهاز.",
        "focusScreenTimeAuthRestricted": "عناصر التحكم العائلية مقيّدة على هذا الآيفون، لذلك لا يمكن لـ DeenFocus طلب الوصول إلى مدة استخدام الجهاز هنا.",
        "focusScreenTimeAuthUnavailable": "عناصر التحكم العائلية غير متاحة حاليًا على هذا الآيفون.",
        "focusScreenTimeAuthIosVersion": "حظر التطبيقات عبر مدة استخدام الجهاز يتطلب iOS 16 أو أحدث.",
        "focusScreenTimeAuthInvalidArgument": "طلب تفويض مدة استخدام الجهاز غير صالح. أعد المحاولة.",
        "focusScreenTimeAuthFailedGeneric": "تعذّر منح الوصول إلى مدة استخدام الجهاز على هذا الآيفون.",
    },
    "de": {
        **EN,
        "focusScreenTimeAuthPasscodeRequired": "Dieses iPhone braucht einen Gerätecode, bevor Apple Bildschirmzeit-Zugriff erlaubt. Code in den Einstellungen setzen, dann erneut versuchen.",
        "focusScreenTimeAuthCanceled": "Der Bildschirmzeit-Zugriff wurde abgebrochen, bevor Apple ihn erteilt hat. Bitte erneut versuchen und die Apple-Abfrage abschließen.",
        "focusScreenTimeAuthConflict": "Eine andere App verwaltet bereits Familienkontrollen auf diesem iPhone. Zuerst deaktivieren, dann erneut versuchen.",
        "focusScreenTimeAuthInvalidAccount": "Mit einem gültigen iCloud-Konto auf diesem iPhone anmelden und Bildschirmzeit-Zugriff erneut versuchen.",
        "focusScreenTimeAuthNetwork": "Dieses iPhone braucht eine Internetverbindung, bevor Apple Bildschirmzeit-Zugriff erteilen kann.",
        "focusScreenTimeAuthRestricted": "Familienkontrollen sind auf diesem iPhone eingeschränkt, daher kann DeenFocus hier keinen Bildschirmzeit-Zugriff anfordern.",
        "focusScreenTimeAuthUnavailable": "Familienkontrollen sind auf diesem iPhone derzeit nicht verfügbar.",
        "focusScreenTimeAuthIosVersion": "App-Sperre über Bildschirmzeit erfordert iOS 16 oder neuer.",
        "focusScreenTimeAuthInvalidArgument": "Die Bildschirmzeit-Autorisierung war ungültig. Bitte erneut versuchen.",
        "focusScreenTimeAuthFailedGeneric": "Bildschirmzeit-Zugriff konnte auf diesem iPhone nicht erteilt werden.",
    },
    "es": {
        **EN,
        "focusScreenTimeAuthPasscodeRequired": "Este iPhone necesita un código de dispositivo antes de que Apple permita el acceso a Tiempo en pantalla. Configúralo en Ajustes e inténtalo de nuevo.",
        "focusScreenTimeAuthCanceled": "Se canceló el acceso a Tiempo en pantalla antes de que Apple lo concediera. Vuelve a intentarlo y completa el aviso de Apple.",
        "focusScreenTimeAuthConflict": "Otra app ya gestiona Controles parentales en este iPhone. Desactívala primero e inténtalo de nuevo.",
        "focusScreenTimeAuthInvalidAccount": "Inicia sesión con una cuenta de iCloud válida en este iPhone e intenta de nuevo el acceso a Tiempo en pantalla.",
        "focusScreenTimeAuthNetwork": "Este iPhone necesita conexión a internet para que Apple conceda el acceso a Tiempo en pantalla.",
        "focusScreenTimeAuthRestricted": "Los Controles parentales están restringidos en este iPhone, así que DeenFocus no puede solicitar el acceso a Tiempo en pantalla aquí.",
        "focusScreenTimeAuthUnavailable": "Los Controles parentales no están disponibles ahora en este iPhone.",
        "focusScreenTimeAuthIosVersion": "El bloqueo de apps con Tiempo en pantalla requiere iOS 16 o posterior.",
        "focusScreenTimeAuthInvalidArgument": "La solicitud de autorización de Tiempo en pantalla no es válida. Inténtalo de nuevo.",
        "focusScreenTimeAuthFailedGeneric": "No se pudo conceder el acceso a Tiempo en pantalla en este iPhone.",
    },
    "fr": {
        **EN,
        "focusScreenTimeAuthPasscodeRequired": "Cet iPhone doit avoir un code d’appareil avant qu’Apple n’autorise l’accès au Temps d’écran. Définissez-le dans Réglages, puis réessayez.",
        "focusScreenTimeAuthCanceled": "L’accès au Temps d’écran a été annulé avant qu’Apple ne l’accorde. Réessayez et terminez l’invite Apple.",
        "focusScreenTimeAuthConflict": "Une autre app gère déjà les Contrôles parentaux sur cet iPhone. Désactivez-la d’abord, puis réessayez.",
        "focusScreenTimeAuthInvalidAccount": "Connectez-vous avec un compte iCloud valide sur cet iPhone, puis réessayez l’accès au Temps d’écran.",
        "focusScreenTimeAuthNetwork": "Cet iPhone a besoin d’une connexion Internet pour qu’Apple accorde l’accès au Temps d’écran.",
        "focusScreenTimeAuthRestricted": "Les Contrôles parentaux sont restreints sur cet iPhone, DeenFocus ne peut donc pas demander l’accès au Temps d’écran ici.",
        "focusScreenTimeAuthUnavailable": "Les Contrôles parentaux sont actuellement indisponibles sur cet iPhone.",
        "focusScreenTimeAuthIosVersion": "Le blocage d’apps via le Temps d’écran nécessite iOS 16 ou une version ultérieure.",
        "focusScreenTimeAuthInvalidArgument": "La demande d’autorisation du Temps d’écran est invalide. Réessayez.",
        "focusScreenTimeAuthFailedGeneric": "L’accès au Temps d’écran n’a pas pu être accordé sur cet iPhone.",
    },
    "hi": {
        **EN,
        "focusScreenTimeAuthPasscodeRequired": "Apple स्क्रीन टाइम एक्सेस देने से पहले इस iPhone पर डिवाइस पासकोड होना चाहिए। सेटिंग्स में पासकोड सेट करें, फिर फिर से कोशिश करें।",
        "focusScreenTimeAuthCanceled": "Apple के अनुमति देने से पहले स्क्रीन टाइम एक्सेस रद्द हो गया। कृपया फिर से कोशिश करें और Apple का प्रॉम्प्ट पूरा करें।",
        "focusScreenTimeAuthConflict": "इस iPhone पर कोई अन्य ऐप पहले से फ़ैमिली कंट्रोल मैनेज कर रहा है। पहले उसे बंद करें, फिर फिर से कोशिश करें।",
        "focusScreenTimeAuthInvalidAccount": "इस iPhone पर मान्य iCloud खाते से साइन इन करें, फिर स्क्रीन टाइम एक्सेस फिर से आज़माएँ।",
        "focusScreenTimeAuthNetwork": "Apple स्क्रीन टाइम एक्सेस देने से पहले इस iPhone को इंटरनेट चाहिए।",
        "focusScreenTimeAuthRestricted": "इस iPhone पर फ़ैमिली कंट्रोल सीमित है, इसलिए DeenFocus यहाँ स्क्रीन टाइम एक्सेस नहीं माँग सकता।",
        "focusScreenTimeAuthUnavailable": "इस iPhone पर फ़ैमिली कंट्रोल अभी उपलब्ध नहीं है।",
        "focusScreenTimeAuthIosVersion": "स्क्रीन टाइम से ऐप ब्लॉक करने के लिए iOS 16 या नया चाहिए।",
        "focusScreenTimeAuthInvalidArgument": "स्क्रीन टाइम अनुमति अनुरोध अमान्य था। कृपया फिर से कोशिश करें।",
        "focusScreenTimeAuthFailedGeneric": "इस iPhone पर स्क्रीन टाइम एक्सेस नहीं दी जा सकी।",
    },
    "it": {
        **EN,
        "focusScreenTimeAuthPasscodeRequired": "Questo iPhone deve avere un codice dispositivo prima che Apple consenta l’accesso a Tempo di utilizzo. Impostalo in Impostazioni, poi riprova.",
        "focusScreenTimeAuthCanceled": "L’accesso a Tempo di utilizzo è stato annullato prima che Apple lo concedesse. Riprova e completa la richiesta di Apple.",
        "focusScreenTimeAuthConflict": "Un’altra app gestisce già i Controlli parentali su questo iPhone. Disattivala prima, poi riprova.",
        "focusScreenTimeAuthInvalidAccount": "Accedi con un account iCloud valido su questo iPhone, poi riprova l’accesso a Tempo di utilizzo.",
        "focusScreenTimeAuthNetwork": "Questo iPhone deve essere connesso a Internet perché Apple possa concedere l’accesso a Tempo di utilizzo.",
        "focusScreenTimeAuthRestricted": "I Controlli parentali sono limitati su questo iPhone, quindi DeenFocus non può richiedere qui l’accesso a Tempo di utilizzo.",
        "focusScreenTimeAuthUnavailable": "I Controlli parentali non sono al momento disponibili su questo iPhone.",
        "focusScreenTimeAuthIosVersion": "Il blocco delle app con Tempo di utilizzo richiede iOS 16 o successivo.",
        "focusScreenTimeAuthInvalidArgument": "La richiesta di autorizzazione di Tempo di utilizzo non è valida. Riprova.",
        "focusScreenTimeAuthFailedGeneric": "Non è stato possibile concedere l’accesso a Tempo di utilizzo su questo iPhone.",
    },
    "nl": {
        **EN,
        "focusScreenTimeAuthPasscodeRequired": "Deze iPhone heeft een toegangscode nodig voordat Apple Schermtijd-toegang toestaat. Stel die in bij Instellingen en probeer opnieuw.",
        "focusScreenTimeAuthCanceled": "Schermtijd-toegang is geannuleerd voordat Apple deze verleende. Probeer opnieuw en rond de Apple-prompt af.",
        "focusScreenTimeAuthConflict": "Een andere app beheert al Gezinscontroles op deze iPhone. Zet die eerst uit en probeer opnieuw.",
        "focusScreenTimeAuthInvalidAccount": "Meld je aan met een geldig iCloud-account op deze iPhone en probeer Schermtijd-toegang opnieuw.",
        "focusScreenTimeAuthNetwork": "Deze iPhone heeft internet nodig voordat Apple Schermtijd-toegang kan verlenen.",
        "focusScreenTimeAuthRestricted": "Gezinscontroles zijn beperkt op deze iPhone, dus DeenFocus kan hier geen Schermtijd-toegang aanvragen.",
        "focusScreenTimeAuthUnavailable": "Gezinscontroles zijn momenteel niet beschikbaar op deze iPhone.",
        "focusScreenTimeAuthIosVersion": "Apps blokkeren via Schermtijd vereist iOS 16 of nieuwer.",
        "focusScreenTimeAuthInvalidArgument": "Het Schermtijd-autorisatieverzoek was ongeldig. Probeer opnieuw.",
        "focusScreenTimeAuthFailedGeneric": "Schermtijd-toegang kon niet worden verleend op deze iPhone.",
    },
    "pt": {
        **EN,
        "focusScreenTimeAuthPasscodeRequired": "Este iPhone precisa de um código do dispositivo antes da Apple permitir o acesso ao Tempo de Uso. Defina-o em Ajustes e tente de novo.",
        "focusScreenTimeAuthCanceled": "O acesso ao Tempo de Uso foi cancelado antes da Apple concedê-lo. Tente de novo e conclua o aviso da Apple.",
        "focusScreenTimeAuthConflict": "Outro app já gerencia os Controles parentais neste iPhone. Desative-o primeiro e tente de novo.",
        "focusScreenTimeAuthInvalidAccount": "Entre com uma conta iCloud válida neste iPhone e tente o acesso ao Tempo de Uso novamente.",
        "focusScreenTimeAuthNetwork": "Este iPhone precisa de internet para a Apple conceder o acesso ao Tempo de Uso.",
        "focusScreenTimeAuthRestricted": "Os Controles parentais estão restritos neste iPhone, então o DeenFocus não pode solicitar o acesso ao Tempo de Uso aqui.",
        "focusScreenTimeAuthUnavailable": "Os Controles parentais estão indisponíveis neste iPhone no momento.",
        "focusScreenTimeAuthIosVersion": "O bloqueio de apps com Tempo de Uso exige iOS 16 ou posterior.",
        "focusScreenTimeAuthInvalidArgument": "A solicitação de autorização do Tempo de Uso é inválida. Tente de novo.",
        "focusScreenTimeAuthFailedGeneric": "Não foi possível conceder o acesso ao Tempo de Uso neste iPhone.",
    },
    "ro": {
        **EN,
        "focusScreenTimeAuthPasscodeRequired": "Acest iPhone are nevoie de un cod de dispozitiv înainte ca Apple să permită accesul la Timp ecran. Setează-l în Setări, apoi încearcă din nou.",
        "focusScreenTimeAuthCanceled": "Accesul la Timp ecran a fost anulat înainte ca Apple să-l acorde. Încearcă din nou și finalizează solicitarea Apple.",
        "focusScreenTimeAuthConflict": "O altă aplicație gestionează deja Controalele parentale pe acest iPhone. Dezactiveaz-o mai întâi, apoi încearcă din nou.",
        "focusScreenTimeAuthInvalidAccount": "Autentifică-te cu un cont iCloud valid pe acest iPhone, apoi încearcă din nou accesul la Timp ecran.",
        "focusScreenTimeAuthNetwork": "Acest iPhone are nevoie de internet pentru ca Apple să poată acorda accesul la Timp ecran.",
        "focusScreenTimeAuthRestricted": "Controalele parentale sunt restricționate pe acest iPhone, deci DeenFocus nu poate solicita aici accesul la Timp ecran.",
        "focusScreenTimeAuthUnavailable": "Controalele parentale nu sunt disponibile momentan pe acest iPhone.",
        "focusScreenTimeAuthIosVersion": "Blocarea aplicațiilor prin Timp ecran necesită iOS 16 sau o versiune ulterioară.",
        "focusScreenTimeAuthInvalidArgument": "Cererea de autorizare Timp ecran este invalidă. Încearcă din nou.",
        "focusScreenTimeAuthFailedGeneric": "Accesul la Timp ecran nu a putut fi acordat pe acest iPhone.",
    },
    "ru": {
        **EN,
        "focusScreenTimeAuthPasscodeRequired": "На этом iPhone нужен код-пароль устройства, прежде чем Apple разрешит доступ к Экранному времени. Задайте его в Настройках и повторите попытку.",
        "focusScreenTimeAuthCanceled": "Доступ к Экранному времени отменён до того, как Apple его предоставила. Повторите попытку и завершите запрос Apple.",
        "focusScreenTimeAuthConflict": "Другое приложение уже управляет Семейным доступом на этом iPhone. Сначала отключите его и повторите попытку.",
        "focusScreenTimeAuthInvalidAccount": "Войдите с действительной учётной записью iCloud на этом iPhone и снова запросите доступ к Экранному времени.",
        "focusScreenTimeAuthNetwork": "Этому iPhone нужен интернет, чтобы Apple могла предоставить доступ к Экранному времени.",
        "focusScreenTimeAuthRestricted": "Семейный доступ ограничен на этом iPhone, поэтому DeenFocus не может запросить доступ к Экранному времени здесь.",
        "focusScreenTimeAuthUnavailable": "Семейный доступ сейчас недоступен на этом iPhone.",
        "focusScreenTimeAuthIosVersion": "Блокировка приложений через Экранное время требует iOS 16 или новее.",
        "focusScreenTimeAuthInvalidArgument": "Запрос авторизации Экранного времени недействителен. Повторите попытку.",
        "focusScreenTimeAuthFailedGeneric": "Не удалось предоставить доступ к Экранному времени на этом iPhone.",
    },
    "az": {
        **EN,
        "focusScreenTimeAuthPasscodeRequired": "Apple Ekran vaxtına icazə verməzdən əvvəl bu iPhone-da cihaz parolu olmalıdır. Parametrlərdə parol qoyun, sonra yenidən cəhd edin.",
        "focusScreenTimeAuthCanceled": "Apple icazə verməzdən əvvəl Ekran vaxtı girişi ləğv edildi. Yenidən cəhd edin və Apple sorğusunu tamamlayın.",
        "focusScreenTimeAuthConflict": "Bu iPhone-da başqa tətbiq artıq Ailə nəzarətini idarə edir. Əvvəlcə onu söndürün, sonra yenidən cəhd edin.",
        "focusScreenTimeAuthInvalidAccount": "Bu iPhone-da etibarlı iCloud hesabı ilə daxil olun, sonra Ekran vaxtı girişini yenidən yoxlayın.",
        "focusScreenTimeAuthNetwork": "Apple Ekran vaxtı girişi verməzdən əvvəl bu iPhone internetə qoşulmalıdır.",
        "focusScreenTimeAuthRestricted": "Bu iPhone-da Ailə nəzarəti məhdudlaşdırılıb, ona görə DeenFocus burada Ekran vaxtı girişi istəyə bilməz.",
        "focusScreenTimeAuthUnavailable": "Bu iPhone-da Ailə nəzarəti hazırda əlçatan deyil.",
        "focusScreenTimeAuthIosVersion": "Ekran vaxtı ilə tətbiq bloklaması iOS 16 və ya daha yeni tələb edir.",
        "focusScreenTimeAuthInvalidArgument": "Ekran vaxtı icazə sorğusu etibarsızdır. Yenidən cəhd edin.",
        "focusScreenTimeAuthFailedGeneric": "Bu iPhone-da Ekran vaxtı girişi verilə bilmədi.",
    },
}


def main() -> None:
    for locale, values in TRANSLATIONS.items():
        path = ROOT / f"app_{locale}.arb"
        with path.open(encoding="utf-8") as f:
            data = json.load(f)
        data.update(values)
        with path.open("w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
            f.write("\n")
        print(f"Updated {path.name}")


if __name__ == "__main__":
    main()
