package kotlinx.kotlinui

import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class _AccessibilityIgnoresInvertColorsViewModifierTest {
    @Test
    fun serialize() {
        val json = Json {
            prettyPrint = true
        }

        // _AccessibilityIgnoresInvertColorsViewModifier
        val orig_aiicvm = _AccessibilityIgnoresInvertColorsViewModifier(true)
        val data_aiicvm = json.encodeToString(_AccessibilityIgnoresInvertColorsViewModifier.Serializer, orig_aiicvm)
        val json_aiicvm = json.decodeFromString(_AccessibilityIgnoresInvertColorsViewModifier.Serializer, data_aiicvm)
        Assert.assertEquals(orig_aiicvm, json_aiicvm)
        Assert.assertEquals("true", data_aiicvm)
    }
}