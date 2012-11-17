with RASCAL.OS;                   use RASCAL.OS;
with RASCAL.DragNDrop;            use RASCAL.DragNDrop;

package Controller_DataLoad is
   
   type TEL_OpenWindow       is new Toolbox_UserEventListener(16#14#,-1,-1) with null record;
   type MEL_Message_DataLoad is new AMEL_Message_DataLoad with null record;
   type TEL_OKClicked        is new Toolbox_UserEventListener(16#9#,-1,-1) with null record;

   --
   -- The user has SELECT clicked on the iconbar icon.
   --
   procedure Handle (The : in TEL_OpenWindow);

   --
   -- The user has drag'n'dropped something on a SpriteLib window / icon.
   --
   procedure Handle (The : in MEL_Message_DataLoad);

   --
   -- The user has clicked on the OK button.
   --
   procedure Handle (The : in TEL_OKClicked);
   
end Controller_DataLoad;
