print("Loading synth data...");
%recipes=(
	cosmic_star=>{baseball=>50,pie=>100,shuriken=>200,phoenix_tail=>10},
	atma_weapon=>{excalibur=>2,kyuukyoku_yaiba=>2,the_black_death=>2},
	iron_sword=>{wood_sword=>10},
	muscallibur=>{gold_weave=>1},
	assassin_knife=>{skeleton_glove=>5},
	thors_hammer=>{ogre_mallet=>100,baka_mallet=>100,shock_glove=>20},
	sword_bomb=>{grenade=>100,iron_sword=>1},
	
);


print("Loading item data...");

%negative_status=(
	slow=>1,
	burn=>1,
	weak_bodied=>1,
	damage/2=>1,
	poison=>1,
	death_sentance=>1,
);

%armor=( #this doesn't do anything yet.
	clothing=>{cost=>20,defence=>1.1,elem=>{}},
	snug_sweater=>{cost=>500,defence=>1,elem=>{cold=>.5}},
	fire_robe=>{cost=>1000,defence=>13,elem=>{cold=>2,fire=>0}},

);
%items=(

	next_level_tome=>{cost=>0,description=>'Jump to next level instantly',legend=>1},

	hp_vial=>{cost=>10,description=>'Gain 30 hp'},
	hp_potion=>{cost=>300,description=>'Gain 500 hp'},
	hp_thermos=>{cost=>2000,description=>'Gain 1000 hp'},
	hp_max=>{cost=>10000,description=>'Regain all hp'},
	hp_material=>{cost=>60000,description=>'Increase HP by 30', legend=>1},
	mp_material=>{cost=>60000,description=>'Increase Mp by 20', legend=>1},
	mp_vial=>{cost=>100,description=>'Gain 30 mp'},
	mp_potion=>{cost=>3000,description=>'gain 500 mp'},
	mp_thermos=>{cost=>10000,description=>'Gain 1000 mp'},
	mp_max=>{cost=>30000,description=>'Regain all mp'},
	coca_cola=>{cost=>1000,legend=>1,description=>'Cool, Refreshing Coca cola!'},
	
	detector=>{cost=>1000,description=>'Uncloak cloaked people'},
	baseball=>{cost=>20,description=>'Easy to throw'},
	shuriken=>{cost=>1500,description=>'Sharp and pointy'},
	cosmic_star=>{cost=>1000000,legend=>1,description=>'Sharp and pointy'},
	grenade=>{cost=>6000,description=>'Sharp and pointy'},
	pie=>{cost=>1,description=>'pie'},
	
	elixir=>{cost=>100000,description=>'Full HP and MP plus cure negative status'},
	megaelixir=>{cost=>600000,description=>'Full HP and MP cure plus negative status for whole party',legend=>1},

	milk=>{cost=>50,description=>'Does a body good! (Cures weak bodied and damage/2)'},
	antidote=>{cost=>50,description=>'Cures poison'},
	ointment=>{cost=>100,description=>'Cures burning'},
#	smarty_pants=>{cost=>77,description=>'Cures Baka-ness'},
#	tiny_hammer=>{cost=>100,description=>'Cures mini, baka-ness, color.'},
#	holy_water=>{cost=>100,description=>'Cures death sentance'},
#	speed_salt=>{cost=>100,description=>'Cures slow'},
#	vitamins=>{cost=>50,description=>'Cures blunt'},
#	paint_thinner=>{cost=>10,description=>'cures color'},
	remedy=>{cost=>300,description=>'Cures negative status'},
	phoenix_soul=>{cost=>120000,description=>'Raise the entire graveyard!'},
	phoenix_down=>{cost=>5000,description=>'Raise the recently deceased'},
	phoenix_tail=>{cost=>60000,description=>'Raise any deceased',legend=>1},
	ultima_crystal=>{cost=>7000,description=>'The power of Ultima',legend=>1},
);

