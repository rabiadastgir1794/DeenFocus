package com.rnr.deenfocus

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import android.widget.RemoteViews
import org.json.JSONArray
import org.json.JSONObject
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

private const val widgetPrefsName = "deenly_widget"
private const val widgetTimelineKey = "widget_timeline_json"

enum class WidgetSize {
    SMALL,
    MEDIUM,
    LARGE,
}

data class WidgetPrayer(
    val id: String,
    val label: String,
    val timeLabel: String,
    val isoTime: String,
)

data class WidgetVerse(
    val text: String,
    val source: String,
)

data class WidgetEntry(
    val dayKey: String,
    val dateLabel: String,
    val isDarkMode: Boolean,
    val verse: WidgetVerse?,
    val prayers: List<WidgetPrayer>,
)

internal object DeenWidgetStore {
    fun saveTimeline(context: Context, json: String) {
        context.getSharedPreferences(widgetPrefsName, Context.MODE_PRIVATE)
            .edit()
            .putString(widgetTimelineKey, json)
            .apply()
    }

    fun loadEntry(context: Context, today: LocalDate = LocalDate.now()): WidgetEntry? {
        val raw = context.getSharedPreferences(widgetPrefsName, Context.MODE_PRIVATE)
            .getString(widgetTimelineKey, null) ?: return null
        return runCatching {
            val root = JSONObject(raw)
            val entries = root.optJSONArray("entries") ?: JSONArray()
            val todayKey = today.toString()
            val parsed = buildList {
                for (index in 0 until entries.length()) {
                    val row = entries.optJSONObject(index) ?: continue
                    add(
                        WidgetEntry(
                            dayKey = row.optString("dayKey"),
                            dateLabel = row.optString("dateLabel"),
                            isDarkMode = row.optBoolean("isDarkMode", false),
                            verse = row.optJSONObject("verse")?.let {
                                WidgetVerse(
                                    text = it.optString("text"),
                                    source = it.optString("source"),
                                )
                            },
                            prayers = buildList {
                                val prayerRows = row.optJSONArray("prayers") ?: JSONArray()
                                for (prayerIndex in 0 until prayerRows.length()) {
                                    val prayer = prayerRows.optJSONObject(prayerIndex) ?: continue
                                    add(
                                        WidgetPrayer(
                                            id = prayer.optString("id"),
                                            label = prayer.optString("label"),
                                            timeLabel = prayer.optString("timeLabel"),
                                            isoTime = prayer.optString("isoTime"),
                                        ),
                                    )
                                }
                            },
                        ),
                    )
                }
            }
            parsed.firstOrNull { it.dayKey == todayKey } ?: parsed.firstOrNull()
        }.getOrNull()
    }
}

internal object DeenWidgetUpdater {
    private val timeFormatter: DateTimeFormatter = DateTimeFormatter.ISO_DATE_TIME

    fun refreshAll(context: Context) {
        val manager = AppWidgetManager.getInstance(context)
        updateForProvider(
            context,
            manager,
            SmallDeenWidgetProvider::class.java,
            WidgetSize.SMALL,
        )
        updateForProvider(
            context,
            manager,
            MediumDeenWidgetProvider::class.java,
            WidgetSize.MEDIUM,
        )
        updateForProvider(
            context,
            manager,
            LargeDeenWidgetProvider::class.java,
            WidgetSize.LARGE,
        )
    }

    fun updateWidgets(
        context: Context,
        manager: AppWidgetManager,
        appWidgetIds: IntArray,
        size: WidgetSize,
    ) {
        val entry = DeenWidgetStore.loadEntry(context)
        for (appWidgetId in appWidgetIds) {
            val views = buildViews(context, size, entry)
            manager.updateAppWidget(appWidgetId, views)
        }
    }

    private fun updateForProvider(
        context: Context,
        manager: AppWidgetManager,
        providerClass: Class<out AppWidgetProvider>,
        size: WidgetSize,
    ) {
        val ids = manager.getAppWidgetIds(ComponentName(context, providerClass))
        if (ids.isNotEmpty()) {
            updateWidgets(context, manager, ids, size)
        }
    }

