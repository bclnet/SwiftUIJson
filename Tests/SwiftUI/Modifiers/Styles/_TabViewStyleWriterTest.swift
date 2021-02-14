@file: OptIn(ExperimentalStdlibApi::class)

package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class _TabViewStyleWriterTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // _TabViewStyleWriter
        val orig_tvsm = _TabViewStyleWriter(DefaultTabViewStyle())
        val data_tvsm = json.encodeToString(_TabViewStyleWriter.Serializer(), orig_tvsm)
        val json_tvsm = json.decodeFromString(_TabViewStyleWriter.Serializer<TabViewStyle>(), data_tvsm)
        Assert.assertEquals(orig_tvsm, json_tvsm)
        Assert.assertEquals(
            """{
    "style": {
        "type": ":DefaultTabViewStyle"
    }
}""".trimIndent(), data_tvsm
        )
    }
}