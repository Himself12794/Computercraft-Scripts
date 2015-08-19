setFreq(5)
while true do
  local x,y,z=gps.locate(5)
  sleep(2)
  local x1,y1,z1=gps.locate(5)
  if x==x1 then
    print('Bore has stopped moving')
    set(false)
  elseif x<x1 then
    set(true)
  end
  sleep(0.01)
end
    
