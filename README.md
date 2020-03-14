<!-- MIT License

Copyright (c) 2020 William Won (william.won@gatech.edu)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE. -->

# bluespec-crossbar-switch
1-cycle `CrossbarSwitch` implementation in Bluespec System Verilog, using `RWire` module.

## Interface
`CrossbarSwitch#(Ingress Ports Count, Egress Ports Count, Egress Port Address Type, Data Type)`

```bluespec
import CrossbarSwitch::*;

// 32 x 16 crossbar switch (egress port address is 4 bits), driving 64-bit data
CrossbarSwitch#(32, 16, Bit#(4), Bit#(64)) crossbarSwitch <- mkCrossbarSwitch;

// Put Data
crossbarSwitch.ingressPort[0].put(32'b3, 13)  // (Input 0) sending (data 32'b3) to (Output 13)

// Get Data
let output = crossbarSwitch.egressPort[13].get;  // (Output 13) receiving result (in the same cycle)
```
