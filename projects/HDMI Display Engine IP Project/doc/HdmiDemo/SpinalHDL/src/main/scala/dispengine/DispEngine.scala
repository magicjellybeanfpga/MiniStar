package dispengine

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.ahblite._
import spinal.lib.graphic._
import spinal.lib.graphic.vga._

class PLLVR(clkInFreq: String,
            idivSel: Int,
            fbdivSel: Int,
            odivSel: Int) extends BlackBox {
                
    addGeneric("FCLKIN", clkInFreq)
    addGeneric("IDIV_SEL", idivSel)
    addGeneric("DYN_IDIV_SEL", "false")
    addGeneric("FBDIV_SEL", fbdivSel)
    addGeneric("DYN_FBDIV_SEL", "false")
    addGeneric("ODIV_SEL", odivSel)
    addGeneric("DYN_ODIV_SEL", "false")
    addGeneric("PSDA_SEL", "0000")
    addGeneric("DUTYDA_SEL", "1000")
    addGeneric("DYN_DA_EN", "false")
    addGeneric("DYN_SDIV_SEL", 2)
    addGeneric("CLKOUT_FT_DIR", U"1'b1")
    addGeneric("CLKOUT_DLY_STEP", 0)
    addGeneric("CLKOUTP_FT_DIR", U"1'b1")
    addGeneric("CLKOUTP_DLY_STEP", 0)
    addGeneric("CLKFB_SEL", "internal")
    addGeneric("CLKOUTD_SRC", "CLKOUT")
    addGeneric("CLKOUTD3_SRC", "CLKOUT")
    addGeneric("CLKOUT_BYPASS", "false")
    addGeneric("CLKOUTP_BYPASS", "false")
    addGeneric("CLKOUTD_BYPASS", "false")
    addGeneric("DEVICE", "GW1NSR-4C")

    val io = new Bundle {
        val RESET    = in Bool
        val RESET_P  = in Bool
        val VREN     = in Bool
        val CLKIN    = in Bool
        val CLKFB    = in Bool
        val IDSEL    = in UInt(6 bits)
        val FBDSEL   = in UInt(6 bits)
        val ODSEL    = in UInt(6 bits)
        val PSDA     = in UInt(4 bits)
        val DUTYDA   = in UInt(4 bits)
        val FDLY     = in UInt(4 bits)
        val LOCK     = out Bool
        val CLKOUT   = out Bool
        val CLKOUTP  = out Bool
        val CLKOUTD  = out Bool
        val CLKOUTD3 = out Bool
    }

    noIoPrefix()
}

class CLKDIV(divMode: String, gsrEnable: String) extends BlackBox {
    addGeneric("DIV_MODE", divMode)
    addGeneric("GSREN", gsrEnable)

    val io = new Bundle {
        val HCLKIN = in Bool
        val RESETN = in Bool
        val CALIB  = in Bool
        val CLKOUT = out Bool
    }

    noIoPrefix()
}

