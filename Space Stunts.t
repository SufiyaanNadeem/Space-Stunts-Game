%Set Screen Size & Background
setscreen ("graphics:max;max")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Menu, GameScreen, and Music Variables

%Starting Titles
var title : int := Pic.FileNew ("PLAY.jpg")
var done : int := 1

%Game Screen
var GameScreen : int := Pic.FileNew ("background12.jpg")
var spriteLVL1 : int := Sprite.New (GameScreen)
Sprite.SetHeight (spriteLVL1, 1)

%Game Over
var EndGame : int := Pic.FileNew ("EXIT-RESTART1.jpg")
Pic.SetTransparentColour (EndGame, green)
var spriteOver : int := Sprite.New (EndGame)
Sprite.SetHeight (spriteOver, 8)
Sprite.SetPosition (spriteOver, 0, 0, false)
var lastFont := Font.New ("Agency FB Bold:100:bold")

%Menu Buttons
var mx, my, mbutton : int
Mouse.ButtonChoose ("multibutton") %for two-button functionality
var leave : boolean := false
%Menu Variables
var Continue : boolean := false

%Fuel
var minusfuel : real := 0

%Music
%This process plays main soundtrack
process BackMusic
    Music.PlayFile ("soundtrack.mp3")
end BackMusic
%This process plays rocket thrust
process ThrustMusic
    Music.PlayFile ("thrust.wav")
end ThrustMusic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Rocket Variables

%Constant for 36 different Rockets
const rotation : int := 36
%Variable for Keys
var chars : array char of boolean

%Right Facing Rockets
var rocket : array 0 .. 35 of int
var spriteRocket : array 0 .. 35 of int     %Sprites for Rockets

%Left Facing Rockets
var rocketDown : array 0 .. 35 of int
var spriteRocketDown : array 0 .. 35 of int     %Sprites for Rockets

%Angle * 10 of Rockets
var angle : int
var astry : int := 694
%Rocket position (x,y) / Direction of Rocket (dx,dy)
var x, y, dx, dy : real
var gx, gy : real
gx := 0
gy := 0
%Boost Const
const KEY_SPACE : char := chr (32)
%Boolean for Checking which Sprite to use
var up : boolean := true


%Setting Right Facing Rocket's picture, transparency, and sprite
rocket (0) := Pic.FileNew ("rocket_right.gif")
Pic.SetTransparentColour (rocket (0), white)
rocket (18) := Pic.FileNew ("rocket_left.gif")
Pic.SetTransparentColour (rocket (18), white)
rocket (9) := Pic.FileNew ("rocket_up.gif")
Pic.SetTransparentColour (rocket (9), white)
rocket (27) := Pic.FileNew ("rocket_down.gif")
Pic.SetTransparentColour (rocket (27), white)

spriteRocket (0) := Sprite.New (rocket (0))
Sprite.SetHeight (spriteRocket (0), 3)
spriteRocket (18) := Sprite.New (rocket (18))
Sprite.SetHeight (spriteRocket (18), 3)
spriteRocket (27) := Sprite.New (rocket (27))
Sprite.SetHeight (spriteRocket (27), 3)
spriteRocket (9) := Sprite.New (rocket (9))
Sprite.SetHeight (spriteRocket (9), 3)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Obstacle Variables

%Planet Variables (lvl 1)
var planet1 : int := Pic.FileNew ("red_planet111.gif")
Pic.SetTransparentColour (planet1, black)
var planet2 : int := Pic.FileNew ("blue_planet111.gif")
Pic.SetTransparentColour (planet2, black)
var planet3 : int := Pic.FileNew ("brown_planet.gif")
Pic.SetTransparentColour (planet3, black)

var redplanet1 : int := Sprite.New (planet1)
Sprite.SetHeight (redplanet1, 6)
var blueplanet1 : int := Sprite.New (planet2)
Sprite.SetHeight (blueplanet1, 6)
var brownplanet1 : int := Sprite.New (planet3)
Sprite.SetHeight (brownplanet1, 6)

%Alien Variables (lvl 2)
var UFO1 : int := Pic.FileNew ("UFO2.gif")
var UFO2 : int := Pic.FileNew ("UFO3.gif")
var spriteUFO1 : int := Sprite.New (UFO1)
Sprite.SetHeight (spriteUFO1, 6)
var spriteUFO2 : int := Sprite.New (UFO1)
Sprite.SetHeight (spriteUFO2, 6)
var spriteUFO3 : int := Sprite.New (UFO2)
Sprite.SetHeight (spriteUFO3, 6)
var UFOdown : boolean := false
var UFOleft : boolean := false
var UFO1y : int := round (gy + 50)
var UFO3x : int := round (gx + 3300)

%Laser Variables
var loopCounter : int := 0 %For Laser
var laser : int := Pic.FileNew ("laser2.gif")
var spriteUFOLaser : int := Sprite.New (laser)
Sprite.SetHeight (spriteUFOLaser, 5)

%Game Complete Vars
var flag : int := Pic.FileNew ("finish line.jpg")
var spriteFlag : int := Sprite.New (flag)
Sprite.SetHeight (spriteFlag, 7)

%Crash Explosion
var explosion1 : int := Pic.FileNew ("explosion5.jpg")
Pic.SetTransparentColour (explosion1, white)
var explosion2 : int := Pic.FileNew ("explosion4.jpg")
Pic.SetTransparentColour (explosion2, white)
var explosion3 : int := Pic.FileNew ("explosion3.jpg")
Pic.SetTransparentColour (explosion3, white)
var explosion4 : int := Pic.FileNew ("explosion2.jpg")
Pic.SetTransparentColour (explosion4, white)
var explosion5 : int := Pic.FileNew ("explosion1.jpg")
Pic.SetTransparentColour (explosion5, white)
var spriteExplosion : array 1 .. 5 of int
spriteExplosion (1) := Sprite.New (explosion1)
spriteExplosion (2) := Sprite.New (explosion2)
spriteExplosion (3) := Sprite.New (explosion3)
spriteExplosion (4) := Sprite.New (explosion4)
spriteExplosion (5) := Sprite.New (explosion5)

var crash : boolean := false
var lives : int := 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Points Variables
var points : int := 0
var coin : int := Pic.FileNew ("coin.gif")
var freeCoin : array 1 .. 20 of boolean
for i : 1 .. 20
    freeCoin (i) := false
