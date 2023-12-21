-- blipy sa podlaczone pod markery poniewaz przez createblip tworzy sie czerwona kropka zamiast normalnej ikonki

local blips = {

	-- GŁÓWNE --
	{-1942.79, 517.90, 35.17, 39}, -- Urząd
	{-2491.03, -28.96, 25.62, 45}, -- Przebieralnia
	{-2022.18, -859.69, 52.60, 55}, -- Gielda
	{-1897.30, 483.70, 35.17, 36}, -- OSK
	{-2635.23, 375.65, 6.16, 25}, -- Kasyno

	-- PRACE --
	{-1934.52, 577.26, 41.66, 46}, -- Zabka
	{-2888.55, 468.20, 62.16, 9}, -- Rybak
	{-1831.31, -67.11, 30.74, 46}, -- Magazynier/Kurier
	{213.216385,-181.677582,1.578125, 46}, -- Elektryk
	{-2267.04, 448.00, 43.72, 46}, -- Śmieciarki 
	{-2519.48, -612.38, 142.48, 46}, -- Kosiarki
	{-1834.36, 73.55, 26.72, 46}, -- Szambo

	-- SALONY --
	{-1820.72, 1326.83, 17.85, 55}, -- Cygan
	{-1964.77, 293.38, 49.10, 55}, -- Salon Doherty /W miare tani/
	{-931.44, -524.82, 25.95, 55}, -- Salon offroad
	{-1682.11, 1222.78, 17.85, 55}, -- Salon Drogi
	{1718.18, -1642.10, 13.55, 55}, -- Salon Drogi LS

	-- MECHANIKI/TUNERY --
	{1781.92, -1711.17, 13.58, 27}, -- Mechanik LS
	{-1734.42, -116.35, 29.65, 27}, -- Mechanik
	{-2036.42, 161.93, 62.16, 23}, -- Tuning mechaniczny
	{92.70, -164.94, 3.73, 23}, -- Tuning mechaniczny

    -- FRAKCJE --
    --{-1606.97, 692.50, 32.82, 30}, -- SAPD
	--{-49.94, -269.36, 6.63, 11}, -- SARA
	--{-2642.80, 635.44, 22.28, 22}, -- SAMC

}

for k,v in ipairs(blips) do
	createBlip(v[1], v[2], v[3], v[4], 2, 255, 255, 255, 255, 0, 350)
end