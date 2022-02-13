/* Sidebar.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Quizmaker {
    [GtkTemplate (ui = "/io/github/diegoivanme/quizmaker/sidebar.ui")]
    public class Sidebar : Gtk.Box {
        [GtkChild] public unowned Gtk.ListBox listbox;
        public int item_number { get; private set; default = 0; }
        public Gtk.Stack stack { get; construct; }
        private Core.Quiz quiz_;
        public Core.Quiz quiz {
            get {
                return quiz_;
            }
            set {
                quiz_ = value;
                delete_all_rows.begin (() => {
                    foreach (var q in value.questions) {
                        add_slide.begin (q);
                    }
                });
            }
        }

        construct {
            listbox.row_selected.connect ((row) => {
                var r = row as SlideRow;
                stack.set_visible_child (r.widget);
            });
        }

        [GtkCallback]
        private void on_add_button_clicked () {
            add_slide.begin ();
        }

        private async void add_slide (Core.Question? q = new Core.Question ()) {
            item_number++;

            var widget = new QuestionPage (q);
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
            Gtk.ListBoxRow? next_row = listbox.get_row_at_index (row_n - 1);

            while (next_row != null) {
                var r = next_row as SlideRow;
                r.page = row_n - 1;
                row_n++;
                next_row = listbox.get_row_at_index (row_n - 1);
            }

            dispose_row (row);
        }

        private void dispose_row (SlideRow row) {
            stack.remove (row.widget);
            listbox.remove (row);
            row.dispose ();

            item_number--;
        }

        private async void delete_all_rows () {
            var n = item_number;
            for (int i = 0; i <= n; i++) {
                SlideRow? row = listbox.get_row_at_index (0) as SlideRow;
                dispose_row (row);
            }
        }
    }
}
