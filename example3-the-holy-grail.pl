#!/usr/bin/env perl
use Modern::Perl;
use AnyEvent;
use AnyEvent::HTTP   qw(http_get);
use Time::HiRes      qw(time);
use Coro             qw(async rouse_cb rouse_wait);

my $global_start = time;

my @urls = qw(
	http://xkcd.com      http://perlsphere.net    http://news.ycombinator.com
	http://slashdot.org  http://planet6.perl.org  http://reddit.com/r/cyberpunk
);

my @threads = ();

for (1 .. 5) {                           # ed: moar threads!
	for my $url (@urls) {
		push @threads, async {           # create a new thread for each URL

			my $start = time;
			my $page = get_url($url);

			printf "got %-30s (%fs)\n", $url, time - $start;

		};
	}
}

$_->join for @threads;                   # wait until all threads have finished

printf "got %-30s (%fs)\n", 'everything!', time - $global_start;

sub get_url {
	my $url = shift;

	my $cv = AnyEvent->condvar;          # ed: the nuts'n'bolts version
	my $cb = sub {
		my ($data, $headers) = @_;
		$cv->send($data, $headers);
	};

	http_get($url, $cb);
	#http_get($url, rouse_cb);           # cede until ready

	my ($data, $headers) = $cv->recv;
	#my ($data, $headers) = rouse_wait;  # wait and retrieve results

	return $data;
}