    private fun buildViews(
        context: Context,
        size: WidgetSize,
        entry: WidgetEntry?,
    ): RemoteViews {
        val layoutId = when (size) {
            WidgetSize.SMALL -> R.layout.widget_small
            WidgetSize.MEDIUM -> R.layout.widget_medium
            WidgetSize.LARGE -> R.layout.widget_large
        }
        val views = RemoteViews(context.packageName, layoutId)
        views.setTextViewText(R.id.appName, context.getString(R.string.app_name))
        views.setTextViewText(R.id.currentDate, entry?.dateLabel ?: "Open Deenly")
        views.setOnClickPendingIntent(R.id.root, launchPendingIntent(context))

        if (entry == null) {
            bindEmptyState(views, size)
            return views
        }

        when (size) {
            WidgetSize.SMALL -> bindPrayerGrid(
                views = views,
                prayers = entry.prayers.filterNot { it.id == "sunrise" }.take(5),
                highlightPrayerId = findNextPrayerId(entry.prayers),
                topIds = intArrayOf(
                    R.id.grid1Top,
                    R.id.grid2Top,
                    R.id.grid3Top,
                    R.id.grid4Top,
                    R.id.grid5Top,
                ),
                bottomIds = intArrayOf(
                    R.id.grid1Bottom,
                    R.id.grid2Bottom,
                    R.id.grid3Bottom,
                    R.id.grid4Bottom,
                    R.id.grid5Bottom,
                ),
                iconIds = intArrayOf(
                    R.id.grid1Icon,
                    R.id.grid2Icon,
                    R.id.grid3Icon,
                    R.id.grid4Icon,
                    R.id.grid5Icon,
                ),
                highlightIds = intArrayOf(
                    R.id.grid1Highlight,
                    R.id.grid2Highlight,
                    R.id.grid3Highlight,
                    R.id.grid4Highlight,
                    R.id.grid5Highlight,
                ),
            )
            WidgetSize.MEDIUM -> bindPrayerGrid(
                views = views,
                prayers = entry.prayers.take(6),
                highlightPrayerId = findNextPrayerId(entry.prayers),
                topIds = intArrayOf(
                    R.id.grid1Top,
                    R.id.grid2Top,
                    R.id.grid3Top,
                    R.id.grid4Top,
                    R.id.grid5Top,
                    R.id.grid6Top,
                ),
                bottomIds = intArrayOf(
                    R.id.grid1Bottom,
                    R.id.grid2Bottom,
                    R.id.grid3Bottom,
                    R.id.grid4Bottom,
                    R.id.grid5Bottom,
                    R.id.grid6Bottom,
                ),
                iconIds = intArrayOf(
                    R.id.grid1Icon,
                    R.id.grid2Icon,
                    R.id.grid3Icon,
                    R.id.grid4Icon,
                    R.id.grid5Icon,
                    R.id.grid6Icon,
                ),
                highlightIds = intArrayOf(
                    R.id.grid1Highlight,
                    R.id.grid2Highlight,
                    R.id.grid3Highlight,
                    R.id.grid4Highlight,
                    R.id.grid5Highlight,
                    R.id.grid6Highlight,
                ),
            )
            WidgetSize.LARGE -> {
                views.setTextViewText(R.id.heading, context.getString(R.string.daily_verse))
                views.setTextViewText(
                    R.id.dailyVerse,
                    entry.verse?.text ?: context.getString(R.string.widget_empty_verse),
                )
                views.setTextViewText(R.id.dailyVerseSource, entry.verse?.source ?: "")
                bindPrayerGrid(
                    views = views,
                    prayers = entry.prayers.filterNot { it.id == "sunrise" }.take(5),
                    highlightPrayerId = findNextPrayerId(entry.prayers),
                    topIds = intArrayOf(
                        R.id.grid1Top,
                        R.id.grid2Top,
                        R.id.grid3Top,
                        R.id.grid4Top,
                        R.id.grid5Top,
                    ),
                    bottomIds = intArrayOf(
                        R.id.grid1Bottom,
                        R.id.grid2Bottom,
                        R.id.grid3Bottom,
                        R.id.grid4Bottom,
                        R.id.grid5Bottom,
                    ),
                    iconIds = intArrayOf(
                        R.id.grid1Icon,
                        R.id.grid2Icon,
                        R.id.grid3Icon,
                        R.id.grid4Icon,
                        R.id.grid5Icon,
                    ),
                    highlightIds = intArrayOf(
                        R.id.grid1Highlight,
                        R.id.grid2Highlight,
                        R.id.grid3Highlight,
                        R.id.grid4Highlight,
                        R.id.grid5Highlight,
                    ),
                )
            }
        }
        return views
    }

