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

                options_list.options = value.option_list;
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
    }
}
