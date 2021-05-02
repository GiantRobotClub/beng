
	#-------------------------------#                                               
# comments by jikuu@home.com
#-------------------------------#
#my $server='rpgcafe.on.ca.lunarnet.org';
#my $server='irc.nightstar.net';

#my $statefile= 'beng2002.state';
use Net::IRC;                   # perl mod

load_info();
	
my $protect_chat=0;
my $naive_audience=0;		# naive adds some extra help stuff that you really dont need
my %characters=();
my %present=();
my %concealed=();
my %graveyard=();
my %defeated=();
my $lastsave=time();
my $dopple = 0;
my %lcnames=();			
my $keep_log=1;
my $verbose=1;
my $dueltime=time();		#duel
my $dueling="";                  #duel
my $dueled="";
my $debug=0;
my $timeout=time()+120;
my $alive = 1;
my $conn_self;
#my %dropped=(wood_sword=>1,ice_brand=>5, ice_stick=>1, excalibur=>0, pistol=>2);
my %dropped=();
my $slimes = 0;
my $ogres = 0;
my $grudge =  0;
my $antigrudge =  0;
sub net_grudge{$grudge-$antigrudge}
my $totaldamage = 0;
my $runaway = 0;
#slayer numbers
my $dragonslayer = 0; #fire
my $slimeslayer = 0; #chem
my $wolfslayer = 0; #ice
my $canslayer = 0; #energy
my $demonslayer = 0; #dark
my $manslayer = 0; #holy
my $goblinslayer = 0; #lit
my $dropped = 'none';
my $lastbeng = time();
srand();				# ready the randomizer

sub load_server{
	open LOADFILE, "<beng_server.pl" or return;
	print "Loading server...";
	eval(join('',<LOADFILE>));
	close LOADFILE;

	print "done\n";
}

sub load_info{
	open LOADFILE, "<beng_info.pl" or return;
	print "Loading info...";
	eval(join('',<LOADFILE>));
	close LOADFILE;

	print "done\n";
}

load_server();

my $beng_nick='BattleEngine2002';       # the name, channel, server?
my $channel='#beng';
#my $server='irc.lunarnet.org';
my $port=6667;

my @errors=();


# Webrunner Presents:
#  CHANGE HISTORY THEATRE
#   Starring Ben Affleck as Status Ailments
#    Matt Dameon as the Psionist Class, complete with new spells
#     Allanis Morrissete as the Two Spells that Slimes Get Now (poison @30 slow_burn @50)
#      Ben Stein as Assimilate actually working
#
# Coming soon to a BENG NEAR YOU

# Status Ailments
# Poison - 10 actions, 1-40 damage each
# Regen - 10 actuions 1-60 heal each
# Burn - 10 actions, 1-200 damage each
# mpshield - 5 actions - damage goes to MP first
# damagex2 - 3 actions - doubles damage
# damage/2 - 5 actions - halves damage

# New Spells
# Vertigo - 40 second paralyze
# Meditate - self heal 2000
# mind_drain - mp drain 100
# mind_blast - mp damage 500
# Rest are simple.

sub load_weapons{
	open LOAD, "<beng_weapons.pl" or return;
	print "Loading weapons...";
	eval(join('',<LOAD>));
	close LOAD;

	print "done\n";
}
sub load_spells{
	open LOADFILE, "<beng_spells.pl" or return;
	print "Loading spells...";
	eval(join('',<LOADFILE>));
	close LOADFILE;

	print "done\n";
}
sub load_items{
	open LOADFILE, "<beng_items.pl" or return;
	print "Loading items...";
	eval(join('',<LOADFILE>));
	close LOADFILE;

	print "done\n";
}
sub load_classes{
	open LOADFILE, "<beng_classes.pl" or return;
	print "Loading classes...";
	eval(join('',<LOADFILE>));
	close LOADFILE;

	print "done\n";
}
load_items();
load_weapons();
load_spells();
load_classes();
while(@ARGV){
	my $arg=shift @ARGV;               # passed command line arguments
	if($arg eq '-server'){             # -server irc.nightstar.net
		$server=shift @ARGV;    
	}elsif($arg eq '-channel'){        # -channel #rpgbattle
		$channel=shift @ARGV;
	}elsif($arg eq '-nick'){           # -nick battleengine
		$beng_nick=shift @ARGV;
	}elsif($arg eq '-naive'){	   # the rest are on/off switches... 
		$naive_users=1;            # dunno..
	}elsif($arg eq '-chat'){
		$protect_chat=1;           # dunno.
	}elsif($arg eq '-nolog'){
		$keep_log=0;               # logging is automatically on, dont know if this saves characters yet, or is just reference logging
	}elsif($arg eq '-verbose'){
		$verbose=1;                # dunno, perhaps this puts output to a screen, it seems that way given sub logprint. -j
        }elsif($arg eq '-debug'){
                $debug=1;
	}else{
		push @errors, "Invalid argument: $arg\n";
	}
}

if(!$beng_nick){
	push @errors, "Specified nick ($beng_nick) is invalid.\n";
}

if(!$channel){
	push @errors, "Specified channel ($channel) is invalid.\n";
}

if(!$server){
	push @errors, "You must specify a server with '-server [URL]'.\n";
}

if(@errors){
	print STDERR @errors;
	exit(1);
}

if($keep_log){
	open LOG, ">>batlog.txt";
}

sub logprint{                   # logging program
	if($verbose){		# screen echo
		print @_;
	}
	if($keep_log){
		print LOG @_;	# to a file (batlog.txt)
	}
}

my $bold="\2";			# the bold character

my $irc=new Net::IRC;		# starting up irc...

	# ^^^connection info passed along

sub shortbase{ my $line=shift;
	my @tokens=split /\s/, $line;
	my @ret=();
	my $current='';
	foreach $token (@tokens){
		if(length($current.$token)>240){
			push @ret, $current;
			$current=$token;
		}else{
			$current.=$token.' ';
		}
	}
	push @ret, $current;
	return @ret;
}

sub shorten{
	map{shortbase($_)} @_
}

sub sayto{ my $to=shift;			# how to log /msgs...
	foreach(shorten(@_)){
		$conn->privmsg($to,$_);
		logprint("private($to) $_\n");
	}
}

sub say{ 					# another logging thing
	foreach(shorten(@_)){
		$conn->privmsg($channel,$_);
		logprint("out: $_\n");
	}
}


#my %goblin=(ogre=>'1',troll=>'1', ettin=>'1', frozen_imp=>'1', imp=>'1', giant=>'1');

#lists of enemy types, used in the slayer counts





my $last_twink=time();	# no clue




sub drop_choice{ my ($class)=@_;
	my $total=0;
	#say("Drop Choice Entered! $class");	
	for(keys %{$drops{$class}}){
	#	say("DEBUG: found $_");
		$total+=$drops{$class}->{$_};
	}
	my $rand=int(rand($total));
	$total=0;
	for(keys %{$drops{$class}}){
		$total+=$drops{$class}->{$_};
		if($total >= $rand){
			
		#	say("DEBUG: returning $_");
			return $_;
		}
	}
	return 'none';
}


sub drop_weapon{ my ($name)=@_;
	my $class = $characters{$name}->{class};
	my $drop = 'none';
	#say("DEBUG: Drop weapon for $class");
	#say("DEBUG: $drops{drop_tester}->{wood_sword}");
	if (exists $drops{$class}) {
		$drop = drop_choice($class);
	#	say("DEBUG: $drop");
	}
	if (exists $equips{$characters{$name}->{weapon}}) {
		$drop = $characters{$name}->{weapon};
		$characters{$name}->{weapon} = 'none';
	}
	if (!($drop eq 'none')) {
	say("Dropped a \2$drop\2!");
		
		$dropped{$drop} = $dropped{$drop} + 1;
	}

}

sub drop_inventory{ my ($name, $drop)=@_;

	my $drop_item = 'none';
	#say("DEBUG: Drop weapon for $class");
	#say("DEBUG: $drops{drop_tester}->{wood_sword}");

	if (exists $inv{$name}->{$drop} && $inv{$name}->{$drop} >= 1) {
		$drop_item = $drop;
		 $inv{$name}->{$drop_item}=  $inv{$name}->{$drop_item} - 1;
	}else{
		sayto($name,"You dont have one of those to drop.");
	}
	if (!($drop_item eq 'none')) {
		say("\2$name\2 dropped a \2$drop_item\2!");
		
		$dropped{$drop_item} = $dropped{$drop_item} + 1;
	}

}
sub pickup{ my ($buyer, $weapon)=@_;
	if( ! exists $characters{$buyer} ) { return; }
	if( (! exists $dropped{$weapon}) || ($dropped{$weapon} < 1) ) {
		sayto($buyer,"There are none of those on the ground");
		return;
	}
#	my $buyerclass = $characters{$buyer}->{class};
#	my $weapontype = $equips{$weapon}->{type};
#	if ($classes{$buyerclass}->{weaptypes}->{$weapontype}) {
#		my $oldweapon = 'none';
#		if(exists $characters{$buyer}->{weapon} && !( $characters{$buyer}->{weapon} eq 'none')) {
#			$oldweapon = $characters{$buyer}->{weapon};
#		}
		$inv{$buyer}->{$weapon} = $inv{$buyer}->{$weapon} + 1; 
		$dropped{$weapon}--;
		say("\2$buyer\2 picks up a \2$weapon\2 off the ground!");
#		if (! ($oldweapon eq 'none') ) {
#			say("\2$buyer\2 puts his old \2$oldweapon\2 in its place!");
#			$dropped{$oldweapon}++;
#		}
		

#	}else{
#		say("You can't equip that weapon!");
#	}
	return;
}

sub list_drops{
	say("You see on the ground...".
	 join(' ',(map {"\2$dropped{$_}\2x\2$_\2 ($equips{$_}->{type}) "}
	 drops_list($name))));
	 say("Use beng pickup [WEAPON] without the brackets to pick it up");

}

sub drops_list{
	my @ret=();
	for(keys %dropped){

		#sayto($name,"DEBUG: $name $_ $weaptype $classes{$class}->{weaptypes}->{$weaptype}");
		if( (exists $equips{$_} || exists $items{$_}) && $dropped{$_} > 0 ){
			push @ret, $_;
		}
	}
	return @ret;
}

sub tell_buy_item{ my ($name)=@_;
	sayto($name, "The item you can buy are: ".
	join(' ',(map {"\2$_\2 (\2$items{$_}->{cost}\2 gold)"}
	 buy_list_items($name))));
	 sayto($name, "Use beng buy [ITEM] without the brackets to buy a weapon.");
}

sub buy_list_items{ my ($name)=@_;
	my @ret=();
	for(keys %items){
		#sayto($name,"DEBUG: $name $_ $weaptype $classes{$class}->{weaptypes}->{$weaptype}");
		if(  (!(exists $items{$_}->{legend}) ) &&
		 ($characters{$name}->{gold} >= $items{$_}->{cost})){
			push @ret, $_;
		}
	}
	return @ret;
}

sub tell_inv{ my ($name)=@_;
	sayto($name, "The items you are carrying are:".
	join(' ',(map {"\2$inv{$name}->{$_}\2x\2$_\2 "}
	 inv_list($name))));

}
sub inv_list{ my ($user)=@_;
	my @ret=();
	for(keys %items){
	#	print("Testing $_ ... ");
		if( (exists $items{$_}) && $inv{$user}->{$_} > 0 ){
			print("Found item $_ !! ");
			push @ret, $_;
		}
	}
	for(keys %equips){
	#	print("Testing $_");
		if( (exists $equips{$_}) && $inv{$user}->{$_} > 0 && !($equips{$_}->{type} eq 'star')){
			print("Found weapon $_ !!");
			push @ret, $_;
		}
	}
	return @ret;
}

sub throw{ my ($name,$weapon, $target)=@_;
	if($characters{$name}->{isresting}){
		sayto($name, "You can't do that, you're resting!");
		return;
	}
	if($characters{$target}->{isresting}){
		sayto($name, "You can't do that, that's not nice!");
		return;
	}
	if ((! exists $characters{$name})||(! exists $characters{$target})) {
		return;
	}
	if (! exists $classes{$characters{$name}->{class}}->{throw}) {
		sayto ($name, "Only thief and ninja can throw weapons.");
		return;
	}
	if (exists $equips{$weapon}) {
		if ($inv{$name}->{$weapon} > 0) {
			say("\2$name\2 throws a \2$weapon\2 at \2$target\2!");
			my $damage = $equips{$weapon}->{rating} * damage_dealt($name);

					if ( exists $special_throws{$weapon} ) {
						$damage = &{$special_throws{$weapon}}($name,$target,$damage);
					#	sayto('webrunner', "DEBUG 2: $basedamage");
						if (! exists $characters{$target}) {delay($name,5); return; }
					}

			cause_damage($name, $target, $damage, $equips{$weapon}->{elem});
			$inv{$name}->{$weapon} = $inv{$name}->{$weapon} - 1;
		}else {sayto ($name, "You dont have any of those to throw!"); }

	} else { sayto ($name, "You cant throw that!"); }
	if($characters{$target}->{hp}<=0){
		defeats($name,$target);
	}
	delay($name, 5);
}

sub equip_weapon{ my ($name, $weapon)=@_;
	if (! exists $characters{$name}) { return; }
	if ($inv{$name}->{$weapon} > 0) {
		if (! exists $equips{$weapon}) { sayto($name, "You cant equip whats not a weapon!"); return; }
		my $weaptype = $equips{$weapon}->{type};
		my $userclass = $characters{$name}->{class};
		print("DEBUG: $weaptype $classes{$userclass}->{weaptypes}->{$weaptype}");
		if ($classes{$userclass}->{weaptypes}->{$weaptype} > 0) {
			say("\2$name\2 equipped a $weapon!");
			my $oldweapon = 'none';
			if (!($characters{$name}->{weapon} eq 'none' || !(exists $characters{$name}->{weapon}))) {
				$oldweapon = $characters{$name}->{weapon};
				$inv{$name}->{$oldweapon} = $inv{$name}->{$oldweapon} + 1;
			}
			$inv{$name}->{$weapon} = $inv{$name}->{$weapon} - 1;
			$characters{$name}->{weapon} = $weapon;
		}else{sayto($name,"You cant equip that!"); }
	}else{sayto($name,"You dont have that!"); }
}
sub buy_ten{ my ($buyer, $weapon)=@_;
	if(! ( !exists $characters{monster} ||  $characters{$buyer}->{isresting} ) ) {
		sayto($buyer,"You're not anywhere near the weapon shop!");
		return;
	}
	if( ! exists $characters{$buyer} ) { return; }
	if( ! exists $characters{$buyer}->{gold} ) { $characters{$buyer}->{gold} = 0; }
	if( (! exists $equips{$weapon}) && (! exists $items{$weapon}) ) {
		sayto($buyer,"You can't buy what doesn't exist, silly person.");
		return;
	}
	my $cost = 0;
	if ( exists $items{$weapon}) {
		if( exists $items{$weapon}->{legend} ) {
			sayto($buyer,"You cant buy legendary items.");
			return;
		}	
		$cost = $items{$weapon}->{cost} * 10;
	
	
	}elsif( exists $equips{$weapon}) {
		if( exists $equips{$weapon}->{legend} ) {
			sayto($buyer,"You cant buy legendary weapons.");
			return;
		}	
		$cost = $equips{$weapon}->{cost} * 10;
	}
	if( $characters{$buyer}->{gold} < $cost) {
		sayto($buyer,"You are too poor to buy that.");
		return;
	}

		sayto($buyer,"You bought 10x\2$weapon\2 for $cost!");
		$characters{$buyer}->{gold} = $characters{$buyer}->{gold} - $cost;
		if (! exists $inv{$buyer} ) { $inv{$buyer} = (wood_sword=>0); }
		if (! exists $inv{$buyer}->{$weapon} ) { $inv{$buyer}->{$weapon} = 0 };
		$inv{$buyer}->{$weapon} = $inv{$buyer}->{$weapon} + 10 ; 


} 

