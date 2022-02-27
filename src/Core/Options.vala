/* Options.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Quizmaker.Core {
    public class Options : Object {
        public Xml.Node* node { private get; protected set construct; }
        private List<Option> options = new List<Option> ();

        public uint length {
            get {
                return options.length ();
            }
        }

        private Xml.Node* r_answer_node;
        private Option _right_answer;
        public Option right_answer {
            get {
                return _right_answer;
            }
            set {
                _right_answer = value;
                r_answer_node = value.node;

                if (r_answer_node->get_prop ("correct") == null)
                    r_answer_node->new_prop ("correct", "true");
            }
        }

        public Options.from_xml (Xml.Node* n) {
            assert (n->name == "options");
            Object (
                node: n
            );

            for (Xml.Node* i = node->children; i != null; i = i->next) {
                Option option = null;
                if (i->type == ELEMENT_NODE) {
                    option = new Option (i);
                    options.append (option);
                }

                string? correct = i->get_prop ("correct");
                if ((correct != null) && (correct == "true")) {
                    right_answer = option;
                }
            }
        }

        public Option add_new_option () {
            Xml.Node* new_node = node->new_child (null, "option", "");
            new_node->set_name ("option");

            var n_option = new Option (new_node);
            options.append (n_option);

            return n_option;
        }

        public Option get_option_at (uint x) {
            return options.nth_data (x);
        }

        public void delete_option (Option opt) {
            opt.ask_deletion ();
            options.remove (opt);
        }
    }
}
