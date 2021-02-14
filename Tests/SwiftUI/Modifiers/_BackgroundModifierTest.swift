package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class _BackgroundModifierTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // _BackgroundModifier
        val orig_bm = _BackgroundModifier(Color.red, Alignment.center)
        val data_bm = json.encodeToString(_BackgroundModifier.Serializer(), orig_bm)
        val json_bm = json.decodeFromString(_BackgroundModifier.Serializer<View>(), data_bm)
        Assert.assertEquals(orig_bm, json_bm)
        Assert.assertEquals(
            """{
    "background": {
        "type": ":Color",
        "color": "red"
    },
    "alignment": "center"
}""".trimIndent(), data_bm
        )
    }
}