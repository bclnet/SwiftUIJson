package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class ZStackTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // ZStack
        val orig_zs = ZStack { Text("Text") }
        val data_zs = json.encodeToString(ZStack.Serializer(), orig_zs)
        val json_zs = json.decodeFromString(ZStack.Serializer<View>(), data_zs)
        Assert.assertEquals(orig_zs, json_zs)
        Assert.assertEquals(
            """{
    "content": {
        "type": ":Text",
        "text": "Text"
    }
}""".trimIndent(), data_zs
        )

        // ZStack:Tuple
        val orig_zs_t = ZStack {
            Text("Text") +
            Text("Second")
        }
        val data_zs_t = json.encodeToString(ZStack.Serializer(), orig_zs_t)
        val json_zs_t = json.decodeFromString(ZStack.Serializer<View>(), data_zs_t)
        Assert.assertEquals(orig_zs_t, json_zs_t)
        Assert.assertEquals(
            """{
    "content": {
        "type": ":TupleView",
        "0": {
            "type": ":Text",
            "text": "Text"
        },
        "1": {
            "type": ":Text",
            "text": "Second"
        }
    }
}""".trimIndent(), data_zs_t
        )
    }
}