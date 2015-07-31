Eskimo Tables is a plugin split from eskimagic in order to facilitate independent
development. It currently has the one method eskimo_table that has the same
functionality as the old admin_table method from eskimagic.

So eskimo_table takes a hash as input and includes the following options;

:admin          => true/false         -- not currently used
:manual_sorting => true/false         -- if true table will be sorted through the use of drag handles
                                         instead of by column. Use this if you want to set the "position"
                                         attributes of a particular class. Defaults to false.
:drag_handle    => 'Column Name'      -- which column will be used in order to sort using manual sorting.
:menu           => true/false
:sorting        => true/false         -- enable/disable sorting using column headers.
:paging         => true/false         -- enable paging. Automatically set to false if using manual sorting.
                                         Defaults to true otherwise.
:notes          => false
:edit_action    => edit_action/nil    -- the edit action. Default is "edit". nil will disable.
:delete_action  => delete_action/nil  -- the delete action. Default is "destroy". nil will disable
:delete_message => messagebox_message -- The message to be displayed before a delete is performed.
:show_action    => show_action        -- the show action. Default is nil which disables it.
:order_action   => order_action       -- the order action. Default is "order".
:highlight      => subset of entries  -- any entry belonging to this subset will be highlighted.
                                         Defaults to nil.
:lowlight       => subset of entries  -- any entry belonging to this subset will be lowlighted.
                                         Defaults to items with "display" set to false.
:css_class      => CSS class          -- For changing style of entire table.
:images         => true/false         -- if set to true entries will include a link to the image
                                         manager for that item.

For backwards compatibility calling admin_table(hash) will have the same effect as calling
eskimo_table(hash) with manual_sorting => false.
Calling admin_table(hash, "admin/shared/admin_table_sort") will have the same effect as calling
eskimo_table(has) with manual_sorting => true.

