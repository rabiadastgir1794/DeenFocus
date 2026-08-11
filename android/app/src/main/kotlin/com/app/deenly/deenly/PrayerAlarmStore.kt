package com.rnr.deenfocus

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject

/** Persists scheduled prayer alarms for reboot / timezone resync. */
object PrayerAlarmStore {
    private const val PREFS = "deenfocus_prayer_alarms"
    private const val KEY_ALARMS_JSON = "alarms_json"
    private const val KEY_PENDING_PRAYED = "pending_prayed_prayer"

    fun saveAlarms(context: Context, alarms: List<Map<String, Any?>>) {
        val array = JSONArray()
        for (alarm in alarms) {
            val obj = JSONObject()
            for ((key, value) in alarm) {
                obj.put(key, value ?: JSONObject.NULL)
            }
            array.put(obj)
        }
        prefs(context).edit().putString(KEY_ALARMS_JSON, array.toString()).apply()
    }

    fun loadAlarms(context: Context): List<MutableMap<String, Any?>> {
        val raw = prefs(context).getString(KEY_ALARMS_JSON, null) ?: return emptyList()
        return runCatching {
            val array = JSONArray(raw)
            val out = ArrayList<MutableMap<String, Any?>>(array.length())
            for (i in 0 until array.length()) {
                val obj = array.getJSONObject(i)
                val map = mutableMapOf<String, Any?>()
                val keys = obj.keys()
                while (keys.hasNext()) {
                    val key = keys.next()
                    val value = obj.get(key)
                    map[key] = if (value == JSONObject.NULL) null else value
                }
                out.add(map)
            }
            out
        }.getOrDefault(emptyList())
    }

    fun clearAlarms(context: Context) {
        prefs(context).edit().remove(KEY_ALARMS_JSON).apply()
    }

    fun setPendingPrayed(context: Context, prayer: String?) {
        val editor = prefs(context).edit()
        if (prayer.isNullOrBlank()) {
            editor.remove(KEY_PENDING_PRAYED)
        } else {
            editor.putString(KEY_PENDING_PRAYED, prayer)
        }
        // commit() so warm-start MainActivity can read before Flutter consumes.
        editor.commit()
    }

    fun consumePendingPrayed(context: Context): String? {
        val prefs = prefs(context)
        val value = prefs.getString(KEY_PENDING_PRAYED, null)
        if (value != null) {
            prefs.edit().remove(KEY_PENDING_PRAYED).commit()
        }
        return value
    }

    private fun prefs(context: Context) =
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
}
