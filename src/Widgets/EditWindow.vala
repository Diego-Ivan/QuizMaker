/* EditWindow.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Quizmaker {
    [GtkTemplate (ui = "/io/github/diegoivanme/quizmaker/editwindow.ui")]
    public class EditWindow : Gtk.Dialog {
        [GtkChild] unowned Gtk.Label title_label;
        [GtkChild] unowned OptionsList options_list;

        private Core.Question _question;
        public Core.Question question {
            get {
                return _question;
            }
            set construct {
                _question = value;
                title_label.label = value.title;

                for (int i = 0; i < value.options.length (); i++) {
                    string content = value.options.nth_data (i);
                    options_list.add_new_option (content);
                }
            }
        }

        public EditWindow (Core.Question q) {
            Object (
                question: q
            );
        }

        construct {
            use_header_bar = (int) true;
            destroy_with_parent = true;

            title = "";
        }

        public GLib.List get_options () {
            return options_list.get_options ();
        }
    }
}
