#!/usr/bin/env python3

if __name__ == "__main__":
    print("Not usable as standalone program!")

try:
    import lldb
except:
    pass


# function called on script load
def __lldb_init_module(debugger, internal_dict):
    res = lldb.SBCommandReturnObject()
    lldb.debugger.GetCommandInterpreter().HandleCommand("settings set prompt \"(lldb) \"", res)

    # format frame and thread output with colors (see https://lldb.llvm.org/formats.html)
    lldb.debugger.GetCommandInterpreter().HandleCommand("settings set frame-format \"\x1b\x5b1mframe #${frame.index}\x1b\x5b0m:\x1b\x5b35m ${frame.pc}\x1b\x5b0m{ \x1b\x5b36m${module.file.basename}\x1b\x5b39m{` \x1b\x5b33m${function.name-with-args} \x1b\x5b39m${function.pc-offset}}}{ at ${line.file.basename}:${line.number}}\n\"", res)
    lldb.debugger.GetCommandInterpreter().HandleCommand("settings set thread-stop-format \"thread #${thread.index}{, name = \x1b\x5b34m'${thread.name}'\x1b\x5b0m}{, queue = '${thread.queue}'}{, activity = '${thread.info.activity.name}'}{, ${thread.info.trace_messages} messages}{, stop reason = \x1b\x5b31m${thread.stop-reason}\x1b\x5b0m}{\nReturn value: ${thread.return-value}}{\nCompleted expression: ${thread.completed-expression}}\n\"", res)
    lldb.debugger.GetCommandInterpreter().HandleCommand("settings set thread-format \"thread #${thread.index}: tid = ${thread.id}{, \x1b\x5b35m${frame.pc}}\x1b\x5b0m{ \x1b\x5b36m${module.file.basename}{` \x1b\x5b33m${function.name-with-args}\x1b\x5b39m${function.pc-offset}}}{ at ${line.file.basename}:${line.number}}{, name = \x1b\x5b34m'${thread.name}'}\x1b\x5b39m{, queue = '${thread.queue}}{, stop reason = \x1b\x5b31m${thread.stop-reason}\x1b\x5b0m}{\nReturn value: ${thread.return-value}}\n\"", res)

    # add functions to lldb
    lldb.debugger.GetCommandInterpreter().HandleCommand("command script add -f settings.qt_run_settings qrs", res)

    # return is required in this function
    return


# special settings required to debug qt gui applications
def qt_run_settings(debugger, command, result, internal_dict):
    target = debugger.GetSelectedTarget()

    # set a breakpoint at _start() function and define callback
    breakpoint = target.BreakpointCreateByName("_start")
    breakpoint.SetScriptCallbackFunction("settings.__qt_run_callback")


# callback which is called if the breakpoint is hit
def __qt_run_callback(frame, bp_loc, dict):
    res = lldb.SBCommandReturnObject()

    # don't hold on SIGSTOP signals which are thrown from qt
    lldb.debugger.GetCommandInterpreter().HandleCommand("process handle SIGSTOP -p true -s false", res)

    # automatically continue the process
    lldb.debugger.GetCommandInterpreter().HandleCommand("continue", res)
