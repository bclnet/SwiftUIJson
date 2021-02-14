@file: OptIn(ExperimentalStdlibApi::class)

package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class TextFieldStyleStyleModifierTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // TextFieldStyleStyleModifier
        val orig_tfssm = TextFieldStyleStyleModifier(DefaultTextFieldStyle())
        val data_tfssm = json.encodeToString(TextFieldStyleStyleModifier.Serializer(), orig_tfssm)
        val json_tfssm = json.decodeFromString(TextFieldStyleStyleModifier.Serializer<TextFieldStyle>(), data_tfssm)
        Assert.assertEquals(orig_tfssm, json_tfssm)
        Assert.assertEquals(
            """{
    "style": {
        "type": ":DefaultTextFieldStyle"
    }
}""".trimIndent(), data_tfssm
        )
    }
}