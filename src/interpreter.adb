with Ada.Text_IO;

package body Interpreter is
    procedure Run (code : String) is
        Tape  : TapeVec.Vector;
        LoopV : LoopVec.Vector;
        Ptr   : Natural := 0;
        I     : Natural := code'First;
    begin
        Tape.Append (0);

        ExecutionLoop :
        while I <= code'Length loop
            case code (I) is
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
                    if Tape (Ptr) = 255 then
                        Tape (Ptr) := 0;
                    else
                        Tape (Ptr) := Tape (Ptr) + 1;
                    end if;

                when '-' =>
                    if Tape (Ptr) /= 0 then
                        Tape (Ptr) := Tape (Ptr) - 1;
                    else
                        Tape (Ptr) := 255;
                    end if;

                when '.' =>
                    declare
                        Char : Natural := Tape (Ptr);
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
                            SkipLoop :
                            while I <= code'Length loop
                                I := I + 1;
                                if code (I) = '[' then
                                    LoopV.Append (I);
                                elsif code (I) = ']' then
                                    LoopV.Delete_Last;
                                end if;

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
    end Run;
end Interpreter;
