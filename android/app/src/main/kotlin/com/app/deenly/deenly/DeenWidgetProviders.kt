package com.rnr.deenfocus

import android.app.AlarmManager
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
import java.time.Instant
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.time.temporal.ChronoUnit

private const val widgetPrefsName = "deenly_widget"
private const val widgetTimelineKey = "widget_timeline_json"
private const val widgetRefreshAction = "com.rnr.deenfocus.WIDGET_REFRESH"
private const val widgetHighlightAlarmBase = 8300
private const val widgetHighlightAlarmMax = 64
private const val widgetHighlightScheduleDays = 2L

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

data class WidgetProgress(
    val completedCount: Int,
    val totalCount: Int,
    val flags: List<Boolean>,
    val countLabel: String,
    val statusMessage: String,
)

data class WidgetEntry(
    val timestamp: String,
    val dayKey: String,
    val dateLabel: String,
    val timeLabel: String,
    val isDarkMode: Boolean,
    val verse: WidgetVerse?,
    val progress: WidgetProgress?,
    val prayers: List<WidgetPrayer>,
)

data class WidgetUi(
    val brandName: String,
    val dailyVerseTitle: String,
    val timelinePlaceholder: String,
    val setLocationMessage: String,
    val prayerProgressTitle: String,
    val prayersCompletedSubtitle: String,
    val defaultProgressCountLabel: String,
)

data class WidgetTimelineBundle(
    val entry: WidgetEntry?,
    val ui: WidgetUi?,
)

internal object DeenWidgetStore {
    private val timestampFormatter: DateTimeFormatter = DateTimeFormatter.ISO_DATE_TIME

    fun saveTimeline(context: Context, json: String) {
        context.getSharedPreferences(widgetPrefsName, Context.MODE_PRIVATE)
            .edit()
            .putString(widgetTimelineKey, json)
            .apply()
    }

    fun loadTimelineBundle(context: Context, today: LocalDate = LocalDate.now()): WidgetTimelineBundle {
        val raw = context.getSharedPreferences(widgetPrefsName, Context.MODE_PRIVATE)
            .getString(widgetTimelineKey, null) ?: return WidgetTimelineBundle(null, null)
        return runCatching {
            val root = JSONObject(raw)
            WidgetTimelineBundle(
                entry = pickCurrentEntry(root, today),
                ui = parseUi(context, root),
            )
        }.getOrElse { WidgetTimelineBundle(null, null) }
    }

    private fun parseUi(context: Context, root: JSONObject): WidgetUi? {
        val ui = root.optJSONObject("ui") ?: return null
        return WidgetUi(
            brandName = ui.optString("brandName", "").ifEmpty { context.getString(R.string.app_name) },
            dailyVerseTitle = ui.optString("dailyVerseTitle", "").ifEmpty {
                context.getString(R.string.daily_verse)
            },
            timelinePlaceholder = ui.optString("timelinePlaceholder", "").ifEmpty {
                context.getString(R.string.widget_empty_verse)
            },
            setLocationMessage = ui.optString("setLocationMessage", "").ifEmpty {
                context.getString(R.string.widget_set_location)
            },
            prayerProgressTitle = ui.optString("prayerProgressTitle", "").ifEmpty {
                context.getString(R.string.widget_prayer_progress_title)
            },
            prayersCompletedSubtitle = ui.optString("prayersCompletedSubtitle", "").ifEmpty {
                context.getString(R.string.widget_prayers_completed_subtitle)
            },
            defaultProgressCountLabel = ui.optString("defaultProgressCountLabel", "").ifEmpty {
                "0 of 5"
            },
        )
    }

    private fun parseProgress(row: JSONObject): WidgetProgress? {
        val progress = row.optJSONObject("progress") ?: return null
        val flagsJson = progress.optJSONArray("flags") ?: JSONArray()
        val flags = buildList {
            for (i in 0 until flagsJson.length()) {
                add(flagsJson.optBoolean(i, false))
            }
        }
        return WidgetProgress(
            completedCount = progress.optInt("completedCount", 0),
            totalCount = progress.optInt("totalCount", 5),
            flags = flags,
            countLabel = progress.optString("countLabel"),
            statusMessage = progress.optString("statusMessage"),
        )
    }

