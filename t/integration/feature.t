=head1 NAME

t/integration/feature.t - integration tests for feature URLs

=head1 DESCRIPTION

Tests for feature URLs

=head1 AUTHORS

Jonathan "Duke" Leto

=cut

use strict;
use warnings;
use Test::More;
use lib 't/lib';
use SGN::Test;
use SGN::Test::WWW::Mechanize;

my $base_url = $ENV{SGN_TEST_SERVER};
my $mech = SGN::Test::WWW::Mechanize->new;

$mech->get_ok("$base_url/feature/search");
$mech->content_contains('Feature Search');
$mech->content_contains('Feature Name');
$mech->content_contains('Feature Type');
$mech->submit_form_ok({
    form_name => 'feature_search_form',
    fields => {
        feature_name => '',
        feature_type => 1,
        organism     => 'Solanum lycopersicum',
        submit       => 'Submit',
    }
});
$mech->content_contains('Search Results');
$mech->content_like(qr/results \d+-\d+ of \d+(,\d+)?/);


$mech->get("$base_url/feature/search");
$mech->submit_form_ok({
    form_name => 'feature_search_form',
    fields => {
        feature_name => 'rbuels_is_3leet',
        feature_type => '',
        organism     => 'Solanum lycopersicum',
        submit       => 'Submit',
    }
});
$mech->content_contains('Search Results');
$mech->content_contains('no matching results found');


$mech->get_ok("$base_url/feature/view/name/JUNK.fasta");
$mech->content_contains("feature with name = 'JUNK' not found");

$mech->get_ok("$base_url/feature/view/id/-1.fasta");
$mech->content_contains("feature with feature_id = '-1' not found");

$mech->get_ok("$base_url/feature/view/name/JUNK");
$mech->content_contains("feature with name = 'JUNK' not found");

$mech->get_ok("$base_url/feature/view/id/-1");
$mech->content_contains("feature with feature_id = '-1' not found");

$mech->get_ok("$base_url/feature/view/id/JUNK.fasta");
$mech->content_contains("JUNK is not a valid value for feature_id");

$mech->get_ok("$base_url/feature/view/id/JUNK");
$mech->content_contains("JUNK is not a valid value for feature_id");

done_testing;