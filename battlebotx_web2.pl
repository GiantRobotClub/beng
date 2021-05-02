#-------------------------------#                                               
# comments by jikuu@home.com
#-------------------------------#


use Net::IRC;                   # perl mod

my $protect_chat=0;
my $naive_audience=0;		# naive adds some extra help stuff that you really dont need
my %characters=();
my %present=();
my %concealed=();
my %graveyard=();
my %defeated=();
my $lastsave=time();
my %lcnames=();			
my $keep_log=1;
my $verbose=1;
my $bengversion='v1.46';
my $dueltime=time();		#duel
my $dueling="";                  #duel
my $dueled="";
my $debug=0;
my $timeout=time()+120;
my $alive = 1;
my $conn_self;

srand();				# ready the randomizer

my $beng_nick='BattleEngine_Beta';       # the name, channel, server?]
my $channel='#rpgtester';
my $server='deepthought.nj.us.nightstar.net';

my @errors=();

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

sub sayto{ my $to=shift;			# how to log /msgs...
	foreach(@_){
		$conn->privmsg($to,$_);
		logprint("private($to) $_\n");
	}
}

sub say{ 					# another logging thing
	foreach(@_){
		$conn->privmsg($channel,$_);
		logprint("out: $_\n");
	}
}
#-------------------------------------#
# I wonder what these are.... :P
# cost is MP
# damage is damage from 1 to whatever
# description is the help thing
#-------------------------------------#

my %spells=(
#special
mpshield=>{cost=>'30',damage=>'0',description=>'Channeling damage for Dummies'},

gravity_bomb=>{cost=>'75',damage=>'0',description=>'Sometimes half is better than whole.'},
omniscience=>{cost=>'50',damage=>'0',description=>'Peer inside people souls and find nothing but porn, porn, PORN!!!'},
serenade=>{cost=>'25',damage=>'0',description=>'Music soothes the savage beast.'},
sniff=>{cost=>'5',damage=>'0',description=>'FEE FIE FOE FUM.'},
waltz=>{cost=>'5',damage=>'0',description=>'Waltz right out of a bad situation.'},
tangle_tango=>{cost=>'20',damage=>'0',description=>'Trip up your partner.'},
disco_fever=>{cost=>'1',damage=>'0',description=>'Face it.  Disco is dead.'},
preach=>{cost=>'1',damage=>'0',description=>'Preach a sermon.'},
scan=>{cost=>'5',damage=>'0',description=>'Learn about an enemy\'s state.'},
vanish=>{cost=>'5',damage=>'0',description=>'See, yet be unseen.'},
hide=>{cost=>'5',damage=>'0',description=>'Now, where\'s a good shadow?'},
smoke_bomb=>{cost=>'10',damage=>'0',description=>'Escape from battle under an impenetrable cover.'},
sneak=>{cost=>'10',damage=>'0',description=>'Don\'t mind me, I\'m just not fighting any more.'},
ghoulish=>{cost=>'50',damage=>'0',description=>'Something unspeakable.'},
taser=>{cost=>'30',damage=>'0',description=>'Paralyze your enemies.'},
web=>{cost=>'20',damage=>'0',description=>'Ensnare your enemies in a sticky net.'},
censored=>{cost=>'1000',damage=>'0',description=>'[this description censored]'},
raise=>{cost=>'50',damage=>'0',description=>'Raise the recently deceased.'},
life=>{cost=>'200',damage=>'0',description=>'Raise any deceased.'},
rbite=>{cost=>'1',damage=>'0',description=>'This venom has been infused with H-band radiation!'},
howl=>{cost=>'2',damage=>'0',description=>'Awooooooooooo!'},
roar=>{cost=>'2',damage=>'0',description=>'Rarrrr!'},
fly=>{cost=>'12',damage=>'0',description=>'Fly good Fleance, fly!'},
lullaby=>{cost=>'8',damage=>'0',description=>'Yawwwn... What a boring song.'},
dance_of_special_words=>{cost=>'310',damage=>'0',description=>'Invoke magic words in another'},
heal_all=>{cost=>'400',damage=>'0',description=>'Heals all party members'},
assimilate=>{cost=>'130',damage=>'0',description=>'Your biological and technological distinctiveness will be added to our own.'},

#normal
lame=>{cost=>'1',damage=>'1',description=>'A lame attack.'},
duh=>{cost=>'1',damage=>'1',description=>'A stupid attack.'},
happy_dance=>{cost=>'1',damage=>'-10',description=>'What?  You need a reason?'},
song=>{cost=>'1',damage=>'12',description=>'Play some music.'},
tansu_dance=>{cost=>'5',damage=>'20',description=>'A vigorous dance involving throwing an excessively heavy chest of drawers.'},
skank_kiss=>{cost=>'10',damage=>'20',description=>'I\'d rather not...'},
flare=>{cost=>'5',damage=>'20',description=>'A flash of flame.'},
spark=>{cost=>'7',damage=>'20',description=>'An electric shock.'},
shuriken=>{cost=>'4',damage=>'24',description=>'Little pointy things, lots of them.'},
throw=>{cost=>'4',damage=>'24',description=>'It\'s all fun and games until someone loses an eye.'},
harmony=>{cost=>'5',damage=>'-25',description=>'Soothing to the ears.'},
cure=>{cost=>'5',damage=>'-30',description=>'Cure minor wounds.'},
ice=>{cost=>'10',damage=>'30',description=>'Freeze your enemies.'},
wound=>{cost=>'20',damage=>'40',description=>'A false healing.'},
gas=>{cost=>'12',damage=>'40',description=>'An unbreathable cloud.'},
spoony=>{cost=>'10',damage=>'50',description=>'You spoony bard!'},
fireball=>{cost=>'15',damage=>'50',description=>'A fireball spell.'},
candy_beam=>{cost=>'10',damage=>'50',description=>'A beam made entirely of candy!'},
acid_shower=>{cost=>'15',damage=>'50',description=>'Ouch.'},
pound=>{cost=>'30',damage=>'80',description=>'Thump, thump!'},
really_bad_breath=>{cost=>'10',damage=>'80',description=>'An unhygienic dragon\'s breath weapon.'},
heal=>{cost=>'10',damage=>'-100',description=>'A spell of healing.'},
kiss=>{cost=>'10',damage=>'-100',description=>'Kiss it better.'},
sword_dance=>{cost=>'40',damage=>'100',description=>'One of the more violent dances.'},
lightning=>{cost=>'50',damage=>'100',description=>'A lightning bolt.'},
poison_breath=>{cost=>'30',damage=>'100',description=>'A poison dragon\'s breath weapon.'},
acid_spray=>{cost=>'20',damage=>'100',description=>'Double ouch.'},
sue=>{cost=>'15',damage=>'100',description=>'He\'s after blood.'},
top_cut=>{cost=>'24',damage=>'120',description=>'Instant critical.'},
backstab=>{cost=>'24',damage=>'120',description=>'Extra painful.'},
shadow_strike=>{cost=>'36',damage=>'120',description=>'Strike from concealment.'},
mug=>{cost=>'36',damage=>'120',description=>'A purely visual joke.'},
kick=>{cost=>'60',damage=>'160',description=>'ACHOOOOO!'},
fighter_doken=>{cost=>'75',damage=>"200",description=>'Two-fisted monkey style.'},
whup_ass=>{cost=>'70',damage=>'200',description=>'A mighty whupping indeed!'},
finite=>{cost=>'20',damage=>'200',description=>'Melody of finite.'},
hag_kiss=>{cost=>'10',damage=>'200',description=>'Ewwww.'},
stomp=>{cost=>'100',damage=>'200',description=>'Squish!'},
fire_breath=>{cost=>'50',damage=>'200',description=>'A fire dragon\'s breath weapon.'},
damn=>{cost=>'100',damage=>'300',description=>'Ooh, that is a bit harsh.'},
regenerate=>{cost=>'50',damage=>'-400',description=>'Supernatural healing.'},
danse_macabre=>{cost=>'100',damage=>'400',description=>'The part that really hurts is that wierd violin solo.'},
shadow_breath=>{cost=>'50',damage=>'400',description=>'A death dragon\'s breath weapon.'},
ethereal_blade=>{cost=>'175',damage=>'500',description=>'Oooh... haunted cutlery.'},
unholy=>{cost=>'150',damage=>'500',description=>'An unholy life drain.'},
devilish=>{cost=>'160',damage=>'600',description=>'An Attack upon the soul.'},
instill=>{cost=>'75',damage=>'-750',description=>'Healing the hard way.'},
rock_and_roll=>{cost=>'80',damage=>'750',description=>'the devil music.'},
sneak_attack=>{cost=>'180',damage=>'800',description=>'come out of nowhere.'},
plunder=>{cost=>'250',damage=>'2000',description=>'they have much less then they had.'},
chirijiraden=>{cost=>350,damage=>'3000',description=>'ancient ninja attak.'},
meteo=>{cost=>'400',damage=>'3000',description=>'Open the Heavens!  Break the Earth!'},
fissure=>{cost=>'400',damage=>'3500',description=>'Split the earth beneath your opponents feet.'},
revive=>{cost=>'100',damage=>'-4000',description=>'A spell of supreme healing.'},
negate=>{cost=>'500',damage=>'4000',description=>'The ultimate betrayal of the healer\'s art.'},
smite=>{cost=>'300',damage=>'5000',description=>'Now you`re fucked.'},
judgement_day=>{cost=>'1000',damage=>'10000',description=>'It\'s your own damn fault.'},
holy_wrath=>{cost=>'1000',damage=>'10000',description=>'God is pissed.'},
magic_missile=>{cost=>'600',damage=>'5000',description=>'a beam of light that always finds it\'s mark.'},
flood_the_earth=>{cost=>'1000',damage=>'10000',description=>'No rainbow today.'},
hurl_thunderbolt=>{cost=>'1000',damage=>'10000',description=>'Zeus does this.  It hurts.'},
breath_weapon_barrage=>{cost=>'5000',damage=>'50000',description=>'So \2that\2 is what happens when a whole swarm of dragons breath at the same time.'},
dragon_slave=>{cost=>'1000',damage=>'1000000',description=>'Now that\'s just excessive.'},
);

