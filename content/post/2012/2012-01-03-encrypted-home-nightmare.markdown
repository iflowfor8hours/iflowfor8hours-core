+++
layout = "single"
title = "Encrypted Home Directory Nightmare"
date = "2012-01-03"

+++

This post probably won't help anyone in a similar situation, but I have to vent anyway.

I ran out of space on my / partition recently, I foolishly made it only
10gigs, and I my /opt dir was huge. My HDD was due for replacement
anyway, so I got an ssd, and started out by pulling the old drive and installing crunchbang linux on the new one. Everything went fine. 

My home partition on the old drive was encrypted with ecryptfs. I didn't
realize at that point that _I didn't remember the password for it_. I never noticed because every time I logged in, everything was decrypted and it never crossed my mind. My intention was to hook both drives up to my desktop and transfer my home over. 

My desktop is a windows box, so I figured there would be some complications that I would get around using a livecd. I tried every common password I've ever used, and couldn't get my partition decrypted. No matter I thought, I would just boot back up and transfer everything over the network. This is where things went significantly downhill. 

I tried to boot my old drive, but something had happened to grub. The kernel I normally use was gone, and there was only the liquorix 3.0.4 kernel there. I tried to boot it and failed. I was getting a kernel panic right after I selected my kernel. It couldn't find my disk. I googled around and found out that the error I was seeing is most commonly associated with missing sata ahci drivers. It was totally possible that they were missing, as I had never used this kernel before, and I don't know why it was the only one showing up.

I panicked and immediately thought that I should throw tools at the problem. I booted with super grub disk, and ran the automated grub repair tools. I tried to boot again and only then realized that it had replaced grub2 with grub, and couldn't find my kernels. Ugh. I tried super grub2 disk, but unetbootin was being a bastard and wouldn't install it on my thumbdrive. I started getting really frustrated with the thought that my homedir was encrypted, I couldn't unecrypt it, and my data was gone forever. 

I banged on the problem late into the night, trying different techniques to get my grub fixed. I booted from a livecd and attempted to install a new kernel using chroot. This appeared to work, but when I rebooted, the kernel didn't appear. 

At that point, I realized that I didn't know anything about grub2. I was looking for menu.lst, trying random update-grub commands to no avail. I tried all kinds of stuff from the grub command line that didn't work, and just got more and more angry. I went to sleep super pissed off, sweating that about 2 weeks worth of stuff was lost. I realized that my backup policy sucked. I needed to rsync more frequently, but that wouldn't help me until I recovered the data. 

Today I woke up and consciously didn't think about it. I just got all the other things on my Saturday list of crap done first. Toilet is fixed, car is clean, house is cleaner, brisket is in the oven, and I bought booze, which in GA is important to do on Saturday, because "package stores" are closed by law on Sundays. 

I sat down with a calm and level head, and realized that I probably won't be able to guess what my password was. I set it while I was living in Spain a year ago, and was using a totally different scheme of passwords. I gave up on that. I realized that my only chance was to build a mental model of how grub2 works, and fix it. 

I started digging into the grub2 docs, and looking at the configuration files. Every time I ran grub-update, it would find the new kernel I installed but it never appeared in my grub.cfg. I started looking at the /etc/grub directory from my livecd booted machine and realized that there were plusses and minuses next my original kernel version and my newly installed generic kernel. Grub was trying to make a cute little submenu for them under the title "previous linux versions", and for some reason it wasn't happening. I fixed the config file so there were no submenus or anything weird and ran update-grub again. My kernel appeared. Nice.

I rebooted and my familiar desktop appeared. WOOT. My data is now rsyncing to the new drive. I have some questions about ecryptfs, and how it works, because I don't know where my disk is getting the decrypt key from when I login, but I'm much less stressed and that's good. 

The moral of the story I think as usual, is not to try and fix things you don't understand when you're angry and frustrated. Throwing tools you don't understand at a problem is almost NEVER the right way to do anything.
