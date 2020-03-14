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

import Vector::*;

import CrossbarSwitchComponent::*;


interface CrossbarSwitchIngressPort#(numeric type egressPortsCount, type egressPortAddress, type t);
    method Action put(t value, egressPortAddress destination);
endinterface

interface CrossbarSwitchEgressPort#(type t);
    method t get;
endinterface

interface CrossbarSwitch#(numeric type ingressPortsCount, numeric type egressPortsCount, type egressPortAddress, type t);
    interface Vector#(ingressPortsCount, CrossbarSwitchIngressPort#(egressPortsCount, egressPortAddress, t)) ingressPort;
    interface Vector#(egressPortsCount, CrossbarSwitchEgressPort#(t)) egressPort;
endinterface


module mkCrossbarSwitch(CrossbarSwitch#(ingressPortsCount, egressPortsCount, egressPortAddress, t))
provisos (Bits#(t, tBitwidth), Alias#(Bit#(TLog#(egressPortsCount)), egressPortAddress), PrimIndex#(egressPortAddress, egressPortAddressBitwidth));
    /**
        1-cycle Crossbar Switch
    **/

    // Components
    Vector#(egressPortsCount, CrossbarSwitchComponent#(ingressPortsCount, t)) crossbarSwitchComponents <- replicateM(mkCrossbarSwitchComponent);

    // Combinational Logics

    // Rules

    // Interfaces
    Vector#(ingressPortsCount, CrossbarSwitchIngressPort#(egressPortsCount, egressPortAddress, t)) ingressPortDefinition = newVector;
    for (Integer inPort = 0; inPort < valueOf(ingressPortsCount); inPort = inPort + 1) begin
        ingressPortDefinition[inPort] = interface CrossbarSwitchIngressPort#(t)
            method Action put(t value, egressPortAddress destination);
                crossbarSwitchComponents[destination].ingressPort[inPort].put(value);
            endmethod
        endinterface;
    end
    
    Vector#(egressPortsCount, CrossbarSwitchEgressPort#(t)) egressPortDefinition = newVector;
    for (Integer outPort = 0; outPort < valueOf(egressPortsCount); outPort = outPort + 1) begin
        egressPortDefinition[outPort] = interface CrossbarSwitchEgressPort#(t)
            method t get;
                return crossbarSwitchComponents[outPort].egressPort.get;
            endmethod
        endinterface;
    end

    interface ingressPort = ingressPortDefinition;
    interface egressPort = egressPortDefinition;
endmodule
