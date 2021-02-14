package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class TouchBarTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // TouchBar
        val orig_tb = TouchBar("id") { Text("Text") }
        val data_tb = json.encodeToString(TouchBar.Serializer(), orig_tb)
        val json_tb = json.decodeFromString(TouchBar.Serializer<View>(), data_tb)
        Assert.assertEquals(orig_tb, json_tb)
        Assert.assertEquals(
            """{
    "id": "id",
    "content": {
        "type": ":Text",
        "text": "Text"
    }
}""".trimIndent(), data_tb
        )
    }
}