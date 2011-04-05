xsb-interface: A Ruby interface to the XSB Prolog interpreter
==============================================================

This gem is basically a Ruby mapping of the C interface provided by XSB
version 3.0.1.

Installation
------------

 * Install XSB 3.0.1
 * Include the path to the XSB executable prior to installing the gem:

     export PATH=$PATH:/usr/local/XSB/3.0.1/bin
     gem install xsb-interface

Known Issues
------------

 * Probably does not work with versions of XSB newer than 3.0.1

Copyright (c) 2011 Medical Decision Logic, released under the MIT license
