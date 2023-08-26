package syntaxmapper

import "core:fmt"
import "core:log"
import "core:strings"
import "core:slice"
import "core:os"
import "core:unicode/utf8"

import reg "registry0d"
import "process"
import "syntax"
import zd "0d"
import user "user0d"
import leaf "leaf0d"

main :: proc() {

    if user.start_logger () {
	fmt.println ("*** starting logger ***")
	context.logger = log.create_console_logger(
            opt={.Level, .Time, .Terminal_Color},
	)
    }

    // load arguments
    diagram_source_file := slice.get(os.args, 1) or_else "syntaxmapper.drawio"
    main_container_name := slice.get(os.args, 2) or_else "main"

    if !os.exists(diagram_source_file) {
        fmt.println("Source diagram file", diagram_source_file, "does not exist.")
        os.exit(1)
    }

    // set up shell leaves
    leaves := make([dynamic]reg.Leaf_Instantiator)
    leaf.collect_process_leaves(diagram_source_file, &leaves)

    // export native leaves
    append(&leaves, reg.Leaf_Instantiator {
        name = "stdout",
        init = leaf.stdout_instantiate,
    })



    user.components (&leaves)

    regstry := reg.make_component_registry(leaves[:], diagram_source_file)

    // get entrypoint container
    main_container, ok := reg.get_component_instance(regstry, main_container_name)
    fmt.assertf(
        ok,
        "Couldn't find main container with page name %s in file %s (check tab names, or disable compression?)\n",
        main_container_name,
        diagram_source_file,
    )

    run (main_container)

    fmt.println("--- Outputs ---")
    zd.print_output_list(main_container)
}

run :: proc (main_container : ^zd.Eh) {
    // 1. inject suffix
    // 2. inject any number of filenames to be macro expanded
    // 3. inject filename of .odin file to be processed
    
    // macro expand files
    main_container.handler (main_container, zd.make_message ("suffix", ".m4"))

    main_container.handler (main_container, zd.make_message ("macro expand", "odinproc.ohm"))
    main_container.handler (main_container, zd.make_message ("macro expand", "odinproc.fab"))

    main_container.handler (main_container, zd.make_message ("macro expand", "odinstruct.ohm"))
    main_container.handler (main_container, zd.make_message ("macro expand", "odinstruct.fab"))
    
    main_container.handler (main_container, zd.make_message ("macro expand", "odindeletecomments.ohm"))
    main_container.handler (main_container, zd.make_message ("macro expand", "odindeletecomments.fab"))

    main_container.handler (main_container, zd.make_message ("macro expand", "queue.ohm"))
    main_container.handler (main_container, zd.make_message ("macro expand", "queue.fab"))

    main_container.handler (main_container, zd.make_message ("macro expand", "append.ohm"))
    main_container.handler (main_container, zd.make_message ("macro expand", "append.tocl.fab"))

    main_container.handler (main_container, zd.make_message ("macro expand", "scopedvar.ohm"))
    main_container.handler (main_container, zd.make_message ("macro expand", "scopedvar.tocl.fab"))

    main_container.handler (main_container, zd.make_message ("macro expand", "message_literal.ohm"))
    main_container.handler (main_container, zd.make_message ("macro expand", "message_literal.tocl.fab"))

    main_container.handler (main_container, zd.make_message ("macro expand", "if.ohm"))
    main_container.handler (main_container, zd.make_message ("macro expand", "if.tocl.fab"))

    main_container.handler (main_container, zd.make_message ("macro expand", "forin.ohm"))
    main_container.handler (main_container, zd.make_message ("macro expand", "forin.tocl.fab"))

    main_container.handler (main_container, zd.make_message ("macro expand", "forexpr.ohm"))
    main_container.handler (main_container, zd.make_message ("macro expand", "forexpr.tocl.fab"))

    main_container.handler (main_container, zd.make_message ("macro expand", "return.ohm"))
    main_container.handler (main_container, zd.make_message ("macro expand", "return.tocl.fab"))

    main_container.handler (main_container, zd.make_message ("macro expand", "delannotations.ohm"))
    main_container.handler (main_container, zd.make_message ("macro expand", "delannotations.tocl.fab"))

    main_container.handler (main_container, zd.make_message ("macro expand", "op.ohm"))
    main_container.handler (main_container, zd.make_message ("macro expand", "op.tocl.fab"))

    main_container.handler (main_container, zd.make_message ("macro expand", "assign.ohm"))
    main_container.handler (main_container, zd.make_message ("macro expand", "assign.tocl.fab"))

    main_container.handler (main_container, zd.make_message ("macro expand", "slotvalue.ohm"))
    main_container.handler (main_container, zd.make_message ("macro expand", "slotvalue.tocl.fab"))

    main_container.handler (main_container, zd.make_message ("macro expand", "clstruct.ohm"))
    main_container.handler (main_container, zd.make_message ("macro expand", "clstruct.tocl.fab"))

    main_container.handler (main_container, zd.make_message ("macro expand", "clproc.ohm"))
    main_container.handler (main_container, zd.make_message ("macro expand", "clproc.tocl.fab"))

    main_container.handler (main_container, zd.make_message ("macro expand", "funcall.ohm"))
    main_container.handler (main_container, zd.make_message ("macro expand", "funcall.tocl.fab"))

    // 3. process one .odin file
    //
    // main_container.handler(main_container, zd.make_message("filename", "test.odin.txt"))
    main_container.handler(main_container, zd.make_message("filename", "../../odin0d/0d/0d.odin"))
}
