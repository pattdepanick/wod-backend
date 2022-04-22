#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use File::Find;

our $maptable;
eval { require "$ENV{'HOME'}/jupyter-procmail/scripts/mapping.cfg.pl"; };
if ($@) {
    print("Config file not found: mapping.cfg.pl\n");
    exit(-1);
}
print("Hash is:\n");
print(Dumper($maptable));

my @maptable = @$maptable;

my $dirname = $ARGV[0];

if ((not defined $dirname) || (! -d $dirname )) {
    print("Directory not found: $dirname\n") if (defined $dirname);
    print("Syntax: rebranding.pl dirname\n");
    exit(-1);
}

# Recurse from directory passed in parameter
finddepth({ wanted => \&recurse1, no_chdir => 1},$dirname);

sub recurse1 {

   my $filename = $File::Find::name;

   return if (-d $filename);
   return if ($filename =~ /\/.git\//);
   print("Handling $filename\n");
   # Get all content into $text
   my $sep = $/;
   my $text = "";
   $/ = undef;
   if (open(FILE, "$filename")) {
      $text = <FILE>;
      close(FILE);
   } else {
      print "could not open $filename: $!";
      return;
   }
   $/ = $sep;
   # subsitute using external hash  
   foreach my $elt (@maptable) {
      foreach my $key (keys %$elt) {
        #print "Substitue string **$key** by **$elt->{$key}**\n";
        $text =~ s/$key/$elt->{$key}/g;
      }
   }
   open(FILE, "> $filename") || (print "could not write into $filename: $!" && return);
   print FILE $text;
   close(FILE);
}
