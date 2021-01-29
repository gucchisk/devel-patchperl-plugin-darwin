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
