   M S B A M L   `   `   `  ����H  Dkezelofelulet, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null-clr-namespace:kezelofeluletkezelofelulet  5   	       kezelofelulet.kategoriak   5   	   \ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    5   	   R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5   	   @d2http://schemas.microsoft.com/expression/blend/2008     5   	   Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5   	   -localclr-namespace:kezelofelulet     5   	     � Title$  Kategóriák��5   	   $	��575��6   $	��800��6)    � WindowStartupLocation$ CenterScreen=�5	   	   .��5
      � $��20q�6    � RowDefinitions 5   
   �� 5      $
��Auto �6   �� 5      $��* �6   �� 5      $
��Auto �6   .+�5   
   �� $��Kategóriák��6   $��24(�6&   $
��Bold"�64   ���#333$��10q�6X   � 5   
   $��1��6   $��	0,10,0,10q�6    � ColumnDefinitions 5      �� 5      $��2* �6#   �� 5      $��3* �6#   .+�5      �� -   5         ��Name$ listView��5      $��0��6)   $��10q�69   
����������#CCC$��1q�6k    �� View 5      �� 5      .P�5      �� $
��Név��6)    �� DisplayMemberBinding 66   �� *Name+5      5      �� 5!      $��1��6   $��20q�6)   .+�5"      �� $��Név:��6   $
��Bold"�6(   �� 5#      -   5         ��Name$ nevBox��5#      
�������6B   �� 5&      $��Főkategóriája:��6   $
��Bold"�62   $��0,10,0,0q�6D   �� 5'      -   5         ��Name$ fokategoriak��5'      
�������$��26��6I   6U   5(      5)      �� 5+   
   $��2��6   	 �� Orientation$	 
Horizontal=�6"   $��Right=�6;   .+�5,      �� -   5        
 ��Name$	
 mod��5,      $��Módosítás��6"   $	��100��66   ���#0078D7
�������{�.  6|   �� 5-      -   5        $	
 add��5-      $��Új hozzáadása��6"   $	��130��6:   ���#28A745
�������{�.  6�   �� 5.      -   5        $	
 del��5.      $��Törlés��6"   $	��100��63   ���#DC3545
�������6g   �� 5/      -   5        $
 select��5/      $��Kiválasztás törlése��6%   $	��150��6C   ���#6C757D
�������6w   �� 50      -   5        $
 label��50      $��Vissza��6$   $	��100��65   ���#343A40
�������6i   51      52      55      