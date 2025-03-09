package com.khedr.customized_files_picker

import android.os.Bundle
import android.os.Environment
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.concurrent.Executors

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.khedr.customized_files_picker/viewer"
    private val executor = Executors.newSingleThreadExecutor()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getLocalFiles") {
                executor.execute {
                    val files = getLocalFiles()
                    runOnUiThread {
                        result.success(files)
                    }
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getLocalFiles(): List<String> {
        val imagesDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)
        val videosDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MOVIES)
        val audioDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MUSIC)
        val documentsDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOCUMENTS)

        val imageFiles = getFilesRecursively(imagesDir)
        val videoFiles = getFilesRecursively(videosDir)
        val audioFiles = getFilesRecursively(audioDir)
        val documentFiles = getFilesRecursively(documentsDir)

        return imageFiles + videoFiles + audioFiles + documentFiles
    }

    private fun getFilesRecursively(dir: File): List<String> {
        val filesList = mutableListOf<String>()
        if (dir.exists() && dir.isDirectory) {
            val files = dir.listFiles()
            if (files != null) {
                for (file in files) {
                    if (file.isFile) {
                        filesList.add(file.absolutePath)
                    } else if (file.isDirectory) {
                        filesList.addAll(getFilesRecursively(file))
                    }
                }
            }
        }
        return filesList
    }
}