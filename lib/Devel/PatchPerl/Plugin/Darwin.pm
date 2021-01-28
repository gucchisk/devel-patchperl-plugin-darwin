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
