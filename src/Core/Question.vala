/* Question.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Quizmaker.Core {
    public class Question : Object {
        public Xml.Node* node { get; protected set construct; }

        private Xml.Node* title_node;
        private string _title = "";
        public string title {
            get {
                return _title;
            }
            set {
                _title = value;
                title_node->set_content (value);
            }
        }

        private Xml.Node* image_node;
        private string _image = "";
        public string image {
            get {
                return _image;
            }
            set {
                _image = value;
                image_node->set_content (value);
            }
        }

        public Options option_list { get; set; }

        public uint n_options {
            get {
                return option_list.length;
            }
        }

        public Question (Xml.Node* n) {
            Object (
                node: n
            );

            title_node = node->new_text_child (null, "title", "");
            image_node = node->new_text_child (null, "image", "");

            Xml.Node* option_node = node->new_text_child (null, "options", "");
            option_list = new Options.from_xml (option_node);

            message ("Creating Question");
        }

        public Question.from_xml (Xml.Node* n) {
            assert (n->name == "question");
            Object (
                node: n
            );

            for (Xml.Node* i = node->children; i != null; i = i->next) {
                if (i->type == ELEMENT_NODE) {
                    switch (i->name) {
                        case "title":
                            title_node = get_content_node (i, "title");
                            _title = title_node->get_content ();
                            break;

                        case "image":
                            image_node = get_content_node (i, "image");
                            _image = image_node->get_content ();
                            break;

                        case "options":
                            option_list = new Options.from_xml (i);
                            break;
                    }
                }
            }
        }

        public void ask_deletion () {
            node->unlink ();
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
