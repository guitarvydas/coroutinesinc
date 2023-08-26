package parser

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

Parser_States :: enum { wait_for_character }
Parser_Tags :: enum { word, punct }

Parser_Instance_Data :: struct {
    state : Parser_States,
    buffer : string
}

Next :: proc (eh : ^zd.Eh, next_state : Parser_States) {
    (transmute(^Parser_Instance_Data)(eh.instance_data)).state = next_state
}

State :: proc (eh : ^zd.Eh) -> Parser_States {
    return (transmute(^Parser_Instance_Data)(eh.instance_data)).state
}

instantiate :: proc(name: string) -> ^zd.Eh {
    @(static) counter := 0
    counter += 1

    name_with_id := fmt.aprintf("parser (ID:%d)", counter)
    inst := new (Parser_Instance_Data) // allocate in the heap
    eh := zd.make_leaf_with_data (name_with_id, inst, handler)
    inst.buffer = ""
    Next (eh, .wait_for_character)
    return eh
}

handler :: proc(eh: ^zd.Eh,  msg: zd.Message, inst: ^Parser_Instance_Data) {
    fmt.printf ("parser %v %v\n", msg.port, msg.datum.(rune))
    switch (State (eh)) {
    case .wait_for_character:
        switch msg.port {
        case "c":
	    c := msg.datum.(rune)
	    if (isalpha (c)) {
		inst.buffer = sappend (inst.buffer, c)
	    } else if (c == '⊥') && len (inst.buffer) > 0  {
		zd.send (eh, "token", Parser_Tags.word)
		zd.send (eh, "strout", inst.buffer)
	    } else {
		zd.send (eh, "token", Parser_Tags.word)
		zd.send (eh, "strout", inst.buffer)
		zd.send (eh, "token", Parser_Tags.punct)
		zd.send (eh, "strout", stringify (c))
	    }
	}
    }
}

stringify :: proc (c : rune) -> string {
    s := sappend ("", c)
    return s
}

sappend :: proc (s : string, c : rune) -> string {
    r := fmt.aprintf ("%s%c", s, c)
    return r
}

isalpha :: proc (c : rune) -> bool {
    return (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')
}
