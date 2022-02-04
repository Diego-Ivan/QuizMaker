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
        public Array<Question> questions = new Array<Question> ();
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

            retrieve_questions (root);
        }

        ~Quiz () {
            delete doc;
        }

        private void retrieve_questions (Xml.Node* node) {
            assert (node->name == "quiz");

            for (Xml.Node* iter = node->children; iter != null; iter = iter->next) {
                if (iter->type == ELEMENT_NODE) {
                    if (iter->name == "color") {
                        retrieve_color (iter);
                    }

                    if (iter->name == "question") {
                        create_question (iter);
                    }
                }
            }
        }

        private void retrieve_color (Xml.Node* node) {
            assert (node->name == "color");

            var x = color.parse (node->get_content ());
            message (x.to_string ());
        }

        private void create_question (Xml.Node* node) {
            assert (node->name == "question");
            var question = new Question ();

            for (Xml.Node* i = node->children; i != null; i = i->next) {
                if (i->type == ELEMENT_NODE) {
                    switch (i->name) {
                        case "title":
                            question.title = i->get_content ();
                            break;

                        case "image":
                            question.image = i->get_content ();
                            break;

                        case "options":
                            retrieve_options (i, ref question);
                            break;
                    }
                }
            }
            questions.append_val (question);

            string output = "";
            output += "Question: %s\n".printf (question.title);
            output += "Image Path: %s\n".printf (question.image);
            output += "Options: \n";

            foreach (var option in question.options) {
                output += "\t%s\n".printf (option);
            }

            stdout.printf (output);
        }

        private void retrieve_options (Xml.Node* node, ref Question question) {
            assert (node->name == "options");

            for (Xml.Node* i = node->children; i != null; i = i-> next) {
                if (i->type == ELEMENT_NODE && i->name == "option") {

                    question.options.append (node->get_content ());

                    string? correct = node->get_prop ("correct");

                    if (correct == "true") {
                        question.right_answer = node->get_content ();
                    }
                }
            }
        }
    }
}