end for
var spriteCoin : array 1 .. 20 of int
for i : 1 .. 20
    spriteCoin (i) := Sprite.New (coin)
    Sprite.SetHeight (spriteCoin (i), 6)
end for

%CheckPoint Variables
var checkPoint : int := -1
var checkPointColour : int := 0
var astroCheck : int := Pic.FileNew ("checkPoint.gif")
var spriteAstronaut : int := Sprite.New (astroCheck)
Sprite.SetHeight (spriteAstronaut, 6)


%Vars for top stats
var scoreFont : int := Font.New ("Agency FB Bold:40:bold")
var topRocket : int := Pic.FileNew ("top_rocket.gif")
var scoreRocket : int := Sprite.New (topRocket)
Sprite.SetHeight (scoreRocket, 6)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Music and Title Screen Fade In
fork BackMusic
Pic.DrawSpecial (title, 0, 0, picCopy, picFadeIn, 1000)

%Menu Loop for Mouse Input
loop
    Mouse.Where (mx, my, mbutton)     %Mouse Location

    Pic.Draw (title, 0, 0, picCopy)

    if mx >= 670 and mx <= 1180 and my >= 240 and my <= 340 then
	if mbutton = 1 then
	    for i : 1 .. 5
		Pic.Draw (title, 0, 0, picCopy)
		delay (100)
		Draw.ThickLine (720, 255, 1130, 255, 5, blue)
		delay (100)
		if i = 5 then
		    Continue := true
		    exit
		end if
	    end for
	    exit
	end if
	delay (300)
	Draw.ThickLine (720, 255, 1130, 255, 5, blue)
	delay (300)
    end if

end loop

%Game Screen and Thrust Music Fade In
if Continue = true then
    fork ThrustMusic
    Sprite.SetPosition (spriteLVL1, round (gx), round (gy), false)
    Sprite.Show (spriteLVL1)
    View.Update
end if
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CheckPoint 1
procedure lvl1
    %Obstacles
    Sprite.SetPosition (spriteLVL1, round (gx), round (gy), false)
    Sprite.Show (spriteLVL1)
    Sprite.SetPosition (redplanet1, round (gx + 670), round (gy + 535), false)
    Sprite.Show (redplanet1)
    Sprite.SetPosition (blueplanet1, round (gx + 810), round (gy + 70), false)
    Sprite.Show (blueplanet1)
    Sprite.SetPosition (brownplanet1, round (gx + 1200), round (gy + 250), false)
    Sprite.Show (brownplanet1)
    %Coin Positioning
    if freeCoin (1) not= true then
	Sprite.SetPosition (spriteCoin (1), round (gx + 700), round (gy + 400), true)
    end if
    if freeCoin (2) not= true then
	Sprite.SetPosition (spriteCoin (2), round (gx + 850), round (gy + 400), true)
    end if
    if freeCoin (3) not= true then
	Sprite.SetPosition (spriteCoin (3), round (gx + 1000), round (gy + 400), true)
    end if
    if freeCoin (4) not= true then
	Sprite.SetPosition (spriteCoin (4), round (gx + 1000), round (gy + 600), true)
    end if
    if freeCoin (5) not= true then
	Sprite.SetPosition (spriteCoin (5), round (gx + 1300), round (gy + 600), true)
    end if
    if freeCoin (6) not= true then
	Sprite.SetPosition (spriteCoin (6), round (gx + 1600), round (gy + 600), true)
    end if
    if freeCoin (7) not= true then
	Sprite.SetPosition (spriteCoin (7), round (gx + 1900), round (gy + 400), true)
    end if
end lvl1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CheckPoint 2
proc lvl2
    if UFO1y <= round (gy + 30) then
	UFOdown := false
    elsif UFO1y >= round (gy + 795 - 220) then
	UFOdown := true
    end if
    if UFOdown = true then
	UFO1y -= 3
    else
	UFO1y += 3
    end if

    if round (UFO3x + 200 + gx) <= round (gx + 3300) then
	UFOleft := false
    elsif round (UFO3x + 200 + gx) >= round (gx + 3800) then
	UFOleft := true
    end if

    if UFOleft = true then
	UFO3x -= 5
	Sprite.Hide (spriteUFOLaser)
    elsif UFOleft = false then
	UFO3x += 5
	Sprite.SetPosition (spriteUFOLaser, round (gx + 187 + UFO3x), round (gy + 50), false)
	Sprite.Show (spriteUFOLaser)
    end if

    Sprite.SetPosition (spriteUFO1, round (gx + 2400), round (gy + 50 + UFO1y), false)
    Sprite.Show (spriteUFO1)
    Sprite.SetPosition (spriteUFO2, round (gx + 2800), round (gy + 795 - 220 + -1 * UFO1y), false)
    Sprite.Show (spriteUFO2)
    Sprite.SetPosition (spriteUFO3, round (gx + 100 + UFO3x), round (gy + 795 - 110), false)
    Sprite.Show (spriteUFO3)

    if freeCoin (8) not= true then
	Sprite.SetPosition (spriteCoin (8), round (gx + 2760), round (gy + 400), true)
    end if
    if freeCoin (9) not= true then
	Sprite.SetPosition (spriteCoin (9), round (gx + 2760), round (gy + 600), true)
    end if
    if freeCoin (10) not= true then
	Sprite.SetPosition (spriteCoin (10), round (gx + 2760), round (gy + 200), true)
    end if
    if freeCoin (11) not= true then
	Sprite.SetPosition (spriteCoin (11), round (gx + 3160), round (gy + 200), true)
    end if
    if freeCoin (12) not= true then
	Sprite.SetPosition (spriteCoin (12), round (gx + 3160), round (gy + 400), true)
    end if
    if freeCoin (13) not= true then
	Sprite.SetPosition (spriteCoin (13), round (gx + 3160), round (gy + 600), true)
    end if
    if freeCoin (14) not= true then
	Sprite.SetPosition (spriteCoin (14), round (gx + 3360), round (gy + 500), true)
    end if
    if freeCoin (15) not= true then
	Sprite.SetPosition (spriteCoin (15), round (gx + 3360), round (gy + 300), true)
    end if
    if freeCoin (16) not= true then
	Sprite.SetPosition (spriteCoin (16), round (gx + 3560), round (gy + 400), true)
    end if
    if freeCoin (17) not= true then
	Sprite.SetPosition (spriteCoin (17), round (gx + 3560), round (gy + 600), true)
    end if
    if freeCoin (18) not= true then
	Sprite.SetPosition (spriteCoin (18), round (gx + 3560), round (gy + 200), true)
    end if
    if freeCoin (19) not= true then
	Sprite.SetPosition (spriteCoin (19), round (gx + 3760), round (gy + 400), true)
    end if
    if freeCoin (20) not= true then
	Sprite.SetPosition (spriteCoin (20), round (gx + 3960), round (gy + 400), true)
    end if

    %Coin Showing
    for i : 1 .. 20
	if freeCoin (i) not= true then
	    Sprite.Show (spriteCoin (i))
	end if
    end for
