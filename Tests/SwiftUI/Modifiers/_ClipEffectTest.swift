package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class _ClipEffectTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // _ClipEffect
        val orig_ce = _ClipEffect(Circle(), FillStyle())
        val data_ce = json.encodeToString(_ClipEffect.Serializer(), orig_ce)
        val json_ce = json.decodeFromString(_ClipEffect.Serializer<Shape>(), data_ce)
        Assert.assertEquals(orig_ce, json_ce)
        Assert.assertEquals(
            """{
    "shape": {
        "type": ":Circle"
    },
    "style": {
    }
}""".trimIndent(), data_ce
        )
    }
}