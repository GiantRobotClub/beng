
print("Loading class type lists...");

%goblin=(ogre=>'1',troll=>'1', ettin=>'1', frozen_imp=>'1', imp=>'1', giant=>'1', ogre_king=>'1');
%slimelist=(slime_guardian=>'1',slime=>'1', slime_king=>'1', slime_avenger=>'1', unicorn_jelly=>'1', metal_slime=>'1', slime_gang=>'1');
%dragons=(dragon_of_the_ice_cave=>'1', fire_dragon_of_the_ice_cave=>'1',drake=>'1', shadow_dragon=>'1', cosmic_dragon=>'1', stupid_looking_dragon=>'1', green_dragon=>'1', red_dragon=>'1', black_drake=>'1', senile_dragon=>'1');
%wolves=(werewolf=>'1',wolf=>'1', wolf_rider=>'1', alpha_wolf=>'1', ice_wolf=>'1', fire_wolf=>'1', robot_wolf=>'1', large_wolf=>'1');
%cans=(legend_in_a_can=>'1',unlabelled_can_of_mystery=>'1',monster_in_a_can=>'1', exp_in_a_can=>'1', can_of_whup_ass=>'1',god_in_a_can=>'1',can_of_wyrms=>'1',can_of_summon=>'1',ominous_can=>'1');
 %demons=(ultima_beast=>'1', diablo=>'1', lawyer=>'1', demon=>'1', ice_fiend=>'1',fire_fiend=>'1',damned_fairy=>'1',lost_soul=>'1',ghoul=>'1');
 %humans=(werewolf=>'1', slayer_knight=>'1', oracle=>'1', psionist=>'1', fighter=>'1', monk=>'1', ninja=>'1', thief=>'1', theif=>'1', robot=>'1', bard=>'1', mage=>'1', summoner=>'1',healer=>'1', harlot=>'1', skank=>'1', hag=>'1', wretch=>'1', hunter=>'1', dancer=>'1', mimic=>'1', witch_doctor=>'1', marathon_man=>'1', doctor=>'1', gumshoe=>'1', town_fool=>'1', constable=>'1', jesus=>'1', twink=>'1', holy_knight=>'1', sniper=>'1', lu_tze=>'1');




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
 @canned_monsters=(ettin,red_dragon,stupid_looking_dragon,slime_king,shadow_dragon,ghoul,doppelganger,senile_dragon);  # can stuff
 @canned_gods=(jesus,buddha,cosmic_dragon,jehovah,zeus,diablo);


print("Loading class descriptions..");
%class_desc=(
sniper=>'Uses guns exclusively, has aiming and sniping attacks.',
holy_knight=>'Specializing in mostly holy damage, a sword or mace user that has many sword skills.',
time_mage=>'The magic of time and space- with several demi-like attacks along with temporal magic, time_mage is an excellent support character',
slayer_knight=>'Has many skills which are based on the number of certian enemy types slain.',
oracle=>'A supporting class without much damage potential, an Oracle specializes in status effects.',
psionist=>'With some powerful attack spells and quite a few mp-altering spells, psionist is an excellent all-around class.',
angel=>'Has many holy based attacks and can raise people.',
demon=>'Dark, evil underworld creatures with many dark-based attacks!',
fighter=>'Standard sword-user',
monk=>'Physical attacker with high criticals.',
ninja=>'The ninja is a silent class, having many shadow-and-hide based attacks and ancient sword abilities.',
thief=>'The thief specializes in hiding and stealing, and gets 30% extra gold after battles.',
theif=>'Bad spelling, huh?',
robot=>'Beep destroy beep kill.  Although fairly weak early on, the Robot can do some massive damage with skills like gravity_bomb',
bard=>'Music soothes the savage beast, or kills it.  Has many interesting weapons',
mage=>'Offensive magician, with many powerful elemental attack spells.',
summoner=>'Studies monsters to learn to summon them to use their skills',
healer=>'White Mage, at your service.  One of the only classes able to raise and life people, and also has pretty good damage potential',
harlot=>'The worlds oldest profession',
dancer=>'Dance the night away with the Dancers smattering of odd effect spells.',
hunter=>'A weaker Fighter capable of hunting down specific monsters',
mimic=>'A do-everything class that can use all weapon types and can mimic people to use their abilities.',
dragonmaster=>'Legendary hero with the power of the four dragons.',
slime=>'Weak, but plentiful!',
unicorn_jelly=>'Like a slime, but different.',
doppelganger=>'Can perminently change into anything it wants.',
final_boss=>'Are you scared yet?',
final_boss_second_stage=>'I think you ARE scared yet.',
);

