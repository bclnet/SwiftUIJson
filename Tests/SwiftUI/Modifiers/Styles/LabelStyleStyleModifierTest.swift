@file: OptIn(ExperimentalStdlibApi::class)

package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class LabelStyleStyleModifierTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // LabelStyleStyleModifier
        val orig_lssm = LabelStyleStyleModifier(DefaultLabelStyle())
        val data_lssm = json.encodeToString(LabelStyleStyleModifier.Serializer(), orig_lssm)
        val json_lssm = json.decodeFromString(LabelStyleStyleModifier.Serializer<LabelStyle>(), data_lssm)
        Assert.assertEquals(orig_lssm, json_lssm)
        Assert.assertEquals(
            """{
    "style": {
        "type": ":DefaultLabelStyle"
    }
}""".trimIndent(), data_lssm
        )
    }
}