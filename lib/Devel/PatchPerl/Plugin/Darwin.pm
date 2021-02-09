package Devel::PatchPerl::Plugin::Darwin;

require Devel::PatchPerl;

use strict;
use warnings;

my @patch = (
    {
	perl => [ qw/5.8.9 5.10.1 5.11.0/, qr/^5\.9\.[0-5]$/ ],
	subs => [ [ \&_patch_darwin_locale_test589 ] ],
    },
    {
	perl => [ qr/^5\.11\.[1-5]$/, qr/^5\.12\.[0-4]/, '5.13.0' ],
	subs => [ [ \&_patch_darwin_locale_test5111 ] ],
    },
    {
	perl => [ '5.12.5', qr/^5\.14\.[0-4]/ ],
	subs => [ [ \&_patch_darwin_locale_test5125 ] ],
    },
    {
	perl => [ qr/^5\.13\.[1-9]$/, qr/^5\.13\.(10|11)/ ],
	subs => [ [ \&_patch_darwin_locale_test5131 ] ],
    },
    {
	perl => [ qr/^5\.15\.[0-7]$/ ],
	subs => [ [ \&_patch_darwin_locale_test5150 ] ],
    },
    {
	perl => [ qr/^5\.15\.[89]$/, qr/^5\.16\.[0-3]$/, qr/^5\.17\.\d+/, qr/^5\.18\.[0-4]$/, qr/^5\.19\.[0-8]/ ],
	subs => [ [ \&_patch_darwin_locale_test5158 ] ],
    },
    {
	perl => [ qr/^5\.22\.[34]$/ ],
	subs => [ [ \&_patch_darwin_customized_dat5223 ] ],
    },
    {
	perl => [ qr/^5\.22\.[0-4]$/, qr/^5\.23\.[0-9]$/, qr/^5\.24\.[0-4]$/ ],
	subs => [ [ \&_patch_darwin_libperl_test5230 ] ],
    },
    {
	perl => [ qr/^5\.24\.[1-4]$/ ],
	subs => [ [ \&_patch_darwin_customized_dat5241 ] ],
    },
    {
	perl => [ qr/^5\.25\.]d+/, qr/^5\.26\.[0-3]$/, qr/^5\.27\.\d+/, qr/^5\.28\.[0-3]$/ ],
	subs => [ [ \&_patch_darwin_libperl_test5250 ] ],
    },
);

sub patchperl {
    my $class = shift;
    my %args = @_;
    my ($vers, $source, $patchexe) = @args{'version', 'source', 'patchexe'};
    for my $p ( grep { Devel::PatchPerl::_is( $_->{perl}, $vers ) } @patch) {
	for my $s (@{$p->{subs}}) {
	    my($sub, @args) = @$s;
	    push @args, $vers unless scalar @args;
	    $sub->(@args);
	}
    }
}

sub _patch_darwin_locale_test589 {
    my $patch = <<'END';
--- lib/locale.t
+++ lib/locale.t
@@ -460,6 +460,9 @@ if ($^O eq 'darwin') {
     if ($v >= 8 and $v < 10) {
 	debug "# Skipping eu_ES, be_BY locales -- buggy in Darwin\n";
 	@Locale = grep ! m/^(eu_ES|be_BY.CP1131$)/, @Locale;
+    } else {
+	debug "# Skipping be_BY locales -- buggy in Darwin\n";
+	@Locale = grep ! m/^be_BY\.CP1131$/, @Locale;
     }
 }
END
    Devel::PatchPerl::_patch($patch);
}

