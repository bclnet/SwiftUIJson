package kotlinx.kotlinui

import android.graphics.RectF
import android.icu.util.DateInterval
import android.util.SizeF
import io.mockk.*
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import java.util.*

class PlatformSizeTest {
    @Test
    fun serialize() {
        val json = Json {
            prettyPrint = true
        }

        // SizeF
        val sizeF = mockk<SizeF>(relaxed = true)
        every { sizeF.width } returns 5f
        every { sizeF.height } returns 1f
        every { sizeF == any() } returns true
        val orig_sf = sizeF
        val data_sf = json.encodeToString(SizeFSerializer, orig_sf)
        val json_sf = json.decodeFromString(SizeFSerializer, data_sf)
        Assert.assertEquals(orig_sf, json_sf)
        Assert.assertEquals(
            """[
    5.0,
    1.0
]""".trimIndent(), data_sf
        )

        // RectF
        val rectF = mockk<RectF>(relaxed = true)
//        every { rectF.left } returns 0f
//        every { rectF.top } returns 1f
//        every { rectF.right } returns 2f
//        every { rectF.bottom } returns 3f
        every { rectF == any() } returns true
        val orig_rf = rectF
        val data_rf = json.encodeToString(RectFSerializer, orig_rf)
        val json_rf = json.decodeFromString(RectFSerializer, data_rf)
        Assert.assertEquals(orig_rf, json_rf)
        Assert.assertEquals(
            """[
    0.0,
    0.0,
    0.0,
    0.0
]""".trimIndent(), data_rf
        )
    }
}