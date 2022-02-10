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
        public Gdk.RGBA color;
        public List<Question> questions = new List<Question> ();
        private Xml.Doc* doc;

        public Quiz.from_file (string path) throws QuizError {
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

        private void retrieve_elements (Xml.Node* node) {
            assert (node->name == "quiz");

            for (Xml.Node* iter = node->children; iter != null; iter = iter->next) {
                if (iter->type == ELEMENT_NODE) {
                    switch (iter->name) {
                        case "color":
                            retrieve_color (iter);
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

        private void retrieve_color (Xml.Node* node) {
            assert (node->name == "color");

            var x = color.parse (node->get_content ());
            message (x.to_string ());
        }
    }
}