sub buy{ my ($buyer, $weapon)=@_;
	if(! ( !exists $characters{monster} ||  $characters{$buyer}->{isresting} ) ) {
		sayto($buyer,"You're not anywhere near the weapon shop!");
		return;
	}
	if( ! exists $characters{$buyer} ) {return; }
	if( ! exists $characters{$buyer}->{gold} ) { $characters{$buyer}->{gold} = 0; }
	if( (! exists $equips{$weapon}) && (! exists $items{$weapon}) ) {
		sayto($buyer,"You can't buy what doesn't exist, silly person.");
		return;
	}
	my $cost = 0;
	if ( exists $items{$weapon}) {
		if( exists $items{$weapon}->{legend} ) {
			sayto($buyer,"You cant buy legendary items.");
			return;
		}	
		$cost = $items{$weapon}->{cost};
	}
	elsif( exists $equips{$weapon}) {
		if( exists $equips{$weapon}->{legend} ) {
			sayto($buyer,"You cant buy legendary weapons.");
			return;
		}	
		$cost = $equips{$weapon}->{cost};
	}
	
	if( $characters{$buyer}->{gold} < $cost) {
		sayto($buyer,"You are too poor to buy that.");
		return;
	}

		sayto($buyer,"You bought a $weapon for $cost!");
		$characters{$buyer}->{gold} = $characters{$buyer}->{gold} - $cost;
		if (! exists $inv{$buyer} ) { $inv{$buyer} = (wood_sword=>0); }
		if (! exists $inv{$buyer}->{$weapon} ) { $inv{$buyer}->{$weapon} = 0 };
		$inv{$buyer}->{$weapon} = $inv{$buyer}->{$weapon} + 1 ; 


} 
sub sell_ten{ my ($buyer, $weapon)=@_;
	if(! ( !exists $characters{monster} ||  $characters{$buyer}->{isresting} ) ) {
		sayto($buyer,"You're not anywhere near the weapon shop!");
		return;
	}
	if( ! exists $characters{$buyer} ) { return; }
	if( ! exists $characters{$buyer}->{gold} ) { $characters{$buyer}->{gold} = 0; }
	if( (! exists $equips{$weapon}) && (! exists $items{$weapon}) ) {
		sayto($buyer,"You can't sell what doesn't exist, silly person.");
		return;
	}
	my $cost = 0;
	if (exists $items{$weapon}) { 	$cost = $items{$weapon}->{cost} * 10; }
	elsif (exists $equips{$weapon}) {  $cost = $equips{$weapon}->{cost} * 10; }
	$cost = int($cost / 5);
	if( ($inv{$buyer}->{$weapon} > 9) && ( exists $inv{$buyer}->{$weapon} )) {


		sayto($buyer,"You sold a $weapon for $cost!");
		$characters{$buyer}->{gold} = $characters{$buyer}->{gold} + $cost;
		$inv{$buyer}->{$weapon} = $inv{$buyer}->{$weapon} - 10 ; 
	}
	else {
		sayto($buyer,"You dont have ten of those.");
		return;
	}
} 

sub sell{ my ($buyer, $weapon)=@_;
	if(! ( !exists $characters{monster} ||  $characters{$buyer}->{isresting} ) ) {
		sayto($buyer,"You're not anywhere near the weapon shop!");
		return;
	}
	if( ! exists $characters{$buyer} ) { return; }
	if( ! exists $characters{$buyer}->{gold} ) { $characters{$buyer}->{gold} = 0; }
	if( (! exists $equips{$weapon}) && (! exists $items{$weapon}) ) {
		sayto($buyer,"You can't sell what doesn't exist, silly person.");
		return;
	}
	my $cost = 0;
	if (exists $items{$weapon}) { 	$cost = $items{$weapon}->{cost}; }
	elsif (exists $equips{$weapon}) {  $cost = $equips{$weapon}->{cost}; }
	$cost = int($cost / 5);
	if( ($inv{$buyer}->{$weapon} > 0) && ( exists $inv{$buyer}->{$weapon} )) {


		sayto($buyer,"You sold a $weapon for $cost!");
		$characters{$buyer}->{gold} = $characters{$buyer}->{gold} + $cost;
		$inv{$buyer}->{$weapon} = $inv{$buyer}->{$weapon} - 1 ; 
	}
	else {
		sayto($buyer,"You dont have one of those.");
		return;
	}
} 

# what a summoner gets for studying each of these monsters

#mimicing

sub mimic{ my ($mimic,$subject,$object)=@_;
	if(! (exists $characters{$mimic}  &&
	 exists $characters{$subject}  &&
	 exists $characters{$object})){
		return;
	}
	if($mimic eq $subject){
		sayto($mimic, "You can't mimic yourself!");
		return;
	}
	if($characters{$mimic}->{class} ne 'mimic'){
		sayto($mimic, "Only a \2mimic\2 can mimic those present.");
		return;
	}
	if(!$present{lc($subject)}){
		sayto($mimic, "You can't mimic \2$subject\2 when he's away!");
		return;
	}
	if($characters{$mimic}->{isresting}){
		sayto($mimic, "You're resting.  You can't mimic while resting.");
		return;
	}
	if($characters{$mimic}->{delay}<=time()){
		$mimicking=$mimic;
		my $spell=$sp[$choice-2];
		my $oldlevel=$characters{$mimic}->{level};
		my $oldxp = $characters{$mimic}->{xp};
		my $oldhp = $characters{$mimic}->{hp};
		my $oldmhp = $characters{$mimic}->{maxhp};
		my $elevel=$characters{$mimic}->{level}=$characters{$subject}->{level};
		$characters{$mimic}->{class}=$characters{$subject}->{class};
		$characters{$mimic}->{mp}=$characters{$subject}->{mp};#saves old info...
		if(exists $classes{$characters{$mimic}->{class}}->{hitsas}){
			$elevel=$classes{$characters{$mimic}->{class}}->{hitsas};
		}
		if(rand()>0.10 && rand($elevel)<$oldlevel){
			say("\2$mimic\2 mimics \2$subject\2 against \2$object\2!");
			my @sp=spells_available($subject);
			my $choice=int(rand(scalar(@sp) + 2));
			if($choice>=2){
				my $spell=$sp[$choice-2];
				cast($mimic,$sp[$choice-2],$object);
			}else{
				attack($mimic,$object);
			}
		}else{
			say("\2$mimic\2 fails to mimic \2$subject\2 against \2$object\2!");
		}
		$characters{$mimic}->{maxhp}=$oldmhp;
		$characters{$mimic}->{hp}=$oldhp;

		$characters{$mimic}->{level}=$oldlevel;
		$characters{$mimic}->{mp}=0;
		$characters{$mimic}->{maxmp}=0;
		$characters{$mimic}->{class}='mimic';
		delay($mimic,5);
		$mimicking='';
		correct_points($mimic);
	}else{
		penalty($mimic);
	}
}

#Used for delaying and haste application
sub delay{my ($who,$time)=@_;
	if ($characters{$who}->{seffect} eq 'slow') {
		$time = $time * 2;
	}elsif ($characters{$who}->{seffect} eq 'haste') {
		$time = int($time / 2);
	}
	#say("Time: $time Old Delay: $characters{$who}->{delay}");
	my $current_delay = $characters{$who}->{delay};
	if ($current_delay < 0) { $current_delay = 0; }
	if ($characters{$who}->{delay} > time()) { $characters{$who}->{delay} = $characters{$who}->{delay} + $time; }
	else { $characters{$who}->{delay}=time()+$time; }
	#say("new delay: $characters{$who}->{delay}");
	return 1;
}
#called when hunt is called.
sub hunt{my ($hunter,$monster,$area)=@_;
	if(! exists $characters{$hunter}){
		return;
	}
	if(($characters{$hunter}->{class} ne 'hunter') && ( $characters{$hunter}->{class} ne 'dragonmaster')){
		sayto($hunter, "Only a \2hunter\2 can hunt for specific creatures.");
		return;
	}
	if($characters{$hunter}->{isresting}){
		sayto($hunter, "You're resting.  You can't hunt while resting.");
		return;
	}
	if($characters{$hunter}->{delay}<=time() && (! exists $characters{monster})){
		say("\2$hunter\2 tries to track down a \2$monster\2 in \2$area\2...");
		if($area eq 'bizarre_cannery' || $monster =~ /can/){
			if(rand()<0.80){
				new_character('monster','ominous_can','impossible!ID@!@!@');
			}else{
				new_character('monster','auto_tinner','impossible!ID@!@!@');
			}
		}else{
			wander_hunt($hunter, $area, $monster, $characters{$hunter}->{level});
		}
		delay($hunter,5);
	}elsif (exists $characters{monster}) {
		sayto($hunter,"You cant, there's already a monster!");
	}else{
		penalty($hunter);
	}
}

# lets try and break down the summoner program
# $student is the person studying, $subject is the thing being studied.


sub summoner_study{my ($student,$subject)=@_;  	# initializing variables
						# if the person saying beng study isnt a player, ignore it
	if(! exists $characters{$student}){    
		return;				
	}				
						# not a summoner?  no studying for you.
	if($characters{$student}->{class} ne summoner){  
		sayto($student, "Only a \2summoner\2 can study creatures and learn to summon them."); 
		return;
	}
						# resting?  no studying for you.
	if($characters{$student}->{isresting}){
		sayto($student, "You're resting.  You can't study while resting.");
		return;
	}
						# if there is not a subject, then you cant study it, can you?
	if(!exists $characters{$subject}){
		sayto($student, "There is no \2$subject\2 to study!");
		return;
	}
						# if its away, then no studying
	if(!$present{lc($subject)}){

		sayto($student, "You can't study \2$subject\2 when he's away!");
		return;
	}

	my $class=$characters{$subject}->{class}; # initializing some more variables
						# this is a check of the person to see if they already have it.
	if(exists $characters{$student}->{summons}->{$class}){
		sayto($student, "There is nothing to be gained by studying a creature you can already summon.");
		return;
	}
						# if everything else is cool, then try to study
	## SUMMONER STUDY DEBUG LINES##

	logprint("DELAY: $characters{$caster}->{delay} versus TIME: time().  Succeeds if first < second");
	
	if($characters{$student}->{delay}<=time()){
	logprint("Success!");
		say("\2$student\2 tries to study \2$subject\2...");
		# if there is a summon for that guy, and you hit 1 out of 4...
                if(exists($summons{$class})) { 
                        if( int(rand(4)) eq 1) {     
                                $characters{$student}->{summons}->{$class}=$summons{$class};    # add that summon to the list
                                say("and \2$student\2 learns to summon \2$class\2!");           # tell everyone
                                $characters{$student}->{xp}+=50;                                # give xp
                                correct_points($student);
                        }else{

                                say("but \2$student\2 learns nothing");
                                                               # dunno...
                }
	
				} 

				else{

                        say("but \2$student\2 doesn't understand \2$subject\2!");                         # failure...
		}
		delay($student,5);					# add 5 seconds to delay time
        }
		else{
			if(!$characters{$student}->{delay}<=time()){penalty($student);}
				# how could there be something else, oh well.. hurt em for messin with beng!
	}
}



#------------------------------------------#
# spells that do stuff other than damage
#------------------------------------------#


# status effects - webrunner
sub cause_status{ my ($target)=@_;
    if ( exists( $characters{$target} ) ) {
		print("$target $characters{$target}->{seffect} $characters{$target}->{sefftime}\n");
        if (! ( $characters{$target}->{seffect} eq 'none' ) ) {
                $characters{$target}->{sefftime} = $characters{$target}->{sefftime} - 1;
             if (( $characters{$target}->{sefftime} <= 0  )
	     && !( $characters{$target}->{seffect} eq "" )
	     &&  !( $characters{$target}->{seffect} eq "none") ) { 
			say("\2$target\2's $characters{$target}->{seffect} has worn off!");
			if($characters{$target}->{seffect} eq 'death_sentance') {
				$characters{$target}->{hp} = 0;
				defeats_status($characters{$target}->{seffname},$target);
				return 1;
			}
			$characters{$target}->{seffect} = "none"; 
		}
             if ( $characters{$target}->{seffect} eq 'poison' ) {
                cause_damage('Poison',$target,40, 'chem');
                   if ( $characters{$target}->{hp} <= 0 ) { 
                    defeats_status($characters{$target}->{seffname},$target);
					
                     return 1;
                    }
             }elsif ( $characters{$target}->{seffect} eq 'death_sentance' ) {
                 say("$target will die in $characters{$target}->{sefftime} turns!");
             }
             elsif ( $characters{$target}->{seffect} eq 'regen' ) {
                 cause_damage('Regen',$target,-50, 'none');
             }             


			 
	     elsif ( $characters{$target}->{seffect} eq 'mpregen' ) {
                 mp_damage('mp_regeneration',$target,-50);
		 correct_points($target);
             }
	     elsif ( $characters{$target}->{seffect} eq 'baka' ) {
                 mp_damage('baka-ness',$target,10);
		 correct_points($target);
             }
			 elsif ( $characters{$target}->{seffect} eq 'burn' ) {
                   cause_damage('burning',$target,200, 'fire');
                   if ( $characters{$target}->{hp} <= 0 ) { 
                    defeats_status($characters{$target}->{seffname},$target);
                     return 1;
                    }
             }
			 if ( $characters{$target}->{weapon} eq 'healer_scepter' ) {
                 cause_damage('healer_scepter',$target,-50, 'none');
             }

                ## ones that have repeated effects go above.  But they all count down..


        }
    }
    return 0;
}




# rand_el picks a random element from a list, see can_of_mystery for example
sub rand_el{
	return $_[int(rand(scalar(@_)))];
};

# things that say/do weird stuff when they die.  This includes cans that reveal stuff inside.