end lvl2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Coin Collisions for Points
proc CoinCollision1
    %Approaching Coins from left
    if angle = 0 then
	if round (x + 150) >= round (gx + 700) and round (x) <= round (gx + 700 + 30) and
		round (y + 60) >= round (gy + 400) and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (1) not= true then
		freeCoin (1) := true
		Sprite.Free (spriteCoin (1))
		points += 10
	    end if

	elsif round (x + 150) >= round (gx + 850) and round (x) <= round (gx +
		850 + 30) and round (y + 60) >= round (gy + 400) and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (2) not= true then
		Sprite.Free (spriteCoin (2))
		points += 10
		freeCoin (2) := true
	    end if

	elsif round (x + 150) >= round (gx + 1000) and round (x) <= round (gx + 1000 + 30) and round (y +
		60) >= round (gy + 400) and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (3) not= true then
		Sprite.Free (spriteCoin (3))
		points += 10
		freeCoin (3) := true
	    end if

	elsif round (x + 150) >= round (gx + 1000) and round (x) <= round (gx + 1000 + 30) and round (y +
		60) >= round (gy + 600) and round (y) <= round (gy + 600 + 30) then
	    if freeCoin (4) not= true then
		Sprite.Free (spriteCoin (4))
		points += 10
		freeCoin (4) := true
	    end if

	elsif round (x + 150) >= round (gx + 1300) and round (x) <= round (gx + 1300 + 30) and round (y +
		60) >= round (gy + 600) and round (y) <= round (gy + 600 + 30) then
	    if freeCoin (5) not= true then
		Sprite.Free (spriteCoin (5))
		points += 10
		freeCoin (5) := true
	    end if

	elsif round (x + 150) >= round (gx + 1600) and round (x) <= round (gx + 1600 + 30) and round (y +
		60) >= round (gy + 600) and round (y) <= round (gy + 600 + 30) then
	    if freeCoin (6) not= true then
		Sprite.Free (spriteCoin (6))
		points += 10
		freeCoin (6) := true
	    end if
	elsif round (x + 150) >= round (gx + 1900) and round (x) <= round (gx + 1900 + 30) and round (y +
		60) >= round (gy + 400) and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (7) not= true then
		Sprite.Free (spriteCoin (7))
		points += 10
		freeCoin (7) := true
	    end if
	elsif round (x + 150) >= round (gx + 2760) and round (x) <= round (gx + 2760 + 30) and round (y +
		60) >= round (gy + 400) and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (8) not= true then
		Sprite.Free (spriteCoin (8))
		points += 10
		freeCoin (8) := true
	    end if
	elsif round (x + 150) >= round (gx + 2760) and round (x) <= round (gx + 2760 + 30) and round (y +
		60) >= round (gy + 600) and round (y) <= round (gy + 600 + 30) then
	    if freeCoin (9) not= true then
		Sprite.Free (spriteCoin (9))
		points += 10
		freeCoin (9) := true
	    end if
	elsif round (x + 150) >= round (gx + 2760) and round (x) <= round (gx + 2760 + 30) and round (y +
		60) >= round (gy + 200) and round (y) <= round (gy + 200 + 30) then
	    if freeCoin (10) not= true then
		Sprite.Free (spriteCoin (10))
		points += 10
		freeCoin (10) := true
	    end if
	elsif round (x + 150) >= round (gx + 3160) and round (x) <= round (gx + 3160 + 30) and round (y +
		60) >= round (gy + 200) and round (y) <= round (gy + 200 + 30) then
	    if freeCoin (11) not= true then
		Sprite.Free (spriteCoin (11))
		points += 10
		freeCoin (11) := true
	    end if
	elsif round (x + 150) >= round (gx + 3160) and round (x) <= round (gx + 3160 + 30) and round (y +
		60) >= round (gy + 400) and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (12) not= true then
		Sprite.Free (spriteCoin (12))
		points += 10
		freeCoin (12) := true
	    end if
	elsif round (x + 150) >= round (gx + 3160) and round (x) <= round (gx + 3160 + 30) and round (y +
		60) >= round (gy + 600) and round (y) <= round (gy + 600 + 30) then
	    if freeCoin (13) not= true then
		Sprite.Free (spriteCoin (13))
		points += 10
		freeCoin (13) := true
	    end if
	elsif round (x + 150) >= round (gx + 3360) and round (x) <= round (gx + 3360 + 30) and round (y +
		60) >= round (gy + 500) and round (y) <= round (gy + 500 + 30) then
	    if freeCoin (14) not= true then
		Sprite.Free (spriteCoin (14))
		points += 10
		freeCoin (14) := true
	    end if
	elsif round (x + 150) >= round (gx + 3360) and round (x) <= round (gx + 3360 + 30) and round (y +
		60) >= round (gy + 300) and round (y) <= round (gy + 300 + 30) then
	    if freeCoin (15) not= true then
		Sprite.Free (spriteCoin (15))
		points += 10
		freeCoin (15) := true
	    end if
	elsif round (x + 150) >= round (gx + 3560) and round (x) <= round (gx + 3560 + 30) and round (y +
		60) >= round (gy + 400) and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (16) not= true then
		Sprite.Free (spriteCoin (16))
		points += 10
		freeCoin (16) := true
	    end if
	elsif round (x + 150) >= round (gx + 3560) and round (x) <= round (gx + 3560 + 30) and round (y +
		60) >= round (gy + 600) and round (y) <= round (gy + 600 + 30) then
	    if freeCoin (17) not= true then
		Sprite.Free (spriteCoin (17))
		points += 10
		freeCoin (17) := true
	    end if
	elsif round (x + 150) >= round (gx + 3560) and round (x) <= round (gx + 3560 + 30) and round (y +
		60) >= round (gy + 200) and round (y) <= round (gy + 200 + 30) then
	    if freeCoin (18) not= true then
		Sprite.Free (spriteCoin (18))
		points += 10
		freeCoin (18) := true
	    end if
	elsif round (x + 150) >= round (gx + 3760) and round (x) <= round (gx + 3760 + 30) and round (y +
		60) >= round (gy + 400) and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (19) not= true then
		Sprite.Free (spriteCoin (19))
		points += 10
		freeCoin (19) := true
	    end if
	elsif round (x + 150) >= round (gx + 3960) and round (x) <= round (gx + 3960 + 30) and round (y +
		60) >= round (gy + 400) and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (19) not= true then
		Sprite.Free (spriteCoin (20))
		points += 10
		freeCoin (20) := true
	    end if
	end if
    end if

    %Approaching Coins from Right
    if angle = 18 then
	if round (x) <= round (gx + 700 + 30) and round (x + 150) >= round (gx + 700) and round (y + 60) >= round (gy + 400)
		and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (1) not= true then
		freeCoin (1) := true
		Sprite.Free (spriteCoin (1))
		points += 10
	    end if
	elsif round (x) <= round (gx + 850 + 30) and round (x + 150) >= round (gx + 850)
		and round (y + 60) >= round (gy + 400) and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (2) not= true then
		freeCoin (2) := true
		Sprite.Free (spriteCoin (2))
		points += 10
	    end if
	elsif round (x) <= round (gx + 1000 + 30) and round (x + 150) >= round (gx + 1000)
		and round (y + 60) >= round (gy + 400) and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (3) not= true then
		freeCoin (3) := true
		Sprite.Free (spriteCoin (3))
		points += 10
	    end if
	elsif round (x) <= round (gx + 1000 + 30) and round (x + 150) >= round (gx + 1000)
		and round (y + 60) >= round (gy + 600) and round (y) <= round (gy + 600 + 30) then
	    if freeCoin (4) not= true then
		freeCoin (4) := true
		Sprite.Free (spriteCoin (4))
		points += 10
	    end if
	elsif round (x) <= round (gx + 1300 + 30) and round (x + 150) >= round (gx + 1300)
		and round (y + 60) >= round (gy + 600) and round (y) <= round (gy + 600 + 30) then
	    if freeCoin (5) not= true then
		freeCoin (5) := true
		Sprite.Free (spriteCoin (5))
		points += 10
	    end if
	elsif round (x) <= round (gx + 1600 + 30) and round (x + 150) >= round (gx + 1600)
		and round (y + 60) >= round (gy + 600) and round (y) <= round (gy + 600 + 30) then
	    if freeCoin (6) not= true then
		freeCoin (6) := true
		Sprite.Free (spriteCoin (6))
		points += 10
	    end if
	elsif round (x) <= round (gx + 1900 + 30) and round (x + 150) >= round (gx + 1900)
		and round (y + 60) >= round (gy + 400) and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (7) not= true then
		freeCoin (7) := true
		Sprite.Free (spriteCoin (7))
		points += 10
	    end if
	elsif round (x) <= round (gx + 2760 + 30) and round (x + 150) >= round (gx + 2760)
		and round (y + 60) >= round (gy + 400) and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (8) not= true then
		freeCoin (8) := true
		Sprite.Free (spriteCoin (8))
		points += 10
	    end if
	elsif round (x) <= round (gx + 2760 + 30) and round (x + 150) >= round (gx + 2760)
		and round (y + 60) >= round (gy + 600) and round (y) <= round (gy + 600 + 30) then
	    if freeCoin (9) not= true then
		freeCoin (9) := true
		Sprite.Free (spriteCoin (9))
		points += 10
	    end if
	elsif round (x) <= round (gx + 2760 + 30) and round (x + 150) >= round (gx + 2760)
		and round (y + 60) >= round (gy + 200) and round (y) <= round (gy + 200 + 30) then
	    if freeCoin (10) not= true then
		freeCoin (10) := true
		Sprite.Free (spriteCoin (10))
		points += 10
	    end if
	elsif round (x) <= round (gx + 3160 + 30) and round (x + 150) >= round (gx + 3160)
		and round (y + 60) >= round (gy + 200) and round (y) <= round (gy + 200 + 30) then
	    if freeCoin (11) not= true then
		freeCoin (11) := true
		Sprite.Free (spriteCoin (11))
		points += 10
	    end if
	elsif round (x) <= round (gx + 3160 + 30) and round (x + 150) >= round (gx + 3160)
		and round (y + 60) >= round (gy + 400) and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (12) not= true then
		freeCoin (12) := true
		Sprite.Free (spriteCoin (12))
		points += 10
	    end if
	elsif round (x) <= round (gx + 3160 + 30) and round (x + 150) >= round (gx + 3160)
		and round (y + 60) >= round (gy + 600) and round (y) <= round (gy + 600 + 30) then
	    if freeCoin (13) not= true then
		freeCoin (13) := true
		Sprite.Free (spriteCoin (13))
		points += 10
	    end if
	elsif round (x) <= round (gx + 3360 + 30) and round (x + 150) >= round (gx + 3360)
		and round (y + 60) >= round (gy + 500) and round (y) <= round (gy + 500 + 30) then
	    if freeCoin (14) not= true then
		freeCoin (14) := true
		Sprite.Free (spriteCoin (14))
		points += 10
	    end if
	elsif round (x) <= round (gx + 3360 + 30) and round (x + 150) >= round (gx + 3360)
		and round (y + 60) >= round (gy + 300) and round (y) <= round (gy + 300 + 30) then
	    if freeCoin (15) not= true then
		freeCoin (15) := true
		Sprite.Free (spriteCoin (15))
		points += 10
	    end if
	elsif round (x) <= round (gx + 3560 + 30) and round (x + 150) >= round (gx + 3560)
		and round (y + 60) >= round (gy + 400) and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (16) not= true then
		freeCoin (16) := true
		Sprite.Free (spriteCoin (16))
		points += 10
	    end if
	elsif round (x) <= round (gx + 3560 + 30) and round (x + 150) >= round (gx + 3560)
		and round (y + 60) >= round (gy + 600) and round (y) <= round (gy + 600 + 30) then
	    if freeCoin (17) not= true then
		freeCoin (17) := true
		Sprite.Free (spriteCoin (17))
		points += 10
	    end if
	elsif round (x) <= round (gx + 3560 + 30) and round (x + 150) >= round (gx + 3560)
		and round (y + 60) >= round (gy + 200) and round (y) <= round (gy + 200 + 30) then
	    if freeCoin (18) not= true then
		freeCoin (18) := true
		Sprite.Free (spriteCoin (18))
		points += 10
	    end if
	elsif round (x) <= round (gx + 3760 + 30) and round (x + 150) >= round (gx + 3760)
		and round (y + 60) >= round (gy + 400) and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (19) not= true then
		freeCoin (19) := true
		Sprite.Free (spriteCoin (19))
		points += 10
	    end if
	elsif round (x) <= round (gx + 3960 + 30) and round (x + 150) >= round (gx + 3960)
		and round (y + 60) >= round (gy + 400) and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (20) not= true then
		freeCoin (20) := true
		Sprite.Free (spriteCoin (20))
		points += 10
	    end if
	end if
    end if

    %Approaching Coins from Bottom
    if angle = 9 then
	if round (x + 60) >= round (gx + 700) and round (x) <= round (gx + 700 + 30) and round (y + 150) >= round (gy + 400)
		and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (1) not= true then
		freeCoin (1) := true
		Sprite.Free (spriteCoin (1))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 850) and round (x) <= round (gx + 850 + 30) and round (y + 150) >= round (gy + 400)
		and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (2) not= true then
		freeCoin (2) := true
		Sprite.Free (spriteCoin (2))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 1000) and round (x) <= round (gx + 1000 + 30)
		and round (y + 150) >= round (gy + 400) and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (3) not= true then
		freeCoin (3) := true
		Sprite.Free (spriteCoin (3))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 1000) and round (x) <= round (gx + 1000 + 30)
		and round (y + 150) >= round (gy + 600) and round (y) <= round (gy + 600 + 30) then
	    if freeCoin (4) not= true then
		freeCoin (4) := true
		Sprite.Free (spriteCoin (4))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 1300) and round (x) <= round (gx + 1300 + 30)
		and round (y + 150) >= round (gy + 600) and round (y) <= round (gy + 600 + 30) then
	    if freeCoin (5) not= true then
		freeCoin (5) := true
		Sprite.Free (spriteCoin (5))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 1600) and round (x) <= round (gx + 1600 + 30)
		and round (y + 150) >= round (gy + 600) and round (y) <= round (gy + 600 + 30) then
	    if freeCoin (6) not= true then
		freeCoin (6) := true
		Sprite.Free (spriteCoin (6))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 1900) and round (x) <= round (gx + 1900 + 30)
		and round (y + 150) >= round (gy + 400) and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (7) not= true then
		freeCoin (7) := true
		Sprite.Free (spriteCoin (7))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 2760) and round (x) <= round (gx + 2760 + 30)
		and round (y + 150) >= round (gy + 400) and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (8) not= true then
		freeCoin (8) := true
		Sprite.Free (spriteCoin (8))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 2760) and round (x) <= round (gx + 2760 + 30)
		and round (y + 150) >= round (gy + 600) and round (y) <= round (gy + 600 + 30) then
	    if freeCoin (9) not= true then
		freeCoin (9) := true
		Sprite.Free (spriteCoin (9))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 2760) and round (x) <= round (gx + 2760 + 30)
		and round (y + 150) >= round (gy + 200) and round (y) <= round (gy + 200 + 30) then
	    if freeCoin (10) not= true then
		freeCoin (10) := true
		Sprite.Free (spriteCoin (10))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 3160) and round (x) <= round (gx + 3160 + 30)
		and round (y + 150) >= round (gy + 200) and round (y) <= round (gy + 200 + 30) then
	    if freeCoin (11) not= true then
		freeCoin (11) := true
		Sprite.Free (spriteCoin (11))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 3160) and round (x) <= round (gx + 3160 + 30)
		and round (y + 150) >= round (gy + 400) and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (12) not= true then
		freeCoin (12) := true
		Sprite.Free (spriteCoin (12))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 3160) and round (x) <= round (gx + 3160 + 30)
		and round (y + 150) >= round (gy + 600) and round (y) <= round (gy + 600 + 30) then
	    if freeCoin (13) not= true then
		freeCoin (13) := true
		Sprite.Free (spriteCoin (13))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 3360) and round (x) <= round (gx + 3360 + 30)
		and round (y + 150) >= round (gy + 500) and round (y) <= round (gy + 500 + 30) then
	    if freeCoin (14) not= true then
		freeCoin (14) := true
		Sprite.Free (spriteCoin (14))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 3360) and round (x) <= round (gx + 3360 + 30)
		and round (y + 150) >= round (gy + 300) and round (y) <= round (gy + 300 + 30) then
	    if freeCoin (15) not= true then
		freeCoin (15) := true
		Sprite.Free (spriteCoin (15))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 3560) and round (x) <= round (gx + 3560 + 30)
		and round (y + 150) >= round (gy + 400) and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (16) not= true then
		freeCoin (16) := true
		Sprite.Free (spriteCoin (16))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 3560) and round (x) <= round (gx + 3560 + 30)
		and round (y + 150) >= round (gy + 600) and round (y) <= round (gy + 600 + 30) then
	    if freeCoin (17) not= true then
		freeCoin (17) := true
		Sprite.Free (spriteCoin (17))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 3560) and round (x) <= round (gx + 3560 + 30)
		and round (y + 150) >= round (gy + 200) and round (y) <= round (gy + 200 + 30) then
	    if freeCoin (18) not= true then
		freeCoin (18) := true
		Sprite.Free (spriteCoin (18))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 3760) and round (x) <= round (gx + 3760 + 30)
		and round (y + 150) >= round (gy + 400) and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (19) not= true then
		freeCoin (19) := true
		Sprite.Free (spriteCoin (19))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 3960) and round (x) <= round (gx + 3960 + 30)
		and round (y + 150) >= round (gy + 400) and round (y) <= round (gy + 400 + 30) then
	    if freeCoin (20) not= true then
		freeCoin (20) := true
		Sprite.Free (spriteCoin (20))
		points += 10
	    end if
	end if
    end if

    %Approaching Coin from Above
    if angle = 27 then
	if round (x + 60) >= round (gx + 700) and round (x) <= round (gx + 700 + 30) and round (y) <= round (gy + 400 + 30)
		and round (y + 150) >= round (gy + 400) then
	    if freeCoin (1) not= true then
		freeCoin (1) := true
		Sprite.Free (spriteCoin (1))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 850) and round (x) <= round (gx + 850 + 30) and
		round (y) <= round (gy + 400 + 30) and round (y + 150) >= round (gy + 400) then
	    if freeCoin (2) not= true then
		freeCoin (2) := true
		Sprite.Free (spriteCoin (2))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 1000) and round (x) <= round (gx + 1000 + 30)
		and round (y) <= round (gy + 400 + 30) and round (y + 150) >= round (gy + 400) then
	    if freeCoin (3) not= true then
		freeCoin (3) := true
		Sprite.Free (spriteCoin (3))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 1000) and round (x) <= round (gx + 1000 + 30)
		and round (y) <= round (gy + 600 + 30) and round (y + 150) >= round (gy + 600) then
	    if freeCoin (4) not= true then
		freeCoin (4) := true
		Sprite.Free (spriteCoin (4))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 1300) and round (x) <= round (gx + 1300 + 30)
		and round (y) <= round (gy + 600 + 30) and round (y + 150) >= round (gy + 600) then
	    if freeCoin (5) not= true then
		freeCoin (5) := true
		Sprite.Free (spriteCoin (5))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 1600) and round (x) <= round (gx + 1600 + 30)
		and round (y) <= round (gy + 600 + 30) and round (y + 150) >= round (gy + 600) then
	    if freeCoin (6) not= true then
		freeCoin (6) := true
		Sprite.Free (spriteCoin (6))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 1900) and round (x) <= round (gx + 1900 + 30)
		and round (y) <= round (gy + 400 + 30) and round (y + 150) >= round (gy + 400) then
	    if freeCoin (7) not= true then
		freeCoin (7) := true
		Sprite.Free (spriteCoin (7))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 2760) and round (x) <= round (gx + 2760 + 30)
		and round (y) <= round (gy + 400 + 30) and round (y + 150) >= round (gy + 400) then
	    if freeCoin (8) not= true then
		freeCoin (8) := true
		Sprite.Free (spriteCoin (8))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 2760) and round (x) <= round (gx + 2760 + 30)
		and round (y) <= round (gy + 600 + 30) and round (y + 150) >= round (gy + 600) then
	    if freeCoin (9) not= true then
		freeCoin (9) := true
		Sprite.Free (spriteCoin (9))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 2760) and round (x) <= round (gx + 2760 + 30)
		and round (y) <= round (gy + 200 + 30) and round (y + 150) >= round (gy + 200) then
	    if freeCoin (10) not= true then
		freeCoin (10) := true
		Sprite.Free (spriteCoin (10))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 3160) and round (x) <= round (gx + 3160 + 30)
		and round (y) <= round (gy + 200 + 30) and round (y + 150) >= round (gy + 200) then
	    if freeCoin (11) not= true then
		freeCoin (11) := true
		Sprite.Free (spriteCoin (11))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 3160) and round (x) <= round (gx + 3160 + 30)
		and round (y) <= round (gy + 400 + 30) and round (y + 150) >= round (gy + 400) then
	    if freeCoin (12) not= true then
		freeCoin (12) := true
		Sprite.Free (spriteCoin (12))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 3160) and round (x) <= round (gx + 3160 + 30)
		and round (y) <= round (gy + 600 + 30) and round (y + 150) >= round (gy + 600) then
	    if freeCoin (13) not= true then
		freeCoin (13) := true
		Sprite.Free (spriteCoin (13))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 3360) and round (x) <= round (gx + 3360 + 30)
		and round (y) <= round (gy + 500 + 30) and round (y + 150) >= round (gy + 500) then
	    if freeCoin (14) not= true then
		freeCoin (14) := true
		Sprite.Free (spriteCoin (14))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 3360) and round (x) <= round (gx + 3360 + 30)
		and round (y) <= round (gy + 300 + 30) and round (y + 150) >= round (gy + 300) then
	    if freeCoin (15) not= true then
		freeCoin (15) := true
		Sprite.Free (spriteCoin (15))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 3360) and round (x) <= round (gx + 3360 + 30)
		and round (y) <= round (gy + 300 + 30) and round (y + 150) >= round (gy + 300) then
	    if freeCoin (16) not= true then
		freeCoin (16) := true
		Sprite.Free (spriteCoin (16))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 3560) and round (x) <= round (gx + 3560 + 30)
		and round (y) <= round (gy + 600 + 30) and round (y + 150) >= round (gy + 600) then
	    if freeCoin (17) not= true then
		freeCoin (17) := true
		Sprite.Free (spriteCoin (17))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 3560) and round (x) <= round (gx + 3560 + 30)
		and round (y) <= round (gy + 200 + 30) and round (y + 150) >= round (gy + 200) then
	    if freeCoin (18) not= true then
		freeCoin (18) := true
		Sprite.Free (spriteCoin (18))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 3760) and round (x) <= round (gx + 3760 + 30)
		and round (y) <= round (gy + 400 + 30) and round (y + 150) >= round (gy + 400) then
	    if freeCoin (19) not= true then
		freeCoin (19) := true
		Sprite.Free (spriteCoin (19))
		points += 10
	    end if
	elsif round (x + 60) >= round (gx + 3960) and round (x) <= round (gx + 3960 + 30)
		and round (y) <= round (gy + 400 + 30) and round (y + 150) >= round (gy + 400) then
	    if freeCoin (19) not= true then
		freeCoin (19) := true
		Sprite.Free (spriteCoin (19))
		points += 10
	    end if
	end if
    end if
