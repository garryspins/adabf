with Interpreter;
with Ada.Command_Line;

with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Main is
begin
    for J in 1 .. Ada.Command_Line.Argument_Count loop
        declare
            FileN : String           := Ada.Command_Line.Argument (J);
            FType : File_Type;
            FVal  : Unbounded_String := Null_Unbounded_String;
            Last  : Character;
        begin
            Open (FType, In_File, FileN);

            ReadLoop :
            loop
                exit ReadLoop when End_Of_File (FType);
                Get (File => FType, Item => Last);
                Append (FVal, Last);
            end loop ReadLoop;

            Interpreter.Run (To_String (FVal));

            Close (FType);
        end;
    end loop;
end Main;
