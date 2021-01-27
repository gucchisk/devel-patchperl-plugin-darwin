use Test::More;
use File::Temp;
use File::Fetch;
use File::Path;
use Archive::Tar;
use Devel::PatchPerl;
use Devel::PatchPerl::Hints qw[hint_file];

my $os = $^O;
my $version = '5.8.9';

$ENV{PERL5_PATCHPERL_PLUGIN} = 'Darwin';

my $stderr;
open my $stdtmp, '>&', STDERR;
close STDERR;
open STDERR, '>', \$stderr;

my $temp = File::Temp->newdir();
my $url = "http://www.cpan.org/src/5.0/perl-$version.tar.gz";
my $ff = File::Fetch->new(uri => $url);
my $targz = $ff->fetch( to => $temp->dirname ) or die $ff->error();
my $tar = Archive::Tar->new($targz) or die;
$tar->setcwd($temp->dirname);
$tar->extract or die;
my $srcdir = $temp->dirname . "/perl-$version";
my $result = Devel::PatchPerl->patch_source($version, $srcdir);

close STDERR;
open STDERR, '>&', $stdtmp;
close $stdtmp;

my ($file, $data) = hint_file($os);

is($result, 1, 'test result');
is($stderr, "Patching 'hints/$file'\n", 'stderr');

done_testing();
