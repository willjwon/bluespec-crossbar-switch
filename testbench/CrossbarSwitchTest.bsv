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


import Adder::*;


int maxCycle = 100;


(* synthesize *)
module mkAdderTest();
    // Unit Under Test
    let adder <- mkAdder;

    // Testbench Environment
    Reg#(int) cycle <- mkReg(0);

    // Benchmarks
    // pass

    // Run Testbench
    rule runTestbench if (cycle < maxCycle);
        cycle <= cycle + 1;
    endrule

    rule finishSimulation if (cycle >= maxCycle);
        $display("[Finish] Cycle %d reached.", maxCycle);
        $finish(0);
    endrule

    // Test Cases
    rule putArgs if (cycle == 1);
        adder.putA(1);
        adder.putB(2);
    endrule

    rule getResult if (cycle == 2);
        let result <- adder.getResult();
        $display("[Result] Adder result: %d", result);
    endrule
endmodule
