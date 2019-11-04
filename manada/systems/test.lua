local class = require('manada.exts.middleclass')

local Test = class( 'Test' )

function Test:initialize( params )

    self._testStr = "This is test print"

end

function Test:testPrint()

    print(self._testStr)

end

return Test