my $last_twink=time();	# no clue

my @canned_monsters=(ettin,red_dragon,stupid_looking_dragon,slime_king,shadow_dragon,ghoul);  # can stuff
my @canned_gods=(jesus,buddha,cosmic_dragon,jehovah,zeus,diablo);

#-----------------------------------------------------------------#
# here are the classes
# user - can a player be this, true or false.
# hp - hit points
# xp - experience points
# damage - hitting damage
# spells - what spells can it use
# spells work as follows
# spells=>{spell_name=>what level you get the spell,spell_name=>spell rarity}},
#-----------------------------------------------------------------#
my %classes=(

#sheildtest
sheildtester=>{user=>1,hp=>700,mp=>700,xp=>10,damage=>10,spells=>{mpshield=>1},win=>0},

#hell:
lost_soul=>{user=>0,hp=>700,mp=>500,xp=>700,damage=>42,hitsas=>20,spells=>{wound=>1,ghoulish=>1,heal=>1}},
lawyer=>{user=>0,hp=>500,mp=>100,xp=>500,damage=>30,hitsas=>15,spells=>{sue=>1}},
diablo=>{user=>0,hp=>10000,mp=>2000,xp=>10000,damage=>60,hitsas=>50,spells=>{ghoulish=>1,regenerate=>1,unholy=>1,meteo=>1,vanish=>1,judgement_day=>1}},
fairy=>{user=>0,hp=>10,mp=>0,xp=>10,damage=>-10,hitsas=>2,spells=>{}},
damned_fairy=>{user=>0,hp=>1500,mp=>200,xp=>1500,damage=>20,hitsas=>10,spells=>{wound=>1,revive=>1,fireball=>1}},

#players
angel=>{user=>1,hp=>35,mp=>18,xp=>150,damage=>9,spells=>{preach=>1,fly=>3,cure=>2,wound=>5,raise=>8,damn=>15,heal=>20,omniscience=>25,revive=>35,life=>37,smite=>40}}, 
demon=>{user=>1,hp=>40,mp=>20,xp=>160,damage=>10,spells=>{wound=>4,raise=>9,devilish=>14,instill=>15,fissure=>25,omniscience=>30}},  
fighter=>{user=>1,hp=>50,mp=>0,xp=>100,damage=>10,spells=>{},win=>0},
monk=>{user=>1,hp=>30,mp=>0,xp=>100,damage=>14,spells=>{},win=>0},
ninja=>{user=>1,hp=>30,mp=>12,xp=>120,damage=>12,spells=>{vanish=>2,shuriken=>3,smoke_bomb=>5,top_cut=>7,shadow_strike=>10,ethereal_blade=>23,chirijiraden=>50},win=>0},
thief=>{user=>1,hp=>30,mp=>12,xp=>120,damage=>6,spells=>{hide=>1,sneak=>3,throw=>2,backstab=>6,mug=>9,sneak_attack=>22,plunder=>50},win=>0},
theif=>{user=>1,hp=>30,mp=>12,xp=>120,damage=>6,spells=>{lame=>1,duh=>1},win=>0},
robot=>{user=>1,hp=>40,mp=>5,xp=>100,damage=>8,spells=>{spark=>2,scan=>5,candy_beam=>10,taser=>15,lightning=>20,gravity_bomb=>26,assimilate=>50},win=>0},
bard=>{user=>1,hp=>25,mp=>10,xp=>100,damage=>5,spells=>{hide=>1,song=>2,harmony=>4,lullaby=>8,spoony=>10,serenade=>12,finite=>20,rock_and_roll=>50},win=>0},
mage=>{user=>1,hp=>30,mp=>20,xp=>150,damage=>5,spells=>{flare=>1,spark=>2,ice=>3,fireball=>5,cure=>7,lightning=>10,unholy=>13,heal=>17,meteo=>20,magic_missile=>50},win=>0},
summoner=>{user=>1,hp=>20,mp=>40,xp=>160,damage=>4,spells=>{},win=>0},
healer=>{user=>1,hp=>40,mp=>20,xp=>120,damage=>8,spells=>{cure=>1,heal=>3,raise=>7,wound=>10,revive=>15,life=>20,heal_all=>25,negate=>50},win=>0},
harlot=>{user=>1,hp=>20,mp=>30,xp=>80,damage=>2,spells=>{kiss=>1},win=>0},
skank=>{user=>0,hp=>20,mp=>30,xp=>80,damage=>2,spells=>{skank_kiss=>1},win=>0},
hag=>{user=>0,hp=>20,mp=>30,xp=>80,damage=>2,spells=>{hag_kiss=>1}},
wretch=>{user=>0,hp=>5,mp=>0,xp=>80,damage=>2,spells=>{}},
dancer=>{user=>1,hp=>30,mp=>20,xp=>150,damage=>5,spells=>{happy_dance=>2,waltz=>3,tansu_dance=>1,disco_fever=>5,sword_dance=>7,tangle_tango=>10,danse_macabre=>30,dance_of_special_words=>50},win=>0},

unicorn_jelly=>{user=>0,hp=>10,mp=>5,xp=>50,damage=>20,spells=>{spark=>5,cure=>8}},
town_fool=>{user=>0,hp=>30,mp=>14,xp=>30,damage=>4,spells=>{duh=>1}},
constable=>{user=>0,hp=>100,mp=>20,xp=>190,damage=>8,spells=>{heal=>1}},
exp_in_a_can=>{user=>0,hp=>1,mp=>0,xp=>100,damage=>0,spells=>{}},
unlabelled_can_of_mystery=>{user=>0,hp=>1,mp=>0,xp=>100,damage=>0,spells=>{}},            
monster_in_a_can=>{user=>0,hp=>1,mp=>0,xp=>100,damage=>0,spells=>{}},
god_in_a_can=>{user=>0,hp=>1,mp=>0,xp=>100,damage=>0,spells=>{}},
can_of_wyrms=>{user=>0,hp=>1,mp=>0,xp=>100,damage=>0,spells=>{}},
can_of_whup_ass=>{user=>0,hp=>1000,mp=>0,xp=>3000,hitsas=>16,damage=>100,spells=>{},win=>0},
spider_man=>{user=>0,hp=>40,mp=>100,xp=>60,damage=>16,spells=>{web=>3},win=>0},
evil_chair=>{user=>0,hp=>40,mp=>0,xp=>100,damage=>9,spells=>{},win=>0},
evil_pants=>{user=>0,hp=>60,mp=>0,xp=>150,hitsas=>2,damage=>9,spells=>{},win=>0},
slime=>{user=>1,hp=>10,mp=>2,xp=>30,damage=>3,spells=>{spark=>7,cure=>10},win=>0},
imp=>{user=>0,hp=>30,mp=>0,xp=>60,damage=>6,spells=>{}},
gazelle=>{user=>0,hp=>50,mp=>0,xp=>80,hitsas=>1,damage=>8,spells=>{}},
lion=>{user=>0,hp=>150,mp=>10,xp=>475,hitsas=>5,damage=>20,spells=>{roar=>1}},
elephant=>{user=>0,hp=>400,mp=>0,xp=>1150,hitsas=>9,damage=>40,spells=>{}},
ogre=>{user=>0,hp=>200,mp=>0,xp=>600,hitsas=>6,damage=>20,spells=>{}},
ghoul=>{user=>0,hp=>200,mp=>200,xp=>700,hitsas=>6,damage=>20,spells=>{ghoulish=>1}},
ettin=>{user=>0,hp=>600,mp=>0,xp=>1800,hitsas=>16,damage=>40,spells=>{}},
giant=>{user=>0,hp=>1800,mp=>10,xp=>3600,hitsas=>30,damage=>100,spells=>{sniff=>1}},
giant_spider=>{user=>0,hp=>500,mp=>100,xp=>2000,hitsas=>16,damage=>50,spells=>{web=>1}},
radioactive_spider=>{user=>0,hp=>500,mp=>100,xp=>3000,hitsas=>16,damage=>50,spells=>{web=>1,rbite=>1}},
black_drake=>{user=>0,hp=>400,mp=>150,xp=>1200,hitsas=>14,damage=>20,spells=>{acid_spray=>1}},
troll=>{user=>0,hp=>800,mp=>400,xp=>2400,hitsas=>18,damage=>40,spells=>{regenerate=>1}},
wolf=>{user=>0,hp=>30,mp=>5,xp=>80,damage=>8,spells=>{sniff=>1}},
wolf_rider=>{user=>0,hp=>60,mp=>0,xp=>200,hitsas=>2,damage=>10,spells=>{}},
slime_gang=>{user=>0,hp=>30,mp=>6,xp=>100,hitsas=>2,damage=>9,spells=>{}},
metal_slime=>{user=>0,hp=>60,mp=>300,xp=>600,hitsas=>4,damage=>10,spells=>{acid_shower=>1,heal=>1}},
slime_king=>{user=>0,hp=>60,mp=>20,xp=>300,hitsas=>4,damage=>15,spells=>{cure=>1,spark=>1}},
drake=>{user=>0,hp=>200,mp=>50,xp=>600,hitsas=>8,damage=>15,spells=>{flare=>1}},
stupid_looking_dragon=>{user=>0,hp=>100,mp=>120,xp=>900,damage=>20,spells=>{really_bad_breath=>1}},
green_dragon=>{user=>0,hp=>500,mp=>120,xp=>1200,damage=>20,spells=>{poison_breath=>1}},
red_dragon=>{user=>0,hp=>1000,mp=>200,xp=>2400,damage=>30,spells=>{fire_breath=>1}},
shadow_dragon=>{user=>0,hp=>2000,mp=>500,xp=>4800,damage=>50,spells=>{shadow_breath=>1,unholy=>1,ghoulish=>1}},
cosmic_dragon=>{user=>0,hp=>10000,mp=>5000,xp=>10000,damage=>200,spells=>{shadow_breath=>1,fire_breath=>1,poison_breath=>1,negate=>1,revive=>1,meteo=>1}},
dragon_swarm=>{user=>0,hp=>50000,mp=>50000,xp=>50000,damage=>5000,spells=>{breath_weapon_barrage=>1}},
jehovah=>{user=>0,hp=>25000,mp=>20000,xp=>25000,hitsas=>200,damage=>500,spells=>{holy_wrath=>1,flood_the_earth=>1,judgement_day=>1,revive=>1,life=>1}},
zeus=>{user=>0,hp=>25000,mp=>10000,xp=>25000,hitsas=>200,damage=>1000,spells=>{hurl_thunderbolt=>1,revive=>1}},
buddha=>{user=>0,hp=>10,mp=>100,xp=>1,hitsas=>50,damage=>0,spells=>{preach=>1}},
jesus=>{user=>0,hp=>10,mp=>100,xp=>1,hitsas=>50,damage=>0,spells=>{preach=>1}},
twink=>{user=>1,hp=>500,mp=>100,xp=>10,damage=>50,spells=>{flare=>1,cure=>1,heal=>2,spark=>2,ice=>3,heal=>4,fireball=>4,wound=>5,unholy=>6,revive=>8,meteo=>9,negate=>10},win=>0},
);

