Package Reference
=================

Simple-Kria-Kv260-Example does not ship a platform-level VHDL package
(``firmware/shared/rtl/AppPkg.vhd`` is absent from this design). This is a
PRBS loopback and HDA I/O test design with no ADC, DAC, or signal-processing
logic; there are no DSP-path size constants or sample-bus width declarations.
Constants relevant to the application are declared directly in the top-level
entity's architecture body.


Top-level constants
-------------------

The following constant is declared in the ``top_level`` architecture of
:repo:`firmware/targets/SimpleKriaKv260Example/hdl/SimpleKriaKv260Example.vhd`:

.. list-table::
   :header-rows: 1
   :widths: 30 15 55

   * - Name
     - Value
     - Description
   * - ``DMA_SIZE_C``
     - ``2``
     - Number of DMA lanes. Lane 0 carries PRBS data; lane 1 carries the XVC
       (Xilinx Virtual Cable) debug stream.


For platform-level constants (AXI Stream bus widths, DMA engine parameters)
see the :hub:`reference/index.html` on the platform docs site.