print("Loading special item effects...");
%item_effect=(
next_level_tome=>sub {my ($user, $target)=@_;	
	$characters{$target}->{xp} = xp_needed($target);
	correct_points($target);
	return;


},
detector=>sub {my ($user, $target)=@_;
	if(keys %concealed){
		say("\2$user\2's detector finds concealed parties!");
		for(keys %concealed){
			$present{lc($_)}=1;
			delete $concealed{$_};
		}
	}
	return 0;
},
	hp_material=>sub { my ($user, $target)=@_;
		$characters{$target}->{maxhp}+=30;
		say("\2$target\2's max hp increases by 30!");
		return;
	},
	mp_material=>sub { my ($user, $target)=@_;
		$characters{$target}->{maxmp}+=20;
		say("\2$target\2's max mp increases by 20!");
		return;
	},	
	hp_vial=>sub {my ($user, $target)=@_;
		hp_cure($user,$target,30);
		return;
	},
	hp_potion=>sub {my ($user, $target)=@_;
		hp_cure($user,$target,500);
		return;
	},
	hp_thermos=>sub {my ($user, $target)=@_;
		hp_cure($user,$target,1000);
		return;
	},
	hp_max=>sub {my ($user, $target)=@_;
		hp_cure_max($user,$target);
		return;
	},

	ultima_crystal=>sub {my ($user, $target)=@_;
		free_cast($user,'ultima',$target);
		return;
	},

	mp_vial=>sub {my ($user, $target)=@_;
		mp_cure($user,$target,30);
		return;
	},
	mp_potion=>sub {my ($user, $target)=@_;
		mp_cure($user,$target,500);
		return;
	},
	mp_thermos=>sub {my ($user, $target)=@_;
		mp_cure($user,$target,1000);
		return;
	},
	coca_cola=>sub {my ($user, $target)=@_;
		say("\2$target\2 enjoys Cool, Refreshing Coca Cola!");
		hp_cure($user,$target,1000);
		mp_cure($user,$target,1000);
		return;
	},
	mp_max=>sub {my ($user, $target)=@_;
		mp_cure_max($user,$target);
		return;
	},
	elixir=>sub {my ($user, $target)=@_;
		hp_cure_max($user,$target);
		mp_cure_max($user,$target);
		status_cure($target,'negative');
		return;
	},
	megaelixir=>sub {my ($user, $target)=@_;
		for(get_actives()) {
			hp_cure_max($user,$_);
			mp_cure_max($user,$_);
			status_cure($_,'negative');
		}
		return;
	},

	milk=>sub {my ($user, $target)=@_;
		status_cure($target,'weak_bodied');
		status_cure($target,'damage/2');
		return ;
	},
	antidote=>sub {my ($user, $target)=@_;
		status_cure($target,'poison');

		return ;
	},
	ointment=>sub {my ($user, $target)=@_;
		status_cure($target,'burn');
		return ;
	},
	smarty_pants=>sub {my ($user, $target)=@_;
		status_cure($target,'baka');
		return ;
	},
	holy_water=>sub {my ($user, $target)=@_;
		status_cure($target,'death_sentance');
		return ;
	},
	speed_salt=>sub {my ($user, $target)=@_;
		status_cure($target,'slow');
		return ;
	},
	vitamins=>sub {my ($user, $target)=@_;
		status_cure($target,'damage/2');
		return ;
	},
	paint_thinner=>sub {my ($user, $target)=@_;
		status_cure($target,'color');
		return ;
	},

	remedy=>sub {my ($user, $target)=@_;
		status_cure($target,'negative');
		return ;
	},
	phoenix_soul=>sub {my ($caster, $target)=@_;
		for(get_grave()) {
			if(exists $graveyard{$_}){
				resurrect($_);
			}
		}
		return;
	},
	phoenix_tail=>sub {my ($caster, $target)=@_;
		if(exists $graveyard{$target}){
			resurrect($target);
		}else{
			say("There is no body of \2$target\2 to raise.");
		}
		return;
	},
	phoenix_down=>sub {my ($caster, $target)=@_;
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

sub hp_cure{ my ($user, $target,$amount)=@_;
	if(exists $characters{$user} && exists $characters{$target})
	{
		$characters{$target}->{hp}+=$amount;
		correct_points($target);
		say("\2$user\2 heals \2$target\2 for \2$amount\2 hp!");
		$characters{$user}->{xp}+=int($amount/20);
		correct_points($target);
	}
}
sub hp_cure_max{ my ($user, $target)=@_;
	if(exists $characters{$user} && exists $characters{$target})
	{
		$characters{$target}->{hp}+=$characters{$target}->{maxhp};
		correct_points($target);
		say("\2$user\2 fully heals \2$target\2!");
		$characters{$user}->{xp}+=30;
		correct_points($target);
	}
}
sub mp_cure{ my ($user, $target,$amount)=@_;
	if(exists $characters{$user} && exists $characters{$target})
	{
		$characters{$target}->{mp}+=$amount;
		correct_points($target);
		say("\2$user\2 heals \2$target\2 for \2$amount\2 mp!");
		$characters{$user}->{xp}+=int($amount/20);
		correct_points($target);
	}
}
sub mp_cure_max{ my ($user, $target)=@_;
	if(exists $characters{$user} && exists $characters{$target})
	{
		$characters{$target}->{mp}+=$characters{$target}->{maxmp};
		correct_points($target);
		say("\2$user\2 fills \2$target\2 mp!");
		$characters{$user}->{xp}+=30;
		correct_points($target);
	}
}

sub status_cure{ my ($target,$effect)=@_;
	my $status_cured = 'none';
	if(exists $characters{$target}) {
		if ($effect eq 'negative')
		{
			if(exists $negative_status{$characters{$target}->{seffect}}) {
				$status_cured = $characters{$target}->{seffect};
				$characters{$target}->{seffect} = 'none'
			}

		}
		else {
			if($characters{$target}->{seffect} eq $effect) {
				$status_cured = $characters{$target}->{seffect};
				$characters{$target}->{seffect} = 'none'
			}
		}
		if(!($status_cured eq 'none')) {
			say("\2$target\2's $status_cured is cured!");
		}
		else { say("Nothing happens."); }

	}
}

sub use_item{ my ($user,$target,$item)=@_;
	if($characters{$user}->{isresting} && exists $characters{monster}){
		sayto($caster, "You can't do that, you're resting!");
		return;
	}
	if( (exists $item_effect{$item}) && (exists $characters{$user}) && ((exists $characters{$target}) || $item eq 'phoenix_down' || $item eq 'phoenix_tail' || $item eq 'phoenix_soul') && (exists $items{$item}))
	{
		if($inv{$user}->{$item} >= 1) {
			say("\2$user\2 uses a \2$item\2 on \2$target\2!!");
			$inv{$user}->{$item} = $inv{$user}->{$item} - 1;
			&{$item_effect{$item}}($user,$target);
			delay($user,3);
		}else{
			sayto($user,"You dont have any of those!")
		}
	}
	else{sayto($user,"You can't use that!"); }
}