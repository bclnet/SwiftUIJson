package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import kotlinx.serialization.modules.SerializersModule
import kotlinx.serialization.modules.contextual
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class TextFieldTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // TextField
        val orig_tf = TextField("text", Text("Text"), {}, {})
        val data_tf = json.encodeToString(TextField.Serializer(), orig_tf)
        val json_tf = json.decodeFromString(TextField.Serializer<Text>(), data_tf)
        Assert.assertEquals(orig_tf, json_tf)
        Assert.assertEquals(
            """{
    "content": {
        "type": ":Text",
        "text": "Text"
    }
}""".trimIndent(), data_tf
        )
    }
}