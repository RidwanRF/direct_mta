local animations = {
    {'sex2', 'sex', 'sex_1_cum_w', true, false},
    {'sex1', 'sex', 'sex_1_cum_p', true, false},
    {'dzwonisz', 'ped', 'phone_in', false, false},
    ['rece'] = {'ped', 'handsup', false, false},
    ['taichi'] = {'PARK', 'Tai_Chi_Loop', true, false},
    ['predator'] = {'BSKTBALL', 'BBALL_def_loop', true, false},
    ['podkrecasz'] = {'BAR', 'Barserve_glass', false, false},
    ['podsluchujesz'] = {'BAR', 'Barserve_order', false, false},
    ['pijesz'] = {'BAR', 'dnk_stndM_loop', true, false},
    ['taniec'] = {'CHAINSAW', 'CSAW_Hit_2', true, true},
    ['taniec2'] = {'SKATE', 'skate_idle', true, false},
    ['taniec3'] = {'STRIP', 'strip_B', true, false},
    ['taniec4'] = {'DANCING', 'dance_loop', true, false},
    ['taniec5'] = {'DANCING', 'DAN_Down_A', true, false},
    ['taniec6'] = {'STRIP', 'strip_G', true, false},
    ['taniec7'] = {'STRIP', 'STR_C2', true, false},
    ['taniec8'] = {'DANCING', 'dnce_M_b', true, false},
    ['taniec9'] = {'DANCING', 'DAN_Loop_A', true, false},
    ['taniec10'] = {'DANCING', 'dnce_M_d', true, false},
    ['taniec11'] = {'STRIP', 'strip_D', true, false},
    ['taniec12'] = {'STRIP', 'strip_E', true, false},
    ['taniec13'] = {'STRIP', 'STR_Loop_A', true, false},
    ['taniec14'] = {'STRIP', 'STR_Loop_B', true, false},
    ['taniec15'] = {'FINALE', 'FIN_Cop1_Stomp', true, false},
    ['taniec16'] = {'DANCING', 'dnce_M_a', true, false},
    ['taniec17'] = {'GFUNK', 'Dance_G10', true, false},
    ['taniec18'] = {'GFUNK', 'Dance_G11', true, false},
    ['taniec19'] = {'GFUNK', 'Dance_G12', true, false},
    ['taniec20'] = {'RUNNINGMAN', 'Dance_B1', true, false},
    ['palisz'] = {'LOWRIDER', 'M_smklean_loop', true, false},
    ['lezysz'] = {'BEACH', 'Lay_Bac_Loop', true, false},
    ['lezysz2'] = {'CRACK', 'crckidle2', true, false},
    ['lezysz3'] = {'CRACK', 'crckidle4', true, false},
    ['lezysz4'] = {'BEACH', 'ParkSit_W_loop', false, false},
    ['lezysz5'] = {'BEACH', 'SitnWait_loop_W', true, false},
    ['siedzisz'] = {'BEACH', 'ParkSit_M_loop', true, false},
    ['siedzisz2'] = {'INT_OFFICE', 'OFF_Sit_Idle_Loop', true, false},
    ['siedzisz3'] = {'JST_BUISNESS', 'girl_02', false, false},
    ['klekasz'] = {'CAMERA', 'camstnd_to_camcrch', false, false},
    ['klekasz2'] = {'COP_AMBIENT', 'Copbrowse_nod', true, false},
    ['czekasz'] = {'COP_AMBIENT', 'Coplook_loop', true, false},
    ['akrobata'] = {'DAM_JUMP', 'DAM_Dive_Loop', false, false},
    ['msza'] = {'DEALER', 'DEALER_IDLE', true, false},
    ['msza2'] = {'GRAVEYARD', 'mrnM_loop', false, false},
    ['znakkrzyza'] = {'GANGS', 'hndshkcb', true, false},
    ['rzygasz'] = {'FOOD', 'EAT_Vomit_P', true, false},
    ['jesz'] = {'FOOD', 'EAT_Burger', true, false},
    ['cpun1'] = {'GANGS', 'drnkbr_prtl', true, false},
    ['cpun2'] = {'GANGS', 'smkcig_prtl', true, false},
    ['cpun3'] = {'CRACK', 'Bbalbat_Idle_01', true, false},
    ['cpun4'] = {'CRACK', 'Bbalbat_Idle_02', true, false},
    ['witasz'] = {'GANGS', 'hndshkba', true, false},
    ['rozmawiasz'] = {'GANGS', 'prtial_gngtlkH', true, false},
    ['rozmawiasz2'] = {'GANGS', 'prtial_gngtlkG', true, false},
    ['rozmawiasz3'] = {'GANGS', 'prtial_gngtlkD', true, false},
    ['nerwowy'] = {'GHANDS', 'gsign2', true, false},
    ['piszesz'] = {'INT_OFFICE', 'OFF_Sit_Type_Loop', true, false},
    ['gay'] = {'ped', 'WOMAN_walksexy', true, true},
    ['gay2'] = {'ped', 'WOMAN_walkpro', true, true},
    ['gay3'] = {'ped', 'WOMAN_runsexy', true, true},
    ['wreczasz'] = {'KISSING', 'gift_give', false, false},
    ['machasz'] = {'KISSING', 'gfwave2', true, false},
    ['walisz'] = {'PAULNMAC', 'wank_loop', true, false},
    ['walisz2'] = {'MISC', 'Scratchballs_01', true, false},
    ['sikasz'] = {'PAULNMAC', 'Piss_loop', true, false},
    ['pijany'] = {'ped', 'WALK_drunk', true, true},
    ['pijany2'] = {'PAULNMAC', 'PnM_Loop_A', true, false},
    ['pijany3'] = {'PAULNMAC', 'PnM_Argue2_A', true, false},
    ['rapujesz'] = {'SCRATCHING', 'scmid_l', true, false},
    ['rapujesz2'] = {'SCRATCHING', 'scdldlp', true, false},
    ['rapujesz3'] = {'Flowers', 'Flower_Hit', true, false},
    ['rapujesz4'] = {'RAPPING', 'RAP_C_Loop', true, false},
    ['rapujesz5'] = {'RAPPING', 'RAP_B_Loop', true, false},
    ['rapujesz6'] = {'SCRATCHING', 'scdrdlp', true, false},
    ['rapujesz7'] = {'SCRATCHING', 'scdrulp', true, false},
    ['rapujesz8'] = {'RAPPING', 'RAP_A_Loop', true, false},
    ['rolki'] = {'SKATE', 'skate_run', true, true},
    ['rolki2'] = {'SKATE', 'skate_sprint', true, true},
    ['umierasz'] = {'ped', 'FLOOR_hit_f', false, false},
    ['umierasz2'] = {'ped', 'FLOOR_hit', false, false},
    ['bijesz'] = {'BASEBALL', 'Bat_M', true, false},
    ['bijesz2'] = {'RIOT', 'RIOT_PUNCHES', true, false},
    ['bijesz3'] = {'FIGHT_B', 'FightB_M', true, false},
    ['bijesz4'] = {'MISC', 'bitchslap', true, false},
    ['bijesz5'] = {'ped', 'BIKE_elbowR', true, false},
    ['wolasz'] = {'RYDER', 'RYD_Beckon_01', true, false},
    ['wolasz2'] = {'POLICE', 'CopTraf_Come', true, false},
    ['wolasz3'] = {'RYDER', 'RYD_Beckon_02', true, false},
    ['zatrzymujesz'] = {'POLICE', 'CopTraf_Stop', true, false},
    ['wskazujesz'] = {'SHOP', 'ROB_Loop', true, false},
    ['rozgladasz'] = {'ON_LOOKERS', 'lkaround_loop', true, false},
    ['krzyczysz'] = {'ON_LOOKERS', 'shout_in', true, false},
    ['fuckyou'] = {'RIOT', 'RIOT_FUKU', true, false},
    ['tchorz'] = {'ped', 'cower', false, false},
    ['kopiesz'] = {'GANGS', 'shake_carK', true, false},
    ['kopiesz2'] = {'FIGHT_D', 'FightD_G', true, false},
    ['kopiesz3'] = {'FIGHT_C', 'FightC_3', false, false},
    ['wywazasz'] = {'GANGS', 'shake_carSH', true, false},
    ['wywazasz2'] = {'POLICE', 'Door_Kick', true, false},
    ['kieszen'] = {'GANGS', 'leanIDLE', true, false},
    ['celujesz'] = {'ped', 'ARRESTgun', false, false},
    ['kichasz'] = {'VENDING', 'vend_eat1_P', true, false},
    ['pocalunek'] = {'BD_FIRE', 'Grlfrd_Kiss_03', true, false},
    ['taxi'] = {'MISC', 'Hiker_Pose', false, false},
    ['taxi2'] = {'MISC', 'Hiker_Pose_L', false, false},
    ['noga'] = {'SHOP', 'SHP_Jump_Glide', false, false},
    ['pozegnanie'] = {'BD_FIRE', 'BD_Panic_03', true, false},
    ['cud'] = {'CARRY', 'crry_prtial', true, false},
    ['cud2'] = {'ON_LOOKERS', 'Pointup_loop', false, false},
    ['delirium'] = {'CRACK', 'crckdeth1', false, false},
    ['delirium2'] = {'CRACK', 'crckdeth2', true, false},
    ['delirium3'] = {'CRACK', 'crckidle3', true, false},
    ['delirium4'] = {'CHAINSAW', 'csaw_part', true, false},
    ['delirium5'] = {'CASINO', 'Roulette_loop', true, false},
    ['naprawiasz'] = {'CAR', 'flag_drop', true, false},
    ['naprawiasz2'] = {'CAR', 'Fixn_Car_Loop', true, false},
    ['placzesz'] = {'GRAVEYARD', 'mrnF_loop', true, false},
    ['kibicujesz'] = {'RIOT', 'RIOT_ANGRY_B', true, false},
    ['kibicujesz2'] = {'ON_LOOKERS', 'wave_loop', true, false},
    ['bioenergoterapeuta'] = {'WUZI', 'Wuzi_Greet_Wuzi', true, false},
    ['meteorolog'] = {'WUZI', 'Wuzi_grnd_chk', true, false},
    ['klepiesz'] = {'SWEET', 'sweet_ass_slap', true, false},
    ['cierpisz'] = {'SWEET', 'Sweet_injuredloop', true, false},
    ['starzec'] = {'ped', 'WALK_shuffle', true, true},
    ['starzec2'] = {'ped', 'WOMAN_walkfatold', true, true},
    ['starzec3'] = {'ped', 'WOMAN_walkshop', true, true},
    ['reanimujesz'] = {'MEDIC', 'CPR', false, false},
    ['myjesz'] = {'CASINO', 'dealone', true, false},
    ['zadowolony'] = {'CASINO', 'manwind', true, false},
    ['zadowolony2'] = {'CASINO', 'manwinb', true, false},
    ['zalamany'] = {'CASINO', 'Roulette_lose', true, false},
    ['zmeczony'] = {'FAT', 'IDLE_tired', true, false},
    ['ochnie'] = {'MISC', 'plyr_shkhead', true, false},
    ['cwaniak1'] = {'GHANDS', 'gsign1', true, false},
    ['cwaniak2'] = {'GHANDS', 'gsign1LH', true, false},
    ['cwaniak3'] = {'GHANDS', 'gsign2', true, false},
    ['cwaniak4'] = {'GHANDS', 'gsign2LH', true, false},
    ['cwaniak5'] = {'GHANDS', 'gsign3', true, false},
    ['cwaniak6'] = {'GHANDS', 'gsign3LH', true, false},
    ['cwaniak7'] = {'GHANDS', 'gsign4', true, false},
    ['cwaniak8'] = {'GHANDS', 'gsign4LH', true, false},
    ['cwaniak9'] = {'GHANDS', 'gsign5', true, false},
    ['cwaniak10'] = {'GHANDS', 'gsign5LH', true, false},
    ['pijak'] = {'CRACK', 'crckidle4', true, false},
}

function stopAnimacja(plr)
    setPedAnimation(plr, false)
    unbindKey(plr, 'ENTER', 'down', stopAnimacja)
end

function useAnimation(player, animation)
    local animation = animations[animation]
    if not animation then return end

    if getElementData(player, 'player:job') then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie możesz użyć animacji będąc w pracy') end
    if not isPedOnGround(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Musisz stać na ziemi, aby użyć animacji') end
    if getPedOccupiedVehicle(player) then return exports['borsuk-notyfikacje']:addNotification(player, 'error', 'Błąd', 'Nie możesz użyć animacji będąc w pojeździe') end

    bindKey(player, 'ENTER', 'down', stopAnimacja)
    setPedAnimation(player, animation[1], animation[2], -1, animation[3], animation[4])
end

for k,v in pairs(animations) do
    addCommandHandler(k, useAnimation)
end