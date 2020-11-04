unit Posix.SDL2.SDL_events;

(*
  Simple DirectMedia Layer
  Copyright (C) 1997-2018 Sam Lantinga <slouken@libsdl.org>

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
*)

interface

uses
  Linker.Helper, Posix.SDL2.consts, Posix.SDL2.SDL_keyboard, Posix.SDL2.SDL_joystick,
  Posix.SDL2.SDL_touch, Posix.SDL2.SDL_stdinc;

const
///* General keyboard/mouse state definitions */
  SDL_RELEASED   = 0;
  SDL_PRESSED    = 1;

  SDL_TEXTEDITINGEVENT_TEXT_SIZE = 32;

  SDL_TEXTINPUTEVENT_TEXT_SIZE = 32;

  SDL_QUERY    = -1;
  SDL_IGNORE   =  0;
  SDL_DISABLE  =  0;
  SDL_ENABLE   =  1;

type
(**
 * \brief The types of events that can be delivered.
 *)
  SDL_EventType = (
    SDL_FIRSTEVENT     = 0,     ///**< Unused (do not remove) */

    ///* Application events */
    SDL_QUITEVENT           = $100,  ///**< User-requested quit */

    ///* These application events have special meaning on iOS, see README-ios.md for details */
    SDL_APP_TERMINATING,        (**< The application is being terminated by the OS
                                     Called on iOS in applicationWillTerminate()
                                     Called on Android in onDestroy()
                                *)
    SDL_APP_LOWMEMORY,          (**< The application is low on memory, free memory if possible.
                                     Called on iOS in applicationDidReceiveMemoryWarning()
                                     Called on Android in onLowMemory()
                                *)
    SDL_APP_WILLENTERBACKGROUND, (**< The application is about to enter the background
                                     Called on iOS in applicationWillResignActive()
                                     Called on Android in onPause()
                                *)
    SDL_APP_DIDENTERBACKGROUND, (**< The application did enter the background and may not get CPU for some time
                                     Called on iOS in applicationDidEnterBackground()
                                     Called on Android in onPause()
                                *)
    SDL_APP_WILLENTERFOREGROUND, (**< The application is about to enter the foreground
                                     Called on iOS in applicationWillEnterForeground()
                                     Called on Android in onResume()
                                *)
    SDL_APP_DIDENTERFOREGROUND, (**< The application is now interactive
                                     Called on iOS in applicationDidBecomeActive()
                                     Called on Android in onResume()
                                *)

    ///* Display events */
    SDL_DISPLAYEVENT   = $150,  ///**< Display state change */

    ///* Window events */
    SDL_WINDOWEVENT    = $200,  ///**< Window state change */
    SDL_SYSWMEVENT,             ///**< System specific event */

    ///* Keyboard events */
    SDL_KEYDOWN        = $300,  ///**< Key pressed */
    SDL_KEYUP,                  ///**< Key released */
    SDL_TEXTEDITING,            ///**< Keyboard text editing (composition) */
    SDL_TEXTINPUT,              ///**< Keyboard text input */
    SDL_KEYMAPCHANGED,          (**< Keymap changed due to a system event such as an
                                     input language or keyboard layout change.
                                *)

    ///* Mouse events */
    SDL_MOUSEMOTION    = $400,  ///**< Mouse moved */
    SDL_MOUSEBUTTONDOWN,        ///**< Mouse button pressed */
    SDL_MOUSEBUTTONUP,          ///**< Mouse button released */
    SDL_MOUSEWHEEL,             ///**< Mouse wheel motion */

    ///* Joystick events */
    SDL_JOYAXISMOTION  = $600,  ///**< Joystick axis motion */
    SDL_JOYBALLMOTION,          ///**< Joystick trackball motion */
    SDL_JOYHATMOTION,           ///**< Joystick hat position change */
    SDL_JOYBUTTONDOWN,          ///**< Joystick button pressed */
    SDL_JOYBUTTONUP,            ///**< Joystick button released */
    SDL_JOYDEVICEADDED,         ///**< A new joystick has been inserted into the system */
    SDL_JOYDEVICEREMOVED,       ///**< An opened joystick has been removed */

    ///* Game controller events */
    SDL_CONTROLLERAXISMOTION  = $650,  ///**< Game controller axis motion */
    SDL_CONTROLLERBUTTONDOWN,          ///**< Game controller button pressed */
    SDL_CONTROLLERBUTTONUP,            ///**< Game controller button released */
    SDL_CONTROLLERDEVICEADDED,         ///**< A new Game controller has been inserted into the system */
    SDL_CONTROLLERDEVICEREMOVED,       ///**< An opened Game controller has been removed */
    SDL_CONTROLLERDEVICEREMAPPED,      ///**< The controller mapping was updated */

    ///* Touch events */
    SDL_FINGERDOWN      = $700,
    SDL_FINGERUP,
    SDL_FINGERMOTION,

    ///* Gesture events */
    SDL_DOLLARGESTURE   = $800,
    SDL_DOLLARRECORD,
    SDL_MULTIGESTURE,

    ///* Clipboard events */
    SDL_CLIPBOARDUPDATE = $900, ///**< The clipboard changed */

    ///* Drag and drop events */
    SDL_DROPFILE        = $1000,  ///**< The system requests a file open */
    SDL_DROPTEXT,                 ///**< text/plain drag-and-drop event */
    SDL_DROPBEGIN,                ///**< A new set of drops is beginning (NULL filename) */
    SDL_DROPCOMPLETE,             ///**< Current set of drops is now complete (NULL filename) */

    ///* Audio hotplug events */
    SDL_AUDIODEVICEADDED = $1100,  ///**< A new audio device is available */
    SDL_AUDIODEVICEREMOVED,        ///**< An audio device has been removed. */

    ///* Sensor events */
    SDL_SENSORUPDATE = $1200,      ///**< A sensor was updated */

    ///* Render events */
    SDL_RENDER_TARGETS_RESET = $2000, ///**< The render targets have been reset and their contents need to be updated */
    SDL_RENDER_DEVICE_RESET, ///**< The device has been reset and all textures need to be recreated */

    (** Events ::SDL_USEREVENT through ::SDL_LASTEVENT are for your use,
     *  and should be allocated with SDL_RegisterEvents()
     *)
    SDL_USEREVENT    = $8000,

    (**
     *  This last event is only for bounding internal arrays
     *)
    SDL_LASTEVENT    = $FFFF
  );