# i have no idea what this stuff means... -j

my %class_aliases=(
warrior=>'fighter',
wizard=>'mage',
black_mage=>'mage',
white_mage=>'healer',
cleric=>'healer',
red_mage=>'twink',
monster=>'slime',
ballerina=>'dancer',
black_belt=>'monk',
karate=>'monk',
master=>'monk',
whore=>'harlot',
caller=>'summoner',
);

# what a summoner gets for studying each of these monsters

my %summons=(
fighter=>'fighter_doken',
diablo=>'meteo',
bard=>'song',
elephant=>'pound',
lion=>'roar',
troll=>'regenerate',
harlot=>'censored',
skank=>'really_bad_breath',
hag=>'really_bad_breath',
giant_spider=>'web',
radioactive_spider=>'web',
black_drake=>'acid_spray',
can_of_whup_ass=>'whup_ass',
unlabelled_can_of_mystery=>'scan',
healer=>'cure',
jesus=>'raise',
buddha=>'revive',
zeus=>'hurl_thunderbolt',
jehovah=>'holy_wrath',
dragon_swarm=>'dragon_slave',
mage=>'ice',
ghoul=>'ghoulish',
drake=>'flare',
green_dragon=>'gas',
stupid_looking_dragon=>'duh',
red_dragon=>'fireball',
shadow_dragon=>'unholy',
cosmic_dragon=>'meteo',
ogre=>'wound',
ettin=>'pound',
giant=>'stomp',
robot=>'spark',
monk=>'kick',
metal_slime=>'acid_shower',
slime_king=>'cure',
slime_gang=>'lame',
slime=>'lame',
imp=>'lame',
wolf=>'sniff',
wolf_rider=>'howl',
angel=>'preach',
);

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
	if($characters{$caster}->{delay}<time()){
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
                }}else{
                        say("but \2$student\2 doesn't understand \2$subject\2!");                         # failure...
		}
		$characters{$target}->{delay}=time()+5;					# add 5 seconds to delay time
        }else{
		penalty($student);							# how could there be something else, oh well.. hurt em for messin with beng!
	}
}
#------------------------------------------#
# spells that do stuff other than damage
#------------------------------------------#
%special_spells=(
mpshield=>sub {my ($caster, $target) = @_;
	$characters{$target}->{seffect} = "mpshield";
	$characters{$target}->{sefftime} = "5";
	say("\2$target\2 is now protected by their magic for a limited time!");
	return 0;
	
},


assimilate=>sub {my ($caster, $target) = @_;
	cause_damage($caster,$target,3500);
	cause_damage($target,$caster,-1700);
	my $mptaken = mp_damage($caster,$target,70);
	my $mptaken = mp_damage($target,$caster,-$mptaken);
	return 0;
},
dance_of_special_words=>sub {my ($caster, $target) = @_;

        say("\2$caster\2 give his MP to \2$target\2");
        $characters{$target}->{mp}+=100;
        	return 0;
},
heal_all=>sub {my ($caster, $target) = @_;
	for(get_actives()){
		if(exists $characters{$_}){
                      cause_damage($caster,$_,-5000);
                        
		}
	}
	return 0;
},
gravity_bomb=>sub {my ($caster, $target)=@_;
        $demi=$characters{$target}->{hp}/1.5;
        cause_damage($caster,$target,$demi);
        return 1;
},
omniscience=>sub {my ($caster, $target)=@_;
	status($target);
	return 0;
},
fly=>sub {my ($caster, $target)=@_;
	delete $present{lc($caster)};
	$concealed{lc($caster)}=1;
	return 0;
},
lullaby=>sub {my ($caster, $target)=@_;
	delete $present{lc($caster)};
	$concealed{lc($caster)}=1;
	if($target ne 'monster'){
		$characters{$target}->{isresting}=1;
		$conn_self->mode($channel,"-v",$target);
		$characters{$target}->{delay}=time()+60;
		delete $present{lc($target)};
		delete $concealed{lc($target)};
	}else{
		say("\2The \2$target\2 is not amused by your pathetic ditty.");
	}
	return 0;
},
sniff=>sub {my ($caster, $target)=@_;
	if(keys %concealed){
		say("\2$caster\2 smells concealed parties!  They are no longer hidden.");
		for(keys %concealed){
			$present{lc($_)}=1;
			delete $concealed{$_};
		}
	}
	return 0;
},
serenade=> sub {my ($caster, $target)=@_;
	my $time=int(rand(30)+1);
	if($characters{$target}->{delay} < (time()+8)){
		$characters{$target}->{delay}=time()+$time;
		say("\2$caster\2 paralyzes \2$target\2 with a beautiful song for \2$time\2 seconds!");
	}else{
		$characters{$target}->{delay}+=$time;
		my $totaldelay=$characters{$target}->{delay}-time();
		if($totaldelay>45){
			$characters{$target}->{delay}=time();
			say("A bad note brings \2target\2 out it's trance!");
		}else{
			say("\2$target\2 is distracted for \2$time\2 more seconds!");
		}
	}
	return 0;
},
rbite=>sub {my ($caster, $target)=@_;
	if(rand()>0.75){
		say("\2$target\2 begins to transform into some kind of hideous spider/man cross!");
		new_character($target,'spider_man',$characters{$target}->{staticid});
		return 0;
	}else{
		cause_damage($caster,$target,200);
		return 1;
	}
},
vanish=>sub {my ($caster, $target)=@_;
	delete $present{lc($caster)};
	$concealed{lc($caster)}=1;
	return 0;
},
hide=>sub {my ($caster, $target)=@_;
	delete $present{lc($caster)};
	$concealed{lc($caster)}=1;
	return 0;
},
censored=>sub {my ($caster, $target)=@_;
	say("[the resulting effects have been censored]");
	return 0;
},
waltz=>sub {my ($caster, $target)=@_;
	say("\2$caster\2 waltzes right out of the battle.");
	delete $present{lc($caster)};
	$concealed{lc($caster)}=1;
	if($caster ne 'monster'){
		$characters{$caster}->{isresting}=1;
		$conn_self->mode($channel,"-v",$caster);
		$characters{$caster}->{delay}=time()+60;
	}
	return 0;
},
sneak=>sub {my ($caster, $target)=@_;
	delete $present{lc($caster)};
	$concealed{lc($caster)}=1;
	if($caster ne 'monster'){
		$characters{$caster}->{isresting}=1;
		$conn_self->mode($channel,"-v",$caster);
		$characters{$caster}->{delay}=time()+60;
	}
	return 0;
},
smoke_bomb=>sub {my ($caster, $target)=@_;
	delete $present{lc($caster)};
	$concealed{lc($caster)}=1;
	if($target ne 'monster'){
		$characters{$target}->{isresting}=1;
		$conn_self->mode($channel,"-v",$target);
		$characters{$target}->{delay}=time()+60;
		delete $present{lc($target)};
		delete $concealed{lc($target)};
	}
	return 0;
},
howl=>sub {my ($caster, $target)=@_;
	say("Awoooooooo!");
	return 0;
},
mug=>sub {my ($caster, $target)=@_;
	if(exists $characters{$target}){
		cause_damage($caster,$target,120);
	}
	if(int(rand(5))==1){
		say("\2$caster\2's escape fails!  He is open to attack!");
	}else{
		delete $present{lc($caster)};
		$concealed{lc($caster)}=1;
	}
	return 1;
},
shadow_strike=>sub {my ($caster, $target)=@_;
	if(exists $characters{$target}){
		cause_damage($caster,$target,120);
	}
	if(int(rand(5))==1){
		say("\2$caster\2's escape fails!  He is open to attack!");
	}else{
		delete $present{lc($caster)};
		$concealed{lc($caster)}=1;
	}
	return 1;
},
breath_weapon_barrage=>sub {my ($caster, $target)=@_;
	for(get_actives()){
		if(exists $characters{$_}){
			cause_damage($caster,$_,10000);
			if(exists($characters{$caster}) && $characters{$_}->{hp}<1){
				defeats($caster,$_);
			}
		}
	}
	return 0;
},
ghoulish=>sub {my ($caster, $target)=@_;
	say("\2$caster\2 reads \2$target\2's mind to learn the location of the graveyard");
	if($target eq 'monster'){
		say("...but he doesn't know where the graveyard is.");
	}elsif(keys %graveyard){
		my $choice=rand_el(keys %graveyard);
		say("\2$caster\2 exhumes and eats the body of \2$choice\2");
		clean_grave($graveyard{$choice}->{staticid});
		cause_damage($caster,$caster,-500);
	}else{
		say("...but the graveyard is empty.");
	}
	return 0;
},
scan=>sub {my ($caster, $target)=@_;
	status($target);
	return 0;
},
tangle_tango=>sub {my ($caster, $target)=@_;
	my $time=int(rand(30)+1);
	if($caster eq $target){
		sayto($caster, "It takes two to \2tango\2.");
		return 0;
	}
	if($characters{$target}->{delay} < (time()+9)){
		$characters{$target}->{delay}=time()+$time;
		say("\2$target\2 is tripped for \2$time\2 seconds!");
	}else{
		$characters{$target}->{delay}+=$time;
		my $totaldelay=$characters{$target}->{delay}-time();
		if($totaldelay>40){
			$characters{$target}->{delay}=time();
			say("\2$caster\2 dances \2target\2 back in step!");
		}else{
			say("\2$target\2 is stumbling for \2$time\2 more seconds!");
		}
	}
	return 0;
},
web=>sub {my ($caster, $target)=@_;
	my $time=int(rand(30)+1);
	if($characters{$target}->{delay} < (time()+9)){
		$characters{$target}->{delay}=time()+$time;
		say("\2$target\2 is trapped for \2$time\2 seconds!");
	}else{
		$characters{$target}->{delay}+=$time;
		my $totaldelay=$characters{$target}->{delay}-time();
		if($totaldelay>40){
			$characters{$target}->{delay}=time();
			say("The fresh webbing weakens \2target\2's bond, and he is free!");
		}else{
			say("\2$target\2 is stuck for \2$time\2 more seconds!");
		}
	}
	return 0;
},
taser=>sub {my ($caster, $target)=@_;
	my $time=int(rand(60)+1);
	if($characters{$target}->{delay} < (time()+9)){
		$characters{$target}->{delay}=time()+$time;
		say("\2$target\2 is paralyzed for \2$time\2 seconds!");
	}else{
		$characters{$target}->{delay}+=$time;
		my $totaldelay=$characters{$target}->{delay}-time();
		if($totaldelay>70){
			$characters{$target}->{delay}=time();
			say("The shock brings \2target\2 out of his paralysis!");
		}else{
			say("\2$target\2 is paralyzed for \2$time\2 more seconds!");
		}
	}
	return 0;
},
life=>sub {my ($caster, $target)=@_;
	if(exists $graveyard{$target}){
		resurrect($target);
	}else{
		say("There is no body of \2$target\2 to raise.");
	}
	return 0;
},
raise=>sub {my ($caster, $target)=@_;
	if(exists $graveyard{$target}){
		if((time()-$graveyard{$target}->{delay})<300){
			resurrect($target);
		}else{
			say("Alas!  \2$target\2 has been dead for too long!");
		}
	}else{
		say("There is no body of \2$target\2 to raise.");
	}
	return 0;
},
);