#---------------------------------------------------------------------------------------------------------------------------------#
# making a new character or monster
# arguments are as follows 
# $name is the name of the monster ('monster' usually, or the characters name)
# $class is the actual thing it is 'cosmic_dragon'
# $static is the ip or the impossible thing for monsters.
#---------------------------------------------------------------------------------------------------------------------------------#
sub new_character{my ($name,$class,$static)=@_; # arguments..
	if ($class eq 'doppelganger') { $dopple = 1; }
	else { $dopple = 0; }
	clean_grave($static);				# kill person with $static id from grave
	$characters{$name}={				
		class=>$class,
		hp=>$classes{$class}->{hp},
		maxhp=>$classes{$class}->{hp},
		mp=>$classes{$class}->{mp},
		maxmp=>$classes{$class}->{mp},
		xp=>0,
		level=>1,
		delay=>time(),
		isresting=>1,
		staticid=>$static,
		frontline=>0,
		gold=>0,
		weapon=>'none',
		win=>0,
	}; # duh, alot of stuff... pretty obvious what it is.
	if($classes{$class}->{user}){					# these are apparently references, something i dont know and efnet #perl yells at me for not knowing
		say("\2$name\2 becomes a Level 1 \2$class\2!"); # if its a user... say so
	}else{
		say("A \2$class\2 (ID: \2$name\2) appears!");   # if its a monster... say so
	}
	$characters{$name}->{dead} = "false";
	learned($name,$class);						# learned a spell, plus its arguments ($name, who learned it, and $class, what monster was it that they learned.)
	$lcnames{lc($name)}=$name;					# checks for case sensitive naming...
	if($class eq 'summoner'){
		$characters{$name}->{summons}={};	
		$characters{$name}->{summons}->{'chocobo'}=$summons{'chocobo'};   
                say("and \2$name\2 learns to summon \2chocobo\2!");        }
                                
}

sub lcname{ my ($name)=@_;						# a case sensitive sub, changes stuff into lowercase temporarily.
	if(exists $lcnames{lc($name)}){
		return $lcnames{lc($name)};
	}else{
		return $name;
	}
}

# saving the dead
sub save_corpse{my $name=shift;				# new variable
	
	local *file=shift;						
	my $char=$graveyard{$name};
	my $safename=$name;						# a name thats safe to mess with
	$safename=~s/'/\\'/g;
	$safename="'$safename'";					# add delimiters
	print SAVEFILE "\$graveyard\{$safename\}=\{\n";		# print to the savefile
	foreach $key (keys %{$char}){					
		if($key ne 'summons'){
			print SAVEFILE "\t$key=>'$char->{$key}',\n";
		}else{
			print SAVEFILE "\t$key=>\{\n";
			for(keys %{$char->{summons}}){
				print SAVEFILE "\t\t$_=>'$char->{summons}->{$_}',\n";
			}
			print SAVEFILE "\t\},\n";
		}
	}
	print SAVEFILE "\};\n";
	print SAVEFILE "\$defeated\{\$graveyard\{$safename\}->\{staticid\}\}=$safename;\n";
}

# saving the living
sub save_character{my $name=shift;
	local *file=shift;
	my $char=$characters{$name};
	my $safename=$name;
	$safename=~s/'/\\'/g;
	$safename="'$safename'";
	print SAVEFILE "\$characters\{$safename\}=\{\n";
	foreach $key (keys %{$char}){
		if($key ne 'summons'){
			print SAVEFILE "\t$key=>'$char->{$key}',\n";
		}else{
			print SAVEFILE "\t$key=>\{\n";
			for(keys %{$char->{summons}}){
				print SAVEFILE "\t\t$_=>'$char->{summons}->{$_}',\n";
			}
			print SAVEFILE "\t\},\n";
		}
	}
	print SAVEFILE "\};\n";
}


sub save_inventory{my $name=shift;
	local *file=shift;
	my $char=$inv{$name};
	my $safename=$name;
	$safename=~s/'/\\'/g;
	$safename="'$safename'";
	print SAVEFILE "\$inv\{$safename\}=\{\n";
	foreach $key (keys %{$char}){
			print SAVEFILE "\t$key=>'$char->{$key}',\n";
	}
	print SAVEFILE "\};\n";
}


sub save_drops{
	print SAVEFILE "%dropped=(".join(' ',(map {"$_" ."=>" . "$dropped{$_}" . ","}
	 drops_list($name))) . ");";


}


# save stuff
sub save_counters{
#	print SAVEFILE "\$slimes=$slimes;\n";
#	
	print SAVEFILE "\$grudge=$grudge;\n";
	print SAVEFILE "\$antigrudge=$antigrudge;\n";
#	print SAVEFILE "\$dragonslayer=$dragonslayer;\n";
#	print SAVEFILE "\$slimeslayer=$slimeslayer;\n";
#	print SAVEFILE "\$wolfslayer=$wolfslayer;\n";
#	print SAVEFILE "\$demonslayer=$demonslayer;\n";
#	print SAVEFILE "\$manslayer=$manslayer;\n";
}
sub save{
	open SAVEFILE, ">beng2002.state";
	print "Saving...\n";
	foreach $name (keys %characters){
		save_character($name);
	}

	foreach $name (keys %graveyard){
		save_corpse($name);
	}
	foreach $name (keys %inv){
		save_inventory($name);
	}
	save_drops();
	save_counters();
	close SAVEFILE;
	$lastsave=time();
	logprint("!!!\nSAVED STATE\n!!!\n");
}
# loading stuff
sub load{
	open LOADFILE, "<beng2002.state" or return;
	print "Loading...";
	eval(join('',<LOADFILE>));
	close LOADFILE;
	foreach $name (keys %characters){
		$lcnames{lc($name)}=$name;
		if($characters{$name}->{class} eq 'twink'){
			$last_twink=time();
		}
		if(! exists $characters{$name}->{frontline}){
			$characters{$name}->{frontline}=0;
		}
	}
	if(exists $characters{monster}){
		$present{monster}=1;
	}
	print "done\n";
}


# load dammit
load();


# aha, its learned.  Getting spells is now 75% easier with new LEARNED!!! =) ;)
sub learned{ my ($name,$class)=@_;
	foreach $spell (keys %{$classes{$class}->{spells}}){
		if($classes{$class}->{spells}->{$spell} == $characters{$name}->{level}){
			say("\2$name\2 learned \2$spell\2!");
		}
	}
}

sub element_multi{ my ($element, $class)=@_;
	foreach $elem (keys %{$classes{$class}->{elem}}) {
		#say ("Checking element $elem against $element");
		if($elem eq $element) {
			#say("element found: $elem");
			return $classes{$class}->{elem}->{$elem};
		}
	}
	return 1;
}

# computing xp needed for next level.
sub xp_needed{ my ($name)=@_;
	my $basexp=$classes{$characters{$name}->{class}}->{xp};
	my $level=$characters{$name}->{level};
	my $step=0,$j=0;
	my $factor=0;
	for(my $i=0; $i<$level; $i++){
		if($j++%4==0){$step++}
		$factor+=$step;
	}
	return $basexp*$factor;
}
# What a character is worth in XP when its killed.
sub xp_value{ my ($name)=@_;               # no xp from killing people from now on
		my $xp = xp_needed($name);
		if ($dopple == 1) {
			$xp = sqrt $xp; 
			$dopple = 0;
			if ($xp > 100000) { $xp = 100000; }
			#sayto('webrunner','Dopple killed');
		}
        if($characters{$name}->{staticid} eq 'impossible!ID@!@!@'){
			return int($xp/3);
        }else{
        return 0;
        }
}
# yes, but does the attack hit?  (physical 'hits' only.)
sub does_hit{ my ($attacker, $defender)=@_;  # arguments, durr..
        my $alevel=$characters{$attacker}->{level};
	my $dlevel=$characters{$defender}->{level};   # hmm...
	if(exists $classes{$characters{$attacker}->{class}}->{hitsas}){
		$alevel=$classes{$characters{$attacker}->{class}}->{hitsas};
        } 
		# hitsas is a defense/attack rating
	if(exists $classes{$characters{$defender}->{class}}->{hitsas}){
		$dlevel=$classes{$characters{$defender}->{class}}->{hitsas};
	}
	if($characters{$attacker}->{class} =~ /dragon/){
		return 1;
	}
	if($characters{$attacker}->{weapon} eq 'sniper_rifle') {
		return 1;
	}
	if($characters{$attacker}->{class} eq 'twink'){
		return 1;
	}
	if($characters{$defender}->{class} eq 'bard'){
		return 1;
	}
	if ($dlevel < 1) { $dlevel = 1; } 
	my $prob=($alevel/$dlevel)*0.75;	
	if($prob>0.95){
		$prob=0.95;
	}
	if($prob<0.25){
		$prob=0.25;
	}
	return (rand()<=$prob);
}
# damage dealt.. (physical 'hits' only)
sub damage_dealt{ my ($name)=@_;
	my $level=$characters{$name}->{level};
        my $dmg=$classes{$characters{$name}->{class}}->{damage};
        $dmg = $dmg + int(.6 * $level);
	if((($characters{$name}->{class} eq 'twink') ||
		$characters{$name}->{class} =~ /dragon/) && int(rand(6))==1){
		say("CRITICAL HIT!");
		return 10*$dmg;
      }elsif(($characters{$name}->{class} =~ /fighter/)){
            $monk_damage = ( (0.07 * $level) + 1) * $classes{$characters{$name}->{class}}->{damage};
            if(rand(50)<rand($level)){
			say("CRITICAL HIT!");
	            return 10*$monk_damage;
            }else{
	            return $monk_damage;
            }
      }elsif(($characters{$name}->{class} =~ /dragonmaster/)){
            $monk_damage = ( (0.07 * $level) + 1) * $classes{$characters{$name}->{class}}->{damage};
            if(rand(30)<rand($level)){
			say("CRITICAL HIT!");
	            return 10*$monk_damage;
            }else{
	            return $monk_damage;
            }
	  }elsif(($characters{$name}->{class} =~ /ninja/)){
            $monk_damage = ( (0.06 * $level) + 1) * $classes{$characters{$name}->{class}}->{damage};
            if(rand(65)<rand($level)){
			say("CRITICAL HIT!");
	            return 10*$monk_damage;
            }else{
	            return $monk_damage;
            }
      }elsif(($characters{$name}->{class} =~ /hunter/)){
            $monk_damage = ( (0.07 * $level) + 1) * $classes{$characters{$name}->{class}}->{damage};
            if(rand(65)<rand($level)){
			say("CRITICAL HIT!");
	            return 10*$monk_damage;
            }else{
	            return $monk_damage;
            }
				
      }elsif(($characters{$name}->{class} =~ /slayer_knight/)){
            $monk_damage = ( (0.03 * $level) + 1) * $classes{$characters{$name}->{class}}->{damage};
            if(rand(60)<rand($level)){
			say("CRITICAL HIT!");
	            return 10*$monk_damage;
            }else{
	            return $monk_damage;
            }
      }elsif(($characters{$name}->{class} =~ /holy_knight/)){
            $monk_damage = ( (0.03 * $level) + 1) * $classes{$characters{$name}->{class}}->{damage};
            if(rand(60)<rand($level)){
			say("CRITICAL HIT!");
	            return 10*$monk_damage;
            }else{
	            return $monk_damage;
            }
				
	   }elsif($characters{$name}->{class} =~ /monk/){
            $monk_damage = ( (0.09 * $level) + 1) * $classes{$characters{$name}->{class}}->{damage};
            if(rand(40)<rand($level)){
			say("CRITICAL HIT!");
	            return 10*$monk_damage;
            }else{
	            return $monk_damage;
            }
	}elsif(int(rand(50))==1){
		say("CRITICAL HIT!");
		return 10*$dmg;
	}else{
		return $dmg;
	}
}
#mp give/take thing
sub mp_damage{ my ($attacker, $target, $amount) = @_;
		my $actual = int((rand()+.1)*($amount*.9)+1);
		if ($actual > $characters{$target}->{mp}) { $actual = $characters{$target}->{mp}; }
		if ($actual < 0) { 
			my $said = -$actual;
			say("\2$target\2 gains \2$said\2mp");
		}else{
			say("\2$target\2 is drained of \2$actual\2mp by \2$attacker\2");
			}
		$characters{$target}->{mp}-=$actual;
		correct_points($target);
		return $actual;
}
# doing actual damage, or healing
sub cause_damage{ my ($attacker,$name,$amount, $element)=@_;
    if($characters{$attacker}->{seffect} eq 'damagex2') { $amount = $amount * 2; }
	elsif($characters{$attacker}->{seffect} eq 'damage/2' || $characters{$attacker}->{seffect} eq 'mini') { $amount = $amount / 2; }
    my $elem_multi = element_multi($element,$characters{$name}->{class});
	
#'red','blue','yellow','octarine','plaid','purple','white','orange', 'green', 'black'are now status effects...
# red = fire blue = ice yellow = lightning plaid = weak to all, octarine = strong to all purple = energy
# white = holy green= chem, black = dark gold = absorb all orange = extreme weakness to all
	if($characters{$name}->{seffect} eq 'blue') {
		if ($element eq 'fire') {
			$elem_multi = 4;
		}
		elsif ($element eq 'ice') {
			$elem_multi = -1;
		}
	}
	elsif($characters{$name}->{seffect} eq 'red') {
		if ($element eq 'fire') {
			$elem_multi = -1;
		}
		elsif ($element eq 'ice') {
			$elem_multi = 4;
		}
	}
	elsif($characters{$name}->{seffect} eq 'yellow') {
		if ($element eq 'lit') {
			$elem_multi = .25;
		}
		elsif ($element eq 'ice') {
			$elem_multi = 3;
		}
		elsif ($element eq 'dark') {
			$elem_multi = 3;
		}
	}
	elsif($characters{$name}->{seffect} eq 'purple') {
		if ($element eq 'energy') {
			$elem_multi = .25;
		}
		elsif ($element eq 'chem') {
			$elem_multi = 3;
		}
		elsif ($element eq 'blue') {
			$elem_multi = 3;
		}
	}
	elsif($characters{$name}->{seffect} eq 'white') {
		if ($element eq 'holy') {
			$elem_multi = -1;
		}
		elsif ($element eq 'chem') {
			$elem_multi = 2;
		}
		elsif ($element eq 'dark') {
			$elem_multi = 4;
		}
	}
	elsif($characters{$name}->{seffect} eq 'black') {
		if ($element eq 'dark') {
			$elem_multi = -1;
		}
		elsif ($element eq 'energy') {
			$elem_multi = 2;
		}
		elsif ($element eq 'holy') {
			$elem_multi = 4;
		}
	}
	elsif($characters{$name}->{seffect} eq 'green') {
		if ($element eq 'chem') {
			$elem_multi = -1;
		}
		else { $elem_multi = 1.5; }
	}
	elsif($characters{$name}->{seffect} eq 'plaid') {
		$elem_multi = 2;
	}
	elsif($characters{$name}->{seffect} eq 'gold') {
		$elem_multi = -1;
	}
	elsif($characters{$name}->{seffect} eq 'octarine') {
		$elem_multi = .5;
	}
	elsif($characters{$name}->{seffect} eq 'orange') {
		$elem_multi = 10;
	}
	elsif($characters{$name}->{seffect} eq 'return_damage' && !($characters{$attacker}->{seffect} eq 'return_damage')) {
		cause_damage($name,$attacker,$amount,$element);
		if ($characters{$attacker}->{hp} <= 0) { defeats($name,$attacker); return; }
	}
	elsif($characters{$name}->{seffect} eq 'protect') {
		$amount = $amount * .5;
	}
	elsif($characters{$name}->{seffect} eq 'weak_bodied' || $characters{$name}->{seffect} eq 'mini') {
		$amount = $amount * 2;
	}
	$amount = $amount * $elem_multi;
	if($amount == 0){
		say("\2$name\2 is not affected");
	}elsif($amount>0){
            my $actual=int((rand()+.05)*($amount*0.955)+1);				# kenard's new damage algorithm adds a minimum of 5% damage
                if ($elem_multi>4) {
					say("\2$name\2 is massively weak to that kind of attack!");
                }
				elsif ($elem_multi>1) {
					say("\2$name\2 is weak to that kind of attack!");
                }elsif ($elem_multi < 0) {
					say("\2$name\2 absorbs that type of damage!");
				}elsif ($elem_multi==0) {
					say("\2$name\2 is not affected by that type of attack!");
				}elsif ($elem_multi<1) {
					say("\2$name\2 is resistant!");
				}
	        if ( $characters{$name}->{seffect} eq 'mpshield') #checks if the person has a sheild on - webrunner
		    {

                my $mpdamage = $actual;
                my $hpdamage = 0;
                
			    if ($actual > ($characters{$name}->{mp})) {
			        $mpdamage = $characters{$name}->{mp};
			        $hpdamage = $actual - $characters{$name}->{mp};
			    }
               
                $actual = $hpdamage;
                $characters{$name}->{mp}-=$mpdamage;
                say("\2$attacker\2 hits \2$name\2\'s magic shield for \2$mpdamage\2 points of damage!");

            
			}


		
		if (!($element eq 'none' )) {
			say("\2$attacker\2 hits \2$name\2 for \2$actual\2 points of $element damage!");
		}else {
			say("\2$attacker\2 hits \2$name\2 for \2$actual\2 points of damage!");
		}
	
		
		$characters{$name}->{hp}-=$actual;
		$totaldamage = $totaldamage + $actual;
		logprint("Target HP: $characters{$name}->{hp}\n");
	}
    else{
		$amount=-$amount;
		my $actual=int(rand()*$amount+1);
		say("\2$name\2 is healed of \2$actual\2 points of damage.");
		$characters{$name}->{hp}+=$actual;
		$totaldamage = $totaldamage - $actual;
	}
	if($name eq 'monster' && $characters{monster}->{delay}<=time()){
		$characters{monster}->{delay}=time()-10;
	}
	
	correct_points($name);

}