(**
 *  \brief Fields shared by every event
 *)
  TSDL_CommonEvent = record
    &type: Cardinal ;
    timestamp: Cardinal;   ///**< In milliseconds, populated using SDL_GetTicks() */
  end;

(**
 *  \brief Display state change event data (event.display.* )
 *)
  TSDL_DisplayEvent = record
    &type: Cardinal ;        ///**< ::SDL_DISPLAYEVENT */
    timestamp :Cardinal;   ///**< In milliseconds, populated using SDL_GetTicks() */
    display: Cardinal;     ///**< The associated display index */
    event: Byte;        ///**< ::SDL_DisplayEventID */
    padding1: Byte;
    padding2: Byte;
    padding3: Byte;
    data1: Integer;       ///**< event dependent data */
  end;

(**
 *  \brief Window state change event data (event.window.* )
 *)
  TSDL_WindowEvent = record
    &type: Cardinal;      ///**< ::SDL_DISPLAYEVENT */
    timestamp :Cardinal;   ///**< In milliseconds, populated using SDL_GetTicks() */
    display: Cardinal;     ///**< The associated display index */
    event: Byte;           ///**< ::SDL_DisplayEventID */
    padding1: Byte;
    padding2: Byte;
    padding3: Byte;
    data1: Integer;       ///**< event dependent data */
    data2: Integer;       ///**< event dependent data */
  end;

(**
 *  \brief Keyboard button event structure (event.key.* )
 *)
  TSDL_KeyboardEvent = record
    &type: Cardinal;        ///**< ::SDL_KEYDOWN or ::SDL_KEYUP */
    timestamp: Cardinal;   ///**< In milliseconds, populated using SDL_GetTicks() */
    windowID: Cardinal;    ///**< The window with keyboard focus, if any */
    state: Byte;        ///**< ::SDL_PRESSED or ::SDL_RELEASED */
    &repeat: Byte ;       ///**< Non-zero if this is a key repeat */
    padding2: Byte;
    padding3: Byte;
    keysym: SDL_Keysym;  ///**< The key that was pressed or released */
  end;