sub _patch_darwin_locale_test5111 {
    my $patch = <<'END';
--- lib/locale.t
+++ lib/locale.t
@@ -460,7 +460,7 @@ if ($^O eq 'darwin') {
     if ($v >= 8 and $v < 10) {
 	debug "# Skipping eu_ES, be_BY locales -- buggy in Darwin\n";
 	@Locale = grep ! m/^(eu_ES|be_BY\.CP1131)$/, @Locale;
-    } elsif ($v < 11) {
+    } else {
 	debug "# Skipping be_BY locales -- buggy in Darwin\n";
 	@Locale = grep ! m/^be_BY\.CP1131$/, @Locale;
     }
END
    Devel::PatchPerl::_patch($patch);
}

sub _patch_darwin_locale_test5125 {
    my $patch = <<'END';
--- lib/locale.t
+++ lib/locale.t
@@ -460,7 +460,7 @@ if ($^O eq 'darwin') {
     if ($v >= 8 and $v < 10) {
 	debug "# Skipping eu_ES, be_BY locales -- buggy in Darwin\n";
 	@Locale = grep ! m/^(eu_ES(?:\..*)?|be_BY\.CP1131)$/, @Locale;
-    } elsif ($v < 13) {
+    } else {
 	debug "# Skipping be_BY locales -- buggy in Darwin\n";
 	@Locale = grep ! m/^be_BY\.CP1131$/, @Locale;
     }
END
    Devel::PatchPerl::_patch($patch);
}

sub _patch_darwin_locale_test5131 {
    my $patch = <<'END';
--- lib/locale.t
+++ lib/locale.t
@@ -460,7 +460,7 @@ if ($^O eq 'darwin') {
     if ($v >= 8 and $v < 10) {
 	debug "# Skipping eu_ES, be_BY locales -- buggy in Darwin\n";
 	@Locale = grep ! m/^(eu_ES(?:\..*)?|be_BY\.CP1131)$/, @Locale;
-    } elsif ($v < 11) {
+    } else {
 	debug "# Skipping be_BY locales -- buggy in Darwin\n";
 	@Locale = grep ! m/^be_BY\.CP1131$/, @Locale;
     }
END
    Devel::PatchPerl::_patch($patch);
}

sub _patch_darwin_locale_test5150 {
    my $patch = <<'END';
--- lib/locale.t
+++ lib/locale.t
@@ -460,7 +460,7 @@ if ($^O eq 'darwin') {
     if ($v >= 8 and $v < 10) {
 	debug "# Skipping eu_ES, be_BY locales -- buggy in Darwin\n";
 	@Locale = grep ! m/^(eu_ES(?:\..*)?|be_BY\.CP1131)$/, @Locale;
-    } elsif ($v < 12) {
+    } else {
 	debug "# Skipping be_BY locales -- buggy in Darwin\n";
 	@Locale = grep ! m/^be_BY\.CP1131$/, @Locale;
     }
END
    Devel::PatchPerl::_patch($patch);
}

sub _patch_darwin_locale_test5158 {
    my $patch = <<'END';
--- lib/locale.t
+++ lib/locale.t
@@ -648,7 +648,7 @@ if ($^O eq 'darwin') {
     if ($v >= 8 and $v < 10) {
 	debug "# Skipping eu_ES, be_BY locales -- buggy in Darwin\n";
 	@Locale = grep ! m/^(eu_ES(?:\..*)?|be_BY\.CP1131)$/, @Locale;
-    } elsif ($v < 12) {
+    } else {
 	debug "# Skipping be_BY locales -- buggy in Darwin\n";
 	@Locale = grep ! m/^be_BY\.CP1131$/, @Locale;
     }
END
    Devel::PatchPerl::_patch($patch);
}

sub _patch_darwin_libperl_test5230 {
   my $patch = <<'END';
--- t/porting/libperl.t
+++ t/porting/libperl.t
@@ -550,7 +550,7 @@ if (defined $nm_err_tmp) {
         while (<$nm_err_fh>) {
             # OS X has weird error where nm warns about
             # "no name list" but then outputs fine.
-            if (/nm: no name list/ && $^O eq 'darwin') {
+            if ((/nm: no name list/ || /^no symbols$/) && $^O eq 'darwin') {
                 print "# $^O ignoring $nm output: $_";
                 next;
             }
END
    Devel::PatchPerl::_patch($patch);
}

sub _patch_darwin_customized_dat5223 {
    my $patch = <<'END';
--- t/porting/customized.dat
+++ t/porting/customized.dat
@@ -20,7 +20,7 @@ ExtUtils::Command cpan/ExtUtils-Command/
 ExtUtils::MakeMaker cpan/ExtUtils-MakeMaker/bin/instmodsh 5bc04a0173b8b787f465271b6186220326ae8eef
 ExtUtils::MakeMaker cpan/ExtUtils-MakeMaker/lib/ExtUtils/Command/MM.pm 6298f9b41b29e13010b185f64fa952570637fbb4
 ExtUtils::MakeMaker cpan/ExtUtils-MakeMaker/lib/ExtUtils/Liblist.pm 6e16329fb4d4c2f8db4afef4d8e79c1c1c918128
-ExtUtils::MakeMaker cpan/ExtUtils-MakeMaker/lib/ExtUtils/Liblist/Kid.pm fc0483c5c7b92a8e0f63eb1f762172cddce5b948
+ExtUtils::MakeMaker cpan/ExtUtils-MakeMaker/lib/ExtUtils/Liblist/Kid.pm 9239e2140e8d78d2d70802eff7ff07cb147bf0c6
 ExtUtils::MakeMaker cpan/ExtUtils-MakeMaker/lib/ExtUtils/MakeMaker.pm 8d1b35fcd7d3b4f0552ffb151baf75ccb181267b
 ExtUtils::MakeMaker cpan/ExtUtils-MakeMaker/lib/ExtUtils/MakeMaker/Config.pm 676b10e16b2dc68ba21312ed8aa4d409e86005a6
 ExtUtils::MakeMaker cpan/ExtUtils-MakeMaker/lib/ExtUtils/MakeMaker/FAQ.pod 757bffb47857521311f8f3bde43ebe165f8d5191
END
    Devel::PatchPerl::_patch($patch);
}

sub _patch_darwin_customized_dat5241 {
    my $patch = <<'END';
--- t/porting/customized.dat
+++ t/porting/customized.dat
@@ -22,7 +22,7 @@ ExtUtils::MakeMaker cpan/ExtUtils-MakeMa
 ExtUtils::MakeMaker cpan/ExtUtils-MakeMaker/lib/ExtUtils/Command.pm e3a372e07392179711ea9972087c1105a2780fad
 ExtUtils::MakeMaker cpan/ExtUtils-MakeMaker/lib/ExtUtils/Command/MM.pm b72721bd6aa9bf7ec328bda99a8fdb63cac6114d
 ExtUtils::MakeMaker cpan/ExtUtils-MakeMaker/lib/ExtUtils/Liblist.pm 0e1e4c25eddb999fec6c4dc66593f76db34cfd16
-ExtUtils::MakeMaker cpan/ExtUtils-MakeMaker/lib/ExtUtils/Liblist/Kid.pm bfd2aa00ca4ed251f342e1d1ad704abbaf5a615e
+ExtUtils::MakeMaker cpan/ExtUtils-MakeMaker/lib/ExtUtils/Liblist/Kid.pm 47d2fdf890d7913ccd0e32b5f98a98f75745d227
 ExtUtils::MakeMaker cpan/ExtUtils-MakeMaker/lib/ExtUtils/MakeMaker.pm 5529ae3064365eafd99536621305d52f4ab31b45
 ExtUtils::MakeMaker cpan/ExtUtils-MakeMaker/lib/ExtUtils/MakeMaker/Config.pm bc88b275af73b8faac6abd59a9aad3f625925810
 ExtUtils::MakeMaker cpan/ExtUtils-MakeMaker/lib/ExtUtils/MakeMaker/FAQ.pod 062e5d14a803fbbec8d61803086a3d7997e8a473
END
    Devel::PatchPerl::_patch($patch);
}

sub _patch_darwin_libperl_test5250 {
    my $patch = <<'END';
--- t/porting/libperl.t
+++ t/porting/libperl.t
@@ -574,7 +574,7 @@ if (defined $nm_err_tmp) {
         while (<$nm_err_fh>) {
             # OS X has weird error where nm warns about
             # "no name list" but then outputs fine.
-            if (/nm: no name list/ && $^O eq 'darwin') {
+            if ((/nm: no name list/ || /^no symbols$/) && $^O eq 'darwin') {
                 print "# $^O ignoring $nm output: $_";
                 next;
             }
END
    Devel::PatchPerl::_patch($patch);
}

1;

__END__

=head1 NAME

Devel::PatchPerl::Plugin::Darrwin - patchperl plugin for darwin

=head1 SYNOPSIS

    export PERL5_PATCHPERL_PLUGIN=Darwin
    perlbrew install 5.8.9

=head1 DESCRIPTION

This module is a patchperl plugin for avoiding failure of test on MacOSX(Darwin)

Currently support perl version is bellow.

=item * 5.8.9

=item * 5.10.1

=head1 AUTHOR

gucchisk

=head1 REPOSITORY

L<https://github.com/gucchisk/devel-patchperl-plugin-darwin>
