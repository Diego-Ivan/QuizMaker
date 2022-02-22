/* QuestionRow.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Quizmaker {
    [GtkTemplate (ui = "/io/github/diegoivanme/quizmaker/questionrow.ui")]
    public class QuestionRow : Gtk.ListBoxRow {
        /* Fields */
        [GtkChild] unowned Gtk.EditableLabel title_label;
        [GtkChild] unowned Gtk.Label options_label;

        /* Properties */
        public Core.Question _question;
        public Core.Question question {
            get {
                return _question;
            }
            set {
                _question = value;
                title_label.text = value.title;
                options_label.label = _("%u options".printf (value.n_options));
            }
        }

        /* Signals */
        public signal void trash_request (QuestionRow r);

        construct {
            selectable = false;

            /*
             * Trick to get the label from a GtkEditableLabel so we're able to
             * wrap it. Useful for large questions. I hope I can find a better
             * way of doing this, other than implementing the widget myself.
             */
            var label = title_label.get_first_child ().get_first_child () as Gtk.Label;
            label.wrap = true;

            title_label.changed.connect (() => {
                question.title = title_label.text;
            });
        }

        [GtkCallback]
        private void on_trash_button_clicked () {
            trash_request (this);
        }

        [GtkCallback]
        public void on_edit_mode_activated () {
            var dialog = new EditWindow (question) {
                transient_for = get_native () as Gtk.Window
            };

            dialog.response.connect ((res) => {
                if (res == Gtk.ResponseType.OK) {
                    options_label.label = _("%u options".printf (question.n_options));
                }
                dialog.close ();
            });

            dialog.show ();
        }
    }
}
