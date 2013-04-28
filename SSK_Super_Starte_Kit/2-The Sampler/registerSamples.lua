-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================
-- main.lua
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
-- =============================================================

-- ================= OPEN CLOSE TESTING (BEGIN)
--
openCloseTestingMinDelay = 66 -- 250
openCloseTestingMaxDelay = 67 -- 1500

-- Automatically open-close-open-... first example in list
enableOpenCloseTesting = true
enableOpenCloseTesting = false

-- Automatically open-close-open-... random example in list
enableRandomOpenCloseTesting = true
enableRandomOpenCloseTesting = false

-- Automatically open first example in list (useful while editing that sample)
-- Above settings take precedence
enableAutoLoad = true
enableAutoLoad = false
-- ================= OPEN CLOSE TESTING (END)

--sampleManager:addSample("SSKCorona Feature Testing", "Inputs - Joystick (Normal)", "featureTesting.inputs.joystick1_logic" )
--sampleManager:addSample("SSKCorona Feature Testing", "Sequencer", "featureTesting.sequencer.template1", true ) -- SMALL SCREEN BUTTONS

-- TEMPLATES
--sampleManager:addSample("Template", "Template 1", "_templates.template1", true ) -- SMALL SCREEN BUTTONS
--sampleManager:addSample("Template", "Template 2", "_templates.template2", true )  -- FULL SCREEN NO BUTTONS 
--sampleManager:addSample("Template", "Template 3", "_templates.template3", true )  -- Nearly Empty Shell
--sampleManager:addSample("Template", "Benchmark Template 1: Operations Per Second", "_templates.template3_benchmark_OPS", true ) 
--sampleManager:addSample("Template", "Benchmark Template 2: Operation vs. Operation", "_templates.template4_benchmark_OPVS", true ) 
--sampleManager:addSample("Template", "Template 5 - Code Samples", "_templates.template5_CodeSamples", true )  -- Nearly Empty Shell


-- WORKS IN PROGRESS (WIP)
--EFMsampleManager:addSample("SSKCorona Feature Testing", "Game Piece Class", "featureTesting.gamePiece.test1", true )


-- OFFLINE WIPs
--sampleManager:addSample("SSKCorona Feature Testing", "Path Following", "featureTesting.components.pathfollowing" )

-- =============================================
-- Forums Help (EFM add forum entry links in each example)
-- =============================================
sampleManager:addSample("Forums Help", "121113 - Quick question on transitions", "forumhelp.121113_quick_question_on_transitions", true )  -- FULL SCREEN NO BUTTONS 
sampleManager:addSample("Forums Help", "121111 - Image objects size change ...", "forumhelp.121111_image_objects_size_change")
sampleManager:addSample("Forums Help", "121029 - ... changing .. orientation (alternative)", "forumhelp.121029_manually_changing_screen_orientation")
sampleManager:addSample("Forums Help", "121028 - Visually vibrating object", "forumhelp.121028_vibrating_object")
sampleManager:addSample("Forums Help", "121027 - Touch does not end ... offscreen", "forumhelp.121027_touch_does_not_end_offscreen" )
sampleManager:addSample("Forums Help", "121023 - Dragging objects ... like a puzzle", "forumhelp.121023_dragging-objects-specific-location-puzzle")
sampleManager:addSample("Forums Help", "121023 - Dragging objects ... like a puzzle (part 2)", "forumhelp.121023_dragging-objects-specific-location-puzzle2")
sampleManager:addSample("Forums Help", "121020 - Getting Sprite to Jump Forward", "forumhelp.121020_sprite_jump_forward" )
sampleManager:addSample("Forums Help", "121015 - Display ellipse with an angle", "forumhelp.121015_display_ellipse_with_angle" )
sampleManager:addSample("Forums Help", "121008 - Calculating intersecting lines", "forumhelp.121008_calculating_intersecting_lines" )
sampleManager:addSample("Forums Help", "121008 - Countdown Help", "forumhelp.121008_countdown_help" )
sampleManager:addSample("Forums Help", "120815 - Looking to make drawer", "forumhelp.120815_sliding_drawer" )



-- =============================================
-- SSKCorona Feature Testing (i.e. Validation)
-- =============================================
-- ==
-- Behavior Tests (EFM convert to component)
-- ==
--COMP sampleManager:addSample("SSKCorona Feature Testing", "Drag-n-Drop", "featureTesting.components.dragNDrop_logic" )

-- ==
-- Component Tests (EFM convert to component)
-- ==
-- Facing
--COMP sampleManager:addSample("SSKCorona Feature Testing", "Face Point (Touch)", "featureTesting.components.faceTouch_logic" )
--COMP sampleManager:addSample("SSKCorona Feature Testing", "Face Point (Touch) @ Fixed Rate", "featureTesting.components.faceTouchFixedRate_logic" ) 