(**
 *  \brief Keyboard text editing event structure (event.edit.* )
 *)
  TSDL_TextEditingEvent = record
    &type: Cardinal;                                ///**< ::SDL_TEXTEDITING */
    timestamp: Cardinal;                           ///**< In milliseconds, populated using SDL_GetTicks() */
    windowID: Cardinal;                            ///**< The window with keyboard focus, if any */
    text: array[0..SDL_TEXTEDITINGEVENT_TEXT_SIZE-1] of UTF8Char;  ///**< The editing text */
    start: Integer;                               ///**< The start cursor of selected editing text */
    length: Integer;                              ///**< The length of selected editing text */
  end;

(**
 *  \brief Keyboard text input event structure (event.text.* )
 *)
  TSDL_TextInputEvent = record
    &type: Cardinal;                                ///**< ::SDL_TEXTEDITING */
    timestamp: Cardinal;                           ///**< In milliseconds, populated using SDL_GetTicks() */
    windowID: Cardinal;                            ///**< The window with keyboard focus, if any */
    text: array[0..SDL_TEXTINPUTEVENT_TEXT_SIZE-1] of UTF8Char; ///**< The input text */
  end;

(**
 *  \brief Mouse motion event structure (event.motion.* )
 *)
  TSDL_MouseMotionEvent = record
    &type: Cardinal;       ///**< ::SDL_MOUSEMOTION */
    timestamp: Cardinal;   ///**< In milliseconds, populated using SDL_GetTicks() */
    windowID: Cardinal;    ///**< The window with mouse focus, if any */
    which: Cardinal;       ///**< The mouse instance id, or SDL_TOUCH_MOUSEID */
    state: Cardinal;       ///**< The current button state */
    x: Integer;            ///**< X coordinate, relative to window */
    y: Integer;            ///**< Y coordinate, relative to window */
    xrel: Integer;         ///**< The relative motion in the X direction */
    yrel: Integer;         ///**< The relative motion in the Y direction */
  end;

(**
 *  \brief Mouse button event structure (event.button.* )
 *)
  TSDL_MouseButtonEvent = record
    &type: Cardinal;        ///**< ::SDL_MOUSEBUTTONDOWN or ::SDL_MOUSEBUTTONUP */
    timestamp: Cardinal;   ///**< In milliseconds, populated using SDL_GetTicks() */
    windowID: Cardinal;    ///**< The window with mouse focus, if any */
    which: Cardinal;       ///**< The mouse instance id, or SDL_TOUCH_MOUSEID */
    button: Byte;       ///**< The mouse button index */
    state: Byte;        ///**< ::SDL_PRESSED or ::SDL_RELEASED */
    clicks: Byte;       ///**< 1 for single-click, 2 for double-click, etc. */
    padding1: Byte;
    x: Integer ;           ///**< X coordinate, relative to window */
    y: Integer;           ///**< Y coordinate, relative to window */
  end;

(**
 *  \brief Mouse wheel event structure (event.wheel.* )
 *)
  TSDL_MouseWheelEvent = record
    &type: Cardinal;       ///**< ::SDL_MOUSEWHEEL */
    timestamp: Cardinal;   ///**< In milliseconds, populated using SDL_GetTicks() */
    windowID: Cardinal;    ///**< The window with mouse focus, if any */
    which: Cardinal;       ///**< The mouse instance id, or SDL_TOUCH_MOUSEID */
    x: Integer;            ///**< The amount scrolled horizontally, positive to the right and negative to the left */
    y: Integer;            ///**< The amount scrolled vertically, positive away from the user and negative toward the user */
    direction: Cardinal;   ///**< Set to one of the SDL_MOUSEWHEEL_* defines. When FLIPPED the values in X and Y will be opposite. Multiply by -1 to change them back */
  end;

