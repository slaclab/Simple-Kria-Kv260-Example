First Build (Simple-Kria-Kv260-Example)
=======================================

This tutorial walks through building and bringing up the
Simple-Kria-Kv260-Example design on the Xilinx Kria KV260 Vision AI Starter
Kit (Kria K26 SOM, FPGA part ``xck26-sfvc784-2lv-c``). Application-specific
steps are documented here; shared host-environment and toolchain preparation
are on the :hub:`platform docs site <tutorial/first_soc_bringup.html>`.


Verified host environment
-------------------------

Follow the platform-level setup guide at
:hub:`tutorial/first_soc_bringup.html#setup-environment` for Conda, Vivado,
and host-package prerequisites.

.. note::

   Per-board build verification was not performed in this iteration; toolchain
   matches the platform reference environment.


Clone
-----

Clone the repository with all submodules:

.. code-block:: bash

   git clone --recursive https://github.com/slaclab/Simple-Kria-Kv260-Example.git


Firmware build
--------------

Change to the target directory and invoke ``make``:

.. code-block:: bash

   cd Simple-Kria-Kv260-Example/firmware/targets/SimpleKriaKv260Example/
   make

For the shared Vivado build narrative see
:hub:`tutorial/first_soc_bringup.html#firmware-build`.

The build produces a ``.bit`` and a ``.xsa`` file in
``SimpleKriaKv260Example/images/``.  The filename follows the schema::

   <TargetName>-<PRJ_VERSION>-<YYYYMMDDHHMMSS>-<user>-<git-short-SHA>.xsa

Use the actual filename produced by your build in subsequent steps.


Yocto build
-----------

Generate the embedded Linux image from the ``.xsa`` file.  The Kria build
requires the ``-c`` clean flag:

.. code-block:: bash

   cd Simple-Kria-Kv260-Example/firmware/targets/SimpleKriaKv260Example/
   ./BuildYoctoProject -c -f images/<TargetName>-<PRJ_VERSION>-<YYYYMMDDHHMMSS>-<user>-<git-short-SHA>.xsa

For the shared Yocto build narrative (bare-metal vs Docker, build-output
redirection, host-package prerequisites) see
:hub:`tutorial/first_soc_bringup.html#yocto-build`.


SD card
-------

Follow the shared SD card imaging procedure at
:hub:`tutorial/first_soc_bringup.html#sd-card`.


Boot
----

The KV260 board uses resistor-based MODE pins (not a DIP switch) to select
the boot mode. For SD-card boot, the MODE pins must be configured as
``MODE[3:0]_C2M = 0b1110``:

- ``MODE3_C2M = R162 = open (remove resistor)``
- ``MODE2_C2M = R163 = open (remove resistor)``
- ``MODE1_C2M = R164 = open (default)``
- ``MODE0_C2M = R165 = 499 Ohm (default)``

For the remaining boot and verification steps see
:hub:`tutorial/first_soc_bringup.html#boot`.
