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
        public string right_answer { private get; set; }

        public bool is_selected_right () {
            return selected_answer == right_answer ? true : false;
        }
    }
}
