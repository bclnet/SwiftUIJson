@file: OptIn(ExperimentalStdlibApi::class)

package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class ProgressViewStyleModifierTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // ProgressViewStyleModifier
        val orig_pvsm = ProgressViewStyleModifier(DefaultProgressViewStyle())
        val data_pvsm = json.encodeToString(ProgressViewStyleModifier.Serializer(), orig_pvsm)
        val json_pvsm = json.decodeFromString(ProgressViewStyleModifier.Serializer<ProgressViewStyle>(), data_pvsm)
        Assert.assertEquals(orig_pvsm, json_pvsm)
        Assert.assertEquals(
            """{
    "style": {
        "type": ":DefaultProgressViewStyle"
    }
}""".trimIndent(), data_pvsm
        )
    }
}