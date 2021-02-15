package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class ViewBuilderTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // ViewBuilder
        val orig_vb_a =
            VStack {
                Text("Hello World")
            }
        val data_vb_a = json.encodeToString(VStack.Serializer(), orig_vb_a)
        val json_vb_a = json.decodeFromString(VStack.Serializer<View>(), data_vb_a)
        Assert.assertEquals(orig_vb_a, json_vb_a)
        Assert.assertEquals(
            """{
    "content": {
        "type": ":Text",
        "text": "Hello World"
    }
}""".trimIndent(), data_vb_a
        )
        //
        val orig_vb_b =
            VStack {
                Text("First") +
                        Circle()
            }
        val data_vb_b = json.encodeToString(VStack.Serializer(), orig_vb_b)
        val json_vb_b = json.decodeFromString(VStack.Serializer<View>(), data_vb_b)
        Assert.assertEquals(orig_vb_b, json_vb_b)
        Assert.assertEquals(
            """{
    "content": {
        "type": ":TupleView",
        "0": {
            "type": ":Text",
            "text": "First"
        },
        "1": {
            "type": ":Circle"
        }
    }
}""".trimIndent(), data_vb_b
        )
    }
}