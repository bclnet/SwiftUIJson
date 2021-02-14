package kotlinx.kotlinui

import android.icu.util.DateInterval
import io.mockk.*
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import java.util.*

class LocalizedStringKeyTest {
    @Test
    fun serialize() {
        val json = Json {
            prettyPrint = true
        }

        // LocalizedStringKey
        val orig_lsk = LocalizedStringKey("key")
        val data_lsk = json.encodeToString(LocalizedStringKey.Serializer, orig_lsk)
        val json_lsk = json.decodeFromString(LocalizedStringKey.Serializer, data_lsk)
        Assert.assertEquals(orig_lsk, json_lsk)
        Assert.assertEquals("\"key\"", data_lsk)
    }
}