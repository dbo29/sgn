
use strict;
use warnings;
use Test::More qw | no_plan |;
use lib 't/lib';
#use SGN::Test;
use SGN::Test::WWW::Mechanize;
use CXGN::DB::Connection;
use Carp qw | verbose |;

my $mech = SGN::Test::WWW::Mechanize->new;

#Tests the general form
&check_basic_parts_are_ok($mech);
my @categories = ("name", "email", "subject");
foreach my $category (@categories)
{
   #$mech->has_tag("input", qr/value="".*?name="$category"/sx, 
   #                  "The form has $category as an input.");
   $mech->content_contains("Your $category", "Check if category was added");
   $mech->has_tag("input", "", "The form has $category as an input.");
}
$mech->has_tag("textarea", qr/name="body"/,
			"The form has textarea to put message.");

#Tests the form if someone has an account, but no email
#my $dbh = CXGN::DB::Connection->new();
#if( my $u_id = CXGN::People::Person->get_person_by_username( $dbh, "testusername" ) ) {
#    CXGN::People::Person->new( $dbh, $u_id )->hard_delete;
#}
#my $p = CXGN::People::Person->new($dbh);
#$p->set_first_name("testfirstname");
#$p->set_last_name("testlastname");
#$p->store();
#$dbh->commit();

#Tests for a user
my %user;
$user{first_name} = "Test";
$user{last_name} = "Tester";
$mech->while_logged_in(\%user, 
sub {
    &check_basic_parts_are_ok($mech);
    $mech->has_tag("input", 
		    qr/value="TestTester".*?name="name"/sx, 
                     "Check if user logs in, name will go on form."); 
});
$user{email} = 'testemail@test.com';
$mech->while_logged_in(\%user, 
sub {
   &check_basic_parts_are_ok($mech);
   $mech->has_tag("input", 
		    qr/value='testemail\@test.com'.*?name="name"/sx, 
                     "Check if user logs in, email will go on the form."); 
});
$user{first_name} = "";
$user{last_name} = "";
$mech->while_logged_in(\%user,
sub {
   &check_basic_parts_are_ok($mech);
   $mech->has_tag("input", 
		    qr/value="".*?name=""/sx, 
                     "Check if user logs in and does not have name, name won't go on."); 
});

my $form_name = "contactForm";
my %entry_for_field = ('name' => 'Test Tester', 
			 'email' => 'test@test.com', 
			   'subject' => 'Testing',
			      'body' => 'Hello World');
my @fields = keys %entry_for_field;
print "Sending complete form from form page\n";
&send_complete_form_and_check($mech, $form_name, %entry_for_field);
$mech->back();
print "Sending empty form from form page\n";
for (my $i = 0; $i < 2; $i++)
{  
   print "Sending empty form from submit page\n" if $i == 1;
   &send_blank_form_and_check($mech, $form_name, @fields);
}
print "Sending full form from submit page\n";
&send_complete_form_and_check($mech, $form_name, %entry_for_field);
$mech->back();
$mech->back();
foreach my $field (@fields)
{
   my $filledEntry = {$field => $entry_for_field{$field}};
   my $testDesc = "Form with $field filled in sent ";
   &test_currently_filled_and_oppositely_filled_forms($mech, $form_name, 
			$field, $filledEntry, $testDesc, %entry_for_field);
   $mech->back();
   $mech->back();
   if ($field ne 'name')
   {
      $$filledEntry{'name'} = $entry_for_field{$field};
      my $testDesc = "Form with name and $field filled in sent ";
      &test_currently_filled_and_oppositely_filled_forms($mech, $form_name, 
			$field, $filledEntry, $testDesc, %entry_for_field);
      delete $$filledEntry{'name'};
      $mech->back();
      $mech->back();
   }
   delete $$filledEntry{$field};
}

sub check_basic_parts_are_ok
{
   my $mech = shift;
   $mech->get_ok("/contact/form", "Check the form page");
   $mech->html_lint_ok("Check form page html");
   #$mech->page_links_ok('Check all links');
   $mech->text_contains("Contact", "Title is there");
}

sub send_complete_form_and_check
{
   my ($mech, $form_name, %entry_for_field) = @_;
   $mech->submit_form_ok({'name'=>$form_name, 'fields'=>\%entry_for_field}, 
			     "Check submitting; filled out form was sent.");
   $mech->text_contains("Thank you. Your message has been sent.", 
			    "See if form is sent successfully");
}

sub send_blank_form_and_check
{
   my ($mech, $form_name, @fields) = @_;
   $mech->submit_form_ok({'name'=>$form_name}, 
			     "Check submitting; Empty form is being sent");
   foreach my $field (@fields)
   {
      $mech->text_like(qr/($field)|(message) is required/i, 
				"$field should show error message"); 
   }
}

sub test_currently_filled_and_oppositely_filled_forms
{
    my ($mech, $form_name, $field, $filledEntry, $testDesc, %entry_for_field) = @_;
    for (my $i = 0; $i < 2; $i++)
    {
       $testDesc =~ s/unfilled/filled in/;
       for (my $j = 0; $j < 2; $j++)
       {

          $mech->submit_form_ok({'name'=>$form_name, 
	  			   'fields'=>$filledEntry}, 
				      $testDesc . "$i time(s)");
          foreach my $otherFields (keys %entry_for_field)
          {
             if ($otherFields ne $field)
             { 
                $mech->text_like(qr/($field)|(message) is required/i, 
				"$field should show error message");
                $$filledEntry{$otherFields} = $entry_for_field{$otherFields}; 
       	     }
             else
             {
	        $mech->text_unlike(qr/($field)|(message) is required/i,					           "$field should not show error message");
                delete $$filledEntry{$field};
             }
          }
          $mech->back() if $j != 1;
          $testDesc =~ s/filled in/unfilled/;
       }
   }
}

done_testing; 