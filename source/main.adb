with Controller_Quit;           use Controller_Quit;
with Controller_DataLoad;       use Controller_DataLoad;
with Controller_Internet;       use Controller_Internet;
with Controller_Bugz;           use Controller_Bugz;
with Controller_Choices;        use Controller_Choices;
with Controller_Help;           use Controller_Help;
with Controller_Dummy;          use Controller_Dummy;
with Controller_Error;          use Controller_Error;
with Reporter;                  use Reporter;
with Ada.Exceptions;

with RASCAL.Toolbox;            use RASCAL.Toolbox;
with RASCAL.FileExternal;       use RASCAL.FileExternal;
with RASCAL.Utility;            use RASCAL.Utility;
with RASCAL.Error;              use RASCAL.Error;
with RASCAL.MessageTrans;       use RASCAL.MessageTrans;
with RASCAL.Sprite;
with RASCAL.ToolboxProgInfo;
with RASCAL.ToolboxWindow;

package body Main is

   --

   package Toolbox         renames RASCAL.Toolbox;
   package FileExternal    renames RASCAL.FileExternal;   
   package Utility         renames RASCAL.Utility;        
   package Error           renames RASCAL.Error;          
   package MessageTrans    renames RASCAL.MessageTrans;   
   package Sprite          renames RASCAL.Sprite;         
   package ToolboxProgInfo renames RASCAL.ToolboxProgInfo;
   package ToolboxWindow   renames RASCAL.ToolboxWindow;
   package WimpTask        renames RASCAL.WimpTask;
   package OS              renames RASCAL.OS;
   package Variable        renames RASCAL.Variable;

   --

   procedure Report_Error (Token : in String;
                           Info  : in String) is

      E        : Error_Pointer          := Get_Error (Main_Task);
      M        : Error_Message_Pointer  := new Error_Message_Type;
      Result   : Error_Return_Type;
   begin
      M.all.Token(1..Token'Length) := Token;
      M.all.Param1(1..Info'Length) := Info;
      M.all.Category := Warning;
      M.all.Flags    := Error_Flag_OK;
      Result         := Error.Show_Message (E,M);
   end Report_Error;

   --

   procedure Main is

      ProgInfo_Window : Object_ID;
      Misc            : Messages_Handle_Type;
   begin
      -- Messages
      Add_Listener (Main_Task,new MEL_Message_Bugz_Query);
      Add_Listener (Main_Task,new MEL_Message_DataLoad);
      Add_Listener (Main_Task,new MEL_Message_Quit);

      -- Toolbox Events
      Add_Listener (Main_Task,new TEL_Quit_Quit);
      Add_Listener (Main_Task,new TEL_ViewManual_Type);
      Add_Listener (Main_Task,new TEL_ViewSection_Type);
      Add_Listener (Main_Task,new TEL_ViewIHelp_Type);
      Add_Listener (Main_Task,new TEL_ViewHomePage_Type);
      Add_Listener (Main_Task,new TEL_ViewChoices_Type);
      Add_Listener (Main_Task,new TEL_SendEmail_Type);
      Add_Listener (Main_Task,new TEL_CreateReport_Type);      
      Add_Listener (Main_Task,new TEL_Toolbox_Error);
      Add_Listener (Main_Task,new TEL_OpenWindow);
      Add_Listener (Main_Task,new TEL_OKClicked);
      Add_Listener (Main_Task,new TEL_Dummy);

      -- Start task
      WimpTask.Set_Resources_Path(Main_Task,"<InsertIcnRes$Dir>");
      WimpTask.Initialise(Main_Task);

      if FileExternal.Exists("Choices:InsertIcon.Misc") then
         Misc := MessageTrans.Open_File("Choices:InsertIcon.Misc");
         begin
            Read_Integer ("XPOS",x_pos,Misc);
            Read_Integer ("YPOS",y_pos,Misc);
         exception
            when others => null;            
         end;
      end if;

      main_objectid   := Toolbox.Create_Object("Window",From_Template);
      if not Sprite.Is_PriorityPool then
         ToolboxWindow.Gadget_Fade (main_objectid,1);
      end if;
      ProgInfo_Window := Toolbox.Create_Object("ProgInfo",From_Template);
      ToolboxProgInfo.Set_Version(ProgInfo_Window,MessageTrans.Lookup("VERS",Get_Message_Block(Main_Task)));
      
      --
      Untitled_String := U(MessageTrans.Lookup("UNTITLED",Get_Message_Block(Main_Task)));
      if Length(Untitled_String) = 0 then
         Untitled_String := U("Untitled");
      end if;

      WimpTask.Poll(Main_Task);

   exception
      when e: others => Report_Error("UNTRAPPED",Ada.Exceptions.Exception_Information (e));
   end Main;

   --

end Main;

