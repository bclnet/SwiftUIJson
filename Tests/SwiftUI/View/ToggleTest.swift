package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class ToggleTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // Toggle
        val _isOn_ = Binding.constant(true)
        val orig_t = Toggle(_isOn_) { Text("Text") }
        val data_t = json.encodeToString(Toggle.Serializer(), orig_t)
        val json_t = json.decodeFromString(Toggle.Serializer<View>(), data_t)
        Assert.assertEquals(orig_t, json_t)
        Assert.assertEquals(
            """{
    "id": "id",
    "content": {
        "type": ":Text",
        "text": "Text"
    }
}""".trimIndent(), data_t
        )
    }
}