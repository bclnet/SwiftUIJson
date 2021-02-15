@file: OptIn(ExperimentalStdlibApi::class)

package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class ButtonStyleModifierTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // ButtonStyleModifier
        val orig_bsm = ButtonStyleModifier(DefaultButtonStyle())
        val data_bsm = json.encodeToString(ButtonStyleModifier.Serializer(), orig_bsm)
        val json_bsm = json.decodeFromString(ButtonStyleModifier.Serializer<ButtonStyle>(), data_bsm)
        Assert.assertEquals(orig_bsm, json_bsm)
        Assert.assertEquals(
            """{
    "style": {
        "type": ":DefaultButtonStyle"
    }
}""".trimIndent(), data_bsm
        )
    }
}