/* Options.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Quizmaker.Core {
    public errordomain OptionError {
        NON_VALID_ELEMENT
    }
    public class Options : Object {
        public Xml.Node* node { private get; protected set construct; }
        private List<Option> options = new List<Option> ();

        public uint length {
            get {
                return options.length ();
            }
        }
        public Option right_answer { get; set; }

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
            Xml.Ns* ns = new Xml.Ns (null, "", "");
            Xml.Node* new_node = node->new_child (ns, "option", "");
            new_node->set_name ("option");

            message ("Created new option node");
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