end CoinCollision1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Check Point Display and Detection
proc CheckPoint
    Sprite.SetPosition (spriteAstronaut, round (gx + 2200), round (gy + 795 - 100), true)
    Sprite.Show (spriteAstronaut)
    Draw.ThickLine (round (gx + 2200), round (gy + 795 - 160), round (gx + 2200), round (gy + 40), 5, checkPointColour)
end CheckPoint

proc CheckPointsCollision
    CheckPoint
    if angle = 0 then
	if round (x + 150) >= round (gx + 2200) then
	    checkPoint := -1900
	    checkPointColour := 40
	end if
    end if
end CheckPointsCollision

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Stats on Top
proc topStats
    Font.Draw (realstr (points, 10), round (maxx / 2 - 100), round (maxy - 50), scoreFont, 47)
    Sprite.SetPosition (scoreRocket, 20, maxy - 55, false)
    Sprite.Show (scoreRocket)
    Font.Draw ("x", round (150), round (maxy - 50), scoreFont, 47)
    Font.Draw (realstr (lives, 10), round (80), round (maxy - 50), scoreFont, 47)
end topStats

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Displaying the Rocket

%Procedure that Shows Sprite of Rocket
procedure drawRocket
    Sprite.SetPosition (spriteRocket (angle), round (x), round (y), false)
    Sprite.Show (spriteRocket (angle))
    View.Update
