
// place focused window in a tile in current screen

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
Key.on('k', window_mgmt_modifier, function() { to_grid(1, 1, 0, 0, 1, 1);});
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

function focus(app_name) {
  var current = App.get(app_name);
  if ( current == undefined ) {
    App.launch(app_name);
  } else {
    current.focus();
  }
}

Key.on('b', window_mgmt_modifier, function() { focus('Google Chrome'); } )
Key.on('c', window_mgmt_modifier, function() { focus('iTerm2'); } )
Key.on('w', window_mgmt_modifier, function() { focus('ChitChat'); } )
Key.on('s', window_mgmt_modifier, function() { focus('Slack'); } )
Key.on('a', window_mgmt_modifier, function() { focus('Calendar'); } )

// **** special automation

Key.on('s', ['cmd', 'shift'], function() {Task.run('/Users/eyal/bin/stop_wifi_and_sleep.sh');});
Key.on('x', ['cmd', 'shift'], function() {Task.run('/Users/eyal/bin/start_wifi.sh');});
Key.on('l', ['cmd', 'shift'], function() {Task.run('/System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine');});
