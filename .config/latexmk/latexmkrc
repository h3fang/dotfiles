add_cus_dep( 'nlo', 'nls', 0, 'makenlo2nls' );
sub makenlo2nls {
 my $filename  = basename $_[0];
 system( "cd \"$out_dir\"; makeindex -s nomencl.ist -o \"$filename.nls\"    \"$filename.nlo\"" );
}

