/* QuestionList.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Quizmaker {
    [GtkTemplate (ui = "/io/github/diegoivanme/quizmaker/sidebar.ui")]
    public class QuestionList : Gtk.Box {
        [GtkChild] public unowned Gtk.ListBox listbox;
        public int item_number { get; private set; default = 0; }
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
                var r = row as QuestionRow;
            });
        }

        [GtkCallback]
        private void on_add_button_clicked () {
            add_slide.begin ();
        }

        private async void add_slide (Core.Question? q = new Core.Question ()) {
            item_number++;

            var child = new QuestionRow () {
                question = q
            };

            child.trash_request.connect (handle_trash_requests);

            listbox.append (child);
        }

        private void handle_trash_requests (QuestionRow row) {
            dispose_row (row);
        }

        private void dispose_row (QuestionRow row) {
            listbox.remove (row);
            row.dispose ();

            item_number--;
        }

        private async void delete_all_rows () {
            var n = item_number;
            for (int i = 0; i <= n; i++) {
                QuestionRow? row = listbox.get_row_at_index (0) as QuestionRow;
                dispose_row (row);
            }
        }
    }
}