(**
 *  \brief Joystick axis motion event structure (event.jaxis.* )
 *)
  TSDL_JoyAxisEvent = record
    &type: Cardinal;        ///**< ::SDL_JOYAXISMOTION */
    timestamp: Cardinal;   ///**< In milliseconds, populated using SDL_GetTicks() */
    which: SDL_JoystickID; ///**< The joystick instance id */
    axis: Byte;         ///**< The joystick axis index */
    padding1: Byte;
    padding2: Byte;
    padding3: Byte;
    value: SmallInt;       ///**< The axis value (range: -32768 to 32767) */
    padding4: WORD;
  end;

(**
 *  \brief Joystick trackball motion event structure (event.jball.* )
 *)
  TSDL_JoyBallEvent = record
    &type: Cardinal ;      ///**< ::SDL_JOYBALLMOTION */
    timestamp: Cardinal;   ///**< In milliseconds, populated using SDL_GetTicks() */
    which: SDL_JoystickID; ///**< The joystick instance id */
    ball: Byte;            ///**< The joystick trackball index */
    padding1: Byte;
    padding2: Byte;
    padding3: Byte;
    xrel: Integer;         ///**< The relative motion in the X direction */
    yrel: Integer;         ///**< The relative motion in the Y direction */
  end;

(**
 *  \brief Joystick hat position change event structure (event.jhat.* )
 *)
  TSDL_JoyHatEvent = record
    &type:  Cardinal;      ///**< ::SDL_JOYHATMOTION */
    timestamp: Cardinal;   ///**< In milliseconds, populated using SDL_GetTicks() */
    which: SDL_JoystickID; ///**< The joystick instance id */
    hat: Byte;             ///**< The joystick hat index */
    value: Byte;        (**< The hat position value.
                         *   \sa ::SDL_HAT_LEFTUP ::SDL_HAT_UP ::SDL_HAT_RIGHTUP
                         *   \sa ::SDL_HAT_LEFT ::SDL_HAT_CENTERED ::SDL_HAT_RIGHT
                         *   \sa ::SDL_HAT_LEFTDOWN ::SDL_HAT_DOWN ::SDL_HAT_RIGHTDOWN
                         *
                         *   Note that zero means the POV is centered.
                         *)
    padding1: Byte;
    padding2: Byte;
  end;

(**
 *  \brief Joystick button event structure (event.jbutton.* )
 *)
  TSDL_JoyButtonEvent = record
    &type: Cardinal;        ///**< ::SDL_JOYBUTTONDOWN or ::SDL_JOYBUTTONUP */
    timestamp: Cardinal;   ///**< In milliseconds, populated using SDL_GetTicks() */
    which: SDL_JoystickID; ///**< The joystick instance id */
    button: Byte;       ///**< The joystick button index */
    state: Byte;        ///**< ::SDL_PRESSED or ::SDL_RELEASED */
    padding1: Byte;
    padding2: Byte;
  end;

(**
 *  \brief Joystick device event structure (event.jdevice.* )
 *)
  TSDL_JoyDeviceEvent = record
    &type: Cardinal;        ///**< ::SDL_JOYDEVICEADDED or ::SDL_JOYDEVICEREMOVED */
    timestamp: Cardinal;   ///**< In milliseconds, populated using SDL_GetTicks() */
    which: Integer;       ///**< The joystick device index for the ADDED event, instance id for the REMOVED event */
  end;

(**
 *  \brief Game controller axis motion event structure (event.caxis.* )
 *)
  TSDL_ControllerAxisEvent = record
    &type: Cardinal;        ///**< ::SDL_CONTROLLERAXISMOTION */
    timestamp: Cardinal;   ///**< In milliseconds, populated using SDL_GetTicks() */
    which: SDL_JoystickID; ///**< The joystick instance id */
    axis: Byte;         ///**< The controller axis (SDL_GameControllerAxis) */
    padding1: Byte;
    padding2: Byte;
    padding3: Byte;
    value: SmallInt;       ///**< The axis value (range: -32768 to 32767) */
    padding4: WORD;
  end;

(**
 *  \brief Game controller button event structure (event.cbutton.* )
 *)
  TSDL_ControllerButtonEvent = record
    &type: Cardinal;        ///**< ::SDL_CONTROLLERBUTTONDOWN or ::SDL_CONTROLLERBUTTONUP */
    timestamp: Cardinal;   ///**< In milliseconds, populated using SDL_GetTicks() */
    which: SDL_JoystickID; ///**< The joystick instance id */
    button: Byte;       ///**< The controller button (SDL_GameControllerButton) */
    state: Byte;        ///**< ::SDL_PRESSED or ::SDL_RELEASED */
    padding1: Byte;
    padding2: Byte;
  end;

