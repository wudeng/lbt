local BT = require("behaviour_tree")
local Parallel = require("parallel")
local Sequence = require("sequence")
local Const = require("const")

local Attack = require("example.attack")
local Flee =   require("example.flee")
local HpCheck = require("example.hp_check")

local robot = {id = 1, hp = 100}
-- 高优先级打断低优先级
local root = Parallel(
    Const.FAIL_ONE,
    Const.SUCCESS_ALL,
    Sequence(
        HpCheck(50),
        Flee(5)
    ),
    Attack(20)
)

-- print(inspect(root))

local Tick = BT.new(robot, root)
-- print(inspect(Tick))
for i = 1, 30 do
    print("================", i)
    if i == 5 then
        print(">>>>>>>> hp == 10")
        robot.hp = 10
    end
    if i == 18 then
        print(">>>>>>>> hp == 100")
        robot.hp = 100
    end
    Tick:tick()
end
