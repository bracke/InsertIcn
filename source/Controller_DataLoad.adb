with Ada.Strings.Unbounded;      use Ada.Strings.Unbounded;
with Main;                       use Main;
with Interfaces.C;               use Interfaces.C;
with Reporter;
with ADa.Exceptions;

with RASCAL.OS;                         use RASCAL.OS;
with RASCAL.Utility;                    use RASCAL.Utility;
with RASCAL.FileInternal;               use RASCAL.FileInternal;
with RASCAL.Toolbox;                    use RASCAL.Toolbox;
with RASCAL.Mode;                       use RASCAL.Mode;
with RASCAL.ToolboxRadioButton;         use RASCAL.ToolboxRadioButton;
with RASCAL.ToolboxOptionButton;        use RASCAL.ToolboxOptionButton;
with RASCAL.Keyboard;
with RASCAL.ToolboxWritableField;
with RASCAL.ToolboxWindow;
with RASCAL.WimpWindow;
with RASCAL.FileExternal;

package body Controller_DataLoad is

   --

   package OS                     renames RASCAL.OS;
   package Utility                renames RASCAL.Utility;             
   package FileInternal           renames RASCAL.FileInternal;        
   package Toolbox                renames RASCAL.Toolbox;             
   package Mode                   renames RASCAL.Mode;                
   package ToolboxRadioButton     renames RASCAL.ToolboxRadioButton;  
   package ToolboxOptionButton    renames RASCAL.ToolboxOptionButton; 
   package Keyboard               renames RASCAL.Keyboard;            
   package ToolboxWritableField   renames RASCAL.ToolboxWritableField;
   package ToolboxWindow          renames RASCAL.ToolboxWindow;       
   package WimpWindow             renames RASCAL.WimpWindow;          
   package FileExternal           renames RASCAL.FileExternal;

   --

   procedure Insert_Sprite is

      Pool : Positive range 1..3 := 1;
   begin
      if Length(FilePath)>0 and then FileExternal.Exists(S(FilePath)) then
         if ToolboxRadioButton.Get_State(main_objectid,2) = Selected then
            Pool := 2;
         end if;
         if ToolboxRadioButton.Get_State(main_objectid,3) = Selected then
            Pool := 3;
         end if;
         case Pool is
         when 1 => Utility.Call_OS_CLI ("IconSprites -priority " & S(FilePath));
         when 2 => Utility.Call_OS_CLI ("IconSprites " & S(FilePath));
         when 3 => Utility.Call_OS_CLI ("ToolSprites " & S(FilePath));
         end case;
         if ToolboxOptionButton.Get_State(main_objectid,4) = On then
            WimpWindow.Force_RedrawAll;
         end if;
      end if;
   end Insert_Sprite;

   --
   
   procedure Open_Window is
   begin
      if x_pos > Mode.Get_X_Resolution (OSUnits) or
         y_pos > Mode.Get_Y_Resolution (OSUnits) or
                                       x_pos < 0 or y_pos < 0 then

         Toolbox.Show_Object (main_objectid,0,0,Centre);
      else
         Toolbox.Show_Object_At (main_objectid,x_pos,y_pos,0,0);
      end if;
      
   end Open_Window;

   --

   procedure Handle (The : in MEL_Message_DataLoad) is
     
      File_Type : Integer := The.Event.all.File_Type;
   begin
      FilePath  := U(To_Ada(The.Event.all.Full_Path));
      case File_Type is
      when 16#ff9# => if Keyboard.Is_Shift then
                         if not ToolboxWindow.Is_Open(main_objectid) then
                            Open_Window;
                         end if;
                      else
                         Insert_Sprite;   
                      end if;
                      
      when others  => null;
      end case;
   end Handle;

   --

   procedure Handle (The : in TEL_OpenWindow) is
   begin
      Open_Window;
   exception
      when Exception_Data : others => Report_Error("OPENWINDOW",Ada.Exceptions.Exception_Information (Exception_Data));
   end Handle;

   --

   procedure Handle (The : in TEL_OKClicked) is
   begin
      Insert_Sprite;
   exception
      when Exception_Data : others => Report_Error("OKCLICKED",Ada.Exceptions.Exception_Information (Exception_Data));
   end Handle;   
end Controller_DataLoad;
