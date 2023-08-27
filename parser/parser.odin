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
    switch (State (eh)) {
    case .wait_for_character:
        switch msg.port {
        case "c":
	    c := msg.datum.(rune)
	    switch {
	    case isalpha (c):
		inst.buffer = sappend (inst.buffer, c)
	    case (c != '⊥') && !isalpha (c):
		send_word (eh, inst)
		send_punct (eh, inst, c)
		clear_buffer (eh, inst)
	    case (c == '⊥') && len (inst.buffer) > 0:
		send_word (eh, inst)
		clear_buffer (eh, inst)
	    case (c == '⊥') && len (inst.buffer) == 0:
		clear_buffer (eh, inst)
	    }
	}
    }
}

send_word :: proc (eh : ^zd.Eh, inst : ^Parser_Instance_Data) {
    zd.send (eh, "token", Parser_Tags.word)
    zd.send (eh, "strout", inst.buffer)
}

send_punct :: proc (eh : ^zd.Eh, inst : ^Parser_Instance_Data, c : rune) {
    zd.send (eh, "token", Parser_Tags.punct)
    zd.send (eh, "strout", stringify (c))
}

clear_buffer :: proc (eh : ^zd.Eh, inst : ^Parser_Instance_Data) {
    inst.buffer = ""
}

buggy_stringify :: proc (c : rune) -> string {
    s := sappend ("", c)
    return s
}

stringify :: proc (c : rune) -> string {
    s := fmt.aprintf ("%c", c)
    return s
}

sappend :: proc (s : string, c : rune) -> string {
    r := fmt.aprintf ("%s%c", s, c)
    return r
}

isalpha :: proc (c : rune) -> bool {
    return (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')
}
