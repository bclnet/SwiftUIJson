@file: OptIn(ExperimentalStdlibApi::class)

package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class MenuStyleModifierTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // MenuStyleModifier
        val orig_msm = MenuStyleModifier(DefaultMenuStyle())
        val data_msm = json.encodeToString(MenuStyleModifier.Serializer(), orig_msm)
        val json_msm = json.decodeFromString(MenuStyleModifier.Serializer<MenuStyle>(), data_msm)
        Assert.assertEquals(orig_msm, json_msm)
        Assert.assertEquals(
            """{
    "style": {
        "type": ":DefaultMenuStyle"
    }
}""".trimIndent(), data_msm
        )
    }
}