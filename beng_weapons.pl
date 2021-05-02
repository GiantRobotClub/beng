print("Loading drop data..");
%drops=(
	slime=>{wood_sword=>5,pistol=>5,stick=>5,none=>30, hp_vial=>5,},
	slime_gang=>{leather_cloth=>5,leather_glove=>5,none=>30, mp_vial=>5},
	slime_king=>{dagger=>5,lute=>5,novel=>5,none=>30},
	final_boss_second_stage=>{dragon_blade=>1, atma_weapon=>1,warmaker=>1,godhand=>1,muscallibur=>1,songbringer=>1,tome_of_legends=>1,scepter_of_kings=>1},
	fire_guardian=>{flame_wand=>10,none=>60,wood_sword=>30},
	ice_guardian=>{the_black_death=>10,none=>60,wood_sword=>30},
	ethereal_guardian=>{kyuukyoku_yaiba=>10,none=>60,wood_sword=>30},
	bolt_guardian=>{songbringer=>10,none=>60,wood_sword=>30},
	slime_guardian=>{boxing_glove=>10,none=>60,wood_sword=>30},
	shadow_guardian=>{shadow_sword=>10,none=>60,wood_sword=>30},
	knight_guardian=>{excalibur=>10,none=>60,wood_sword=>30, phoenix_down=>20, knight_guardian_sword=>15},
	fire_dragon_of_the_ice_cave=>{cursed_gauntlet=>30,assassin_knife=>10, phoenix_down=>20, phoenix_tail=>5},
	dragon_of_the_ice_cave=>{kyuukyoku_yaiba=>1,the_black_death=>1,none=>60},
	ogre_king=>{phoenix_soul=>10,drill_glove=>10,lullaby_lute=>20,porno_mag=>20},
	slime_avenger=>{phoenix_soul=>10,althenas_sword=>1,none=>10000},
	cosmic_dragon=>{cosmic_star=>100,phoenix_soul=>100,dragon_blade=>1, atma_weapon=>1,warmaker=>1,godhand=>1,muscallibur=>1,songbringer=>1,tome_of_legends=>1,scepter_of_kings=>1},
	shadow_dragon=>{phoenix_soul=>10,none=>10000,songbringer=>1,scepter_of_kings=>1},
	drake=>{toothbrush=>1,none=>300,hp_vial=>100, dragon_teeth=>1},
	snow_puff=>{ice_brand=>1,none=>5},
	red_dragon=>{flame_wand=>1,none=>30,phoenix_soul=>3, dragon_teeth=>1},
	dragon_swarm=>{dragon_blade=>5,cosmic_star=>5,phoenix_soul=>5,mp_material=>5,hp_material=>5,atma_weapon=>5,warmaker=>5,muscallibur=>5,tome_of_legends=>5,dragon_blade=>5,cosmic_star=>5,phoenix_soul=>5,mp_material=>5,hp_material=>5,atma_weapon=>5,warmaker=>5,muscallibur=>5,tome_of_legends=>5,althenas_sword=>1},
	ultima_beast=>{ultima_crystal=>10,none=>10,phoenix_down=>10,phoenix_tail=>5,phoenix_soul=>1},
	ogre=>{ogre_mallet=>10,none=>50},
	ettin=>{ogre_mallet=>20,none=>50},
	giant=>{baka_mallet=>1,none=>30, hp_material=>1},
	doctor=>{hp_vial=>1000,hp_potion=>100,elixir=>10,megaelixir=>1},
	marathon_man=>{phoenix_tail=>30,hp_material=>50,mp_material=>50,megaelixir=>1,coca_cola=>100},
	gumshoe=>{none=>100,laser_pistol=>30},
	ice_fiend=>{none=>40,ice_claws=>20},
	
#drop_tester=>{
#		wood_sword=>10,
#		flame_wand=>10,
#		porno_mag=>10
#	},
);