## cause damage to everybody




sub attack_free{ my ($attacker, $defender)=@_;
	my $elem = 'none';
	if(exists $characters{$defender}) {	
			my $basedamage = damage_dealt($attacker);
			if (exists $characters{$attacker}->{weapon}) {
				my $weapon = $characters{$attacker}->{weapon};
				if (! ($weapon eq 'none')) {
					my $weapondamage = $equips{$weapon}->{rating};
					my $weapondamage2 = 1;
					if ( $weapondamage >= 0 ) {  $weapondamage2 = sqrt sqrt $weapondamage; }
					else {  $weapondamage2 = $weapondamage / 3 };
			#		sayto('webrunner',"DEBUG: $basedamage $weapondamage $weapondamage2");
					$basedamage = $basedamage * $weapondamage2;
					$elem = $equips{$weapon}->{element};
					if ( exists $special_weapons{$weapon} ) {
						$basedamage = &{$special_weapons{$weapon}}($attacker,$defender,$basedamage, $elem);
					#	sayto('webrunner', "DEBUG 2: $basedamage");
						if (! exists $characters{$defender}) {delay($attacker,5); return; }
					}
					

				}
			 }
			 if($characters{$attacker}->{seffect} eq 'nexrel') {
				$basedamage = $basedamage * 10;
				$elem = 'dark';
			 }

			

			cause_damage($attacker,$defender, $basedamage, $elem);
		#	if($characters{$defender}->{hp}<=0){
		#		defeats($attacker,$defender);
	#	}
	}

}







# attacking
sub attack{ my ($attacker, $defender)=@_;
	my $elem = 'none';
	if($characters{$attacker}->{isresting}){
		sayto($attacker, "You can't do that, you're resting!");
		return;
	}
	if($characters{$defender}->{isresting}){
		sayto($attacker, "You can't do that, that's not nice!");
		return;
	}
	my $currenttime=  time();
	#say("Current Time: $currenttime Delay $characters{$attacker}->{delay} - Time > Delay?");
	if($characters{$attacker}->{delay}<=time()){
		#say("Yes!");
		if(does_hit($attacker,$defender)){


			my $basedamage = damage_dealt($attacker);
			if (exists $characters{$attacker}->{weapon}) {
				my $weapon = $characters{$attacker}->{weapon};
				if (! ($weapon eq 'none')) {
					my $weapondamage = $equips{$weapon}->{rating};
					my $weapondamage2 = 1;
					if ( $weapondamage >= 0 ) {  $weapondamage2 = sqrt sqrt $weapondamage; }
					else {  $weapondamage2 = $weapondamage / 3 };
			#		sayto('webrunner',"DEBUG: $basedamage $weapondamage $weapondamage2");
					$basedamage = $basedamage * $weapondamage2;
					$elem = $equips{$weapon}->{element};
					if ( exists $special_weapons{$weapon} ) {
						$basedamage = &{$special_weapons{$weapon}}($attacker,$defender,$basedamage, $elem);
					#	sayto('webrunner', "DEBUG 2: $basedamage");
						if (! exists $characters{$defender}) {delay($attacker,5); return; }
					}
					

				}
			 }
			 if($characters{$attacker}->{seffect} eq 'nexrel') {
				$basedamage = $basedamage * 10;
				$elem = 'dark';
			 }

			

			cause_damage($attacker,$defender, $basedamage, $elem);
			if($characters{$defender}->{hp}<=0){
				defeats($attacker,$defender);
			}
		}else{
			say("\2$defender\2 nimbly evades a strike from \2$attacker\2");
		}
		if(exists $characters{$attacker}){
			delay($attacker,5);
		}
	}else{
		penalty($attacker);
	}
}
sub donate{ my ($donator, $donated, $amount)=@_;
my $test1 = exists $characters{$donator};
my $test2 = exists $characters{$donated};
#sayto('webrunner', "DEBUG: $donator : $test1 $donated : $test2");
	if ((exists $characters{$donator}) && (exists $characters{$donated}) ) {

		if( ! exists $characters{$donator}->{gold} ) { $characters{$donator}->{gold} = 0; }
		if( ! exists $characters{$donated}->{gold} ) { $characters{$donated}->{gold} = 0; }
		if( $characters{$donator}->{gold} >= $amount ) {
			$characters{$donator}->{gold} = $characters{$donator}->{gold} - $amount;
			$characters{$donated}->{gold} = $characters{$donated}->{gold} + $amount;
			say("\2$donator\2 donated \2$amount\2 gold to \2$donated\2!");
		}else {
			say("You can't donate that much."); 
		}

	}else {
		say("You cant do that.");
	}
}


sub  give_item{ my ($donator, $donated, $item)=@_;
my $test1 = exists $characters{$donator};
my $test2 = exists $characters{$donated};
#sayto('webrunner', "DEBUG: $donator : $test1 $donated : $test2");
	if ((exists $characters{$donator}) && (exists $characters{$donated}) ) {

		if( $inv{$donator}->{$item} >= 1 ) {
			$inv{$donator}->{$item} =$inv{$donator}->{$item} - 1;
			$inv{$donated}->{$item} =$inv{$donated}->{$item} + 1;
			say("\2$donator\2 gave a \2$item\2 to \2$donated\2!");
		}else {
			say("You can't give one of those."); 
		}

	}else {
		say("You cant do that.");
	}
}


# level up effects for stuff (weird)
my %level_effects=(
twink=>sub {my ($name)=@_;
	if($characters{$name}->{level}>=20){
		say("The light that burns twice as bright burns but half as long.");
		defeats($name,$name);
		say("Twink!");
	}
	$last_twink=time();
},
harlot=>sub {my ($name)=@_;
	if($characters{$name}->{level}>=20){
		say("The years of careless living and drug abuse take their toll!");
		say("\2$name\2 degenerates into a \2skank\2!");
		$characters{$name}->{xp}=0;
		$characters{$name}->{class}='skank';
		$characters{$name}->{level}=1;
		learned($name,$characters{$name}->{class});
	}
},
skank=>sub {my ($name)=@_;
	if($characters{$name}->{level}>=20){
		say("The years of careless living and drug abuse take their toll!");
		say("\2$name\2 degenerates into a \2hag\2!");
		$characters{$name}->{xp}=0;
		$characters{$name}->{class}='hag';
		$characters{$name}->{level}=1;
		learned($name,$characters{$name}->{class});
	}
},
hag=>sub {my ($name)=@_;
	if($characters{$name}->{level}>=10){
		say("The years of careless living and drug abuse take their toll!");
		say("\2$name\2 degenerates into a \2wretch\2");
		$characters{$name}->{hp}=1;
		$characters{$name}->{mp}=0;
		$characters{$name}->{maxhp}=1;
		$characters{$name}->{maxmp}=0;
		$characters{$name}->{xp}=0;
		$characters{$name}->{class}='wretch';
		$characters{$name}->{level}=1;
		learned($name,$characters{$name}->{class});
	}
},
spider_man=>sub {my ($name)=@_;
	my %effects=(
		2=>"\2$name\2 eyes bulge and segment!",
		3=>"\2$name\2 grows spinnerets!",
		4=>"\2$name\2 grows disgusing spider-hair all over his body!",
		5=>"\2$name\2 head now looks just like a spider's!",
		6=>"\2$name\2 starts to grow 2 new pairs of limbs from his torso!",
		7=>"\2$name\2 now has two distinct body segments!",
		8=>"\2$name\2 can now walk around on all eights!",
		9=>"\2$name\2 eyes his friends hungrily!",
	);
	if($characters{$name}->{level}>=10 && !exists($characters{monster})){
		say("\2$name\2 completes his transformation into a \2radioactive_spider\2.");
		say("\2$name\2 loses his mind!");
		new_character('monster','radioactive_spider','impossible!ID@!@!@');
		delete $characters{$name};
		delete $present{$name};
		delete $concealed{$name};
		say("\2$name\2 is now \2monster\2!");
	}else{
		if(exists $effects{$characters{$name}->{level}}){
			say($effects{$characters{$name}->{level}});
		}
	}
},
);

# taking away levels
sub level_down{ my ($name)=@_;
	my $class=$characters{$name}->{class};
	my $origxp=xp_needed($name);
	$characters{$name}->{level}-=2;
	$characters{$name}->{maxhp}-=int(rand($classes{$class}->{hp})+1);
	if($classes{$class}->{mp}!=0){
		$characters{$name}->{maxmp}-=int(rand($classes{$class}->{mp})+1);
	}
	if($characters{$name}->{level}<1){
		$characters{$name}->{xp}=0;
	}else{
		$characters{$name}->{xp}=xp_needed($name);
	}
	$characters{$name}->{level}+=1;
	if($characters{$name}->{level}<1 ||
	 $characters{$name}->{maxhp}<1 ||
	 $characters{$name}->{maxmp}<0){
		say("\2$name\2's body couldn't take the strain!  It crumbles to dust.");
		delete $characters{$name};
		delete $present{$name};
		delete $concealed{$name};
		return;
	}
}

