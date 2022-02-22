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

        public Core.Options _options;
        public Core.Options options {
            get {
                return _options;
            }
            set {
                _options = value;

                for (int i = 0; i < value.length; i++) {
                    add_new_option (value.get_option_at (i));
                }
            }
        }
        public int length { get; set; default = 0; }

        static construct {
            typeof (OptionRow).ensure ();
        }

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

        public void add_new_option (Core.Option option = options.add_new_option ()) {
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

            var row = new OptionRow (option);
            if (length == 0) {
                group = row.checkbutton;
            }
            else {
                row.checkbutton.group = group;
            }
            length++;
            row.trash_request.connect (on_trash_request);

            listbox.append (row);
            listbox.append (new_option_row);
        }

        private void on_trash_request (OptionRow o) {
            options.delete_option (o.option);

            var listbox = child as Gtk.ListBox;
            listbox.remove (o);
            o.dispose ();
            length--;
        }
    }
}