print("Loading classes...");
%classes=(

#drop_tester=>{gold=>1,user=>0,hp=>1,mp=>1,xp=>1,damage=>0,hitsas=>1,spells=>{}},
lu_tze=>{gold=>10000,user=>0,hp=>20000,mp=>3000,xp=>5000,damage=>100,hitsas=>50,spells=>{time_slice=>1,broom_hit=>1,sweep=>1,always_remember_Rule_One=>1}},
senile_dragon=>{gold=>300,user=>0,hp=>600,mp=>150,xp=>800,damage=>10,hitsas=>99,spells=>{get_off_my_damn_lawn=>1,gum_bite=>1}},

final_boss_second_stage=>{gold=>40000,user=>0,hp=>600000,mp=>40000,xp=>100000,damage=>500,hitsas=>50,spells=>{grand_cross=>1,fallen_one=>1,supernova=>1,blue_shockwave=>1,ultima=>1,all_ultima=>1},elem=>{holy=>'1.5',chem=>'1.5',dark=>'.75'}},
final_boss=>{gold=>40000,user=>0,hp=>10000,mp=>100000,xp=>50000,damage=>400,hitsas=>30,spells=>{gravity_bomb=>1, holy_explosion=>1, grudge=>1, blue_shockwave=>1, illness=>1}},

fire_guardian=>{gold=>7000,user=>0,hp=>10000,mp=>10000,xp=>10000,damage=>400,hitsas=>30,spells=>{flare=>1,fireball=>1,fireblast=>1,fire_breath=>1,slow_burn=>1,flame_dragon_sword=>1,inferno=>1},elem=>{ice=>'4',fire=>'-2'}},
ice_guardian=>{gold=>7000,user=>0,hp=>10000,mp=>10000,xp=>10000,damage=>400,hitsas=>30,spells=>{ice=>1,iceshard=>1,iceblast=>1,ice_breath=>1,freeze=>1,snowstorm=>1,absolute_zero=>1},elem=>{fire=>'4',ice=>'-2'}},
slime_guardian=>{gold=>7000,user=>0,hp=>10000,mp=>10000,xp=>10000,damage=>400,hitsas=>30,spells=>{slimesword=>1,slimebuster=>1,poison_dart=>1,poison=>1,regenerate=>1},elem=>{lit=>'4',chem=>'-2'}},
bolt_guardian=>{gold=>7000,user=>0,hp=>10000,mp=>10000,xp=>10000,damage=>400,hitsas=>30,spells=>{spark=>1,lightning=>1,shock=>1,storm=>1,taser=>1},elem=>{chem=>'4',lit=>'-2'}},
knight_guardian=>{gold=>7000,user=>0,hp=>10000,mp=>10000,xp=>10000,damage=>400,hitsas=>30,spells=>{stasis_sword=>1,minus_strike=>1,holy_explosion=>1,crush_punch=>1,lightning_stab=>1,revive=>1},elem=>{dark=>'2',holy=>'-1'}},
ethereal_guardian=>{gold=>7000,user=>0,hp=>10000,mp=>10000,xp=>10000,damage=>400,hitsas=>30,spells=>{ethereal_blade=>1,atma=>1,zapper=>1,pulse_wave=>1,regenerate=>1},elem=>{energy=>'0',finite=>'4'}},
shadow_guardian=>{gold=>7000,user=>0,hp=>10000,mp=>10000,xp=>10000,damage=>400,hitsas=>30,spells=>{gravity_bomb=>1,gravity_smash=>1,darkness=>1,unholy=>1,fissure=>1,devilish=>1},elem=>{holy=>'4',dark=>'-2'}},

doppelganger=>{gold=>200,user=>0,hp=>400,mp=>0,xp=>200,damage=>10,hitsas=>1,spells=>{doppelgang=>1,transform=>1}},
ultima_beast=>{gold=>4000,user=>0,hp=>5000,mp=>6000,xp=>6000,damage=>40,hitsas=>10,spells=>{ultima=>1,all_ultima=>1}},

#can of summon monsters for non-summoners=>
knights_of_the_round=>{user=>0,hp=>10000,mp=>30000,xp=>30000,damage=>3000,hitsas=>10,spells=>{ultimate_end=>1}},

ifrit=>{user=>0,hp=>5000,mp=>6000,xp=>10000,damage=>100,hitsas=>10,spells=>{fireball=>1,hell_fire=>1},elem=>{fire=>'-1',ice=>'3'}},
ramuh=>{user=>0,hp=>5000,mp=>6000,xp=>10000,damage=>100,hitsas=>10,spells=>{judgement_bolt=>1,lightning=>1},elem=>{lit=>'-1',chem=>'2'}},
shiva=>{user=>0,hp=>5000,mp=>6000,xp=>10000,damage=>100,hitsas=>10,spells=>{iceshard=>1,ice=>1,diamond_dust=>1,freeze=>1},elem=>{ice=>'-1',fire=>'3'}},
bahamut=>{user=>0,hp=>6000,mp=>6000,xp=>15000,damage=>200,hitsas=>10,spells=>{mega_flare=>1}},
diablos=>{user=>0,hp=>6000,mp=>6000,xp=>15000,damage=>200,hitsas=>10,spells=>{gravity_bomb=>1,gravity_smash=>1,dark_messenger=>1},elem=>{holy=>'2'}},

#wolf_cave
werewolf=>{gold=>1500,user=>0,hp=>1000,mp=>600,xp=>3000,damage=>30,hitsas=>10,spells=>{sniff=>1,howl=>1,wolfsbite=>1,wolfsbane=>1}},
alpha_wolf=>{gold=>1500,user=>0,hp=>2000,mp=>500,xp=>3000,damage=>20,hitsas=>10,spells=>{sniff=>1,howl=>1,wolfsbite=>1}},
ice_wolf=>{gold=>500,user=>0,hp=>400,mp=>300,xp=>700,damage=>10,hitsas=>5,spells=>{sniff=>1,howl=>1,ice=>1,ice_breath=>1},elem=>{fire=>'3',ice=>'-1'}},
fire_wolf=>{gold=>500,user=>0,hp=>400,mp=>300,xp=>700,damage=>10,hitsas=>5,spells=>{sniff=>1,howl=>1,flare=>1,fire_breath=>1},elem=>{fire=>'-1',ice=>'3'}},
robot_wolf=>{gold=>600,user=>0,hp=>1000,mp=>1000,xp=>1000,damage=>20,hitsas=>5,spells=>{sniff=>1,howl=>1,spark=>1,taser=>1,lightning=>1},elem=>{lit=>'3',fire=>'.5',chem=>'0',ice=>'.5'}},
large_wolf=>{gold=>600,user=>0,hp=>300,mp=>50,xp=>500,damage=>8,spells=>{sniff=>1,howl=>1}},


#sheildtest
#sheildtester=>{user=>1,hp=>700,mp=>700,xp=>10,damage=>10,spells=>{mpshield=>1, poison=>1, regen=>1, meteo=>1, assimilate=>1},win=>0},

#eternals
#lesser_eternal=>{user=>0,hp=>300,mp=>300,xp=>100,damage=>30,spells=>{termination_beam=>1,void_thunder=>3,dark_blade_nexrel=>6,eternal_rage=>6},elem=>{finite=>'100'}},
eternion=>{gold=>600000,user=>0,hp=>100000000,mp=>1000000,xp=>1000000,damage=>2000,hitsas=>99,spells=>{dark_blade_nexrel=>1,void_thunder=>1,termination_beam=>1},elem=>{finite=>'10000'}},


#fire_Cave for mid-level (around 3-10) characters
fire_fiend=>{gold=>150,user=>0,hp=>100,mp=>500,xp=>400,damage=>5,hitsas=>3,spells=>{flare=>1,fireball=>1},elem=>{fire=>'-1',ice=>'3'}},
bomb=>{gold=>300,user=>0,hp=>80,mp=>600,xp=>600,damage=>5,hitas=>5,spells=>{explode=>1,flare=>1},elem=>{fire=>'-1',ice=>'3'}},
burning_soldier=>{gold=>400,user=>0,hp=>300,mp=>300,xp=>600,damage=>6,hitsas=>6,spells=>{flare=>1,ghoulish=>1},elem=>{fire=>'-1',dark=>'0',ice=>'2',holy=>'3'}},
fire_spirit=>{gold=>2000,user=>0,hp=>2000,mp=>2000,xp=>1200,damage=>8,hitsas=>8,spells=>{flare=>1,fireball=>1,fire_breath=>1},elem=>{fire=>'-1',ice=>'2'}},

#freedom_fortress
#el_diablo=>{user=>0,hp=>400,mp=>100,xp=>10000,damage=>20,hitsas=>4,spells=>{tounges_of_flame=>1,inferno=>1,ignite=>1},elem=>{fire=>'-1',ice=>'3',chem=>'1.5'}},
#ice cave
frozen_imp=>{gold=>300,user=>0,hp=>200,mp=>100,xp=>600,damage=>20,hitsas=>5,spells=>{ice=>1},elem=>{fire=>'3',ice=>'-1'}},
dragon_of_the_ice_cave=>{gold=>4000,user=>0,hp=>8000,mp=>600,xp=>8000,damage=>20,hitsas=>30,spells=>{ice=>1,ice_breath=>1,freeze=>1,snowstorm=>1,red_paint=>1},elem=>{ice=>'-1',fire=>'3',sharp=>'1'}},
fire_dragon_of_the_ice_cave=>{gold=>4000,user=>0,hp=>8000,mp=>600,xp=>8000,damage=>20,hitsas=>30,spells=>{flare=>1, fireball=>1,fire_breath=>1,},elem=>{ice=>'3',fire=>'-1'}},

snow_puff=>{gold=>500,user=>0,hp=>5000,mp=>200,xp=>4000,damage=>5,hitsas=>5,spells=>{ice=>1,freeze=>1,snowstorm=>1},elem=>{fire=>'6', ice=>'0', energy=>'1.2', chem=>'0.001'}},
ice_fiend=>{gold=>400,user=>0,hp=>300,mp=>500,xp=>1000,damage=>0,hitsas=>20,spells=>{ice=>1,freeze=>1, iceshard=>1},elem=>{fire=>'3',ice=>'0.5'}},

#elem_testing
#fire_fiend=>{gold=>6000,user=>0,hp=>100,mp=>500,xp=>20,damage=>0,hitsas=>20,spells=>{},elem=>{fire=>'0.5',ice=>'3'}},
#elem_tester=>{user=>1,hp=>100,mp=>500,xp=>20,damage=>0,hitsas=>20,spells=>{fireball=>1,ice=>1,lightning=>1}},

#hell:
lost_soul=>{gold=>340,user=>0,hp=>700,mp=>500,xp=>700,damage=>42,hitsas=>20,spells=>{darkness=>1,ghoulish=>1,heal=>1},elem=>{holy=>'3', dark=>'0.5'}},
lawyer=>{gold=>1500,user=>0,hp=>500,mp=>100,xp=>500,damage=>30,hitsas=>15,spells=>{sue=>1}, elem=>{dark=>'-1'}},
diablo=>{gold=>3000,user=>0,hp=>60000,mp=>2000,xp=>10000,damage=>60,hitsas=>50,spells=>{ghoulish=>1,fallen_one=>1,regenerate=>1,unholy=>1,meteo=>1,vanish=>1,judgement_day=>1},elem=>{holy=>'4', fire=>'-1', dark=>'.5'}},
fairy=>{gold=>15,user=>0,hp=>10,mp=>0,xp=>10,damage=>-10,hitsas=>2,spells=>{},elem=>{holy=>'-1', dark=>'3'}},
damned_fairy=>{gold=>200,user=>0,hp=>1500,mp=>200,xp=>1500,damage=>20,hitsas=>10,spells=>{darkness=>1,revive=>1,fireball=>1},elem=>{holy=>'3', dark=>'0.5'}},

#players

#programmer=>{user=>0,hp=>80,mp=>100,xp=>80,damage=>10,spells=>{unholy=>1,negate=>2,heal_all=>3,damage_double=>4,slow_burn=>5,meditate=>6,paper_or_plastic=>7,defence_down=>8,gravity_bomb=>1,mind_drain=>9,assimilate=>10,taser=>11,mpshield=>12}},

dragonmaster=>{gold=>20,user=>0,hp=>60,mp=>300,xp=>60,throw=>1,damage=>15,spells=>{white_dragon_protect=>1,red_dragon_anger=>2,blue_dragon_healing=>3,black_dragon_grief=>4},weaptypes=>{accessory=>1,cloth=>1, knife=>1, book=>1, music=>1, glove=>1, sword=>1, gun=>1}},
sniper=>{gold=>15,user=>1,hp=>35,mp=>10,xp=>100,damage=>8,spells=>{aimshot=>1,hide=>3,sureshot=>5,arm_aim=>10,seal_evil=>20,leg_aim=>15,headshot=>20,ranged_shot=>25,machine_gun=>30,phosphorous=>40,cannon=>50},weaptypes=>{accessory=>1,gun=>1}},
time_mage=>{gold=>15,user=>1,hp=>30,mp=>20,xp=>120,damage=>10,spells=>{time_blip=>1,quick=>5,haste=>10,slow=>12,delay_action=>7,demi=>9,stop=>20,steal_time=>17,mini=>23,temporal_wave=>30,comet=>40,omega_blast=>50,every_one=>35},elem=>{dark=>'0',energy=>'2',lit=>'2'},weaptypes=>{accessory=>1,book=>1,wand=>1}},
holy_knight=>{gold=>15,user=>1,hp=>35,mp=>14,xp=>110,damage=>10,spells=>{minus_strike=>1,dash_and_slash=>5, lightning_stab=>7, atma=>10, blade_beam=>15, night_sword=>20,climhazzard=>25, stasis_sword=>3,holy_explosion=>30,crush_punch=>40,omnislash=>50},elem=>{holy=>'0',dark=>'1.5'},weaptypes=>{accessory=>1,sword=>1,wand=>1}},
slayer_knight=>{gold=>15,user=>1, hp=>40, mp=>30, xp=>130,damage=>10,spells=>{slimesword=>1,wolfsbite=>3,canopener=>5,demoneyes=>7,dragonkiller=>10,manslaughter=>13,soul_blast=>17,slimebuster=>19,wolfsbane=>20,cannerymaster=>25,demonking=>30,dragonslayer=>35,murder=>40,soul_sweep=>50},weaptypes=>{accessory=>1,sword=>1,knife=>1}},
oracle=>{gold=>15,user=>1,hp=>30,mp=>40,xp=>120,damage=>10,spells=>{regen=>1,mind_regen=>3,poison=>5,mpshield=>7,blunt=>10,damage_double=>15,defence_down=>20,protect=>25,return_damage=>30,slow_burn=>40},elem=>{energy=>'.5'},weaptypes=>{accessory=>1,book=>1,wand=>1,gun=>1}},
psionist=>{gold=>15,user=>1,hp=>20,mp=>40,xp=>110,damage=>7,spells=>{scan=>1, vanish=>2, vertigo=>5, mpshield=>3, damage_double=>15, element_reel=>9, blunt=>20, mind_drain=>8, pyrokinesis=>10, mind_regen=>30, pulse_wave=>50, telekinesis=>25, mind_blast=>35, slow_burn=>40, meditate=>24, sneak=>13},elem=>{energy=>'2'},weaptypes=>{accessory=>1,gun=>1,knife=>1}},
angel=>{gold=>15,user=>1,hp=>35,mp=>18,xp=>150,damage=>9,spells=>{regen=>6,preach=>1,fly=>3,cure=>2,wound=>5,raise=>8,damn=>15,heal=>20,omniscience=>25,revive=>35,life=>37,smite=>40,mind_regen=>30},elem=>{holy=>'-1', dark=>'3', energy=>'2'},weaptypes=>{accessory=>1,sword=>1,cloth=>1}}, 
demon=>{gold=>15,user=>1,hp=>40,mp=>20,xp=>160,damage=>10,spells=>{poison=>6,darkness=>4,raise=>9,devilish=>14,defence_down=>40,instill=>15,fissure=>25,omniscience=>30},elem=>{dark=>'-1', holy=>'3', energy=>'2'},weaptypes=>{accessory=>1,sword=>1,glove=>1}},  
fighter=>{gold=>15,user=>1,hp=>50,mp=>0,xp=>100,damage=>10,spells=>{},win=>0,weaptypes=>{accessory=>1,sword=>1,knife=>1}},
monk=>{gold=>15,user=>1,hp=>30,mp=>0,xp=>100,damage=>14,spells=>{},win=>0,elem=>{holy=>'.5', dark=>'2', fire=>'2'},weaptypes=>{accessory=>1,glove=>1}},
ninja=>{gold=>15,user=>1,hp=>30,mp=>12,xp=>120,throw=>1,damage=>12,spells=>{vanish=>2,return_damage=>35,smoke_bomb=>5,top_cut=>7,shadow_strike=>10,ethereal_blade=>23,cherry_blossom=>50, poison_dart=>30, flame_dragon_sword=>20},win=>0,elem=>{dark=>'.5', chem=>'2'},weaptypes=>{accessory=>1,knife=>1,glove=>1}},
thief=>{gold=>15,user=>1,hp=>30,mp=>12,xp=>120,damage=>6,throw=>1,spells=>{
hide=>1,sneak=>3,steal_item=>5,steal_gold=>2,backstab=>6,mug=>9,sneak_attack=>22,throw_gold=>25,steal_armor=>30,mind_drain=>40,plunder=>50, acid_bomb=>25, steal_heat=>32},win=>0,elem=>{dark=>'.5', chem=>'2'},weaptypes=>{accessory=>1,knife=>1, glove=>1}},
theif=>{gold=>15,user=>1,hp=>30,mp=>12,xp=>120,damage=>6,spells=>{lame=>1,duh=>1},win=>0,elem=>{fire=>'10', ice=>'10'},weaptypes=>{accessory=>1,wand=>1}},
robot=>{gold=>15,user=>1,hp=>40,mp=>10,xp=>100,damage=>8,spells=>{spark=>2,scan=>5,candy_beam=>10,taser=>15,lightning=>20,protect=>30,gravity_bomb=>26,assimilate=>50},win=>0,elem=>{lit=>'3', fire=>'.5', ice=>'.5', dark=>'-.5'},weaptypes=>{accessory=>1,glove=>1}},
bard=>{gold=>15,user=>1,hp=>25,mp=>10,xp=>100,damage=>5,spells=>{hide=>1,song=>2,harmony=>4,lullaby=>8,spoony=>10,serenade=>12,finite=>20,rock_and_roll=>50},win=>0,elem=>{dark=>'2', fire=>'2', chem=>'3', ice=>'2', energy=>'.1', holy=>'2'},weaptypes=>{accessory=>1,music=>1,cloth=>1, book=>1}},
mage=>{gold=>15,user=>1,hp=>30,mp=>20,xp=>150,damage=>5,
spells=>{flare=>1,spark=>2,ice=>3,fireball=>5,shock=>6,cure=>7,iceshard=>8,lightning=>10,iceblast=>11,unholy=>13,inferno=>21,storm=>22,absolute_zero=>23,heal=>17,ultima=>20,meteo=>25,poison=>30,slow_burn=>35,magic_missile=>50},win=>0,elem=>{dark=>'.5', energy=>'2', fire=>'.75', ice=>'.75', lit=>'.75'},weaptypes=>{accessory=>1,wand=>1, book=>1, knife=>1}},
summoner=>{gold=>15,user=>1,hp=>28,mp=>40,xp=>160,damage=>4,spells=>{},win=>0,weaptypes=>{accessory=>1,wand=>1, book=>1}},
healer=>{gold=>15,user=>1,hp=>40,mp=>20,xp=>120,damage=>8,spells=>{cure=>1,heal=>3,raise=>7,inexperienced_spellcaster=>9,dispell=>14,wound=>10,regen=>30,revive=>15,life=>20,heal_all=>25,negate=>50},win=>0,elem=>{dark=>'2', holy=>'-.5'},weaptypes=>{accessory=>1,wand=>1, book=>1}},
harlot=>{gold=>15,user=>1,hp=>20,mp=>30,xp=>80,damage=>2,spells=>{kiss=>1},win=>0,weaptypes=>{accessory=>1,cloth=>1, knife=>1}},
skank=>{gold=>15,user=>0,hp=>20,mp=>30,xp=>80,damage=>2,spells=>{skank_kiss=>1},win=>0,weaptypes=>{accessory=>1,cloth=>1, knife=>1}},
hag=>{gold=>15,user=>0,hp=>20,mp=>30,xp=>80,damage=>2,spells=>{hag_kiss=>1},weaptypes=>{accessory=>1,cloth=>1, knife=>1}},
wretch=>{gold=>15,user=>0,hp=>5,mp=>0,xp=>80,damage=>2,spells=>{},weaptypes=>{accessory=>1,cloth=>1, knife=>1}},
dancer=>{gold=>15,user=>1,hp=>30,mp=>20,xp=>150,damage=>5,spells=>{happy_dance=>2,waltz=>3,tansu_dance=>1,disco_fever=>5,sword_dance=>7,tangle_tango=>10,danse_macabre=>30,dance_of_special_words=>50,dance_of_the_sacred_spirits=>40},win=>0,weaptypes=>{accessory=>1,cloth=>1, knife=>1, music=>1}},
hunter=>{gold=>15,user=>1,hp=>50,mp=>0,xp=>110,damage=>10,spells=>{},weaptypes=>{accessory=>1,sword=>1, knife=>1}},
mimic=>{gold=>15,user=>1,hp=>40,mp=>0,xp=>150,damage=>6,spells=>{},weaptypes=>{accessory=>1,cloth=>1, knife=>1, book=>1, music=>1, glove=>1, sword=>1, gun=>1}},

#peanut_of_ultimate_peril=>{user=>0,hp=>9999,mp=>999,xp=>9999,damage=>120,spells=>{peanut_butter_is_very_very_sticky=>1}},

the_mall_after_being_exposed_to_radation_and_chemicals=>{gold=>1500,user=>0,hp=>1500,mp=>999,xp=>3000,damage=>20,spells=>{paper_or_plastic=>1,sam_the_record_man=>1,attention_shoppers=>1,on_sale=>1},elem=>{fire=>'2', chem=>'.5'}},

witch_doctor=>{gold=>800,user=>0,hp=>600,mp=>700,xp=>1800,damage=>20,spells=>{poison=>1,regen=>1,damage_double=>1,blunt=>1,slow_burn=>1,mpshield=>1}},
marathon_man=>{gold=>15000,user=>0,hp=>100000,mp=>100000,xp=>10000,damage=>30,spells=>{second_wind=>1,regenerate=>1,regen=>1,fireball=>1},elem=>{chem=>'2'}},
doctor=>{gold=>500,user=>0,hp=>1000,mp=>1000,xp=>2000,damage=>-200,spells=>{heal_you=>1,regenerate=>1,regen=>1,revive=>1,heal=>1,cure=>1}},

gumshoe=>{gold=>150,user=>0,hp=>1000,mp=>500,xp=>1000,damage=>30,spells=>{zapper=>1}},


slime_avenger=>{gold=>7777,user=>0,hp=>4000,mp=>500,xp=>8000,damage=>2,spells=>{grudge=>1},elem=>{lit=>'5',chem=>'-2'}},

unicorn_jelly=>{gold=>15,user=>1,hp=>10,mp=>5,xp=>60,damage=>20,spells=>{spark=>5,cure=>8},elem=>{lit=>'4', chem=>'-1'}},
town_fool=>{gold=>6,user=>1,hp=>30,mp=>14,xp=>30,damage=>4,spells=>{duh=>1}},
constable=>{gold=>6,user=>0,hp=>100,mp=>20,xp=>190,damage=>8,spells=>{heal=>1}},
exp_in_a_can=>{gold=>1,user=>0,hp=>1,mp=>0,xp=>100,damage=>0,spells=>{}},
ominous_can=>{gold=>0,user=>0,hp=>1,mp=>0,xp=>1,damage=>0,spells=>{}},
unlabelled_can_of_mystery=>{gold=>1,user=>0,hp=>1,mp=>0,xp=>100,damage=>0,spells=>{}},            
monster_in_a_can=>{gold=>1,user=>0,hp=>1,mp=>0,xp=>100,damage=>0,spells=>{}},
legend_in_a_can=>{gold=>1,user=>0,hp=>1,mp=>0,xp=>100,damage=>0,spells=>{}},
god_in_a_can=>{gold=>1,user=>0,hp=>1,mp=>0,xp=>100,damage=>0,spells=>{}},
can_of_summon=>{gold=>1,user=>0,hp=>1,mp=>0,xp=>50,damage=>0,spells=>{}},
can_of_wyrms=>{gold=>1,user=>0,hp=>1,mp=>0,xp=>100,damage=>0,spells=>{}},
can_of_whup_ass=>{gold=>150,user=>0,hp=>1000,mp=>1000,xp=>3000,hitsas=>16,damage=>100,spells=>{cannerymaster=>1,canopener=>1},win=>0},
auto_tinner=>{gold=>0,user=>0,hp=>100000000,mp=>100000000,xp=>10000,hitsas=>1000000,damage=>0,spells=>{auto_tin=>1}},
spider_man=>{gold=>150,user=>0,hp=>40,mp=>100,xp=>60,damage=>16,spells=>{web=>3},win=>0,elem=>{chem=>'.5'}},
evil_chair=>{gold=>5,user=>0,hp=>40,mp=>0,xp=>100,damage=>9,spells=>{},win=>0, elem=>{fire=>'2'}},
evil_pants=>{gold=>15,user=>0,hp=>60,mp=>0,xp=>150,hitsas=>2,damage=>9,spells=>{},win=>0, elem=>{fire=>'2'}},
slime=>{gold=>5,user=>1,hp=>10,mp=>2,xp=>40,damage=>3,spells=>{spark=>7,cure=>10,poison=>30,slow_burn=>50},win=>0,elem=>{lit=>'4', chem=>'-1'}}, #webrunner
imp=>{gold=>5,user=>0,hp=>30,mp=>0,xp=>60,damage=>6,spells=>{}},
gazelle=>{gold=>2,user=>0,hp=>50,mp=>0,xp=>80,hitsas=>1,damage=>8,spells=>{}},
lion=>{gold=>150,user=>0,hp=>150,mp=>10,xp=>475,hitsas=>5,damage=>20,spells=>{roar=>1}},
elephant=>{gold=>200,user=>0,hp=>400,mp=>0,xp=>1150,hitsas=>9,damage=>40,spells=>{}},
ogre=>{gold=>150,user=>0,hp=>200,mp=>0,xp=>400,hitsas=>6,damage=>20,spells=>{}},
ghoul=>{gold=>200,user=>0,hp=>200,mp=>200,xp=>700,hitsas=>6,damage=>20,spells=>{ghoulish=>1,mpshield=>1}},
ogre_king=>{gold=>3000,user=>0,hp=>6000,mp=>6000,xp=>10000,hitsas=>10,damage=>120,spells=>{gravity_smash=>1,ogre_wrath=>1}},
ettin=>{gold=>300,user=>0,hp=>600,mp=>0,xp=>1000,hitsas=>16,damage=>40,spells=>{},elem=>{sharp=>'2'}},
giant=>{gold=>400,user=>0,hp=>1800,mp=>10,xp=>2000,hitsas=>30,damage=>100,spells=>{sniff=>1}},
giant_spider=>{gold=>150,user=>0,hp=>500,mp=>100,xp=>2000,hitsas=>16,damage=>50,spells=>{web=>1,poison=>1}},
radioactive_spider=>{gold=>150,user=>0,hp=>500,mp=>100,xp=>3000,hitsas=>16,damage=>50,spells=>{web=>1,rbite=>1,poison=>1},elem=>{chem=>'.5',}},
black_drake=>{gold=>150,user=>0,hp=>400,mp=>150,xp=>1200,hitsas=>14,damage=>20,spells=>{acid_spray=>1,poison=>1},elem=>{holy=>'2', chem=>'.5', dark=>'-1'}},
troll=>{gold=>200,user=>0,hp=>800,mp=>400,xp=>2400,hitsas=>18,damage=>40,spells=>{regenerate=>1,regen=>1,mind_regen=>1},elem=>{fire=>'2'}},
wolf=>{gold=>2,user=>0,hp=>30,mp=>5,xp=>80,damage=>8,spells=>{sniff=>1}},
wolf_rider=>{gold=>2,user=>0,hp=>60,mp=>0,xp=>200,hitsas=>2,damage=>10,spells=>{}},
slime_gang=>{gold=>5,user=>0,hp=>30,mp=>6,xp=>100,hitsas=>2,damage=>9,spells=>{},elem=>{lit=>'4', chem=>'-1'}},
metal_slime=>{gold=>5,user=>0,hp=>60,mp=>300,xp=>600,hitsas=>4,damage=>10,spells=>{acid_shower=>1,heal=>1,protect=>1},elem=>{lit=>'4', chem=>'-1'}},
slime_king=>{gold=>6,user=>0,hp=>60,mp=>20,xp=>300,hitsas=>4,damage=>15,spells=>{cure=>1,spark=>1,regen=>1},elem=>{lit=>'4', chem=>'-1'}},
drake=>{gold=>20,user=>0,hp=>200,mp=>50,xp=>600,hitsas=>8,damage=>15,spells=>{flare=>1},elem=>{fire=>.5,ice=>1.5}},
stupid_looking_dragon=>{gold=>100,user=>0,hp=>100,mp=>120,xp=>900,damage=>20,spells=>{really_bad_breath=>1}},
green_dragon=>{gold=>1000,user=>0,hp=>500,mp=>120,xp=>1200,damage=>20,spells=>{poison_breath=>1, poison=>1},elem=>{chem=>'-1', energy=>'2'}},
red_dragon=>{gold=>1500,user=>0,hp=>1000,mp=>200,xp=>2400,damage=>30,spells=>{fire_breath=>1,slow_burn=>1},elem=>{ice=>'5', fire=>'-1'}},
shadow_dragon=>{gold=>4000,user=>0,hp=>3000,mp=>500,xp=>4800,damage=>50,spells=>{shadow_breath=>1,unholy=>1,ghoulish=>1,blunt=>1},elem=>{holy=>'3', dark=>'.2'}},
cosmic_dragon=>{gold=>13000,user=>0,hp=>20000,mp=>5000,xp=>10000,damage=>200,spells=>{shadow_breath=>1,fire_breath=>1,poison_breath=>1,negate=>1,revive=>1,meteo=>1}},
dragon_swarm=>{gold=>99999,user=>0,hp=>60000,mp=>50000,xp=>50000,damage=>5000,spells=>{breath_weapon_barrage=>1}},
jehovah=>{gold=>99999,user=>0,hp=>25000,mp=>20000,xp=>25000,hitsas=>200,damage=>500,spells=>{holy_wrath=>1,flood_the_earth=>1,judgement_day=>1,revive=>1,life=>1},elem=>{holy=>'-1'}},
zeus=>{gold=>99999,user=>0,hp=>25000,mp=>10000,xp=>25000,hitsas=>200,damage=>1000,spells=>{hurl_thunderbolt=>1,revive=>1},elem=>{holy=>'-1',lit=>'-1'}},
buddha=>{gold=>99,user=>0,hp=>10,mp=>100,xp=>1,hitsas=>50,damage=>0,spells=>{preach=>1},elem=>{holy=>'-1'}},
jesus=>{gold=>99,user=>0,hp=>10,mp=>100,xp=>1,hitsas=>50,damage=>0,spells=>{preach=>1},elem=>{holy=>'-1'}},
twink=>{gold=>0,user=>1,hp=>500,mp=>100,xp=>10,damage=>50,spells=>{flare=>1,cure=>1,heal=>2,spark=>2,ice=>3,heal=>4,fireball=>4,wound=>5,unholy=>6,revive=>8,meteo=>9,negate=>10},win=>0,elem=>{holy=>'-1'}},
);