# giving levels
sub level_up{ my ($name)=@_;
	my $class=$characters{$name}->{class};
	$characters{$name}->{level}+=1;
	$characters{$name}->{maxhp}+=int(rand($classes{$class}->{hp})+1);
	if($classes{$class}->{mp}!=0){
		$characters{$name}->{maxmp}+=int(rand($classes{$class}->{mp})+1);
	}
	if (! ($characters{$name}->{xp} > xp_needed($name))) {
	say("\2$name\2 LEVELS UP!");
	say("\2$name\2 is now a Level \2$characters{$name}->{level} $class\2!");
	}
	learned($name,$class);
	if($characters{$name}->{level}==100){
		say("This is getting ridiculous.  Level 100?!");
	}
	if(exists $level_effects{$class}){
		&{$level_effects{$class}}($name);
	}
}
# if you have too many hp/mp, bring it back to the max.
sub correct_points{ my ($name)=@_;
	if($name ne $mimicking){
		if(exists $characters{$name}->{class}) {
			if ($characters{$name}->{hp}>$characters{$name}->{maxhp}){
				$characters{$name}->{hp}=$characters{$name}->{maxhp};
			}
			if($characters{$name}->{mp}>$characters{$name}->{maxmp}){
				$characters{$name}->{mp}=$characters{$name}->{maxmp};
			}
			if ($characters{$name}->{hp} > 0) { $characters{$name}->{dead} = "false"; }
			while(exists($characters{$name}) &&
			 $characters{$name}->{xp} >= xp_needed($name)){
				level_up($name);
			}
		}else{
			delete $characters{$name};
			delete $present{$name};
			delete $concealed{$name};
		}
	}
}
sub defeats_status{ my ($victor,$victim)=@_;
	#$dopple = 0;

	if(! exists $characters{$victim}){
       
		return;	# no victims?, get outta here!
	}
	if (! exists $characters{$victim}->{class}) { # empty
		return ;

	}
	
	if (! exists $characters{$victim}->{hp}) { # empty
		return ;

	}


	
	if ($characters{$victim}->{hp} eq '') {
		return;
	}
	

	if ($characters{$victim}->{hp} eq NULL) {
		return;
	}
	
	if ($characters{$victim}->{dead} eq "true") { return; }
	

	$grudge = $grudge + 1;
	if($characters{$victim}->{hp}<=0){
		say("\2$victim\2 is struck dead!");
	}
	drop_weapon($victim);
	my @victors=();  	# all the different victors
	my $victim_class=$characters{$victim}->{class};
	if (exists $slimelist{$victim_class}) {
		$slimeslayer = $slimeslayer+1;
	}
	if (exists $goblin{$victim_class}) {
		$goblinslayer = $goblinslayer+1;
	}
	if (exists $dragons{$victim_class}) {
		$dragonslayer = $dragonslayer+1;
	}
	if (exists $wolves{$victim_class}) {
		$wolfslayer = $wolfslayer+1;
	}
	if (exists $humans{$victim_class}) {
		$manslayer = $manslayer+1;
	}
	if (exists $demons{$victim_class}) {
		$demonslayer = $demonslayer+1;
	}
	if (exists $cans{$victim_class}) {
		$canslayer = $canslayer+1;
	}
	my $gold = gold_value($victim);
	$characters{$victim}->{gold} = 0;
	if(exists $weird_deaths{$victim_class}){
		my $normal_victory= &{$weird_deaths{$victim_class}}($victim,$victor);
		return if not $normal_victory;  # weird death?
	}
	if($victim eq 'monster'){
		@victors=get_party(); # well, if it was a monster, then find out who was in the party
		#$conn_self->mode($channel,"-m");
	}
	else{			#set mode -v if it was a person.
		$conn_self->mode($channel,"-v",$victim);
	}
	say("\2$victor\2 defeats \2$victim\2!");
	if ($dueling eq "1"){
            $dueling = "";                                          #dueling conditions
            say("\2$victor\2 wins the duel!!!");
                if(exists($characters{$victor})){
			$characters{$victor}->{win}++;
		}
	}
	push @victors,$victor;
        my $value=xp_value($victim);
		#my $gold = gold_value($victim);
	$graveyard{$victim}=$characters{$victim};		# throw the bum in the graveyard
	if(($victim ne 'monster') && ($characters{$victim}->{class} ne 'twink')){
		$graveyard{$victim}->{delay}=time(); 	# that is, if its not a monster
	}else{
		$graveyard{$victim}->{delay}=time()-500;  # cause if it is, no summoning for you
	}
	$defeated{$characters{$victim}->{staticid}}=$victim;
	delete $characters{$victim};				# delete the victim from character list
	delete $present{$victim};				# delete it from party list
	#if(!get_party()){$conn_self->mode($channel,"-m");}
	for(@victors){
		if($_ ne $victim && exists($characters{$_})){
			$characters{$_}->{xp}+=int($value/scalar(@victors));
			if($characters{$_}->{weapon} eq 'textbook') { $characters{$_}->{xp}+=int($value/scalar(@victors)); }
		} # well, give the winners some xp
		
			
	}	
	for(@victors){
		if($_ ne $victim && exists($characters{$_})){
			if (! exists $characters{$_}->{gold} ) {  $characters{$_}->{gold} = 0; }
			$characters{$_}->{gold}+=int($gold/scalar(@victors));
				if($characters{$_}->{class} eq 'thief') { $characters{$_}->{gold}+=int(($gold/scalar(@victors))/3); }
		
		} # well, give the winners some gold too
		
	}
	my $gained = int($value/scalar(@victors));
	say("gained $gained exp!");
	for(@victors){
		if($_ ne $victim && exists($characters{$_})){
			correct_points($_);
		}
	}
	$gained = int($gold/scalar(@victors));
	say("gained $gained gold!");
		delete $characters{$victim};				# delete the victim from character list
	delete $present{$victim};				# delete it from party list

}
# the winner, and still champeen.
sub defeats{ my ($victor,$victim)=@_;
#	$dopple = 0;

	if(! exists $characters{$victim}){
       
		return;	# no victims?, get outta here!
	}
	if (! exists $characters{$victim}->{class}) { # empty
		return ;

	}
	if (! exists $characters{$victim}->{hp}) { # empty
		return ;

	}

	
	if ($characters{$victim}->{hp} eq '') {
		return;
	}
	

	if ($characters{$victim}->{hp} eq NULL) {
		return;
	}
	
	if ($characters{$victim}->{dead} eq "true") { return; }
	
	$grudge = $grudge + 1;
	if($characters{$victim}->{hp}<=0){
		say("\2$victim\2 is struck dead!");
		$characters{$victim}->{dead} = "true";
	
	}
	my $gold = gold_value($victim);
	drop_weapon($victim);

	$characters{$victim}->{gold} = 0;
	my @victors=();  	# all the different victors
	
	
	my $victim_class=$characters{$victim}->{class};
	if (exists $slimelist{$victim_class}) {
		$slimeslayer = $slimeslayer+1;
	}
	if (exists $dragons{$victim_class}) {
		$dragonslayer = $dragonslayer+1;
	}
	if (exists $wolves{$victim_class}) {
		$wolfslayer = $wolfslayer+1;
	}
	if (exists $goblin{$victim_class}) {
		$goblinslayer = $goblinslayer+1;
	}
	if (exists $humans{$victim_class}) {
		$manslayer = $manslayer+1;
	}
	if (exists $demons{$victim_class}) {
		$demonslayer = $demonslayer+1;
	}
	if (exists $cans{$victim_class}) {
		$canslayer = $canslayer+1;
	}
	if(exists $characters{$victim}->{doppelganger}){
		my $lifebond=$characters{$victim}->{doppelganger};
			if(exists $characters{$lifebond}){
			say("The doppelganger's life bond with \2$lifebond\2 is severed...");
			if(rand()<0.5){
				defeats($victim,$lifebond);
			}else{
				say("draining \2$lifebond\2's spirit!");
				my $lost=int($characters{$lifebond}->{level}/2);
				for(0..$lost){level_down($lifebond)}
			}
		}
	}
	if(exists $weird_deaths{$victim_class}){
		my $normal_victory= &{$weird_deaths{$victim_class}}($victim,$victor);
		return if not $normal_victory;  # weird death?
	}

	if($victim eq 'monster'){
		@victors=get_party(); # well, if it was a monster, then find out who was in the party
		#$conn_self->mode($channel,"-m");
	}
	else{			#set mode -v if it was a person.
		$conn_self->mode($channel,"-v",$victim);
	}
	say("\2$victor\2 defeats \2$victim\2!");
	if ($dueling eq "1"){
            $dueling = "";                                          #dueling conditions
            say("\2$victor\2 wins the duel!!!");
                if(exists($characters{$victor})){
			$characters{$victor}->{win}++;
		}
	}
	push @victors,$victor;
        my $value=xp_value($victim);
	
	$graveyard{$victim}=$characters{$victim};		# throw the bum in the graveyard
	if(($victim ne 'monster') && ($characters{$victim}->{class} ne 'twink')){
		$graveyard{$victim}->{delay}=time(); 	# that is, if its not a monster
	}else{
		$graveyard{$victim}->{delay}=time()-500;  # cause if it is, no summoning for you
	}
	$defeated{$characters{$victim}->{staticid}}=$victim;
		delete $characters{$victim};				# delete the victim from character list
	delete $present{$victim};				# delete it from party list


	#if(!get_party()){$conn_self->mode($channel,"-m");}

	for(@victors){
		if($_ ne $victim && exists($characters{$_})){
			$characters{$_}->{xp}+=int($value/scalar(@victors));
			if($characters{$_}->{weapon} eq 'textbook') { $characters{$_}->{xp}+=int($value/scalar(@victors)); }
		} # well, give the winners some xp
		
			
	}	
	for(@victors){
		if($_ ne $victim && exists($characters{$_})){
			if (! exists $characters{$_}->{gold} ) {  $characters{$_}->{gold} = 0; }
			$characters{$_}->{gold}+=int($gold/scalar(@victors));
				if($characters{$_}->{class} eq 'thief') { $characters{$_}->{gold}+=int(($gold/scalar(@victors))/3); }
		
		} # well, give the winners some gold too
		
	}

	my $gained = int($value/scalar(@victors));
	say("gained $gained exp!");

	for(@victors){
		if($_ ne $victim && exists($characters{$_})){
			correct_points($_);
		}
	}

	$gained = int($gold/scalar(@victors));
	say("gained $gained gold!");
	if(exists $characters{$victor}){
		if (rand(5000000) < ( net_grudge() * $characters{$victor}->{level}) ) {
			say("A voice booms from nowhere... 'Well well well.. you have shown yourself to be powerful warriors.  Today, you face your greatest challenge. . .'");
			new_character('monster','eternion','impossible!ID@!@!@');
			$antigrudge=$grudge;
		}
	}
}

sub gold_value{ my ($name)=@_; 
		if (! exists $characters{$name} ) { return 0 ; }
			return int( $classes{$characters{$name}->{class}}->{gold}) + $characters{$name}->{gold};
}
# rezzy
sub resurrect{ my ($name)=@_;
	if(! exists $graveyard{$name}){
		return; 							# if hes not there, then dont do anything
	}
	delete $defeated{$characters{$name}->{staticid}}; 	# otherwise, get him out of the defeated list
	$characters{$name}=$graveyard{$name};			# give him back his name
	$characters{$name}->{hp}=1;					# crappy hp and mp, plus rest
	$characters{$name}->{mp}=0;
	$characters{$name}->{dead} = "false";
	$characters{$name}->{isresting}=1;
	$conn_self->mode($channel,"-v",$name);
	delete $graveyard{$name};					# get him out of the graveyard
	say("\2$name\2 is restored to life! (he is weakened from his ordeal)");
        level_down($name); level_down($name);                                 # level down
}

sub clean_grave{ my ($static)=@_;					# delete the all the people ( no life for them )
	delete $graveyard{$defeated{$static}};
	delete $defeated{$static};
}
										# not really sure what this does, maybe a check to see if its dead.
sub is_dead{ my ($static)=@_;
	return exists $defeated{$static};
}
										# how long have they been dead?
sub death_time{ my ($static)=@_;
	return $graveyard{$defeated{$static}}->{delay};
}

sub can_cast{ my ($caster,$spell)=@_;				# can you cast it ( do you have the mp, and the spell, and the level )
	my $cost = $spells{$spell}->{cost};
	if ($characters{$caster}->{weapon} eq 'book_of_magic') { $cost = int($cost / 2); }
	return ($characters{$caster}->{mp} >= $cost) &&
	 exists($classes{$characters{$caster}->{class}}->{spells}->{$spell}) &&
	 ($classes{$characters{$caster}->{class}}->{spells}->{$spell} <=
	 $characters{$caster}->{level});
}

sub can_summon{ my ($caster,$class)=@_;				# do you have the summon, do you have the mp?
	if(! exists($characters{$caster})){return 0;}
	if($characters{$caster}->{class} ne 'summoner'){return 0;}
	if(exists $characters{$caster}->{summons}->{$class}){
		my $cost = summon_cost($class);
		if ($characters{$caster}->{weapon} eq 'summon_staff') { $cost = int($cost / 2); }
		if($cost > $characters{$caster}->{mp}){
			return 0;
		}else{
			return 1;
		}
	}else{
		return 0;
	}
}
										# finds out the spell cost.
sub summon_cost{ my ($class)=@_;
	return $spells{$summons{$class}}->{cost};
}


#--------------------------------#
# The summoning sub
#--------------------------------#
sub summon{ my ($caster,$class,$target)=@_;			# declaring variables			
	if(! exists $characters{$caster}){	
		return;							
	}
	if($characters{$caster}->{class} ne summoner){		
		sayto($caster, "Only a \2summoner\2 can summon creatures.");	# class verification
		return;
	}
	if($characters{$caster}->{isresting}){
		sayto($caster, "You can't do that, you're resting!");			# resting...
		return;
	}
	if($characters{$caster}->{delay}<=time()){
		if(can_summon($caster,$class)){
			my $spell=$summons{$class};
			my $damage=$spells{$spell}->{damage};
			my $cost = $spells{$spell}->{cost};
			if ($characters{$caster}->{weapon} eq 'summon_staff') { $cost = int($cost / 2); }
			$characters{$caster}->{mp}-=$cost;
			if(rand()<(0.70+$characters{$caster}->{level}/100)){	
				if(exists $characters{$caster}){
					delay($caster,9);		# check to see if it fails, plus at the 9 second delay.
				}
				say("\2$caster\2 summons \2$class\2 to cast \2$spell\2!");
				if(rand() > 0.98){
					say("...but loses control of the \2$class\2!");	# failed....
					if($present{monster}){
						$target=rand_el(get_targets(),'monster');
					}else{
						$target=rand_el(get_targets());
					}
				}
				if(exists $special_spells{$spell}){
					&{$special_spells{$spell}}($caster,$target);
				}else{
					cause_damage($caster,$target,$damage, $spells{$spell}->{element});
				}
				if($characters{$target}->{hp}<=0){				# we have a winner.
					defeats($caster,$target);
				}
				if(exists $characters{$caster}){				# give exp for casting a spell, and correct the points
					$characters{$caster}->{xp}+=int($cost/2);
					correct_points($caster);
				}
			}else{
				say("\2$caster\2 fails to summon \2$class\2");		# failed..
			}
		}else{
			sayto($caster, "You can't summon that!");				# didnt pass other stuff
		}
	}else{
		penalty($caster);									# add 5 second delay
	}
}

#------------------------------------------------------#
# spell casting
#------------------------------------------------------#
sub free_cast{ my ($caster, $spell, $target)=@_;
	my $target_ok=exists($characters{$target});
	my $target_hurt=(!exists($characters{$target})) ||
	 $characters{$target}->{hp}<$characters{$target}->{maxhp};
	my $cost=$spells{$spell}->{cost};

	my $damage=$spells{$spell}->{damage};
	my $defeat_check=1;
	my $special_spell = 0;
	if((rand()>0.94) && ($spell ne "magic_missile") && ($spell ne "sureshot") && ($spell ne "aimshot")){
		say("\2$caster\2's spell fizzles!");	# 3% chance of spell fizzle
	}elsif( $characters{$target}->{seffect} eq 'white_dragon_protect' ) {
		say("\2$target\2 is protected by the white dragon!");
		$characters{$target}->{seffect} = 'none';
		$characters{$target}->{sefftime} = 1;
	}else{
		if(exists $characters{$caster}){
			delay($caster,7);	# 7 second delay for spells
		}
		say("\2$caster\2 casts \2$spell\2!");
		if(exists $special_spells{$spell}){
			$defeat_check= &{$special_spells{$spell}}($caster,$target);
			$special_spell = 1;
		}else{
			cause_damage($caster,$target,$damage,$spells{$spell}->{element});
		}
		if($defeat_check && $target_ok && $characters{$target}->{hp}<=0){
			defeats($caster,$target);		# call up defeats if the spell worked, the target is there, and hp < 0
		}

		my $raised= (!$target_ok) && exists($characters{$target});
		my $wounded= $target_ok && $damage > 0;
		my $healed= $target_hurt && $damage < 0;
		my $useful= $raised || $wounded || $healed || $special_spell;	# people that did stuff.
				
		if($characters{$caster}->{hp}<=0) {
			defeats($caster,$caster);
		}
	}
	
}

