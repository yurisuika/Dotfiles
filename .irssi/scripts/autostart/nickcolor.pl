use Irssi 20040119.2359 ();
$VERSION = "1.19";
%IRSSI = (
    authors     => 'David Leadbeater, Timo Sirainen, Georg Lukas',
    contact     => 'dgl@dgl.cx, tss@iki.fi, georg@boerde.de',
    name        => 'usercount',
    description => 'Adds a usercount for a channel as a statusbar item',
    license     => 'GNU GPLv2 or later',
    url         => 'http://irssi.dgl.cx/',
    changes     => 'Only show halfops if server supports them',
);

# Once you have loaded this script run the following command:
# /statusbar window add usercount
# You can also add -alignment left|right option

# Settings:
# /toggle usercount_show_zero to show item even when there are no users
# /toggle usercount_show_ircops (default off)
# /toggle usercount_show_halfops (default on)

# you can customize the look of this item from theme file:
#  sb_usercount = "{sb %_$0%_ nicks ($1-)}";
#  sb_uc_ircops = "%_*%_$*";
#  sb_uc_ops = "%_@%_$*";
#  sb_uc_halfops = "%_%%%_$*";
#  sb_uc_voices = "%_+%_$*";
#  sb_uc_normal = "$*";
#  sb_uc_space = " ";


use strict;
use Irssi::TextUI;use strict;
use Irssi 20020101.0250 ();
use vars qw($VERSION %IRSSI); 
$VERSION = "1";
%IRSSI = (
    authors     => "Timo Sirainen, Ian Peters",
    contact	=> "tss\@iki.fi", 
    name        => "Nick Color",
    description => "assign a different color for each nick",
    license	=> "Public Domain",
    url		=> "http://irssi.org/",
    changed	=> "2002-03-04T22:47+0100"
);

# hm.. i should make it possible to use the existing one..
Irssi::theme_register([
  'pubmsg_hilight', '{pubmsghinick $0 $3 $1}$2'
]);

my %saved_colors;
my %session_colors = {};
my @colors = qw/2 3 4 5 6 7 9 10 11 12 13/;

sub load_colors {
  open COLORS, "$ENV{HOME}/.irssi/saved_colors";

  while (<COLORS>) {
    # I don't know why this is necessary only inside of irssi
    my @lines = split "\n";
    foreach my $line (@lines) {
      my($nick, $color) = split ":", $line;
      $saved_colors{$nick} = $color;
    }
  }

  close COLORS;
}

sub save_colors {
  open COLORS, ">$ENV{HOME}/.irssi/saved_colors";

  foreach my $nick (keys %saved_colors) {
    print COLORS "$nick:$saved_colors{$nick}\n";
  }

  close COLORS;
}

# If someone we've colored (either through the saved colors, or the hash
# function) changes their nick, we'd like to keep the same color associated
# with them (but only in the session_colors, ie a temporary mapping).

sub sig_nick {
  my ($server, $newnick, $nick, $address) = @_;
  my $color;

  $newnick = substr ($newnick, 1) if ($newnick =~ /^:/);

  if ($color = $saved_colors{$nick}) {
    $session_colors{$newnick} = $color;
  } elsif ($color = $session_colors{$nick}) {
    $session_colors{$newnick} = $color;
  }
}

# This gave reasonable distribution values when run across
# /usr/share/dict/words

sub simple_hash {
  my ($string) = @_;
  chomp $string;
  my @chars = split //, $string;
  my $counter;

  foreach my $char (@chars) {
    $counter += ord $char;
  }

  $counter = $colors[$counter % 11];

  return $counter;
}

# FIXME: breaks /HILIGHT etc.
sub sig_public {
  my ($server, $msg, $nick, $address, $target) = @_;
  my $chanrec = $server->channel_find($target);
  return if not $chanrec;
  my $nickrec = $chanrec->nick_find($nick);
  return if not $nickrec;
  my $nickmode = $nickrec->{op} ? "@" : $nickrec->{voice} ? "+" : "";

  # Has the user assigned this nick a color?
  my $color = $saved_colors{$nick};

  # Have -we- already assigned this nick a color?
  if (!$color) {
    $color = $session_colors{$nick};
  }

  # Let's assign this nick a color
  if (!$color) {
    $color = simple_hash $nick;
    $session_colors{$nick} = $color;
  }

  $color = "0".$color if ($color < 10);
  $server->command('/^format pubmsg %K<'.chr(3).$color.'$2$0%K> %n%|$1');
}

sub cmd_color {
  my ($data, $server, $witem) = @_;
  my ($op, $nick, $color) = split " ", $data;

  $op = lc $op;

  if (!$op) {
    Irssi::print ("No operation given");
  } elsif ($op eq "save") {
    save_colors;
  } elsif ($op eq "set") {
    if (!$nick) {
      Irssi::print ("Nick not given");
    } elsif (!$color) {
      Irssi::print ("Color not given");
    } elsif ($color < 2 || $color > 14) {
      Irssi::print ("Color must be between 2 and 14 inclusive");
    } else {
      $saved_colors{$nick} = $color;
    }
  } elsif ($op eq "clear") {
    if (!$nick) {
      Irssi::print ("Nick not given");
    } else {
      delete ($saved_colors{$nick});
    }
  } elsif ($op eq "list") {
    Irssi::print ("\nSaved Colors:");
    foreach my $nick (keys %saved_colors) {
      Irssi::print (chr (3) . "$saved_colors{$nick}$nick" .
		    chr (3) . "1 ($saved_colors{$nick})");
    }
  } elsif ($op eq "preview") {
    Irssi::print ("\nAvailable colors:");
    foreach my $i (2..14) {
      Irssi::print (chr (3) . "$i" . "Color #$i");
    }
  }
}

