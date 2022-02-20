/* OptionsList.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Quizmaker {
    public class OptionsList : Adw.Bin {
        public Adw.PreferencesRow new_option_row { get; protected set; }
        public Gtk.CheckButton group { get; set; }
        public int length { get; set; default = 0; }

        construct {
            var listbox = new Gtk.ListBox () {
                selection_mode = NONE,
            };
            listbox.add_css_class ("boxed-list");
            child = listbox;
            new_option_row = new Adw.PreferencesRow () {
                child = new Gtk.Label (_("Add a new Option")) {
                    margin_top = 12,
                    margin_bottom = 12
                }
            };
            listbox.append (new_option_row);

            listbox.row_activated.connect ((row) => {
                if (row != new_option_row) {
                    var r = row as OptionRow;
                    r.checkbutton.active = true;
                    return;
                }
                add_new_option ();
            });
        }

        public void add_new_option (string? str = "") {
            var listbox = child as Gtk.ListBox;
            if (new_option_row == null) {
                new_option_row = new Adw.PreferencesRow () {
                    child = new Gtk.Label (_("Add a new Option")) {
                        margin_top = 12,
                        margin_bottom = 12
                    }
                };
            }
            else {
                listbox.remove (new_option_row);
            }

            var row = new OptionRow (str);
            if (length == 0) {
                group = row.checkbutton;
            }
            else {
                row.checkbutton.group = group;
                message ("not in group");
            }
            length++;
            row.trash_request.connect (on_trash_request);

            listbox.append (row);
            listbox.append (new_option_row);
        }

        public GLib.List get_options () {
            var l = new GLib.List <string> ();
            int index = 0;

            var list = child as Gtk.ListBox;
            Gtk.ListBoxRow? current_row;
            current_row = list.get_row_at_index (index);

            while (current_row != null) {
                if (current_row == new_option_row)
                    break;

                var r = current_row as OptionRow;
                string c = r.content;

                if (c == "") {
                    warning ("Row %i is empty", index);
                }
                else {
                    l.append (c);
                }

                index++;
                current_row = list.get_row_at_index (index); // go to the next row
            }

            return l;
        }

        private void on_trash_request (OptionRow o) {
            var listbox = child as Gtk.ListBox;
            listbox.remove (o);
            o.dispose ();
            length--;
        }
    }
}