# status effects
sub cause_status{ my ($target)=@_;
	if ( $characters{$target}=>{seffect} == "poison" ) {
	   $cause_damage("Poison",$target,50);
	}
	elseif ( $characters{$target}=>{seffect} == "regen" ) {
	   $cause_damage("Regen",$target,-60);
	}
        ## ones that have repeated effects go above.  But they all count down..
	$characters($target)=>{seffect} -= 1;

	return 1;
}



# rand_el picks a random element from a list, see can_of_mystery for example
sub rand_el{
	return $_[int(rand(scalar(@_)))];
};

# things that say/do weird stuff when they die.  This includes cans that reveal stuff inside.
my %weird_deaths=(
gazelle=>sub{ my ($name,$killer)=@_;
        my $choice=rand_el('nothing','lion');
        if(exists $characters{$killer}){
                $characters{$killer}->{xp}+=80;
                correct_points($killer);
                say("\2$killer\2 defeats \2monster\2");
        }
        delete $characters{$name};
        if($choice eq 'lion'){
                say("The blood attracts a fierce \2lion!\2");
                new_character('monster','lion','impossible!ID@!@!@');
        }

},
fairy=>sub{ my ($name,$killer)=@_;
        say("She gets pissed.");
        new_character('monster','damned_fairy','impossible!ID@!@!@');
        return 0;
},
exp_in_a_can=>sub{ my ($name,$killer)=@_;
	say("Reeeeefreshing!");
	return 1;
},
unlabelled_can_of_mystery=>sub{ my ($name,$killer)=@_;
	say("You open the can to find...");
	my $choice=rand_el('exp','potion','insanity','nothing','dogfood',
	 'cure','slime','dragon','can','peaches');
	delete $characters{$name};
	if($choice eq 'exp'){
		say("A boatload of exp!");
		if(exists $characters{$killer}){
			$characters{$killer}->{xp}+=1000;
			correct_points($killer);
		}
	}elsif($choice eq 'potion'){
		say("A wonderful potion!");
		say("\2$killer\2 is healed");
		if(exists $characters{$killer}){
			$characters{$killer}->{hp}+=1000;
			$characters{$killer}->{mp}+=1000;
			correct_points($killer);
		}
	}elsif($choice eq 'insanity'){
		say("Something unspeakable... something \2$killer\2's mind can't handle.");
		say("\2$killer\2 goes completely insane!");
		$characters{monster}=$characters{$killer};
		$characters{monster}->{staticid}='impossible!ID@!@!@';
		delete $characters{$killer};
		delete $present{$killer};
		delete $concealed{$killer};
		say("\2$killer\2 is now \2monster\2!");
	}elsif($choice eq 'nothing'){
		say("Nothing at all!");
	}elsif($choice eq 'peaches'){
		say("Peaches!");
		say("In heavy syrup!");
	}elsif($choice eq 'dogfood'){
		say("Something that smells like meat, but worse.");
		say("You wouldn't feed this to your worst enemy.");
	}elsif($choice eq 'cure'){
		say("A cure for cancer!");
		say("The world hails \2$killer\2 as the greatest hero ever!");
		say("Your name echos through the ages!");
	}elsif($choice eq 'slime'){
		say("A lowly, lowly slime.");
		new_character('monster','slime','impossible!ID@!@!@');
	}elsif($choice eq 'dragon'){
		say("A dragon.  You scratched his favorite scale opening it.");
		say("He looks pretty mad.");
		new_character('monster',
		 rand_el('stupid_looking_dragon','green_dragon','red_dragon',
		  'shadow_dragon','cosmic_dragon'),
		 'impossible!ID@!@!@');
	}elsif($choice eq 'can'){
		say("Another can!");
		new_character('monster',
		 rand_el('unlabelled_can_of_mystery','monster_in_a_can',
		  'exp_in_a_can', 'can_of_whup_ass','god_in_a_can','can_of_wyrms'),
		 'impossible!ID@!@!@');
	}else{
		say("A \2bug\2 in the battle engine! (oops!)");
	}
	return 0;
},monster_in_a_can=>sub{ my ($name,$killer)=@_;
	my $new_monster=$canned_monsters[int(rand(scalar(@canned_monsters)))];
	say("You've opened a can of \2$new_monster\2!");
	new_character('monster', $new_monster, 'impossible!ID@!@!@');
	return 0;
},
god_in_a_can=>sub{ my ($name,$killer)=@_;
	my $new_monster=$canned_gods[int(rand(scalar(@canned_gods)))];
	say("You've opened a can of \2$new_monster\2!");
	new_character('monster', $new_monster, 'impossible!ID@!@!@');
	return 0;
},
can_of_whup_ass=>sub{ my ($name,$killer)=@_;
	say("You've succeeded in opening a \2can_of_whup_ass\2!");
	say("Guess what's inside!");
	new_character('monster', 'cosmic_dragon', 'impossible!ID@!@!@');
	return 0;
},
can_of_wyrms=>sub{ my ($name,$killer)=@_;
	say("W\2y\2rms!  Everywhere!");
	new_character('monster', 'dragon_swarm', 'impossible!ID@!@!@');
	return 0;
},
buddha=>sub{ my ($name,$killer)=@_;
	say("I don't care what you heard in a koan, killing Buddha is seriously bad karma.");
	return 1;
},
jesus=>sub{ my ($name,$killer)=@_;
	say("No, no, \2NO\2!  It's supposed to be '\2for\2 your sins' not '\2by\2 your sins'.");
	say("What are you, \2ROMANS??!\2");
	return 1;
},
jehovah=>sub{ my ($name,$killer)=@_;
	say("Zounds!  You know we're both going to Hell for this.");
	return 1;
},
zeus=>sub{ my ($name,$killer)=@_;
	say("Hah!  THAT was for Prometheus!");
	return 1;
},
);

