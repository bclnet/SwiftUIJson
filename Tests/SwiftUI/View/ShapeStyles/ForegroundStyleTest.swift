package kotlinx.kotlinui

import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class ForegroundStyleTest {
    @Test
    fun serialize() {
        val json = Json {
            prettyPrint = true
        }

        // ForegroundStyle
        val orig_fs = ForegroundStyle()
        val data_fs = json.encodeToString(ForegroundStyle.Serializer, orig_fs)
        val json_fs = json.decodeFromString(ForegroundStyle.Serializer, data_fs)
        Assert.assertEquals(orig_fs, json_fs)
        Assert.assertEquals(
            """{
}""".trimIndent(), data_fs
        )
    }
}