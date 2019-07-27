## Need Help or want to follow my releases? Join the Support Discord: https://discord.gg/UbsYrKx


Copy from ikt's description:

InversePower tries to counteract the fact that GTA V cuts off power when your 
car starts gliding. This allows for a more realistic and less annoying driving 
experience. Drifting and slides are easier to maintain and adjust.

This mod is inspired by Drift Assist by InfamousSabre and works similarly. The
big difference is that speed is used as a negative feedback to make cars not
accelerate too much and swerve out of control at higher speeds.


## Configuration
This plugin won't work if engine power or torque are modified other scripts.

InversePower-FiveM uses Convars defined in your Server Config File ( e.g. server.cfg ) to define values, current convars are:

### InversePower_DefaultLevel
Default level for the Angle at which InversePower starts adding Power/Torque

0 = Default, 25°

1 = Sensitive, 15°

2 = Drift, 10°

3 = Disabled, 180°

Default: 0

### InversePower_toggleKey
sets the key thats used to change the drift mode, if set to 0, changing it via key will be disabled. 

default: 166

### InversePower_DrawDebug
Draws Debug Values on screen if set to "true"

Default: "false"

### InversePower_Power & InversePower_Torque
Power gives the engine more potential. Torque is effective for making the
wheels spin more. If a handling.meta is used with high grip, lower Torque.

Default = 100 and 80

### InversePower_Angle
The higher this value, the higher the adjustment will be when the car 
is sliding at a big angle.

Default: 350

### InversePower_Speed
The higher this value, the higher the adjustment will be when the car 
is sliding at a low speed.

Default: 200



If no Convars are set, InversePower-FiveM will fall back to defaults