sub tell_buy_type{ my ($name, $type)=@_;
	sayto($name, "The $type weapons you can buy are: ".
	join(' ',(map {"\2$_\2 (\2$equips{$_}->{cost}\2 gold)"}
	 buy_list($name))));
	 sayto($name, "Use beng buy [WEAPON] without the brackets to buy a weapon.");
}

sub buy_list_type{ my ($name, $weaptype)=@_;
	my @ret=();
	for(keys %equips){
		my $class = $characters{$name}->{class};
		#sayto($name,"DEBUG: $name $_ $weaptype $classes{$class}->{weaptypes}->{$weaptype}");
		if( ( $classes{$class}->{weaptypes}->{$weaptype}) &&
		 ($characters{$name}->{gold} >= $equips{$_}->{cost})&& ($equips{$_}->{type} eq $weaptype )){
			push @ret, $_;
		}
	}
	return @ret;
}

print "Loading weapon data...";

%equips=(

#accessories: dont affect attack damage.
	mind_crystal=>{legend=>1,cost=>300000,rating=>'1',element=>'none',type=>'accessory',description=>'Attacking refills MP'},


#monster type
	ice_claws=>{cost=>300,rating=>'3',element=>'ice',type=>'monster',description=>'Claws of an ice beast'},
	dragon_teeth=>{cost=>1500,rating=>'6',element=>'none',type=>'monster',description=>'The teeth of a dragon'},
	knight_guardian_sword=>{cost=>10000,rating=>'15',element=>'holy',type=>'monster',description=>'Sword of a Knight Guardian'},
	toothbrush=>{cost=>100000,rating=>'1',element=>'white_gleaming',type=>'sword',legend=>1,description=>'Brush your teeth and go to bed'},
	cheater_toothbrush=>{cost=>50,rating=>'1',element=>'cheater',type=>'cheater',description=>'Dont Cheat!'},
	electric_toothbrush=>{cost=>6000000,rating=>'300',element=>'lit',type=>'sword',legend=>1,description=>'Brush them right off the face of the planet'},
#swords (fighter, hunter, holy_knight, angel, demon, slayer_knight)
	sword_bomb=>{legend=>1,cost=>10000000,rating=>'3000',element=>'none',type=>'sword',description=>'Explodes!',legend=>1},
	wood_sword=>{cost=>50,rating=>'1.5',element=>'none',type=>'sword',description=>'Average wooden sword'},
	iron_sword=>{cost=>200,rating=>'3',element=>'none',type=>'sword',description=>'Average iron sword'},
	ice_brand=>{cost=>1000,rating=>'5',element=>'ice',type=>'sword',description=>'Taste Cold Steel!'},
	l33t_haxor=>{cost=>1337,rating=>'6',element=>'st00p1d',type=>'sword',description=>'I H4X0RZZ U!!!11'},
	lightsabre=>{cost=>2000,rating=>'8',element=>'energy',type=>'sword',description=>'An elegant weapon from a more civilized age'},
	blood_blade=>{cost=>12000,rating=>'30',element=>'dark',type=>'sword',description=>'Health Drain'},
	crystal_sword=>{cost=>30000,rating=>'50',element=>'dark',type=>'sword',description=>'Made of crystal'},
	kyuukyoku_yaiba=>{cost=>80000,rating=>'80',legend=>1,element=>'finite',type=>'sword',description=>'Terminal Blade - does incredible damage to Eternals'},

	excalibur=>{cost=>100000,rating=>'90',legend=>1,element=>'holy',type=>'sword',description=>'No Stones Attached'},
	
	atma_weapon=>{cost=>1000000,rating=>'100',legend=>1,element=>'energy',type=>'sword',description=>'AKA the Ultima Weapon'},
	althenas_sword=>{cost=>2000000, rating=>'400',legend=>1,element=>'none',type=>'sword',description=>'Dragonmaster\'s Sword'},
	programmer_blade=>{cost=>999999999 , legend=>1, rating=>'999',element=>'none',type=>'sword',description=>'Webrunners personal weapon'},
	cardmasters_hand=>{cost=>999999999 ,legend=>1, rating=>'9999',element=>'none',type=>'glove',description=>'Webrunners personal glove.  Casts a random high-level spell'},

	life_syphon=>{cost=>6000000,rating=>'999',legend=>1,element=>'none',type=>'sword',description=>"Powered by your soul"},
#guns (psionist, sniper, oracle)
	pistol=>{cost=>30,rating=>'1.3',element=>'none',type=>'gun',description=>'bang'},
	sniper_rifle=>{cost=>1100,rating=>'5',element=>'none',type=>'gun',description=>'Cant miss'},
	flamethrower=>{cost=>1500,rating=>'5.5',element=>'fire',type=>'gun',description=>'Turn up the heat'},
	poison_dartgun=>{cost=>3000,rating=>10,element=>'chem',type=>'gun',description=>'Chemicals are fun'},
	mp5=>{cost=>10000,rating=>'10',element=>'none',type=>'gun',description=>'Hits multiple times'},
	ice_shard_launcher=>{cost=>10000,rating=>'10',element=>'ice',type=>'gun',description=>'C..c..cold!'},
	laser_pistol=>{cost=>13000,rating=>'35',element=>'energy',type=>'gun',description=>'ZZAP!'},
	bazooka=>{cost=>35000,rating=>'60',element=>'none',type=>'gun',description=>'Massive Damage'},
	the_black_death=>{cost=>80000,rating=>'80',legend=>1,element=>'dark',type=>'gun',description=>'Fires dark energy'},
	zapper=>{cost=>6000000,rating=>'999',legend=>1,element=>'energy',type=>'gun',description=>'Duck Hunt'},
	warmaker=>{cost=>1000000,rating=>'100',legend=>1,element=>'dark',type=>'gun',description=>'Legendary gun'},
	golden_gun=>{cost=>6000000,rating=>'999',legend=>1,element=>'gold',type=>'gun',description=>'One bullet.  One kill'},

	#cloth (angel, dancer)
	
	leather_cloth=>{cost=>10,rating=>'1.1',element=>'none',type=>'cloth',description=>'Normal fabric'},
	smooth_silk=>{cost=>10000,rating=>'25',element=>'none',type=>'cloth',description=>'Mismerizing'},
	demi_cloth=>{cost=>60000,rating=>'50',element=>'dark',type=>'cloth',description=>'The Fabric of Space and Time'},
	amnesia_cloth=>{cost=>6000000,rating=>'999',element=>'none',type=>'cloth',description=>'Pacifies the target into a non-moving forgetful slouch.'},
	gold_weave=>{cost=>1000000,rating=>'100',legend=>1,element=>'none',type=>'cloth',description=>'Woven from magically infused gold'},
#gloves (robot, demon, ninja, monk, dancer)
	leather_glove=>{cost=>30,rating=>'1.5',element=>'none',type=>'glove',description=>'One leather glove.'},
	spiked_glove=>{cost=>600,rating=>'4',element=>'none',type=>'glove',description=>'Brass Knucks'},
	shock_glove=>{cost=>2000,rating=>'8',element=>'lit',type=>'glove',description=>'This Punch Hurts'},
	claws=>{cost=>5000,rating=>'20',element=>'none',type=>'glove',description=>'Bub.'},
	drill_glove=>{cost=>11000,rating=>'40',element=>'none',type=>'glove',description=>'Drill Punch'},
	skeleton_glove=>{cost=>10000,rating=>'15',element=>'dark',type=>'glove',description=>'Chance of death sentance'},
	burn_knuckle=>{cost=>35000,rating=>'60',element=>'fire',type=>'glove',description=>'Terry Bogards Secret Weapon'},
	boxing_glove=>{cost=>80000,rating=>'80',legend=>1,element=>'none',type=>'glove',description=>'Puncha-puncha.'},
	cursed_gauntlet=>{cost=>150,rating=>'50',element=>'dark',type=>'glove',description=>'I wonder why its so cheap'},
	godhand=>{cost=>1000000,rating=>'100',legend=>1,element=>'holy',type=>'glove',description=>'The most powerful glove in existance'},
	power_glove=>{cost=>6000000,rating=>'999',legend=>1,element=>'energy',type=>'glove',description=>'I love the power glove.  Its so bad!'},
	#knives (mage, harlot, ninja, thief, slayer_knight)
	
	dagger=>{cost=>100,rating=>'3',element=>'none',type=>'knife',description=>'Sharp and pointy'},
	knife=>{cost=>1000,rating=>'5',element=>'none',type=>'knife',description=>'Ouch.'},
	kris=>{cost=>4000,rating=>'10',element=>'none',type=>'knife',description=>'Waved for more damage'},
	poison_dagger=>{cost=>8000,rating=>'30',element=>'chem',type=>'knife',description=>'Dipped in liquid death'},
	assassin_knife=>{cost=>166666,rating=>'40',element=>'none',type=>'knife',description=>'Might hit an artery'},
	ninja_knife=>{cost=>60000,rating=>'60',element=>'none',type=>'knife',description=>'Ninjas make everything better'},
	katana=>{cost=>40000,rating=>'40',element=>'nome',type=>'knife',description=>'Sharp and deadly'},
	shadow_sword=>{cost=>80000,rating=>'80',legend=>1,element=>'dark',type=>'knife',description=>'Dark Damage'},
	dragon_blade=>{cost=>1000000,rating=>'100',legend=>1,element=>'none',type=>'knife',description=>'Dragon Power!'},
	diamond_dagger=>{cost=>6000000,rating=>'999',legend=>1,element=>'holy',type=>'knife',description=>'The most powerful dagger in the known universe'},
#instruments (bard, dancer)
	lute=>{cost=>1,rating=>'1.5',element=>'none',type=>'music',description=>'Simple lute'},
	harp=>{cost=>50,rating=>'1',element=>'none',type=>'music',description=>'Small chance of Blunt'},
	harp_of_magic=>{cost=>10000,rating=>'1',element=>'none',type=>'music',description=>'50% chance of casting one of 10 different spells for free'},
	lullaby_lute=>{cost=>150,rating=>'1',element=>'none',type=>'music',description=>'Can put to sleep'},
	mysterious_piano=>{cost=>777,rating=>'1',element=>'banana',type=>'music',description=>'Im not really sure...'},
	songbringer=>{cost=>80000,rating=>'80',legend=>1,element=>'dark',type=>'music',description=>'The Dark Lute Songbringer'},
	muscallibur=>{cost=>1000000,rating=>'100',legend=>1,element=>'holy',type=>'music',description=>'Legendary Harp in the Stone'},
#books (bard, mage, summoner, time_mage, oracle, healer, dancer)
		novel=>{cost=>40,rating=>'1.4',element=>'none',type=>'book',description=>'Interesting Times'},
		dictionary=>{cost=>1300,rating=>'30',element=>'none',type=>'book',description=>'Ill verb YOU'},
		porno_mag=>{cost=>6000,rating=>'20',element=>'none',type=>'book',description=>'Everyone stops to stare'},
		chequebook=>{cost=>20000,rating=>'20',element=>'none',type=>'book',description=>'Throw money at the problem'},
		book_of_magic=>{cost=>20000,rating=>'20',element=>'none',type=>'book',description=>'Magic is in the air (magic cost halved)'},
		britannica=>{cost=>60000,rating=>'80',element=>'none',type=>'book',description=>'Look it up'},
		tome_of_legends=>{cost=>1000000,rating=>'100',legend=>1,element=>'none',type=>'book',description=>'Every spell known to mankind'},
		textbook=>{cost=>10000,rating=>'0',element=>'none',type=>'book',description=>'Increases XP Gain, damage at zero'},
		#mace/wand (time_mage, oracle, mage, angel, holy_knight, healer, summoner) 
	stick=>{cost=>10,rating=>'1.2',element=>'none',type=>'wand',description=>'You need to know what a STICK IS!?'},
	mental_rod=>{cost=>6000,rating=>'15',element=>'none',type=>'wand',description=>'Mental Damage'},
	healing_staff=>{cost=>150,rating=>'-6',element=>'none',type=>'wand',description=>'Heals when it hits'},
	healer_scepter=>{cost=>60000,rating=>'-10',element=>'none',type=>'wand',description=>'Heals and regens'},
	flame_wand=>{cost=>3000,rating=>'7',element=>'fire',type=>'wand',description=>'free fireball'},
	lightning_rod=>{cost=>10000,rating=>'16',element=>'lit',type=>'wand',description=>'free lightning'},
	summon_staff=>{cost=>20300,rating=>'50',element=>'none',type=>'wand',description=>'Summon Hotline (summon cost halved)'},
	ogre_wrath=>{cost=>6000000,rating=>'999',element=>'none',legend=>1,type=>'wand',description=>'OGRE SMASH!'},
	ogre_mallet=>{cost=>10000,rating=>'10',element=>'none',legend=>1,type=>'wand',description=>'A mallet with OGRE written on it for some reason'},
	
	scepter_of_kings=>{cost=>1000000,rating=>'100',legend=>1,element=>'holy',type=>'wand',description=>'The Holiest!'},
	
	baka_mallet=>{cost=>777,rating=>'7',element=>'baka',type=>'wand',description=>"BAKA BAKA!"},
	Mjolnir=>{cost=>1000000,legend=>1,rating=>'150',element=>'lit',type=>'wand',description=>"Thor's Hammer"},

	programmers_wand=>{cost=>1000000000,rating=>'999',element=>'code',type=>'wand',description=>'The wand of Coding', legend=>1},
	
	#ninja stars
	baseball=>{cost=>20,rating=>'5',element=>'none',type=>'star',description=>'here comes the pitch!'},
	shuriken=>{cost=>1500,rating=>'20',element=>'none',type=>'star',description=>'Pointy thrown object'},
	cosmic_star=>{cost=>1000000,rating=>'300',legend=>1,element=>'none',type=>'star',description=>'Extremely Deadly Star'},
	grenade=>{cost=>6000,rating=>'30',element=>'fire',type=>'star',description=>'Explosive weapon'},
	pie=>{cost=>1,rating=>1,element=>'coconut',type=>'star',description=>'Anybody want any pie?'},
	nuclear_potato=>{cost=>1,rating=>100000,element=>'potato',type=>'star',legend=>1,description=>'Incredibly Powerful Star'},
);

