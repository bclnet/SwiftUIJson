@file: OptIn(ExperimentalStdlibApi::class)

package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class ToggleStyleModifierTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // ToggleStyleModifier
        val orig_tsm = ToggleStyleModifier(DefaultToggleStyle())
        val data_tsm = json.encodeToString(ToggleStyleModifier.Serializer(), orig_tsm)
        val json_tsm = json.decodeFromString(ToggleStyleModifier.Serializer<ToggleStyle>(), data_tsm)
        Assert.assertEquals(orig_tsm, json_tsm)
        Assert.assertEquals(
            """{
    "style": {
        "type": ":DefaultToggleStyle"
    }
}""".trimIndent(), data_tsm
        )
    }
}