(**
 *  \brief Controller device event structure (event.cdevice.* )
 *)
  TSDL_ControllerDeviceEvent = record
    &type: Cardinal;        ///**< ::SDL_CONTROLLERDEVICEADDED, ::SDL_CONTROLLERDEVICEREMOVED, or ::SDL_CONTROLLERDEVICEREMAPPED */
    timestamp: Cardinal;    ///**< In milliseconds, populated using SDL_GetTicks() */
    which: Integer;         ///**< The joystick device index for the ADDED event, instance id for the REMOVED or REMAPPED event */
  end;

(**
 *  \brief Audio device event structure (event.adevice.* )
 *)
  TSDL_AudioDeviceEvent = record
    &type: Cardinal;        ///**< ::SDL_AUDIODEVICEADDED, or ::SDL_AUDIODEVICEREMOVED */
    timestamp: Cardinal;   ///**< In milliseconds, populated using SDL_GetTicks() */
    which: Cardinal;       ///**< The audio device index for the ADDED event (valid until next SDL_GetNumAudioDevices() call), SDL_AudioDeviceID for the REMOVED event */
    iscapture: Byte;    ///**< zero if an output device, non-zero if a capture device. */
    padding1: Byte;
    padding2: Byte;
    padding3: Byte;
  end;


(**
 *  \brief Touch finger event structure (event.tfinger.* )
 *)
  TSDL_TouchFingerEvent = record
    &type: Cardinal;        ///**< ::SDL_FINGERMOTION or ::SDL_FINGERDOWN or ::SDL_FINGERUP */
    timestamp: Cardinal;   ///**< In milliseconds, populated using SDL_GetTicks() */
    touchId: SDL_TouchID; ///**< The touch device id */
    fingerId: SDL_FingerID;
    x: Single;            ///**< Normalized in the range 0...1 */
    y: Single;            ///**< Normalized in the range 0...1 */
    dx: Single;           ///**< Normalized in the range -1...1 */
    dy: Single;           ///**< Normalized in the range -1...1 */
    pressure: Single;     ///**< Normalized in the range 0...1 */
  end;

(**
 *  \brief Multiple Finger Gesture Event (event.mgesture.* )
 *)
  TSDL_MultiGestureEvent = record
    &type: Cardinal;        ///**< ::SDL_MULTIGESTURE */
    timestamp: Cardinal;   ///**< In milliseconds, populated using SDL_GetTicks() */
    touchId: SDL_TouchID; ///**< The touch device id */
    dTheta: Single;
    dDist: Single;
    x: Single;
    y: Single;
    numFingers: WORD;
    padding: WORD;
  end;

(**
 * \brief Dollar Gesture Event (event.dgesture.* )
 *)
  TSDL_DollarGestureEvent = record
    &type: Cardinal;        ///**< ::SDL_DOLLARGESTURE or ::SDL_DOLLARRECORD */
    timestamp: Cardinal;   ///**< In milliseconds, populated using SDL_GetTicks() */
    touchId: SDL_TouchID; ///**< The touch device id */
    gestureId: SDL_GestureID;
    numFingers: Cardinal;
    error: Single;
    x: Single;            ///**< Normalized center of gesture */
    y: Single;            ///**< Normalized center of gesture */
  end;

(**
 *  \brief An event used to request a file open by the system (event.drop.* )
 *         This event is enabled by default, you can disable it with SDL_EventState().
 *  \note If this event is enabled, you must free the filename in the event.
 *)
  TSDL_DropEvent = record
    &type: Cardinal;        ///**< ::SDL_DROPBEGIN or ::SDL_DROPFILE or ::SDL_DROPTEXT or ::SDL_DROPCOMPLETE */
    timestamp: Cardinal;   ///**< In milliseconds, populated using SDL_GetTicks() */
    &file: MarshaledAString;         ///**< The file name, which should be freed with SDL_free(), is NULL on begin/complete */
    windowID: Cardinal;    ///**< The window that was dropped on, if any */
  end;


