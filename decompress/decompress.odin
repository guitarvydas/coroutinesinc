package decompress

import "core:fmt"
import "core:log"
import "core:strings"
import "core:slice"
import "core:os"
import "core:unicode/utf8"

import reg "../registry0d"
import "../process"
import "../syntax"
import zd "../0d"

Decompress_States :: enum { wait_for_character, wait_for_len }

Decompress_Instance_Data :: struct {
    state : Decompress_States,
    Len : int
}

Next :: proc (eh : ^zd.Eh, next_state : Decompress_States){
    (transmute(^Decompress_Instance_Data)(eh.instance_data)).state = next_state
}

State :: proc (eh : ^zd.Eh) -> Decompress_States {
    return  (transmute(^Decompress_Instance_Data)(eh.instance_data)).state
}

instantiate :: proc(name: string) -> ^zd.Eh {
    @(static) counter := 0
    counter += 1

    name_with_id := fmt.aprintf("decompress (ID:%d)", counter)
    inst := new (Decompress_Instance_Data) // allocate in the heap
    eh := zd.make_leaf_with_data (name_with_id, inst, handler)
    Next (eh, .wait_for_character)
    return eh
}

handler :: proc(eh: ^zd.Eh,  msg: zd.Message, inst: ^Decompress_Instance_Data) {
    c := msg.datum.(rune)
    switch (State (eh)) {
    case .wait_for_character:
        switch msg.port {
        case "c":
	    if (c == '⊥') {
	    } else if c == 'ω' {
		inst.Len = cast(int)c
		Next (eh, .wait_for_len)
	    } else {
		zd.send (eh, "out", c)
	    }
        }

    case .wait_for_len:
        switch msg.port {
        case "c":
	    for ; inst.Len > 0 ; inst.Len -= 1 {
		zd.send (eh, "out", c)
	    }
	    Next (eh, .wait_for_character)
	}
    }
}
