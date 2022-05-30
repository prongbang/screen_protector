package com.prongbang.screen_protector

import android.app.Activity
import androidx.annotation.NonNull
import com.prongbang.screenprotect.AndroidScreenProtector
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** ScreenProtectorPlugin */
class ScreenProtectorPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private var activity: Activity? = null
    private var screenProtectorUtility: ScreenProtectorUtility? = null

    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "screen_protector")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) =
        when (call.method) {
            "preventScreenshotOn" -> {
                val data = screenProtectorUtility?.preventScreenshotOn() ?: false
                result.success(data)
            }
            "preventScreenshotOff" -> {
                val data = screenProtectorUtility?.preventScreenshotOff() ?: false
                result.success(data)
            }
            "protectDataLeakageOn" -> {
                val data = screenProtectorUtility?.protectDataLeakageOn() ?: false
                result.success(data)
            }
            "protectDataLeakageOff" -> {
                val data = screenProtectorUtility?.preventScreenshotOff() ?: false
                result.success(data)
            }
            else -> result.success(false)
        }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        val screenProtector = AndroidScreenProtector.newInstance(activity)
        screenProtectorUtility = AndroidScreenProtectorUtility(screenProtector)
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        val screenProtector = AndroidScreenProtector.newInstance(activity)
        screenProtectorUtility = AndroidScreenProtectorUtility(screenProtector)
    }

    override fun onDetachedFromActivity() {
    }
}
