package com.rnr.deenfocus

import android.app.Activity
import android.content.Intent
import android.content.res.Configuration
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

class FocusBlockedActivity : Activity() {
    private data class ThemePalette(
        val background: Int,
        val cardBackground: Int,
        val cardBorder: Int,
        val titleText: Int,
        val bodyText: Int,
        val infoCardBackground: Int,
        val infoLabelText: Int,
        val infoValueText: Int,
        val buttonStart: Int,
        val buttonEnd: Int,
        val buttonText: Int,
    )

    private data class ModeContent(
        val badge: String,
        val title: String,
        val description: String,
        val instruction: String,
        val quote: String,
        val actionLabel: String,
        val topGradientStart: Int,
        val topGradientEnd: Int,
        val badgeBg: Int,
        val badgeText: Int,
    )

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
        val activeMode = normalizeMode(intent.getStringExtra("activeMode"))
        val content = modeContent(activeMode)
        val palette = themePalette()

        window.decorView.setBackgroundColor(palette.background)

        val scrollView = ScrollView(this).apply {
            isFillViewport = true
        }

        val root = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER
            setPadding(dp(24), dp(32), dp(24), dp(32))
            background = GradientDrawable().apply {
                setColor(palette.background)
            }
        }

        val card = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER_HORIZONTAL
            setPadding(dp(24), dp(28), dp(24), dp(24))
            background = GradientDrawable().apply {
                cornerRadius = dpF(28)
                setColor(palette.cardBackground)
                setStroke(dp(1), palette.cardBorder)
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
            text = content.badge
            setTextColor(content.badgeText)
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 12f)
            setTypeface(typeface, Typeface.BOLD)
            background = GradientDrawable().apply {
                cornerRadius = dpF(999)
                setColor(content.badgeBg)
            }
            setPadding(dp(12), dp(6), dp(12), dp(6))
        }

        val title = TextView(this).apply {
            text = content.title
            setTextColor(palette.titleText)
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 27f)
            gravity = Gravity.CENTER
            setTypeface(typeface, Typeface.BOLD)
            setPadding(0, dp(18), 0, dp(10))
        }

        val description = TextView(this).apply {
            text = content.description
            setTextColor(palette.bodyText)
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 16f)
            gravity = Gravity.CENTER
            setLineSpacing(0f, 1.25f)
        }

        val instructionCard = infoCard(
            label = "Instruction",
            value = content.instruction,
            palette = palette,
        )

        val quoteCard = infoCard(
            label = if (activeMode == "salah") "Verse" else "Quote",
            value = content.quote,
            palette = palette,
        )

        val homeButton = Button(this).apply {
            text = content.actionLabel
            setTextColor(palette.buttonText)
            textSize = 16f
            typeface = Typeface.DEFAULT_BOLD
            background = GradientDrawable(
                GradientDrawable.Orientation.LEFT_RIGHT,
                intArrayOf(
                    palette.buttonStart,
                    palette.buttonEnd,
                ),
            ).apply {
                cornerRadius = dpF(18)
            }
            setPadding(dp(16), dp(16), dp(16), dp(16))
            setOnClickListener { navigateHome() }
        }

        card.addView(modeBadge)
        card.addView(title)
        card.addView(description)
        card.addView(space(18))
        card.addView(instructionCard)
        card.addView(space(12))
        card.addView(quoteCard)
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

    private fun infoCard(label: String, value: String, palette: ThemePalette): View {
        val container = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(dp(16), dp(14), dp(16), dp(14))
            background = GradientDrawable().apply {
                cornerRadius = dpF(20)
                setColor(palette.infoCardBackground)
                setStroke(dp(1), palette.cardBorder)
            }
        }

        val labelView = TextView(this).apply {
            text = label
            setTextColor(palette.infoLabelText)
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 12f)
            setTypeface(typeface, Typeface.BOLD)
        }

        val valueView = TextView(this).apply {
            text = value
            setTextColor(palette.infoValueText)
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 15f)
            setLineSpacing(0f, 1.2f)
            setPadding(0, dp(6), 0, 0)
        }

        container.addView(labelView)
        container.addView(valueView)
        return container
    }

    private fun themePalette(): ThemePalette {
        val isDarkTheme =
            resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK ==
                Configuration.UI_MODE_NIGHT_YES
        return if (isDarkTheme) {
            ThemePalette(
                background = Color.parseColor("#111B14"),
                cardBackground = Color.parseColor("#1D2820"),
                cardBorder = Color.parseColor("#4A4539"),
                titleText = Color.parseColor("#E0E3DC"),
                bodyText = Color.parseColor("#CFC6B4"),
                infoCardBackground = Color.parseColor("#232E26"),
                infoLabelText = Color.parseColor("#CFC6B4"),
                infoValueText = Color.parseColor("#E0E3DC"),
                buttonStart = Color.parseColor("#8ED4B4"),
                buttonEnd = Color.parseColor("#4E9A7C"),
                buttonText = Color.parseColor("#1B3D2E"),
            )
        } else {
            ThemePalette(
                background = Color.parseColor("#F7F5F0"),
                cardBackground = Color.parseColor("#FFFFFFFF"),
                cardBorder = Color.parseColor("#CFC6B4"),
                titleText = Color.parseColor("#1C2E24"),
                bodyText = Color.parseColor("#4A4539"),
                infoCardBackground = Color.parseColor("#F0E6D6"),
                infoLabelText = Color.parseColor("#3D3224"),
                infoValueText = Color.parseColor("#1C2E24"),
                buttonStart = Color.parseColor("#4E9A7C"),
                buttonEnd = Color.parseColor("#2E6B52"),
                buttonText = Color.parseColor("#FFFFFF"),
            )
        }
    }

    private fun normalizeMode(activeMode: String?): String? {
        return when (activeMode) {
            "child", "childMode" -> "child"
            "nightDiscipline", "night", "sleep", "sleepLock" -> "nightDiscipline"
            "salah", "prayer", "prayerLock" -> "salah"
            else -> activeMode
        }
    }

    private fun modeContent(activeMode: String?): ModeContent {
        return when (activeMode) {
            "salah" -> ModeContent(
                badge = "Prayer Mode",
                title = "Salah Time - Stay Focused",
                description = "Step away from distractions and answer the call to prayer.\nTake this moment to connect with Allah.",
                instruction = "Return after completing your Salah in DeenFocus.",
                quote = "\"Establish prayer for My remembrance.\"\n(Quran 20:14)",
                actionLabel = "Start My Salah",
                topGradientStart = Color.parseColor("#C8E6D8"),
                topGradientEnd = Color.parseColor("#F0E6D6"),
                badgeBg = Color.parseColor("#C8E6D8"),
                badgeText = Color.parseColor("#1B3D2E"),
            )
            "child" -> ModeContent(
                badge = "Child Mode",
                title = "Child Focus Mode",
                description = "This device is currently in child focus mode to help maintain a safe and balanced digital experience.",
                instruction = "Some apps are temporarily unavailable.",
                quote = "\"Teach your children prayer when they are seven.\"\n(Hadith - Abu Dawood)",
                actionLabel = "Continue in Safe Mode",
                topGradientStart = Color.parseColor("#C8E4F0"),
                topGradientEnd = Color.parseColor("#F0E6D6"),
                badgeBg = Color.parseColor("#C8E4F0"),
                badgeText = Color.parseColor("#163545"),
            )
            "nightDiscipline" -> ModeContent(
                badge = "Night Mode",
                title = "Night Focus Mode",
                description = "It's time to rest and disconnect from digital distractions.",
                instruction = "Put your device aside and enjoy a peaceful night.",
                quote = "\"And We made your sleep a means for rest.\"\n(Quran 78:9)",
                actionLabel = "Good Night 🌙",
                topGradientStart = Color.parseColor("#E9E5DB"),
                topGradientEnd = Color.parseColor("#C8E6D8"),
                badgeBg = Color.parseColor("#E3DFD5"),
                badgeText = Color.parseColor("#1C2E24"),
            )
            else -> ModeContent(
                badge = "Focus Mode",
                title = "Stay Focused",
                description = "Distractions are paused while your focus mode is active.",
                instruction = "Return once your focus session is complete in DeenFocus.",
                quote = "\"And seek help through patience and prayer.\"\n(Quran 2:45)",
                actionLabel = "Continue",
                topGradientStart = Color.parseColor("#C8E6D8"),
                topGradientEnd = Color.parseColor("#F0E6D6"),
                badgeBg = Color.parseColor("#C8E6D8"),
                badgeText = Color.parseColor("#1B3D2E"),
            )
        }
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
