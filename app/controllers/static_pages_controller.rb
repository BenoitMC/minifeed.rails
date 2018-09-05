class StaticPagesController < ApplicationController
  def keyboard_shortcuts
    skip_policy_scope

    @list = {
      "h"     => "help",
      "left"  => "previous_entry",
      "right" => "next_entry",
      "esc"   => "close_modal",
      "r"     => "mark_entry_as_un_read",
      "s"     => "mark_entry_as_un_starred",
      "p"     => "reader_mode",
      "m"     => "open_internal",
      "o"     => "open_external",
    }
  end
end
