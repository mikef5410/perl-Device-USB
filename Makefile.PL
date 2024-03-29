use strict;
use warnings;
use Inline::MakeMaker;

if($^O eq 'MSWin32')
{
    if(!$ENV{LIBUSB_LIBDIR} or !$ENV{LIBUSB_INCDIR})
    {
        die <<'END';
ERROR: Missing required environment variables to compile under Windows.

    LIBUSB_LIBDIR should contain the path to the libusb libraries
    LIBUSB_INCDIR should contain the path to the libusb include files

END
    }
}

unless(header_found())
{
    die <<"END";
ERROR: Can't find usb.h header.

If the library is not installed, you will need to install it. If it is
installed somewhere other than /usr or /usr/local, you need to set the
following environment variables:

    LIBUSB_LIBDIR should contain the path to the libusb libraries
    LIBUSB_INCDIR should contain the path to the libusb include files

END
}

unless(lib_found())
{
    die <<"END";
ERROR: Can't find libusb library.

If the library is not installed, you will need to install it. If it is
installed somewhere other than /usr or /usr/local, you need to set the
following environment variables:

    LIBUSB_LIBDIR should contain the path to the libusb libraries
    LIBUSB_INCDIR should contain the path to the libusb include files

END
}

WriteMakefile(
    NAME                => 'Device::USB',
    AUTHOR              => 'G. Wade Johnson <wade@anomaly.org>',
    VERSION_FROM        => 'lib/Device/USB.pm',
    ABSTRACT_FROM       => 'lib/Device/USB.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
	'Inline' => 0,
	'Inline::C' => 0,
	'Inline::MakeMaker' => 0,
	'Carp' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => {
        FILES => 'Device-USB-* USB.inl _Inline'
    },
);


sub header_found
{
    foreach my $dir (qw(/usr/include /usr/local/include), $ENV{LIBUSB_INCDIR})
    {
        return 1 if defined $dir && -e "$dir/usb.h";
    }

    return;
}

sub lib_found
{
    foreach my $dir (qw(/usr/local/lib64 /usr/lib64 /lib64 /usr/lib /usr/local/lib),
                     $ENV{LIBUSB_LIBDIR})
    {
        return 1 if defined $dir && ($^O =~ /win/i ? (-e "$dir/libusb.lib" || -e "$dir/libusb.a") : -e "$dir/libusb.so") ;
    }

    return;
}
