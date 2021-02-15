package kotlinx.kotlinui

import android.icu.util.DateInterval
import io.mockk.*
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import java.util.*

class PlatformDateTest {
    @Test
    fun serialize() {
        val json = Json {
            prettyPrint = true
        }

        // Date
        val date = mockk<Date>(relaxed = true)
        every { date.time } returns 1220227200L * 1000
        every { date.equals(any()) } returns true
        val orig_d = date
        val data_d = json.encodeToString(DateSerializer, orig_d)
        val json_d = json.decodeFromString(DateSerializer, data_d)
        Assert.assertEquals(orig_d, json_d)
        Assert.assertEquals("\"31/08/2008 19:00:00.000\"", data_d)

        // DateInterval
        val dateInterval = mockk<DateInterval>(relaxed = true)
        every { dateInterval.equals(any()) } returns true
        every { dateInterval.getFromDate() } returns 1220227200L * 1000
        every { dateInterval.getToDate() } returns 1220227200L * 1000
        val orig_di = dateInterval
        val data_di = json.encodeToString(DateIntervalSerializer, orig_di)
        val json_di = json.decodeFromString(DateIntervalSerializer, data_di)
        Assert.assertEquals(orig_di, json_di)
        Assert.assertEquals(
            """[
    "31/08/2008 19:00:00.000",
    "31/08/2008 19:00:00.000"
]""".trimIndent(), data_di
        )
    }
}