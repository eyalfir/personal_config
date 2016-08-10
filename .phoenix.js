// Configuration for https://github.com/sdegutis/Phoenix

// FUN!

lookOfDisapproval="ಠ_ಠ";
rageOfDongers="ヽ༼ ಠ益ಠ ༽ﾉ";
whyLook="ლ(ಠ_ಠლ)";

// Adjust window size

function get_grid_rect(screen, grid_rows, grid_cols, to_row, to_col, rows, cols) {
  var screen_frame = screen.frameWithoutDockOrMenu()
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
  var win = Window.focusedWindow();
  var frame = win.frame();
  frame = get_grid_rect(win.screen(), grid_rows, grid_cols, to_row, to_col, rows, cols)
  win.setFrame(frame);
}

// Move windows between monitors

function moveToScreen(win, screen) {
  if (!screen) {
    return;
  }

  var frame = win.frame();
  var oldScreenRect = win.screen().frameWithoutDockOrMenu();
  var newScreenRect = screen.frameWithoutDockOrMenu();

  var xRatio = newScreenRect.width / oldScreenRect.width;
  var yRatio = newScreenRect.height / oldScreenRect.height;

  win.setFrame({
    x: (Math.round(frame.x - oldScreenRect.x) * xRatio) + newScreenRect.x,
    y: (Math.round(frame.y - oldScreenRect.y) * yRatio) + newScreenRect.y,
    width: Math.round(frame.width * xRatio),
    height: Math.round(frame.height * yRatio)
  });
}

function circularLookup(array, index) {
  if (index < 0)
    return array[array.length + (index % array.length)];
  return array[index % array.length];
}

function rotateMonitors(offset) {
  var win = Window.focusedWindow();
  var currentScreen = win.screen();
  var screens = [currentScreen];
  for (var x = currentScreen.previousScreen(); x != win.screen(); x = x.previousScreen()) {
    screens.push(x);
  }

  screens = _(screens).sortBy(function(s) { return s.frameWithoutDockOrMenu().x; });
  var currentIndex = _(screens).indexOf(currentScreen);
  moveToScreen(win, circularLookup(screens, currentIndex + offset));
}

function leftOneMonitor() {
  rotateMonitors(-1);
}

function rightOneMonitor() {
  rotateMonitors(1);
}


// Start/select apps
App.allWithTitle = function( title ) {
  return _(this.runningApps()).filter( function( app ) {
    if (app.title() === title) {
      return true;
    }
  });
};

function launch_app(title, timeout) {
    api.alert(rageOfDongers + " Starting " + title)
    api.launch(title)
    return
}

function focus(app_name, on_empty_launch, filter) {
  var apps = App.allWithTitle(app_name);
  if (_.isEmpty(apps)) {
    if (on_empty_launch === true) {
      launch_app(app_name)
    }
    else {
      api.alert('couldnt find app ' + app_name)
      return
    }
  }

  var windows = _.chain(apps)
    .map(function(x) { return x.allWindows(); })
    .flatten()
    .value();
  if (filter) {
    windows = windows.filter(filter)
  }
  if (_.isEmpty(windows)) {
    if (on_empty_launch === true) {
      launch_app(app_name)
    }
    else {
      api.alert('no such windows')
      return
    }
  }
  else {
    windows.forEach(real_focus)
  }
};

function real_focus(win) {
  if (win.isWindowMinimized()) {
    win.unMinimize()
  }
  my_focus_window(win)
}

function arrange_windows(pattern, frame) {
  Window.allWindows().filter(function(win) { return win.title().match(pattern);}).forEach(function (win) {
    real_focus(win)
    if (frame != undefined) {
      win.setFrame(frame)
    }
  })
}


function arrange_app(title, frame) {
  var apps = App.allWithTitle(title)
  api.alert('here')
  if (_.isEmpty(apps)) {
    api.alert('cannot find it...')
    return false;
  }
  var windows = _.chain(apps)
    .map(function(x) { return x.allWindows(); })
    .flatten()
    .value();
  windows.forEach(function(win) {
    if (win.isWindowMinimized()) {
      win.unMinimize()
    }
    win.setFrame(frame)
  })
}


// arrangements

function arrange(screen, rows, cols) {
  for (var i = 0; i < arguments.length - 3; i++) {
    var this_arrange = arguments[i + 3]
    if (this_arrange === null) { continue;}
    var this_row = Math.trunc(i / cols)
    var this_col = Math.trunc(i % cols)
    var frame = get_grid_rect(screen, rows, cols, this_row, this_col, this_arrange.rows, this_arrange.cols)
    arrange_windows(this_arrange.name, frame)
  }
}

function alert_window_name() {
  var win = Window.focusedWindow()
  api.alert(win.title())
}

function current_screen() {
  var win = Window.focusedWindow()
  return win.screen()
}

function my_focus_window(win) {
  win.focusWindow()
  var frame = win.frame();
  MousePosition.restore({x: frame.x + (frame.width / 2), y: frame.y + (frame.height / 2)});
}


var window_mgmt_modifier = ['ctrl', 'cmd']

api.bind('l', ['ctrl', 'cmd', 'shift'], rightOneMonitor);
api.bind('h', ['ctrl', 'cmd', 'shift'], leftOneMonitor);

var window_aliases = {};

var last_session = {last:[]};


function store_last_session() {
  var lasti = [];
  Window.allWindows().forEach(function (win) {lasti.push({w: win, r: win.frame()});});
  last_session.last = lasti;
  api.alert('Session saved');
}