    private fun pickCurrentEntry(root: JSONObject, today: LocalDate): WidgetEntry? {
        val entries = root.optJSONArray("entries") ?: JSONArray()
        val todayKey = today.toString()
        val parsed = buildList {
            for (index in 0 until entries.length()) {
                val row = entries.optJSONObject(index) ?: continue
                add(
                    WidgetEntry(
                        timestamp = row.optString("timestamp"),
                        dayKey = row.optString("dayKey"),
                        dateLabel = row.optString("dateLabel"),
                        timeLabel = row.optString("timeLabel"),
                        isDarkMode = row.optBoolean("isDarkMode", false),
                        verse = row.optJSONObject("verse")?.let {
                            WidgetVerse(
                                text = it.optString("text"),
                                source = it.optString("source"),
                            )
                        },
                        progress = parseProgress(row),
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
        val now = LocalDateTime.now()
        return parsed
            .lastOrNull { entry ->
                runCatching { LocalDateTime.parse(entry.timestamp, timestampFormatter) }
                    .getOrNull()
                    ?.let { !it.isAfter(now) } == true
            }
            ?: parsed.firstOrNull { it.dayKey == todayKey }
            ?: parsed.firstOrNull()
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
        scheduleNextRefresh(context, manager)
        schedulePrayerHighlightAlarms(context)
    }

    fun updateWidgets(
        context: Context,
        manager: AppWidgetManager,
        appWidgetIds: IntArray,
        size: WidgetSize,
    ) {
        val bundle = DeenWidgetStore.loadTimelineBundle(context)
        for (appWidgetId in appWidgetIds) {
            try {
                val views = buildViews(context, size, bundle.entry, bundle.ui)
                manager.updateAppWidget(appWidgetId, views)
            } catch (_: Exception) {
                // Never leave a dead/black widget tile if one layout bind fails.
                val fallback = RemoteViews(context.packageName, R.layout.widget_small)
                fallback.setTextViewText(
                    R.id.appName,
                    bundle.ui?.brandName ?: context.getString(R.string.app_name),
                )
                fallback.setTextViewText(
                    R.id.currentDate,
                    bundle.entry?.dateLabel
                        ?: bundle.ui?.timelinePlaceholder
                        ?: context.getString(R.string.widget_empty_verse),
                )
                fallback.setOnClickPendingIntent(R.id.root, launchPendingIntent(context))
                manager.updateAppWidget(appWidgetId, fallback)
            }
        }
    }

    private fun scheduleNextRefresh(
        context: Context,
        manager: AppWidgetManager,
    ) {
        val hasWidgets =
            manager.getAppWidgetIds(ComponentName(context, SmallDeenWidgetProvider::class.java)).isNotEmpty() ||
                manager.getAppWidgetIds(ComponentName(context, MediumDeenWidgetProvider::class.java)).isNotEmpty() ||
                manager.getAppWidgetIds(ComponentName(context, LargeDeenWidgetProvider::class.java)).isNotEmpty()
        if (!hasWidgets) return

        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val pendingIntent = refreshPendingIntent(context)
        val nextRefresh = LocalDateTime.now()
            .plusDays(1)
            .toLocalDate()
            .atStartOfDay()
            .atZone(ZoneId.systemDefault())
            .toInstant()
            .toEpochMilli()

        alarmManager.setAndAllowWhileIdle(
            AlarmManager.RTC_WAKEUP,
            nextRefresh,
            pendingIntent,
        )
    }

    /**
     * Refreshes widgets when the current prayer highlight should advance.
     */
    private fun schedulePrayerHighlightAlarms(context: Context) {
        val manager = AppWidgetManager.getInstance(context)
        val hasWidgets =
            manager.getAppWidgetIds(ComponentName(context, SmallDeenWidgetProvider::class.java)).isNotEmpty() ||
                manager.getAppWidgetIds(ComponentName(context, MediumDeenWidgetProvider::class.java)).isNotEmpty() ||
                manager.getAppWidgetIds(ComponentName(context, LargeDeenWidgetProvider::class.java)).isNotEmpty()
        if (!hasWidgets) {
            cancelPrayerHighlightAlarms(context)
            return
        }

        val raw = context.getSharedPreferences(widgetPrefsName, Context.MODE_PRIVATE)
            .getString(widgetTimelineKey, null)
        if (raw.isNullOrBlank()) {
            cancelPrayerHighlightAlarms(context)
            return
        }

        cancelPrayerHighlightAlarms(context)

        val boundaries = mutableListOf<Long>()
        runCatching {
            val root = JSONObject(raw)
            val entries = root.optJSONArray("entries") ?: return@runCatching
            val nowMillis = System.currentTimeMillis()
            val scheduleUntilMillis = Instant.now()
                .plus(widgetHighlightScheduleDays, ChronoUnit.DAYS)
                .toEpochMilli()
            for (i in 0 until entries.length()) {
                val row = entries.optJSONObject(i) ?: continue
                val prayers = row.optJSONArray("prayers") ?: continue
                for (j in 0 until prayers.length()) {
                    val p = prayers.optJSONObject(j) ?: continue
                    val iso = p.optString("isoTime")
                    val dt = parsePrayerLocalDateTime(iso) ?: continue
                    val boundary = dt
                        .atZone(ZoneId.systemDefault())
                        .toInstant()
                        .toEpochMilli()
                    if (boundary > nowMillis && boundary <= scheduleUntilMillis) {
                        boundaries.add(boundary)
                    }
                }
            }
        }

        val uniqueSorted = boundaries.distinct().sorted().take(widgetHighlightAlarmMax)
        if (uniqueSorted.isEmpty()) return

        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        uniqueSorted.forEachIndexed { index, atMillis ->
            val intent = Intent(context, SmallDeenWidgetProvider::class.java).apply {
                action = widgetRefreshAction
            }
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                widgetHighlightAlarmBase + index,
                intent,
                pendingIntentFlags(),
            )
            when {
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.S &&
                    alarmManager.canScheduleExactAlarms() -> {
                    alarmManager.setExactAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        atMillis,
                        pendingIntent,
                    )
                }
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.S &&
                    !alarmManager.canScheduleExactAlarms() -> {
                    alarmManager.setAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        atMillis,
                        pendingIntent,
                    )
                }
                Build.VERSION.SDK_INT >= Build.VERSION_CODES.M -> {
                    alarmManager.setExactAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        atMillis,
                        pendingIntent,
                    )
                }
                else -> {
                    @Suppress("DEPRECATION")
                    alarmManager.setExact(
                        AlarmManager.RTC_WAKEUP,
                        atMillis,
                        pendingIntent,
                    )
                }
            }
        }
    }

