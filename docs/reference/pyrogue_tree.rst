PyRogue Device Tree
===================

The PyRogue device tree for Simple-Kria-Kv260-Example is defined in the
:repo:`firmware/python/simple_kria_kv260_example/` package. The package
contains three source files: ``_Root.py``, ``_Application.py``, and
``__init__.py``.


Hierarchy
---------

- ``Root`` (:repo:`firmware/python/simple_kria_kv260_example/_Root.py`)

  - ``AxiSocCore`` — platform core device at offset ``0x04_0000_0000``
    (``socCore.AxiSocCore``)
  - ``Application`` — application device at offset ``0x04_8000_0000``
    (:repo:`firmware/python/simple_kria_kv260_example/_Application.py`)

    - ``SsiPrbsTx`` — PRBS transmit generator at offset ``0x0_0000``
      (``surf.protocols.ssi.SsiPrbsTx``)
    - ``SsiPrbsRx`` — PRBS receive checker at offset ``0x1_0000``
      (``surf.protocols.ssi.SsiPrbsRx``)
    - ``HdaInputBus`` — HDA input bus read register at offset ``0x2_0000``
      (``pr.RemoteVariable``, read-only, polled every 1 s)
    - ``HdaOutputBus`` — HDA output bus write register at offset ``0x2_0100``
      (``pr.RemoteVariable``, read/write)
    - ``HdaTriBus`` — HDA tristate control register at offset ``0x2_0104``
      (``pr.RemoteVariable``, read/write)
  - ``prbsRx`` — software-side PRBS checker (``pyrogue.utilities.prbs.PrbsRx``,
    128-bit, connected to DMA TCP stream port 10000)
  - ``prbTx`` — software-side PRBS generator (``pyrogue.utilities.prbs.PrbsTx``,
    128-bit, connected to DMA TCP stream port 10000)


Public surface
--------------

``__init__.py`` re-exports the two implementation classes:

.. code-block:: python

   from simple_kria_kv260_example._Application import *
   from simple_kria_kv260_example._Root       import *


Startup sequence
----------------

``Root.__init__`` performs the following steps (from
:repo:`firmware/python/simple_kria_kv260_example/_Root.py`):

- Opens a TCP memory-map client to the board at port 9000 (``tcpMemBase``).
- Opens a TCP stream client for DMA lane 0 at port 10000 (``dataStream``).
- Opens a TCP stream client for DMA lane 1 at port 10512 (``xvcStream``).
- Instantiates a local XVC server on port 2542 and connects
  the XVC stream to it (``dmaClk`` → JTAG passthrough).
- Adds ``AxiSocCore`` and ``Application`` as child devices with the
  offsets above.
- Connects the data stream to the software-side ``prbsRx`` and ``prbTx``
  objects for host-driven PRBS loopback testing.

For the PyRogue API reference see :hub:`reference/pyrogue_api.html`.
