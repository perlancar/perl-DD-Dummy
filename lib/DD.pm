## no critic: Modules::ProhibitAutomaticExportation

package DD;

# DATE
# VERSION

use Exporter qw(import);
our @EXPORT = qw(dd dmp);

our $BACKEND = $ENV{PERL_DD_BACKEND} || "Data::Dump";

our $is_dd;

sub _dd_or_dmp {
    if ($BACKEND eq 'Data::Dump') {
        require Data::Dump;
        if ($is_dd) {
            print Data::Dump::dump(@_), "\n";
            return @_;
        } else {
            return Data::Dump::dump(@_);
        }
    } elsif ($BACKEND eq 'Data::Dump::Color') {
        require Data::Dump::Color;
        if ($is_dd) {
            print Data::Dump::Color::dump(@_), "\n";
            return @_;
        } else {
            return Data::Dump::Color::dump(@_);
        }
    } elsif ($BACKEND eq 'Data::Dumper') {
        require Data::Dumper;
        local $Data::Dumper::Terse = 1;
        local $Data::Dumper::Indent = 1;
        local $Data::Dumper::Useqq = 1;
        local $Data::Dumper::Deparse = 1;
        local $Data::Dumper::Quotekeys = 0;
        local $Data::Dumper::Sortkeys = 1;
        if ($is_dd) {
            print Data::Dumper::Dumper(@_);
            return @_;
        } else {
            return Data::Dumper::Dumper(@_);
        }
    } elsif ($BACKEND eq 'Data::Dmp') {
        require Data::Dmp;
        if ($is_dd) {
            goto \&Data::Dmp::dd;
        } else {
            goto \&Data::Dmp::dmp;
        }
    } else {
        die "DD: Unknown backend '$BACKEND'";
    }
}

sub dd {
    local $is_dd = 1;
    goto &_dd_or_dmp;
}

sub dmp {
    local $is_dd = 0;
    goto &_dd_or_dmp;
}

1;
# ABSTRACT: Dump data structure for debugging

=head1 SYNOPSIS

In your code:

 use DD; # exports dd() and dmp()
 ...
 dd $data; # prints data to STDOUT
 ...
 my $foo = dd $data; # prints data to STDOUT, also returns it so $foo gets assigned

On the command-line:

 % perl -MDD -E'...; dd $data; ...'


=head1 DESCRIPTION

C<DD> is a module with a short name you can use for debugging. It provides
C<dd()> which dumps data structure to STDOUT, as well as return the original
data so you can insert C<dd> in the middle of expressions.

C<DD> can use several kinds of backends. The default is L<Data::Dump> which is
chosen because it's a mature module and produces visually nice dumps for
debugging. You can also use these other backends:

=over

=item * Data::Dumper

=item * Data::Dump::Color

Optional dependency.

=item * Data::Dmp

Optional dependency.

=back


=head1 FUNCTIONS

=head2 dd

=head2 dmp


=head1 PACKAGE VARIABLES

=head2 $BACKEND

The backend to use. The default is to use C<PERL_DD_BACKEND> environment
variable or "Data::Dump" as the fallback default.


=head1 ENVIRONMENT

=head2 PERL_DD_BACKEND

Can be used to set the default backend.


=head1 SEE ALSO

L<XXX> - basically the same thing but with a different name and defaults. I
happen to use "XXX" to mark todo items in source code, so I prefer C<DD>
instead.