sub cast{ my ($caster, $spell, $target)=@_;

	if($characters{$caster}->{isresting}){
		sayto($caster, "You can't do that, you're resting!");
		return;
	}
	if($characters{$caster}->{delay}<=time()){
		if(can_cast($caster,$spell)){
			my $target_ok=exists($characters{$target});
			my $target_hurt=(!exists($characters{$target})) ||
			 $characters{$target}->{hp}<$characters{$target}->{maxhp};
			my $cost=$spells{$spell}->{cost};
			if ($characters{$caster}->{weapon} eq 'book_of_magic') { $cost = int($cost / 2); }
			my $damage=$spells{$spell}->{damage};
			my $defeat_check=1;
			my $special_spell = 0;
			$characters{$caster}->{mp}-=$cost;
			if((rand()>0.97) && ($spell ne "magic_missile") && ($spell ne "sureshot") && ($spell ne "aimshot")){
				say("\2$caster\2's spell fizzles!");	# 3% chance of spell fizzle
			}elsif( $characters{$target}->{seffect} eq 'white_dragon_protect' ) {
		say("\2$target\2 is protected by the white dragon!");
		$characters{$target}->{seffect} = 'none';
			}else{
				if(exists $characters{$caster}){
					delay($caster,7);	# 7 second delay for spells
				}
				say("\2$caster\2 casts \2$spell\2!");
				if(exists $special_spells{$spell}){
					$defeat_check= &{$special_spells{$spell}}($caster,$target);
					$special_spell = 1;
				}else{
					my $elem = $spells{$spell}->{element};
					if ($elem eq '') { $elem = 'none';
					}
					cause_damage($caster,$target,$damage,$elem);
				}
				if($defeat_check && $target_ok && $characters{$target}->{hp}<=0){
					defeats($caster,$target);		# call up defeats if the spell worked, the target is there, and hp < 0
				}

				my $raised= (!$target_ok) && exists($characters{$target});
				my $wounded= $target_ok && $damage > 0;
				my $healed= $target_hurt && $damage < 0;
				my $useful= $raised || $wounded || $healed || $special_spell;	# people that did stuff.
				if(exists $characters{$caster}){
					if($useful){
						my $xpgain=int($cost/2);		# give them some xp!
						if($xpgain>50){
							$xpgain=50;
						}
						$characters{$caster}->{xp}+=$xpgain;	# give them their hard earned xp	
						correct_points($caster);		
					}
				}
				if($characters{$caster}->{hp}<=0) {
					defeats($caster,$caster);
				}
			}
		}else{
			sayto($caster, "You can't cast that!");
		}
	}else{
		penalty($caster);
	}
}

sub status{ my ($name)=@_;
	if(!exists $characters{$name}){return;}
	my $element = "";
	my $strong = "resist";
	my $class = $characters{$name}->{class};
	foreach $elem (keys %{$classes{$class}->{elem}}) {
		if ($classes{$class}->{elem}->{$elem} < 0) {
			$strong = "absorb";
		}
		elsif ($classes{$class}->{elem}->{$elem} < 1) { 
			$strong = "resistant";
		}
		elsif ($classes{$class}->{elem}->{$elem} > 1) {
			$strong = "weakness";
		}
		if ($classes{$class}->{elem}->{$elem} != 1) {
			$element = $element . "$elem\:$strong ";
		}
	}
	if (! exists $characters{$name}->{gold} ) {  $characters{$name}->{gold} = 0; }
	say("\2$name\2 is a level \2$characters{$name}->{level}\2 ".
	 "\2$characters{$name}->{class}\2 with \2$characters{$name}->{hp}/$characters{$name}->{maxhp}\2 hit points,".
	 " \2$characters{$name}->{mp}/$characters{$name}->{maxmp}\2 magic points, ".
	 "\2$characters{$name}->{gold}\2 gold, and ".
		
	 "\2$characters{$name}->{xp}\2 experience points (\2". xp_needed($name) .
	 "\2 needed for next level.) Status: \2$characters{$name}->{seffect}\2".
	 " Elements: \2$element\2".
	 " Weapon: \2$characters{$name}->{weapon}\2"
	 );
}

sub penalty{ my ($name)=@_;

	delay($name,5);
	my $delaytime =  $characters{$name}->{delay} - time();
	if ($delaytime < 0) { logprint("!!!!!!!!!?  NEGATIVE.  IMPOSSIBLE.");
	}
	sayto($name,"Whoa!  Slow down!  That'll cost you another 5 seconds!  You now can't act for $delaytime seconds!");
}

sub defeated_penalty{ my ($name,$static)=@_;			# optional stuff.
	if($protect_chat){
		sayto($name,"Don't camp the spawn!  That'll cost you another 20 seconds.");
		$graveyard{$defeated{$static}}->{delay}+=20;
	}
}

# fleeing
sub flee{ my ($name)=@_;						
	if($characters{$name}->{isresting}){
		sayto($name,"You're already resting safely, fleeing won't do anything.");
        }elsif($dueling eq "1"){                              #dueling thing, so they can't escape
                sayto($name,"you can't escape a duel, Coward!");

	}elsif($characters{$name}->{delay}<=time()){
		if(int(rand(3))==1){
			say("\2$name\2 tried to flee, but couldn't escape!");
		}else{
			say("\2$name\2 flew in terror!");
			sayto($name,"You ran far away, grew tired, and sat down to rest.");
			$characters{$name}->{delay}=time()+60;
			$characters{$name}->{isresting}=1;
			$conn_self->mode($channel,"-v",$name);
			#if(!get_party()){ $conn_self->mode($channel,"-m");}			
		}
	}else{
		penalty($name);
	}
}

sub rest{ my ($name)=@_;
	if($characters{$name}->{isresting}){
		sayto($name, "You can't do that, you're already resting!");
		return;
	}
	if(exists $characters{monster}){
		sayto($name, "You can't do that, there's a monster! (try \2flee\2)");
		return;
	}
	if($dueling eq "1"){
		sayto($name, "You can't rest now, you in a fight to the death!");
		return;
	}
	if($characters{$name}->{delay}<=time()){
		if($protect_chat){
			sayto($name,"Use the '\2wake\2' command to stop resting (less than 60 seconds doesn't help at all, five minutes will restore you fully)");
		}else{
			sayto($name,"Use the '\2wake\2' command to stop resting (60 seconds will restore you to full strength)");
		}
		$characters{$name}->{delay}=time()+60;
		$characters{$name}->{isresting}=1;
		$conn_self->mode($channel,"-v",$name);
		say("\2$name\2 sits down and rests.");
	}else{
		penalty($name);
	}
}

# wakey wakey..
sub wake{ my ($name)=@_;
	if(!$characters{$name}->{isresting}){
		sayto($name,"You can't do that, you're already awake!");
		return;
	}
	if(exists $characters{monster}){
		sayto($name,"The party's gone off wandering, and is fighting a monster.");
		sayto($name,"You'll never catch up before the battle's over.");
	}elsif($dueling eq "1"){
		sayto($name,"You can't join the duel.");
	}else{
		if($characters{$name}->{delay}<=time()){
			my $factor=(time()-$characters{$name}+60)/300;
			if($protect_chat){
				$characters{$name}->{hp}+=int($characters{$name}->{maxhp}*$factor);
				$characters{$name}->{mp}+=int($characters{$name}->{maxmp}*$factor);
			}else{
				$characters{$name}->{hp}=$characters{$name}->{maxhp};
				$characters{$name}->{mp}=$characters{$name}->{maxmp};
			}
			$characters{$name}->{seffect} = 'none';
			correct_points($name);
			say("\2$name\2 arises, feeling refreshed");
		}else{
			say("\2$name\2 rises, grumpy and unrested.");
		}
		$characters{$name}->{isresting}=0;
		$conn_self->mode($channel,"+v",$name);
		#delay($name,5);
	}
}

# this seems to be the monsters, and their rarity....


#sub slots{
#	$slotmachine = (rand_el('bar','7','bag','skull','cherry','airship','apple','can','eternion'),
#       rand_el('bar','7','bag','skull','cherry','airship','apple','can','eternion'),
#		rand_el('bar','7','bag','skull','cherry','airship','apple','can','eternion'));
#		say("And the slot machine turns up.. $slotmachine");
#		if ($slotmachine = (7, 7, 7)) {
#			return 'jackpot';
#		}elsif ($slotmachine = (bar,bar,bar)) {
#			return 'jackpot2';
#		}elsif ($slotmachine = (7,7,skull)) {
#			return 'skull_jackpot';
#		}elsif ($slotmachine = (skull,skull,skull)) {
#			return 'death';
#		}elsif ($slotmachine = (bag,bag,bag)) {
#			return 'item';
#		}elsif ($slotmachine = (cherry,cherry,cherry)){
#			return 'cherry';
#		}elsif ($slotmachine = (airship,airship,airship)){
#			return 'airship';
#		}elsif ($slotmachine = (can,can,can)){
#			return 'can';
#		}elsif ($slotmachine = (apple,apple,apple)){
#			return 'apple';
#		}elsif ($slotmachine = (eternion,eternion,eternion)){
#			return 'eternion';
#		}elsif ($slotmachine = (bag, can, skull)) {
#			return 'slimeify';
#		}else { return 'other'; }
#}
# i dunno what this is, it usually just gives you slime
sub pick_random{ my ($area)=@_;
	my $total=0;
	if(! exists($areas{$area})){
		$area='hometown_plains';
	}
	for(keys %{$areas{$area}}){
		$total+=$areas{$area}->{$_};
	}
	my $rand=int(rand($total));
	$total=0;
	for(keys %{$areas{$area}}){
		$total+=$areas{$area}->{$_};
		if($total >= $rand){
			return $_;
		}
	}
	return 'slime';
}
sub pick_random_factor{ my ($area,$preferred,$factor)=@_;
	my $total=0;
	if(! exists($areas{$area})){
		$area='hometown_plains';
	}
	for(keys %{$areas{$area}}){
		$total+=$areas{$area}->{$_}*($_ eq $preferred ? $factor : 1);
		my $temp = $areas{$area}->{$_}*($_ eq $preferred ? $factor : 1);
		#sayto('web_runner',"DEBUG: $_ $temp Total: $total");
	}
	my $rand=int(rand($total));
	#sayto('web_runner',"DEBUG: $total Rand: $rand");
	$total=0;
	for(keys %{$areas{$area}}){
		$total+=$areas{$area}->{$_}*($_ eq $preferred ? $factor : 1);
		my $temp = $areas{$area}->{$_}*($_ eq $preferred ? $factor : 1);
		#sayto('web_runner',"DEBUG: $_ $temp Total: $total");
		if($total >= $rand){
			#sayto('web_runner',"DEBUG: Found $_");
			return $_;
		}
	}
	return 'slime';
}

sub wander_hunt{ my ($name,$area, $monster, $level)=@_;
	if(! exists $characters{$name}){
		return;
	}
	if($characters{$name}->{isresting}){
		sayto($name, "You can't wander, you're resting!");
		return;
	}
	if(! exists $characters{monster}){
		foreach(get_party()){
			delay($_,3);
		}
		my $temp1 = exists $areas{$area{$monster}};
		#my $temp2 = exists $classes{lc($monster)};
		my $temp3 = rand(10);
		#sayto('web_runner', "DEBUG: $monster $area $level $temp3 $temp1 $temp2");

			new_character('monster',pick_random_factor($area,$monster,$level*2),'impossible!ID@!@!@');

		$present{lc('monster')}=1;
		#$conn_self->mode($channel,"+m");
	}
}


sub wander{ my ($name,$area)=@_;
	if(! exists $characters{$name}){
		return;
	}
	if($characters{$name}->{isresting}){
		sayto($name, "You can't wander, you're resting!");
		return;
	}
	if(! exists $characters{monster}){
		foreach(get_party()){
			delay($_,3);
		}
		new_character('monster',pick_random($area),'impossible!ID@!@!@');
		$present{lc('monster')}=1;
		#$conn_self->mode($channel,"+m");
	}
}

sub tell_summons{ my ($name)=@_;
	if($characters{$name}->{class} eq 'summoner'){
		sayto($name, "The creatures you can summon are: ".
		join(' ',(map {"\2$_\2 (\2$spells{$summons{$_}}->{cost}\2 mp)"}
		 keys(%{$characters{$name}->{summons}}))));
	}
}

sub tell_spells{ my ($name)=@_;
	sayto($name, "The spells you know are: ".
	join(' ',(map {"\2$_\2 (\2$spells{$_}->{cost}\2 mp)"}
	 spells_known($name))));
}

sub tell_buy{ my ($name)=@_;
	sayto($name, "The weapons you can buy are: ".
	join(' ',(map {"\2$_\2 (\2$equips{$_}->{cost}\2 gold ($equips{$_}->{type}))"}
	 buy_list($name))));
	 sayto($name, "Use beng buy [WEAPON] without the brackets to buy a weapon.");
}

sub buy_list{ my ($name)=@_;
	my @ret=();
	for(keys %equips){
		my $weaptype = $equips{$_}->{type};
		my $class = $characters{$name}->{class};
		#sayto($name,"DEBUG: $name $_ $weaptype $classes{$class}->{weaptypes}->{$weaptype}");
		if(  (!(exists $equips{$_}->{legend}) ) &&( $classes{$class}->{weaptypes}->{$weaptype}) &&
		 ($characters{$name}->{gold} >= $equips{$_}->{cost})){
			push @ret, $_;
		}
	}
	return @ret;
}

# spells known is all the spells you have, while...
sub spells_known{ my ($name)=@_;
	my @ret=();
	for(keys %{$classes{$characters{$name}->{class}}->{spells}}){
		if( $classes{$characters{$name}->{class}}->{spells}->{$_} <=
		 $characters{$name}->{level}){
			push @ret, $_;
		}
	}
	return @ret;
}
# spells available is all the spells you can cast.... it checks for available mp as well.
sub spells_available{ my ($name)=@_;
	my @ret=();
	for(keys %{$classes{$characters{$name}->{class}}->{spells}}){
		if( ($classes{$characters{$name}->{class}}->{spells}->{$_} <=
		 $characters{$name}->{level}) &&
		 ($characters{$name}->{mp} >= $spells{$_}->{cost})){
			push @ret, $_;
		}
	}
	return @ret;
}

# how many spells does it have?
sub useful_spells{ my ($name)=@_;
	my @ret=();
	for(spells_available($name)){
		if($spells{$_}->{damage}<0){
			if($characters{$name}->{hp} < $characters{$name}->{maxhp}){
				push @ret, $_;
			}
		}else{
			push @ret, $_;
		}
	}
	return @ret;
}

# monsters want to do stuff
sub monster_action{
	if(exists($characters{monster})
	 && (time()>($characters{monster}->{delay}+int(rand(3))))){
		if(! exists $characters{monster}->{class}) { delete $characters{monster}; delete $present{monster}; return; }
		$characters{monster}->{isresting}=0;
		my @targets=get_targets();
		if(!get_party()){
			$dopple = 0;
			say("Everyone has escaped from the $characters{monster}->{class}!");	# nobody for the monster to play with
			$runaway = $runaway + 1;
			delete $characters{monster};
			delete $present{monster};
			#$conn_self->mode($channel,"-m");
			return;
		}
		if(@targets){
			my $target= $targets[rand(scalar(@targets))];					# pick a random person from the party
			my @sp=useful_spells('monster');							# how many spells does the monster have
			my $choice=int(rand(scalar(@sp) + 2));						# get a random number based on the number of spells the monster has + 2
			$present{monster}=1;
			delete $concealed{monster};

			if($choice>=2 || $characters{monster}->{class} eq 'doppelganger'){
				my $spell=$sp[$choice-2];							# pick that number
				say("The $characters{monster}->{class} (ID: \2monster\2) uses a spell!");
				if($spells{$spell}->{damage}<0){						
					cast('monster',$sp[$choice-2],'monster');				# if the damage is negative, use it on itself
				}else{
					cast('monster',$sp[$choice-2],$target);				# otherwize, attack the party
				}
			}else{
				say("The $characters{monster}->{class} (ID: \2monster\2) attacks \2$target\2!");
				attack('monster',$target);
			}
                        cause_status('monster');  # effect any poison or whatnot the monster may have. - webrunner
		}else{
			if(rand(time()-$characters{monster}->{delay})>40.0){				
				say("The $characters{monster}->{class} gets bored, and wanders off.");	# after 40 seconds it leaves
				#$conn_self->mode($channel,"-m");
				delete $characters{monster};
				delete $present{monster};
			}
		}
	}
}

