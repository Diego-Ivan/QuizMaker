/* OptionRow.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Quizmaker {
    [GtkTemplate (ui = "/io/github/diegoivanme/quizmaker/optionrow.ui")]
    public class OptionRow : Gtk.ListBoxRow {
        [GtkChild] public unowned Gtk.CheckButton checkbutton;
        [GtkChild] unowned Gtk.EditableLabel name_label;

        public string content {
            get {
                return name_label.text;
            }
            set construct {
                name_label.text = value;
            }
        }

        public signal void trash_request (OptionRow o);

        public OptionRow (string str) {
            Object (
                content: str
            );
        }

        [GtkCallback]
        private void on_trash_button_clicked () {
            trash_request (this);
        }
    }
}