# i have no idea what this stuff means... -j
# Then you're an idiot - w
print("Loading class aliases..");
%class_aliases=(
holy_swordsman=>'holy_knight',
arc_knight=>'holy_knight',
paladin=>'holy_knight',
gunman=>'sniper',
merc=>'sniper',
gunslinger=>'sniper',
dragonslayer=>'slayer_knight',
assassin=>'ninja',
knight=>'fighter',
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
ranger=>'hunter',
tracker=>'hunter',
mime=>'mimic',
);

print("Loading wierd death sequences...");
%weird_deaths=(
the_mall_after_being_exposed_to_radation_and_chemicals=>sub {my ($name,$killer)=@_;
	my $choice=rand_el('saying1','saying2','saying3','can_store');
	if(exists $characters{$killer}){
		                $characters{$killer}->{xp}+=500;
                correct_points($killer);
                say("\2$killer\2 defeats \2monster\2");
        }
	
	if ($choice eq 'saying1') {
		say("Unfortunately, that means you blew up the Electronics Boutique too.  Aww.");
		return 1;
	}
	elsif ($choice eq 'saying2') {
		say("Two-for one experience points sale, one time only");
		$characters{$killer}->{xp}+=1500;
                correct_points($killer);
		return 1;
	}
	elsif ($choice eq 'saying3') {
		say("That oughta give some people more time to do useful things...");
		return 1;
	}
	elsif ($choice eq 'can_store') {
		say("The can store in the mall was also destroyed, sending cans flying everywhere!");
			new_character('monster',
		 rand_el('legend_in_a_can','unlabelled_can_of_mystery','monster_in_a_can',
		  'exp_in_a_can', 'can_of_whup_ass','god_in_a_can','can_of_wyrms','can_of_summon'),
		 'impossible!ID@!@!@');
		return 0;
	}
	return 1;

	

},
gazelle=>sub{ my ($name,$killer)=@_;
        my $choice=rand_el('nothing','lion');
        if(exists $characters{$killer}){
                $characters{$killer}->{xp}+=80;
                correct_points($killer);
                #say("\2$killer\2 defeats \2monster\2");

        }
        delete $characters{$name};
        if($choice eq 'lion'){
                say("The blood attracts a fierce \2lion!\2");
                new_character('monster','lion','impossible!ID@!@!@');
				return 0;
        }
		return 1;

},
	final_boss_second_stage=>sub{ my ($name,$killer)=@_;
        say("[insert credits here]");
        return 1;
},
final_boss=>sub{ my ($name,$killer)=@_;
        say("Congrats!  You beat the final boss.. EXCEPT... final bosses have multiple stages!");
        new_character('monster','final_boss_second_stage','impossible!ID@!@!@');
        return 0;
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
ominous_can=>sub{ my ($name,$killer)=@_;
	say("It's full of \2hunter\2 meat!");
	return 1;
},

metal_slime=>sub{ my ($name,$killer)=@_;
	$slimes = $slimes + 1;
	if ($slimes > 100) {
		say('Oh no!  Your merciless slime killing has brought upon the wrath of the slime superhero.. THE SLIME AVENGER!');
		new_character('monster','slime_avenger','impossible!ID@!@!@'); $slimes = 0; return 0;
	}
	return 1;
},
ogre=>sub{ my ($name,$killer)=@_;
	$ogres = $ogres + 1;
	if (rand($ogres) > 100) {
		say('The King of the Ogres wants to have a word with you, Ogre Killer.');
		$ogres = 0;
		new_character('monster','ogre_king','impossible!ID@!@!@'); $slimes = 0; return 0;
	}
	return 1;
},
ettin=>sub{ my ($name,$killer)=@_;
	$ogres = $ogres + 1;
	if (rand($ogres) > 30) {
		say('The King of the Ogres wants to have a word with you, Ogre Killer.');
		$ogres = 0;
		new_character('monster','ogre_king','impossible!ID@!@!@'); $slimes = 0; return 0;
	}
	return 1;
},
giant=>sub{ my ($name,$killer)=@_;
	$ogres = $ogres + 1;
	if (rand($ogres) > 30) {
		say('The King of the Ogres wants to have a word with you, Ogre Killer.');
		$ogres = 0;
		new_character('monster','ogre_king','impossible!ID@!@!@'); $slimes = 0; return 0;
	}
	return 1;
},
slime=>sub{ my ($name,$killer)=@_;
	$slimes = $slimes + 1;
	if ($slimes > 100) {
		say('Oh no!  Your merciless slime killing has brought upon the wrath of the slime superhero.. THE SLIME AVENGER!');

		new_character('monster','slime_avenger','impossible!ID@!@!@'); $slimes = 0; return 0;
	}
	return 1;
},
slime_king=>sub{ my ($name,$killer)=@_;
	$slimes = $slimes + 1;
		if ($slimes > 100) {
					say('Oh no!  Your merciless slime killing has brought upon the wrath of the slime superhero.. THE SLIME AVENGER!');

		new_character('monster','slime_avenger','impossible!ID@!@!@'); $slimes = 0;return 0;
	}
	return 1;
},
slime_gang=>sub{ my ($name,$killer)=@_;
	$slimes = $slimes + 3;
	$slimeslayer = $slimeslayer + 2;
		if ($slimes > 100) {
					say('Oh no!  Your merciless slime killing has brought upon the wrath of the slime superhero.. THE SLIME AVENGER!');

		new_character('monster','slime_avenger','impossible!ID@!@!@'); $slimes = 0;return 0;
	}
	return 1;
},
unicorn_jelly=>sub{ my ($name,$killer)=@_;
	$slimes = $slimes + 1;
		if ($slimes > 100) {
					say('Oh no!  Your merciless slime killing has brought upon the wrath of the slime superhero.. THE SLIME AVENGER!');

		new_character('monster','slime_avenger','impossible!ID@!@!@'); $slimes = 0;return 0;
	}
	return 1;
},
unlabelled_can_of_mystery=>sub{ my ($name,$killer)=@_;
	say("You open the can to find...");
	my $choice=rand_el('exp','potion','insanity','nothing','dogfood',
	 'cure','slime','dragon','can','peaches','coca-cola','gold');
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
	}elsif($choice eq 'gold'){
		say("A treasure trove of gold!");
		say("\2$killer\2 is 1000 gold richer!");
		if(exists $characters{$killer}){
			$characters{$killer}->{gold}+=1000;

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
	}elsif($choice eq 'coca-cola'){
		say("Cool, refreshing Coca-Cola.");
		$dropped{coca_cola}= $dropped{coca_cola}+1;
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
		  'shadow_dragon','cosmic_dragon','dragon_of_the_ice_cave', 'fire_dragon_of_the_ice_cave'),
		 'impossible!ID@!@!@');
	}elsif($choice eq 'can'){
		say("Another can!");
		new_character('monster',
		 rand_el('legend_in_a_can','unlabelled_can_of_mystery','monster_in_a_can',
		  'exp_in_a_can', 'can_of_summon', 'can_of_whup_ass','god_in_a_can','can_of_wyrms'),
		 'impossible!ID@!@!@');
	}else{
		say("A \2bug\2 in the battle engine! (oops!)");
	}
	return 0;
},
can_of_summon=>sub{ my ($name,$killer)=@_;
	say("You open the can to find...");
	my $choice=rand_el('lollypop', 'alexander', 'ifrit','bahamut','ramuh','diablos','slime',
 'knights_of_the_round','slime','shiva','can','chocobo','slime','lollypop','non_fighter_monk',
		'wolf','wolf_rider','vampire','bizarre_cannery', 'giant_spider');
	delete $characters{$name};
	say("the secret to summoning \2$choice\2!!!");
	my $student = $killer;
		my $class = $choice;
	if($characters{$student}->{class} ne summoner){  
		say("Too bad \2$student\2 is not a \2summoner\2..."); 
		return 1;
	}
	if(exists $characters{$student}->{summons}->{$class}){
		say("Too bad \2$student\2 already knew how to summon \2$class\2...");
		return 1;
	}
	$characters{$student}->{summons}->{$class}=$summons{$class};    # add that summon to the list
        say("and \2$student\2 learns to summon \2$class\2!");           # tell everyone
        $characters{$student}->{xp}+=50;                                # give xp
        correct_points($student);
	return 1;
},

