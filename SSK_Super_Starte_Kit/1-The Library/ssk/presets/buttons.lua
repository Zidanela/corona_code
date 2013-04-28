-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
-- =============================================================
-- Buttons Presets
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
--
-- DO NOT MODIFY THIS FILE.  MODIFY "data/buttons.lua" instead.
--
-- =============================================================
--
-- labelsInit.lua - Create Label Presets
--
local mgr = ssk.buttons

-- ============================
-- ========= DEFAULT BUTTON
-- ============================
local default_params = 
{ 
	textColor			= _WHITE_,
	fontSize			= 16,
	textFont			= native.systemFontBold,
	unselRectFillColor	= _DARKGREY_,
	selRectFillColor	= _GREY_,

	--unselRectGradient  = graphics.newGradient ( { 170, 170, 170, 255  }, { 64, 64, 64, 255 }, "down" ),
	--selRectGradient    = graphics.newGradient ( { 200, 200, 200, 255  }, { 94, 94, 94, 255 }, "down" ),
	strokeWidth        = 1,
    strokeColor        = {1,1,1,128},
	textOffset         = {0,1},
	emboss             = false,	
}
mgr:addPreset( "default", default_params )


-- ============================
-- ======= Default Check/Radio Box
-- ============================
local params = 
{ 
	unselImgSrc  = imagesDir .. "interface/check.png",
	selImgSrc    = imagesDir .. "interface/checkOver.png",
	strokeWidth        = 1,
    strokeColor        = {1,1,1,128},
}
mgr:addPreset( "defaultcheck", params )


-- ============================
-- ================== RG BUTTON
-- ============================
local params = 
{ 
	unselImgSrc  = imagesDir .. "badges/rg.png",
	selImgSrc    = imagesDir .. "badges/rg.png",
}
mgr:addPreset( "RGButton", params )

-- ============================
-- ======= Corona  BADGE/BUTTON 150 x 144
-- ============================
local params = 
{ 
	unselImgSrc  = imagesDir .. "badges/coronaBadge_smallt.png",
	selImgSrc    = imagesDir .. "badges/coronaBadge_smallt.png",
}
mgr:addPreset( "CoronaButton", params )


-- ============================
-- ======= Corona  BADGE/BUTTON 75 x 72
-- ============================
params.buttonOverlayRectColor = nil
params.unselImgSrc = imagesDir .. "badges/coronaBadge_tinyt.png"
params.selImgSrc   = imagesDir .. "badges/coronaBadge_tinyt.png"
params.unselRectEn = false
params.selRectEn   = false
params.strokeWidth = 0
mgr:addPreset( "CoronaButtonTiny", params )

