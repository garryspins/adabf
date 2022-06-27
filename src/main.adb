with Interpreter;
with Ada.Command_Line;
with Ada.Exceptions;
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

        exception
            when Error : Interpreter.ExecFailure =>
                Ada.Text_IO.Put_Line
                   ("[ExecFailure] " &
                    Ada.Exceptions.Exception_Message (Error));
            when Error : others =>
                Ada.Text_IO.Put_Line
                   ("[ReadError] " & Ada.Exceptions.Exception_Message (Error));
        end;
    end loop;
end Main;
