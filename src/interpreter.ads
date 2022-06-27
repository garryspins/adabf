
with Ada.Containers.Vectors;

package Interpreter is
    package TapeVec is new Ada.Containers.Vectors(Natural, Natural); 
    package LoopVec is new Ada.Containers.Vectors(Natural, Natural); 

    procedure Run(code:String);

    ExecFailure : exception;
end Interpreter;