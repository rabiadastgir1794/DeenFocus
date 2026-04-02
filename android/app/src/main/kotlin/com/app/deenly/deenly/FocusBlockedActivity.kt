package com.rnr.deenfocus

import android.app.Activity
import android.content.Intent
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Bundle
import android.util.TypedValue
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.TimeZone

class FocusBlockedActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        FocusDebugLogger.append(applicationContext, "blocked.activity", "onCreate intent=$intent")
        renderContent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        FocusDebugLogger.append(applicationContext, "blocked.activity", "onNewIntent intent=$intent")
        renderContent(intent)
    }

    @Deprecated("Deprecated in Java")
    override fun onBackPressed() {
        navigateHome()
    }

    private fun renderContent(intent: Intent) {
        val appName = intent.getStringExtra("blockedAppName").orEmpty()
        val activeMode = normalizeMode(intent.getStringExtra("activeMode"))
        val lockReason = intent.getStringExtra("lockReason")
        val nextChangeAt = intent.getStringExtra("nextChangeAt")

        window.decorView.setBackgroundColor(Color.parseColor("#F5F1E8"))

        val scrollView = ScrollView(this).apply {
            isFillViewport = true
        }

        val root = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER
            setPadding(dp(24), dp(32), dp(24), dp(32))
            background = GradientDrawable(
                GradientDrawable.Orientation.TOP_BOTTOM,
                intArrayOf(
                    Color.parseColor("#EDE0C7"),
                    Color.parseColor("#E2D0AF"),
                    Color.parseColor("#D7C29B"),
                ),
            )
        }

        val card = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER_HORIZONTAL
            setPadding(dp(24), dp(28), dp(24), dp(24))
            background = GradientDrawable().apply {
                cornerRadius = dpF(28)
                setColor(Color.parseColor("#FFFFFC"))
                setStroke(dp(1), Color.parseColor("#DDCDAF"))
            }
            elevation = dpF(18)
            translationZ = dpF(10)
        }

        val icon = ImageView(this).apply {
            setImageResource(R.mipmap.ic_launcher)
            layoutParams = LinearLayout.LayoutParams(dp(68), dp(68)).apply {
                gravity = Gravity.CENTER_HORIZONTAL
                topMargin = dp(18)
            }
        }

        val iconStack = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER
            addView(icon)
            translationY = -dpF(88)
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT,
            ).apply {
                bottomMargin = -dp(64)
            }
        }

        val modeBadge = TextView(this).apply {
            text = modeTitle(activeMode)
            setTextColor(Color.parseColor("#7B4E00"))
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 12f)
            setTypeface(typeface, Typeface.BOLD)
            background = GradientDrawable().apply {
                cornerRadius = dpF(999)
                setColor(Color.parseColor("#F6E7C7"))
            }
            setPadding(dp(12), dp(6), dp(12), dp(6))
        }

        val title = TextView(this).apply {
            text = if (appName.isBlank()) {
                "This app is blocked for now"
            } else {
                "$appName is blocked for now"
            }
            setTextColor(Color.parseColor("#2E2415"))
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 26f)
            gravity = Gravity.CENTER
            setTypeface(typeface, Typeface.BOLD)
            setPadding(0, dp(18), 0, dp(10))
        }

        val subtitle = TextView(this).apply {
            text = modeSummary(activeMode, appName)
            setTextColor(Color.parseColor("#6E5A39"))
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 16f)
            gravity = Gravity.CENTER
            setLineSpacing(0f, 1.25f)
        }

        val reasonCard = infoCard(
            label = "Why this app is blocked",
            value = lockReason ?: fallbackReason(activeMode),
        )

        val untilText = formatNextChange(nextChangeAt)
        val untilCard = infoCard(
            label = when (activeMode) {
                "child" -> "Unlocks"
                "nightDiscipline" -> "Next change"
                "salah" -> "Prayer window"
                else -> "Next change"
            },
            value = untilText,
        )

        val homeButton = Button(this).apply {
            text = "Return to Home"
            setTextColor(Color.WHITE)
            textSize = 16f
            typeface = Typeface.DEFAULT_BOLD
            background = GradientDrawable(
                GradientDrawable.Orientation.LEFT_RIGHT,
                intArrayOf(
                    Color.parseColor("#3C8D63"),
                    Color.parseColor("#2E6D4D"),
                ),
            ).apply {
                cornerRadius = dpF(18)
            }
            setPadding(dp(16), dp(16), dp(16), dp(16))
            setOnClickListener { navigateHome() }
        }

        card.addView(modeBadge)
        card.addView(title)
        card.addView(subtitle)
        card.addView(space(18))
        card.addView(reasonCard)
        card.addView(space(12))
        card.addView(untilCard)
        card.addView(space(22))
        card.addView(
            homeButton,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT,
            ),
        )

        root.addView(iconStack)
        root.addView(
            card,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT,
            ),
        )

        scrollView.addView(
            root,
            ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT,
            ),
        )

        setContentView(scrollView)
    }

    private fun infoCard(label: String, value: String): View {
        val container = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(dp(16), dp(14), dp(16), dp(14))
            background = GradientDrawable().apply {
                cornerRadius = dpF(20)
                setColor(Color.parseColor("#F8F2E6"))
                setStroke(dp(1), Color.parseColor("#E2D4B8"))
            }
        }

        val labelView = TextView(this).apply {
            text = label
            setTextColor(Color.parseColor("#8A6C39"))
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 12f)
            setTypeface(typeface, Typeface.BOLD)
        }

        val valueView = TextView(this).apply {
            text = value
            setTextColor(Color.parseColor("#3A2D18"))
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 15f)
            setLineSpacing(0f, 1.2f)
            setPadding(0, dp(6), 0, 0)
        }

        container.addView(labelView)
        container.addView(valueView)
        return container
    }

    private fun normalizeMode(activeMode: String?): String? {
        return when (activeMode) {
            "child", "childMode" -> "child"
            "nightDiscipline", "night", "sleep", "sleepLock" -> "nightDiscipline"
            "salah", "prayer", "prayerLock" -> "salah"
            else -> activeMode
        }
    }

    private fun modeTitle(activeMode: String?): String {
        return when (activeMode) {
            "child" -> "Child Mode Active"
            "nightDiscipline" -> "Sleep Lock Active"
            "salah" -> "Prayer Lock Active"
            else -> "Focus Mode Active"
        }
    }

    private fun modeSummary(activeMode: String?, appName: String): String {
        val appRef = if (appName.isBlank()) "This app" else appName
        return when (activeMode) {
            "child" -> "$appRef is being kept closed because Child Mode is protecting the device right now."
            "nightDiscipline" -> "$appRef is paused because Sleep Lock is active during your protected sleep schedule."
            "salah" -> "$appRef is paused because Prayer Lock is active for the current salah window."
            else -> "$appRef is unavailable while your current focus protection is active."
        }
    }

    private fun fallbackReason(activeMode: String?): String {
        return when (activeMode) {
            "child" -> "Child Mode is currently on, so selected apps stay blocked until the mode is turned off or the timed session ends."
            "nightDiscipline" -> "Sleep Lock is active during your protected schedule, so selected apps stay blocked inside that time window."
            "salah" -> "Prayer Lock keeps selected apps blocked during the active prayer time window."
            else -> "A focus mode is active, so this app is temporarily unavailable."
        }
    }

    private fun formatNextChange(nextChangeAt: String?): String {
        if (nextChangeAt.isNullOrBlank()) {
            return "This block stays in place until the active mode changes."
        }

        val millis = runCatching { nextChangeAt.toLong() }.getOrNull()
        if (millis != null) {
            return SimpleDateFormat("MMM d, h:mm a", Locale.getDefault()).format(Date(millis))
        }

        val isoPatterns = listOf(
            "yyyy-MM-dd'T'HH:mm:ss.SSSX",
            "yyyy-MM-dd'T'HH:mm:ssX",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd'T'HH:mm:ss",
        )
        val parsed = isoPatterns.asSequence()
            .mapNotNull { pattern ->
                runCatching {
                    SimpleDateFormat(pattern, Locale.US).apply {
                        // Flutter sends local ISO strings without a timezone suffix most of the time.
                        // Parsing those as UTC shifts the time and makes the "unlocks at" UI wrong.
                        timeZone = TimeZone.getDefault()
                    }.parse(nextChangeAt)
                }.getOrNull()
            }
            .firstOrNull()
        if (parsed != null) {
            return SimpleDateFormat("MMM d, h:mm a", Locale.getDefault()).format(parsed)
        }

        return "This block stays in place until the active mode changes."
    }

    private fun navigateHome() {
        startActivity(
            Intent(Intent.ACTION_MAIN).apply {
                addCategory(Intent.CATEGORY_HOME)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            },
        )
        finish()
    }

    private fun space(heightDp: Int): View {
        return View(this).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                dp(heightDp),
            )
        }
    }

    private fun dp(value: Int): Int {
        return TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_DIP,
            value.toFloat(),
            resources.displayMetrics,
        ).toInt()
    }

    private fun dpF(value: Int): Float {
        return TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_DIP,
            value.toFloat(),
            resources.displayMetrics,
        )
    }
}
