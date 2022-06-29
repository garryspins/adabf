with Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

package body Interpreter is
    procedure Run (code : String; debug : Boolean) is
        Tape  : TapeVec.Vector;
        LoopV : LoopVec.Vector;
        Ptr   : Natural := 0;
        I     : Natural := code'First;
    begin
        Tape.Append (0);

        ExecutionLoop :
        while I <= code'Length loop
            case code (I) is
                when '*' =>
                    if debug then
                        Ada.Text_IO.Put_Line ("");
                        Ada.Text_IO.Put_Line ("-- Start Debug Dump --");

                        Ada.Text_IO.Put_Line ("Ptr:" & (HT & HT) & Ptr'Img);
                        Ada.Text_IO.Put_Line
                           ("TapeItems(" & Tape.Last_Index'Img & " ):");

                        for Val in 0 .. Tape.Last_Index loop
                            declare
                                TVal : TapeNode;
                            begin
                                TVal := Tape (Val);

                                Ada.Text_IO.Put_Line
                                   (HT & '[' & Val'Img & " ] =" & TVal'Img &
                                    HT & " ( " & Character'Val (TVal) & " )");
                            end;
                        end loop;

                        Ada.Text_IO.Put_Line ("-- End  Debug  Dump -- ");
                    end if;

                when '>' =>
                    if Tape.Last_Index = Ptr then
                        Tape.Append (0);
                    end if;

                    Ptr := Ptr + 1;
                when '<' =>
                    if Ptr = 0 then
                        Ptr := Tape.Last_Index;
                    else
                        Ptr := Ptr - 1;
                    end if;

                when '+' =>
                    Tape (Ptr) := Tape (Ptr) + 1;

                when '-' =>
                    Tape (Ptr) := Tape (Ptr) - 1;

                when '.' =>
                    declare
                        Char : TapeNode := Tape (Ptr);
                    begin
                        Ada.Text_IO.Put (Character'Val (Integer (Char)));
                    end;

                when ',' =>
                    declare
                        Char : Character;
                    begin
                        Ada.Text_IO.Get (Char);
                        Tape (Ptr) := Character'Pos (Char);
                    end;

                when '[' =>
                    declare
                        Original : Integer := LoopV.Last_Index;
                    begin
                        LoopV.Append (I);

                        if Tape (Ptr) = 0 then
                            I := I + 1;
                            SkipLoop :
                            while I <= code'Length loop
                                if code (I) = '[' then
                                    LoopV.Append (I);
                                elsif code (I) = ']' then
                                    LoopV.Delete_Last;
                                end if;

                                I := I + 1;
                                exit SkipLoop when LoopV.Last_Index = Original;
                            end loop SkipLoop;
                        end if;
                    end;

                when ']' =>
                    if LoopV.Last_Index = LoopVec.No_Index then
                        raise ExecFailure
                           with "[Error] Unexpected ']' (" & I'Img & " )";
                    else
                        if Tape (Ptr) = 0 then
                            LoopV.Delete_Last;
                        else
                            I := LoopV.Last_Element;
                        end if;
                    end if;

                when others =>
                    null;
            end case;

            I := I + 1;
        end loop ExecutionLoop;

        if LoopV.Last_Index /= LoopVec.No_Index then
            raise ExecFailure
               with "[Error] Unclosed Loop (" & LoopV.Last_Element'Img & " )";
        end if;
    end Run;
end Interpreter;
