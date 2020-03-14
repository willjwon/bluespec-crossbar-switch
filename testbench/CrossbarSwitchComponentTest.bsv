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

import CrossbarSwitchComponent::*;


typedef Bit#(32) TestInt;
TestInt maxSimulationCycles = 10000;


(* synthesize *)
module mkCrossbarSwitchComponentTest();
    // Unit under test
    CrossbarSwitchComponent#(10, Bit#(16)) uut <- mkCrossbarSwitchComponent;

    // Testbench variables
    Reg#(TestInt) cycle <- mkReg(0);

    rule runSimulation;
        cycle <= cycle + 1;
    endrule

    rule finishSimulation if (cycle >= maxSimulationCycles);
        $display("[SIM] Simulation done at cycle %d", cycle);
        $finish(0);
    endrule

    rule put if (cycle == 0);
        uut.ingressPort[9].put(7);
    endrule

    rule print;
        $display("Received %d at cycle %d", uut.egressPort.get, cycle);
    endrule
endmodule