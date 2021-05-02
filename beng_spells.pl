#-------------------------------------#
# I wonder what these are.... :P
# cost is MP
# damage is damage from 1 to whatever
# description is the help thing
#-------------------------------------#


# Elements:
# None
# Fire 
# Ice 
# Chem
# Lit
# Dark
# Holy
#Energy
print "Loading spell data...";

%spells=(


auto_tin=>{cost=>'1',damage=>'1',description=>'For tinning foolish hunters.'},
second_wind=>{cost=>'1000',damage=>'-1',description=>'Hes getting a second wind!'},

throw_gold=>{cost=>'40',damage=>'-1',description=>'Money makes the world go round'},
fix_gold=>{cost=>'0',damage=>'-1',description=>'Temp debugging'},
steal_item=>{cost=>'60',damage=>'1',description=>'Steals items'},
steal_gold=>{cost=>'20',damage=>'1',description=>'Steals Gold'},
#spells for the seniles
always_remember_rule_one=>{cost=>'500',damage=>'1',description=>'Do not act incautiously when confronting little bald wrinkly smiling men!'},
time_slice=>{cost=>'200',damage=>'-1',description=>'He is a History Monk.... sort of'},
sweep=>{cost=>'1',damage=>'1',description=>'He is a Sweeper, after all.'},
broom_hit=>{cost=>'5',damage=>'20',description=>'Thwack!'},
deja_fu=>{cost=>'100',damage=>'1',description=>'Youre Already History'},
get_off_my_damn_lawn=>{cost=>'10',damage=>'1',description=>'Lowsy punks.'},
gum_bite=>{cost=>'10',damage=>'30',description=>'Eww'},



suicide=>{cost=>'0',damage=>'-1',description=>'self-kill'},
#althenas Sword Spell
white_dragon_protect=>{cost=>'100',damage=>'-1',description=>'Protects against one spell.'},
red_dragon_anger=>{cost=>'500',damage=>'10000',description=>'Massive fire attack',element=>'fire'},
blue_dragon_healing=>{cost=>'300',damage=>'-1',description=>'Fully heals party and dispells all status'},
black_dragon_grief=>{cost=>'600',damage=>'1',description=>'Kills enemies that have less than 10000 hp'},

#ultima
ultima=>{cost=>'500',damage=>'1500',description=>'its ULTIMA!'},
all_ultima=>{cost=>'1500',damage=>'1500',description=>'Ultima to ALL!'},

#final boss area
doppelgang=>{cost=>'0',damage=>'1',description=>'Im the real Zidane!'},
transform=>{cost=>'0',damage=>'1',description=>'Im the real Cosmic Dragon!'},

blue_shockwave=>{cost=>'600',damage=>'1',description=>'Down to One'},
fallen_one=>{cost=>'1500',damage=>'1',description=>'All Down to One'},
illness=>{cost=>'100',damage=>'1',description=>'Random Status Effect'},
grand_cross=>{cost=>'1000',damage=>'1',description=>'Get your Healers Ready to dispell'},
supernova=>{cost=>'1500',damage=>'1',description=>'Destroying the sun for fun and profit!',element=>'fire'},

#time mage
time_blip=>{cost=>'3',damage=>'1',description=>'Slight temporal delay'},
steal_time=>{cost=>'40',damage=>'1',description=>'Delay opponents and speed yourself'},
stop=>{cost=>'40',damage=>'1',description=>'Ha Ha You Cant Move!'},
slow=>{cost=>'30',damage=>'1',description=>'Taaakkkeeeee  aaaaa wwwwiiiilllldddd gueeesssssssssss'},
haste=>{cost=>'30',damage=>'-1',description=>'Gottagofastgottagogogogogogogogogofastfastfastwhee'},
quick=>{cost=>'20',damage=>'-1',description=>'Next turn comes quicker!'},
delay_action=>{cost=>'30',damage=>'1',description=>'10 more seconds, please'},

comet=>{cost=>'90',damage=>'1',description=>'Strange alien matter from SPACCEEE',element=>'dark'},
demi=>{cost=>'30',damage=>'1',description=>'Gravity Attack',element=>'dark'},
mini=>{cost=>'160',damage=>'1',description=>'Makes the enemy tiny'},
temporal_wave=>{cost=>'150',damage=>'1',description=>'Huge damage at the cost of time',element=>'energy'},
omega_blast=>{cost=>'600',damage=>'1',description=>'Itll kill you, but itll kill them too.'},
every_one=>{cost=>'77',damage=>'1',description=>'Randomly brings HP to 1 (better chance if your hp is high or enemy is low)'},


#sniper skills
aimshot=>{cost=>'2',damage=>'1',description=>'Ready... Aim.. Fire...'},
sureshot=>{cost=>'30',damage=>'1',description=>'Cant Miss'},
arm_aim=>{cost=>'20',damage=>'1',description=>'Weakened Attacks'},
seal_evil=>{cost=>'40',damage=>'100',description=>'Holy Bullets, Batman!',element=>'holy'},
leg_aim=>{cost=>'30',damage=>'1',description=>'Cant Move'},
headshot=>{cost=>'80',damage=>'1',description=>'All or nothing'},
ranged_shot=>{cost=>'40',damage=>'1',description=>'You Cant See Me!'},
machine_gun=>{cost=>'100',damage=>'1',description=>'Rapid Fire'},
phosphorous=>{cost=>'120',damage=>'1000',description=>'New meaning to the term Fire',element=>'fire'},
cannon=>{cost=>'300',damage=>'5000',description=>'Watch the kickback on that!'},

#paladin_spells
minus_strike=>{cost=>'6',damage=>'1',description=>'My Loss is Your Loss',element=>'holy'},
stasis_sword=>{cost=>'10',damage=>'1',description=>'Life is short!  Bury!  Steady sword!',element=>'ice'},
dash_and_slash=>{cost=>'6',damage=>'30',description=>'What do you think it does?'},
lightning_stab=>{cost=>'15',damage=>'1',description=>'Absorb power in the sky and strike!  Lightning Stab!', element=>'lit'},
atma=>{cost=>'6',damage=>'1',description=>'Ultima Weapon Attack',element=>'energy'},
blade_beam=>{cost=>'40',damage=>'300',description=>'Attack with a beam of energy',element=>'energy'},
night_sword=>{cost=>'60',damage=>'1',description=>'Master of all swords, cut energy!  Night Sword!',element=>'dark'},
climhazzard=>{cost=>'90',damage=>'600',description=>'Non-elemental sword attack'},
holy_explosion=>{cost=>'130',damage=>'1',description=>'Heavens wish to destroy all minds!  Holy explosion!',element=>'holy'},
crush_punch=>{cost=>'150',damage=>'1',description=>'The doom of a planet...Crush Punch!',element=>'dark'},
omnislash=>{cost=>'200',damage=>'1',description=>'Multiple hits'},

#slayer spells
goblin_punch=>{cost=>'8',damage=>'1',description=>'Imps are an unpredictable sort...',element=>'lit'},
jack_the_giant_killer=>{cost=>'90',damage=>'1',description=>'Many Electrocuted Giants, imps, ogres, and trolls mount an offensive',element=>'lit'},

slimesword=>{cost=>'1',damage=>'1',description=>'The ghosts of slimes', element=>'chem'},
slimebuster=>{cost=>'40',damage=>'1',description=>'Who you gonna call?  Slime busters!', element=>'chem'},

dragonkiller=>{cost=>'40',damage=>'1',description=>'Die Dragons Die', element=>'fire'},
dragonslayer=>{cost=>'130',damage=>'1',description=>'A true hero', element=>'fire'},

wolfsbite=>{cost=>'6',damage=>'1',description=>'Ice Wolf Howl', element=>'ice'},
wolfsbane=>{cost=>'65',damage=>'1',description=>'Silver Slivers', element=>'ice'},

canopener=>{cost=>'25', damage=>'1',description=>'Kitchen Helper',element=>'energy'},
cannerymaster=>{cost=>'100',damage=>'1',description=>'My dont we like risking our lives?', element=>'energy'},

demoneyes=>{cost=>'30',damage=>'1',description=>'Demonic Revenge', element=>'dark'},
demonking=>{cost=>'130',damage=>'1',description=>'Power of the Demons', element=>'dark'},

manslaughter=>{cost=>'50',damage=>'1',description=>'Cold Blooded Killer', element=>'holy'},
murder=>{cost=>'160',damage=>'1',description=>'Holy Judgement of the Fallen',element=>'holy'},

soul_sweep=>{cost=>'700',damage=>'1',description=>'Brand what you have wrought',element=>'holy and dark'},
soul_blast=>{cost=>'200',damage=>'1',description=>'The Souls of the Fallen',element=>'holy and dark'},

yellow_belly=>{cost=>'150',damage=>'1',description=>'You may never want to flee again',element=>'lit'},
better_safe_than_sorry=>{cost=>'50',damage=>'-1',description=>'Youve become good at staying alive, havent you?'},

#Holy Knight spells


#The Summon-Only Leage
ultimate_end=>{cost=>'4000',damage=>'1',description=>'Like in FF7'},
diamond_dust=>{cost=>'35',damage=>'200',description=>'Snap of the fingers',element=>'ice'},
hell_fire=>{cost=>'60',damage=>'400',description=>'Ever play Final Fantasy?',element=>'fire'},
mega_flare=>{cost=>'999',damage=>'9999',description=>'Behold the king of dragons', element=>'energy'},
judgement_bolt=>{cost=>'75',damage=>'500',description=>'Simply shocking',element=>'lit'},
dark_messenger=>{cost=>'50',damage=>'1',description=>'Gravity Blast'},
holy_judgement=>{cost=>'150',damage=>'1000',description=>'The best attack a castle can fire',element=>'holy'},


#Status
dark_blade_nexrel=>{cost=>'100',damage=>'-1',description=>'Brandishes the Dark Blade Nexrel'},
blunt=>{cost=>'40',damage=>'1',description=>'A weak enemy is a good enemy'},
damage_double=>{cost=>'40',damage=>'-1',description=>'Wow, strong arent we'},
mpshield=>{cost=>'30',damage=>'-1',description=>'Channeling damage for Dummies'},
poison=>{cost=>'30',damage=>'0',description=>'I dont feel so good', element=>'green'},
regen=>{cost=>'30',damage=>'-1',description=>'Hey, free life, thats good, right?'},
slow_burn=>{cost=>'200',damage=>'0',description=>'FIRE!!!!!!!! RUN!!!!'},
steal_armor=>{cost=>'100',damage=>'0',description=>'Hey, thats pretty shiny, mind if I take it?'},
mind_regen=>{cost=>'50',damage=>'-1',description=>'Concentrate.. concentrate...'},
defence_down=>{cost=>'30',damage=>'1',description=>'Hit them now! NOW!'},
dance_of_the_sacred_spirits=>{cost=>'45',damage=>'-1',description=>'Unga Bunga'},
protect=>{cost=>'30',damage=>'-1',description=>'You cant harm me!  Well, maybe a little'},
return_damage=>{cost=>'100',damage=>'-1',description=>'What goes around comes around'},
freeze=>{cost=>'20',damage=>'1',description=>'Is it chilly in here?'},
spraypaint=>{cost=>'25',damage=>'0',description=>'All the colours of the rainbow'},
red_paint=>{cost=>'15',damage=>'-1',description=>'Its amazing what a little red paint can do'},
dispell=>{cost=>'25',damage=>'-1',description=>'I hate status effects, dont you?'},
element_reel=>{cost=>'30',damage=>'1', description=>'Where she stops, nobody knows!'},


#special
ogre_wrath=>{cost=>'100',damage=>'1', description=>'How dare you slaughter my people!?'},
eternal_rage=>{cost=>'7',damage=>'1', description=>'Eternion does one of his attacks'},
grudge=>{cost=>'42',damage=>'1', description=>'What goes around comes around'},
inexperienced_spellcaster=>{cost=>'50',damage=>'1', description=>'I dont know what this is gonna do'},
snowstorm=>{cost=>'10',dammage=>'1',description=>'BRR'},
lick=>{cost=>'1',damage=>'-1',description=>'MMM!  Tasty!'},
bloodsuck=>{cost=>'150',damage=>'0',description=>'The best spell.. OF VAMPIRES'},
#ultimate_end=>{cost=>'4000',damage=>'0',description=>'Like in FF7'},
heal_you=>{cost=>'1',damage=>'0',description=>'So hows the patient?'},
vertigo=>{cost=>'25',damage=>'0',description=>'Dont Look Down'},
meditate=>{cost=>'150',damage=>'0',description=>'Heal Thyself'},
mind_drain=>{cost=>'1',damage=>'0',description=>'Think, stupid'},
mind_blast=>{cost=>'30',damage=>'0',description=>'Cant... concentrate..'},
gravity_bomb=>{cost=>'75',damage=>'0',description=>'Sometimes half is better than whole.'},
cursing=>{cost=>'0',damage=>'0',description=>'Being cursed sucks.'},

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

#elemental spells.
ice=>{cost=>'10',damage=>'30',description=>'Freeze your enemies.', element=>'ice'},
iceshard=>{cost=>'35',damage=>'150',description=>'Multiple shards of ice', element=>'ice'},
iceblast=>{cost=>'100',damage=>'300',description=>'Now thats just cold', element=>'ice'},
absolute_zero=>{cost=>'300',damage=>'3000',description=>'Cant get much colder',element=>'ice'},
ice_breath=>{cost=>'50',damage=>'120',description=>'A ice dragon\'s breath weapon.', element=>'ice'},
steal_heat=>{cost=>'10',damage=>'70',description=>'It suddenly got colder',element=>'ice'},

gas=>{cost=>'12',damage=>'40',description=>'An unbreathable cloud.', element=>'chem'},
really_bad_breath=>{cost=>'10',damage=>'80',description=>'An unhygienic dragon\'s breath weapon.', element=>'chem'},
poison_breath=>{cost=>'30',damage=>'100',description=>'A poison dragon\'s breath weapon.', element=>'chem'},
acid_shower=>{cost=>'15',damage=>'50',description=>'Ouch.', element=>'chem'},
acid_spray=>{cost=>'20',damage=>'100',description=>'Double ouch.', element=>'chem'},
acid_bomb=>{cost=>'30',damage=>'200',description=>'I want to see goggles, people!',element=>'chem'},
poison_dart=>{cost=>'40',damage=>'200',description=>'Now with 10% more poisony goodness!',element=>'chem'},


pulse_wave=>{cost=>'500',damage=>'5000',description=>'Waves of psionic energy and a huge explosion', element=>'energy'},
zapper=>{cost=>'20',damage=>'100',description=>'Duck Hunt Et All', elem=>'energy'},

shadow_breath=>{cost=>'50',damage=>'400',description=>'A death dragon\'s breath weapon.', element=>'dark'},

pyrokinesis=>{cost=>'50',damage=>'125',description=>'Hot hot HOT!', element=>'fire'},
flare=>{cost=>'5',damage=>'20',description=>'A flash of flame.', element=>'fire'},
fireball=>{cost=>'15',damage=>'50',description=>'A fireball spell.', element=>'fire'},
fireblast=>{cost=>'100',damage=>'300',description=>'Massively powerful fire attack', element=>'fire'},
inferno=>{cost=>'400',damage=>'2000',description=>'Firey Death', element=>'fire'},
fire_breath=>{cost=>'50',damage=>'200',description=>'A fire dragon\'s breath weapon.', element=>'fire'},
flame_dragon_sword=>{cost=>'40',damage=>'200',description=>'Hot under the collar',element=>'fire'},
explode=>{cost=>'100',damage=>'1',description=>'BOOM!',element=>'fire'},

void_thunder=>{cost=>'9000',damage=>'1',description=>'Ultimate Destructive Magic... VOID THUNDER!',element=>'lit'},
spark=>{cost=>'7',damage=>'20',description=>'An electric shock.', element=>'lit'},
lightning=>{cost=>'50',damage=>'100',description=>'A lightning bolt.', element=>'lit'},
shock=>{cost=>'25',damage=>'50',description=>'A powerful electric attack',element=>'lit'},
storm=>{cost=>'300', damage=>'1500',description=>'Incredibly powerful lightning storm',element=>'lit'},
hurl_thunderbolt=>{cost=>'1000',damage=>'10000',description=>'Zeus does this.  It hurts.', element=>'lit'},


wound=>{cost=>'20',damage=>'40',description=>'A false healing.', element=>'holy'},
smite=>{cost=>'300',damage=>'5000',description=>'Now you`re fucked.', element=>'holy'},
holy_wrath=>{cost=>'1000',damage=>'10000',description=>'God is pissed.', element=>'holy'},
negate=>{cost=>'500',damage=>'4000',description=>'The ultimate betrayal of the healer\'s art.', element=>'holy'},
damn=>{cost=>'100',damage=>'300',description=>'Ooh, that is a bit harsh.', element=>'holy'},
judgement_day=>{cost=>'1000',damage=>'10000',description=>'It\'s your own damn fault.', element=>'holy'},


finite=>{cost=>'20',damage=>'200',description=>'Melody of finite.', element=>'finite'},


darkness=>{cost=>'20',damage=>'40',description=>'Demon Attack', element=>'dark'},
termination_beam=>{cost=>'500',damage=>'3000',description=>'Ter..min..at..ion...BEAM!!!',element=>'dark'},
gravity_smash=>{cost=>'60',damage=>1,description=>'Weaken the infidels!',element=>'dark'},
fissure=>{cost=>'400',damage=>'3500',description=>'Split the earth beneath your opponents feet.',element=>'dark'},
unholy=>{cost=>'150',damage=>'500',description=>'An unholy life drain.', element=>'dark'},
devilish=>{cost=>'160',damage=>'600',description=>'An Attack upon the soul.', element=>'dark'},
#normal



paper_or_plastic=>{cost=>'30',damage=>'100',description=>'Better to use one of those re-usable cloth bags'},
sam_the_record_man=>{cost=>'40',damage=>'0',description=>'They sell music.'},
attention_shoppers=>{cost=>'200',damage=>'0',description=>'Blue light special in isle 5'},
on_sale=>{cost=>'50',damage=>'-1000',description=>'Sales are good for everyone!  Except you.'},

telekinesis=>{cost=>'150',damage=>'500',description=>'Pick em up and throw em down'},

chocobo_kick=>{cost=>'10',damage=>'30',description=>'WARK.. Kweh..'},
lame=>{cost=>'1',damage=>'1',description=>'A lame attack.'},
duh=>{cost=>'1',damage=>'1',description=>'A stupid attack.'},
happy_dance=>{cost=>'1',damage=>'-10',description=>'What?  You need a reason?'},
song=>{cost=>'1',damage=>'12',description=>'Play some music.'},
tansu_dance=>{cost=>'5',damage=>'20',description=>'A vigorous dance involving throwing an excessively heavy chest of drawers.'},
skank_kiss=>{cost=>'10',damage=>'20',description=>'I\'d rather not...'},
#shuriken=>{cost=>'4',damage=>'35',description=>'Little pointy things, lots of them.'},
throw=>{cost=>'4',damage=>'24',description=>'It\'s all fun and games until someone loses an eye.'},
harmony=>{cost=>'5',damage=>'-25',description=>'Soothing to the ears.'},
cure=>{cost=>'5',damage=>'-30',description=>'Cure minor wounds.'},

spoony=>{cost=>'10',damage=>'50',description=>'You spoony bard!'},

candy_beam=>{cost=>'10',damage=>'50',description=>'A beam made entirely of candy!'},
pound=>{cost=>'30',damage=>'80',description=>'Thump, thump!'},
heal=>{cost=>'10',damage=>'-100',description=>'A spell of healing.'},
kiss=>{cost=>'10',damage=>'-100',description=>'Kiss it better.'},
sword_dance=>{cost=>'40',damage=>'100',description=>'One of the more violent dances.'},

sue=>{cost=>'15',damage=>'100',description=>'He\'s after blood.',element=>'dark'},
top_cut=>{cost=>'24',damage=>'140',description=>'Instant critical.'},
backstab=>{cost=>'24',damage=>'120',description=>'Extra painful.'},
shadow_strike=>{cost=>'36',damage=>'140',description=>'Strike from concealment.'},
mug=>{cost=>'36',damage=>'120',description=>'A purely visual joke.'},
kick=>{cost=>'60',damage=>'160',description=>'ACHOOOOO!'},
fighter_doken=>{cost=>'75',damage=>"200",description=>'Two-fisted monkey style.'},
whup_ass=>{cost=>'70',damage=>'200',description=>'A mighty whupping indeed!'},
hag_kiss=>{cost=>'10',damage=>'200',description=>'Ewwww.'},
stomp=>{cost=>'100',damage=>'200',description=>'Squish!'},


regenerate=>{cost=>'50',damage=>'-400',description=>'Supernatural healing.'},
danse_macabre=>{cost=>'100',damage=>'400',description=>'The part that really hurts is that wierd violin solo.'},

ethereal_blade=>{cost=>'150',damage=>'1000',description=>'Oooh... haunted cutlery.',element=>'energy'},

instill=>{cost=>'75',damage=>'-750',description=>'Healing the hard way.'},
rock_and_roll=>{cost=>'80',damage=>'750',description=>'the devil music.'},
sneak_attack=>{cost=>'180',damage=>'800',description=>'come out of nowhere.'},
plunder=>{cost=>'250',damage=>'2000',description=>'they have much less then they had.'},
cherry_blossom=>{cost=>300,damage=>'1',description=>'Firey like the dragons breath, Cold like the killers heart, lightning like the speed of reaction, and dark like the shadows that secure you.',elem=>'fire, ice, lit, and dark'},
meteo=>{cost=>'400',damage=>'3000',description=>'Open the Heavens!  Break the Earth!'},
revive=>{cost=>'100',damage=>'-4000',description=>'A spell of supreme healing.'},

magic_missile=>{cost=>'600',damage=>'5000',description=>'a beam of light that always finds it\'s mark.'},
flood_the_earth=>{cost=>'1000',damage=>'10000',description=>'No rainbow today.'},

breath_weapon_barrage=>{cost=>'5000',damage=>'50000',description=>'So \2that\2 is what happens when a whole swarm of dragons breath at the same time.'},
dragon_slave=>{cost=>'6000',damage=>'1000000',description=>'Now that\'s just excessive.'},
);

