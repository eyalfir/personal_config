
// ***** place focused window in a tile in current screen

function get_grid_rect(screen, grid_rows, grid_cols, to_row, to_col, rows, cols) {
  var screen_frame = screen.flippedVisibleFrame()
  var row_height = screen_frame.height / grid_rows
  var col_width = screen_frame.width / grid_cols
  var frame = {x:0, y:0, height:0, width:0}
  frame.y = screen_frame.y + to_row * row_height
  frame.x = screen_frame.x + to_col * col_width
  frame.height = rows * row_height
  frame.width = cols * col_width
  return frame
}

function to_grid(grid_rows, grid_cols, to_row, to_col, rows, cols) {
  var win = Window.focused();
  var frame = win.frame();
  frame = get_grid_rect(win.screen(), grid_rows, grid_cols, to_row, to_col, rows, cols)
  win.setFrame(frame);
}

var window_mgmt_modifier = ['ctrl', 'cmd']
Key.on('k', window_mgmt_modifier, function() { to_grid(1, 1, 0, 0, 1, 1);});
Key.on('h', window_mgmt_modifier, function() { to_grid(1, 2, 0, 0, 1, 1);});
Key.on('l', window_mgmt_modifier, function() { to_grid(1, 2, 0, 1, 1, 1);});
Key.on('i', window_mgmt_modifier, function() { to_grid(2, 1, 0, 0, 1, 1);});
Key.on(',', window_mgmt_modifier, function() { to_grid(2, 1, 1, 0, 1, 1);});
Key.on('u', window_mgmt_modifier, function() { to_grid(2, 2, 0, 0, 1, 1);});
Key.on('o', window_mgmt_modifier, function() { to_grid(2, 2, 0, 1, 1, 1);});
Key.on('m', window_mgmt_modifier, function() { to_grid(2, 2, 1, 0, 1, 1);});
Key.on('.', window_mgmt_modifier, function() { to_grid(2, 2, 1, 1, 1, 1);});
Key.on('p', window_mgmt_modifier, function() { to_grid(3, 1, 0, 0, 1, 1);});
Key.on(';', window_mgmt_modifier, function() { to_grid(3, 1, 1, 0, 1, 1);});
Key.on('/', window_mgmt_modifier, function() { to_grid(3, 1, 2, 0, 1, 1);});

// ***** move current window between screens

function rotateMonitors(offset) {
  var win = Window.focused();
  var currentScreen = win.screen();
  var all_screens = _.sortBy(Screen.all(), function (a) { return a.frame().x; } );
  var current_idx = _(all_screens).indexOf(currentScreen);
  var new_idx = (current_idx + offset + all_screens.length) % (all_screens.length);
  var new_screen = all_screens[new_idx];
  win.setFrame(new_screen.flippedVisibleFrame());
}


Key.on('l', ['ctrl', 'cmd', 'shift'], function() {rotateMonitors(1);} );
Key.on('h', ['ctrl', 'cmd', 'shift'], function() {rotateMonitors(-1);} );

function focusMouse(win) {
  var frame = win.frame()
  Mouse.move({x: frame.x + frame.width / 2, y: frame.y + frame.height / 2})
}

// ***** run specific apps on key

function focus(app_name) {
  var current = App.get(app_name);
  if ( current == undefined ) {
    Phoenix.notify('app ' + app_name + ' not found')
    current = App.launch(app_name);
  } else {
    current.mainWindow().focus();
  }
  focusMouse(current.mainWindow())
}

function focus_airdroid() {
  var app = App.get('AirDroid');
  if ( app == undefined ) {
    app = App.launch('AirDroid');
  } else {

    var windows = app.windows()
    var found = false
    //fullscreen = app.Windows().filter(function(w)
    //app.windows().forEach(function (win) { Phoenix.notify(win.title())})
    for (i = 0; i < app.windows().length; i++) {
	    //Phoenix.notify('- ' + app.windows()[i].title() + ' - ' + i)
	    if ( app.windows()[i].title() == '' ) {
		    app.windows()[i].focus()
		    found = true
	    }
    }
    if ( ! found ) {
	    app.windows()[0].focus()
    }
  }
}

