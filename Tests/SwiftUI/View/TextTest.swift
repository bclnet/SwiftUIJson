package kotlinx.kotlinui

import android.icu.util.DateInterval
import io.mockk.every
import io.mockk.mockk
import kotlinx.ptype.PType
import kotlinx.serialization.json.Json
import kotlinx.serialization.serializer
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*
import java.util.*

class TextTest {
    @Test
    fun serialize_storage() {
        val json = Json {
            serializersModule = PType.module
            prettyPrint = true
        }
        _Plane.register()
        _Plane.mockDate(0, 0, 1)

        // String
        val orig_s = Text(Text.Init.string, "Text")
        val data_s = json.encodeToString(Text.Serializer, orig_s)
        val json_s = json.decodeFromString(Text.Serializer, data_s)
        Assert.assertEquals(orig_s, json_s)
        Assert.assertEquals(
            """{
    "text": "Text"
}""".trimIndent(), data_s
        )

        // Verbatim
        val orig_v = Text(Text.Init.verbatim, "Verbatim")
        val data_v = json.encodeToString(Text.Serializer, orig_v)
        val json_v = json.decodeFromString(Text.Serializer, data_v)
        Assert.assertEquals(orig_v, json_v)
        Assert.assertEquals(
            """{
    "verbatim": "Verbatim"
}""".trimIndent(), data_v
        )

        // LocalizedTextStorage
        val orig_lts = Text(LocalizedStringKey("TextKey"))
        val data_lts = json.encodeToString(Text.Serializer, orig_lts)
        val json_lts = json.decodeFromString(Text.Serializer, data_lts)
        Assert.assertEquals(orig_lts, json_lts)
        Assert.assertEquals(
            """{
    "local": {
        "text": "TextKey"
    }
}""".trimIndent(), data_lts
        )

        // AttachmentTextStorage
        val orig_ats = Text(Image(Image.Init.systemName, "Image"))
        val data_ats = json.encodeToString(Text.Serializer, orig_ats)
        val json_ats = json.decodeFromString(Text.Serializer, data_ats)
        Assert.assertEquals(orig_ats, json_ats)
        Assert.assertEquals(
            """{
    "attach": {
        "image": {
            "named": {
                "system": true,
                "name": "Image"
            }
        }
    }
}""".trimIndent(), data_ats
        )

        // FormatterTextStorage
        val orig_fts = Text("FormatterTextStorage")
        val data_fts = json.encodeToString(Text.Serializer, orig_fts)
        val json_fts = json.decodeFromString(Text.Serializer, data_fts)
        Assert.assertEquals(orig_fts, json_fts)
        Assert.assertEquals(
            """{
    "text": "FormatterTextStorage"
}""".trimIndent(), data_fts
        )

        // DateTextStorage.Interval
        val orig_dts_i = Text(DateInterval(0, 1))
        val data_dts_i = json.encodeToString(Text.Serializer, orig_dts_i)
        val json_dts_i = json.decodeFromString(Text.Serializer, data_dts_i)
        Assert.assertEquals(orig_dts_i, json_dts_i)
        Assert.assertEquals(
            """{
    "date": {
        "interval": [
            "31/12/1969 18:00:00.000",
            "31/12/1969 18:00:00.000"
        ],
        "value": "interval"
    }
}""".trimIndent(), data_dts_i
        )

        // DateTextStorage.Absolute
        val orig_dts_a = Text(Date(), Text.DateStyle.date)
        val data_dts_a = json.encodeToString(Text.Serializer, orig_dts_a)
        val json_dts_a = json.decodeFromString(Text.Serializer, data_dts_a)
        Assert.assertEquals(orig_dts_a, json_dts_a)
        Assert.assertEquals(
            """{
    "date": {
        "date": "31/12/1969 18:00:00.000",
        "style": "date",
        "value": "absolute"
    }
}""".trimIndent(), data_dts_a
        )
    }
}