    private fun bindPrayerGrid(
        views: RemoteViews,
        prayers: List<WidgetPrayer>,
        highlightPrayerId: String?,
        topIds: IntArray,
        bottomIds: IntArray,
        iconIds: IntArray,
        highlightIds: IntArray,
    ) {
        for (index in topIds.indices) {
            val prayer = prayers.getOrNull(index)
            views.setTextViewText(topIds[index], prayer?.label ?: "--")
            views.setTextViewText(bottomIds[index], prayer?.timeLabel ?: "--")
            views.setImageViewResource(iconIds[index], iconForPrayer(prayer?.id))
            views.setViewVisibility(
                highlightIds[index],
                if (prayer != null && prayer.id == highlightPrayerId) android.view.View.VISIBLE
                else android.view.View.GONE,
            )
        }
    }

    private fun bindEmptyState(views: RemoteViews, size: WidgetSize) {
        when (size) {
            WidgetSize.LARGE -> {
                views.setTextViewText(R.id.heading, "Daily Verse")
                views.setTextViewText(R.id.dailyVerse, "Set your location in Deenly to load prayers and the daily verse.")
                views.setTextViewText(R.id.dailyVerseSource, "")
            }
            WidgetSize.SMALL,
            WidgetSize.MEDIUM,
            -> Unit
        }
    }

    private fun findNextPrayerId(prayers: List<WidgetPrayer>): String? {
        val now = LocalDateTime.now()
        return prayers.firstOrNull { prayer ->
            runCatching { LocalDateTime.parse(prayer.isoTime, timeFormatter) }
                .getOrNull()
                ?.isAfter(now) == true
        }?.id
    }

    private fun iconForPrayer(id: String?): Int {
        return when (id) {
            "fajr" -> R.drawable.fajr
            "sunrise" -> R.drawable.ic_widget_sunrise
            "dhuhr" -> R.drawable.dhuhr
            "asr" -> R.drawable.asar
            "maghrib" -> R.drawable.maghrib
            "isha" -> R.drawable.isha
            else -> R.drawable.ic_widget_prayer
        }
    }

    private fun launchPendingIntent(context: Context): PendingIntent {
        val intent = context.packageManager.getLaunchIntentForPackage(context.packageName)
            ?: Intent(context, MainActivity::class.java)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
        return PendingIntent.getActivity(context, 1001, intent, flags)
    }
}

abstract class BaseDeenWidgetProvider(
    private val size: WidgetSize,
) : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        DeenWidgetUpdater.updateWidgets(context, appWidgetManager, appWidgetIds, size)
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        when (intent.action) {
            Intent.ACTION_DATE_CHANGED,
            Intent.ACTION_TIME_CHANGED,
            Intent.ACTION_TIMEZONE_CHANGED,
            Intent.ACTION_BOOT_COMPLETED,
            AppWidgetManager.ACTION_APPWIDGET_UPDATE,
            -> DeenWidgetUpdater.refreshAll(context)
        }
    }
}

class SmallDeenWidgetProvider : BaseDeenWidgetProvider(WidgetSize.SMALL)

class MediumDeenWidgetProvider : BaseDeenWidgetProvider(WidgetSize.MEDIUM)

class LargeDeenWidgetProvider : BaseDeenWidgetProvider(WidgetSize.LARGE)
