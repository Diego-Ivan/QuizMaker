/* Question.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Quizmaker.Core {
    public class Question : Object {
        public string title { get; set; default = ""; }
        public string image { get; set; default = ""; }
        public Options option_list { get; set; }

        public string selected_answer;
        public string right_answer { get; set; }

        public uint n_options {
            get {
                return option_list.length;
            }
        }

        public bool is_selected_right () {
            return selected_answer == right_answer ? true : false;
        }

        public Question.from_xml (Xml.Node* node) {
            for (Xml.Node* i = node->children; i != null; i = i->next) {
                if (i->type == ELEMENT_NODE) {
                    switch (i->name) {
                        case "title":
                            title = i->get_content ();
                            break;

                        case "image":
                            image = i->get_content ();
                            break;

                        case "options":
                            option_list = new Options.from_xml (i);
                            break;
                    }
                }
            }
        }
    }
}
