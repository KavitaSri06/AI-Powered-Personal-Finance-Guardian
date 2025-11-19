package com.kavita.financeguardian.finance_guardian

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.provider.Telephony
import android.database.Cursor

class MainActivity: FlutterActivity() {

    private val CHANNEL = "sms_reader"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getSms" -> {
                    val sms = readSms()
                    result.success(sms)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun readSms(): List<Map<String, String>> {
        val list = mutableListOf<Map<String, String>>()

        val cursor: Cursor? = contentResolver.query(
            Telephony.Sms.Inbox.CONTENT_URI,
            arrayOf("body", "date"),
            null,
            null,
            "date DESC"
        )

        cursor?.use {
            while (it.moveToNext()) {
                list.add(
                    mapOf(
                        "body" to it.getString(0),
                        "date" to it.getString(1)
                    )
                )
            }
        }

        return list
    }
}
