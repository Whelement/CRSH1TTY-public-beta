```
  .oooooo.   ooooooooo.    .oooooo..o ooooo   ooooo   .o  ooooooooooooo ooooooooooooo oooooo   oooo 
 d8P'  `Y8b  `888   `Y88. d8P'    `Y8 `888'   `888' o888  8'   888   `8 8'   888   `8  `888.   .8'  
888           888   .d88' Y88bo.       888     888   888       888           888        `888. .8'   
888           888ooo88P'   `"Y8888o.   888ooooo888   888       888           888         `888.8' 
888           888`88b.         `"Y88b  888     888   888       888           888          `888'  
`88b    ooo   888  `88b.  oo     .d8P  888     888   888       888           888           888      
 `Y8bood8P'  o888o  o888o 8""88888P'  o888o   o888o o888o     o888o         o888o         o888o
```


# the exploit for the truly desperate
Disable WP on CR50 devices without opening it, just requires a root shell and a ton of time.

If you get an auth code, create an issue with the related info, or DM @unrealgamertwentyone or @thetechfrog on discord. if we get enough info, we might be able to make this a lot faster. 

# Instructions:

When in doubt, just use fast.sh

please use vt2 instead of a shim.

If you have wifi, run `curl -Ls https://raw.githubusercontent.com/Whelement/CRSH1TTY-public-beta/main/fast.sh | bash`

To build a shim with the script, download [https://github.com/MercuryWorkshop/sh1mmer/tree/beautifulworld](https://github.com/MercuryWorkshop/sh1mmer/tree/beautifulworld), unzip the file if you downloaded it that way, then run go to sh1mmer/wax/sh1mmer_legacy/root/usr/sbin, download your script of choice from this repo, and replace the file already in the sbin folder with the one you downloaded (make sure it's named `factory_install.sh`), then run wax_legacy.sh in sh1mmer/wax

We're not making a web builder, we're not smart enough for that. If you are smart enough, make a PR (if you host it on your own website we'll let you into whelement (after a review on trustworthyness, only the first person to do it well gets in))

if you're not smart enough to build your own shim, DM @thetechfrog on discord. Don't be persistent or spammy, I'll get you a shim eventually. Be sure to mention your board when asking for a shim.

# Disclaimer: 

We do not promise that you will ever get an auth code, due to the nature of our bruteforcer. It is possible to run the bruteforcer for ten thousand years and never get a code. We also don't promise that the script even works. It does not include symbols, which may be present in your auth code. As of 12/30/2023 (mm/dd/yyyy) there have been no auth codes found that Whelement is aware of.

Please criticise our exploit. We know it sucks, but if you know how to make it better, please share. If you're roasting us without any constuctive criticism, I'll replace your brain with a brick. Thank you!

# Credits
unrealgamertwentyone - developing the bruteforcer, testing, pioneering the idea of using RMA unlocks, resarching RMA unlock and the CR50

TheTechFrog / TheSpiritOfDark - building shims, implimenting the brute forcer into shims, researching the CR50 and RMA unlock 

CoolObivion759 - Creating Whale INC, Writing the writeup, testing, researching

Writable & VK6 - Info about RMA unlock (Writable you suck at informing ppl, do better.)

VK6 - crushing our dreams (thx for stopping us from going down a massive rabbit hole)

# Too much free time? Read the writeup!

## Written by CoolOblivion759

### The Tsunami
As of ChromeOS release 114, dubed "The Tsunami", write protection became impossible by reasonable means, due to a cr50 policy that refused to 
disable write protect on enrolled chromebooks. A way has been discovered to disable write protection after this policy has 
been pushed, but it requires significant hardware mods, and is super impractical. There has to be some other way, right?

### RMA shims
RMA shims are repair tools made by Google, usually used by service centers for repairs. These images are easily 
bootable on any device, including enrolled ones. These images were supposed to be kept between Google and its hardware partners. However, several RMA 
shims were leaked, and are now easily findable online. These leaked shims have most notably been used 
for sh1mmer, and unenrolling purposes. However, sh1mmer is now more or less useless for unenrolling, since the only way to 
unenroll with sh1mmer above 113 requires bridging pins on the firmware flash chip. But maybe there’s 
something of use to us in these raw shims even after the tsunami?

### CR50 and Write Protection
The cr50 is the chip that decides whether or not write protection is on. 
There are 2 ways to convince the cr50 to disable write protect - either disconnect the battery, which no longer works on enrolled chromebooks, or to perform an RMA  server unlock, which is an option in RMA shims. 
However, this requires a special 8-character code. Normally, only very special people are supposed to have that code. 
Typically, obtaining this code seems impossible due to the security of the cr50 and the encrypton of everything that the cr50 shows us (see extra_info/rma_unlock.png). But theres nothing stopping us from just guessing. 
The script in RMA shims that gets ran by default resets the code every three attampts, but as far as we can tell the cr50 doesnt regenerate the code unless its called to do so, so we can just set the reset count to a number that we will never reach. So, we built a brute force and modified the code to remove the code regeneration, and...

We still haven't gotten a code lmao

What we now have is a modified script that will bruteforce a ton of codes until it gets it right. It then performs an RMA unlock and disables write protect. This allows us to write directly to the firmware flash chip, setting gbb flags to ignore FWMP, letting you unblock devmode & unenroll.

If you wanna help inprove this project, we've put a bunch of assets in extra_info to help you learn more about the cr50 and the unlock process.

