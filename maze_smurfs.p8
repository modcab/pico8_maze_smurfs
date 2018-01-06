pico-8 cartridge // http://www.pico-8.com
version 15
__lua__
-- smurf maze
-- by m0d, based on work by mrben

-- global variable
maze_width = 21  -- width of the maze
maze_height =21  -- heigh of the maze
cell_size = 6  -- size of a cell
maze_width = 10  -- width of the maze
maze_height =10  -- heigh of the maze
cell_size = 12  -- size of a cell
smurf = {
  flip = false
}
color = {
  bg=0,
  maze=7,
  path=8
}

function _init()
  generate_maze()
end

function _update()
  -- print(flr(time(), 1), 0, 0, 7)
    if state < 2 then
        for i=1,speed do
            if state == 0 then
                if btnp(4) then
                    state=1
                end
            end

                if #calls > 0 then
                  submaze = calls[#calls]
                  gen(submaze[1],submaze[2],submaze[3])
                  del(calls,submaze)
                else
                    state=2
                    break
                end
            end

    else
      if (btnp(0)) then
        if (can_move(0, smurf)) then
          delete_smurf()
          smurf.x = smurf.x - cell_size
          smurf.flip = true
          sfx(0)
          if (smurf.x < 0) _init()
        end
      end
      if (btnp(1)) then
        if (can_move(1, smurf)) then
          delete_smurf()
          smurf.x = smurf.x + cell_size
          smurf.flip = false
          sfx(0)
          if (smurf.x > 120) _init()
        end
      end

      if (btnp(2)) then
        if (can_move(2, smurf)) then
          delete_smurf()
          smurf.y = smurf.y - cell_size
          sfx(0)
          if (smurf.y < 0) _init()
        end
      end
      if (btnp(3)) then
        if (can_move(3, smurf)) then
          delete_smurf()
          smurf.y = smurf.y + cell_size
          sfx(0)
          if (smurf.y > 120) _init()
        end
      end
        if (btnp(4)) then
            generate_maze()
        end
    end
    spr(1, smurf.x, smurf.y, 1, 1, smurf.flip)
end

function can_move(btn, smurf)
  local wall = {
    x = 0,
    y = 0
  }
  local foundwall = false
  if (btn == 0) then
    wall.x = smurf.x - 2
    wall.y = smurf.y
    for x = wall.x - 2, wall.x + 2 do
      foundwall = foundwall or (pget(x, wall.y) != color.bg)
    end
  end
  if (btn == 1) then
    wall.x = smurf.x + cell_size - 2
    wall.y = smurf.y
    for x = wall.x - 2, wall.x + 2 do
      foundwall = foundwall or (pget(x, wall.y) != color.bg)
    end
  end
  if (btn == 2) then
    wall.x = smurf.x
    wall.y = smurf.y - 2
    for y = wall.y - 2, wall.y + 2 do
      foundwall = foundwall or (pget(wall.x, y) != color.bg)
    end
  end
  if (btn == 3) then
    wall.x = smurf.x
    wall.y = smurf.y + cell_size - 2
    for y = wall.y - 2, wall.y + 2 do
      foundwall = foundwall or (pget(wall.x, y) != color.bg)
    end
  end
  return not foundwall
end

function delete_smurf()
  rectfill(smurf.x, smurf.y, smurf.x + cell_size - 5, smurf.y + cell_size - 5, color.bg)
end

function gen(r,e,m)
    if r.w > r.h then

        local wall = flr(rnd(r.w-1))+1
        --local wall = flr(r.w/2)
        local door = flr(rnd(r.h))

        local e1
        local e2
        if e.x < r.x+wall then
            e1={x=e.x,y=e.y}
            e2={x=r.x+wall,y=r.y+door}
            m[c2i(e2)]=c2i({x=r.x+wall-1,y=r.y+door})
        else
            e1={x=r.x+wall-1,y=r.y+door}
            e2={x=e.x,y=e.y}
            m[c2i(e1)]=c2i({x=r.x+wall,y=r.y+door})
        end

        if max(r.w-wall,r.h) > 1 then
            add(calls,
                {{x=r.x+wall,y=r.y,
                    w=r.w-wall,h=r.h},
                    e2,
                    m})
        end
        if max(wall,r.h) > 1 then
            add(calls,
                {{x=r.x,y=r.y,
                    w=wall,h=r.h},
                    e1,
                    m})
        end

        -- drawing
        line(px(r,wall),py(r,0),
            px(r,wall),py(r,r.h),
            color.maze)
        line(px(r,wall),py(r,door)+1,
            px(r,wall),py(r,door+1)-1,
            color.bg)
    else

        local wall = flr(rnd(r.h-1))+1
        local door = flr(rnd(r.w))

        local e1
        local e2
        if e.y < r.y+wall then
            e1={x=e.x,y=e.y}
            e2={x=r.x+door,y=r.y+wall}
            m[c2i(e2)]=c2i({x=r.x+door,y=r.y+wall-1})
        else
            e1={x=r.x+door,y=r.y+wall-1}
            e2={x=e.x,y=e.y}
            m[c2i(e1)]=c2i({x=r.x+door,y=r.y+wall})
        end

        if max(r.w,r.h-wall) > 1 then
            add(calls,
                {{x=r.x,y=r.y+wall,
                    w=r.w,h=r.h-wall},
                    e2,
                    m})
        end
        if max(r.w,wall) > 1 then
            add(calls,
                {{x=r.x,y=r.y,
                    w=r.w,h=wall},
                    e1,
                    m})
        end

        -- drawing
        line(px(r,0),py(r,wall),
            px(r,r.w),py(r,wall),
            color.maze)
        line(px(r,door)+1,py(r,wall),
            px(r,door+1)-1,py(r,wall),
            color.bg)
    end
end

function generate_maze()
  rectfill(0,0,127,127,color.bg)

  m={}
  for i=1,maze_width* maze_height do add(m,-1) end

  local rectangle ={x=0,y=0,w=maze_width,h= maze_height }
  rect(px(rectangle,0),py(rectangle,0),
      px(rectangle, rectangle.w),py(rectangle, rectangle.h),
      color.maze)

  local door
  -- create door: 1 - right, 2 - top, 3 - bottom, 0 - left
  which_side = flr(rnd(4))
  -- door at one of the sides.
  if which_side < 2 then
      door = {
        x = maze_width * (which_side % 2),
        y = flr(rnd(maze_height))
      }
      -- print smurf
      smurf.x = door.x * cell_size + 5 * (-1 * (which_side % 2) +1 * ((which_side + 1) % 2))
      smurf.y = door.y * cell_size + 5
      -- spr(1, smurf.x, smurf.y)
      which_side = (which_side + 1) % 2
      door = {
        x = maze_width * (which_side % 2),
        y = flr(rnd(maze_height))
      }
      line(
        px(rectangle, door.x),
        py(rectangle, door.y) + 1,
        px(rectangle, door.x),
        py(rectangle, door.y + 1) - 1,
        color.bg
      )
  -- door at top
  else
      door = {
        x = flr(rnd(maze_width)),
        y = (maze_height - 1) * (which_side % 2)
      }
      -- print smurf
      smurf.x = door.x * cell_size + 5
      smurf.y = door.y * cell_size + 5 + (-1 * (which_side % 2) + 1 * ((which_side + 1) % 2))
      -- spr(1, smurf.x, smurf.y)

      which_side = 2 + (which_side + 1) % 2
      door = {
        x = flr(rnd(maze_width)),
        y = (maze_height - 1) * (which_side % 2)
      }
      line(
        px(rectangle, door.x) + 1,
        py(rectangle, door.y + (which_side % 2)),
        px(rectangle, door.x + 1) - 1,
        py(rectangle, door.y + (which_side % 2)),
          color.bg)

  end

  -- start.
  state = 0

  -- for step by step
  calls={}
  add(calls,{ rectangle, door,m})
  speed=maze_width* maze_height
  -- for path display
  toggle=false
  pos=maze_width*flr(maze_height /2)+flr(maze_width/2)
end

-- place functions
function px(r,v)
    return (r.x+v)* cell_size + (128- cell_size *maze_width)/2 -.5
end

function py(r,v)
    return (r.y+v)* cell_size + (128- cell_size * maze_height)/2 -.5
end

-- coordinate/index functions
function c2i(coord)
    return coord.y*maze_width+coord.x+1
end

function i2c(idx)
    return {x=(idx-1)%maze_width,
        y=flr((idx-1)/maze_width)}
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007777700077777000777770088888800888880000000000088888800000000000000000000000000000000000000000000000000000000000000000
0000000007777777077777770777777788888888888888800888888088f1ff180000000000000000000000000000000000000000000000000000000000000000
00000000077cccc0077cccc0077cccc0888ffff88ffff8808888888888fffff80000000000000000000000000000000000000000000000000000000000000000
0000000000c0cc0000c0cc0000c0cc0088f1ff1881ff1f80888ffff888fffff80000000000000000000000000000000000000000000000000000000000000000
0000000000ccccc000ccccc000ccccc008fffff00fffff8088fffff8083333800000000000000000000000000000000000000000000000000000000000000000
000000000c7777000c7777000c777700073333000033337008f1ff10003333000000000000000000000000000000000000000000000000000000000000000000
00000000007007000007007007007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100002505000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