# apparently, if you are in the frontline, you get added to the array twice =)  therefore, more of a target
sub get_targets{
	my @ret=();
	for(get_actives()){
		push @ret, $_;
		if($characters{$_}->{frontline}){
			push @ret, $_;
		}
	}
	return @ret;
}

# unless you are resting, then you are active.  Monsters are not active (maybe they should be)
sub get_actives{
	my @ret=();
	for(keys %characters){
		if( $_ ne 'monster' &&
		 $present{lc($_)} &&
		 ! $characters{$_}->{isresting} ){
			push @ret, $_;
		}
	}
	return @ret;
}
sub get_all_actives{
	my @ret=();
	for(keys %characters){
		if( $present{lc($_)} &&
		 ! $characters{$_}->{isresting} ){
			push @ret, $_;
		}
	}
	return @ret;
}

sub get_classes{
	my @ret=();
	for(keys %classes){
			push @ret, $_;
	}
	return @ret;
}
sub get_all_spells{
	my @ret=();
	for(keys %spells){
			push @ret, $_;
	}
	return @ret;
}
# if you are present or concealed, you are in this array.
sub get_party{
	my @ret=();
	for(keys %characters){
		if( $_ ne 'monster' &&
		 ($present{lc($_)} || $concealed{lc($_)}) &&
		 ! $characters{$_}->{isresting} ){
			push @ret, $_;
		}
	}
	return @ret;
}
#see the graveyard(usefull for healers.)          also the access to it is in the msg sub, above the 'save'
sub get_grave{
	my @ret=();
	for(keys %graveyard){
                if( $_ ne 'monster'){ 
		 	push @ret, $_;
		}
	}
	return @ret;
}

#the Dueling thing.
sub duel{ my ($first,$second)=@_;
        print "$dueltime\n";
        print time();
        print "\n";
        print "$dueling\n";
        #if(($dueltime < time()) && ($dueling eq ""))
	{
                print "dueling time and dueling OK\n";
                if(exists($characters{$first}) && exists($characters{$second}))
		{
                        say("\2$first\2 challenges \2$second\2 to a duel!!");
                        $dueltime=time()+60;
                        sayto($second,"In the main window type 'beng accept' to fight, or type 'beng decline' to refuse.");
			$dueling=$first;
                        $dueled=$second;
                        print "Exist OK\n";
                        print "$dueltime";
		}
	}
}
#init_the_duel
sub init_duel{my ($second)=@_;
        if ($dueling eq "" || $dueltime < time() || $second ne $dueled)
                { 
                        $dueling = "";
			return;}

        for(keys %characters){
                if( $_ ne 'monster' && ($present{lc($_)} || $concealed{lc($_)}))
                {
                 $characters{$_}->{isresting}=1;
			$conn_self->mode($channel,"-v",$_);
		}
	}

	$characters{$dueling}->{isresting}=0;
	$conn_self->mode($channel,"+v",$dueling);
	$characters{$second}->{isresting}=0;
        $conn_self->mode($channel,"+v",$second);
        say("In the blue corner we have the defender, \2$second\2.");
	status($second);
         say("And in the red corner we have the challenger, \2$dueling\2.");
        status($dueling);
        $dueling = "1";
}
#duel's record
sub record{
        my ($name)=@_;
        if(!exists($characters{$name})) {
		return;
	  }
        say("\2$name\2's record is \2$characters{$name}->{win}\2 wins");
}



sub intro{
	say("Greetings.  I am Battle Engine 2002. $bengversion");
	say("Command me with '\2BEng command\2'.");
	say("Try '\2BEng help\2'.");
        say("Latest updates: $update");
        say("Latest bug fixes: $bugfixes");
        say("Current hint: $tip");
}

sub facts{
	say("Battle Engine Facts since last restart:");
	say("Total damage dealt: \2$totaldamage\2 ".
		"Total number of enemies killed: \2$grudge\2 ".
		"Total number of enemies not killed: \2$runaway\2 ".
		"Total enemies of type killed: Slime: $slimeslayer Dragon: $dragonslayer Wolves: $wolfslayer People: $manslayer Demons: $demonslayer Cans: $canslayer Goblin-Giant-Etc: $goblinslayer");
}
sub on_connect{
	my ($self,$msg)=@_;
	if (!$debug){
		print "Registering\n";
		sayto("Nickserv","IDENTIFY IMROBOTO");
		my $wait = time()+5;
		while ($wait > time()){}
	}
	print "Joining...\n";
	$self->join($channel);
	intro();
}

# what does it do with messages?

sub on_msg{
	my ($self,$msg)=@_;
	$conn_self=$self;
	my $text=${@{$msg->{'args'}}}[0];
	$msg->{from}=~/([^!]+)![^@]+\@(.+)/;
	my $from=$1;
	my $static=$2;
	logprint "$from:$static :-";					# logging....
	logprint join(":",@{$msg->{'args'}});
	logprint "\n";
	$timeout=time()+120;
	$alive = 1;
	if(time()>($lastsave+150)){
		save();							# save evert 150 seconds..
	}
	if(exists($characters{$from})){
		$present{lc($from)}=1;
		delete $concealed{lc($from)};
	}
	if($text =~ /BattleEngine/i){
		if($naive_audience){
			intro();						# if the audience is new to this, then show the intro.
		}
	}
	if($text =~ /^\s*beng\s+(.+)$/i){
		if(exists($characters{monster}) && (time()>($lastbeng+25)) ){
			my $long_wait=time()-($lastbeng+10);
			my $needsay=0;
			foreach $char (keys %characters){
				if(!$characters{$char}->{isresting}){
					$characters{$char}->{delay}+=$long_wait;
					if($characters{$char}->{delay}>time()){
						$needsay=1;
					}
				}
			}
			if($needsay){
				say("Delays extended due to long pause.");
			}
		}
		$lastbeng=time();
		$_=$1;
		monster_action();							# monsters....
		if(exists($characters{$from}) &&
		 ($characters{$from}->{staticid} ne $static)){
			say("Hey \2$from\2!  Back to your own nick!");
			sayto($from,"If this is actually your account, use '\2\/msg $beng_nick login PASSWORD\2' to log in (and create a password, if you hadn't before).");
			sayto($from,"Remember that in such a situation, at least one other person can read your password.  And, of course, everybody you're chatting with knows your IP address.  Don't use an important password.  Better to use an insecure password like 'password' or your character's name backward, and have someone steal your character, than to use an important password and have someone break into your computer.");
			if(exists $present {lc($from)}){
				delete $present{lc($from)};
			}
			return;
		}
		if(lcname($from) ne $from){
			sayto($from,"Nick recognition is case-sensitive, you must change your nick back to ".lcname($from).".");
			return;
		}
		if(/^join\s+(\S+)/i){
			my $staticmatch=0;
			my $class=$1;
			if(exists $class_aliases{$class}){
				$class=$class_aliases{$class};
			}
			for $name (keys %characters){
				if($characters{$name}->{staticid} eq $static){
					$staticmatch=1;					# already a character with same ip?
				}
			}
			if(exists $characters{$from}){
				sayto($from,"You've already joined.");		# if it already exists, then no multi characters
			#}elsif($staticmatch){
			#	say("Oi! No cloning, \2$from\2!");			# no cloning!
			}else{
				my $slime_delay=$protect_chat?150:30;		# slimes get to reform faster..?
				my $reg_delay=$protect_chat?300:60;
				if((lc($class) eq 'slime') &&
				 is_dead($static) &&
				 (death_time($static)+$slime_delay)>time()){
                                        defeated_penalty($from,$static);
					sayto($from,"It will now be ".
					 ((death_time($static)+$slime_delay)-time()).
					 " seconds until you can join as a slime again.");	# slime messages
				}elsif((lc($class) ne 'slime') && is_dead($static) && (death_time($static)+$reg_delay)>time()){
					defeated_penalty($from,$static);
					sayto($from,"It will now be \2".
					 ((death_time($static)+$reg_delay)-time()).
					 "\2 seconds until you can join again.");			# normal messages
				}else{
					if(lc($class) eq 'twink'){					# one twink a day
						if((time()-$last_twink)>24*60*60){
							$last_twink=time();
							new_character($from,'twink',$static);
						}else{
							$last_twink=time();
							say("No more \2twink\2s today, twink! (or tomorrow, now).");
						}
					}elsif(exists $classes{lc($class)} && $classes{lc($class)}->{user}){
						$present{lc($from)}=1;
						new_character($from,lc($class),$static);
					}else{
						sayto($from,"there is no such class as '\2$class\2'");	# fool, dont you know your classes?
					}
				}
			}
		}elsif(/^intro/i){
			intro();
		}elsif(/^fact/i){
			facts();
		}elsif(/^levelup\s+(\S+)/i){
                        if($debug eq 1){
                                        my $level = $1;                                       
                                        while ($level)  {
                                                level_up($from);
                                                $level=$level-1;
                                        }  
                        }
		}elsif(/^who/i){
			say("Current players: \2".join(' ',(keys %characters))."\2");
		}elsif(/^pres/i){
			say("Current present players: \2".join('',
			 map{!$present{lc($_)}?'':"$_ "}(keys %characters))."\2");
		}elsif(/^active/i){
			say("Current awake players: \2".join(' ', get_actives())."\2");
		}elsif(/^graveyard/i){
			say("In the graveyard you see: \2".join(' ', get_grave())."\2");
		}elsif(/^save/i){
			save();
        }elsif(/^challenge\s+(\S+)/i){               #challenge for a duel: Help Jikuu, if you see anything that's wrong.
                  duel($from,lcname($1));
                  print "challenging...";                   #test print.
        }elsif(/^accept/i){                            	#accepts a challenge for a duel: " "
			init_duel($from);
                  print "accept";                        	#test print 	
		}elsif(/^decline/i){
                        if ($from eq $dueled){
                                say("There will be no fight.");
                                $dueltime=time();
                                $dueling="";
                        }
		}elsif(/^record/i){
			record($from);


		}elsif(/^help(?:\s+(.+))?$/i){
			$_=$1;								# help stuff...
			if(/^(\S+)/ && exists($spells{lc($1)})){
				sayto($from,$spells{lc($1)}->{description} . " element:$spells{lc($1)}->{element}");	# spell help... does the spell exist?  If so, read the desc.
			}elsif(/^(\S+)/ && exists($equips{lc($1)})){
				sayto($from,$equips{lc($1)}->{description} . " ($equips{lc($1)}->{type}) Rating: $equips{lc($1)}->{rating} Cost: $equips{lc($1)}->{cost} Element:$equips{lc($1)}->{element}");	# weapon help
			}elsif(/^(\S+)/ && exists($items{lc($1)})){
				sayto($from,$items{lc($1)}->{description} . " Cost: $items{lc($1)}->{cost}");	# item help
			}elsif(/^(\S+)/ && exists($class_desc{lc($1)})){
				sayto($from,$class_desc{lc($1)});	# class help

			}elsif(/^class/i){
				sayto($from,"These are the classes: \2time_mage\2, \2oracle\2, \2angel\2, \2demon\2, \2holy_knight\2, \2sniper\2, \2slayer_knight\2, \2hunter\2, \2mimic\2, \2summoner\2, \2fighter\2, \2mage\2, \2healer\2, \2ninja\2, \2bard\2, \2robot\2, \2thief\2, \2harlot\2, \2monk\2, \2slime\2, \2psionist\2, and \2dancer\2.");
			}elsif(/^wander/i){
				sayto($from,"Use '\2wander AREA\2' to find a monster to fight!");
			}elsif(/^area/i){
				sayto($from,"Wander any of these areas: \2".join(' ',keys(%areas)).
				 "\2");
			}elsif(/^front/i){
				sayto($from,"Move to the front of the line, protect your allies.");
			}elsif(/^back/i){
				sayto($from,"Move behind your allies, let them take the heat.");
			}elsif(/^dropped/i){
				sayto($from,"See what's on the ground");
			}elsif(/^pickup/i){
				sayto($from,"Pickup a weapon on the ground");
			}elsif(/^study/i){
				sayto($from,"Study a creature to learn to summon it.");
			}elsif(/^summon/i){
				sayto($from,"Summon a creature you've successfully \2study\2'd.",
				 "Use '\2beng summons\2' to learn which you can summon.");
							}elsif(/^hunt/i){
				sayto($from,"Hunt a particular a creature to learn to summon it.");
			}elsif(/^mimic/i){
				sayto($from,"Mimic a creature to perform one of it's actions.");
			}elsif(/^challenge/i){
				sayto($from,"Challenge a player to fight to the death with you.");
			}elsif(/^accept/i){
				sayto($from,"Agree to a fight to the death.");
			}elsif(/^decline/i){
				sayto($from,"Refuse to a fight to the death.");
			}elsif(/^buy/i){
				sayto($from,"Buy a specified weapon or item, if you can");
			}elsif(/^weapstore/i){
				sayto($from,"See what weapons you can buy and their costs");
			}elsif(/^itemstore/i){
				sayto($from,"See what items you can buy and their costs");
			}elsif(/^equip/i){
				sayto($from,"Equip a weapon you have in your inventory");
			}elsif(/^drop/i){
				sayto($from,"Drop something you have in your inventory");
			}elsif(/^sell/i){
				sayto($from,"Sell something you have in your inventory");

			}elsif(/^donate/i){
				sayto($from,"Donate money to an individual");

			}elsif(/^spell/i){
				sayto($from,"There are four known spells: \2flare\2, \2fireball\2, \2cure\2, and \2heal\2.",
				 "\2Flare\2 and \2fireball\2 are mage spells.",
				 "\2Cure\2 and \2heal\2 are healer spells.",
				 "It is rumoured that there are some spells known only to the highest level characters...",
				 "(and those with the source code) ;P",
				 "Use '\2beng spells\2' to learn which you can cast.");
                  }elsif(/^version/i){
				sayto($from,"Battle Engine2002, $bengversion.",
                                 'Battle Engine2002 code by:',
								 "\2webrunner\2 - webrunner\@adventurers-comic.com",
                                 "\2jikuu\2 - jikuu\@home.com",
                                 "\2kenard\2 - Kehmry\@starband.net",
				 "Original code by \2nindalf\2."); 
			}else{
				sayto($from,"Get a character class by saying '\2join [CLASS]\2'.",
                                 "I also understand '\2stat\2', '\2spells\2','\2hit [TARGET]\2','\2cast [SPELL] on [TARGET]\2', '\2rest\2', '\2wake\2', '\2wander [AREA]\2', '\2front\2', '\2back\2', '\2challenge [TARGET]\2', '\2accept\2', '\2decline\2', and '\2version\2'.",
				 "Also '\2study [SUBJECT]\2' '\2summon [SUBJECT] at [TARGET]\2' '\2summons\2' for summoners only.",
				 "All commands must be started with '\2BEng\2' (BattleEngine)",
				 "(Try '\2beng intro\2' '\2beng help spells\2' and '\2beng help classes\2')");
			}
		}elsif(exists($characters{$from})){
			if(/^hit\s+(\S+)/i){
                
                if (!cause_status($from)) {  ## Cause status effects to character. - webrunner
					if(exists($characters{lcname($1)})){
						if(!exists($present{lc($1)})){
							say("\2$1\2 isn't here.");
						}else{
							attack($from,lcname($1));
						}
					}else{
						say("There is no \2$1\2.");
					}
				}
			}elsif(/^cast\s+(\S+)\s+(?:on\s+)?(\S+)/i){
				my $spell=$1;
				my $target=$2;
                 if (!cause_status($from)) {  ## Cause status effects to character. - webrunner
			
				if(lc($spell) =~ /raise|life/){
					cast($from,lc($spell),lcname($target));	# if its raise or life, then cast on the target, regardless if they are here or not
				}elsif(lc($spell) =~ /heal_all/){			# Heal all fixed.
					cast($from,lc($spell),$from);
				}elsif(!exists($characters{lcname($target)})){
					say("There is no \2$target\2.");		# no target?
				}elsif(!exists($spells{lc($spell)})){
					say("There's no such spell as \2$spell\2.");	# no such spell?
				}else{
					if(!$present{lc($target)} || $characters{lcname($target)}->{isresting}){				# not present?
						say("\2$target\2 isn't here.");
					}else{
						cast($from,lc($spell),lcname($target));
					}
				} }
			}elsif(/^summon\s+(\S+)\s+(?:at\s+)?(\S+)/i){
				my $creature=$1;
				my $target=$2;
                if (!cause_status($from)) {
               ## Cause status effects to character. - webrunner
				if(exists($summons{lc($creature)}) && ($summons{lc($creature)} =~ /raise|life/)){
					summon($from,lc($creature),lcname($target));	# do a raise/life thing first
				}elsif(!exists($characters{lcname($target)})){
					say("There is no \2$target\2.");
				}else{
					if(!$present{lc($target)} || $characters{lcname($target)}->{isresting}){
						say("\2$target\2 isn't here.");
					}else{
						summon($from,lc($creature),lcname($target));
					}
				} }
			}elsif(/^mimic\s+(\S+)\s+(?:at\s+)?(\S+)/i){
				 if (!cause_status($from)) {
					if(exists($characters{lcname($1)})){
						if(exists($characters{lcname($2)})){
							if(!$present{lc($1)}){
								say("\2$1\2 isn't here.");
							}else{
								if(!$present{lc($2)} || $characters{lcname($2)}->{isresting}){
									say("\2$2\2 isn't here.");
								}else{
									mimic($from,lcname($1),lcname($2));
								}
							}
						}else{
							say("There is no \2$2\2.");
						}
					}else{
						say("There is no \2$1\2.");
					}
				}
			}elsif(/^throw\s+(\S+)\s+(?:at\s+)?(\S+)/i){
				 if (!cause_status($from)) {
					if(exists($equips{lcname($1)})){
						if(exists($characters{lcname($2)})){

								if(!$present{lc($2)} || $characters{lcname($2)}->{isresting}){
									say("\2$2\2 isn't here.");
								}else{
									throw($from,lcname($1),lcname($2));
								}
						
						}else{
							say("There is no \2$2\2.");
						}
					}else{
						say("There is no such weapon as \2$1\2.");
					}
				}
				}elsif(/^spells/i){
				tell_spells($from);
			}elsif(/^dropped/i){
				list_drops();
			}elsif(/^weapstore/i){
				tell_buy($from);
			}elsif(/^itemstore/i){
				tell_buy_item($from);
			}elsif(/^hunt\s+(\S+)\s+(?:in\s+)?(\S+)/i){
				hunt($from,lc($1),lc($2));
			}elsif(/^donate\s+(\S+)\s+(?:to\s+)?(\S+)/i){
				donate($from,lcname($2),lcname($1));
			}elsif(/^give\s+(\S+)\s+(?:to\s+)?(\S+)/i){
				give_item($from,lcname($2),lcname($1));
			}elsif(/^use\s+(\S+)\s+(?:on\s+)?(\S+)/i){
				use_item($from,lcname($2),lcname($1));
			}elsif(/^summons/i){
				tell_summons($from);
			}elsif(/^inv/i){
				tell_inv($from);
			}elsif(/^study\s+(\S+)/i){
			#	my $test = lc($1);
			#	say ("DEBUG: $test ");
				if(exists($characters{lcname($1)})){
					if(!$present{lc($1)}){
						say("\2$1\2 isn't here.");
					}else{
						summoner_study($from,lcname($1));
					}
				}else{
					say("There is no \2$1\2.");
				}

			}elsif(/^front/i){
				if(!$characters{$from}->{frontline}){
					say("\2$from\2 bravely moves to the front line.");
					$characters{$from}->{frontline}=1;
				}else{
					sayto($from, "You're already in the front line.");
				}
			}elsif(/^back/i){
				if($characters{$from}->{frontline}){
					say("\2$from\2 wisely moves to the back line.");
					$characters{$from}->{frontline}=0;
				}else{
					sayto($from, "You're already in the back line.");
				}
			}elsif(/^(flee|run)/i){
				flee($from);
			}elsif(/^rest/i){
				rest($from);
			}elsif(/^wake/i){
				wake($from);
			}elsif(/^wander(?:\s+(\w+))?/i){
				if($1 && ! exists($areas{lc($1)})){
					say("\2$1\2 is not a valid area (use 'help areas').");
				}else{
					wander($from,lc($1));
	
					}
			}elsif(/^buyten(?:\s+(\w+))?/i){
				buy_ten($from,$1);
			}elsif(/^buy(?:\s+(\w+))?/i){
				buy($from,$1);
			}elsif(/^drop(?:\s+(\w+))?/i){
				drop_inventory($from,$1);
			}elsif(/^equip(?:\s+(\w+))?/i){
				equip_weapon($from,$1);
			}elsif(/^sellten(?:\s+(\w+))?/i){
				sell_ten($from,$1);
			}elsif(/^sell(?:\s+(\w+))?/i){
				sell($from,$1);
			}elsif(/^pickup(?:\s+(\w+))?/i){
				pickup($from,$1);
			}elsif(/^stat/i){
				status($from);
            }elsif(/^version/i){
				sayto($from,"Battle Engine, $bengversion.",
                                 'Battle Engine code by:',
                                 "\2jikuu\2 - jikuu\@home.com",
                                 "\2kenard\2 - Kehmry\@starband.net",
				 "\2webrunner\2 - webrunner\@adventurers-comic.com",
				 "Original code by \2nindalf\2."); 
			}else{
				sayto($from,"I'm sorry, I don't understand.");
			}
		}else{
			sayto($from,"You have to join first.");
		}
	}
$admin_password='adminpass';
}