end drawRocket

%Input Keys for the Rotation
procedure rocketRotation
    Input.KeyDown (chars)

    %Rotates to face Right
    if chars (KEY_RIGHT_ARROW) or angle = 0 then
	angle := 0
	if chars (KEY_SPACE) then
	    x += dx * 2
	    if round (gx + 8000) not= 1514 and round (gx + 8000) not= 1515 then
		gx -= dx * 3
	    end if
	else
	    x += dx
	    if round (gx + 8000) not= 1514 and round (gx + 8000) not= 1515 then
		gx -= dx
	    end if
	end if
    end if

    %Rotates to face Left
    if chars (KEY_LEFT_ARROW) or angle = 18 then   %rotate if dow
	angle := 18

	if chars (KEY_SPACE) then
	    x += dx * 2
	    if round (gx) not= -1 and round (gx) not= 0 then
		gx -= dx * 3
	    end if
	else
	    x += dx
	    if round (gx) not= -1 and round (gx) not= 0 then
		gx -= dx
	    end if
	end if
    end if

    %Rotates to face Up
    if chars (KEY_UP_ARROW) or angle = 9 then
	angle := 9
	if chars (KEY_SPACE) then
	    y += dy * 2
	    if round (gy + 795) >= 745 and round (gx + 795) <= 746 then
		gy -= dy * 3
	    end if
	else
	    y += dy
	    if round (gy + 795) >= 745 and round (gx + 795) <= 746 then
		gy -= dy
	    end if
	end if
    end if

    %Rotates to face Down
    if chars (KEY_DOWN_ARROW) or angle = 27 then
	angle := 27
	if chars (KEY_SPACE) then
	    y += dy * 2
	    if round (gy) <= 1 then
	    else
		gy += dy * 3
	    end if
	else
	    y += dy
	    if round (gy) <= 1 then
	    else
		gy += dy
	    end if
	end if
    end if

    %Limits for Rocket
    if x <= 0 then
	angle := 0
    end if
    if x >= gx + 8000 then
	angle := 18
    end if

    %Moving only rocket when limits are touched for the background
    if angle = 0 and round (gx) >= 0 and round (gx) <= 1 and angle = 0 then
	gx -= 1
    end if
    if angle = 18 and round (gx + 8000) >= 1514 and round (gx + 8000) <= 1516 then
	gx += 1
    end if
    if angle = 9 and round (gy) >= 0 and round (gy) <= 1 then
	gy -= 1
    end if
    if angle = 27 and round (gy + 795) >= 740 and round (gx + 795) <= 746 then
	gy += 1
    end if

    %Determines direction of the Rocket
    dx := cosd (angle * 10)
    dy := sind (angle * 10)

    %Calling for Procedures to show LVLs and Rocket
    lvl1
    lvl2
    drawRocket

    %Hide Rocket,Don't free since rocket needs to be stored
    Sprite.Hide (spriteRocket (angle))
