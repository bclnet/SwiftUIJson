@file: OptIn(ExperimentalStdlibApi::class)

package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class ListStyleModifierTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // ListStyleModifier
        val orig_lsm = ListStyleModifier(DefaultListStyle())
        val data_lsm = json.encodeToString(ListStyleModifier.Serializer(), orig_lsm)
        val json_lsm = json.decodeFromString(ListStyleModifier.Serializer<ListStyle>(), data_lsm)
        Assert.assertEquals(orig_lsm, json_lsm)
        Assert.assertEquals(
            """{
    "style": {
        "type": ":DefaultListStyle"
    }
}""".trimIndent(), data_lsm
        )
    }
}