(**
 *  \brief Sensor event structure (event.sensor.* )
 *)
  TSDL_SensorEvent = record
    &type: Cardinal;        ///**< ::SDL_SENSORUPDATE */
    timestamp: Cardinal;   ///**< In milliseconds, populated using SDL_GetTicks() */
    which: Integer;       ///**< The instance ID of the sensor */
    data: array[0..5] of Single;      ///**< Up to 6 values from the sensor - additional values can be queried using SDL_SensorGetData() */
  end;

(**
 *  \brief The "quit requested" event
 *)
  TSDL_QuitEvent = record
    &type: Cardinal;        ///**< ::SDL_QUIT */
    timestamp: Cardinal;   ///**< In milliseconds, populated using SDL_GetTicks() */
  end;

(**
 *  \brief OS Specific event
 *)
  TSDL_OSEvent = record
    &type: Cardinal;        ///**< ::SDL_QUIT */
    timestamp: Cardinal;   ///**< In milliseconds, populated using SDL_GetTicks() */
  end;

(**
 *  \brief A user-defined event type (event.user.* )
 *)
  TSDL_UserEvent = record
    &type: Cardinal;        ///**< ::SDL_USEREVENT through ::SDL_LASTEVENT-1 */
    timestamp: Cardinal;   ///**< In milliseconds, populated using SDL_GetTicks() */
    windowID: Cardinal;    ///**< The associated window if any */
    code: Integer;        ///**< User defined event code */
    data1: Pointer;        ///**< User defined data pointer */
    data2: Pointer;        ///**< User defined data pointer */
  end;


  PSDL_SysWMmsg = Pointer;

(**
 *  \brief A video driver dependent system event (event.syswm.* )
 *         This event is disabled by default, you can enable it with SDL_EventState()
 *
 *  \note If you want to use this event, you should include SDL_syswm.h.
 *)
  TSDL_SysWMEvent = record
    &type: Cardinal;        ///**< ::SDL_SYSWMEVENT */
    timestamp: Cardinal;   ///**< In milliseconds, populated using SDL_GetTicks() */
    msg: PSDL_SysWMmsg;  ///**< driver dependent data, defined in SDL_syswm.h */
  end;

  PSDL_Event = ^SDL_Event;
  SDL_Event = record
  case Uint32 of
    0:
      (&type: Uint32);
    1:
      (common: TSDL_CommonEvent);
    Ord(SDL_WINDOWEVENT):
      (window: TSDL_WindowEvent);
    Ord(SDL_KEYUP),
    Ord(SDL_KEYDOWN):
      (key: TSDL_KeyboardEvent);
    Ord(SDL_TEXTEDITING):
      (edit: TSDL_TextEditingEvent);
    Ord(SDL_TEXTINPUT):
      (text: TSDL_TextInputEvent);
    Ord(SDL_MOUSEMOTION):
      (motion: TSDL_MouseMotionEvent);
    Ord(SDL_MOUSEBUTTONUP),
    Ord(SDL_MOUSEBUTTONDOWN):
      (button: TSDL_MouseButtonEvent);
    Ord(SDL_MOUSEWHEEL):
      (wheel: TSDL_MouseWheelEvent);
    Ord(SDL_JOYAXISMOTION):
      (jaxis: TSDL_JoyAxisEvent);
    Ord(SDL_JOYBALLMOTION):
      (jball: TSDL_JoyBallEvent);
    Ord(SDL_JOYHATMOTION):
      (jhat: TSDL_JoyHatEvent);
    Ord(SDL_JOYBUTTONDOWN),
    Ord(SDL_JOYBUTTONUP):
      (jbutton: TSDL_JoyButtonEvent);
    Ord(SDL_JOYDEVICEADDED),
    Ord(SDL_JOYDEVICEREMOVED):
      (jdevice: TSDL_JoyDeviceEvent);
    Ord(SDL_CONTROLLERAXISMOTION):
      (caxis: TSDL_ControllerAxisEvent);
    Ord(SDL_CONTROLLERBUTTONUP),
    Ord(SDL_CONTROLLERBUTTONDOWN):
      (cbutton: TSDL_ControllerButtonEvent);
    Ord(SDL_CONTROLLERDEVICEADDED),
    Ord(SDL_CONTROLLERDEVICEREMOVED),
    Ord(SDL_CONTROLLERDEVICEREMAPPED):
      (cdevice: TSDL_ControllerDeviceEvent);
    Ord(SDL_QUITEVENT):
      (quit: TSDL_QuitEvent);
    Ord(SDL_USEREVENT):
      (user: TSDL_UserEvent);
    Ord(SDL_SYSWMEVENT):
      (syswm: TSDL_SysWMEvent);
    Ord(SDL_FINGERDOWN),
    Ord(SDL_FINGERUP),
    Ord(SDL_FINGERMOTION):
      (tfinger: TSDL_TouchFingerEvent);
    Ord(SDL_MULTIGESTURE):
      (mgesture: TSDL_MultiGestureEvent);
    Ord(SDL_DOLLARGESTURE),
    Ord(SDL_DOLLARRECORD):
      (dgesture: TSDL_DollarGestureEvent);
    Ord(SDL_DROPFILE):
      (drop: TSDL_DropEvent);
    Ord(SDL_LASTEVENT) + 1:
      (padding: array [0..55] of Uint8);
  end;

  SDL_eventaction = (
    SDL_ADDEVENT,
    SDL_PEEKEVENT,
    SDL_GETEVENT
  );

  PSDL_EventFilter = ^SDL_EventFilter;
  SDL_EventFilter = function(userdata: Pointer; event: PSDL_Event): Integer; cdecl;

