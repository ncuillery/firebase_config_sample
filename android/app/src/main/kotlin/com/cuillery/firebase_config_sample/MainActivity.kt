package com.cuillery.firebase_config_sample

import android.os.Bundle
import android.util.Log
import com.google.firebase.analytics.FirebaseAnalytics
import com.google.firebase.analytics.ktx.analytics
import com.google.firebase.analytics.ktx.logEvent
import com.google.firebase.ktx.Firebase
import com.google.firebase.remoteconfig.FirebaseRemoteConfig
import com.google.firebase.remoteconfig.ktx.remoteConfig
import com.google.firebase.remoteconfig.ktx.remoteConfigSettings
import io.flutter.embedding.android.FlutterActivity

private lateinit var firebaseAnalytics: FirebaseAnalytics
private lateinit var firebaseConfig: FirebaseRemoteConfig

class MainActivity: FlutterActivity() {
    private val TAG = "MainActivity"
    override fun onCreate(savedInstanceState: Bundle?) {
        Log.i(TAG, "onCreate")
        firebaseAnalytics = Firebase.analytics
        firebaseAnalytics.setUserProperty("app_country", "japan")
        firebaseAnalytics.logEvent("app_created") {}

        firebaseConfig = Firebase.remoteConfig
        val configSettings = remoteConfigSettings {
            minimumFetchIntervalInSeconds = 0
        }
        firebaseConfig.setConfigSettingsAsync(configSettings)

        firebaseConfig.fetchAndActivate()
                .addOnCompleteListener(this) { task ->
                    if (task.isSuccessful) {
                        val updated = task.result
                        Log.i(TAG, "Fetch and activate succeeded: $updated")
                        Log.i(TAG, firebaseConfig.getString("country"))
                    } else {
                        Log.i(TAG, "Fetch failed")
                    }
                }

        super.onCreate(savedInstanceState)
    }

}
