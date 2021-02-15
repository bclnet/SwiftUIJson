package kotlinx.kotlinui

import android.graphics.Color as CGColor
import io.mockk.every
import io.mockk.mockk
import io.mockk.mockkStatic
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class SelectionShapeStyleTest {
    @Test
    fun serialize() {
        val json = Json {
            prettyPrint = true
        }

        // SelectionShapeStyle
        val orig_sss = SelectionShapeStyle(true)
        val data_sss = json.encodeToString(SelectionShapeStyle.Serializer, orig_sss)
        val json_sss = json.decodeFromString(SelectionShapeStyle.Serializer, data_sss)
        Assert.assertEquals(orig_sss, json_sss)
        Assert.assertEquals(
            """{
    "selected": true
}""".trimIndent(), data_sss
        )
    }
}