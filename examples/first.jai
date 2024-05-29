#import "Compiler";
#import "Basic";
#import "Process";

#run {
    options := get_build_options();
    assert(options.compile_time_command_line.count >= 1, "Missing args, did you forget to pass the name of the example? (ie: jai first.jai - clear)");
    example_name := options.compile_time_command_line[0];
    use_gl := array_find(options.compile_time_command_line, "-GL");

    workspace := compiler_create_workspace(tprint("Building example: %", example_name));

    options.output_path = example_name;
    options.output_executable_name = example_name;
    set_build_options(options, workspace);
    compiler_begin_intercept(workspace);
    add_build_string(tprint("USE_GL :: %;", use_gl), workspace);
    add_build_file(tprint("%/module.jai", example_name), workspace);

    while true {
        message := compiler_wait_for_message();
        if message.kind == {
            case .ERROR;    { exit(1); }
            case .COMPLETE; { break; }
        }
    }
    compiler_end_intercept(workspace);

    run_command(tprint("./%/%", example_name, example_name));

    set_build_options_dc(.{ do_output = false });
}
