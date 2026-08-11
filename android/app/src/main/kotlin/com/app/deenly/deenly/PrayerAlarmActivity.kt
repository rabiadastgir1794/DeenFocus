package com.rnr.deenfocus

import android.app.Activity
import android.content.Context
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
import android.view.WindowManager
import android.widget.Button
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView
import androidx.core.app.NotificationManagerCompat

/**
 * Full-screen DeenFocus prayer alarm UI launched via AlarmManager + FSI.
 * Visual language mirrors [FocusBlockedActivity].
 */
class PrayerAlarmActivity : Activity() {
    private data class ThemePalette(
        val background: Int,
        val cardBackground: Int,
        val cardBorder: Int,
        val titleText: Int,
        val bodyText: Int,
        val infoCardBackground: Int,
        val infoLabelText: Int,
        val buttonStart: Int,
        val buttonEnd: Int,
        val buttonText: Int,
        val secondaryButtonText: Int,
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.addFlags(
            WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD,
        )
        render(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        render(intent)
    }

    override fun onDestroy() {
        val alarmId = intent?.getStringExtra(PrayerAlarmScheduler.EXTRA_ALARM_ID).orEmpty()
        if (alarmId.isNotBlank()) {
            NotificationManagerCompat.from(this)
                .cancel(PrayerAlarmScheduler.notificationIdFor(alarmId))
        }
        super.onDestroy()
    }

    @Deprecated("Deprecated in Java")
    override fun onBackPressed() {
        val alarmId = intent?.getStringExtra(PrayerAlarmScheduler.EXTRA_ALARM_ID).orEmpty()
        if (alarmId.isNotBlank()) {
            PrayerAlarmScheduler.cancelOne(this, alarmId)
        }
        @Suppress("DEPRECATION")
        super.onBackPressed()
    }

    private fun render(intent: Intent) {
        val palette = themePalette()
        val alarmId = intent.getStringExtra(PrayerAlarmScheduler.EXTRA_ALARM_ID).orEmpty()
        val prayer = intent.getStringExtra(PrayerAlarmScheduler.EXTRA_PRAYER).orEmpty()
        val prayerLabel = intent.getStringExtra(PrayerAlarmScheduler.EXTRA_PRAYER_LABEL)
            ?: prayer.replaceFirstChar { if (it.isLowerCase()) it.titlecase() else it.toString() }
        val subtitle = intent.getStringExtra(PrayerAlarmScheduler.EXTRA_SUBTITLE)
            ?: getString(R.string.prayer_alarm_subtitle)
        val badge = intent.getStringExtra(PrayerAlarmScheduler.EXTRA_BADGE)
            ?: getString(R.string.prayer_alarm_badge)
        val ivePrayed = intent.getStringExtra(PrayerAlarmScheduler.EXTRA_IVE_PRAYED)
            ?: getString(R.string.prayer_alarm_ive_prayed)
        val dismiss = intent.getStringExtra(PrayerAlarmScheduler.EXTRA_DISMISS)
            ?: getString(R.string.prayer_alarm_dismiss)
        val snooze = intent.getStringExtra(PrayerAlarmScheduler.EXTRA_SNOOZE)
            ?: getString(R.string.prayer_alarm_snooze)
        val snoozeMinutes = intent.getIntExtra(PrayerAlarmScheduler.EXTRA_SNOOZE_MINUTES, 10)

        if (alarmId.isNotBlank()) {
            NotificationManagerCompat.from(this)
                .cancel(PrayerAlarmScheduler.notificationIdFor(alarmId))
        }

        window.decorView.setBackgroundColor(palette.background)

        val scrollView = ScrollView(this).apply { isFillViewport = true }
        val root = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER
            setPadding(dp(24), dp(32), dp(24), dp(32))
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
            ).apply { bottomMargin = -dp(64) }
        }