(**
 *  Pumps the event loop, gathering events from the input devices.
 *
 *  This function updates the event queue and internal input device state.
 *
 *  This should only be run in the thread that sets the video mode.
 *)
procedure SDL_PumpEvents; cdecl; external libSDL2 name _PU + 'SDL_PumpEvents';

(**
 *  Checks the event queue for messages and optionally returns them.
 *
 *  If \c action is ::SDL_ADDEVENT, up to \c numevents events will be added to
 *  the back of the event queue.
 *
 *  If \c action is ::SDL_PEEKEVENT, up to \c numevents events at the front
 *  of the event queue, within the specified minimum and maximum type,
 *  will be returned and will not be removed from the queue.
 *
 *  If \c action is ::SDL_GETEVENT, up to \c numevents events at the front
 *  of the event queue, within the specified minimum and maximum type,
 *  will be returned and will be removed from the queue.
 *
 *  \return The number of events actually stored, or -1 if there was an error.
 *
 *  This function is thread-safe.
 *)
function SDL_PeepEvents(events: PSDL_Event; numevents: Integer; action: SDL_eventaction; minType: Cardinal; maxType: Cardinal): Integer; cdecl; external libSDL2 name _PU + 'SDL_PeepEvents';

(**
 *  Checks to see if certain event types are in the event queue.
 *)
function SDL_HasEvent(&type: Cardinal): SDL_bool; cdecl; external libSDL2 name _PU + 'SDL_HasEvent';
function SDL_HasEvents(minType: Cardinal; maxType: Cardinal): SDL_bool; cdecl; external libSDL2 name _PU + 'SDL_HasEvents';

(**
 *  This function clears events from the event queue
 *  This function only affects currently queued events. If you want to make
 *  sure that all pending OS events are flushed, you can call SDL_PumpEvents()
 *  on the main thread immediately before the flush call.
 *)
procedure SDL_FlushEvent(&type: Cardinal); cdecl; external libSDL2 name _PU + 'SDL_FlushEvent';
procedure SDL_FlushEvents(minType: Cardinal; maxType: Cardinal); cdecl; external libSDL2 name _PU + 'SDL_FlushEvents';

(**
 *  \brief Polls for currently pending events.
 *
 *  \return 1 if there are any pending events, or 0 if there are none available.
 *
 *  \param event If not NULL, the next event is removed from the queue and
 *               stored in that area.
 *)
function SDL_PollEvent(event: PSDL_Event): Integer; cdecl; external libSDL2 name _PU + 'SDL_PollEvent';

(**
 *  \brief Waits indefinitely for the next available event.
 *
 *  \return 1, or 0 if there was an error while waiting for events.
 *
 *  \param event If not NULL, the next event is removed from the queue and
 *               stored in that area.
 *)
