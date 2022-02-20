/* Quiz.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Quizmaker.Core {
    public errordomain QuizError {
        FILE_NOT_FOUND,
        NO_ROOT_ELEMENT,
        NOT_QUIZ_FILE
    }

    public class Quiz : Object {
        public string title { get; set; }
        public string description { get; set; }
        public string file_location { get; set; }
        public Gdk.RGBA color { get; set; }

        public List<Question> questions = new List<Question> ();
        private Xml.Doc* doc;

        public Quiz.from_file (string path) throws QuizError {
            file_location = path;
            doc = Xml.Parser.parse_file (path);
            if (doc == null) {
                throw new QuizError.FILE_NOT_FOUND ("File %s is not accessible".printf (path));
            }

            Xml.Node* root = doc->get_root_element ();
            if (root == null) {
                throw new QuizError.NO_ROOT_ELEMENT ("No root found in the file");
            }

            if (root->name != "quiz") {
                throw new QuizError.NOT_QUIZ_FILE ("File parsed is not a Quizzek file");
            }

            retrieve_elements (root);
        }

        ~Quiz () {
            delete doc;
        }

        construct {
            color = { 0, 0, 0, 0 };
        }

        public void save () {
            doc->save_format_file (file_location, 1);
        }

        private void retrieve_elements (Xml.Node* node) {
            assert (node->name == "quiz");

            for (Xml.Node* iter = node->children; iter != null; iter = iter->next) {
                if (iter->type == ELEMENT_NODE) {
                    switch (iter->name) {
                        case "title":
                            title = get_node_content (iter, "title");
                            break;

                        case "description":
                            description = get_node_content (iter, "description");
                            break;

                        case "color":
                            color.parse (get_node_content (iter, "color"));
                            break;

                        case "question":
                            var question = new Question.from_xml (iter);
                            questions.append (question);
                            break;

                        default:
                            warning ("Unknown tag at %u : %s", iter->line, iter->name);
                            break;
                    }
                }
            }
        }

        private string? get_node_content (Xml.Node* node, string node_name) {
            assert (node->name == node_name);
            for (Xml.Node* i = node->children; i != null; i = i->next) {
                if (i->type == TEXT_NODE) {
                    return i->get_content ();
                }
            }

            return null;
        }
    }
}
