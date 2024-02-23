#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use Getopt::Long;

# SYNOPSIS
#    Request SenHub API
# DESCRIPTION
#    This script uses the LWP::UserAgent library for Perl
#    Output: 0 Service OK
#            2 Critical
#            3 Unknown
# PARAMETER
#    senhub-endpoint: SenHub URL as a command-line argument (--senhub-endpoint)
#
# NOTES
#    1.1
#        First version
#        support@sensorfactory.eu
#        29/09/2021
#        Alexis (Adapted for Perl with command-line parameter support)

my $senhub_endpoint = '';
GetOptions('senhub-endpoint=s' => \$senhub_endpoint);

if (!$senhub_endpoint) {
    print "Wrong or no parameter provided. Use --senhub-endpoint to specify the SenHub URL.\n";
    exit(2);
}

sub http_request {
    my ($url) = @_;
    my $ua = LWP::UserAgent->new;
    my $response = $ua->get($url);

    if ($response->is_success) {
        my $result = $response->decoded_content;
        
        if ($result =~ /^OK/) {
            print "$result\n";
            exit(0);
        }
        elsif ($result =~ /^KO/ || $result =~ /^CRITICAL/) {
            print "$result\n";
            exit(2);
        }
        elsif ($result =~ /^UNKNOWN/) {
            print "$result\n";
            exit(3);
        }
        elsif ($result =~ /^WARNING/) {
            print "$result\n";
            exit(1);
        }
        else {
            print "$result\n";
            exit(3);
        }
    }
    else {
        print "HTTP GET error: ", $response->status_line, "\n";
        exit(3);
    }
}

# Main execution
eval {
    http_request($senhub_endpoint);
};
if ($@) {
    print "An error occurred: $@\n";
    exit(2);
}