end rocketRotation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Collisions

%When the Rocket Crashes into something, this proc will blow it up
procedure crashCollision
    if crash = true then
	Sprite.Hide (spriteRocket (angle))
	for i : 1 .. 5
	    Sprite.SetHeight (spriteExplosion (i), 4)
	    if angle = 0 then
		Sprite.SetPosition (spriteExplosion (i), round (x + 75), round (y + 30), true)
	    elsif angle = 18 then
		Sprite.SetPosition (spriteExplosion (i), round (x + 75), round (y + 30), true)
	    elsif angle = 9 then
		Sprite.SetPosition (spriteExplosion (i), round (x + 30), round (y + 75), true)
	    elsif angle = 27 then
		Sprite.SetPosition (spriteExplosion (i), round (x + 30), round (y + 75), true)
	    end if
	    Sprite.Show (spriteExplosion (i))
	    delay (30)
	    Sprite.Hide (spriteExplosion (i))
	end for
	angle := 0
	x := -150
	y := round (maxy / 2)
	gx := checkPoint
	gy := -1
	crash := false
    end if
end crashCollision

%Asteroid Collision Detection
procedure asteroidCollision
    if round (y) <= round (gy + 40) then
	crash := true
	lives -= 1
    end if
    if round (y + 150) >= round (gy + 795 - 40) then
	crash := true
	lives -= 1
    end if
