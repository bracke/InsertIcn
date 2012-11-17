with Ada.Strings.Unbounded;      use Ada.Strings.Unbounded;

with RASCAL.WimpTask;            use RASCAL.WimpTask;
with RASCAL.OS;                  use RASCAL.OS;
with RASCAL.Variable;            use RASCAL.Variable;

package Main is

   -- Constants
   app_name       : constant String := "InsertIcn";
   Choices_Write  : constant String := "<Choices$Write>." & app_name;
   Choices_Read   : constant String := "Choices:" & app_name & ".Choices";

   --
   Main_Task      : ToolBox_Task_Class;
   main_objectid  : Object_ID             := -1;
   main_winid     : Wimp_Handle_Type      := -1;
   Untitled_String: Unbounded_String;
   FilePath       : Unbounded_String;
     
   x_pos          : Integer := -1;
   y_pos          : Integer := -1;

   --

   procedure Report_Error (Token : in String;
                           Info  : in String);

   --

   procedure Main;

   --

 end Main;


