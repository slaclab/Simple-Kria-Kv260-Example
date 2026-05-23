Architecture Overview (Simple-Kria-Kv260-Example)
==================================================

Simple-Kria-Kv260-Example is a PRBS loopback and HDA I/O test design running
on the Kria K26 SOM (``xck26-sfvc784-2lv-c``). It is built on the SLAC
``axi-soc-ultra-plus-core`` platform but does not include an ADC/DAC DSP path.
The design validates DMA throughput and I/O connectivity, not signal processing.

For the full platform-level architecture (DMA engine, AXI-Lite bridge,
PS-PL interface, software stack) see :hub:`explanation/architecture.html`.


Topology
--------

The design has two active data paths:

- **PRBS loopback (DMA lane 0):** ``SsiPrbsTx`` generates a 128-bit PRBS
  stream and drives it to the DMA inbound path. The host receives the stream
  over TCP (port 10000) and a software-side ``PrbsRx`` checker validates
  integrity. In the reverse direction, the host can transmit a PRBS pattern
  that the firmware ``SsiPrbsRx`` checker consumes from the DMA outbound
  path. This end-to-end loopback exercises the full DMA lane 0 path.
- **HDA I/O (PMOD pins):** The ``Application`` crossbar slave ``HDA_IO_C``
  exposes the eight ``pmod`` pins via ``AxiLiteRegs`` register read/write.
  A tristate control register (``HdaTriBus``) selects input/output direction
  per pin. The input register (``HdaInputBus``) is polled by PyRogue every
  second. This path exercises the bidirectional I/O bank.

DMA lane 1 carries the XVC (Xilinx Virtual Cable) debug stream over TCP port
10512, enabling JTAG access through the DMA fabric.

``DMA_SIZE_C = 2`` is the only application-level size constant; it is declared
in the top-level VHDL architecture body (no ``AppPkg.vhd``). See
:doc:`../reference/rtl_top_entity` and :doc:`../reference/register_map`.


Clock domain
------------

The design runs in two functional clock domains, both sourced from
``AxiSocUltraPlusCore``:

- ``axilClk`` (100 MHz) — AXI-Lite register access from the PS.
- ``dmaClk`` (250 MHz) — DMA engine and application datapath crossbar.

The ``Application`` entity bridges these two domains with
``surf.AxiLiteAsync`` before the internal crossbar. A third derived clock
``xvcClk156`` (156.25 MHz) feeds only the XVC debug module and is isolated
from the functional paths by an asynchronous clock group constraint in the
XDC.

No separate DSP or ADC converter clock is present — no signal-processing
logic is instantiated in this design. The platform-level multi-domain clock
pattern (described at :hub:`explanation/architecture.html#clock-domains`)
does not apply here; only the AXI-Lite and DMA clocks are used.
