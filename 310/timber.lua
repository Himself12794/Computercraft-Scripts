turtle.dig()
turtle.forward()

function cLeft(n)
	turtle.turnLeft()
	r=turtle.compare(n)
	turtle.turnRight()
	return r
end
function layer()
	turtle.dig()
	turtle.turnLeft()
	turtle.dig()
	turtle.forward()
	turtle.turnRight()
	turtle.dig()
	turtle.forward()
	turtle.turnLeft()
	turtle.turnLeft()
	turtle.digUp()
	turtle.up()
end

-- function up(s)
	-- turtle.select(s)
	-- u = turtle.compare()
	-- print(u)
	-- return u
-- end
spot=0

while turtle.detect() do
	layer()
	spot=spot+1
	sleep(0.1)
end
for i=1, spot do
	turtle.down()
end
