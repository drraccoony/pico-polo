pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
-- polo recreated in the pico8
-- engine! neato!

-- variables

function _init()
	 player={
	   sp=1,
	   x=59,
	   y=59,
	   w=8,
	   h=8,
	   flp=false,
	   dx=0,
	   dy=0,
	   max_dx=2,
	   max_xy=3,
	   acc=0.3,
	   acc_y=3.4,
	   anim=0,
	   running=false,
	   jumping=false,
	   falling=false,
	   landed=false,
	   sliding=false, 
	 }
	 
	 gravity=0.3
	 friction=0.85
end


-->8
--update and draw

function _update()
		player_update()
		player_animate()
end

function _draw()
		cls()
		map(0,0)
		spr(player.sp,player.x,player.y,1,1,player.flp)
end
-->8
--collisions

function collide_map(obj,dir,flag)
		--obj = table needs x,y,w,h
		--dir = left,right,up,down
		local x=obj.x local y=obj.y
		local w=obj.w local h=obj.h
		
		local x1=0 local y1=0
		local x2=0 local y2=0
		
		if dir=="left" then
				x1=x-1 y1=y
				x2=x   y2=y+h-1
		elseif dir=="right" then
		  x1=x+w   y1=y
		  x2=x+w+1 y2=y+h-1
		elseif dir=="up" then
				x1=x+1   y1=y-1
				x2=x+w-1 y2=y
		elseif dir=="down" then
				x1=x		 y1=y+h
				x2=x+w	y2=y+h
		end
		
		-- pixels to tiles
		x1/=8 y1/=8
		x2/=8 y2/=8
		
		if fget(mget(x1,y1), flag)
		or fget(mget(x1,y2), flag)
		or fget(mget(x2,y1), flag)
		or fget(mget(x2,y2), flag) then
				return true
		else
				return false
		end
end
-->8
--player

function player_update()
		--physics
		player.dy+=gravity
		player.dx*=friction
		--controls
		if btn(⬅️) then
				player.dx-=player.acc
				player.running=true
				player.flp=true
		end
		if btn(➡️) then
			 player.dx+=player.acc
			 player.running=true
			 player.flp=false
		end
		
		--slide
		if player.running
		and not btn(⬅️)
		and not btn(➡️)
		and not player.falling
		and not player.jumping then
				player.running=false
				player.sliding=true
		end
		
		--jump
		if btnp(❎)
		and player.landed then
				player.dy-=player.acc_y
				player.landed=false
				sfx(0)
		end
		
		--check collision up and down
		if player.dy>0 then
				player.falling=true
				player.landed=false
				player.jumping=false
		  
		  --player.dy=limit_speed(player.dy,player.max_dy)
		  
		  if collide_map(player,"down",0) then
		  		player.landed=true
		  		player.falling=false
		  		player.dy=0
		  		player.y-=(player.y+player.h)%8
		  end
		elseif player.dy<0 then
			player.jumping=true
			if collide_map(player,"up",1) then
					player.dy=0
			end
		end
		
		-- check collision left and right
		if player.dx<0 then
				
				--player.dx=limit_speed(player.dx,player.max_dx)
				
				if collide_map(player,"left",1) then
						player.dx=0
				end
		elseif player.dx>0 then
		  if collide_map(player,"right",1) then
		    player.dx=0
		  end
		end
		
		--stop sliding
		if player.sliding then
		  if abs(player.dx)<.2
		  or player.running then
		  		player.dx=0
		  		player.sliding=false
		  end	  
		end

		player.x+=player.dx
		player.y+=player.dy
		
end

function player_animate()
		if player.jumping then
				player.sp=5
		elseif player.falling then
		  player.sp=6
		elseif player.sliding then
		  player.sp=7
		elseif player.running then
		  if time()-player.anim>.05 then
		    player.anim=time()
		    player.sp+=1
		    if player.sp>4 then
		      player.sp=2
		    end
		  end
		  else --player idle
		    player.sp=1
		  
		end     
