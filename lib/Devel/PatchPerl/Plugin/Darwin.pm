package Devel::PatchPerl::Plugin::Darwin;

require Devel::PatchPerl;

use strict;
use warnings;

my @patch = (
    {
	perl => [ qw/ 5.8.9 5.10.1 / ],
	subs => [ [ \&_patch_darwin_locale_test ] ],
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

sub _patch_darwin_locale_test {
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
