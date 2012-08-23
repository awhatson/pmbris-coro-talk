#!/usr/bin/env perl
use Modern::Perl;
use Coro;

# The "async" thread:
async {
   say 'async 1';
   cede;
   say 'async 2';
};

# The "main" thread:
say 'main 1';
cede;
say 'main 2';
cede;
