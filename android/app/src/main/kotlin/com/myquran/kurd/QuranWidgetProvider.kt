package com.myquran.kurd

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import android.app.PendingIntent
import android.content.Intent
import es.antonborri.home_widget.HomeWidgetPlugin

class QuranWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        fun updateWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val widgetData = HomeWidgetPlugin.getData(context)

            val arabicText = widgetData.getString("widget_arabic_text",
                "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ")
            val kurdishText = widgetData.getString("widget_kurdish_text",
                "بە ناوی خوای بەخشەندەی میهرەبان")
            val surahName = widgetData.getString("widget_surah_name",
                "— الفاتحة : ١")

            val views = RemoteViews(context.packageName, R.layout.quran_widget)
            views.setTextViewText(R.id.widget_arabic_text, arabicText)
            views.setTextViewText(R.id.widget_kurdish_text, kurdishText)
            views.setTextViewText(R.id.widget_surah_name, surahName)

            // Tap on widget opens the app
            val intent = context.packageManager
                .getLaunchIntentForPackage(context.packageName)
            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(android.R.id.content, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
