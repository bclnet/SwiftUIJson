package kotlinx.kotlinui

import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*

class __DesignTimeSelectionIdentifierTest {
    @Test
    fun serialize() {
        val json = Json {
            prettyPrint = true
        }

        // __DesignTimeSelectionIdentifierTest
        val orig_dtsi = __DesignTimeSelectionIdentifier("id")
        val data_dtsi = json.encodeToString(__DesignTimeSelectionIdentifier.Serializer, orig_dtsi)
        val json_dtsi = json.decodeFromString(__DesignTimeSelectionIdentifier.Serializer, data_dtsi)
        Assert.assertEquals(orig_dtsi, json_dtsi)
        Assert.assertEquals("\"id\"", data_dtsi)
    }
}