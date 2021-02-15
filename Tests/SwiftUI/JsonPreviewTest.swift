package kotlinx.kotlinui

import org.junit.Test
import org.junit.Assert.*

class JsonPreviewTest {

    @Test
    fun test_complex() {
        val preview = JsonPreview {
            VStack {
                Text("Verbatim") + Text("Verbatim")
            }
        }
        assertEquals(4, 2 + 2)
    }
}