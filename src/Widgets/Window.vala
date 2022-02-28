/* window.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Quizmaker {
	[GtkTemplate (ui = "/io/github/diegoivanme/quizmaker/window.ui")]
	public class Window : Adw.ApplicationWindow {
	    [GtkChild] unowned Adw.WindowTitle title_widget;
	    [GtkChild] unowned ColorButton color_button;
	    [GtkChild] unowned Gtk.Label title_label;
	    [GtkChild] unowned Gtk.Label description_label;
	    [GtkChild] unowned QuestionList list;
	    [GtkChild] unowned Gtk.Switch randomize_switch;
	    [GtkChild] unowned Gtk.ProgressBar progress_bar;

	    private const ActionEntry[] WIN_ENTRIES = {
	        { "save", save_action }
	    };

	    private Core.Quiz _quiz;
	    public Core.Quiz quiz {
	        get {
	            return _quiz;
	        }
	        set {
	            _quiz = value;
	            color_button.rgba = value.color;
	            title_label.label = value.title;
	            description_label.label = value.description;
	            randomize_switch.active = value.randomize;
	            list.quiz = value;
	        }
	    }

		public Window (Gtk.Application app) {
			Object (
			    application: app
			);

			application.set_accels_for_action ("win.save", { "<Ctrl>S" });
			quiz = new Core.Quiz ();

			randomize_switch.notify["active"].connect (() => {
			    quiz.randomize = randomize_switch.active;
			});
		}

		construct {
		    color_button.color_activated.connect ((c) => {
		        quiz.color = c;
		    });

		    var action_group = new SimpleActionGroup ();
		    action_group.add_action_entries (WIN_ENTRIES, this);
		    insert_action_group ("win", action_group);
		}

		private void save_action () {
		    var callback_target = new Adw.CallbackAnimationTarget (progress_bar_pulse_callback);

		    var animation = new Adw.TimedAnimation (progress_bar,
		        0, 1, 500,
		        callback_target
		    );
		    animation.easing = EASE_IN_OUT_SINE;

		    progress_bar.opacity = 1;

		    animation.play ();

		    if (quiz.file_location == "") {
		        var filters = new Gtk.FileFilter () {
		            name = "XML"
		        };

		        filters.add_suffix ("quizzek");
		        filters.add_suffix ("xml");

		        var filechooser = new Gtk.FileChooserNative (
		            null,
		            this,
		            SAVE,
		            null,
		            null
		        );
		        filechooser.add_filter (filters);

		        filechooser.response.connect ((res) => {
		            if (res == Gtk.ResponseType.ACCEPT) {
		                var path = filechooser.get_file ().get_path ();
		                quiz.file_location = path;
                        quiz.save ();
		            }
		            else {
		                warning ("Save to fail quiz %s: No location chosen", quiz.title);
		            }
		        });

		        filechooser.show ();
		    }
		    else {
		        quiz.save ();
		    }

	        animation.done.connect (() => {
	            progress_bar_fadeout ();
	        });
		}

		[GtkCallback]
		private void open_file_request () {
		    var filters = new Gtk.FileFilter () {
                name = "XML"
            };

            filters.add_suffix ("xml");
            filters.add_suffix ("quiz");

            var filechooser = new Gtk.FileChooserNative (
                null,
                this,
                OPEN,
                null,
                null
            );
            filechooser.add_filter (filters);

            filechooser.response.connect ((res) => {
                if (res == Gtk.ResponseType.ACCEPT) {
                    var path = filechooser.get_file ().get_path ();
                    title_widget.subtitle = filechooser.get_file ().get_basename ();
                    try {
                        quiz = new Core.Quiz.from_file (path);
                    }
                    catch (Error e) {
                        critical (e.message);
                    }
                }
            });

            filechooser.show ();
		}

		private void progress_bar_fadeout () {
		    var target_callback = new Adw.CallbackAnimationTarget (progress_bar_fadeout_callback);

		    var animation = new Adw.TimedAnimation (progress_bar,
		        0, 1, 400,
		        target_callback
		    );
		    animation.easing = EASE_IN_OUT_CUBIC;
		    animation.play ();
		}

		public void progress_bar_fadeout_callback (double value) {
		    if (value == 0)
		        progress_bar.fraction = 0;
		    else
		        progress_bar.opacity = 1 - value;
		}

		public void progress_bar_pulse_callback (double value) {
		    progress_bar.fraction = value;
		}
	}
}