-- Moving
--COMP sampleManager:addSample("SSKCorona Feature Testing", "Move To Point (Touch)", "featureTesting.components.moveToTouch_logic" )
--COMP sampleManager:addSample("SSKCorona Feature Testing", "Move To Point (Touch) @ Fixed Rate", "featureTesting.components.moveToTouchFixedRate_logic" )

-- Aiming (EFM broken; math?; behaviors?)
--COMP sampleManager:addSample("SSKCorona Feature Testing", "Aim At Object #1", "featureTesting.components.aimAtObject_logic" ) 
--COMP sampleManager:addSample("SSKCorona Feature Testing", "Aim At Object #2 (Distance Limit)", "featureTesting.components.aimAtObject2_logic" )

-- Wrapping
--COMP sampleManager:addSample("SSKCorona Feature Testing", "Wrap Point (Screen Wrap)", "featureTesting.components.wrapping1_logic" )

-- Path Following (EFM - WIP)
--sampleManager:addSample("SSKCorona Feature Testing", "Path Following", "featureTesting.components.pathfollowing" )


-- ==
-- Networking Utilities & External Networking Classes Tests
-- ==
sampleManager:addSample("SSKCorona Feature Testing", "UDP Auto-Connect", "featureTesting.networking.autoconnect" )
sampleManager:addSample("SSKCorona Feature Testing", "UDP Manual Connect", "featureTesting.networking.manualconnect" )


-- ==
-- Button Factory Tests
-- ==
sampleManager:addSample("SSKCorona Feature Testing", "Push Buttons", "featureTesting.buttons.pushButtonsTest_logic" )
sampleManager:addSample("SSKCorona Feature Testing", "Toggle Buttons", "featureTesting.buttons.toggleButtonsTest_logic" )
sampleManager:addSample("SSKCorona Feature Testing", "Radio Buttons", "featureTesting.buttons.radioButtonsTest_logic" )
sampleManager:addSample("SSKCorona Feature Testing", "Sliders", "featureTesting.buttons.slidersTest_logic" )
sampleManager:addSample("SSKCorona Feature Testing", "Standard Button Callbacks", "featureTesting.buttons.buttonCallbacksTest_logic" )
sampleManager:addSample("SSKCorona Feature Testing", "Push Button Masks", "featureTesting.buttons.pushButtonMasks", true )

-- ==
-- Label Factory Tests
-- ==
sampleManager:addSample("SSKCorona Feature Testing", "Labels", "featureTesting.labels.labels_logic" )

-- ==
-- HUDs (EFM need more snazzy huds soon)
-- ==
sampleManager:addSample("SSKCorona Feature Testing", "HUDs 1 - Numeric Meters", "featureTesting.huds.numericmeter_logic" )
sampleManager:addSample("SSKCorona Feature Testing", "HUDs 2 - Percentage Dials", "featureTesting.huds.percentage_dials_logic" )
sampleManager:addSample("SSKCorona Feature Testing", "HUDs 3 - Sliding Meters", "featureTesting.huds.visualmeters_logic" )

-- ==
-- Inputs
-- ==
sampleManager:addSample("SSKCorona Feature Testing", "Inputs - Joystick (Normal)", "featureTesting.inputs.joystick1_logic" )
sampleManager:addSample("SSKCorona Feature Testing", "Inputs - Horizontal Snap (Normal)", "featureTesting.inputs.horizSnap1_logic" )
sampleManager:addSample("SSKCorona Feature Testing", "Inputs - Vertical Snap (Normal)", "featureTesting.inputs.vertSnap1_logic" )
sampleManager:addSample("SSKCorona Feature Testing", "Inputs - Joystick (Virtual)", "featureTesting.inputs.joystick2_logic" )
sampleManager:addSample("SSKCorona Feature Testing", "Inputs - Horizontal Snap (Virtual)", "featureTesting.inputs.horizSnap2_logic" )
sampleManager:addSample("SSKCorona Feature Testing", "Inputs - Vertical Snap (Virtual)", "featureTesting.inputs.vertSnap2_logic" )

-- ==
-- Inputs (Applied)
-- ==
--COMP sampleManager:addSample("SSKCorona Feature Testing", "Inputs Applied - Horizontal Snap", "featureTesting.inputs.applied.horizSnap1_logic" )
--COMP sampleManager:addSample("SSKCorona Feature Testing", "Inputs Applied - Joystick", "featureTesting.inputs.applied.joystick1_logic" )


-- ==
-- Prototyping (Objects)
-- ==
--sampleManager:addSample("SSKCorona Feature Testing", "Sampler Template 1 Test", "featureTesting._templates.template1" )
--sampleManager:addSample("SSKCorona Feature Testing", "Sampler Template 2 Test", "featureTesting._templates.template2" )

-- ==
-- Image Sheet Mgr
-- ==
--EFM sampleManager:addSample("SSKCorona Feature Testing", "Image Sheet Manager", "featureTesting.imageSheets.imgSheetMgr" )