function SDL_WaitEvent(event: PSDL_Event): Integer; cdecl; external libSDL2 name _PU + 'SDL_WaitEvent';

(**
 *  \brief Waits until the specified timeout (in milliseconds) for the next
 *         available event.
 *
 *  \return 1, or 0 if there was an error while waiting for events.
 *
 *  \param event If not NULL, the next event is removed from the queue and
 *               stored in that area.
 *  \param timeout The timeout (in milliseconds) to wait for next event.
 *)
function SDL_WaitEventTimeout(event: PSDL_Event; timeout: Integer): Integer; cdecl; external libSDL2 name _PU + 'SDL_WaitEventTimeout';

(**
 *  \brief Add an event to the event queue.
 *
 *  \return 1 on success, 0 if the event was filtered, or -1 if the event queue
 *          was full or there was some other error.
 *)
function SDL_PushEvent(event: PSDL_Event): Integer; cdecl; external libSDL2 name _PU + 'SDL_PushEvent';

(**
 *  Sets up a filter to process all events before they change internal state and
 *  are posted to the internal event queue.
 *
 *  The filter is prototyped as:
 *  \code
 *      int SDL_EventFilter(void *userdata, SDL_Event * event);
 *  \endcode
 *
 *  If the filter returns 1, then the event will be added to the internal queue.
 *  If it returns 0, then the event will be dropped from the queue, but the
 *  internal state will still be updated.  This allows selective filtering of
 *  dynamically arriving events.
 *
 *  \warning  Be very careful of what you do in the event filter function, as
 *            it may run in a different thread!
 *
 *  There is one caveat when dealing with the ::SDL_QuitEvent event type.  The
 *  event filter is only called when the window manager desires to close the
 *  application window.  If the event filter returns 1, then the window will
 *  be closed, otherwise the window will remain open if possible.
 *
 *  If the quit event is generated by an interrupt signal, it will bypass the
 *  internal queue and be delivered to the application at the next event poll.
 *)
procedure SDL_SetEventFilter(filter: SDL_EventFilter; userdata: Pointer); cdecl; external libSDL2 name _PU + 'SDL_SetEventFilter';

(**
 *  Return the current event filter - can be used to "chain" filters.
 *  If there is no event filter set, this function returns SDL_FALSE.
 *)
function SDL_GetEventFilter(filter: PSDL_EventFilter; var userdata: Pointer): SDL_bool; cdecl; external libSDL2 name _PU + 'SDL_GetEventFilter';

(**
 *  Add a function which is called when an event is added to the queue.
 *)
procedure SDL_AddEventWatch(filter: SDL_EventFilter; userdata: Pointer); cdecl; external libSDL2 name _PU + 'SDL_AddEventWatch';

(**
 *  Remove an event watch function added with SDL_AddEventWatch()
 *)
procedure SDL_DelEventWatch(filter: SDL_EventFilter; userdata: Pointer); cdecl; external libSDL2 name _PU + 'SDL_DelEventWatch';

(**
 *  Run the filter function on the current event queue, removing any
 *  events for which the filter returns 0.
 *)
procedure SDL_FilterEvents(filter: SDL_EventFilter; userdata: Pointer); cdecl; external libSDL2 name _PU + 'SDL_FilterEvents';

(**
 *  This function allows you to set the state of processing certain events.
 *   - If \c state is set to ::SDL_IGNORE, that event will be automatically
 *     dropped from the event queue and will not be filtered.
 *   - If \c state is set to ::SDL_ENABLE, that event will be processed
 *     normally.
 *   - If \c state is set to ::SDL_QUERY, SDL_EventState() will return the
 *     current processing state of the specified event.
 *)
function SDL_EventState(&type: Cardinal; state: Integer): Byte; cdecl; external libSDL2 name _PU + 'SDL_EventState';

(**
 *  This function allocates a set of user-defined events, and returns
 *  the beginning event number for that set of events.
 *
 *  If there aren't enough user-defined events left, this function
 *  returns (Uint32)-1
 *)
function SDL_RegisterEvents(numevents: Integer): Cardinal; cdecl; external libSDL2 name _PU + 'SDL_RegisterEvents';


implementation

end.
