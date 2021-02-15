package kotlinx.kotlinui

import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class BackgroundStyleTest {
    @Test
    fun serialize() {
        val json = Json {
            prettyPrint = true
        }

        // BackgroundStyle
        val orig_bs = BackgroundStyle()
        val data_bs = json.encodeToString(BackgroundStyle.Serializer, orig_bs)
        val json_bs = json.decodeFromString(BackgroundStyle.Serializer, data_bs)
        Assert.assertEquals(orig_bs, json_bs)
        Assert.assertEquals(
            """{
}""".trimIndent(), data_bs
        )
    }
}