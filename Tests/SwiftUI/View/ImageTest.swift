package kotlinx.kotlinui

import android.icu.util.DateInterval
import io.mockk.every
import io.mockk.mockk
import kotlinx.serialization.json.Json
import kotlinx.serialization.serializer
import android.media.Image as UXImage
import android.media.Image as CGImage
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*
import java.util.*

class ImageTest {
    @Test
    fun serialize_storage() {
        val json = Json {
            prettyPrint = true
        }

//        // NamedImageProvider
//        val orig_s0 = Image("name", null)
//        val data_s0 = json.encodeToString(serializer(), orig_s0)
//        val json_s0 = json.decodeFromString(serializer<Image>(), data_s0)
//        Assert.assertEquals(orig_s0, json_s0)
//
//        // RenderingModeProvider
//        val orig_s1 = Image("renderingMode").renderingMode(Image.TemplateRenderingMode.template)
//        val data_s1 = json.encodeToString(serializer(), orig_s1)
//        val json_s1 = json.decodeFromString(serializer<Image>(), data_s1)
//        Assert.assertEquals(orig_s1, json_s1)
//
//        // InterpolationProvider
//        val orig_s2 = Image("interpolation").interpolation(Image.Interpolation.medium)
//        val data_s2 = json.encodeToString(serializer(), orig_s2)
//        val json_s2 = json.decodeFromString(serializer<Image>(), data_s2)
//        Assert.assertEquals(orig_s2, json_s2)
//
//        // AntialiasedProvider
//        val orig_s3 = Image("antialiased").antialiased(true)
//        val data_s3 = json.encodeToString(serializer(), orig_s3)
//        val json_s3 = json.decodeFromString(serializer<Image>(), data_s3)
//        Assert.assertEquals(orig_s3, json_s3)

        // CGImageProvider
//        val cgImage = mockk<CGImage>(relaxed = true)
//        val orig_s4 = Image(cgImage, 0f, Image.Orientation.up)
//        val data_s4 = json.encodeToString(serializer(), orig_s4)
//        val json_s4 = json.decodeFromString(serializer<Image>(), data_s4)
//        Assert.assertEquals(orig_s4, json_s4)
//
//        // PlatformProvider
//        val uxImage = mockk<UXImage>()
////        every { cgImage.getFromDate() } returns 0
//        val orig_s5 = Image(uxImage)
//        val data_s5 = json.encodeToString(serializer(), orig_s5)
//        val json_s5 = json.decodeFromString(serializer<Image>(), data_s5)
//        Assert.assertEquals(orig_s5, json_s5)
//
//        // ResizableProvider
//        val orig_s6 = Image("resizable").resizable(EdgeInsets(), Image.ResizingMode.tile)
//        val data_s6 = json.encodeToString(serializer(), orig_s6)
//        val json_s6 = json.decodeFromString(serializer<Text>(), data_s6)
//        Assert.assertEquals(orig_s6, json_s6)
    }
}