# private messages are only counted if they have a password message in them
sub on_private{
	my ($self,$msg)=@_;
	my $text=${@{$msg->{'args'}}}[0];
	$msg->{from}=~/([^!]+)![^@]+\@(.+)/;
	my $from=$1;
	my $static=$2;
	logprint "on_private\n";
	logprint "$from  $static \n";
	logprint "$text\n";
        if($text =~ /^quit\s+(\w+)/){
                if($1 eq $admin_password){
                        sayto($from, 'Shutting down...');
                        save();
                        exit(0);
                }else{
                        sayto($from, 'Wrong password.');
		}
        }elsif($text =~ /^restart\s+(\w+)/){
                if($1 eq $admin_password){
                        sayto($from, 'Restarting...');
                        save();
                        exec("sh beng.sh");
                }else{
                        sayto($from, 'Wrong password.');
		}
	}elsif($text =~ /^slayer\s+(\w+)/){
                if($1 eq $admin_password){
			sayto($from, "Enemy counter: $grudge");
			sayto($from, "Ogre counter: $ogres");
                        sayto($from, "Slime counter: $slimes");
                        sayto($from, "Slimeslayer: $slimeslayer");
                        sayto($from, "Wolfslayer: $wolfslayer");
                        sayto($from, "ManSlayer: $manslayer");
                        sayto($from, "Demonslayer: $demonslayer");
                        sayto($from, "Dragonslayer: $dragonslayer");
                        sayto($from, "Canslayer: $canslayer");
			sayto($from, "Goblinslayer: $goblinslayer");
                }else{
                        sayto($from, 'Wrong password.');
		}
	}elsif($text =~ /^webinv\s+(\w+)/){
		$inv{'webrunner'}->{$1} = $inv{'webrunner'}->{$1} + 1;
		sayto($from,"Gave webrunner a $1");
	}elsif($text =~ /^load_data\s+(\w+)/){
		if($1 eq $admin_password){
			sayto($from,"Loading Weapons..");
			load_weapons();
			sayto($from,"Done!");
			sayto($from,"Loading spells..");
			load_spells();
			sayto($from,"Done!");
			sayto($from,"Loading classes..");
			load_classes();
			sayto($from,"Done!");	
			sayto($from,"Loading info..");
			load_info();
			sayto($from,"Done!");
			sayto($from,"Loading items..");
			load_items();
			sayto($from,"Done!");
		}else{
			sayto($from, 'Wrong password.');
		}
	}elsif($text =~ /^reload_save\s+(\w+)/){
		if($1 eq $admin_password){
			sayto($from,"Loading Characters..");
			load();
			sayto($from,"Done!");
		}else{
			sayto($from, 'Wrong password.');
		}
	}elsif($text =~ /^sync\s+(\w+)\s+(\w+)/){
		if($1 eq 'nindalf' && $2 eq $admin_password){
			sayto($from, "Synching Nindalf");
			system("./cvssync nindalf");
		}
		if($1 eq 'webrunner' && $2 eq $admin_password){
			sayto($from, "Synching Webrunner");
			system("./cvssync webrunner");
		}
	}elsif($text =~ /^patch\s+(\w+)/){
		if($1 eq $admin_password){
			sayto($from,"Loading patch..");
			load_patch();
			sayto($from,"Done!");
		}else{
			sayto($from, 'Wrong password.');
		}
	}elsif($text =~ /^webinv\s+(\w+)/){
		$inv{'webrunner'}->{$1} = $inv{'webrunner'}->{$1} + 1;
		sayto($from,"Gave webrunner a $1");
	}elsif($text =~ /^load_data\s+(\w+)/){
		if($1 eq $admin_password){
			sayto($from,"Loading Weapons..");
			load_weapons();
			sayto($from,"Done!");
			sayto($from,"Loading spells..");
			load_spells();
			sayto($from,"Done!");					
			sayto($from,"Loading classes..");
			load_classes();
			sayto($from,"Done!");	
			sayto($from,"Loading info..");
			load_info();
			sayto($from,"Done!");
			sayto($from,"Loading items..");
			load_items();
			sayto($from,"Done!");
		}else{
			sayto($from, 'Wrong password.');
		}
	}elsif($text =~ /^reload_save\s+(\w+)/){
		if($1 eq $admin_password){
			sayto($from,"Loading Characters..");
			load();
			sayto($from,"Done!");
		}else{
			sayto($from, 'Wrong password.');
		}
	}elsif($text =~ /^sync\s+(\w+)\s+(\w+)/){
		if($1 eq 'nindalf' && $2 eq $admin_password){
			system("./cvssync nindalf");
			sayto($from,"Sunc!");
		}
		if($1 eq 'webrunner' && $2 eq $admin_password){
			system("./cvssync webrunner");
			sayto($from,"Sunc!");
		}
	}elsif($text =~ /^patch\s+(\w+)/){
		if($1 eq $admin_password){
			sayto($from,"Loading patch..");
			load_patch();
			sayto($from,"Done!");
		}else{
			sayto($from, 'Wrong password.');
		}
	}elsif($text=~/^log\S*\s+(\w+)/i){
		if(! exists $characters{$from}){
			sayto($from, "Join first.");
			return;
		}
		if(exists $characters{$from}->{password}){
			if($characters{$from}->{password} eq $1){
				$characters{$from}->{staticid}=$static;
				sayto($from,"You are now logged in.");
			}else{
				sayto($from,"Incorrect password.");
			}
		}else{
			$characters{$from}->{password}=$1;
			$characters{$from}->{staticid}=$static;
			sayto($from,"Your password is now registered.");
		}
	}elsif($text=~/^blargcheater\S*\s+(\w+)/i){
		if(exists $characters{lcname($1)}){
			$characters{lcname($1)}->{weapon} = 'cheater_toothbrush';
		}
	}elsif($text=~/^botop\S*\s+(\w+)/i){
		if (/^load/i){
			load();
		}
	}
}

# purging stuff on quit
sub on_quit{
	my ($self,$msg)=@_;
	$msg->{from}=~/([^!]+)!(.+)/;
	my $from=$1;
	my $static=$2;
	delete $present{lc($from)};
	delete $concealed{lc($from)};
}

# purging stuff on join
sub on_join{
	my ($self,$msg)=@_;
	$msg->{from}=~/([^!]+)!(.+)/;
	my $from=$1;
	my $static=$2;
	$present{lc($from)}=1;
	delete $concealed{lc($from)};
}



#are we connected?
sub on_ping{
	my ($self,$event)=@_;
	my $nick = $event->nick;
	my $args = $event->args;
	my $first = ($event->args)[0];
	my $second = ($event->args)[1];
	$self->ctcp_reply($nick, join (' ', ($event->args)));
	print "PING - $nick\n";
}

# Gives lag results for outgoing PINGs.
sub on_ping_reply {
    my ($self, $event) = @_;
	my $first = $event->args;
	my $second = ($event->args)[0];
    my ($args) = ($event->args)[1];
    my ($nick) = $event->nick;
    $args = time() - $args;
    print "PONG - $args\n";
    $alive=2;
}

sub setconn{
	print "setting connections...";
	$conn= $irc->newconn(	
		Nick  => $beng_nick,
		Server  => $server,
		Port    =>  $port,
		Ircname => 'Mmmm... Beer and pretzels.'
	);
	$conn->add_handler('376', \&on_connect);
	$conn->add_handler('public', \&on_msg);
	$conn->add_handler('msg', \&on_private);
	$conn->add_handler('quit', \&on_quit);
	$conn->add_handler('part', \&on_quit);
	$conn->add_handler('join', \&on_join);
	$conn->add_handler('cping',\&on_ping);
	$conn->add_handler('crping',\&on_ping_reply);
	print "done\n";
}

setconn();

#$irc->start;
print "starting main loop\n";
while(1){
	$irc->do_one_loop();
	if ($timeout < time()){
		if (!$alive){
			save();
			print "Disconnected\n";
			$irc->removeconn($conn);
			setconn();
			$alive=1;
			$timeout= time() + 120;
		} else {
			print "Pinging $beng_nick\n";
			$conn->ctcp("PING","$beng_nick");
			$timeout=($alive eq 1)?time()+30:time()+600;
		}	
	}
}

sub load_patch{
	open LOADFILE, "<beng_patch.pl" or return;
	print "Loading server...";
	eval(join('',<LOADFILE>));
	close LOADFILE;

	print "done\n";
}
