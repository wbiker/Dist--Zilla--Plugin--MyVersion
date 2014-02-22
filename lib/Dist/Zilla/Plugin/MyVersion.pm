use strict;
use warnings;
package Dist::Zilla::Plugin::MyVersion;
# ABSTRACT: Gives back the new version in the x.xx pattern

use Dist::Zilla 4 ();
use version 0.80 ();
use Storable qw(store retrieve);

use Moose;
use namespace::autoclean 0.09;

with 'Dist::Zilla::Role::VersionProvider';

sub provide_version {
    my ($self) = @_;

    # read version from file.
    my $version;
    if(-e 'version.dat') {
        my $hashref = retrieve('version.dat');

        my $old_version = $hashref->{version};
		my ($major, $minor) = split(/\./, $old_version);
		$minor++;
		if('100' eq $minor) {
			$minor = '00';
			$major++;
		}
		$version = $major.'.'.$minor;
		$hashref->{version} = $version;
		store($hashref, 'version.dat');
    }
    else {
        my $hashref = {version => '0.01'};
        store($hashref, 'version.dat') or die "COuld not create version.dat file: $!";
		$version = '0.01';
    }

	return "$version";
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