end

--function limit_speed(num,maximum)
		--		return mid (-maximum,num,maximum)
__gfx__
00000000777777777777777777777777777777777777777777777777777777770000000000000000000000000000000000000000000000000000000000000000
00000000777777777777777777777777777777777700770077777777777777770000000000000000000000000000000000000000000000000000000000000000
00700700770077007700770077007700770077007700770077777777770077000000000000000000000000000000000000000000000000000000000000000000
00077000770077007700770077007700770077007777777777007700770077000000000000000000000000000000000000000000000000000000000000000000
00077000777777777777777777777777777777777777777777007700777777770000000000000000000000000000000000000000000000000000000000000000
00700700777777777777777777777777777777777777777777777777777777770000000000000000000000000000000000000000000000000000000000000000
00000000077007700770770000777000007777000770077007700770077007700000000000000000000000000000000000000000000000000000000000000000
00000000077007700000770000077000007700007700770007700770007700770000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddddd0d00d0dddddddd11d00d0dddddddddd0d00dddddddddddddddddddd00000000000000d000000000000000000000000000000000000000000000000
dddddddd0ddddd0d1ddddddd110dd00dddddddddd00dd0dd00d00d0000d00d000000000000000000000000000000000000000000000000000000000000000000
ddd0dd0000dd0dd0110dddd0110dd0d00dddd0dd0d0dd0dd0d0000d00d0000d00d000000000000d0000000000000000000000000000000000000000000000000
d00d00dd0d00d00d11d0d0dd11d0d00dd0dd0dddd00d0dddddd00dddddddddddddd0000000000ddd000000000000000000000000000000000000000000000000
0dd00d00d00d0d0d1100dd00110d00d00d00d0dd0d00d0dd66d00d6666666666666d00000000d666000000000000000000000000000000000000000000000000
00d0d00d00d000d011ddd00d11d0dd0000dd0ddd00dd0ddd00dddd0000000000000d00000000d000000000000000000000000000000000000000000000000000
0d0000d00d0ddd0d110d0d00110dddd0d00d00dd0dddd0dd00d00d00000000000000000000000000000000000000000000000000000000000000000000000000
d00d0000d0dd0d00110dd0d0110d00dd0d00d0dddd00d0dd00d00d00000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000d00d00000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000dddd00000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000d00d000d0000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000d00d000d0000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000d00d0000d000d0000000d000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000dddd0000d00d0000000d0d00000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000d00d0000dddd0000dddd0d00000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000d00d0000d00d0000d00d0000000000000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dddddddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0dddd0dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d0dd0ddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d00d0dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00dd0ddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d00d00dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d00d0dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d0d00ddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d00dd0dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0dd0dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d00d0ddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d00d0dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00dd0ddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0dddd0dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd00d0dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d0d00ddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d00dd0dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0dd0dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d00d0ddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d00d0dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00dd0ddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0dddd0dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd00d0dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d0d00ddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d00dd0dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d0dd0dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d00d0ddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0d00d0dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00dd0ddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0dddd0dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd00d0dd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d0d00ddd000000000000000000000000000000000000000000000000000000000777777770000000000000000000000000000000000000000000000000000000
d00dd0dd000000000000000000000000000000000000000000000000000000000777777770000000000000000000000000000000000000000000000000000000
0d0dd0dd000000000000000000000000000000000000000000000000000000000770077000000000000000000000000000000000000000000000000000000000
d00d0ddd000000000000000000000000000000000000000000000000000000000770077000000000000000000000000000000000000000000000000000000000
0d00d0dd000000000000000000000000000000000000000000000000000000000777777770000000000000000000000000000000000000000000000000000000
00dd0ddd000000000000000000000000000000000000000000000000000000000777777770000000000000000000000000000000000000000000000000000000
0dddd0dd000000000000000000000000000000000000000000000000000000000077007700000000000000000000000000000000000000000000000000000000
dd00d0dd000000000000000000000000000000000000000000000000000000000077007700000000000000000000000000000000000000000000000000000000
d0d00ddd0000000000000000000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd000000000000000
d00dd0dd0000000000000000000000000000000000d00d0000d00d0000d00d0000d00d0000d00d0000d00d0000d00d0000d00d0000d00d000000000000000000
0d0dd0dd000000000000000000000000000000d00d0000d00d0000d00d0000d00d0000d00d0000d00d0000d00d0000d00d0000d00d0000d00d00000000000000
d00d0ddd00000000000000000000000000000dddddddddddddd00dddddddddddddddddddddddddddddddddddddddddddddd00dddddddddddddd0000000000000
0d00d0dd0000000000000000000000000000d6666666666666d00d66666666666666666666666666666666666666666666d00d6666666666666d000000000000
00dd0ddd0000000000000000000000000000d0000000000000dddd00000000000000000000000000000000000000000000dddd0000000000000d000000000000
0dddd0dd000000000000000000000000000000000000000000d00d00000000000000000000000000000000000000000000d00d00000000000000000000000000
dd00d0dd000000000000000000000000000000000000000000d00d00000000000000000000000000000000000000000000d00d00000000000000000000000000
d0d00ddd000000000000000000000000000000000000000000d00d00000000000000000000000000000000000000000000d00d00000000000000000000000000
d00dd0dd000000000000000000000000000000000000000000dddd00000000000000000000000000000000000000000000dddd00000000000000000000000000
0d0dd0dd000000000000000000000000000000000000000000d00d00000000000000000000000000000000000000000000d00d00000000000000000000000000
d00d0ddd000000000000000000000000000000000000000000d00d00000000000000000000000000000000000000000000d00d00000000000000000000000000
0d00d0dd000000000000000000000000000000000000000000d00d00000000000000000000000000000000000000000000d00d00000000000000000000000000
00dd0ddd000000000000000000000000000000000000000000dddd00000000000000000000000000000000000000000000dddd00000000000000000000000000
0dddd0dd000000000000000000000000000000000000000000d00d00000000000000000000000000000000000000000000d00d00000000000000000000000000
dd00d0dd000000000000000000000000000000000000000000d00d00000000000000000000000000000000000000000000d00d00000000000000000000000000
d0d00ddd000000000000000000000000000000000000000000d00d00000000000000000000000000000000000000000000d00d00000000000000000000000000
d00dd0dd000000000000000000000000000000000000000000dddd00000000000000000000000000000000000000000000dddd00000000000000000000000000
0d0dd0dd00000000000000000d000000000000000000000000d00d00000000000000000000000000000000000000000000d00d00000000000000000000000000
d00d0ddd00000000000000000d000000000000000000000000d00d00000000000000000000000000000000000000000000d00d00000000000000000000000000
0d00d0dd000000000000000000d000d0000000000000000000d00d00000000000000000000000000000000000000000000d00d00000000000000000000000000
00dd0ddd000000000000000000d00d00000000000000000000dddd00000000000000000000000000000000000000000000dddd00000000000000000000000000
0dddd0dd000000000000000000dddd00000000000000000000d00d00000000000000000000000000000000000000000000d00d00000000000000000000000000
dd00d0dd000000000000000000d00d00000000000000000000d00d00000000000000000000000000000000000000000000d00d00000000000000000000000000
d0d00ddd000000000000000000d00d00000000000000000000d00d000000000000000000000000000000000000000000dddddddddddddddddddddddddddddddd
d00dd0dd000000000000000000dddd00000000000000000000dddd0000000000000000000000000000000000000000001ddddddddddddddddddddddddddddddd
0d0dd0dd000000000000000000d00d00000000000000000000d00d000000000000000000000000000000000000000000110dddd0ddd0dd00ddd0dd00ddd0dd00
d00d0ddd000000000000000000d00d00000000000000000000d00d00000000000000000000000000000000000000000011d0d0ddd00d00ddd00d00ddd00d00dd
0d00d0dd000000000000000000d00d00000000000000000000d00d0000000000000000000000000000000000000000001100dd000dd00d000dd00d000dd00d00
00dd0ddd000000000000000000dddd00000000000000000000dddd00000000000000000000000000000000000000000011ddd00d00d0d00d00d0d00d00d0d00d
0dddd0dd000000000000000000d00d00000000000000000000d00d000000000000000000000000000000000000000000110d0d000d0000d00d0000d00d0000d0
dd00d0dd000000000000000000d00d00000000000000000000d00d000000000000000000000000000000000000000000110dd0d0d00d0000d00d0000d00d0000
d0d00ddd000000000000000000d00d0000000000dddddddddddddddd000000000000000000000000000000000000000011d00d0ddd0d00d0dd0d00d0dd0d00d0
d00dd0dd000000000000000000dddd00000000001ddddddddddddddd0000000000000000000000000000000000000000110dd00d0ddddd0d0ddddd0d0ddddd0d
0d0dd0dd000000000000000000d00d0000000000110dddd00dddd0dd0000000000000000000000000000000000000000110dd0d000dd0dd000dd0dd000dd0dd0
d00d0ddd000000000000000000d00d000000000011d0d0ddd0dd0ddd000000000000000000000000000000000000000011d0d00d0d00d00d0d00d00d0d00d00d
0d00d0dd000000000000000000d00d00000000001100dd000d00d0dd0000000000000000000000000000000000000000110d00d0d00d0d0dd00d0d0dd00d0d0d
00dd0ddd000000000000000000dddd000000000011ddd00d00dd0ddd000000000000000000000000000000000000000011d0dd0000d000d000d000d000d000d0
0dddd0dd000000000000000000d00d0000000000110d0d00d00d00dd0000000000000000000000000000000000000000110dddd00d0ddd0d0d0ddd0d0d0ddd0d
dd00d0dd000000000000000000d00d0000000000110dd0d00d00d0dd0000000000000000000000000000000000000000110d00ddd0dd0d00d0dd0d00d0dd0d00
d0d00ddd000000000000000000d00d000000000011d00d0ddd0d00d0dddddddddddddddddddddddddddddddddddddddddd0d00d0dd0d00d0dd0d00d0dd0d00d0
d00dd0dd000000000000000000dddd0000000000110dd00d0ddddd0ddddddddddddddddddddddddddddddddddddddddd0ddddd0d0ddddd0d0ddddd0d0ddddd0d
0d0dd0dd000000000000000000d00d0000000000110dd0d000dd0dd0ddd0dd00ddd0dd00ddd0dd00ddd0dd00ddd0dd0000dd0dd000dd0dd000dd0dd000dd0dd0
d00d0ddd000000000000000000d00d000000000011d0d00d0d00d00dd00d00ddd00d00ddd00d00ddd00d00ddd00d00dd0d00d00d0d00d00d0d00d00d0d00d00d
0d00d0dd000000d00000000000d00d0000000000110d00d0d00d0d0d0dd00d000dd00d000dd00d000dd00d000dd00d00d00d0d0dd00d0d0dd00d0d0dd00d0d0d
00dd0ddd00000d0d0000000000dddd000000000011d0dd0000d000d000d0d00d00d0d00d00d0d00d00d0d00d00d0d00d00d000d000d000d000d000d000d000d0
0dddd0dd00dddd0d0000000000d00d0000000000110dddd00d0ddd0d0d0000d00d0000d00d0000d00d0000d00d0000d00d0ddd0d0d0ddd0d0d0ddd0d0d0ddd0d
dd00d0dd00d00d000000000000d00d0000000000110d00ddd0dd0d00d00d0000d00d0000d00d0000d00d0000d00d0000d0dd0d00d0dd0d00d0dd0d00d0dd0d00
dd0d00d0dddddddddddddddddddddddddddddddddd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0
0ddddd0ddddddddddddddddddddddddddddddddd0ddddd0d0ddddd0d0ddddd0d0ddddd0d0ddddd0d0ddddd0d0ddddd0d0ddddd0d0ddddd0d0ddddd0d0ddddd0d
00dd0dd0ddd0dd00ddd0dd00ddd0dd00ddd0dd0000dd0dd000dd0dd000dd0dd000dd0dd000dd0dd000dd0dd000dd0dd000dd0dd000dd0dd000dd0dd000dd0dd0
0d00d00dd00d00ddd00d00ddd00d00ddd00d00dd0d00d00d0d00d00d0d00d00d0d00d00d0d00d00d0d00d00d0d00d00d0d00d00d0d00d00d0d00d00d0d00d00d
d00d0d0d0dd00d000dd00d000dd00d000dd00d00d00d0d0dd00d0d0dd00d0d0dd00d0d0dd00d0d0dd00d0d0dd00d0d0dd00d0d0dd00d0d0dd00d0d0dd00d0d0d
00d000d000d0d00d00d0d00d00d0d00d00d0d00d00d000d000d000d000d000d000d000d000d000d000d000d000d000d000d000d000d000d000d000d000d000d0
0d0ddd0d0d0000d00d0000d00d0000d00d0000d00d0ddd0d0d0ddd0d0d0ddd0d0d0ddd0d0d0ddd0d0d0ddd0d0d0ddd0d0d0ddd0d0d0ddd0d0d0ddd0d0d0ddd0d
d0dd0d00d00d0000d00d0000d00d0000d00d0000d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00
dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0
0ddddd0d0ddddd0d0ddddd0d0ddddd0d0ddddd0d0ddddd0d0ddddd0d0ddddd0d0ddddd0d0ddddd0d0ddddd0d0ddddd0d0ddddd0d0ddddd0d0ddddd0d0ddddd0d
00dd0dd000dd0dd000dd0dd000dd0dd000dd0dd000dd0dd000dd0dd000dd0dd000dd0dd000dd0dd000dd0dd000dd0dd000dd0dd000dd0dd000dd0dd000dd0dd0
0d00d00d0d00d00d0d00d00d0d00d00d0d00d00d0d00d00d0d00d00d0d00d00d0d00d00d0d00d00d0d00d00d0d00d00d0d00d00d0d00d00d0d00d00d0d00d00d
d00d0d0dd00d0d0dd00d0d0dd00d0d0dd00d0d0dd00d0d0dd00d0d0dd00d0d0dd00d0d0dd00d0d0dd00d0d0dd00d0d0dd00d0d0dd00d0d0dd00d0d0dd00d0d0d
00d000d000d000d000d000d000d000d000d000d000d000d000d000d000d000d000d000d000d000d000d000d000d000d000d000d000d000d000d000d000d000d0
0d0ddd0d0d0ddd0d0d0ddd0d0d0ddd0d0d0ddd0d0d0ddd0d0d0ddd0d0d0ddd0d0d0ddd0d0d0ddd0d0d0ddd0d0d0ddd0d0d0ddd0d0d0ddd0d0d0ddd0d0d0ddd0d
d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00d0dd0d00

__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000302030301010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4500000049474647474747474647480000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4500000000005600000000005600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4500005700005600000000005600000000570000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4500005600005600000000004240404040404040404400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4500005600424400000000004341414141414141414500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4558005600434140404040404141414141414141414500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4140404040414141414141414141414141414141414500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4141414141414141414141414141414141414141414500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4141414141414141414141414141414141414141414140400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0002000010050100501005010050110501205014050170501b0502005027050270502705000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00040000106500a6300762006610066101460013600136001b5002a500170001700018000190000c6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300000d6500d6500d6500360000000036500365003650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
