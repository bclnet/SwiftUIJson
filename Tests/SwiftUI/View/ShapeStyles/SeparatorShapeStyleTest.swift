package kotlinx.kotlinui

import android.graphics.Color as CGColor
import io.mockk.every
import io.mockk.mockk
import io.mockk.mockkStatic
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class SeparatorShapeStyleTest {
    @Test
    fun serialize() {
        val json = Json {
            prettyPrint = true
        }

        // SeparatorShapeStyle
        val orig_sss = SeparatorShapeStyle()
        val data_sss = json.encodeToString(SeparatorShapeStyle.Serializer, orig_sss)
        val json_sss = json.decodeFromString(SeparatorShapeStyle.Serializer, data_sss)
        Assert.assertEquals(orig_sss, json_sss)
        Assert.assertEquals(
            """{
}""".trimIndent(), data_sss
        )
    }
}