  use Parse::CPAN::Meta;
    my $distmeta = Parse::CPAN::Meta->load_file('config.yml');
    # Reading properties
    my $name     = $distmeta->{name};
    my $version  = $distmeta->{version};
    my $homepage = $distmeta->{resources}{homepage};