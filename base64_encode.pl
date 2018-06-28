#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  base64_encode.pl
#
#        USAGE:  ./base64_encode.pl  
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#      VERSION:  1.0
#      CREATED:  09/23/2016 06:26:50 AM
#     REVISION:  ---
#===============================================================================

use FindBin qw($Bin);
use lib "$Bin/lib";
use Splunklib::Intersplunk qw(readResults outputResults isGetInfo outputGetInfo);
# GetInfo support
# @ARGV example: "__GETINFO__ field=_raw action=encode"
if (isGetInfo(\@ARGV)) {
   outputGetInfo(undef, \*STDOUT);
   exit(0);
}
 
# @ARGV example: "field=_raw action=encode"
my $field = '_raw';    # Default to encode/decode _raw
my $action = 'encode'; # Default to encode
for my $arg (@ARGV) {
   my ($k, $v) = split(/=/, $arg);
   if    ($k eq 'field')  { $field  = $v; }
   elsif ($k eq 'action') { $action = $v; }
}

my $ary = readResults(\*STDIN, undef, 1);
my $results = $ary->[0];
my $header = $ary->[1];
my $lookup = $ary->[2];
 
use MIME::Base64;
 
for my $result (@$results) {
   if ($action eq 'encode') {
      $result->[$lookup->{$field}] = encode_base64($result->[$lookup->{$field}], '');
   }
   else {
      $result->[$lookup->{$field}] = decode_base64($result->[$lookup->{$field}]);
   }
}
outputResults($ary, undef, 1, '\n', \*STDOUT);
