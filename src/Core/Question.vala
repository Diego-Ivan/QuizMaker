/* Question.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Quizmaker.Core {
    public class Question : Object {
        public string title { get; set; }
        public string image { get; set; }
        public List<string> options = new List<string> ();
        public string selected_answer;
        private string right_answer { get; set; }

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
                            retrieve_options (i);
                            break;
                    }
                }
            }
        }

        private void retrieve_options (Xml.Node* node) {
            assert (node->name == "options");

            for (Xml.Node* i = node->children; i != null; i = i-> next) {
                if (i->type == ELEMENT_NODE && i->name == "option") {

                    options.append (node->get_content ());

                    string? correct = node->get_prop ("correct");

                    if (correct == "true") {
                        right_answer = node->get_content ();
                    }
                }
            }
        }
    }
}