load_colors;

Irssi::command_bind('color', 'cmd_color');

Irssi::signal_add('message public', 'sig_public');
Irssi::signal_add('event nick', 'sig_nick');


my ($ircops, $ops, $halfops, $voices, $normal, $total);
my ($timeout_tag, $recalc);

# Called to make the status bar item
sub usercount {
  my ($item, $get_size_only) = @_;
  my $wi = !Irssi::active_win() ? undef : Irssi::active_win()->{active};

  if(!ref $wi || $wi->{type} ne "CHANNEL") { # only works on channels
    return unless ref $item;
    $item->{min_size} = $item->{max_size} = 0;
    return;
  }

  if ($recalc) {
    $recalc = 0;
    calc_users($wi);
  }

  my $theme = Irssi::current_theme();
  my $format = $theme->format_expand("{sb_usercount}");
  if ($format) {
    # use theme-specific look
    my $ircopstr = $theme->format_expand("{sb_uc_ircops $ircops}",
          Irssi::EXPAND_FLAG_IGNORE_EMPTY);
    my $opstr = $theme->format_expand("{sb_uc_ops $ops}",
          Irssi::EXPAND_FLAG_IGNORE_EMPTY);
    my $halfopstr = $theme->format_expand("{sb_uc_halfops $halfops}",
          Irssi::EXPAND_FLAG_IGNORE_EMPTY);
    my $voicestr = $theme->format_expand("{sb_uc_voices $voices}", 
          Irssi::EXPAND_FLAG_IGNORE_EMPTY);
    my $normalstr = $theme->format_expand("{sb_uc_normal $normal}",
          Irssi::EXPAND_FLAG_IGNORE_EMPTY);
	my $space = $theme->format_expand('{sb_uc_space}',
         Irssi::EXPAND_FLAG_IGNORE_EMPTY);
	$space = " " unless $space;

    my $str = "";
    $str .= $ircopstr.$space if defined $ircops;
    $str .= $opstr.$space  if defined $ops;
    $str .= $halfopstr.$space if defined $halfops;
    $str .= $voicestr.$space if defined $voices;
    $str .= $normalstr.$space if defined $normal;
    $str =~ s/\Q$space\E$//;

    $format = $theme->format_expand("{sb_usercount $total $str}",
				    Irssi::EXPAND_FLAG_IGNORE_REPLACES);
  } else {
    # use the default look
    $format = "{sb \%_$total\%_ nicks \%c(\%n";
    $format .= '*'.$ircops.' ' if (defined $ircops);
    $format .= '@'.$ops.' ' if (defined $ops);
    $format .= '%%'.$halfops.' ' if (defined $halfops);
    $format .= "+$voices " if (defined $voices);
    $format .= "$normal " if (defined $normal);
    $format =~ s/ $//;
    $format .= "\%c)}";
  }

  $item->default_handler($get_size_only, $format, undef, 1);
}

sub calc_users() {
  my $channel = shift;
  my $server = $channel->{server};

  $ircops = $ops = $halfops = $voices = $normal = 0;
  for ($channel->nicks()) {
    if ($_->{serverop}) {
      $ircops++;
	}

    if ($_->{op}) {
      $ops++;
	} elsif ($_->{halfop}) {
	   $halfops++;
    } elsif ($_->{voice}) {
      $voices++;
    } else {
      $normal++;
    }
  }

  $total = $ops+$halfops+$voices+$normal;
  
  if (!Irssi::settings_get_bool('usercount_show_zero')) {
    $ircops = undef if ($ircops == 0);
    $ops = undef if ($ops == 0);
    $halfops = undef if ($halfops == 0);
    $voices = undef if ($voices == 0);
    $normal = undef if ($normal == 0);
  }

  # Server doesn't support halfops? 
  if($server->isupport("PREFIX") !~ /\%/) {
     $halfops = undef;
  } else {
     $halfops = undef unless Irssi::settings_get_bool('usercount_show_halfops');
  }

  $ircops = undef unless Irssi::settings_get_bool('usercount_show_ircops');
}

sub refresh {
   if ($timeout_tag > 0) {
      Irssi::timeout_remove($timeout_tag);
      $timeout_tag = 0;
   }
   Irssi::statusbar_items_redraw('usercount');
}

sub refresh_check {
   my $channel = shift;
   my $wi = ref Irssi::active_win() ? Irssi::active_win()->{active} : 0;

   return unless ref $wi && ref $channel;
   return if $wi->{name} ne $channel->{name};
   return if $wi->{server}->{tag} ne $channel->{server}->{tag};

   # don't refresh immediately, or we'll end up refreshing 
   # a lot around netsplits
   $recalc = 1;
   Irssi::timeout_remove($timeout_tag) if ($timeout_tag > 0);
   $timeout_tag = Irssi::timeout_add(500, 'refresh', undef);
}

sub refresh_recalc {
  $recalc = 1;
  refresh();
}

$recalc = 1;
$timeout_tag = 0;

Irssi::settings_add_bool('usercount', 'usercount_show_zero', 1);
Irssi::settings_add_bool('usercount', 'usercount_show_ircops', 0);
Irssi::settings_add_bool('usercount', 'usercount_show_halfops', 1);

Irssi::statusbar_item_register('usercount', undef, 'usercount');
Irssi::statusbars_recreate_items();

Irssi::signal_add_last('nicklist new', 'refresh_check');
Irssi::signal_add_last('nicklist remove', 'refresh_check');
Irssi::signal_add_last('nick mode changed', 'refresh_check');
Irssi::signal_add_last('setup changed', 'refresh_recalc');
Irssi::signal_add_last('window changed', 'refresh_recalc');
Irssi::signal_add_last('window item changed', 'refresh_recalc');