#---------------------------------------------------------------------------------------------------------------------------------#
# making a new character or monster
# arguments are as follows 
# $name is the name of the monster ('monster' usually, or the characters name)
# $class is the actual thing it is 'cosmic_dragon'
# $static is the ip or the impossible thing for monsters.
#---------------------------------------------------------------------------------------------------------------------------------#
sub new_character{my ($name,$class,$static)=@_; # arguments..
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
		win=>0,
	}; # duh, alot of stuff... pretty obvious what it is.
	if($classes{$class}->{user}){					# these are apparently references, something i dont know and efnet #perl yells at me for not knowing
		say("\2$name\2 becomes a Level 1 \2$class\2!"); # if its a user... say so
	}else{
		say("A \2$class\2 (ID: \2$name\2) appears!");   # if its a monster... say so
	}
	learned($name,$class);						# learned a spell, plus its arguments ($name, who learned it, and $class, what monster was it that they learned.)
	$lcnames{lc($name)}=$name;					# checks for case sensitive naming...
	if($class eq 'summoner'){					
		$characters{$name}->{summons}={};			# dunno
	}
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

# save stuff
sub save{
	open SAVEFILE, ">beng.state";
	print "Saving...\n";
	foreach $name (keys %characters){
		save_character($name);
	}
	foreach $name (keys %graveyard){
		save_corpse($name);
	}
	close SAVEFILE;
	$lastsave=time();
	logprint("!!!\nSAVED STATE\n!!!\n");
}
# loading stuff
sub load{
	open LOADFILE, "<beng.state" or return;
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

# aha, its learned.  Getting spells is now 75% easier with new LEARNED!!! =] ;)
sub learned{ my ($name,$class)=@_;
	foreach $spell (keys %{$classes{$class}->{spells}}){
		if($classes{$class}->{spells}->{$spell} == $characters{$name}->{level}){
			say("\2$name\2 learned \2$spell\2!");
		}
	}
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
        if($characters{$name}->{staticid} eq 'impossible!ID@!@!@'){
	return int(xp_needed($name)/3);
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
        } # hitsas is a defense/attack rating
	if(exists $classes{$characters{$defender}->{class}}->{hitsas}){
		$dlevel=$classes{$characters{$defender}->{class}}->{hitsas};
	}
	if($characters{$attacker}->{class} =~ /dragon/){
		return 1;
	}
	if($characters{$attacker}->{class} eq 'twink'){
		return 1;
	}
	if($characters{$defender}->{class} eq 'bard'){
		return 1;
	}
	my $prob=$alevel/$dlevel*0.75;
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
        $dmg = $dmg + int(.5 * $level);
	if((($characters{$name}->{class} eq 'twink') ||
		$characters{$name}->{class} =~ /dragon/) && int(rand(6))==1){
		say("CRITICAL HIT!");
		return 10*$dmg;
      }elsif(($characters{$name}->{class} =~ /fighter/) &&	(rand(30)<$level) ){
		say("CRITICAL HIT!");
            return 10*$dmg;
      }elsif($characters{$name}->{class} =~ /monk/){
            $monk_damage = ( (0.08 * $level) + 1) * $classes{$characters{$name}->{class}}->{damage};
            if(rand(40)<$level){
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
		say("\2$target\2 is drained of \2$actual\2 by \2$attacker\2");
		$characters{$target}->{mp}-=$actual;
		return $actual;
}
# doing actual damage, or healing
sub cause_damage{ my ($attacker,$name,$amount)=@_;
	if($amount == 0){
		say("\2$name\2 is not affected");
	}elsif($amount>0){
            my $actual=int((rand()+.05)*($amount*0.955)+1);				# kenard's new damage algorithm adds a minimum of 5% damage 
		say("\2$attacker\2 hits \2$name\2 for \2$actual\2 points of damage!");
		$characters{$name}->{hp}-=$actual;
	}else{
		$amount=-$amount;
		my $actual=int(rand()*$amount+1);
		say("\2$name\2 is healed of \2$actual\2 points of damage.");
		$characters{$name}->{hp}+=$actual;
	}
	if($name eq 'monster' && $characters{monster}->{delay}<time()){
		$characters{monster}->{delay}=time()-10;
	}
	correct_points($name);
	if($characters{$name}->{hp}<=0){
		say("\2$name\2 is struck dead!");
	}
}

# attacking
sub attack{ my ($attacker, $defender)=@_;
	if($characters{$attacker}->{isresting}){
		sayto($attacker, "You can't do that, you're resting!");
		return;
	}
	if($characters{$defender}->{isresting}){
		sayto($attacker, "You can't do that, that's not nice!");
		return;
	}
	if($characters{$attacker}->{delay}<time()){
		if(does_hit($attacker,$defender)){
			cause_damage($attacker,$defender, damage_dealt($attacker));
			if($characters{$defender}->{hp}<=0){
				defeats($attacker,$defender);
			}
		}else{
			say("\2$defender\2 nimbly evades a strike from \2$attacker\2");
		}
		if(exists $characters{$attacker}){
			$characters{$attacker}->{delay}=time()+5;
		}
	}else{
		penalty($attacker);
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
	say("\2$name\2 LEVELS UP!");
	say("\2$name\2 is now a Level \2$characters{$name}->{level} $class\2!");
	learned($name,$class);
	if($characters{$name}->{level}==100){
		say("This is getting ridiculous.  Level \2100\2?!");
	}
	if(exists $level_effects{$class}){
		&{$level_effects{$class}}($name);
	}
}
# if you have too many hp/mp, bring it back to the max.
sub correct_points{ my ($name)=@_;
	if($characters{$name}->{hp}>$characters{$name}->{maxhp}){
		$characters{$name}->{hp}=$characters{$name}->{maxhp};
	}
	if($characters{$name}->{mp}>$characters{$name}->{maxmp}){
		$characters{$name}->{mp}=$characters{$name}->{maxmp};
	}
	while(exists($characters{$name}) &&
	 $characters{$name}->{xp} >= xp_needed($name)){
		level_up($name);
	}
}
# the winner, and still champeen.
sub defeats{ my ($victor,$victim)=@_;
	my @victors=();  	# all the different victors
	if(! exists $characters{$victim}){
		return;	# no victims?, get outta here!
	}
	if(! exists $characters{$victor}){
		return;	# no victors?, get outta here!
	}
	my $victim_class=$characters{$victim}->{class};
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
		} # well, give the winners some xp
	}

	for(@victors){
		if($_ ne $victim && exists($characters{$_})){
			correct_points($_);
		}
	}
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
	return ($characters{$caster}->{mp} >= $spells{$spell}->{cost}) &&
	 exists($classes{$characters{$caster}->{class}}->{spells}->{$spell}) &&
	 ($classes{$characters{$caster}->{class}}->{spells}->{$spell} <=
	 $characters{$caster}->{level});
}

sub can_summon{ my ($caster,$class)=@_;				# do you have the summon, do you have the mp?
	if(! exists($characters{$caster})){return 0;}
	if($characters{$caster}->{class} ne 'summoner'){return 0;}
	if(exists $characters{$caster}->{summons}->{$class}){
		if(summon_cost($class) > $characters{$caster}->{mp}){
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
	if($characters{$caster}->{delay}<time()){
		if(can_summon($caster,$class)){
			my $spell=$summons{$class};
			my $damage=$spells{$spell}->{damage};
			$characters{$caster}->{mp}-=$spells{$spell}->{cost};
			if(rand()<(0.70+$characters{$caster}->{level}/100)){	
				if(exists $characters{$caster}){
					$characters{$caster}->{delay}=time()+9;		# check to see if it fails, plus at the 9 second delay.
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
					cause_damage($caster,$target,$damage);
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
sub cast{ my ($caster, $spell, $target)=@_;
	if($characters{$caster}->{isresting}){
		sayto($caster, "You can't do that, you're resting!");
		return;
	}
	if($characters{$caster}->{delay}<time()){
		if(can_cast($caster,$spell)){
			my $target_ok=exists($characters{$target});
			my $target_hurt=(!exists($characters{$target})) ||
			 $characters{$target}->{hp}<$characters{$target}->{maxhp};
			my $cost=$spells{$spell}->{cost};
			my $damage=$spells{$spell}->{damage};
			my $defeat_check=1;
			$characters{$caster}->{mp}-=$cost;
			if((rand()>0.97) && ($spell ne "magic_missile")){
				say("\2$caster\2's spell fizzles!");	# 3% chance of spell fizzle
			}else{
				if(exists $characters{$caster}){
					$characters{$caster}->{delay}=time()+7;	# 7 second delay for spells
				}
				say("\2$caster\2 casts \2$spell\2!");
				if(exists $special_spells{$spell}){
					$defeat_check= &{$special_spells{$spell}}($caster,$target);
				}else{
					cause_damage($caster,$target,$damage);
				}
				if($defeat_check && $target_ok && $characters{$target}->{hp}<=0){
					defeats($caster,$target);		# call up defeats if the spell worked, the target is there, and hp < 0
				}
				my $raised= (!$target_ok) && exists($characters{$target});
				my $wounded= $target_ok && $damage > 0;
				my $healed= $target_hurt && $damage < 0;
				my $useful= $raised || $wounded || $healed;	# people that did stuff.
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
	say("\2$name\2 is a level \2$characters{$name}->{level}\2 ".
	 "\2$characters{$name}->{class}\2 with \2$characters{$name}->{hp}/$characters{$name}->{maxhp}\2 hit points,".
	 " \2$characters{$name}->{mp}/$characters{$name}->{maxmp}\2 magic points, and ".
	 "\2$characters{$name}->{xp}\2 experience points (\2". xp_needed($name) .
	 "\2 needed for next level).");
}

sub penalty{ my ($name)=@_;
	sayto($name,"Whoa!  Slow down!  That'll cost you another 5 seconds.");
	$characters{$name}->{delay}=$characters{$name}->{delay}+5;
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

	}elsif($characters{$name}->{delay}<time()){
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
	if($characters{$name}->{delay}<time()){
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
		if($characters{$name}->{delay}<time()){
			my $factor=(time()-$characters{$name}+60)/300;
			if($protect_chat){
				$characters{$name}->{hp}+=int($characters{$name}->{maxhp}*$factor);
				$characters{$name}->{mp}+=int($characters{$name}->{maxmp}*$factor);
			}else{
				$characters{$name}->{hp}=$characters{$name}->{maxhp};
				$characters{$name}->{mp}=$characters{$name}->{maxmp};
			}
			correct_points($name);
			say("\2$name\2 arises, feeling refreshed");
		}else{
			say("\2$name\2 rises, grumpy and unrested.");
		}
		$characters{$name}->{isresting}=0;
		$conn_self->mode($channel,"+v",$name);
		$characters{$name}->{delay}=time()+5;
	}
}

# this seems to be the monsters, and their rarity....

my %areas=(
hometown_plains=>{
slime=>1000,
unicorn_jelly=>1,
robot=>100,
evil_chair=>10,
evil_pants=>5,
exp_in_a_can=>10,
},
hometown_forest=>{
slime=>100,
imp=>100,
wolf=>100,
wolf_rider=>20,
unicorn_jelly=>1,
evil_chair=>10,
evil_pants=>5,
exp_in_a_can=>10,
},
slime_valley=>{
slime=>500,
slime_gang=>500,
slime_king=>50,
metal_slime=>5,
unicorn_jelly=>1,
},
bizarre_cannery=>{
exp_in_a_can=>20,
monster_in_a_can=>10,
can_of_whup_ass=>5,
unlabelled_can_of_mystery=>5,
god_in_a_can=>2,
can_of_wyrms=>1,
},
ogre_pit=>{
ogre=>100,
ettin=>10,
giant=>1,
},
holy_mountain=>{
cosmic_dragon=>2,
jehovah=>1,
zeus=>1,
jesus=>10,
buddha=>20,
monk=>300,
healer=>700,
},
dragon_cave=>{
drake=>100,
green_dragon=>20,
stupid_looking_dragon=>10,
red_dragon=>10,
shadow_dragon=>2,
cosmic_dragon=>1,
},
swamp_of_spiders=>{
ghoul=>200,
black_drake=>200,
giant_spider=>100,
troll=>100,
green_dragon=>50,
},
wild_savannah=>{
lion=>20,
gazelle=>75,
elephant=>20,
},
town_square=>{
mage=>50,
fighter=>40,
ninja=>30,
town_fool=>30,
constable=>10,
},
hell=>{
diablo=>5,
fairy=>5,
lost_soul=>20,
lawyer=>20,
}
);

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
			$characters{$_}->{delay}=time()+5;
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
		$characters{monster}->{isresting}=0;
		my @targets=get_targets();
		if(!get_party()){
			say("Everyone has escaped from the $characters{monster}->{class}!");	# nobody for the monster to play with
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
			if($choice>=2){
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

# apparently, if you are in the frontline, you get added to the array twice =]  therefore, more of a target
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
	say("Greetings.  I am Battle Engine X. $bengversion");
	say("Command me with '\2BEng command\2'.");
	say("Try '\2BEng help\2'.");
	say("WWW: http://pub78.ezboard.com/bbattleenginex");
        say("Latest updates: Most classes get a level 50 spell. | summoners' study says something different when they can't learn. | bot should +v you if your awake | Now monster only acts when beng is said");
        say("Latest bug fixes: Thief got spells. | heal_all should work now with no target. | radioactive_spider is dead.");
        say("Current hint: It's a secret to everybody.");
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
		$_=$1;
		monster_action();							# monsters....
		if(exists($characters{$from}) &&
		 ($characters{$from}->{staticid} ne $static)){
			say("Hey \2$from\2!  Back to your own nick!");
			sayto($from,"If this is actually your account, use '\2\/msg BattleEngineX login PASSWORD\2' to log in (and create a password, if you hadn't before).");
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
			}elsif($staticmatch){
				say("Oi! No cloning, \2$from\2!");			# no cloning!
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
				sayto($from,$spells{lc($1)}->{description});	# spell help... does the spell exist?  If so, read the desc.
			}elsif(/^class/i){
				sayto($from,"These are the classes: \2summoner\2, \2fighter\2, \2mage\2, \2healer\2, \2ninja\2, \2bard\2, \2robot\2, \2thief\2, \2harlot\2, \2monk\2, \2slime\2, and \2dancer\2.");
			}elsif(/^wander/i){
				sayto($from,"Use '\2wander AREA\2' to find a monster to fight!");
			}elsif(/^area/i){
				sayto($from,"Wander any of these areas: \2".join(' ',keys(%areas)).
				 "\2");
			}elsif(/^front/i){
				sayto($from,"Move to the front of the line, protect your allies.");
			}elsif(/^back/i){
				sayto($from,"Move behind your allies, let them take the heat.");
			}elsif(/^study/i){
				sayto($from,"Study a creature to learn to summon it.");
			}elsif(/^summon/i){
				sayto($from,"Summon a creature you've successfully \2study\2'd.",
				 "Use '\2beng summons\2' to learn which you can summon.");
			}elsif(/^challenge/i){
				sayto($from,"Challenge a player to fight to the death with you.");
			}elsif(/^accept/i){
				sayto($from,"Agree to a fight to the death.");
			}elsif(/^decline/i){
				sayto($from,"Refuse to a fight to the death.");

			}elsif(/^spell/i){
				sayto($from,"There are four known spells: \2flare\2, \2fireball\2, \2cure\2, and \2heal\2.",
				 "\2Flare\2 and \2fireball\2 are mage spells.",
				 "\2Cure\2 and \2heal\2 are healer spells.",
				 "It is rumoured that there are some spells known only to the highest level characters...",
				 "(and those with the source code) ;P",
				 "Use '\2beng spells\2' to learn which you can cast.");
                  }elsif(/^version/i){
				sayto($from,"Battle Engine X, $bengversion.",
                                 'Battle Engine X code by:',
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
				if(exists($characters{lcname($1)})){
					if(!$present{lc($1)}){
						say("\2$1\2 isn't here.");
					}else{
						attack($from,lcname($1));
					}
				}else{
					say("There is no \2$1\2.");
				}
			}elsif(/^cast\s+(\S+)\s+(?:on\s+)?(\S+)/i){
				my $spell=$1;
				my $target=$2;
				if(lc($spell) =~ /raise|life/){
					cast($from,lc($spell),lcname($target));	# if its raise or life, then cast on the target, regardless if they are here or not
				}elsif(lc($spell) =~ /heal_all/){			# Heal all fixed.
					cast($from,lc($spell),$from);
				}elsif(!exists($characters{lcname($target)})){
					say("There is no \2$target\2.");		# no target?
				}elsif(!exists($spells{lc($spell)})){
					say("There's no such spell as \2$spell\2.");	# no such spell?
				}else{
					if(!$present{lc($target)}){				# not present?
						say("\2$target\2 isn't here.");
					}else{
						cast($from,lc($spell),lcname($target));
					}
				}
			}elsif(/^summon\s+(\S+)\s+(?:at\s+)?(\S+)/i){
				my $creature=$1;
				my $target=$2;
				if(exists($summons{lc($creature)}) && ($summons{lc($creature)} =~ /raise|life/)){
					summon($from,lc($creature),lcname($target));	# do a raise/life thing first
				}elsif(!exists($characters{lcname($target)})){
					say("There is no \2$target\2.");
				}else{
					if(!$present{lc($target)}){
						say("\2$target\2 isn't here.");
					}else{
						summon($from,lc($creature),lcname($target));
					}
				}
			}elsif(/^spells/i){
				tell_spells($from);
			}elsif(/^summons/i){
				tell_summons($from);
			}elsif(/^study\s+(\S+)/i){
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
			}elsif(/^stat/i){
				status($from);
                  }elsif(/^version/i){
				sayto($from,"Battle Engine X, $bengversion.",
                                 'Battle Engine X code by:',
                                 "\2jikuu\2 - jikuu\@home.com",
                                 "\2kenard\2 - Kehmry\@starband.net",
				 "Original code by \2nindalf\2."); 
			}else{
				sayto($from,"I'm sorry, I don't understand.");
			}
		}else{
			sayto($from,"You have to join first.");
		}
	}
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
	if($text=~/^log\S*\s+(\w+)/i){
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
		    Port    =>  6667,
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
while (1)
{
	$irc->do_one_loop();
	if ($timeout < time()){
			if (!$alive){
				save();
				print "Disconnected\n";
				$irc->removeconn($conn);
				setconn();
				$alive=1;
				$timeout= time() + 120;
			}			
			else {
			
			print "Pinging $beng_nick\n";
			$conn->ctcp("PING","$beng_nick");
			$timeout=($alive eq 1)?time()+30:time()+600;
			}
			
	}
}


