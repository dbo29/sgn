
=head1 DESCRIPTION
A script for downloading population 
genotype raw data in a tab delimited format.

=head1 AUTHOR(S)

Isaak Y Tecle (iyt2@cornell.edu)

=cut

use strict;

use CXGN::Phenome::Population;
use CGI;

use CatalystX::GlobalContext qw( $c );

my $cgi           = CGI->new();
my $population_id = $cgi->param('population_id');
my $dbh           = $c->dbc->dbh;
my $pop           = CXGN::Phenome::Population->new( $dbh, $population_id );
my $name          = $pop->get_name();
my $g_file        = $pop->genotype_file($c);


if (-e $g_file) {

    print $cgi->header(
	-type => 'application/x-download',
	-attachment => "genotype_data_${population_id}.txt",
	);

    print "Genotype data for $name\n\n\n";
 
    open my $f, "<$g_file" or die "can't open file $g_file: $!\n";
    my $markers  = <$f>;
    my $linkages = <$f>;
    my $pos      = <$f>;
    
    foreach my $row ($markers, $linkages, $pos) {
	$row =~ s/,/\t/g;
	print $row;
    } 

### genotype code substitution needs to be modified when QTL analysis 
### is enabled for 4-way cross population

    while (my $genotype=<$f>) {
	$genotype =~ s/,1/\ta/g;
	$genotype =~ s/,2/\th/g;
	$genotype =~ s/,3/\tb/g;
	$genotype =~ s/,4/\td/g;
	$genotype =~ s/,5/\tc/g;
	$genotype =~ s/,NA/\tNA/g;
    
	print "$genotype";
    }

}
else {
     print $cgi->header ('text/plain');   
     print "No genotype data file found for this population";
    
}


