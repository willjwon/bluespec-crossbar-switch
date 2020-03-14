// MIT License

// Copyright (c) 2020 William Won (william.won@gatech.edu)

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import CrossbarSwitch::*;


// User settings
typedef 16 IngressPortsCount;
typedef 16 EgressPortsCount;
typedef Bit#(64) Data;

// Derived Settings
typedef Bit#(TLog#(EgressPortsCount)) EgressPortAddress;


(* synthesize *)
module mkCrossbarSwitchInstance(CrossbarSwitch#(IngressPortsCount, EgressPortsCount, EgressPortAddress, Data));
    // 32 x 16 crossbar (4bit output destination address), each driving 64 bits
    CrossbarSwitch#(IngressPortsCount, EgressPortsCount, EgressPortAddress, Data) crossbarSwitch <- mkCrossbarSwitch;
    return crossbarSwitch;
endmodule
