package kotlinx.kotlinui

import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import kotlinx.system.WritableKeyPath
import org.junit.Assert
import org.junit.Test

class _EnvironmentKeyWritingModifierTest {
    @Test
    fun serialize() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()

        // _EnvironmentKeyWritingModifier
        val orig_ekwm_a = _EnvironmentKeyWritingModifier(WritableKeyPath[EnvironmentValues::font], Font.body)
        val data_ekwm_a = json.encodeToString(_EnvironmentKeyWritingModifier.Serializer(), orig_ekwm_a)
        val json_ekwm_a = json.decodeFromString(_EnvironmentKeyWritingModifier.Serializer<WritableKeyPath<EnvironmentValues, Font?>>(), data_ekwm_a)
        Assert.assertEquals(orig_ekwm_a, json_ekwm_a)
        Assert.assertEquals(
            """{
    "keyPath": "font",
    "key": "#WritableKeyPath<:EnvironmentValues,:Font?>",
    "value": {
        "type": ":Font",
        "font": "body"
    }
}""".trimIndent(), data_ekwm_a
        )
        //
        val orig_ekwm_b = _EnvironmentKeyWritingModifier(WritableKeyPath[EnvironmentValues::foregroundColor], Color.red)
        val data_ekwm_b = json.encodeToString(_EnvironmentKeyWritingModifier.Serializer(), orig_ekwm_b)
        val json_ekwm_b = json.decodeFromString(_EnvironmentKeyWritingModifier.Serializer<WritableKeyPath<EnvironmentValues, Color?>>(), data_ekwm_b)
        Assert.assertEquals(orig_ekwm_b, json_ekwm_b)
        Assert.assertEquals(
            """{
    "keyPath": "foregroundColor",
    "key": "#WritableKeyPath<:EnvironmentValues,:Color?>",
    "value": {
        "type": ":Color",
        "color": "red"
    }
}""".trimIndent(), data_ekwm_b
        )
    }
}