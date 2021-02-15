package kotlinx.kotlinui

import android.graphics.Color
import android.graphics.ColorSpace
import android.icu.util.DateInterval
import android.util.SizeF
import io.mockk.every
import io.mockk.mockk
import io.mockk.mockkConstructor
import io.mockk.mockkStatic
import kotlinx.ptype.ActionManager
import kotlinx.serialization.json.Json
import org.junit.Assert
import org.junit.Test
import org.junit.Assert.*
import java.util.*
import android.graphics.Color as CGColor

fun _Plane.register() {
    mockColor()
    JsonUI.registered
}

fun _Plane.mockActionManager() {
    ActionManager.mocked = true
}

fun _Plane.mockDate(date: Long, fromDate: Long, toDate: Long) {
    mockkConstructor(Date::class)
    every { anyConstructed<Date>().time } returns date
    every { anyConstructed<Date>() == any() } returns true

    mockkConstructor(DateInterval::class)
    every { anyConstructed<DateInterval>().fromDate } returns fromDate
    every { anyConstructed<DateInterval>().toDate } returns toDate
    every { anyConstructed<DateInterval>() == any() } returns true
}

fun _Plane.mockSize(width: Float, height: Float) {
    mockkConstructor(SizeF::class)
    every { anyConstructed<SizeF>().width } returns width
    every { anyConstructed<SizeF>().height } returns height
    every { anyConstructed<SizeF>() == any() } returns true
}

fun _Plane.mockColor() {
    colorSpaces = Array(1) {
        val colorSpace = mockk<ColorSpace>(relaxed = true)
        every { colorSpace.name } returns when (it) {
            0 -> "SRGB"
            else -> error("$it")
        }
        colorSpace
    }
    colors = Array(14) { mockk(relaxed = true) }

    // mock ColorSpace
    mockkStatic(ColorSpace::class)
    every { ColorSpace.get(ColorSpace.Named.SRGB) } returns colorSpaces[0]!!

    // mock Color
    mockkStatic(CGColor::class)
    every { Color.valueOf(any(), any()) } returns makeCGColor(10f, 10f, 10f)
}

fun _Plane.makeCGColor(r: Float, g: Float, b: Float): CGColor {
    val color = mockk<CGColor>(relaxed = true)
    every { color.colorSpace } returns colorSpaces[0]!!
    every { color.components } returns arrayOf(r, g, b).toFloatArray()
    return color
}