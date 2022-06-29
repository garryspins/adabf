with Ada.Containers.Vectors;

package Interpreter is
    type TapeNode is mod 256;
    package TapeVec is new Ada.Containers.Vectors (Natural, TapeNode);
    package LoopVec is new Ada.Containers.Vectors (Natural, Natural);

    procedure Run (code : String; debug : Boolean);

    ExecFailure : exception;
end Interpreter;
