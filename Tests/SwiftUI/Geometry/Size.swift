package kotlinx.kotlinui

import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test

class SizeTest {
    @Test
    fun serialize() {
        val json = Json {
            prettyPrint = true
        }

        // Size
        val orig_s = Size(1, 2)
        val data_s = json.encodeToString(Size.Serializer, orig_s)
        val json_s = json.decodeFromString(Size.Serializer, data_s)
        Assert.assertEquals(orig_s, json_s)
        Assert.assertEquals(
            """[
    1,
    2
]""".trimIndent(), data_s
        )
    }
}