package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import kotlinx.system.*
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class TupleViewTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // TupleView
        val orig_tv_a = TupleView(Text("Text"))
        val data_tv_a = json.encodeToString(TupleView.Serializer(), orig_tv_a)
        val json_tv_a = json.decodeFromString(TupleView.Serializer<Any>(), data_tv_a)
        Assert.assertEquals(orig_tv_a, json_tv_a)
        Assert.assertEquals(
            """{
    "0": {
        "type": ":Text",
        "text": "Text"
    }
}""".trimIndent(), data_tv_a
        )

        // TupleView
        val orig_tv_t2 = TupleView(Tuple2(Text("Text1"), Text("Text2")))
        val data_tv_t2 = json.encodeToString(TupleView.Serializer(), orig_tv_t2)
        val json_tv_t2 = json.decodeFromString(TupleView.Serializer<Any>(), data_tv_t2)
        Assert.assertEquals(orig_tv_t2, json_tv_t2)
        Assert.assertEquals(
            """{
    "0": {
        "type": ":Text",
        "text": "Text1"
    },
    "1": {
        "type": ":Text",
        "text": "Text2"
    }
}""".trimIndent(), data_tv_t2
        )
    }
}