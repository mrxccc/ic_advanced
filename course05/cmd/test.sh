#!/usr/bin/ic-repl
identity default "./id1.pem";
import course05 = "rrkah-fqaaa-aaaaa-aaaaq-cai";
call course05.greet("test");
let result = _;
assert _ == "Hello, test!";