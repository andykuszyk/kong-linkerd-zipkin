require 'linkerd'

header="wIZjU4TGt/twXDA2pG3hoHBcMDakbeGgAAAAAAAAAAY="

function get_id_should_return_number()
    hex = "705c3036a46de1a0"
    number = get_id(hex)
    print(number)
    assert(number + 1 == number + 1, "The id should be a number")
end

function get_flags_should_return_flags()
    flags = get_flags(header)
    print(flags)
    assert(flags == 6, 'get_flags should return `6`')
end

function get_trace_id_should_get_correct_id()
    id = get_trace_id(header)
    print(id)
    assert(id == -193072714, "The extracted value should have the correct id")
end

function get_span_id_should_get_correct_id()
    id = get_span_id(header)
    assert(id == -993593349, "The extracted value should have the correct id")
end

function get_parent_id_should_get_correct_id()
    id = get_parent_id(header)
    assert(id == -754191, "The extracted value should have the correct id")
end

function build_header_should_return_original_header()
    span_id = get_span_id(header) 
    parent_id = get_parent_id(header) 
    trace_id = get_trace_id(header) 
    flags = get_flags(header)
    new_header = build_header(span_id, parent_id, trace_id, flags)
    print(new_header)
    assert(#new_header == #header, "Both headers should be the same length")
    assert(new_header == header, "The new header and old header should match")
end

get_id_should_return_number()
get_flags_should_return_flags()
get_trace_id_should_get_correct_id()
get_span_id_should_get_correct_id()
get_parent_id_should_get_correct_id()
build_header_should_return_original_header()
