# Devel::PatchPerl::Plugin::Darwin

## Support
* perl-5.32.1
* perl-5.30.3
* perl-5.28.3
* perl-5.26.3
* perl-5.24.4
* perl-5.22.4
* perl-5.20.3
* perl-5.18.4
* perl-5.16.3
* perl-5.14.4
* perl-5.12.5
* perl-5.10.1
* perl-5.8.9
* perl-5.6.2

## Install (for perlbrew)

```
$ cpanm -S git://github.com/gucchisk/devel-patchperl-plugin-darwin.git
```

## Use Plugin

```
$ export PERL5_PATCHPERL_PLUGIN=Darwin
```

## Development

### Test
```
$ perl Build.PL
$ ./Build test
```

### Release
```
$ shipit
```
See [.shipit](.shipit)