print "Loading special weapons...";

%special_throws=(
	cursed_gauntlet=>sub {my ($attacker, $target, $damage)=@_;
		my $name = $attacker;
		say("The gauntlet refuses to leave \2$attacker\2's hand!");
		$inv{$name}->{cursed_gauntlet} = $inv{$name}->{cursed_gauntlet} + 1;
		return 0;
	},
	pie=>sub {my ($attacker, $target, $damage)=@_;
		say("Splat!");
		return $damage;
	},
);
%special_weapons=(
	sword_bomb=>sub {my ($attacker, $target, $damage, $element)=@_; 
		cause_damage(sword_bomb,$attacker,$damage,'none');
		return 0;
		},
	power_glove=>sub {my ($attacker, $target, $damage, $element)=@_; 
		$characters{$target}->{mp} = 0;
		if(!($inv{$attacker}->{'zapper'} > 1)) {
			say("Cant control the power!  Mp drained!");
			$characters{$attacker}->{mp} = 0; correct_points($attacker);return int($damage / 1000); }
		return $damage * 3;
		
	},
	zapper=>sub {my ($attacker, $target, $damage, $element)=@_; 
		$characters{$target}->{mp} = 0;
		if(!($inv{$attacker}->{'power_glove'} > 1)) {
			say("Cant control the power!  Mp drained!");
			$characters{$attacker}->{mp} = 0; correct_points($attacker); return int($damage / 1000);}
		
		return $damage * 3;
	},
	life_syphon=>sub {my ($attacker, $target, $damage, $element)=@_; 
		$characters{$target}->{hp} = 0;
		$characters{$attacker}->{maxhp} = $characters{$attacker}->{maxhp} -10;
		$characters{$attacker}->{maxmp} = $characters{$attacker}->{maxmp} -10;
		$characters{$attacker}->{xp} = $characters{$attacker}->{xp} - 100;
		correct_points($attacker);

		return 0;
	},

	diamond_dagger=>sub {my ($attacker, $target, $damage, $element)=@_; 
		return $totaldamage / 500;	

	},
	ogre_wrath=>sub {my ($attacker, $target, $damage, $element)=@_; 
		return $goblinslayer * $damage;	

	},
	amnesia_cloth=>sub {my ($attacker, $target, $damage, $element)=@_; 
		
		say("\2monster\2 forgets who he is!");
		$characters{nobody_important}=$characters{monster};
		
		delete $characters{monster};
		delete $present{monster};
		delete $concealed{monster};
		say("\2monster\2 is now \2nobody_important\2!");
		return 0;

	},
	golden_gun=>sub {my ($attacker, $target, $damage, $element)=@_; 
		$characters{$target}->{hp} = 0;
		$characters{$attacker}->{weapon} = 'none';
	},
	mind_crystal=>sub {my ($attacker, $target, $damage, $element)=@_; 
		$characters{$attacker}->{mp} = $characters{$attacker}->{maxmp};
		return $damage;
	},
	programmers_wand=>sub {my ($attacker, $target, $damage, $element)=@_; 
		free_cast($attacker, 'ultima',$target);
		return $damage * 2;
	},
	cheater_toothbrush=>sub {my ($attacker, $target, $damage, $element)=@_; 
		return 1;
	},
	cardmasters_hand=>sub {my ($attacker, $target, $damage, $element)=@_; 
		my $spell= rand_el('ultimate_end','red_dragon_anger','ultima','magic_missle','omnislash','black_dragon_grief','supernova','judgement_day','dragon_slave','spark');
		free_cast($attacker,$spell,$target);
		return $damage;
	},
	programmer_blade=>sub {my ($attacker, $target, $damage, $element)=@_; 
			free_cast($attacker,'ultima',$target);
			return $damage;
	},
	baka_mallet=>sub {my ($attacker, $target, $damage, $element)=@_; 
			$characters{$target}->{seffect} = 'baka';
			$characters{$target}->{sefftime} = 6;
			$characters{$target}->{seffname} = 'webrunner';
			return $damage;
	},
	mental_rod=>sub {my ($attacker, $target, $damage, $element)=@_;
			mp_damage($attacker, $target, $damage);
			mp_damage($attacker, $attacker, -$damage);
			return 0;
	},
	atma_weapon=>sub {my ($attacker, $target, $damage, $element)=@_; 

		return $characters{$attacker}->{hp} + $damage;
	},
	blood_blade=>sub {my ($attacker, $target, $damage, $element)=@_; 
		cause_damage($attacker,$attacker,-$damage,'none');
		return $damage;
	},
	althenas_sword=>sub {my ($attacker, $target, $damage, $element)=@_; 
		my $spell= rand_el('black_dragon_grief','red_dragon_anger','blue_dragon_healing','white_dragon_protect');
		free_cast($attacker,$spell,$target);
		return $damage;
	},
	mp5=>sub {my ($attacker, $target, $damage, $element)=@_; 
		cause_damage($attacker,$target,$damage,$element);
		cause_damage($attacker,$target,$damage,$element);
		return $damage;
	},
	warmaker=>sub {my ($attacker, $target, $damage, $element)=@_; 
		return $damage * rand(3);
	},
	skeleton_glove=>sub {my ($attacker, $target, $damage, $element)=@_; 
		if (rand((sqrt $characters{$attacker}->{level} )*3) > rand($characters{$target}->{hp} + 100)) {	
			$characters{$target}->{seffect} = 'death_sentance';
			$characters{$target}->{sefftime} = 8;
			$characters{$target}->{seffname} = $attacker;
			say("$target is going to die in 8 turns!");
		}
		return $damage;
	},
	assassin_knife=>sub {my ($attacker, $target, $damage, $element)=@_; 
		if (rand(sqrt( $characters{$attacker}->{maxhp})) > rand($characters{$target}->{maxhp})) {
			$characters{$target}->{hp} = 0;
			say("$target is assassinated!");
			return 0;
		}
		return $damage / 3;
	},
#
	cursed_gauntlet=>sub {my ($attacker, $target, $damage, $element)=@_; 
		free_cast($attacker, 'cursing', $attacker);
		return 1;
	},
	godhand=>sub {my ($attacker, $target, $damage, $element)=@_; 
		return $damage + sqrt(sqrt( $slimeslayer * $goblinslayer * $canslayer * $manslayer * $dragonslayer * $demonslayer * $wolfslayer * $damage )) / 100;
	},
	poison_dagger=>sub {my ($attacker, $target, $damage, $element)=@_; 
		my $choice = rand_el('poison','none','none','none','none');
		if ($choice eq 'poison'){
			$characters{$target}->{seffect} = 'poison';
			$characters{$target}->{sefftime} => 8;
			say("$target is poisoned!");
		}
		return $damage;
	},
	dragon_blade=>sub {my ($attacker, $target, $damage, $element)=@_; 
		my $spell= rand_el('fire_breath','ice_breath','shadow_breath','really_bad_breath', 'poison_breath');
		if (!($spell eq 'none')) { free_cast($attacker,$spell,$target); }
		return $damage;
	},
	harp_of_magic=>sub {my ($attacker, $target, $damage, $element)=@_; 
		my $spell= rand_el('duh','fireball','lightning','finite','pyrokinesis','flare','iceshard','poison_dart','lullaby','darkness');
		if (!($spell eq 'none')) { free_cast($attacker,$spell,$target); }
		return $damage;
	},
	smooth_silk=>sub {my ($attacker, $target, $damage, $element)=@_; 

		my $time=int(rand(80)+1);
		if ($time > 60) {
			$time = $time - 60;
			if($characters{$target}->{delay} < (time()+9)){
				$characters{$target}->{delay}=time()+$time;
				say("\2$target\2 is mezmerized for \2$time\2 seconds!");
			}else{
				$characters{$target}->{delay}+=$time;
				my $totaldelay=$characters{$target}->{delay}-time();
				if($totaldelay>40){
					$characters{$target}->{delay}=time();
					say("The fabric softens \2target\2's bond, and he is free!");
				}else{
					say("\2$target\2 is frozen \2$time\2 more seconds!");
				}
			}
		}
		return $damage;
	},

	demi_cloth=>sub {my ($attacker, $target, $damage, $element)=@_; 
		return rand($characters{$target}->{hp}*0.33);
	},
	gold_weave=>sub {my ($attacker, $target, $damage, $element)=@_; 
		return rand($characters{$attacker}->{hp});
	},
	harp=>sub {my ($attacker, $target, $damage, $element)=@_; 
		if (rand($characters{$attacker}->{level}) > 50) {
			$characters{$target}->{seffect} = 'blunt';
			$characters{$target}->{sefftime} => 6;
			say("$target is weakened");
		}
		return $damage;
	},
	lullaby_lute=>sub {my ($attacker, $target, $damage, $element)=@_; 

		my $time=int(rand(90)+1);
		if ($time > 60) {
			$time = $time - 60;
			if($characters{$target}->{delay} < (time()+9)){
				$characters{$target}->{delay}=time()+$time;
				say("\2$target\2 is put to sleep for \2$time\2 seconds!");
			}else{
				$characters{$target}->{delay}+=$time;
				my $totaldelay=$characters{$target}->{delay}-time();
				if($totaldelay>40){
					$characters{$target}->{delay}=time();
					say("The music wakes \2target\2!");
				}else{
					say("\2$target\2 is trapped in slumber for \2$time\2 more seconds!");
				}
			}
		}
		return $damage;
	},
	mysterious_piano=>sub {my ($attacker, $target, $damage, $element)=@_; 
		my $choice= rand_el('giant q', 'heal_all', 'cast_duh', 'banana ', 'nothing', 'banana_heal');
		if ($choice eq 'giant_q') {
			say("A Giant yellow Q falls on \2$target\2!");
			return $damage;
		}
		elsif ($choice eq 'heal_all') {
			say("A healing breeze begins to blow!");
			free_cast($attacker, 'heal_all',$target);
			return 0;
		}
		elsif ($choice eq 'cast_duh') {
			say("Dont YOU feel stupid?");
			free_cast($attacker, 'duh',$target);
			return 0;
		}
		elsif ($choice eq 'banana') {
			say("A swarm of bananas surround the enemy!");
			return $damage * 2;
		}
		elsif ($choice eq 'nothing') {
			say("Nothing happens!");
			return 0;
		}
		elsif ($choice eq 'banana_heal') {
			say("A Helpful banana comes to \2$target\2's aid!");
			return $damage * -1;
		}

		return 0;

	},
	songbringer=>sub {my ($attacker, $target, $damage, $element)=@_; 
		my $spell= rand_el('gravity_bomb','fissure','darkness','vanish', 'none', 'none');
		if (!($spell eq 'none')) { free_cast($attacker,$spell,$target); }
		return $damage;
	},
	muscallibur=>sub {my ($attacker, $target, $damage, $element)=@_; 
		my $spell= rand_el('damn','wound','smite','holy_explosion', 'none', 'none');
		if (!($spell eq 'none')) { free_cast($attacker,$spell,$target); }
		return $damage;
	},
	porno_mag=>sub {my ($attacker, $target, $damage, $element)=@_; 

		my $time=int(rand(100)+1);
		if ($time > 60) {
			$time = $time - 60;
			if($characters{$target}->{delay} < (time()+9)){
				$characters{$target}->{delay}=time()+$time;
				say("\2$target\2 stares at the magazine for \2$time\2 seconds!");
			}else{
				$characters{$target}->{delay}+=$time;
				my $totaldelay=$characters{$target}->{delay}-time();
				if($totaldelay>40){
					$characters{$target}->{delay}=time();
					say("The page turns to the articles!  \2target\2 is no longer interested!");
				}else{
					say("\2$target\2 is transfixed on the magazine for \2$time\2 more seconds!");
				}
			}
		}
		return $damage;
	},
	chequebook=>sub {my ($attacker, $target, $damage, $element)=@_; 
		my $gold = $characters{$attacker}->{gold};
		my $dam = int(rand($gold / 4));
		$characters{$attacker}->{gold} = $characters{$attacker}->{gold} - $dam;
		say ("\2$attacker\2 throws $dam gold at \2$target\2!");
		return ($dam / 2);
	},
	
	tome_of_legends=>sub {my ($attacker, $target, $damage, $element)=@_; 
		my $choice = 0;
		my $subject = "doppelgang";
my @spellarray = get_all_spells();

		while ($subject eq "doppelgang" || $subject eq "transform") {
			$choice=int(rand(scalar(@spellarray)));
			$subject = @spellarray[$choice];
		}
		
		free_cast($attacker, $subject, $target);
		return $damage;
	},
	 lightning_rod=>sub {my ($attacker, $target, $damage, $element)=@_; 
		my $spell='lightning';
		free_cast($attacker,$spell,$target);
		return $damage;
	},
	ice_shard_launcher=>sub {my ($attacker, $target, $damage, $element)=@_; 
		my $spell='iceshard';
		free_cast($attacker,$spell,$target);
		return $damage;
	},
	flame_wand=>sub {my ($attacker, $target, $damage, $element)=@_; 
		my $spell='fireball';
		free_cast($attacker,$spell,$target);
		return $damage;
	},
	scepter_of_kings=>sub {my ($attacker, $target, $damage, $element)=@_; 
		my $spell='holy_explosion';
		free_cast($attacker,$spell,$target);
		return $damage;
	},
);
