/* QuestionPage.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Quizmaker {
    [GtkTemplate (ui = "/io/github/diegoivanme/quizmaker/questionpage.ui")]
    public class QuestionPage : Gtk.Box {
        [GtkChild] private unowned Gtk.Label title_label;
        [GtkChild] private unowned Gtk.Label image;
        [GtkChild] private unowned Gtk.Box options_box;

        private Core.Question question_;
        public Core.Question question {
            get {
                return question_;
            }
            set construct {
                question_ = value;
                title_label.label = value.title;
                image.label = value.image;

                value.options.foreach ((o) => {
                    string str = o;
                    message ("%s : %s", str, value.right_answer);
                    if (str == value.right_answer) {
                        str += " : Correct";
                    }
                    options_box.append (new Gtk.Label (str));
                });
            }
        }

        public QuestionPage (Core.Question _question) {
            Object (
                question: _question
            );
        }
    }
}
