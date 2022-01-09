package Net::Sec::Ban::Failed;

use Moo;
use Types::Standard qw(HashRef);

use Data::Dumper;

has 'config' => (
  is       => 'rw',
  isa      => HashRef,
  required => 1,
);

has 'options' => (
  is       => 'rw',
  isa      => HashRef,
  required => 1,
);

has '_ips' => (
  is      => 'rw',
  isa     => HashRef,
  default => sub {{}},
);

sub run {
  my ($self) = @_;
  $self->restore_ips;
  $self->read_from_pipe;
}

sub restore_ips {
  my ($self) = @_;
  my $inf    = $self->config->{log_input}->[0]->{deploy}->{salt_file};
  open(my $fh, '<', $inf) || die "Could not open '$inf': $!";
  while (my $l = <$fh>) {
    chomp($l);
    my ($ip, $ts) = split(/\s*#\s*/, $l, 2);
    $self->_ips->{$ip} = $ts || time;
  }
  close $fh || die "Could not close '$inf': $!";
  print "Restored IP's from $inf:\n";
  print Dumper($self->_ips);
}

sub read_from_pipe {
  my ($self) = @_;

  my $file =  $self->config->{log_input}->[0]->{file};
  my $opt  = ($self->options->{follow}) ? "-f" : q{};
  if ($self->config->{log_input}->[0]->{type} eq 'journalctl') {
    open(my $fh, "journalctl $opt --file=$file|") || die "Could not open pipe: $!";
    # Aug  9 07:08:53 mail postfix/smtpd[1498]: warning: unknown[5.188.206.205]: SASL LOGIN authentication failed: authentication failure
    while (my $line = <$fh>) {
      #$self->_ips->{$1} = time if ($line =~ /warning: .*\[(.*)\]: SASL LOGIN authentication failed:/);
      if ($line =~ /warning: .*\[(.*)\]: SASL LOGIN authentication failed:/) {
        $self->_ips->{$1} = time;
        $self->dump_file if $self->options->{follow};
      }
    }
    close $fh;
  }
}

sub dump_file {
  my ($self) = @_;
  my $ofn   = $self->config->{log_input}->[0]->{deploy}->{salt_file};
  open(my $of, '>', $ofn) or die "Could not open $ofn: $!";
  for my $ip (sort keys %{$self->_ips}) {
    my $ts = $self->_ips->{$ip};
    print $of "$ip # $ts\n";
  }
  close $of;
  my $deploy = $self->config->{log_input}->[0]->{deploy};
  my $cmd    = "salt $deploy->{salt_id} state.apply $deploy->{salt_state}"; 
  system $cmd;
  return;
}

__PACKAGE__->meta->make_immutable;
1;
