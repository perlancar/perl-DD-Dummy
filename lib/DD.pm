## no critic: Modules::ProhibitAutomaticExportation

package DD;

# AUTHORITY
# DATE
# DIST
# VERSION

use Exporter qw(import);
our @EXPORT = qw(dd dd_warn dd_die dmp);

our $BACKEND = $ENV{PERL_DD_BACKEND} || "Data::Dump";

our $_action;

sub _doit {
    if ($BACKEND eq 'Data::Dump') {
        require Data::Dump;
        if    ($_action eq 'dd'     ) { print  Data::Dump::dump(@_). "\n"; return @_ }
        elsif ($_action eq 'dd_warn') { warn   Data::Dump::dump(@_). "\n"; return @_ }
        elsif ($_action eq 'dd_die' ) { die    Data::Dump::dump(@_). "\n"            }
        elsif ($_action eq 'dmp'    ) { return Data::Dump::dump(@_)                  }
    } elsif ($BACKEND eq 'Data::Dump::Color') {
        require Data::Dump::Color;
        if    ($_action eq 'dd'     ) { print  Data::Dump::Color::dump(@_). "\n"; return @_ }
        elsif ($_action eq 'dd_warn') { warn   Data::Dump::Color::dump(@_). "\n"; return @_ }
        elsif ($_action eq 'dd_die' ) { die    Data::Dump::Color::dump(@_). "\n"            }
        elsif ($_action eq 'dmp'    ) { return Data::Dump::Color::dump(@_)                  }
    } elsif ($BACKEND eq 'Data::Dumper') {
        require Data::Dumper;
        local $Data::Dumper::Terse     = 1;
        local $Data::Dumper::Indent    = 1;
        local $Data::Dumper::Useqq     = 1;
        local $Data::Dumper::Deparse   = 1;
        local $Data::Dumper::Quotekeys = 0;
        local $Data::Dumper::Sortkeys  = 1;
        if    ($_action eq 'dd'     ) { print  Data::Dumper::Dumper(@_); return @_ }
        elsif ($_action eq 'dd_warn') { warn   Data::Dumper::Dumper(@_); return @_ }
        elsif ($_action eq 'dd_die' ) { die    Data::Dumper::Dumper(@_)            }
        elsif ($_action eq 'dmp'    ) { return Data::Dumper::Dumper(@_)            }
    } elsif ($BACKEND eq 'Data::Dmp') {
        require Data::Dmp;
        if    ($_action eq 'dd'     ) { goto  &Data::Dmp::dd                      }
        elsif ($_action eq 'dd_warn') { warn   Data::Dmp::dmp(@_)."\n"; return @_ }
        elsif ($_action eq 'dd_die' ) { warn   Data::Dmp::dmp(@_)."\n"; return @_ }
        elsif ($_action eq 'dmp'    ) { goto  &Data::Dmp::dmp                     }
    } else {
        die "DD: Unknown backend '$BACKEND'";
    }
}

sub dd      { $_action = 'dd';      goto &_doit }
sub dd_warn { $_action = 'dd_warn'; goto &_doit }
sub dd_die  { $_action = 'dd_die';  goto &_doit }
sub dmp     { $_action = 'dmp';     goto &_doit }

1;
# ABSTRACT: Dump data structure for debugging

=head1 SYNOPSIS

To install this module, currently do:

 % cpanm -n DD::Dummy

In your code:

 use DD; # exports dd(), dd_warn(), dd_die(), dmp()
 ...
 dd $data                ; # prints data to STDOUT, return argument
 my $foo = dd $data      ; # ... so you can use it inside expression
 my $foo = dd_warn $data ; # just like dd() but warns instead
 dd_die $data            ; # just like dd() but dies instead

 my $dmp = dmp $data     ; # dump data as string and return it

On the command-line:

 % perl -MDD -E'...; dd $data; ...'


=head1 DESCRIPTION

C<DD> is a module with a short name you can use for debugging. It provides
L</dd> which dumps data structure to STDOUT, as well as return the original data
so you can insert C<dd> in the middle of expressions. It also provides
L</dd_warn>, L</dd_die>, as well as L</dmp> for completeness.

C<DD> can use several kinds of backends. The default is L<Data::Dump> which is
chosen because it's a mature module and produces visually nice dumps for
debugging. You can also use these other backends:

=over

=item * Data::Dmp

Optional dependency.

=item * Data::Dump::Color

Optional dependency.

=item * Data::Dumper

=back


=head1 FUNCTIONS

=head2 dd

Print the dump of its arguments to STDOUT, and return its arguments.

=head2 dd_warn

Warn the dump of its arguments, and return its arguments. If you want a full
stack trace, you can use L<Devel::Confess>, e.g. on the command-line:

 % perl -d:Confess -MDD -E'... dd_warn $data;'

=head2 dd_die

Die with the dump of its arguments as message. If you want a full stack trace,
you can use L<Devel::Confess>, e.g. on the command-line:

 % perl -d:Confess -MDD -E'... dd_die $data;'

=head2 dmp

Dump its arguments as string and return it.


=head1 PACKAGE VARIABLES

=head2 $BACKEND

The backend to use. The default is to use L</PERL_DD_BACKEND> environment
variable or "Data::Dump" as the fallback default.


=head1 ENVIRONMENT

=head2 PERL_DD_BACKEND

Can be used to set the default backend.


=head1 SEE ALSO

L<XXX> - basically the same thing but with different function names and
defaults. I happen to use "XXX" to mark todo items in source code, so I prefer
other names.