monster_in_a_can=>sub{ my ($name,$killer)=@_;
	my $new_monster=$canned_monsters[int(rand(scalar(@canned_monsters)))];
	say("You've opened a can of \2$new_monster\2!");
	new_character('monster', $new_monster, 'impossible!ID@!@!@');
	return 0;
},
legend_in_a_can=>sub{ my ($name,$killer)=@_;
	my $new_monster=rand_el('ogre_king','slime_avenger','eternion','cosmic_dragon','final_boss');
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
slime_avenger=>sub{ my ($name,$killer)=@_;
	say("<Slime Avenger> I...impossible.  I must.. fight... for the common slime... ugh....");
	return 1;
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


print("Loading areas...");

%areas=(
	final_boss_dungeon=>{
		ultima_beast=>100,
		doppelganger=>10,
		shadow_guardian=>10,
		ethereal_guardian=>10,
		knight_guardian=>10,
		bolt_guardian=>10,
		slime_guardian=>10,
		ice_guardian=>10,
		fire_guardian=>10,
		final_boss=>1,
	},

	wolf_cave=>{
		wolf=>70,
		wolf_rider=>60,
		large_wolf=>50,
		fire_wolf=>50,
		ice_wolf=>50,
		robot_wolf=>30,
		alpha_wolf=>1,
		werewolf=>1,
	},
	ice_cave=>{
		ice_fiend=>50,
		frozen_imp=>100,
		snow_puff=>10,
		fire_dragon_of_the_ice_cave=>1,
		dragon_of_the_ice_cave=>1,
	},

	hometown_plains=>{
		slime=>1000,
		unicorn_jelly=>1,
		robot=>100,
		evil_chair=>10,
		evil_pants=>5,
		exp_in_a_can=>200,
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
		exp_in_a_can=>50,
		can_of_summon=>20,
		monster_in_a_can=>15,
		can_of_whup_ass=>5,
		unlabelled_can_of_mystery=>35,
		god_in_a_can=>1,
		can_of_wyrms=>1,
		legend_in_a_can=>2,
	},
	ogre_pit=>{
		ogre=>100,
		ettin=>40,
		giant=>4,
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
		sniper=>30,
		holy_knight=>20,
		slayer_knight=>20,
		mage=>50,
		fighter=>40,
		ninja=>30,
		town_fool=>30,
		constable=>10,
		bard=>30,
		angel=>30,
		demon=>30,
		summoner=>30,
		oracle=>30,
		psionist=>30,
		theif=>30,
		dancer=>30,

	},
	#drop_test=>{drop_tester=>1,},
	hell=>{
		diablo=>5,
		fairy=>5,
		lost_soul=>20,
		lawyer=>20,
	},
	downtown=>{
		witch_doctor=>100,
		skank=>25,
		hag=>25,
		wretch=>25,
		doctor=>75,
		marathon_man=>25,
		constable=>25,
		gumshoe=>25,
		the_mall_after_being_exposed_to_radation_and_chemicals=>25,
	},
	fire_cave=>{
			fire_fiend=>20,
			bomb=>18,
			burning_soldier=>16,
			fire_spirit=>1
	},
	old_monsters_home=>{
				wretch=>30,
				senile_dragon=>30,
				lu_tze=>1,
			},
);



#khrimas_tower=>{
#army_of_khrima=>50,
#guardbot=>1,
#army_of_khrima_elite=>4,
#},
#tower_second_floor=>{
#army_of_khrima=>40,
#robot_drake=>1,
#exploding_robot=>25,
#army_of_khrima_elite=>25,
#},
#tower_third_floor=>{
#army_of_khrima=>10,
#spybot_prototype=>10,
#army_of_khrima_elite=>20,
#exploding_robot=>10,
#tiny_robot_pirate=>1,
#bard=>8,
#the_axe=>4
#},
#tower_fourth_floor=>{
#army_of_khrima=>5,
#spybot_prototype=>5,
#army_of_khrima_elite=>7,
#exploding_robot=>5,
#guardbot=>7,
#ninja=>8,
#mizuna=>4
#},
#tower_fifth_floor=>{
#army_of_khrima=>5,
#spybot_prototype=>5,
#army_of_khrima_elite=>7,
#exploding_robot=>5,
#guardbot=>6,
#monk=>8,
#robot_drake=>1,
#punching_guy=>4,
#},
#tower_sixth_floor=>{
#robot_drake=>5,
#fighter=>5,
#army_of_khrima_elite=>5,
#army_of_khrima=>5,
#guardbot=>6,
#silver_haired_guy=>4,
#},
#tower_apex=>{
#khrima_shadow=>6,
#khrima=>1
#},
