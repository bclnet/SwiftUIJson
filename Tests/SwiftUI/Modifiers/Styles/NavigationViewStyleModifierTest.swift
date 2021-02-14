@file: OptIn(ExperimentalStdlibApi::class)

package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class NavigationViewStyleModifierTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // NavigationViewStyleModifier
        val orig_nvsm = NavigationViewStyleModifier(DefaultNavigationViewStyle())
        val data_nvsm = json.encodeToString(NavigationViewStyleModifier.Serializer(), orig_nvsm)
        val json_nvsm = json.decodeFromString(NavigationViewStyleModifier.Serializer<NavigationViewStyle>(), data_nvsm)
        Assert.assertEquals(orig_nvsm, json_nvsm)
        Assert.assertEquals(
            """{
    "style": {
        "type": ":DefaultNavigationViewStyle"
    }
}""".trimIndent(), data_nvsm
        )
    }
}