function restore_last_session() {
  for (i = 0; i < last_session.last.length; i++) {
    last_session.last[i].w.setFrame(last_session.last[i].r);
  }
}

api.bind('1', ['ctrl', 'cmd', 'shift'], function() { window_aliases['1'] = Window.focusedWindow(); api.alert('saved alias'); });
api.bind('2', ['ctrl', 'cmd', 'shift'], function() { window_aliases['2'] = Window.focusedWindow(); api.alert('saved alias'); });
api.bind('3', ['ctrl', 'cmd', 'shift'], function() { window_aliases['3'] = Window.focusedWindow(); api.alert('saved alias'); });
api.bind('4', ['ctrl', 'cmd', 'shift'], function() { window_aliases['4'] = Window.focusedWindow(); api.alert('saved alias'); });
api.bind('5', ['ctrl', 'cmd', 'shift'], function() { window_aliases['5'] = Window.focusedWindow(); api.alert('saved alias'); });
api.bind('6', ['ctrl', 'cmd', 'shift'], function() { window_aliases['6'] = Window.focusedWindow(); api.alert('saved alias'); });
api.bind('7', ['ctrl', 'cmd', 'shift'], function() { window_aliases['7'] = Window.focusedWindow(); api.alert('saved alias'); });
api.bind('8', ['ctrl', 'cmd', 'shift'], function() { window_aliases['8'] = Window.focusedWindow(); api.alert('saved alias'); });
api.bind('m', ['ctrl', 'cmd', 'shift'], function() { var win = Window.focusedWindow(); win.minimize() });
//api.bind('m', ['ctrl', 'cmd', 'shift'], function() { var win = Window.focusedWindow(); win.setFrame({x: 1, y: 1, width: 1, height: 1})});
api.bind('9', ['ctrl', 'cmd', 'shift'], function() { store_last_session(); });
api.bind('1', window_mgmt_modifier, function() {my_focus_window(window_aliases['1']); });
api.bind('2', window_mgmt_modifier, function() {my_focus_window(window_aliases['2']); });
api.bind('3', window_mgmt_modifier, function() {my_focus_window(window_aliases['3']); });
api.bind('4', window_mgmt_modifier, function() {my_focus_window(window_aliases['4']); });
api.bind('5', window_mgmt_modifier, function() {my_focus_window(window_aliases['5']); });
api.bind('6', window_mgmt_modifier, function() {my_focus_window(window_aliases['6']); });
api.bind('7', window_mgmt_modifier, function() {my_focus_window(window_aliases['7']); });
api.bind('8', window_mgmt_modifier, function() {my_focus_window(window_aliases['8']); });
api.bind('9', window_mgmt_modifier, function() {restore_last_session(); });

// api.bind('6', window_mgmt_modifier, function() { arrange(current_screen(), 1, 2, {name:'WhatsApp', rows:1, cols:1}, {name:'Slack', rows:1, cols:1})})
/* api.bind('1', window_mgmt_modifier, function() { arrange(current_screen(), 2, 2, 
  {name:'lightcyber.com', rows:2, cols:1},
  {name:'Slack', rows:1, cols:1},
  null,
  {name:'WhatsApp', rows:1, cols:1}
)}) */
api.bind('0', window_mgmt_modifier, alert_window_name)
api.bind('h', window_mgmt_modifier, function() { to_grid(1, 2, 0, 0, 1, 1);});
api.bind('l', window_mgmt_modifier, function() { to_grid(1, 2, 0, 1, 1, 1);});
api.bind('k', window_mgmt_modifier, function() { to_grid(1, 1, 0, 0, 1, 1);});
api.bind('i', window_mgmt_modifier, function() { to_grid(2, 1, 0, 0, 1, 1);});
api.bind(',', window_mgmt_modifier, function() { to_grid(2, 1, 1, 0, 1, 1);});
api.bind('u', window_mgmt_modifier, function() { to_grid(2, 2, 0, 0, 1, 1);});
api.bind('o', window_mgmt_modifier, function() { to_grid(2, 2, 0, 1, 1, 1);});
api.bind('m', window_mgmt_modifier, function() { to_grid(2, 2, 1, 0, 1, 1);});
api.bind('.', window_mgmt_modifier, function() { to_grid(2, 2, 1, 1, 1, 1);});
api.bind('p', window_mgmt_modifier, function() { to_grid(3, 1, 0, 0, 1, 1);});
api.bind(';', window_mgmt_modifier, function() { to_grid(3, 1, 1, 0, 1, 1);});
api.bind('/', window_mgmt_modifier, function() { to_grid(3, 1, 2, 0, 1, 1);});

//api.bind('s', ['cmd', 'ctrl'], function() {api.alert('blue', 1000);});
api.bind('s', ['cmd', 'shift'], function() {api.runCommand('/Users/eyal/bin/stop_wifi_and_sleep.sh');});
api.bind('x', ['cmd', 'shift'], function() {api.runCommand('/Users/eyal/bin/start_wifi.sh');});
api.bind('l', ['cmd', 'shift'], function() {api.runCommand('/System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine');});


api.bind('c', window_mgmt_modifier, function() {focus('iTerm', true);});
api.bind('a', window_mgmt_modifier, function() {focus('Calendar', true);});
api.bind('b', window_mgmt_modifier , function() {focus('Google Chrome', false, function (win) {return !(win.title().match('WhatsApp'));});});
api.bind('s', window_mgmt_modifier , function() {focus('Slack', true);});
//api.bind('w', window_mgmt_modifier , function() {arrange_windows('WhatsApp');});
api.bind('w', window_mgmt_modifier , function() {focus('ChitChat', true);});