class DispEngine(addressWidth: Int,
                 dispRamBaseAddress: Int,
                 pllBaseAddress: Int,
                 vgaCtrlBaseAddress: Int,
                 rgbConfig: RgbConfig) extends Component {

    val io = new Bundle {
        val ahb = slave(AhbLite3(AhbLite3Config(addressWidth, 32)))
        val clk_in = in Bool
        val clk_hdmi = out Bool
        val clk_pixel = out Bool
        val pll_locked = out Bool
        val vga_rst = out Bool
        val vga = out(Vga(RgbConfig(8, 8, 8)))
        val vga_error = out Bool
    }

    val busCtrl = new AhbLite3SlaveFactory(io.ahb)

    val pllArea = new Area {
        val pd = Reg(Bool) init(True)
        val idiv = Reg(UInt(6 bits)) init(64 - 4)
        val fbdiv = Reg(UInt(6 bits)) init(64 - 55)
        val odiv = Reg(UInt(6 bits)) init(64 - 2)

        val pllvr = new PLLVR("27", 4 - 1, 55 - 1, 2)
        pllvr.io.RESET := False
        pllvr.io.RESET_P <> pd
        pllvr.io.VREN := True
        pllvr.io.CLKIN <> io.clk_in
        pllvr.io.CLKFB := False
        pllvr.io.IDSEL <> idiv
        pllvr.io.FBDSEL <> fbdiv
        pllvr.io.ODSEL <> odiv
        pllvr.io.PSDA := U"4'b0"
        pllvr.io.DUTYDA := U"4'b0"
        pllvr.io.FDLY := U"4'b0"
        pllvr.io.LOCK <> io.pll_locked
        io.clk_hdmi := pllvr.io.CLKOUT

        val clkDiv = new CLKDIV("5", "false")
        clkDiv.io.HCLKIN := io.clk_hdmi
        clkDiv.io.RESETN := True
        clkDiv.io.CALIB := False
        clkDiv.io.CLKOUT <> io.clk_pixel

        busCtrl.readAndWrite(pd, pllBaseAddress + 0, bitOffset = 0)
        busCtrl.read(BufferCC(io.pll_locked, False), pllBaseAddress + 0, bitOffset = 1)
        busCtrl.readAndWrite(idiv, pllBaseAddress + 4)
        busCtrl.readAndWrite(fbdiv, pllBaseAddress + 8)
        busCtrl.readAndWrite(odiv, pllBaseAddress + 12)
    }

    val vgaArea = new Area {
        val vgaClk = ClockDomain.internal("vgaClk")
        vgaClk.clock := io.clk_pixel
        vgaClk.reset := ResetCtrl.asyncAssertSyncDeassert(ClockDomain.current.readResetWire, vgaClk)

        val softReset = Reg(Bool) init(True)
        val timingsWidth = 12
        val defaultTimings = VgaTimings(timingsWidth)
        defaultTimings.setAs(1280, 40, 110, 220, false, 720, 5, 5, 20, false)
        val timings = Reg(VgaTimings(timingsWidth)) init(defaultTimings)
        val color = Reg(UInt(rgbConfig.getWidth bits)) init(0xFFFF)

        val asyncArea = new ClockingArea(vgaClk) {
            val frameStart = Bool
            val toggledOnFrameStart = Reg(Bool) init(False)
            when(frameStart =/= (RegNext(frameStart) init(False))) {
                toggledOnFrameStart := !toggledOnFrameStart
            }

            val vgaCtrl = new VgaCtrl(rgbConfig)
            
            val timingsReg = BufferCC(timings)
            val colorReg = BufferCC(color)
            val payload = Rgb(rgbConfig)
            val vga = Vga(rgbConfig)
            payload.r := colorReg(rgbConfig.gWidth + rgbConfig.bWidth, rgbConfig.rWidth bits)
            payload.g := colorReg(rgbConfig.bWidth, rgbConfig.gWidth bits)
            payload.b := colorReg(0, rgbConfig.bWidth bits)

            vgaCtrl.io.softReset := BufferCC(softReset, True)
            vgaCtrl.io.timings <> timingsReg
            vgaCtrl.io.frameStart <> frameStart
            vgaCtrl.io.pixels.valid := True
            vgaCtrl.io.pixels.payload <> payload
            vgaCtrl.io.vga <> vga
            vgaCtrl.io.error <> io.vga_error
            io.vga_rst := vgaClk.reset
        }

        io.vga << asyncArea.vga

        val toggledOnFrameStart = BufferCC(asyncArea.toggledOnFrameStart, False)

        busCtrl.readAndWrite(softReset, vgaCtrlBaseAddress + 0, bitOffset = 0)
        busCtrl.read(BufferCC(io.vga.colorEn, False), vgaCtrlBaseAddress + 0, bitOffset = 1)
        busCtrl.read(BufferCC(io.vga.hSync, False), vgaCtrlBaseAddress + 0, bitOffset = 2)
        busCtrl.read(BufferCC(io.vga.vSync, False), vgaCtrlBaseAddress + 0, bitOffset = 3)
        busCtrl.readAndWrite(color, vgaCtrlBaseAddress + 0, bitOffset = 16)
        busCtrl.readAndWrite(timings.h.polarity, vgaCtrlBaseAddress + 4, bitOffset = 0)
        busCtrl.readAndWrite(timings.v.polarity, vgaCtrlBaseAddress + 4, bitOffset = 1)
        busCtrl.readAndWrite(timings.h.syncStart, vgaCtrlBaseAddress + 8, bitOffset = 0)
        busCtrl.readAndWrite(timings.h.syncEnd, vgaCtrlBaseAddress + 8, bitOffset = 16)
        busCtrl.readAndWrite(timings.h.colorStart, vgaCtrlBaseAddress + 12, bitOffset = 0)
        busCtrl.readAndWrite(timings.h.colorEnd, vgaCtrlBaseAddress + 12, bitOffset = 16)
        busCtrl.readAndWrite(timings.v.syncStart, vgaCtrlBaseAddress + 16, bitOffset = 0)
        busCtrl.readAndWrite(timings.v.syncEnd, vgaCtrlBaseAddress + 16, bitOffset = 16)
        busCtrl.readAndWrite(timings.v.colorStart, vgaCtrlBaseAddress + 20, bitOffset = 0)
        busCtrl.readAndWrite(timings.v.colorEnd, vgaCtrlBaseAddress + 20, bitOffset = 16)
    }

    noIoPrefix()
}

object DispEngineVerilog {
    def main(args: Array[String]) {
        SpinalVerilog(new DispEngine(16, 0x0, 0x1000, 0x2000, RgbConfig(5, 6, 5))).printPruned()
    }
}
