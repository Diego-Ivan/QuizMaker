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

        private Core.Option _option;
        public Core.Option option {
            get {
                return _option;
            }
            set construct {
                _option = value;
                name_label.text = value.name;
            }
        }

        public signal void trash_request (OptionRow o);

        public OptionRow (Core.Option option_) {
            Object (
                option: option_
            );

            name_label.changed.connect (() => {
                option.name = name_label.text;
            });
        }

        [GtkCallback]
        private void on_trash_button_clicked () {
            trash_request (this);
        }
    }
}