Key.on('b', window_mgmt_modifier, function() { focus('Google Chrome'); } )
Key.on('c', window_mgmt_modifier, function() { focus('iTerm2'); } )
Key.on('w', window_mgmt_modifier, function() { focus('ChitChat'); } )
Key.on('s', window_mgmt_modifier, function() { focus('Slack'); } )
Key.on('a', window_mgmt_modifier, function() { focus('Calendar'); } )
Key.on('r', window_mgmt_modifier, function() { focus('Microsoft Outlook'); } )
Key.on('v', window_mgmt_modifier, focus_airdroid)
Key.on('n', window_mgmt_modifier, function() { focus('Desktop-Google-Keep-OSX'); } )

// **** special automation

Key.on('s', ['cmd', 'shift'], function() {Task.run('~/bin/stop_wifi_and_sleep.sh');});
Key.on('x', ['cmd', 'shift'], function() {Task.run('~/bin/start_wifi.sh');});
Key.on('l', ['cmd', 'shift'], function() {Task.run('/System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine');});
Key.on('c', ['cmd', 'shift'], function() {Task.run('~/personal_config/bin/close_all_notifications.sh');});


// ***** save and restore full window session

var last_session = {last:[]};


function store_last_session() {
  var lasti = [];
  Window.all().forEach(function (win) {lasti.push({w: win, r: win.frame()});});
  last_session.last = lasti;
  Phoenix.notify('Session saved');
}

function restore_last_session() {
  for (i = 0; i < last_session.last.length; i++) {
    last_session.last[i].w.setFrame(last_session.last[i].r);
  }
}

Key.on('9', ['ctrl', 'cmd', 'shift'], function() { store_last_session(); });
Key.on('9', window_mgmt_modifier, function() {restore_last_session(); });

// ***** bring a specific window to focus on main screen

var main_screen = { main: undefined };
var in_main_focus = {}

function set_main_screen() {
  //main_screen.main = Window.focused().screen()
  Storage.set('main_screen_frame', Window.focused().screen().flippedVisibleFrame())
  Phoenix.notify('main screen set')
}

function restore_focused_window() {
  if ( 'window' in in_main_focus ) {
    in_main_focus['window'].setFrame(in_main_focus['frame'])
    delete in_main_focus['window']
    delete in_main_focus['frame']
  }
}

function main_screen_focus_window(win) {
  in_main_focus['window'] = win
  in_main_focus['frame'] = win.frame()
  win.setFrame(Storage.get('main_screen_frame'))
}

function focus_to_main_screen() {
  //var frame = main_screen.main.flippedVisibleFrame();
  var current_win = Window.focused()
  if ( ( 'window' in in_main_focus ) && ( in_main_focus['window'].app().name() == current_win.app().name()) ) {
	  restore_focused_window()
	  return
  }
  restore_focused_window()
  main_screen_focus_window(current_win)
}

Key.on('f', ['ctrl', 'cmd', 'shift'], function() { set_main_screen(); });
Key.on('f', window_mgmt_modifier, function() { focus_to_main_screen(); });

// ******* store session with app names and exact frames

function restore_app_session() {
  session = Storage.get('last_session')
  for (app_name in session) {
    focus(app_name);
    var app = App.get(app_name);
    var win = app.mainWindow();
    win.setFrame(session[app_name]);
  }
}

function get_app_state(win) {
	var app_name = win.app().name();
	return {name: app_name, frame: win.frame()};
}
function create_app_session() {
  session = {}
  var all_apps = App.all()
  for (i = 0; i < all_apps.length; i++) {
	  app = all_apps[i]
	  if (app.mainWindow().frame().width == 0) continue;
	  session[app.name()] = app.mainWindow().frame()
  }
  Storage.set('last_session', session)
  Phoenix.notify('app session saved')
  Phoenix.log('app session saved')
  Phoenix.log(JSON.stringify(session))
}
	

//Key.on('r', window_mgmt_modifier, restore_app_session);
Key.on('r', ['ctrl', 'cmd', 'shift'], create_app_session);
//Key.on('r', window_mgmt_modifier, function() { Phoenix.log(JSON.stringify(create_app_session(App.get('iTerm2')))); } );
//Key.on('r', window_mgmt_modifier, function() { Phoenix.log(JSON.stringify(get_app_state(App.get('iTerm2').mainWindow()))); } );
//Key.on('r', window_mgmt_modifier, function() { Phoenix.log(JSON.stringify(create_app_session()))});