        val badgeView = TextView(this).apply {
            text = badge.uppercase()
            setTextColor(Color.parseColor("#1C2E24"))
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 12f)
            setTypeface(typeface, Typeface.BOLD)
            background = GradientDrawable().apply {
                cornerRadius = dpF(999)
                setColor(Color.parseColor("#E3DFD5"))
            }
            setPadding(dp(12), dp(6), dp(12), dp(6))
        }

        val title = TextView(this).apply {
            text = subtitle
            setTextColor(palette.titleText)
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 22f)
            gravity = Gravity.CENTER
            setTypeface(typeface, Typeface.BOLD)
            setPadding(0, dp(18), 0, dp(8))
        }

        val prayerName = TextView(this).apply {
            text = prayerLabel
            setTextColor(palette.titleText)
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 34f)
            gravity = Gravity.CENTER
            setTypeface(typeface, Typeface.BOLD)
            setPadding(0, dp(4), 0, dp(12))
        }

        val info = TextView(this).apply {
            text = intent.getStringExtra(PrayerAlarmScheduler.EXTRA_TITLE)
                ?: getString(R.string.prayer_alarm_title_format, prayerLabel)
            setTextColor(palette.bodyText)
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 15f)
            gravity = Gravity.CENTER
            setLineSpacing(0f, 1.2f)
        }

        val prayedButton = Button(this).apply {
            text = ivePrayed
            setTextColor(palette.buttonText)
            textSize = 16f
            typeface = Typeface.DEFAULT_BOLD
            isAllCaps = false
            minHeight = dp(56)
            background = GradientDrawable(
                GradientDrawable.Orientation.LEFT_RIGHT,
                intArrayOf(palette.buttonStart, palette.buttonEnd),
            ).apply { cornerRadius = dpF(18) }
            setOnClickListener {
                PrayerAlarmStore.setPendingPrayed(this@PrayerAlarmActivity, prayer)
                if (alarmId.isNotBlank()) {
                    PrayerAlarmScheduler.cancelOne(this@PrayerAlarmActivity, alarmId)
                }
                startActivity(
                    Intent(this@PrayerAlarmActivity, MainActivity::class.java).apply {
                        flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                            Intent.FLAG_ACTIVITY_CLEAR_TOP or
                            Intent.FLAG_ACTIVITY_SINGLE_TOP
                        putExtra("prayer_alarm_prayed", prayer)
                    },
                )
                finish()
            }
        }

        val snoozeButton = TextView(this).apply {
            text = "$snooze ($snoozeMinutes)"
            setTextColor(palette.secondaryButtonText)
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 16f)
            gravity = Gravity.CENTER
            setTypeface(typeface, Typeface.BOLD)
            setPadding(0, dp(18), 0, dp(10))
            setOnClickListener {
                val snoozeIntent = Intent(this@PrayerAlarmActivity, PrayerAlarmReceiver::class.java).apply {
                    action = PrayerAlarmScheduler.ACTION_SNOOZE
                    putExtras(intent)
                }
                sendBroadcast(snoozeIntent)
                finish()
            }
        }

        val dismissButton = TextView(this).apply {
            text = dismiss
            setTextColor(palette.bodyText)
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 15f)
            gravity = Gravity.CENTER
            setPadding(0, dp(8), 0, dp(4))
            setOnClickListener {
                if (alarmId.isNotBlank()) {
                    PrayerAlarmScheduler.cancelOne(this@PrayerAlarmActivity, alarmId)
                }
                finish()
            }
        }

        card.addView(badgeView)
        card.addView(title)
        card.addView(prayerName)
        card.addView(info)
        card.addView(space(22))
        card.addView(
            prayedButton,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT,
            ),
        )
        card.addView(snoozeButton)
        card.addView(dismissButton)

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
                ViewGroup.LayoutParams.WRAP_CONTENT,
            ),
        )
        setContentView(scrollView)
    }

    private fun themePalette(): ThemePalette {
        val isDark =
            resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK ==
                Configuration.UI_MODE_NIGHT_YES
        return if (isDark) {
            ThemePalette(
                background = Color.parseColor("#111B14"),
                cardBackground = Color.parseColor("#1D2820"),
                cardBorder = Color.parseColor("#4A4539"),
                titleText = Color.parseColor("#E0E3DC"),
                bodyText = Color.parseColor("#CFC6B4"),
                infoCardBackground = Color.parseColor("#232E26"),
                infoLabelText = Color.parseColor("#CFC6B4"),
                buttonStart = Color.parseColor("#8ED4B4"),
                buttonEnd = Color.parseColor("#4E9A7C"),
                buttonText = Color.parseColor("#1B3D2E"),
                secondaryButtonText = Color.parseColor("#8ED4B4"),
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
                buttonStart = Color.parseColor("#4E9A7C"),
                buttonEnd = Color.parseColor("#2E6B52"),
                buttonText = Color.parseColor("#FFFFFF"),
                secondaryButtonText = Color.parseColor("#4E9A7C"),
            )
        }
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

    private fun dpF(value: Int): Float = dp(value).toFloat()

    companion object {
        fun intentFrom(context: Context, source: Intent): Intent {
            return Intent(context, PrayerAlarmActivity::class.java).apply {
                putExtras(source)
            }
        }
    }
}
