#!/usr/bin/perl
#
# $Id: makesym.perl,v 1.7 2009-02-06 03:48:27 zeus Exp $
#
# Read output file from as86 (e.g. rombios.txt) and write out a symbol
# table suitable for the Bochs debugger.
#

$WHERE_BEFORE_SYM_TABLE = 0;
$WHERE_IN_SYM_TABLE = 1;
$WHERE_AFTER_SYM_TABLE = 2;

$where = $WHERE_BEFORE_SYM_TABLE;
while (<STDIN>) {
  chop;
  if ($where == WHERE_BEFORE_SYM_TABLE && /^Symbols:/) {
    $where = $WHERE_IN_SYM_TABLE;
  } elsif ($where == $WHERE_IN_SYM_TABLE && /^$/) {
    $where = $WHERE_AFTER_SYM_TABLE;
  }
  if ($where == $WHERE_IN_SYM_TABLE) {
    @F = split (/\s+/);
    ($name[0], $junk, $addr[0], $junk, $name[1], $junk, $addr[1]) = @F;
    foreach $col (0,1) {
      next if length $addr[$col] < 1;
      $addr[$col] =~ tr/A-Z/a-z/;
      $addr[$col] = "000f" . $addr[$col];
      print "$addr[$col] $name[$col]\n";
    }
  }
}
