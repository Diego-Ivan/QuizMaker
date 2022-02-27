/* Option.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Quizmaker.Core {
    public class Option : Object {
        public Xml.Node* node { get; set construct; }

        private string _name;
        public string name {
            get {
                return _name;
            }
            set {
                _name = value;
                node->set_content (value);
            }
        }

        public Option (Xml.Node* nod) {
            Object (
                node: nod
            );
            assert (node->name == "option" || node->name == ":option");

            if (node->type != TEXT_NODE) {
                for (Xml.Node* i = node->children; i != null; i = i->next) {
                    if (i->type == TEXT_NODE) {
                        node = i;
                    }
                }
            }
            _name = node->get_content ();
        }

        public void ask_deletion () {
            node->unlink ();
        }
    }
}
