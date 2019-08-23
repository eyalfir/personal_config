
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

// ***** run specific apps on key

function focusMouse(win) {
  var frame = win.frame()
  Mouse.move({x: frame.x + frame.width / 2, y: frame.y + frame.height / 2})
}

function focus_window(app_name, window_perdicate, toLaunch) {
  var appToLaunch = toLaunch || app_name
  var winPredicate = window_perdicate || ( win => win.title().match(app_name) )
  var app = App.get(app_name);
  if ( app == undefined ) {
    if (App.launch(appToLaunch)) {
      Phoenix.notify('launching ' + app_name)
    } else {
      Phoenix.notify('app ' + app_name + ' not found')
    }
    return
  } else {
    //Phoenix.notify('found app');
    //Phoenix.notify(app.windows.length);
  }
  var filtered = app.windows().filter(winPredicate)
  var win = filtered.length > 0 ? filtered[0] : app.windows()[0]
  win.focus()
  focusMouse(win)
}

function focusOnGmail() {
  Task.run('~/personal_config/bin/goto_inbox.sh')
  focus_window('Google Chrome')
}



Key.on('b', window_mgmt_modifier, function() { focus_window('Google Chrome', function(win) { return win.title().match('Chrome'); } ) } )
Key.on('f', window_mgmt_modifier, function() { focus_window('Finder'); } )
Key.on('z', window_mgmt_modifier, function() { focus_window('zoom.us', function(win) { return win.title().match('Zoom Meeting ID') } ) } );
Key.on('c', window_mgmt_modifier, function() { focus_window('iTerm2', null, 'iterm') } )
Key.on('t', window_mgmt_modifier, function() { focus_window('Trello'); } )
Key.on('w', window_mgmt_modifier, function() { focus_window('WhatsApp'); } )
Key.on('g', window_mgmt_modifier, focusOnGmail)
Key.on('s', window_mgmt_modifier, function() { focus_window('Slack'); } )
Key.on('a', window_mgmt_modifier, function() { focus_window('Google Chrome', function(win) { return win.title().match('GCalendar'); } ) } )
// Key.on('n', window_mgmt_modifier, function() { focus('Desktop-Google-Keep-OSX'); } )
Key.on('n', window_mgmt_modifier, function() { focus_window('Google Keep'); } )

// **** special automation

Key.on('s', ['cmd', 'shift'], function() {Task.run('~/bin/stop_wifi_and_sleep.sh');});
Key.on('l', ['cmd', 'shift'], function() {Task.run('/System/Library/CoreServices/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine');});
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
