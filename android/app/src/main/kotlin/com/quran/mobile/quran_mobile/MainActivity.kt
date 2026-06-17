package com.quran.mobile.quran_mobile

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.InputStreamReader
import java.io.OutputStreamWriter
import java.io.File
import java.io.BufferedReader
import java.io.BufferedWriter
import java.nio.charset.StandardCharsets

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // Clean up large cache keys from SharedPreferences XML to prevent OutOfMemoryError on startup
        try {
            val sharedPrefsFile = File(applicationContext.filesDir.parentFile, "shared_prefs/FlutterSharedPreferences.xml")
            if (sharedPrefsFile.exists()) {
                val tempFile = File(applicationContext.filesDir.parentFile, "shared_prefs/FlutterSharedPreferences.xml.tmp")
                var modified = false
                
                val bufferSize = 2048
                val buffer = CharArray(bufferSize)
                var bufferLength = 0
                
                BufferedReader(InputStreamReader(FileInputStream(sharedPrefsFile), StandardCharsets.UTF_8)).use { reader ->
                    BufferedWriter(OutputStreamWriter(FileOutputStream(tempFile), StandardCharsets.UTF_8)).use { writer ->
                        var skipLine = false
                        var bufferFilled = false
                        
                        while (true) {
                            val cInt = reader.read()
                            if (cInt == -1) {
                                if (!skipLine) {
                                    if (!bufferFilled) {
                                        val lineContent = String(buffer, 0, bufferLength)
                                        if (lineContent.contains("name=\"flutter.cache_") || lineContent.contains("name='flutter.cache_")) {
                                            modified = true
                                        } else {
                                            writer.write(buffer, 0, bufferLength)
                                        }
                                    } else {
                                        writer.write(buffer, 0, bufferLength)
                                    }
                                }
                                break
                            }
                            val c = cInt.toChar()
                            
                            if (c == '\n') {
                                if (!skipLine) {
                                    if (!bufferFilled) {
                                        val lineContent = String(buffer, 0, bufferLength)
                                        if (lineContent.contains("name=\"flutter.cache_") || lineContent.contains("name='flutter.cache_")) {
                                            modified = true
                                        } else {
                                            writer.write(buffer, 0, bufferLength)
                                            writer.write(cInt)
                                        }
                                    } else {
                                        writer.write(buffer, 0, bufferLength)
                                        writer.write(cInt)
                                    }
                                }
                                bufferLength = 0
                                skipLine = false
                                bufferFilled = false
                            } else {
                                if (skipLine) {
                                    continue
                                }
                                
                                if (!bufferFilled) {
                                    buffer[bufferLength++] = c
                                    if (bufferLength == bufferSize) {
                                        bufferFilled = true
                                        val linePrefix = String(buffer, 0, bufferLength)
                                        if (linePrefix.contains("name=\"flutter.cache_") || linePrefix.contains("name='flutter.cache_")) {
                                            skipLine = true
                                            modified = true
                                            bufferLength = 0
                                        } else {
                                            writer.write(buffer, 0, bufferLength)
                                            bufferLength = 0
                                        }
                                    }
                                } else {
                                    writer.write(cInt)
                                }
                            }
                        }
                    }
                }
                
                if (modified) {
                    if (sharedPrefsFile.delete()) {
                        tempFile.renameTo(sharedPrefsFile)
                    }
                } else {
                    tempFile.delete()
                }
            }
        } catch (e: java.lang.Exception) {
            e.printStackTrace()
        }

        super.onCreate(savedInstanceState)
    }
}
