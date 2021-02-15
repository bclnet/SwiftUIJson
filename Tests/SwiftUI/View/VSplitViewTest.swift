package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class VSplitViewTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // VSplitView
        val orig_vsv = VSplitView { Text("Text") }
        val data_vsv = json.encodeToString(VSplitView.Serializer(), orig_vsv)
        val json_vsv = json.decodeFromString(VSplitView.Serializer<View>(), data_vsv)
        Assert.assertEquals(orig_vsv, json_vsv)
        Assert.assertEquals(
            """{
    "content": {
        "type": ":Text",
        "text": "Text"
    }
}""".trimIndent(), data_vsv
        )
    }
}