end asteroidCollision


%Checkpoint 1 Planet Collision Detection- All sides
procedure PlanetCollision1
    if angle = 0 then
	if round (x + 150) >= round (gx + 670) and round (x) <= round (gx + 670 + 146) and round (y + 60) >= round (gy + 535)
		and round (y) <= round (gy + 535 + 147) or round (x + 150) >= round (gx +
		835) and round (x) <= round (gx +
		835 + 123) and round (y + 60) >= round (gy + 70) and round (y) <= round (gy + 70 + 148) or round (x + 150) >= round (gx + 1200)
		and round (x) <= round (gx + 1200 + 331) and round (y +
		60) >= round (gy + 250) and round (y) <=
		round (gy + 250 + 200) then
	    crash := true
	    lives -= 1
	end if
    end if
    if angle = 18 then
	if round (x) <= round (gx + 670 + 146) and round (x + 150) >= round (gx + 670) and round (y + 60) >= round (gy + 535)
		and round (y) <= round (gy + 535 + 147) or round (x) <= round (gx + 835 + 123) and round (x + 150) >= round (gx + 835) and round (y + 60) >= round (gy +
		70) and
		round (y) <= round (gy + 70 + 148) or round (x) <= round (gx + 1200 + 331) and round (x + 150) >= round (gx + 1200) and round (y + 60) >= round (gy + 250)
		and round (y) <= round (gy + 250 + 200) then
	    crash := true
	    lives -= 1
	end if
    end if
    if angle = 9 then
	if round (x + 60) >= round (gx + 670) and round (x) <= round (gx + 670 + 146) and round (y + 150) >= round (gy + 535) and round (y) <= round (gy + 535 + 147) or round (x + 60) >=
		round (gx +
		835)
		and round (x) <= round (gx + 835 +
		123) and round (y + 150) >= round (gy + 70) and
		round (y) <= round (gy + 70 + 148) or round (x + 60) >= round (gx + 1200) and round (x) <= round (gx + 1200 + 331) and round (y + 150) >= round (gy + 250)
		and round (y) <= round (gy + 250 + 200) then
	    crash := true
	    lives -= 1
	end if
    end if
    if angle = 27 then
	if round (x + 60) >= round (gx + 670) and round (x) <= round (gx + 670 + 146) and round (y) <= round (gy + 535 + 147) and round (y + 150) >= round (gy + 535) or round (x + 60) >=
		round (gx + 835) and round (x) <= round (gx + 835 +
		123) and round (y) <= round (gy + 70 + 148) and
		round (y + 150) >= round (gy + 70) or round (x + 60) >= round (gx + 1200) and round (x) <= round (gx + 1200 + 331) and round (y) <= round (gy + 250 + 200) and round (y + 150) >=
		round (gy + 250) then
	    crash := true
	    lives -= 1
	end if
    end if

