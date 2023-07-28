package com.example.lashamezvrishvili_artteo

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.Pigeon
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Paint
import android.util.Base64
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import java.io.ByteArrayOutputStream
import android.graphics.Matrix

class MainActivity : FlutterActivity() {

    private class MyDogApi(private val context: Context) : Pigeon.DogApi {

        private fun drawableToBitmap(drawable: Drawable): Bitmap {
            if (drawable is BitmapDrawable) {
                if (drawable.bitmap != null) {
                    return drawable.bitmap.copy(drawable.bitmap.config, true)
                }
            }
            // Single color bitmap will be created of 1x1 pixel
            val bitmap: Bitmap =
                if (drawable.intrinsicWidth <= 0 || drawable.intrinsicHeight <= 0) {
                    Bitmap.createBitmap(1, 1, Bitmap.Config.ARGB_8888)
                } else {
                    Bitmap.createBitmap(
                        drawable.intrinsicWidth,
                        drawable.intrinsicHeight,
                        Bitmap.Config.ARGB_8888
                    )
                }

            val canvas = Canvas(bitmap)
            drawable.setBounds(0, 0, canvas.width, canvas.height)
            drawable.draw(canvas)
            return bitmap
        }

        override fun addWatermark(imageBase64: String): String {
            // decode the base64 string into a Bitmap
            val decodedBytes = Base64.decode(imageBase64, Base64.DEFAULT)
            val originalBitmap = BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.size)

            // create a mutable copy of the original Bitmap
            val bitmap = originalBitmap.copy(originalBitmap.config, true)

            // load the watermark image from the res/drawable folder
            val watermarkDrawable = context.resources.getDrawable(R.drawable.watermark_image, null)
            val watermarkBitmap = drawableToBitmap(watermarkDrawable)

            // calculate scaling factors
            val scaleWidth = bitmap.width.toFloat() * 0.6f / watermarkBitmap.width.toFloat()
            val scaleHeight = bitmap.height.toFloat() *0.6f / watermarkBitmap.height.toFloat()

            // use the smaller of the two scaling factors to maintain aspect ratio
            val scaleFactor = minOf(scaleWidth, scaleHeight)

            // calculate the new width and height of the watermark
            val newWidth = (watermarkBitmap.width * scaleFactor).toInt()
            val newHeight = (watermarkBitmap.height * scaleFactor).toInt()

            // resize the watermarkBitmap
            val resizedWatermarkBitmap =
                Bitmap.createScaledBitmap(watermarkBitmap, newWidth, newHeight, true)

            // calculate the position for the watermark
            val watermarkLeft = 0f
            val watermarkTop = 0f

            // draw the resized watermark onto the original Bitmap
            val canvas = Canvas(bitmap)
            val paint = Paint()
            canvas.drawBitmap(resizedWatermarkBitmap, watermarkLeft, watermarkTop, paint)

            // encode the Bitmap back into a base64 string
            val outputStream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, outputStream)
            val watermarkedImageBytes = outputStream.toByteArray()
            val watermarkedImageBase64 =
                Base64.encodeToString(watermarkedImageBytes, Base64.DEFAULT)

            // cleanup so that we don't leak memory and consequent bitmap operations dont
            originalBitmap.recycle()
            resizedWatermarkBitmap.recycle()

            return watermarkedImageBase64
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        Pigeon.DogApi.setup(
            flutterEngine.dartExecutor.binaryMessenger,
            MyDogApi(applicationContext)
        )
    }
}