    private fun cancelPrayerHighlightAlarms(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        repeat(widgetHighlightAlarmMax) { index ->
            val intent = Intent(context, SmallDeenWidgetProvider::class.java).apply {
                action = widgetRefreshAction
            }
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                widgetHighlightAlarmBase + index,
                intent,
                PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE,
            )
            if (pendingIntent != null) {
                alarmManager.cancel(pendingIntent)
                pendingIntent.cancel()
            }
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
        ui: WidgetUi?,
    ): RemoteViews {
        val layoutId = when (size) {
            WidgetSize.SMALL -> R.layout.widget_small
            WidgetSize.MEDIUM -> R.layout.widget_medium
            WidgetSize.LARGE -> R.layout.widget_large
        }
        val views = RemoteViews(context.packageName, layoutId)
        views.setTextViewText(R.id.appName, ui?.brandName ?: context.getString(R.string.app_name))
        views.setTextViewText(
            R.id.currentDate,
            entry?.dateLabel ?: ui?.timelinePlaceholder ?: context.getString(R.string.widget_empty_verse),
        )
        views.setOnClickPendingIntent(R.id.root, launchPendingIntent(context))

        if (entry == null) {
            bindEmptyState(context, views, size, ui)
            return views
        }

        when (size) {
            WidgetSize.SMALL -> bindPrayerGrid(
                views = views,
                prayers = entry.prayers.filterNot { it.id == "sunrise" }.take(5),
                highlightPrayerId = findCurrentPrayerId(
                    entry.prayers.filterNot { it.id == "sunrise" },
                ),
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
            WidgetSize.MEDIUM -> {
                views.setTextViewText(
                    R.id.heading,
                    ui?.dailyVerseTitle ?: context.getString(R.string.daily_verse),
                )
                views.setTextViewText(
                    R.id.dailyVerse,
                    entry.verse?.text
                        ?: ui?.timelinePlaceholder
                        ?: context.getString(R.string.widget_empty_verse),
                )
                views.setTextViewText(R.id.dailyVerseSource, entry.verse?.source ?: "")
                bindPrayerGrid(
                    views = views,
                    prayers = entry.prayers.filterNot { it.id == "sunrise" }.take(5),
                    highlightPrayerId = findCurrentPrayerId(
                        entry.prayers.filterNot { it.id == "sunrise" },
                    ),
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
                    labelColor = 0xFFFFFFFF.toInt(),
                )
            }
            WidgetSize.LARGE -> {
                bindProgressSection(views, entry, ui, context)
                bindPrayerGrid(
                    views = views,
                    prayers = entry.prayers.filterNot { it.id == "sunrise" }.take(5),
                    highlightPrayerId = findCurrentPrayerId(
                        entry.prayers.filterNot { it.id == "sunrise" },
                    ),
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
                    labelColor = 0xFFFFFFFF.toInt(),
                )
            }
        }
        return views
    }

    private fun bindProgressSection(
        views: RemoteViews,
        entry: WidgetEntry,
        ui: WidgetUi?,
        context: Context,
    ) {
        val progress = entry.progress
        views.setTextViewText(
            R.id.progressTitle,
            ui?.prayerProgressTitle
                ?: context.getString(R.string.widget_prayer_progress_title),
        )
        views.setTextViewText(
            R.id.progressCount,
            progress?.countLabel
                ?: "${progress?.completedCount ?: 0} of ${progress?.totalCount ?: 5}",
        )
        views.setTextViewText(
            R.id.progressSubtitle,
            ui?.prayersCompletedSubtitle
                ?: context.getString(R.string.widget_prayers_completed_subtitle),
        )
        views.setTextViewText(
            R.id.progressStatus,
            progress?.statusMessage?.takeIf { it.isNotBlank() }
                ?: ui?.prayersCompletedSubtitle
                ?: "",
        )

        val bgIds = intArrayOf(
            R.id.progressDot1Bg,
            R.id.progressDot2Bg,
            R.id.progressDot3Bg,
            R.id.progressDot4Bg,
            R.id.progressDot5Bg,
        )
        val checkIds = intArrayOf(
            R.id.progressDot1Check,
            R.id.progressDot2Check,
            R.id.progressDot3Check,
            R.id.progressDot4Check,
            R.id.progressDot5Check,
        )
        for (index in bgIds.indices) {
            val done = progress?.flags?.getOrNull(index) == true
            views.setImageViewResource(
                bgIds[index],
                if (done) R.drawable.widget_progress_check_filled_on_green
                else R.drawable.widget_progress_check_empty_on_green,
            )
            views.setImageViewResource(
                checkIds[index],
                R.drawable.widget_progress_check_mark_on_green,
            )
            views.setViewVisibility(
                checkIds[index],
                if (done) android.view.View.VISIBLE else android.view.View.GONE,
            )
        }
    }

    private fun bindPrayerGrid(
        views: RemoteViews,
        prayers: List<WidgetPrayer>,
        highlightPrayerId: String?,
        topIds: IntArray,
        bottomIds: IntArray,
        iconIds: IntArray,
        highlightIds: IntArray,
        labelColor: Int = 0xFFFFFFFF.toInt(),
    ) {
        for (index in topIds.indices) {
            val prayer = prayers.getOrNull(index)
            views.setTextViewText(topIds[index], prayer?.label ?: "--")
            views.setTextViewText(bottomIds[index], prayer?.timeLabel ?: "--")
            views.setTextColor(topIds[index], labelColor)
            views.setTextColor(bottomIds[index], labelColor)
            views.setImageViewResource(iconIds[index], iconForPrayer(prayer?.id))
            views.setViewVisibility(
                highlightIds[index],
                if (prayer != null && prayer.id == highlightPrayerId) android.view.View.VISIBLE
                else android.view.View.GONE,
            )
        }
    }

    private fun bindEmptyState(context: Context, views: RemoteViews, size: WidgetSize, ui: WidgetUi?) {
        when (size) {
            WidgetSize.MEDIUM -> {
                views.setTextViewText(
                    R.id.heading,
                    ui?.dailyVerseTitle ?: context.getString(R.string.daily_verse),
                )
                views.setTextViewText(
                    R.id.dailyVerse,
                    ui?.setLocationMessage ?: context.getString(R.string.widget_set_location),
                )
                views.setTextViewText(R.id.dailyVerseSource, "")
            }
            WidgetSize.LARGE -> {
                views.setTextViewText(
                    R.id.progressTitle,
                    ui?.prayerProgressTitle
                        ?: context.getString(R.string.widget_prayer_progress_title),
                )
                views.setTextViewText(
                    R.id.progressCount,
                    ui?.defaultProgressCountLabel ?: "0 of 5",
                )
                views.setTextViewText(
                    R.id.progressSubtitle,
                    ui?.prayersCompletedSubtitle
                        ?: context.getString(R.string.widget_prayers_completed_subtitle),
                )
                views.setTextViewText(
                    R.id.progressStatus,
                    ui?.setLocationMessage ?: context.getString(R.string.widget_set_location),
                )
            }
            WidgetSize.SMALL -> Unit
        }
    }

    /**
     * Flutter may emit local wall times or UTC (`…Z`). [LocalDateTime.parse] alone often fails on `Z`,
     * so next-prayer highlighting never matched and stayed hidden.
     */
    private fun parsePrayerLocalDateTime(isoTime: String): LocalDateTime? {
        val raw = isoTime.trim()
        if (raw.isEmpty()) return null
        runCatching { Instant.parse(raw).atZone(ZoneId.systemDefault()).toLocalDateTime() }
            .getOrNull()
            ?.let { return it }
        runCatching { LocalDateTime.parse(raw, DateTimeFormatter.ISO_LOCAL_DATE_TIME) }
            .getOrNull()
            ?.let { return it }
        runCatching { LocalDateTime.parse(raw, timeFormatter) }.getOrNull()?.let { return it }
        return runCatching {
            LocalDateTime.parse(raw, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"))
        }.getOrNull()
    }

    /**
     * Resolves the current prayer from system time on every widget refresh.
     */
    private fun findCurrentPrayerId(prayers: List<WidgetPrayer>): String? {
        val now = LocalDateTime.now()
        val parsed = prayers.mapNotNull { prayer ->
            val start = parsePrayerLocalDateTime(prayer.isoTime) ?: return@mapNotNull null
            prayer to start
        }.sortedBy { it.second }
        if (parsed.isEmpty()) return null
        return parsed.lastOrNull { (_, start) -> !start.isAfter(now) }?.first?.id
            ?: parsed.last().first.id
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
        return PendingIntent.getActivity(context, 1001, intent, pendingIntentFlags())
    }

    private fun refreshPendingIntent(context: Context): PendingIntent {
        val intent = Intent(context, SmallDeenWidgetProvider::class.java).apply {
            action = widgetRefreshAction
        }
        return PendingIntent.getBroadcast(context, 1002, intent, pendingIntentFlags())
    }

    private fun pendingIntentFlags(): Int {
        val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
        return flags
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
        DeenWidgetUpdater.refreshAll(context)
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        when (intent.action) {
            Intent.ACTION_DATE_CHANGED,
            Intent.ACTION_TIME_CHANGED,
            Intent.ACTION_TIMEZONE_CHANGED,
            Intent.ACTION_BOOT_COMPLETED,
            widgetRefreshAction,
            AppWidgetManager.ACTION_APPWIDGET_UPDATE,
            -> DeenWidgetUpdater.refreshAll(context)
        }
    }
}

class SmallDeenWidgetProvider : BaseDeenWidgetProvider(WidgetSize.SMALL)

class MediumDeenWidgetProvider : BaseDeenWidgetProvider(WidgetSize.MEDIUM)

class LargeDeenWidgetProvider : BaseDeenWidgetProvider(WidgetSize.LARGE)
