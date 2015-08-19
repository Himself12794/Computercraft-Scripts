while true do
print('pulsing on')
rs.setOutput('top', true)
sleep(1)
print('pulsing off')
rs.setOutput('top', false)
print('waiting')
sleep(8)
end
