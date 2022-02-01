/* Sidebar.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Quizmaker {
    [GtkTemplate (ui = "/io/github/diegoivanme/quizmaker/sidebar.ui")]
    public class Sidebar : Gtk.Box {
        [GtkChild] unowned Gtk.ListBox listbox;
        public int item_number { get; private set; default = 0; }
        public Gtk.Stack stack { get; construct; }

        private string[] possible_icons = {
            "audio-volume-high-symbolic",
            "mail-unread-symbolic",
            "zoom-in-symbolic",
            "zoom-original-symbolic",
            "alarm-symbolic",
            "dialog-error-symbolic",
            "user-trash-symbolic",
            "security-low-symbolic",
            "dialog-warning-symbolic",
            "display-projector-symbolic"
        };

        construct {
            add_slide.begin ();

            listbox.row_selected.connect ((row) => {
                var r = row as SlideRow;
                stack.set_visible_child (r.widget);
            });
        }

        [GtkCallback]
        private void on_add_button_clicked () {
            add_slide.begin ();
        }

        private async void add_slide () {
            item_number++;

            var widget = new Adw.StatusPage () {
                title = @"This is page $item_number",
                icon_name = possible_icons[Random.int_range (0, possible_icons.length)]
            };

            var child = new SlideRow () {
                page = item_number,
                widget = widget
            };

            child.trash_request.connect (handle_trash_requests);

            listbox.append (child);
            stack.add_named (widget, @"$item_number");
        }

        private void handle_trash_requests (SlideRow row) {
            var row_n = row.page;
            message (row_n.to_string ());
            Gtk.ListBoxRow? next_row = listbox.get_row_at_index (row_n - 1);

            while (next_row != null) {
                var r = next_row as SlideRow;
                r.page = row_n - 1;
                row_n++;
                next_row = listbox.get_row_at_index (row_n - 1);
            }

            dispose_row.begin (row);
        }

        private async void dispose_row (SlideRow row) {
            stack.remove (row.widget);
            listbox.remove (row);
            row.dispose ();

            item_number--;
        }
    }
}
