require("rttlib")

-- Get our Lua TC
tc = rtt.getTC()

-- Get the deployer
depl = tc:getPeer("deployer")

-- Start deploying and connecting

depl.import("controller-youbot")
depl.loadComponent("controller","Controller")
depl.loadComponent("areadetection","Areadetection")
depl.loadComponent("teleop","Teleop")
-- Deployment Exercise: Add a supervisor Lua component

-- Data Flow connections
cp=rtt.Variable("ConnPolicy")
cp.transport=3 -- 3 is ROS -- NOTE: set transport back to zero for local connections ! 

cp.name_id="/cmdvel" -- topic name
depl:stream("controller.cmdvel", cp )
depl:stream("teleop.cmdvel", cp )

cp.name_id="/youbot"
depl:stream("controller.curlocation", cp)
depl:stream("areadetection.curlocation", cp)

cp.name_id="/joy"
depl:stream("teleop.joystick",cp)

-- Data Flow Exercise: 
--  Connect the events of areadetection to the supervisor

-- Only start in case no youbot is present:
loadComponent("youbot","NoBot")
cp.transport = 0
depl:connect("youbot.cmdvel","controller.cmdvel", cp);
depl:connect("youbot.cmdvel","teleop.cmdvel", cp);
depl:connect("youbot.youbot","controller.curlocation", cp);
depl:connect("youbot.youbot","controller.curlocation", cp);

-- Deployment Exercise:
--  Configure or start the necessary components: 
--  areadetection, nobot (if applicable), supervisor 
--  Remember that the supervisor has the authority to
--  control (start/stop) most components.

-- Deployment Exercise:
--  Visualise the current setup with the rtt_dot_service
