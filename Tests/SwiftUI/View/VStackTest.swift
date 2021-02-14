package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class VStackTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // VStack
        val orig_vs = VStack { Text("Text") }
        val data_vs = json.encodeToString(VStack.Serializer(), orig_vs)
        val json_vs = json.decodeFromString(VStack.Serializer<View>(), data_vs)
        Assert.assertEquals(orig_vs, json_vs)
        Assert.assertEquals(
            """{
    "content": {
        "type": ":Text",
        "text": "Text"
    }
}""".trimIndent(), data_vs
        )
    }
}