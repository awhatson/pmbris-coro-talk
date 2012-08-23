#!/usr/bin/env perl
use Modern::Perl;
use AnyEvent;

$| = 1; print "enter your name> ";

my $name;
my $ready = AnyEvent->condvar;

my $wait_for_input = AnyEvent->io(
	fh   => \*STDIN,          # the file handle to watch
	poll => 'r',              # watch for read events
	cb   => sub {             # Callback:
      $name = <STDIN>;        #  retrieve a line of input
	  chomp $name;            #  clean up that pesky newline
      $ready->send;           #  send the "ready" signal
   }
);

# DO OTHER STUFF

$ready->recv;                 # wait for the "ready" signal
undef $wait_for_input;        # clean up the IO watcher
say "your name is $name";
