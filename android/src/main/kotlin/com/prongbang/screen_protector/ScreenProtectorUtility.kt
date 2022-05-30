package com.prongbang.screen_protector

import android.os.Build
import androidx.annotation.ChecksSdkIntAtLeast
import com.prongbang.screenprotect.ScreenProtector

interface ScreenProtectorUtility {
    fun protectDataLeakageOn(): Boolean
    fun protectDataLeakageOff(): Boolean
    fun preventScreenshotOn(): Boolean
    fun preventScreenshotOff(): Boolean
    fun isSDKMoreThanRVersion(): Boolean
    fun protectRecentScreen(enabled: Boolean): Boolean
}

class AndroidScreenProtectorUtility(
    private val screenProtector: ScreenProtector
) : ScreenProtectorUtility {

    override fun protectDataLeakageOn(): Boolean {
        return preventScreenshotAndProtectDataLeakageOn()
    }

    override fun protectDataLeakageOff(): Boolean {
        return preventScreenshotAndProtectDataLeakageOff()
    }

    override fun preventScreenshotOn(): Boolean {
        return preventScreenshotAndProtectDataLeakageOn()
    }

    override fun preventScreenshotOff(): Boolean {
        return preventScreenshotAndProtectDataLeakageOff()
    }

    @ChecksSdkIntAtLeast(api = Build.VERSION_CODES.R)
    override fun isSDKMoreThanRVersion(): Boolean {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.R
    }

    override fun protectRecentScreen(enabled: Boolean): Boolean {
        return try {
            screenProtector.process(enabled)
            true
        } catch (_: Exception) {
            false
        }
    }

    private fun preventScreenshotAndProtectDataLeakageOff(): Boolean {
        return try {
            screenProtector.unprotect()
            true
        } catch (_: Exception) {
            false
        }
    }

    private fun preventScreenshotAndProtectDataLeakageOn(): Boolean {
        return try {
            screenProtector.protect()
            true
        } catch (_: Exception) {
            false
        }
    }
}