print "Loading special spells...";

%special_spells=(
second_wind=>sub {my ($caster, $target)=@_;
	cause_damage($caster, $caster, -10000);
	mp_damage($caster,$caster,-10000);
	say("$caster gets a second wind!");
	return 1;
},
throw_gold=>sub {my ($caster, $target)=@_;
		my $attacker = $caster;
		my $gold = $characters{$attacker}->{gold};
		my $dam = int(rand($gold / 4));
		$characters{$attacker}->{gold} = $characters{$attacker}->{gold} - $dam;
		say ("\2$attacker\2 throws $dam gold at \2$target\2!");
		cause_damage($caster, $target, $dam/2, 'gold');
		return 1;
},

fix_gold=>sub {my ($caster, $target)=@_;
	$characters{$caster}->{gold} = int($characters{$caster}->{gold});
	return 1;
},
steal_item=>sub {my ($caster, $target)=@_;
		if ($target ne 'monster') {
			say("You shouldnt steal from other players, you know. . .");
		}
		else{ if(exists $drops{$characters{$target}->{class}}) {
			if (rand(5) > 2) {
			my $drop = drop_choice($characters{$target}->{class});
			if (!($drop eq 'none'))
			{
				say("Stole a \2$drop\2!!");
				$inv{$caster}->{$drop} = $inv{$caster}->{$drop} + 1;
			}else{
				say("Nothing stolen");
			}
		} else {
			say("The pickpocket attempt fails and \2$target\2 strikes \2$caster\2!!" );
			attack_free($target,$caster);


		}


		}else{say("Nothing to steal!");}
		}
	return 1;
},
steal_gold=>sub {my ($caster, $target)=@_;
	if ($target ne 'monster') {
			say("You shouldnt steal from  players, you know. . .");
		} else {
	my $gold = gold_value($target);
	$gold = int( rand($gold) /5);
	say ("Stole \2$gold\2 gold!");

	$characters{$caster}->{gold} += $gold;
		}
	return 1;
		
		
},

get_off_my_damn_lawn=>sub {my ($caster, $target)=@_;
	if($target ne 'monster'){

		say("$target gets off his damn lawn!");

		$characters{$target}->{isresting}=1;
		$conn_self->mode($channel,"-v",$target);
		$characters{$target}->{delay}=time()+60;
		delete $present{lc($target)};
		delete $concealed{lc($target)};
	}
	return 1;
},

sweep=> sub{my ($caster, $target)=@_;
	say("$caster sweeps the floor.");
	return 0;
},
time_slice=> sub{my ($caster, $target)=@_;
	say("$caster slices time and gets two more actions!");
	delay($caster,-20);
	monster_action();
	delay($caster,-20);
	monster_action();
	return 1;
},
always_remember_Rule_One=> sub{my ($caster, $target)=@_;
	say("You never heard of Rule One?");
	cast($caster,'deja_fu',$target);
	return 1;
},
deja_fu=> sub{my ($caster, $target)=@_;
	attack_free($caster,$target);
	attack_free($caster,$target);
	delay($target,15);
	say("$target cant move for 15 seconds!");
	return 1;
},
suicide=> sub {my ($caster, $target)=@_;
	cause_damage($caster,$caster,10000000,'none');
	return 1;
},
explode=>sub {my ($caster,$target)=@_; 
	cause_damage($caster,$target,$characters{$caster}->{hp}*2,'fire');
	$characters{$caster}->{hp} = 0;
	return 1;
},
white_dragon_protect=>sub {my ($caster,$target)=@_; 
	multi_effect_help($caster, 'white_dragon_protect', $target);
	return 1;
},
blue_dragon_healing=>sub {my ($caster, $target) = @_;
	multi_effect_help($caster, 'blue_dragon_healing', $target);
	return 0;
},
black_dragon_grief=>sub {my ($caster, $target) = @_;
	if( $characters{$target}->{maxhp} < 10000 ) {
		say("\2$target\2 is sucked into a vortex by the power of the black dragon!");
		$characters{$target}->{hp} = 0;
	}else{ say("\2$target\2 is too strong, and is not affected by Black Dragon Grief!"); }
	return 1;
},
doppelgang=>sub {my ($caster, $target)=@_; #Turns perminently to a copy of $target
		my $mimic = $caster;
		my $subject = $target;
		say("$caster becomes a copy of $target!");
		$characters{$mimic}->{level}=$characters{$subject}->{level};
		$characters{$mimic}->{class}=$characters{$subject}->{class};
		$characters{$mimic}->{mp}=$characters{$subject}->{mp};
		$characters{$mimic}->{maxmp}=$characters{$subject}->{maxmp};
		$characters{$mimic}->{gold}=$characters{$subject}->{gold};
		$characters{$mimic}->{hp}=$characters{$subject}->{hp};
		$characters{$mimic}->{maxhp}=$characters{$subject}->{maxhp};
		$characters{$mimic}->{weapon}=$characters{$subject}->{weapon};
		$characters{$mimic}->{xp}=$characters{$subject}->{xp};
		$characters{$mimic}->{doppelganger}=$target;
		status($mimic);
		delay($mimic,-10);
		monster_action();
},
transform=>sub {my ($caster, $target)=@_; #turns into a random monster
		my $mimic = $caster;
		my @classarray = get_classes();
		my $choice=int(rand(scalar(@classarray)));
		my $subject = @classarray[$choice];
		say("$caster becomes a level 1 $subject!");
		$characters{$mimic}->{level}=1;
		$characters{$mimic}->{class}=$subject;
		$characters{$mimic}->{mp}=$classes{$subject}->{mp};
		$characters{$mimic}->{maxmp}=$classes{$subject}->{mp};
		$characters{$mimic}->{hp}=$classes{$subject}->{hp};
		$characters{$mimic}->{maxhp}=$classes{$subject}->{hp};
		$characters{$mimic}->{xp}=0;
		learned($caster, $subject);
		status($mimic);
},
auto_tin=>sub {my ($caster,$target)=@_; #tins enemy and flees
	say("The \2auto_tinner\2 tins \2$target\2 and leaves!");
	delete $characters{$target};
	delete $characters{$caster};
	$conn_self->mode($channel,"-v",$target);
	new_character('monster','ominous_can','impossible!ID@!@!@');
},
demi=>sub {my ($caster, $target)=@_; #.40 of HP damage
        $demi=$characters{$target}->{hp} * .40;
        cause_damage_nostatus($caster,$target,$demi, 'dark');
        return 1;
},
comet=>sub {my ($caster, $target)=@_; #does HP/MP damage bsaed on percentages of hp and mp
        $demi1 = $characters{$target}->{hp} * .20;

		$demi2 = $characters{$target}->{mp} * .20;
		my $demi3 =  sqrt($demi1*$demi2);
		if ($demi3 > 300000) {
			$demi3 = 300000;
		}
        cause_damage_nostatus($caster,$target,$demi3, 'dark');
		mp_damage($caster,$target,$demi3);
        return 1;
},
delay_action=>sub { my ($caster,$target)=@_; # 10 second delay, like a freeze spell but it's always 10 seconds, reliably and it compounds.
	delay($target,10);
	say("$target" . "'s movement is delayed!");
},
steal_time=>sub { my ($caster,$target)=@_; # 5 second delay, 5 seocnd undelay
	delay($target,5);
	delay($caster,-5);
	say("$target loses time while $caster gains it!");
},
every_one=>sub {my ($caster,$target)=@_;#randomly brings people to 1 hp
	#multi_effect($caster, 'every_one', $caster);
	if (rand($characters{$caster}->{hp} * 10) >= rand($characters{$target}->{hp} /10)) {
		say("$target"."'s HP are reduced to one!");
		$characters{$target}->{hp} = 1;


	} else {
		say("But the effect fails on $target!");
	}
	$characters{$caster}->{hp} = 1;
	say("$caster"."'s HP are reduced to one!");

	return 0;
},
fallen_one=>sub {my ($caster,$target)=@_; #all good targets to 1 hp
	multi_effect($caster, 'fallen_one',$target);
	return 0;
},
grand_cross=>sub {my ($caster,$target)=@_; #all good targets damage and status effects
	multi_effect($caster, 'grand_cross',$target);
	return 0;
},
illness=>sub {my ($caster,$target)=@_; #random status effect!
	my  $status = rand_el('poison','slow_burn','death_sentance','slow','blunt','weak_bodied' , 'none');
	if (!($status eq 'none')){
		$characters{$target}->{seffect} = $status;
		$characters{$target}->{sefftime} = 8;
		$characters{$target}->{seffname} = $caster;
		say("$target" . "'s is afflicted with status effect $status!");
	}else{
		say("$target gets no status effect!");
	}		
	return 0;
},
supernova=>sub {my ($caster,$target)=@_; #Fire damage to all
	multi_effect($caster, 'supernova', $target);
	return 0;
},
all_ultima=>sub {my ($caster,$target)=@_; #Ultima to all targets
	multi_effect($caster, 'all_ultima', $target);
	return 0;
},
blue_shockwave=>sub {my ($caster,$target)=@_; #one hp to one

		$characters{$target}->{hp} = 1;
		say("$target" . "'s HP are reduced to one!");

	return 1;
},
time_blip=>sub { my ($caster,$target)=@_; #tiny time delay
	delay($target,2);
	say("$target" . "'s movement is slightly delayed!");
},
quick=>sub { my ($caster,$target)=@_; #removes time delay
	delay($target,-10);
	say("\2$target\2's next action will come sooner!");
},

omega_blast=>sub {my ($caster, $target)=@_; #does huge damage to you and the target
    my $damage = $characters{$caster}->{hp} * 100;
	cause_damage($caster,$target,$damage,'none');
	characters{$caster}->{hp} = 0;
	return 1;
},
temporal_wave=>sub {my ($caster, $target)=@_; #takes time away, does damage
	my $time = rand(20);
	say("$caster is delayed for $time seconds in order to launch a temporal wave!");
	cause_damage($caster,$target,$time*100,'energy');
	delay($caster,$time);
	return 1;
},
mini=>sub {my ($caster, $target)=@_; #effects "mini"
	$characters{$target}->{seffect} = "mini";
	$characters{$target}->{sefftime} = "10"; # 10 turns
	say("\2$target\2 is now tiny!");
	return 0;
	
},
cherry_blossom=>sub { my ($caster, $target)=@_; #four element damage
	cause_damage($caster,$target,1100, 'fire');
	cause_damage($caster,$target,1100, 'ice');
	cause_damage($caster,$target,1100, 'lit');
	cause_damage($caster,$target,1100, 'dark');
	return 1;
},
ranged_shot=>sub {my ($caster, $target)=@_;
	if(exists $characters{$target}){
		cause_damage($caster,$target,200, 'none');
	}
	if(int(rand(5))==1){
		say("\2$caster\2's reveals his position!");
	}else{
		delete $present{lc($caster)};
		$concealed{lc($caster)}=1;
	}
	return 1;
},
slow=>sub {my ($caster, $target)=@_;
	$characters{$target}->{seffect} = "slow";
	$characters{$target}->{sefftime} = "6"; # 5 turns
	say("\2$target\2 is now at half speed!");
	return 0;
	
},
haste=>sub {my ($caster, $target)=@_;
	$characters{$target}->{seffect} = "haste";
	$characters{$target}->{sefftime} = "6"; # 5 turns
	say("\2$target\2 is now at double speed!");
	return 0;
	
},
stop=>sub {my ($caster, $target)=@_;
	my $time=int(rand(50)+1);
	if($characters{$target}->{delay} < (time()+9)){
		$characters{$target}->{delay}=time()+$time;
		say("\2$target\2 is frozen in time for \2$time\2 seconds!");
	}else{
		$characters{$target}->{delay}+=$time;
		my $totaldelay=$characters{$target}->{delay}-time();
		if($totaldelay>70){
			$characters{$target}->{delay}=time();
			say("\2target\2's temporal stability is restored!");
		}else{
			say("\2$target\2 is temporally frozen for \2$time\2 more seconds!");
		}
	}
	return 0;
},
leg_aim=>sub {my ($caster, $target)=@_;
	my $time=int(rand(40)+1);
	if($characters{$target}->{delay} < (time()+9)){
		$characters{$target}->{delay}=time()+$time;
		say("\2$target\2 cant move his legs for \2$time\2 seconds!");
	}else{
		$characters{$target}->{delay}+=$time;
		my $totaldelay=$characters{$target}->{delay}-time();
		if($totaldelay>70){
			$characters{$target}->{delay}=time();
			say("\2target\2's legs are jolted back into working order!");
		}else{
			say("\2$target\2's legs are hurt for \2$time\2 more seconds!");
		}
	}
	return 0;
},
cannon=>sub {my ($caster, $target)=@_;
	cause_damage($caster,$target,7000, 'none');
	cause_damage($caster,$caster,300,'none');
	#cause_damage($caster,rand_el($characters),100,'none');

return 1;
},
machine_gun=>sub {my ($caster, $target)=@_;
	cause_damage($caster,$target,400, 'none');
	cause_damage($caster,$target,400, 'none');
	cause_damage($caster,$target,400, 'none');
	cause_damage($caster,$target,400, 'none');

return 1;
},
headshot=>sub {my ($caster, $target)=@_;
	if (rand($characters{$target}->{maxhp})*3 < rand($characters{$caster}->{level})) {
		$characters{$target}->{hp} = 0;

	}else{
	say("$caster misses his mark!");
	}
	
	
	return 1;
},
aimshot=>sub {my ($caster, $target)=@_;
	cause_damage($caster,$target,$classes{$characters{$caster}->{class}}->{damage}*$characters{$caster}->{level}/1.5, 'none');

	return 1;
},
sureshot=>sub {my ($caster, $target)=@_;
	cause_damage($caster,$target,$classes{$characters{$caster}->{class}}->{damage}*$characters{$caster}->{level}*2, 'none');

	return 1;
},
arm_aim=>sub {my ($caster, $target) = @_;         # halvesdamage - webrunner
	$characters{$target}->{seffect} = "damage/2";
	$characters{$target}->{sefftime} = "4"; # 5 turns
	say("\2$target\2 is now weakened");
	return 0;
	
},
night_sword=>sub {my ($caster, $target)=@_;
	cause_damage($caster,$target,300, 'dark');
	cause_damage($target,$caster,-300, 'none');
	return 1;
},
minus_strike=>sub { my ($caster, $target)=@_;
	my $damage = ( $characters{$caster}->{maxhp} - $characters{$caster}->{hp});
	mp_damage('minus_strike',$caster,$characters{$caster}->{level});
	cause_damage($caster,$target,$damage,'holy');
	return 1;
},
atma=>sub { my ($caster, $target)=@_;
	my $damage =$characters{$caster}->{hp};
	mp_damage('atma',$caster,$characters{$caster}->{level});
	cause_damage($caster,$target,$damage,'energy');
	return 1;
},
holy_explosion=>sub {my ($caster, $target)=@_;
	cause_damage($caster,$target,500,'holy');
	if(rand($characters{$target}->{hp}) < rand($characters{$caster}->{hp}))
	{
	my $time=int(rand(100)+1);
	if($characters{$target}->{delay} < (time()+9)){
		$characters{$target}->{delay}=time()+$time;
		say("\2$target\2 is mentally unstable for \2$time\2 seconds!");
	}else{
		$characters{$target}->{delay}+=$time;
			say("\2$target\2's remains crazy for \2$time\2 more seconds!");
	}
	}
	return 1;
},
crush_punch=>sub {my ($caster, $target)=@_;
	cause_damage($caster,$target,100,'dark');
	if(rand($characters{$target}->{hp}) < rand($characters{$caster}->{level}))
	{
		$characters{$target}->{hp} = 0;
		
	}
	return 1;
},
omnislash=>sub {my ($caster, $target)=@_;
	attack_free($caster,$target);
	attack_free($caster,$target);
	attack_free($caster,$target);
	attack_free($caster,$target);
	attack_free($caster,$target);


	return 1;
},
stasis_sword=>sub {my ($caster, $target)=@_;
	cause_damage($caster,$target,35,'ice');
	if(rand($characters{$target}->{hp}) < rand($characters{$caster}->{hp}))
	{
	my $time=int(rand(50)+1);
	if($characters{$target}->{delay} < (time()+9)){
		$characters{$target}->{delay}=time()+$time;
		say("\2$target\2 is frozen for \2$time\2 seconds!");
	}else{
		$characters{$target}->{delay}+=$time;
			say("\2$target\2's icy prison is reinforced for \2$time\2 more seconds!");
	}
	}
	return 1;
},
lightning_stab=>sub {my ($caster, $target)=@_;
	cause_damage($caster,$target,60,'lit');
	if(rand($characters{$target}->{hp}) < rand($characters{$caster}->{hp}))
	{
		mp_damage($caster,$target,99999);
	}
	return 1;
},
eternal_rage=>sub { my ($caster, $target)=@_;
	my $spell = rand_el('void_thunder','termination_beam','nexrel');
	if ($spell eq 'nexrel') {
		$target = $caster;
	}
	free_cast($caster, $spell, $target);
	return 1;
},
grudge=>sub { my ($caster, $target)=@_;
	my $damage = net_grudge() * 2;
	cause_damage($caster,$target,$damage,'none');
	return 1;
},
goblin_punch=>sub { my ($caster, $target)=@_;
	my $damage = $goblinslayer * rand($characters{$caster}->{level});
	if ($damage > 500) { $damage = 500;}
	cause_damage($caster,$target,$damage,'none');
	return 1;
},
jack_the_giant_killer=>sub { my ($caster, $target)=@_;
	my $damage = $goblinslayer  * 36;
	if ($damage > 3000) { $damage = 3000;
	}
	cause_damage($caster,$target,$damage,'none');
	return 1;
},

ogre_wrath=>sub { my ($caster, $target)=@_;
	my $damage = $goblinslayer * 3;
	if ($damage > 50) { $damage = 50;
	}
	cause_damage($caster,$target,$damage,'none');
	return 1;
},
slimesword=>sub { my ($caster, $target)=@_;
	
	my $damage = $slimeslayer;
	
	if ($damage > 500) { $damage = 500;}
	cause_damage($caster,$target,$damage,'chem');
	return 1;
},
wolfsbite=>sub { my ($caster, $target)=@_;
	my $damage = $wolfslayer / 2 * 3;
	if ($damage > 500) { $damage = 500;}
	cause_damage($caster,$target,$damage,'ice');
	return 1;
},
canopener=>sub { my ($caster, $target)=@_;
	my $damage = $canslayer * 1.1 * 3;
	if ($damage > 500) { $damage = 500;}
	cause_damage($caster,$target,$damage,'energy');
	return 1;
},
demoneyes=>sub { my ($caster, $target)=@_;
	my $damage = $demonslayer * 2 * 3;
	if ($damage > 500) { $damage = 500;}
	cause_damage($caster,$target,$damage,'dark');
	return 1;
},
dragonkiller=>sub { my ($caster, $target)=@_;
	my $damage = $dragonslayer * 3.5 * 3;
	if ($damage > 500) { $damage = 500;}
	cause_damage($caster,$target,$damage,'fire');
	return 1;
},
manslaughter=>sub { my ($caster, $target)=@_;
	my $damage = $manslayer * 4 * 3;
	if ($damage > 500) { $damage = 500;}
	cause_damage($caster,$target,$damage,'holy');
	return 1;
},
slimebuster=>sub { my ($caster, $target)=@_;
	my $damage = $slimeslayer * 5 * 3;
	if ($damage > 3000) { $damage = 3000;}
	cause_damage($caster,$target,$damage,'chem');
	return 1;
},
wolfsbane=>sub { my ($caster, $target)=@_;
	my $damage = $wolfslayer * 7 * 3;
		if ($damage > 3000) { $damage = 3000;}
	cause_damage($caster,$target,$damage,'ice');
	return 1;
},
cannerymaster=>sub { my ($caster, $target)=@_;
	my $damage = $canslayer * 10 * 3;
		if ($damage > 3000) { $damage = 3000;}
	cause_damage($caster,$target,$damage,'energy');
	return 1;
},
demonking=>sub { my ($caster, $target)=@_;
	my $damage = $demonslayer * 13 * 3;
		if ($damage > 3000) { $damage = 3000;}
	cause_damage($caster,$target,$damage,'dark');
	return 1;
},
dragonslayer=>sub { my ($caster, $target)=@_;
	my $damage = $dragonslayer * 15 * 3;
		if ($damage > 3000) { $damage = 3000;}
	cause_damage($caster,$target,$damage,'fire');
	return 1;
},
murder=>sub { my ($caster, $target)=@_;
	my $damage = $manslayer * 20 * 3;
		if ($damage > 3000) { $damage = 3000;}
	cause_damage($caster,$target,$damage,'holy');
	return 1;
},

soul_blast=>sub { my ($caster, $target)=@_;
	my $damage = net_grudge() * 2;
		if ($damage > 500) { $damage = 500;}
	cause_damage($caster,$target,$damage,'holy');
	cause_damage($caster,$target,$damage,'dark');
	return 1;
},


soul_sweep=>sub { my ($caster, $target)=@_;
	my $damage = net_grudge() * 40;
		if ($damage > 1000) { $damage = 1000;}
	cause_damage($caster,$target,$damage,'holy');
	cause_damage($caster,$target,$damage,'dark');

	return 1;
},

dark_blade_nexrel=>sub {my ($caster, $target) = @_;         # Heals a little bit for 10 turns.
	$characters{$target}->{seffect} = "nexrel";
	$characters{$target}->{sefftime} = "20"; # 15 turns
	say("\2$target\2 brandishes the Dark Blade Nexrel!");
	return 0;
	
},
void_thunder=>sub {my ($caster, $target)=@_;
	say("<Eternion> Ultimate Destructive Magic... VOID THUNDER!");
    multi_effect($caster, 'void_thunder', $target);
	return 0;
},
snowstorm=>sub {my ($caster, $target)=@_;
		 multi_effect($caster, 'snowstorm', $target);
	return 0;
},
dispell=>sub {my ($caster, $target) = @_;         #  makes status go away
	$characters{$target}->{sefftime} = "0"; # three turns
	$characters{$target}->{seffect}  = "none";
	say("\2$target\2's status effect is dispelled!");
	return 0;
	
},
freeze=>sub {my ($caster, $target)=@_;
	my $time=int(rand(50)+1);
	if($characters{$target}->{delay} < (time()+9)){
		$characters{$target}->{delay}=time()+$time;
		say("\2$target\2 is frozen in a block of ice for \2$time\2 seconds!");
	}else{
		$characters{$target}->{delay}+=$time;
		my $totaldelay=$characters{$target}->{delay}-time();
		if($totaldelay>70){
			$characters{$target}->{delay}=time();
			say("The ice cracks!  \2target\2 can move again!!");
		}else{
			say("\2$target\2's icy prison is reinforced for \2$time\2 more seconds!");
		}
	}
	return 0;
},

spraypaint=>sub {my ($caster, $target)=@_;
	my $choice=rand_el('red','blue','yellow','octarine','plaid','purple','white','orange', 'gold', 'black', 'green');
	say ("\2$target\2 is now coloured \2$choice\2!");
	$characters{$target}->{seffect} = $choice;
	$characters{$target}->{sefftime} = "7"; # three turns
	
return 0
},
element_reel=>sub {my ($caster, $target)=@_;
	my $choice=rand_el('red','blue','yellow', 'red','blue','yellow','octarine','plaid','purple','white','orange', 'white', 'gold', 'gold', 'black', 'green');
	say ("\2$target\2 is now \2$choice\2! for four turns!");
	$characters{$target}->{seffect} = $choice;
	$characters{$target}->{sefftime} = "4"; # three turns
	
return 0
},
inexperienced_spellcaster=>sub {my ($caster, $target)=@_;
	say ("\2$caster\2 tries to weave a black magic spell....");

	my $choice=rand_el('fire', 'ice', 'holy', 'dark', 'energy', 'chem', 'lit');
	my $damage=rand_el('1', '20', '-100', '100', '0', '500', '10000', '40', '50', '-9999', '-1', '30', '1337', '-99','42');
	say ("Spell type: \2$choice\2 Damage=\2$damage\2");
	cause_damage($caster,$target,$damage,$choice);
	
return 1
},
red_paint=>sub {my ($caster, $target)=@_;
	my $choice='red';
	say ("\2$target\2 is now coloured \2$choice\2!");
	$characters{$target}->{seffect} = $choice;
	$characters{$target}->{sefftime} = "7"; # three turns
	
return 0
},
lick=>sub {my ($caster, $target)=@_;
	my $choice=rand_el('Cherry','Blueberry','Banana','Sugary','Tasty','I love lollypops');
	say("Mmm!  $choice!");
	cause_damage($caster,$caster,-5, 'none');
	if ($target ne $caster) {
	say("\2$caster\2 offers \2$target\2 a lick too!"); cause_damage($caster,$target,-5, 'none'); }
	
	return 0;
},
bloodsuck=>sub {my ($caster, $target)=@_;
	cause_damage($caster,$target,200, 'dark');
	cause_damage($target,$caster,-200, 'none');
	return 1;
	},

ultimate_end=>sub {my ($caster, $target)=@_;
	say("Lengthy animation not included");
	cause_damage($caster,$target,7000, 'none');
	cause_damage($caster,$target,7000, 'none');
	cause_damage($caster,$target,7000, 'none');
	cause_damage($caster,$target,7000, 'none');
	cause_damage($caster,$target,7000, 'none');
	cause_damage($caster,$target,7000, 'none');
	cause_damage($caster,$target,7000, 'none');
	cause_damage($caster,$target,7000, 'none');
	cause_damage($caster,$target,7000, 'none');
	cause_damage($caster,$target,7000, 'none');
	cause_damage($caster,$target,7000, 'none');
	cause_damage($caster,$target,9999, 'none');
return 1;
},
vertigo=>sub {my ($caster, $target)=@_;
	my $time=int(rand(40)+1);
	if($characters{$target}->{delay} < (time()+9)){
		#say("Old delay: $characters{$target}->{delay}");
		my $newtime = time()+$time;
		$characters{$target}->{delay}=$newtime;
		#say("new delay: $characters{$target}->{delay} should be $newtime ");
		#delay($target,$time);
		#my $thistime = time();
		#say("Time: $thistime");
		say("\2$target\2 is paralyzed with fear for \2$time\2 seconds!");

	}else{
		
		$characters{$target}->{delay}+=$time;

		my $totaldelay=$characters{$target}->{delay}-time();
		if($totaldelay>70){
			$characters{$target}->{delay}=time();
			say("Facing fears brings \2target\2 out of his trembling!");
		}else{
			say("\2$target\2 is paralyzed with fear for \2$time\2 more seconds!");
		}
	}
	return 0;
},

mind_drain=>sub {my ($caster, $target) = @_;   
	my $mptaken = mp_damage($caster,$target,100);
	mp_damage($target,$caster,-$mptaken);
	return 0;
},
heal_you=>sub {my ($caster, $target) = @_;   
	cause_damage($caster,$target,-500, 'none');
	return 0;
},


mind_blast=>sub {my ($caster, $target) = @_;
	mp_damage($caster,$target,500, 'energy');
	return 0;
},
meditate=> sub {my ($caster, $target) = @_;
	 cause_damage($caster,$caster,-2000, 'none');
	 return 0;
},

damage_double=>sub {my ($caster, $target) = @_;         # doubles damage - webrunner
	$characters{$target}->{seffect} = "damagex2";
	$characters{$target}->{sefftime} = "3"; # three turns
	say("\2$target\2 is now strengthened!");
	return 0;
	
},
return_damage=>sub {my ($caster, $target) = @_;         #  returns damage - webrunner
	$characters{$target}->{seffect} = "return_damage";
	$characters{$target}->{sefftime} = "5"; # three turns
	say("\2$target\2 can now mirror damage!");
	return 0;
	
},
defence_down=>sub {my ($caster, $target) = @_;         # 1.5's damage - webrunner
	$characters{$target}->{seffect} = "weak_bodied";
	$characters{$target}->{sefftime} = "7"; # 7 turns
	say("\2$target\2 is now more succeptable to damage!");
	return 0;
},
protect=>sub {my ($caster, $target) = @_;         # .75's damage - webrunner
	$characters{$target}->{seffect} = "protect";
	$characters{$target}->{sefftime} = "7"; # three turns
	say("\2$target\2 is now protected!");
	return 0;
	
},
dance_of_the_sacred_spirits=>sub {my ($caster, $target) = @_;         # .75's damage - webrunner
	$characters{$target}->{seffect} = "protect";
	$characters{$target}->{sefftime} = "10"; # three turns
	say("\2$target\2 is now protected by the gods and takes less damage!");
	return 0;
	
},

steal_armor=>sub {my ($caster, $target) = @_;         # 1.5's damage - webrunner
	$characters{$target}->{seffect} = "weak_bodied";
	$characters{$target}->{sefftime} = "15"; # 7 turns
	say("Without Armor, \2$target\2 is now more succeptable to damage!");
	$characters{$caster}->{seffect} = "protect";
	$characters{$caster}->{sefftime} = "15"; # three turns
	say("\2$caster\2 puts on the armor and gets a defence boost!");
	return 0;
	
},


blunt=>sub {my ($caster, $target) = @_;         # halvesdamage - webrunner
	$characters{$target}->{seffect} = "damage/2";
	$characters{$target}->{sefftime} = "5"; # 5 turns
	say("\2$target\2 is now weakened");
	return 0;
	
},

mpshield=>sub {my ($caster, $target) = @_;         # Sheilds by converting hp damage to mp - webrunner
	$characters{$target}->{seffect} = "mpshield";
	$characters{$target}->{sefftime} = "5"; # five turns.. although it wont help if you run out of MP
	say("\2$target\2 is now protected by their magic for a limited time!");
	return 0;
	
},

regen=>sub {my ($caster, $target) = @_;         # Heals a little bit for 10 turns.
	$characters{$target}->{seffect} = "regen";
	$characters{$target}->{sefftime} = "10"; # 15 turns
	say("\2$target\2 begins regenerating health");
	return 0;
	
},


mind_regen=>sub {my ($caster, $target) = @_;         # Heals a little bit for 10 turns.
	$characters{$target}->{seffect} = "mpregen";
	$characters{$target}->{sefftime} = "10"; # 15 turns
	say("\2$target\2 begins regenerating magic points!");
	return 0;
	
},

poison=>sub {my ($caster, $target) = @_;         # Damages a little bit for 10 turns.
	$characters{$target}->{seffect} = "poison";
	$characters{$target}->{sefftime} = "10"; # 15 turns
    $characters{$target}->{seffname} = $caster;
	say("\2$target\2 is poisoned!");
	return 0;
	
},

slow_burn=>sub {my ($caster, $target) = @_;         # Damages a little bit for 10 turns.
	$characters{$target}->{seffect} = "burn";
	$characters{$target}->{sefftime} = "10"; # 15 turns
    $characters{$target}->{seffname} = $caster;
	say("\2$target\2 is on fire!");
	return 0;
	
},



assimilate=>sub {my ($caster, $target) = @_;
	my $mptaken = mp_damage($caster,$target,70);
	my $mptaken = mp_damage($target,$caster,-$mptaken);
	cause_damage($caster,$target,3500, 'lit');
	cause_damage($target,$caster,-1700, 'lit');

	return 1;
},
dance_of_special_words=>sub {my ($caster, $target) = @_;

        say("\2$caster\2 give his MP to \2$target\2");
        $characters{$target}->{mp}+=310;
        	return 0;
},
heal_all=>sub {my ($caster, $target) = @_;
    multi_effect_help($caster, 'heal_all', $target);
	return 0;
},
gravity_bomb=>sub {my ($caster, $target)=@_;
        $demi=$characters{$target}->{hp}/1.5;
        cause_damage_nostatus($caster,$target,$demi, 'dark');
        return 1;
},
cursing=>sub {my ($caster, $target)=@_;
        $characters{$caster}->{hp} = 1;
		say("\2$caster\2 is cursed!");
		return 1;
},
gravity_smash=>sub {my ($caster, $target)=@_;
        $demi=$characters{$target}->{hp}/1.7;
        cause_damage_nostatus($caster,$target,$demi, 'dark');
        return 1;
},
dark_messenger=>sub {my ($caster, $target)=@_;
        $demi=$characters{$target}->{hp}*.5;
        cause_damage_nostatus($caster,$target,$demi, 'dark');
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
		cause_damage($caster,$target,200, 'chem');
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

paper_or_plastic=>sub {($caster, $target)=@_;
	my $choice = rand_el('paper','plastic','ill_wear_it_home');
	if ($choice eq 'paper') {
		say ("Paper it is!");
		cause_damage($caster,$target,150, 'none');
	}
	elsif ($choice eq 'plastic') {
		say ("Plastic?  Sure!");
		cause_damage($caster,$caster,-150, 'none');
	}
	elsif ($choice eq 'ill_wear_it_home') {
		say ("I'll wear it home, thanks.");
		cause_damage($caster,$target,300, 'none');
		cause_damage($caster,$caster,100, 'none');
	}

	return 1;
},
howl=>sub {my ($caster, $target)=@_;
	say("Awoooooooo!");
	return 0;
},
mug=>sub {my ($caster, $target)=@_;
	if(exists $characters{$target}){
		cause_damage($caster,$target,120, 'none');
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
		cause_damage($caster,$target,120, 'none');
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
	multi_effect($caster, 'breath_weapon_barrage', $target);
	return 0;
},
attention_shoppers=>sub {my ($caster, $target)=@_;
	say("Attention Mall shoppers, there is a blue light special in isle five!");
	say("A horde of shoppers tramples the entire party!");
	multi_effect($caster, 'attention_shoppers', $target);
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
		delete $graveyard{$choice};
		cause_damage($caster,$caster,-500, 'none');
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
sam_the_record_man=>sub {my ($caster, $target)=@_;
	my $time=int(rand(30)+1);
	if($characters{$target}->{delay} < (time()+9)){
		$characters{$target}->{delay}=time()+$time;
		say("Wow, thats some phat tunes! \2$target\2 begins dancing and cannot act for \2$time\2 seconds");
	}else{
		$characters{$target}->{delay}+=$time;
		my $totaldelay=$characters{$target}->{delay}-time();
		if($totaldelay>40){
			$characters{$target}->{delay}=time();
			say("Ugh, this music sucks.  \2$target\2 is freed from the musical curse!");
		}else{
			say("The track changes, and \2$target\2 keeps dancing for \2$time\2 more seconds!");
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

print "Loading summon data...";


%summons=(
fire_fiend=>'flare',
senile_dragon=>'gum_bite',
lu_tze=>'broom_hit',
bomb=>'explode',
burning_soldier=>'fireball',
fire_spirit=>'fireblast',
ultima_beast=>'ultima',
final_boss=>'grudge',
final_boss_second_stage=>'blue_shockwave',
fire_guardian=>'inferno',
	ice_guardian=>'absolute_zero',
	slime_guardian=>'poison_dart',
	bolt_guardian=>'storm',
	knight_guardian=>'crush_punch',
	ethereal_guardian=>'pulse_wave',
	shadow_guardian=>'fissure',

holy_knight=>'minus_strike',
sniper=>'seal_evil',
werewolf=>'wolfsbane',
alpha_wolf=>'wolfsbite',
ice_wolf=>'iceshard',
robot_wolf=>'taser',
large_wolf=>'howl',
eternion=>'eternal_rage',
slayer_knight=>'canopener',
can=>'spraypaint',
bizarre_cannery=>'spraypaint',
can_of_summon=>'omniscience',
lollypop=>'lick',
non_fighter_monk=>'meditate',
vampire=>'bloodsuck',
chocobo=>'chocobo_kick',
knights_of_the_round=>'ultimate_end',
ramuh=>'judgement_bolt',
ifrit=>'hell_fire',
shiva=>'diamond_dust',
diablos=>'dark_messenger',
alexander=>'holy_judgement',
bahamut=>'mega_flare',
the_mall_after_being_exposed_to_radation_and_chemicals=>'paper_or_plastic',
lost_soul=>'wound',
ninja=>'smoke_bomb',
secret_summon=>'slow_burn',
thief=>'hide',
bard=>'harmony',
oracle=>'damage_double',
witch_doctor=>'poison',
dancer=>'dance_of_special_words',
doctor=>'regen',
gumshoe=>'zapper',
mimic=>'return_damage',
marathon_man=>'revive',
fighter=>'fighter_doken',
diablo=>'meteo',
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
slime_avenger=>'grudge',
imp=>'lame',
wolf=>'sniff',
wolf_rider=>'howl',
angel=>'preach',
psionist=>'mind_drain',
frozen_imp=>'freeze',
dragon_of_the_ice_cave=>'red_paint',
fire_dragon_of_the_ice_cave=>'inferno',
snow_puff=>'freeze',
ice_fiend=>'ice',

);
%multi_effects=(
white_dragon_protect=>sub {my ($caster,$target)=@_;
			$characters{$target}->{seffect} = 'white_dragon_protect';
			$characters{$target}->{sefftime} = 99;
			say("$target is protected by the power of the white dragon!");
},
blue_dragon_healing=>sub {my ($caster, $target) = @_;
    $characters{$target}->{hp} = $characters{$target}->{maxhp} ;
    say("\2$target\2 is fully healed by the power of the blue dragon!");
	return 0;
},
every_one=>sub {my ($caster, $target) = @_;
				if(rand(3)<=1) { 
				$characters{$target}->{hp} = 1;
				say("$target"."'s HP are reduced to one!");
				}
				if(rand(3)<=1) {
				$characters{$caster}->{hp} = 1;
				say("$target"."'s HP are reduced to one!");
				}
},
fallen_one=>sub {my ($caster, $target) = @_;
			$characters{$target}->{hp} = 1;
			say("$target"."'s HP are reduced to one!");
},
grand_cross=>sub {my ($caster, $target) = @_;
			my  $status = rand_el('poison','burn','death_sentance','slow','damage/2','weak_bodied' , 'none');
			if (!($status eq 'none')){

				$characters{$target}->{seffect} = $status;
				$characters{$target}->{sefftime} = 8;
				$characters{$target}->{seffname} = $caster;
				say("$target is afflicted with status effect $status!");
			}
			cause_damage($caster,$target,400,'none');
},
supernova=>sub {my ($caster, $target) =@_;
cause_damage($caster,$target,800,'fire');
},
all_ultima=>sub {my ($caster, $target) =@_;
	cause_damage($caster,$_,1500,'none');
},
void_thunder=>sub {my ($caster, $target) =@_;
	cause_damage($caster,$_,9999, 'lit');
},
snowstorm=>sub {my ($caster, $target) =@_;
	cause_damage($caster,$_,20, 'ice');
},

heal_all=>sub {my ($caster, $target) =@_;
	cause_damage($caster,$_,-5000);
},
breath_weapon_barrage=>sub {my ($caster, $target) =@_;
	cause_damage($caster,$_,10000, 'fire');
},
attention_shoppers=>sub {my ($caster, $target) =@_;
	cause_damage($caster,$_,100, 'none');
},

);
sub multi_effect_help{my ($caster, $spell, $target)=@_;
	my @targets=();
	if (! ($target eq 'monster')) {
		@targets = get_actives();
	}else{ @targets = ('monster'); }
	for(@targets) {
		if(exists $characters{$_}){

				&{$multi_effects{$spell}}($caster,$_);
				if(exists($characters{$caster}) && $characters{$_}->{hp}<1){
					defeats($caster,$_);
				}
			
		}
	}

}
	
sub multi_effect{my ($caster, $spell, $target)=@_;
	my @targets=();
	if (!($target eq 'monster')) {
		@targets = get_actives();
	}else{ @targets = ('monster'); }
	for(@targets) {
		if(exists $characters{$_}){
			if( $characters{$_}->{seffect} eq 'white_dragon_protect' ) {
				say("\2$_\2 is protected by the white dragon!");
				$characters{$_}->{seffect} = 'none';
				$characters{$_}->{sefftime} = 1;
			}else{
				&{$multi_effects{$spell}}($caster,$_);
				if(exists($characters{$caster}) && $characters{$_}->{hp}<1){
					defeats($caster,$_);
				}
			}
		}
	}

}
	

sub cause_damage_nostatus{ my ($attacker,$name,$amount, $element)=@_;
    my $elem_multi = element_multi($element,$characters{$name}->{class});
	
#'red','blue','yellow','octarine','plaid','purple','white','orange', 'green', 'black'are now status effects...
# red = fire blue = ice yellow = lightning plaid = weak to all, octarine = strong to all purple = energy
# white = holy green= chem, black = dark gold = absorb all orange = extreme weakness to all

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
	   	
		if (!($element eq 'none' ) && !($element eq '')) {
			say("\2$attacker\2 hits \2$name\2 for \2$actual\2 points of $element damage!");
		}else {
			say("\2$attacker\2 hits \2$name\2 for \2$actual\2 points of damage!");
		}
	
		logprint("Target HP: $characters{$name}->{hp}\n");
		$characters{$name}->{hp}-=$actual;
		$totaldamage = $totaldamage + $actual;
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
