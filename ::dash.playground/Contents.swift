/*:
 # //dash
 #### A game for the skilled
 
 //dash _(pronounced 'slash-slash-dash')_ is a _shoot 'em up_ game with simple, but well designed graphics and blazing fast action. It makes use of the Force Touch trackpad like no other of its kind so, to enjoy it at most, please make sure that "Force Click and haptic feedback" is enabled on your machine.
 
  ***
 
 ## Bitty
 ![Bitty](Assets/markup-bitty.png)
This is Bitty. He's the good guy, and you control him. He also blinks a lot. His goal is to defeat the bad guys (his enemies) and nothing else. The more enemies he gets to defeat, the more points you get. To move him, you can either point your mouse to where you want him to aim or use WASD or the arrow keys. To dash, press W or the up arrow. In order to shoot, you can either press the spacebar or click on the trackpad. If you find yourself trapped, you can make a super shot, which can hit all of the enemies on its way. To do so, you can hold the spacebar for one second or do a Force Click on your trackpad. Please note that both kinds of shots have cooldowns, so use them wisely.
 
 ## Enemies
 ![Image containing the kinds of enemies](Assets/markup-enemies.png)
 There are three types of enemies: the regular ones, the strong ones, and the smart ones. All of them appear randomly, with frequencies that increase progressively (every 10 points), and hitting them ends the game. The regular ones follow Bitty, and that's their only skill. The strong enemies need multiple shots to explode, since they can have up to two extra levels of strength. The smart enemies have an eye and thus, can see. That way, they can also shoot Bitty, with projectiles that can't be destroyed in any way, so you _need_ to dodge them away. Strong enemies can be combined with smart enemies.
 
 ## Power-ups
 ![Image containing the kinds of power-ups](Assets/markup-power-ups.png)
 As the game gets harder, you might need some external help. That help can be given in the form of power-ups, which can do two things: make Bitty stronger, allowing him an extra chance after he's hit, or slow down the time for enemies so it's easier to explode them. Power-ups are not cumulative.
 
 ***
 
All sounds were download from [Kenney](https://www.kenney.nl) under the CC0 license.
 
The lightning icon was made by [Dave Gandy](https://www.flaticon.com/authors/dave-gandy) and downloaded from [Flaticon](https://www.flaticon.com/).
*/

import PlaygroundSupport
import CoreGraphics

let initialView = InitialView(frame: CGRect(x: 0, y: 0, width: 800, height: 600))
PlaygroundSupport.PlaygroundPage.current.liveView = initialView