end PlanetCollision1

%Checkpoint 1 UFO Collision Detection- All sides
proc UFOCollision
    if angle = 0 then
	if round (x + 150) >= round (gx + 2400) and round (x) <= round (gx + 2400 + 300) and round (y + 60) >= round (gy + 50 + UFO1y)
		and round (y) <= round (gy + 50 + UFO1y + 202) or round (x + 150) >= round (gx +
		2800) and round (x) <= round (gx +
		835 + 300) and round (y + 60) >= round (gy + 795 - 220 + -1 * UFO1y) and round (y) <= round (gy + 795 - 220 + -1 * UFO1y + 202) or round (x + 150) >= round (gx + gx + 100 + UFO3x)
		and round (x) <= round (gx + 100 + UFO3x + 200) and round (y +
		60) >= round (gy + 795 - 110) and round (y) <=
		round (gy + 795 - 110 + 80) then
	    crash := true
	    lives -= 1
	end if
    end if
    if UFOleft = false then
	if angle = 0 then
	    if round (x + 150) >= round (gx + 187 + UFO3x) and round (x) <= round (gx + 187 + UFO3x + 25) then
		crash := true
		lives -= 1
	    end if
	end if
	if angle = 18 then
	    if round (x) <= round (gx + 187 + UFO3x+25) and round (x + 150) >= round (gx + 187 + UFO3x) then
		crash := true
		lives -= 1
	    end if
	end if
    end if
    if angle = 18 then
	if round (x) <= round (gx + 2400 + 300) and round (x + 150) >= round (gx + 2400) and round (y + 60) >= round (gy + 50 + UFO1y)
		and round (y) <= round (gy + 50 + UFO1y + 202) or round (x) <= round (gx + 2800 + 300) and round (x + 150) >= round (gx + 2800) and round (y + 60) >= round (gy + 795 - 220 + -1 *
		UFO1y) and
		round (y) <= round (gy + +795 - 220 + -1 * UFO1y + 202) or round (x) <= round (gx + 100 + UFO3x + 200) and round (x + 150) >= round (gx + 100 + UFO3x) and round (y + 60) >=
		round (gy
		+ 795 - 110)
		and round (y) <= round (gy + 795 - 100 + 82) then
	    crash := true
	    lives -= 1
	end if
    end if
    if angle = 9 then
	if round (x + 60) >= round (gx + 2400) and round (x) <= round (gx + 2400 + 300) and round (y + 150) >= round (gy + 50 + UFO1y) and round (y) <= round (gy + 50 + UFO1y + 202) or round (x +
		60) >=
		round (gx +
		2800)
		and round (x) <= round (gx + 2800 +
		300) and round (y + 150) >= round (gy + 795 - 220 + -1 * UFO1y) and
		round (y) <= round (gy + +795 - 220 + -1 * UFO1y + 202) or round (x + 60) >= round (gx + 100 + UFO3x) and round (x) <= round (gx + 100 + UFO3x + 200) and round (y + 150) >=
		round (gy
		+ 795 - 110)
		and round (y) <= round (gy + 795 - 110 + 82) then
	    crash := true
	    lives -= 1
	end if
    end if
    if angle = 27 then
	if round (x + 60) >= round (gx + 2400) and round (x) <= round (gx + 2400 + 300) and round (y) <= round (gy + 50 + UFO1y + 202) and round (y + 150) >= round (gy + 50 + UFO1y + 202) or round (x
		+ 60) >=
		round (gx + 2800) and round (x) <= round (gx + 2800 +
		300) and round (y) <= round (gy + 795 - 220 + -1 * UFO1y + 202) and
		round (y + 150) >= round (gy + 795 - 220 + -1 * UFO1y) or round (x + 60) >= round (gx + 100 + UFO3x) and round (x) <= round (gx + 100 + UFO3x + 200) and round (y) <= round (gy + 795 -
		110 + 82) and round (y + 150) >=
		round (gy + 795 - 110) then
	    crash := true
	    lives -= 1
	end if
    end if
end UFOCollision

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Procedures for End Game Experience
proc GameOver
    Sprite.Show (spriteOver)
    Font.Draw (realstr (points, 10), round (550), round (250), lastFont, 47)
end GameOver
proc GameOverCollision
    Sprite.SetPosition (spriteFlag, round (gx + 4100), round (gy + 40), false)
    Sprite.Show (spriteFlag)
    if angle = 0 then
	if round (x + 150) >= round (gx + 4100) then
	    GameOver
	    lives := 0
	end if
    end if
end GameOverCollision

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Setting Initial Angle,Coordinates, and direction of Rocket
angle := 0
x := -150
y := round (maxy / 2)
gx := checkPoint
gy := -1
dx := 0
dy := 0

%Loop for putting together game using all Procedures
loop
    if lives <= 0 then
	GameOver
    else
	rocketRotation
	asteroidCollision
	PlanetCollision1
	UFOCollision
	CoinCollision1
	topStats
	CheckPointsCollision
	crashCollision
	GameOverCollision
    end if
end loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
