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

import RWire::*;
import Vector::*;


interface CrossbarSwitchComponentIngressPort#(type t);
    method Action put(t value);
endinterface

interface CrossbarSwitchComponentEgressPort#(type t);
    method t get;
endinterface

interface CrossbarSwitchComponent#(numeric type ingressPortsCount, type t);
    interface Vector#(ingressPortsCount, CrossbarSwitchComponentIngressPort#(t)) ingressPort;
    interface CrossbarSwitchComponentEgressPort#(t) egressPort;
endinterface


module mkCrossbarSwitchComponent(CrossbarSwitchComponent#(ingressPortsCount, t)) provisos (Bits#(t, tBitwidth));
    /**
        Multiple ingress ports - one egress port connection
    **/

    // Components
    Vector#(ingressPortsCount, RWire#(t)) ingressValues <- replicateM(mkRWire);
    RWire#(t) egressValue <- mkRWire;

    // Combinational Logics
    Bool areIngressValuesReady = False;
    for (Integer inPort = 0; inPort < valueOf(ingressPortsCount); inPort = inPort + 1) begin
        if (isValid(ingressValues[inPort].wget)) begin
            areIngressValuesReady = True;
        end
    end

    // Rules
    rule connect if (areIngressValuesReady);
        t ingressValue = ?; 
        for (Integer inPort = 0; inPort < valueOf(ingressPortsCount); inPort = inPort + 1) begin
            if (ingressValues[inPort].wget matches tagged Valid .value) begin
                ingressValue = value;
            end
        end

        egressValue.wset(ingressValue);
    endrule

    Vector#(ingressPortsCount, CrossbarSwitchComponentIngressPort#(t)) ingressPortDefinition = newVector;
    for (Integer inPort = 0; inPort < valueOf(ingressPortsCount); inPort = inPort + 1) begin
        ingressPortDefinition[inPort] = interface CrossbarSwitchComponentIngressPort#(t)
            method Action put(t value);
                ingressValues[inPort].wset(value);
            endmethod
        endinterface;
    end
    
    interface ingressPort = ingressPortDefinition;
    interface egressPort = interface CrossbarSwitchComponentEgressPort#(t)
        method t get if (isValid(egressValue.wget));
            return validValue(egressValue.wget);
        endmethod
    endinterface;
endmodule