-- ==
-- IO
-- ==
sampleManager:addSample("SSKCorona Feature Testing", "File IO", "featureTesting.io.test1" ) 

-- ==
-- Templates
-- ==
sampleManager:addSample("SSKCorona Feature Testing", "Sampler Template 1 Test", "_templates.template1" )
sampleManager:addSample("SSKCorona Feature Testing", "Sampler Template 2 Test", "_templates.template2" )

if( not enableRandomOpenCloseTesting ) then
	sampleManager:addSample("SSKCorona Feature Testing", "Benchmark Template 1: Operations Per Second Test", "_templates.template3_benchmark_OPS" ) 
	sampleManager:addSample("SSKCorona Feature Testing", "Benchmark Template 2: Operation vs. Operation Test", "_templates.template4_benchmark_OPVS") 
end

-- =============================================
-- Mechanics
-- =============================================
-- ==
-- Camera
-- ==
--COMP sampleManager:addSample("Mechanics - Camera", "#1 - 3 Layer (random objects; fixed Rate)", "mechanics.camera.scrolling1_logic" )
sampleManager:addSample("Mechanics - Camera", "Left-Right Auto-Scroll", "mechanics.camera.lrautoscroll_logic" )
sampleManager:addSample("Mechanics - Camera", "Legend of Zelda Auto-Scroll", "mechanics.camera.zeldascroll_logic" )

-- ==
-- Movement
-- ==
--COMP sampleManager:addSample("Mechanics - Movement", "Linear Movement (L/R/U/D; Buttons)", "mechanics.movement.linearMovement_logic" )
--COMP sampleManager:addSample("Mechanics - Movement", "Step Movement (no Repeat; Buttons)", "mechanics.movement.stepNoRepeatMovement_logic" )
--COMP sampleManager:addSample("Mechanics - Movement", "Step Movement (w/ Repeat; Buttons)", "mechanics.movement.stepwRepeatMovement_logic" )
--COMP sampleManager:addSample("Mechanics - Movement", "Thrust Movement (L/R/U/D; Buttons)", "mechanics.movement.thrustMovement_logic" )
--COMP sampleManager:addSample("Mechanics - Movement", "Asteroids Movement (Buttons)", "mechanics.movement.asteroidsMovement_logic" )

-- ==
-- Platforming
-- ==
sampleManager:addSample("Mechanics - Platforming", "One-Way Platform", "mechanics.platforming.1wayplatform_logic" )

-- =============================================
-- Benchmarks
-- =============================================
if( not enableRandomOpenCloseTesting ) then
	sampleManager:addSample("Benchmarks", "math.sqrt() - Normal : Operations Per Second", "benchmarks.math_sqrt_remote", true ) 
	sampleManager:addSample("Benchmarks", "math.sqrt() - Localized : Operations Per Second", "benchmarks.math_sqrt_local", true ) 
	sampleManager:addSample("Benchmarks", "math.sqrt() - Localized vs. Normal", "benchmarks.math_sqrt_local_vs_remote", true ) 
	sampleManager:addSample("Benchmarks", "ASCII85 Encoding : KB Per Second", "benchmarks.ascii85", true ) 
end

-- =============================================
-- Experiments
-- =============================================
if( not enableRandomOpenCloseTesting ) then
	sampleManager:addSample("Experiments", "Co-Routines", "experiments.coroutineTest", true )
	-- Fix bug with GGCharts (flashes) EFM
	sampleManager:addSample("Experiments", "GGCharts Test#1", "experiments.GlitchGames.test1", true )
	sampleManager:addSample("Experiments", "Proper Classes", "experiments.classes.properclass", true )
end


-- ==
-- Functional & Performance Tests
-- ==
if( not enableRandomOpenCloseTesting ) then
	sampleManager:addSample("Corona Bench", "FT 1: SpriteObject - 1,600 Sprites; 10 Loops", "cbench.focused1.test", true )
	sampleManager:addSample("Corona Bench", "FT 2: SpriteInstance - 1,600 Sprites; 10 Loops", "cbench.focused2.test", true )
	sampleManager:addSample("Corona Bench", "G2G 1: Sprite- Object vs Instance (On-Screen) sprites/s", "cbench.gen2gen1.test", true )
	sampleManager:addSample("Corona Bench", "G2G 2: Sprite- Object vs Instance (Off-Screen) sprites/s", "cbench.gen2gen2.test", true )
	sampleManager:addSample("Corona Bench", "G2G 3: Sprite- Object vs Instance (On-Screen) FPS", "cbench.gen2gen3.test", true )
	sampleManager:addSample("Corona Bench", "G2G 4: Sprite- Object vs Instance (Off-Screen) FPS", "cbench.gen2gen4.test", true )
end


-- =============================================
-- Misc
-- =============================================
