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
        private Xml.Node* node;
        public string file_location { get; set; default = ""; }

        private Xml.Node* title_node;
        private string _title;
        public string title {
            get {
                return _title;
            }
            set {
                _title = value;
                title_node->set_content (value);
            }
        }

        private Xml.Node* description_node;
        private string _description;
        public string description {
            get {
                return _description;
            }
            set {
                _description = value;
                description_node->set_content (value);
            }
        }

        private Xml.Node* color_node;
        private Gdk.RGBA _color;
        public Gdk.RGBA color {
            get {
                return _color;
            }
            set {
                _color = value;
                color_node->set_content (value.to_string ());
            }
        }

        private List<Question> questions = new List<Question> ();
        public uint length {
            get {
                return questions.length ();
            }
        }

        private Xml.Doc* doc;

        public Quiz () {
            doc = new Xml.Doc ("1.0");

            node = new Xml.Node (null, "quiz");

            doc->set_root_element (node);

            Xml.Node* comment_node = new Xml.Node.comment (@"Generated using $(Config.PRETTY_NAME) $(Config.VERSION)");
            node->add_child (comment_node);

            title_node = node->new_text_child (null, "title", "");
            description_node = node->new_text_child (null, "description", "");
            color_node = node->new_text_child (null, "color", "rgba(0,0,0,1)");
        }

        public Quiz.from_file (string path) throws QuizError {
            file_location = path;
            doc = Xml.Parser.parse_file (path);
            if (doc == null) {
                throw new QuizError.FILE_NOT_FOUND ("File %s is not accessible".printf (path));
            }

            node = doc->get_root_element ();
            if (node == null) {
                throw new QuizError.NO_ROOT_ELEMENT ("No root found in the file");
            }

            if (node->name != "quiz") {
                throw new QuizError.NOT_QUIZ_FILE ("File parsed is not a Quizzek file");
            }

            retrieve_elements ();
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

        public Question get_question_at (uint x) {
            return questions.nth_data (x);
        }

        public Question add_question () {
            Xml.Node* n = node->new_text_child (null, "question", "");

            var question = new Question (n);
            questions.append (question);

            return question;
        }

        public void delete_question (Question q) {
            q.ask_deletion ();
            questions.remove (q);
        }

        private void retrieve_elements () {
            assert (node->name == "quiz" || node->name == ":quiz");

            for (Xml.Node* iter = node->children; iter != null; iter = iter->next) {
                if (iter->type == ELEMENT_NODE) {
                    switch (iter->name) {
                        case "title":
                            title_node = get_content_node (iter, "title");
                            _title = title_node->get_content ();
                            break;

                        case "description":
                            description_node = get_content_node (iter, "description");
                            _description = description_node->get_content ();
                            break;

                        case "color":
                            color_node = get_content_node (iter, "color");
                            _color.parse (color_node->get_content ());
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

        private Xml.Node* get_content_node (Xml.Node* n, string node_name) {
            assert (n->name == node_name);

            for (Xml.Node* i = n->children; i != null; i = i->next) {
                if (i->type == TEXT_NODE) {
                    return i;
                }
            }

            return n;
        }
    }
}
