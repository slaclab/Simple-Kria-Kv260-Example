Application Register Map
========================

This page documents the AXI-Lite address map for Simple-Kria-Kv260-Example.
The design uses a two-level decode: the top-level entity routes the entire
AXI-Lite space to ``Application``, which then decodes three sub-slaves via an
internal crossbar.


Top-level AXI-Lite routing
---------------------------

The top-level entity
:repo:`firmware/targets/SimpleKriaKv260Example/hdl/SimpleKriaKv260Example.vhd`
does **not** instantiate a ``genAxiLiteConfig`` crossbar. Instead, it passes
the AXI-Lite master from ``AxiSocUltraPlusCore`` directly to the ``Application``
entity using ``AXIL_BASE_ADDR_G => APP_ADDR_OFFSET_C``.

There is no multi-index top-level crossbar in this design; the AXI-Lite bus
is passed directly to ``Application`` without an intermediate decode stage.


Application crossbar
--------------------

The ``Application`` entity
:repo:`firmware/shared/rtl/Application.vhd`
instantiates a three-master AXI-Lite crossbar (``NUM_AXIL_MASTERS_C = 3``)
decoded from ``AXIL_BASE_ADDR_G`` with a 20-bit window and 16-bit stride:

.. code-block:: vhdl

   constant AXIL_CONFIG_C : AxiLiteCrossbarMasterConfigArray(NUM_AXIL_MASTERS_C-1 downto 0) :=
       genAxiLiteConfig(NUM_AXIL_MASTERS_C, AXIL_BASE_ADDR_G, 20, 16);

The three slave indices are:

.. list-table::
   :header-rows: 1
   :widths: 20 10 70

   * - Constant
     - Index
     - Slave
   * - ``PRBS_TX_C``
     - ``0``
     - ``SsiPrbsTx`` — PRBS transmit generator. Drives DMA inbound lane 0.
   * - ``PRBS_RX_C``
     - ``1``
     - ``SsiPrbsRx`` — PRBS receive checker. Consumes DMA outbound lane 0.
   * - ``HDA_IO_C``
     - ``2``
     - ``AxiLiteRegs`` — HDA I/O register block. Exposes ``pmod`` pin
       input / output / tristate control via 8-bit registers.

This is a PRBS loopback and HDA I/O test design; it does not include a
ring-buffer or DAC SigGen sub-device.


Pattern: genAxiLiteConfig
--------------------------

For the full ``genAxiLiteConfig`` crossbar pattern used across the SLAC SoC
platform see :hub:`reference/register_map.html`.
