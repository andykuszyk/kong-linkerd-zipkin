require 'linkerd'

function test_get_id_should_return_correct_long()
    id = get_id('AAAAAAAABNI=')

    assert(id == 1234, 'get_id should decode the base64 value to 1234')
end

function test_encode_produces_base64()
    encoded = encode(1234)
    print(encoded)
    assert(encoded == 'AAAAAAAABNI=', 'encode should base64 encode the value')
end

test_get_id_should_return_correct_long()
test_encode_produces_base64()
