use warnings;
use Test::WWW::Selenium;
use Test::More tests=>5;

my $sel = Test::WWW::Selenium->new( host => "localhost",
			      port => 4444,
			      browser => "*firefox",
			      browser_url => "http://sgn.localhost.localdomain/sequencing/sol100.pl",
				    default_names => 1,
				    
                            );


$sel->start;
$sel->open_ok("http://sgn.localhost.localdomain/sequencing/sol100.pl");

#---- type "Solanum lycopersicum" in the "species" field ----#
$sel->type_ok("species","Solanum lycopersicum");

#---- click "update result" button on page ----#
$sel->click_ok("update_result");
#$sel->wait_for_page_to_load_ok(10000);

sleep(2);

#---- get the results from the "result_space" div ----#
$sel->get_text_ok("result_space");

my $body = $sel->get_body_text();

like($body, qr/Solanum/, "Solanum string presence test");
$sel->stop;
